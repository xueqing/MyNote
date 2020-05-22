# ffmpeg 的封装格式处理

- [ffmpeg 的封装格式处理](#ffmpeg-%e7%9a%84%e5%b0%81%e8%a3%85%e6%a0%bc%e5%bc%8f%e5%a4%84%e7%90%86)
  - [封装格式](#%e5%b0%81%e8%a3%85%e6%a0%bc%e5%bc%8f)
  - [查看 ffmpeg 支持的封装格式](#%e6%9f%a5%e7%9c%8b-ffmpeg-%e6%94%af%e6%8c%81%e7%9a%84%e5%b0%81%e8%a3%85%e6%a0%bc%e5%bc%8f)
  - [相关 API](#%e7%9b%b8%e5%85%b3-api)
  - [参考](#%e5%8f%82%e8%80%83)

## 封装格式

封装格式(container format)可以看作是编码流(音频流、视频流等)数据的一层外壳，将编码后的数据存储于此封装格式的文件之内。封装又称容器。

不同封装格式适用于不同的场合，支持的编码格式不一样，

ffmpeg 处理封装格式的流程：打开输入文件、打开输出文件、从输入文件读取编码帧、向输出文件写入编码帧。

ffmpeg 中， mux(multiplex) 是复用，表示将多路流(视频、音频、字幕等)混入一路输出(普通文件、流等)。demux 是解复用，表示从一路输入中分离出多路流(视频、音频、字幕等)。mux 处理的是输入格式，demux 处理的是输出格式。输入/输出媒体格式涉及文件格式和封装格式。

- 文件格式：由文件扩展名标识，主要起提示作用，通过扩展名提示文件类型(或封装格式)信息。
- 封装格式：存储媒体内容的实际容器格式，不同的封装格式对应不同的文件扩展名。很多时候也用文件格式指代封装格式。

## 查看 ffmpeg 支持的封装格式

使用 `ffmpeg -formats` 命令可以查看 FFmpeg 支持的封装格式。

## 相关 API

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

## 参考

- [FFmpeg 封装格式处理](https://www.cnblogs.com/leisure_chn/p/10506636.html)
