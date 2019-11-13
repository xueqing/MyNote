# ffplay 解读

- [ffplay 解读](#ffplay-%e8%a7%a3%e8%af%bb)
  - [概述](#%e6%a6%82%e8%bf%b0)
  - [重要函数](#%e9%87%8d%e8%a6%81%e5%87%bd%e6%95%b0)
  - [音视频数据流程](#%e9%9f%b3%e8%a7%86%e9%a2%91%e6%95%b0%e6%8d%ae%e6%b5%81%e7%a8%8b)

## 概述

`ffplay.c` 是基于 ffmpeg 库的一个简单的媒体播放器。它初始化运行环境，把各个数据结构和功能函数组织起来，协调数据流和功能函数，响应用户操作，启动并控制程序运行。

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

## 音视频数据流程

ffplay.c `int main(int argc, char **argv)`

```text
avdevice_register_all
  生成实例，注册所有编解码器、解复用器和协议
av_init_packet(&flush_pkt)
  初始化 flush_pkt
stream_open
  打开并处理指定 URL
event_loop
  处理 GUI 发送的事件。
  for 循环
    refresh_loop_wait_event 调用 video_refresh 渲染一帧
```

ffplay.c `static VideoState *stream_open(const char *filename, AVInputFormat *iformat)`

```text
frame_queue_init
  初始化帧队列
packet_queue_init
  初始化包队列
init_clock
  初始化时钟
SDL_CreateThread(read_thread, "read_thread", is)
  创建读线程调用 read_thread 从磁盘或网络得到流
```

ffplay.c `static int read_thread(void *arg)`

```text
avformat_alloc_context
  初始化 AVFormatContext
avformat_open_input
  打开一个输入流并读头信息，未打开 codec。
  init_input
    打开输入文件并探测格式(格式未知的话) AVFormatContext。
    av_probe_input_buffer2
      探测字节流确定输入格式 AVInputFormat
  AVFormatContext.iformat.read_header
    读格式头并初始化 AVFormatContext 结构
setup_find_stream_info_opts
  设置 AVStream.info，即 avformat_find_stream_info 内部使用的流信息
avformat_find_stream_info
  读媒体文件的包获得流信息。这对于没有头的文件格式(如 mpeg)有用。
  find_probe_decoder/avcodec_open2(libavforamt/utils.c)
    找到对应的编解码器和参数
stream_component_open
  打开一个指定流，查找并打开编解码器 codec 并启动音视频解码线程
  avcodec_parameters_to_context
    将流的编解码器参数 AVCodecParameters(VideoState.ic.streams.codecpar) 转为 AVCodecContext
  avcodec_find_decoder
    根据匹配的 codec_id 找到注册的解码器 AVCodec
  audio_open
    如果是音频，准备音频播放，设置播放的回调函数 sdl_audio_callback
  decoder_init
    初始化解码器
  decoder_start
    开始解码，在 PacketQueue 放一个 flush_pkt，并创建和开启 audio_thread/video_thread/subtitle_thread 线程处理不同媒体类型
for 循环
  av_read_frame(libavforamt/utils.c)
    返回流的下一帧。对于视频，包包含一帧数据；对于音频，如果帧是固定大小则包含整数帧，大小不固定则包含一帧。
    read_frame_internal >> ff_read_packet >> AVFormatContext.iformat.read_packet
  packet_queue_put
    将读到的帧放到音频或视频的 PacketQueue(VideoState.audioq/videoq/subtitleq)
```

audio_thread 音频解码线程

```text
av_frame_alloc
  初始化一个帧，分配解码帧缓存
get_video_frame
  调用 decoder_decode_frame 得到一个音频帧 AVFrame
  avcodec_receive_frame >> decode_receive_frame_internal >> ... >> Decoder.avctx.codec.decode 解一个包得到音频帧
frame_queue_push
  将帧放在采样队列(VideoState.sampq)
av_frame_unref
  释放视频帧内存
```

video_thread 视频解码线程

```text
av_frame_alloc
  初始化一个帧
get_video_frame
  调用 decoder_decode_frame 得到一个视频帧 AVFrame。内部
  avcodec_receive_frame >> decode_receive_frame_internal >> ... >> Decoder.avctx.codec.decode 解一个包得到视频帧
queue_picture
  将帧放在图像队列(VideoState.pictq)
av_frame_unref
  释放视频帧内存
```

subtitle_thread 字幕解码线程

```text
frame_queue_peek_writable
  等待可以放入一帧
packet_queue_get
  取出队列中的一个包
decoder_decode_frame
  得到一个字幕帧 AVFrame
  avcodec_decode_subtitle2 >> Decoder.avctx.codec.decode 解一个包得到帧
frame_queue_push
  将帧放在字幕队列(VideoState.subq)
```
