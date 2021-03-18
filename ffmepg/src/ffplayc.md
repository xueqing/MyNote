# ffplay 解读

- [ffplay 解读](#ffplay-解读)
  - [概述](#概述)
  - [流程](#流程)
  - [重要函数](#重要函数)

## 概述

`ffplay.c` 是基于 ffmpeg 库的一个简单的媒体播放器。它初始化运行环境，把各个数据结构和功能函数组织起来，协调数据流和功能函数，响应用户操作，启动并控制程序运行。

## 流程

```mermaid
graph TD
subgraph "main 函数"
    main --> |"注册编解码器/解复用器/协议"| A1(avdevice_register_all)
    A1 --> |"初始化 flush_pkt"| B1("av_init_packet(&flush_pkt)")
    B1 --> |"打开并处理指定 URL"| C1(stream_open)
    C1 --> |"处理事件循环"| D1(event_loop)
end

C1 --> stream_open
subgraph "stream_open 函数"
    stream_open --> |"初始化帧队列"| A2(frame_queue_init)
    A2 --> |"初始化包队列"| B2(packet_queue_init)
    B2 --> |"初始化时钟"| C2(init_clock)
    C2 --> |"创建读线程 read_thread 从磁盘或网络得到流"| D2("SDL_CreateThread")
end

D2 --> read_thread
subgraph "read_thread 函数"
    read_thread --> |"初始化 AVFormatContext"| A3(avformat_alloc_context)
    A3 --> |"打开输入流读头信息，保存文件格式"| B3(avformat_open_input)
    B3 --> |"设置 avformat_find_stream_info 内部使用的流信息"| C3("setup_find_stream_info_opts")
    C3 --> |"读媒体文件的包获得流信息"| D3(avformat_find_stream_info)
    D3 --> |"打开指定流，查找并打开编解码器，并启动音视频解码线程"| E3(stream_component_open)
    E3 --> F3("for loop")
end

E3 --> stream_component_open
subgraph "stream_component_open 函数"
    stream_component_open --> |"将流的编解码器参数 AVCodecParameters 转为 AVCodecContext"| A6(avcodec_parameters_to_context)
    A6 --> |"根据匹配的 codec_id 找到注册的解码器"| B6(avcodec_find_decoder)
    B6 --> |"准备音频播放，设置播放的回调函数 sdl_audio_callback"| C6(audio_open)
    C6 --> |"初始化解码器"| D6(decoder_init)
    D6 --> |"开始解码，创建和开启 audio_thread/video_thread/subtitle_thread 线程处理不同媒体类型"| E6(decoder_start)
end

F3 --> for_loop
subgraph "for loop 函数"
    for_loop --> |"暂停/继续读流"| A7(av_read_pause/av_read_play)
    A7 --> |"返回流的下一帧"| B7(av_read_frame)
    B7 --> |"将读到的帧放到音频或视频的 PacketQueue"| C7(packet_queue_put)
end

E6 --> audio_thread
subgraph "audio_thread 音频解码线程"
    audio_thread --> |"初始化一个帧，分配解码帧缓存"| A8(av_frame_alloc)
    A8 --> |"得到一个音频帧 AVFrame"| B8(decoder_decode_frame)
    B8 --> |"将帧放在采样队列(VideoState.sampq)"| C8(frame_queue_push)
    C8 --> |"释放音频帧内存"| D8(av_frame_unref)
end

E6 --> video_thread
subgraph "video_thread 视频解码线程"
    video_thread --> |"初始化一个帧，分配解码帧缓存"| A9(av_frame_alloc)
    A9 --> |"得到一个视频帧 AVFrame"| B9(decoder_decode_frame)
    B9 --> |"将帧放在图像队列(VideoState.pictq)"| C9(queue_picture)
    C9 --> |"释放视频帧内存"| D9(av_frame_unref)
end

E6 --> subtitle_thread
subgraph "subtitle_thread 字幕解码线程"
    subtitle_thread --> |"等待可以放入一帧"| A10(frame_queue_peek_writable)
    A10 --> |"取出队列中的一个包"| B10(packet_queue_get)
    B10 --> |"得到一个字幕帧"| C10(decoder_decode_frame)
    C10 --> |"将帧放在字幕队列将帧放在字幕队列(VideoState.subq)"| D10(frame_queue_push)
end

D1 --> event_loop
subgraph "event_loop 函数"
    event_loop --> |"调用 video_refresh 渲染一帧"| A11(refresh_loop_wait_event)
    A11 --> B11("switch-case 处理 SDL_XXX 事件")
end
```

```mermaid
graph TD
subgraph "avformat_open_input 函数"
    avformat_open_input --> |"打开输入文件并探测格式(格式未知的话)"| A4(init_input)
    A4 --> |"读格式头并初始化 AVFormatContext"| B4(AVFormatContext.iformat.read_header)
end

subgraph "avformat_find_stream_info 函数"
    avformat_find_stream_info --> |"找到对应的编解码器和参数"| A5(find_probe_decoder)
    A5 --> |"读取一小段视频文件数据并尝试解码，保存取到的流信息"| B5(try_decode_frame)
end
```

## 重要函数

```text
static int packet_queue_put_private(PacketQueue *q, AVPacket *pkt)
  向音视频队列中添加一个音视频数据帧/包，不用加锁和解锁。
  申请分配一个 MyAVPacketList 结构，然后浅拷贝 AVPacket 数据，链表末尾置空。将新的 MyAVPacketList 放在队列末尾，更新队列的媒体数据统计信息。最后设置信号量通知等待的解码线程
static int packet_queue_put(PacketQueue *q, AVPacket *pkt)
  向音视频队列中添加一个音视频数据帧/包，需要手动加锁和解锁以同步
static int packet_queue_init(PacketQueue *q)
  初始化队列。
  初始化为 0 后创建线程同步使用的互斥量和条件量
static void packet_queue_flush(PacketQueue *q)
  刷新队列。
  释放队列中所有动态分配的内存，包括音视频裸数据占用的内存(MyAVPacketList.pkt)和 MyAVPacketList 结构占用的内存
static void packet_queue_destroy(PacketQueue *q)
  释放队列占用的所有资源。
  首先释放所有动态分配的内存，然后释放申请的互斥量和条件量
static void packet_queue_abort(PacketQueue *q)
  设置异常请求退出状态，释放队列占用的资源
static int packet_queue_get(PacketQueue *q, AVPacket *pkt, int block, int *serial)
  从队列取出一帧包/数据。
  如果异常请求标记被置为，返回错误码 -1。
  如果队列有数据，取出第一个数据包，更新队列的媒体数据统计信息，浅拷贝，释放被拷贝的结构，返回 1。
  如果是非阻塞模式，队列没有数据，直接返回 0。
  如果是阻塞模式，没有数据进入睡眠状态等待互斥量和信号量。

static int decoder_decode_frame(Decoder *d, AVFrame *frame, AVSubtitle *sub)
  从队列取一个数据帧/包，进行解码，得到音视频帧 AVFrame 或字幕帧 AVSubtitle。

static Frame *frame_queue_peek_writable(FrameQueue *f)
  等待信号量直到可以放入一个新的音视频帧 AVFrame
static int queue_picture(VideoState *is, AVFrame *src_frame, double pts, double duration, int64_t pos, int serial)
  放入一个新的图像帧 Frame。
  判断是否可以放入图像帧(可能需要等待)。不能写入返回错误码 -1。
  设置图像的属性。
  放入 VideoState.pictq 图像队列。
static int get_video_frame(VideoState *is, AVFrame *frame)
  取出音视频帧/字幕帧，并计算同步时钟

static int audio_decode_frame(VideoState *is)
  解码一个音频帧并返回解压的数据大小。  
```
