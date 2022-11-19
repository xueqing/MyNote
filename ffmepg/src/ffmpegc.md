# ffmpeg 解读

- [ffmpeg 解读](#ffmpeg-解读)
  - [概述](#概述)
  - [流程](#流程)
    - [main 函数](#main-函数)
    - [ffmpeg_parse_options 函数](#ffmpeg_parse_options-函数)
      - [OptionDef 结构体](#optiondef-结构体)
      - [options 数组](#options-数组)
    - [transcode 函数](#transcode-函数)
      - [init_input_threads](#init_input_threads)
      - [reap_filters 函数](#reap_filters-函数)

## 概述

`ffmpeg.c` 是基于 ffmpeg 库的一个多媒体转换器。

## 流程

### main 函数

```mermaid
graph TD
subgraph "main 函数"
  main --> |"加载动态库"| A0(init_dynload)
  A0 --> |"设置程序退出时要调用的函数，ffmpeg_cleanup 用于清理申请的内存"| B0(register_exit)
  B0 --> |"打印 ffmpeg 版本信息(编译时间、编译选项、库信息等)"| C0(show_banner)
  C0 --> |"解析输入选项，并打开所有输入输出文件"| D0(ffmpeg_parse_options)
  D0 --> |"文件转换器的主循环"| E0(transcode)
  E0 --> |"退出程序，清理资源"| F0(exit_program)
end
```

### ffmpeg_parse_options 函数

```mermaid
graph TD
subgraph "ffmpeg_parse_options 函数"
  ffmpeg_parse_options --> |"分隔命令行"| A1(split_commandline)
  A1 --> |"打开输入文件"| B1(open_input_file)
  B1 --> |"初始化 complex filtergraph"| C1(init_complex_filters)
  C1 --> |"打开输出文件"| D1(open_output_file)
end

B1 --> open_input_file
subgraph "open_input_file 函数"
  open_input_file --> |"如果选项设置了格式，查找对应的输入格式"| A2(av_find_input_format)
  A2 --> |"分配格式上下文"| B2(avformat_alloc_context)
  B2 --> |"根据选项设置音频采样率、音频通道数、帧率、视频尺寸、像素格式"| C2(av_dict_setxxx)
  C2 --> |"根据选项(编解码名称)查找视频、音频、字幕或数据编解码器"| D2(find_codec_or_die)
  D2 --> |"根据通用选项打开输入文件"| E2(avformat_open_input)
  E2--> |"设置 avformat_find_stream_info 内部使用的流信息"| F2(setup_find_stream_info_opts)
  F2 --> |"如果需要，解析流参数"| G2(avformat_find_stream_info)
  G2 --> |"保存此文件的输入流"| H2(add_input_streams)
end

D1 --> open_output_file
subgraph "open_output_file 函数"
  open_output_file --> |"分配输出格式上下文"| A3(avformat_alloc_output_context2)
  A3 --> |"初始化输出 filter"| B3(init_output_filter)
  B3 --> |"为每种类型挑选“最好的”流，并在创建输出流时保存其索引，设置各种媒体的参数"| C3(new_xxx_stream)
  C3 --> |"设置解码标识，创建 simple filtergraph"| D3(init_simple_filtergraph)
  D3 --> |"打开文件"| E3(avio_open2)
  E3 --> |"拷贝 metadata"| F3(copy_metadata)
  F3 --> |"拷贝 chapter"| G3(copy_chapters)
end
```

- `new_xxx_stream` 为每种类型挑选“最好的”流，并在创建输出流时保存“最好”输入流的索引
  - 视频：分辨率最好的，`new_video_stredam` 创建视频流
  - 音频：通道数最多的，`new_audio_stream` 创建音频流
  - 字幕：选择第一个，`new_subtitle_stream` 创建字幕流
  - 数据：选择编码器匹配的，`new_data_stream` 创建数据流

#### OptionDef 结构体

```c
// cmdutils.h
typedef struct OptionDef {
    const char *name;
    int flags;
#define HAS_ARG    0x0001
#define OPT_BOOL   0x0002
#define OPT_EXPERT 0x0004
#define OPT_STRING 0x0008
#define OPT_VIDEO  0x0010
#define OPT_AUDIO  0x0020
#define OPT_INT    0x0080
#define OPT_FLOAT  0x0100
#define OPT_SUBTITLE 0x0200
#define OPT_INT64  0x0400
#define OPT_EXIT   0x0800
#define OPT_DATA   0x1000
#define OPT_PERFILE  0x2000     /* the option is per-file (currently ffmpeg-only).
                                   implied by OPT_OFFSET or OPT_SPEC */
#define OPT_OFFSET 0x4000       /* option is specified as an offset in a passed optctx */
#define OPT_SPEC   0x8000       /* option is to be stored in an array of SpecifierOpt.
                                   Implies OPT_OFFSET. Next element after the offset is
                                   an int containing element count in the array. */
#define OPT_TIME  0x10000
#define OPT_DOUBLE 0x20000
#define OPT_INPUT  0x40000
#define OPT_OUTPUT 0x80000
     union {
        void *dst_ptr;
        int (*func_arg)(void *, const char *, const char *);
        size_t off;
    } u;
    const char *help;
    const char *argname;
} OptionDef;
```

- name: 存储选项的名称。如 `f`/`y`/`c` 等
- flags: 存储选项值的类型。如 `HAS_ARG`(有选项值)/`OPT_BOOL`(选项值为布尔类型)/`OPT_TIME`(选项值为时间类型)
- u: 存储选项的处理函数
  - `dst_ptr` 直接修改对应字段的值
  - `func_arg` 解析选项的回调函数
  - `off` 修改相对 `OptionsContext` 结构体的指定偏移量的字段值
- help: 选项的说明信息
- argname: 选项的别名

#### options 数组

ffmpeg 使用 `const OptionDef options[]` 数组保存所有选项。其中一部分通用选项存储在 `CMDUTILS_COMMON_OPTIONS` 宏中。

```c
const OptionDef options[] = {
    /* main options */
    CMDUTILS_COMMON_OPTIONS
    { "f",              HAS_ARG | OPT_STRING | OPT_OFFSET |
                        OPT_INPUT | OPT_OUTPUT,                      { .off       = OFFSET(format) },
        "force format", "fmt" },
    { "y",              OPT_BOOL,                                    {              &file_overwrite },
        "overwrite output files" },
    { "n",              OPT_BOOL,                                    {              &no_file_overwrite },
        "never overwrite output files" },
    { "ignore_unknown", OPT_BOOL,                                    {              &ignore_unknown_streams },
        "Ignore unknown stream types" },
    { "copy_unknown",   OPT_BOOL | OPT_EXPERT,                       {              &copy_unknown_streams },
        "Copy unknown stream types" },
    { "c",              HAS_ARG | OPT_STRING | OPT_SPEC |
                        OPT_INPUT | OPT_OUTPUT,                      { .off       = OFFSET(codec_names) },
        "codec name", "codec" },
    ......
}


#define CMDUTILS_COMMON_OPTIONS                                                                                         \
    { "L",           OPT_EXIT,             { .func_arg = show_license },     "show license" },                          \
    { "h",           OPT_EXIT,             { .func_arg = show_help },        "show help", "topic" },                    \
    { "?",           OPT_EXIT,             { .func_arg = show_help },        "show help", "topic" },                    \
    { "help",        OPT_EXIT,             { .func_arg = show_help },        "show help", "topic" },                    \
    { "-help",       OPT_EXIT,             { .func_arg = show_help },        "show help", "topic" },                    \
    { "version",     OPT_EXIT,             { .func_arg = show_version },     "show version" },                          \
    ......
```

### transcode 函数

```mermaid
graph TD
subgraph "transcode 函数"
  transcode --> |"完成转码的初始化工作"| A4(transcode_init)
  A4 --> |"为每个输入文件调用 init_input_threads"| B4(init_input_threads)
  B4 --> C4("while 循环")
  C4 --> |"释放每个文件的 in_thread_queue"| D4(free_input_threads)
  D4 --> |"传入空包，刷新所有输入文件的解码器缓存"| E4(process_input_packet)
  E4 --> |"刷新所有编码器"| F4(flush_encoders)
  F4 --> |"关闭所有输出文件"| G4(av_write_trailer)
  G4 --> H4("关闭所有编码器、解码器，释放其他资源")
end

A4 --> transcode_init
subgraph "transcode_init 循环"
  transcode_init --> A5("初始化过滤器")
  A5 --> B5("初始化帧率估计，如果命令行参数为输入文件设置了 -re，记录该文件所有流的 start 为当前时间")
  B5 --> |"初始化输入流：内部调用 avcodec_open2 打开解码器"| C5(init_input_stream)
  C5 --> |"初始化输出流：内部调用 avcodec_open2 打开编码器"| D5(init_output_stream)
  D5 --> E5("丢弃输入文件中未使用的 program")
  E5 --> |"对于不需要流的输出文件格式，初始化所有流之后，调用 avformat_write_header，打开复用器"| F5(check_init_output_file)
  F5 --> |"打印流映射信息"| G5(dump_format)
end
```

```mermaid
graph TD
subgraph "while 循环"
  while_loop --> |"检测键盘操作，如果按下 q 键则退出程序"| A6(check_keyboard_interaction)
  A6 --> |"进行单步转码"| B6(transcode_step)
  B6 --> |"打印当前时间的转码信息"| C6(print_report)
end

B6 --> transcode_step
subgraph "transcode_step 函数"
  transcode_step --> |"选择要处理的输出流，返回 cur_dts 最小的合适流"| A7(choose_output)
  A7 --> B7("根据输出流找到对应的输入流")
  B7 --> |"从指定输入流对应的输入文件读一个包并进行处理"| C7(process_input)
  C7 --> |"完成编码工作"| D7(reap_filters)
end

C7 --> process_input
subgraph "process_input 函数"
  process_input --> |"从指定的输入文件获取一包数据。如果该流的 dts 大于当前时间，返回 AVERROR(EAGAIN)"| A8(get_input_packet)
  A8 --> |"读到可用的包，重置输入文件和输出流的标记"| B8(reset_eagain)
  B8 --> C8("将流全局的 side data 增加到第一个包")
  C8 --> |"处理输入文件的一包数据"| E8(process_input_packet)
end
```

#### init_input_threads

- init_input_threads 为每个输入文件创建 AVPacket 队列 in_thread_queue，创建 input_thread 线程
- input_thread 有一个 while 循环
  - av_read_frame 从文件读一包
  - 将读到的包发送到 in_thread_queue

#### reap_filters 函数
