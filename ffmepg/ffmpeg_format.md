# ffmpeg 的封装格式处理

- [ffmpeg 的封装格式处理](#ffmpeg-的封装格式处理)
  - [封装格式](#封装格式)
  - [查看 ffmpeg 支持的封装格式](#查看-ffmpeg-支持的封装格式)
  - [libavformat 库](#libavformat-库)
    - [主要的 API](#主要的-api)
    - [解复用](#解复用)
      - [打开媒体文件](#打开媒体文件)
      - [关闭打开的文件](#关闭打开的文件)
      - [读取打开的文件](#读取打开的文件)
    - [复用](#复用)
      - [设置复用上下文](#设置复用上下文)
      - [写入文件头](#写入文件头)
      - [写入数据包](#写入数据包)
      - [完成文件](#完成文件)
  - [参考](#参考)

## 封装格式

封装格式(container format)可以看作是编码流(音频流、视频流等)数据的一层外壳，将编码后的数据存储于此封装格式的文件之内。封装又称容器。

不同封装格式适用于不同的场合，支持的编码格式不一样，

ffmpeg 处理封装格式的流程：打开输入文件、打开输出文件、从输入文件读取编码帧、向输出文件写入编码帧。

ffmpeg 中， mux(multiplex) 是复用，表示将多路流(视频、音频、字幕等)混入一路输出(普通文件、流等)。demux 是解复用，表示从一路输入中分离出多路流(视频、音频、字幕等)。mux 处理的是输入格式，demux 处理的是输出格式。输入/输出媒体格式涉及文件格式和封装格式。

- 文件格式：由文件扩展名标识，主要起提示作用，通过扩展名提示文件类型(或封装格式)信息。
- 封装格式：存储媒体内容的实际容器格式，不同的封装格式对应不同的文件扩展名。很多时候也用文件格式指代封装格式。

## 查看 ffmpeg 支持的封装格式

使用 `ffmpeg -formats` 命令可以查看 FFmpeg 支持的封装格式。

## libavformat 库

libavformat 是一个处理 I/O 和复用/解复用的库。

libavformat(lavf) 用于处理多种媒体容器格式。它主要的两个目的是解复用——即将一个媒体文件拆分成组件流，以及反向的复用过程——将提供的数据写入一个指定的容器格式。该库还有一个 `lavf_io I/O 模块`，提供了许多协议用于访问数据(比如文件、TCP、HTTP 等)。在使用 lavf 之前，需要调用 `av_register_all()` 注册所有编译的复用器、解复用器和协议。除非完全确定不需要使用该库的网络功能，也应该调用 `avformat_network_init()`。

`AVInputFormat` 结构体描述了支持的输入格式，`AVOutputFormat` 描述了支持的输出格式。可以使用 `av_iformat_next()`/`av_oformat_next()` 函数迭代所有注册的输入/输出格式。协议层不是公共 API 的一部分，因此你只能使用 `avio_enum_protocols` 函数获得支持的协议名称。

`AVFormatContext` 是用于复用和解复用的主要 lavf 结构，它导出读写文件的所有信息。跟大多数 libavformat 结构一样，`AVFormatContext`的大小不是公共 ABI 的一部分，因此不能在栈上或使用 `av_malloc()` 直接分配。想要创建一个 `AVFormatContext`，使用 `avformat_alloc_context()`(有的函数，比如 `avformat_open_input()` 可能会完成这些事情)。

### 主要的 API

FFmpeg 中将编码帧及未编码帧均称作 frame，下面内容将编码帧称作 packet，未编码帧称作 frame。

packet 交织：不同流的 packet 在输出媒体文件中应严格按照 packet 中 dts 递增的顺序交错存放。

```c
// 打开输入媒体文件，读取文件头，将文件格式信息存储在第一个参数 AVFormatContext 中
int avformat_open_input(AVFormatContext **ps, const char *url, AVInputFormat *fmt, AVDictionary **options);

// 读取一段视频文件数据并尝试解码，将取到的流信息填入 AVFormatContext.streams 中。AVFormatContext.streams 是一个指针数组，数组大小是 AVFormatContext.nb_streams
int avformat_find_stream_info(AVFormatContext *ic, AVDictionary **options);

// 用于解复用过程: 将存储在输入文件中的数据分割为多个 packet，每次调用将得到一个 packet
// 对于视频来说，一个 packet 只包含一个视频帧；对于音频来说，若是帧长固定的格式则一个 packet 可包含整数个音频帧，若是帧长可变的格式则一个 packet 只包含一个音频帧
int av_read_frame(AVFormatContext *s, AVPacket *pkt);

// 用于复用过程，将 packet 写入输出媒体：直接将 packet 写入复用器，不会缓存或记录任何 packet。由调用者负责不同流的 packet 交织问题
int av_write_frame(AVFormatContext *s, AVPacket *pkt);

// 用于复用过程，将packet写入输出媒体: 在内部缓存 packet，从而确保输出媒体中不同流的 packet 能按照 dts 增长的顺序正确交织
int av_interleaved_write_frame(AVFormatContext *s, AVPacket *pkt);

// 创建并初始化一个 AVIOContext，用于访问输出媒体文件
int avio_open(AVIOContext **s, const char *url, int flags);

// 向输出文件写入文件头信息
int avformat_write_header(AVFormatContext *s, AVDictionary **options);

// 向输出文件写入文件尾信息
int av_write_trailer(AVFormatContext *s);
```

### 解复用

解复用器读入一个媒体文件，将其分割成数据块(packet)。一个 `AVPacket` 的 packet 包含一个或多个编码帧，这些帧术语一个基本流(elementary stream)。在 lavf 的 API，这个过程表示为：

- `avformat_open_input()` 打开文件
- `av_read_frame()` 读取一个 packet
- `av_close_input()` 清理资源

#### 打开媒体文件

打开文件所需的最小信息是它的 URL，参数会传递给 `avformat_open_input()`，正如下面的代码：

```c
const char *url = "file:in.mp3";
AVFormatContext *s = NULL;
int ret = avformat_open_input(&s, url, NULL, NULL);
if (ret < 0 )
  abort();
```

上述代码尝试分配 `AVFormatContext`，打开指定的文件(自动探测格式)，读头部，导出这些信息存储到 `s`。一些格式没有头或者没有在头部存储足够的信息，因此建议调用 `avformat_find_stream_info()`，它会尝试读和解码一些帧来查找缺少的信息。

在一些场景，可能想要使用 `avformat_alloc_context()` 预分配一个 `AVFormatContext`，对其做一些跳转，然后将其传递给 `avformat_open_input()`。一种情况是你想要使用自定义函数读取输入数据而不是 lavf 内部的 I/O 层，为此，使用 `avio_alloc_context()` 创建自己的 `AVIOContext`，将读取回调函数传递给它。然后，将参加没户口那么的 `AVFormatContext` 的 `pb` 设置为新创建的 `AVIOContext`。

```c
AVDictionary *options = NULL;
av_dict_set(&options, "video_size", "640*480", 0);
av_dict_set(&options, "pixel_format", "rgb24", 0);

if (avformat_open_input(&s, url, NULL, &options) < 0)
  abort();
av_dixt_free(&options);
```

这段代码传递私有选项 `video_size` 和 `pixel_format` 给解复用器。这对于类似原始视频解复用器是必须的，否则解复用器不知道如何解释原始的视频数据。如果格式最终和原始视频不同，这些选项不会被解复用器识别也不会应用。这样未被识别的选项会在选项字典返回(识别的选项会被消费)。调用的程序可以按照下面的方式处理这些未识别的选项：

```c
AVDictionary *e;
if (e = av_dict_get(options, "", NULL, AV_DICT_IGNORE_SUFFOX)) {
  fprintf(stderr, "Options %s not recognized by the demuxer.\n", e->key);
  abort();
}
```

#### 关闭打开的文件

在完成读取文件之后，必须使用 `av_close_input()` 关闭它。这个函数会释放和该文件相关的所有资源。

#### 读取打开的文件

从打开的 `AVFormatContext` 读物数据是通过对其反复调用 `av_read_frame()` 实现的。每次调用如果成功，会返回一个 `AVPacket` 包含一个流的编码数据，流可通过 `AVPacket.stream_index` 识别。如果想要解码这些数据，可直接传递这个包给 libavcodec 解码函数 `avcodec_send_packet()` 或 `avcodec_decode_subtitle2()`。

如果已知会设置 `AVPacket.pts` `AVPacket.dts` `AVPacket.duration` 时间信息。如果流没有提供，这些字段也可能未设置(及 `pts/dts` 是 `AV_NOPTS_VALUE`，`duration` 是 0)。时间信息是 `AVStream.time_base` 单位，即将其转为秒时需要乘以时基。

如果在返回的包上设置了 `AVPacket.buf`，那么会动态分配该数据包，用户可以一直保留。否则，`AVPacket.buf` 是 `NULL`，该包的数据在解复用的某处静态存储，且仅在下一个 `av_read_frame()` 调用或关闭文件之前有效。如果调用者需要更长的生命周期，`av_dup_packet()` 会对其进行 `av_malloc` 拷贝。这两种情形，都必须在不再使用的时候使用 `av_packet_unref()` 释放包。

### 复用

复用器接收 `AVPacket` 类型的编码数据，将其写入知道容器格式的文件或其他输出字节流。

用于复用的主要 API 函数是:

- `avformat_write_header` 写入文件头
- `av_write_frame`/`av_interleaved_write_frame()` 写入包
- `av_write_trailer` 完成文件

#### 设置复用上下文

复用过程开始的时候，调用者首先必须调用 `avformat_alloc_context()` 创建一个复用上下文。然后，调用者通过填充上下文的不同域设置复用器：

- `AVFormatContext.oformat` 域必须设置用于选择要使用的复用器
- 除非格式是 `AVFMT_NOFILE` 类型，`AVFormatContext.pb` 域必须设置为一个打开的 IO 上下文，该上下文由 `avio_open2` 返回或是一个自定义的。
- 除非格式是 `AVFMT_NOSTREAMS` 类型，必须使用 `avformat_new_stream()` 创建至少一个流。调用者必须按照已知的填充“流编解码参数”信息 `AVStream.codecpar`，比如编解码类型 `AVCodecParameters.codec_type`、编解码 ID `AVCodecParameters.codec_id` 和其他参数(比如宽度、高度、像素或采样格式等)。流时基 `AVStream.time_base` 应设置为调用者想要用于此流的时基(注意服用者使用的时基可以不同)
- 在 remux 期间，建议仅手动初始化 `AVCodecParameters` 的相关字段，而不是使用 `avcodec_parameters_copy()`: 不能保证编码上下文的值对于输入和输出格式上下文都保持有效。
- 调用者可根据 `AVFormatContext` 文档填充额外的信息，比如“全局的” `AVFormatContext.metadata` 或“单个流的” `AVStream.metadata`，`AVFormatContext.chapters`、`AVFormatContext.programs` 等。这些信息是否存储在输出取决于容器格式和复用器是否支持。

#### 写入文件头

当完全设置了复用上下文之后，调用者必须调用 `avformat_write_header()` 来初始化复用器内部并写入文件头。此阶段是否写入任何东西到 IO 上下文取决于复用器，但是必须总调用这个函数。所有的复用器私有选项必须传递给这个函数的 `options` 参数。

#### 写入数据包

通过重复调用 `av_write_frame()` 或 `av_interleaved_write_fram()` 将数据发送给复用器。(参阅这些函数的文档查看两个函数的区别；每个复用上下文只使用一个，不能混合使用)注意发送给复用器的包的时间信息应当是对应 `AVStream` 的时基。该时基由复用器(在 `avformat_write_header()` 阶段)设置，且可不同于调用者的时基。

#### 完成文件

一旦写入所有数据，调用者必须调用 `av_write_trailer()` 来清空所有缓存的包，并完成输出文件，然后关闭 IO 上下文(如果有的话)，并最终使用 `avformat_free_context()` 释放复用上下文。

## 参考

- [FFmpeg 封装格式处理](https://www.cnblogs.com/leisure_chn/p/10506636.html)
