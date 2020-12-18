# ffmpeg 的时间基

- [ffmpeg 的时间基](#ffmpeg-的时间基)
  - [时间基与时间戳](#时间基与时间戳)
  - [AVStream.time_base](#avstreamtime_base)
    - [转封装过程的时间基转换](#转封装过程的时间基转换)
  - [AVCodecContext.time_base](#avcodeccontexttime_base)
    - [音视频编解码过程的时间基转换](#音视频编解码过程的时间基转换)
  - [AVFilterLink.time_base](#avfilterlinktime_base)
  - [AV_TIME_BASE/AV_TIME_BASE_Q](#av_time_baseav_time_base_q)
  - [常用的时间基转换函数](#常用的时间基转换函数)
    - [av_q2d](#av_q2d)
    - [av_rescale/av_rescale_rnd/av_rescale_q/av_rescale_q_rnd](#av_rescaleav_rescale_rndav_rescale_qav_rescale_q_rnd)
    - [av_packet_rescale_ts](#av_packet_rescale_ts)
  - [tbr/tbn/tbc](#tbrtbntbc)

## 时间基与时间戳

ffmpeg 中，时间基是时间(单位秒)的基本单位。时间戳乘以时间基可以得到实际的时间。

不同封装格式的时间基不同。在编解码时，采用的时间基和容器内的时间基也不同。

ffmpeg 中的 pts/dts 是 `int64_t` 类型，乘以对应的时间基，表示对应的时间戳。

## AVStream.time_base

对应容器的时间基。

这是时间(单位秒)的基本单位，表示帧的时间戳。

- 解码：`libavformat` 设置
- 编码：可以由调用者在 `avformat_write_header()` 之前设置，以向复用器提供有关所需时间基的提示。在 `avformat_write_header()` 中，复用器会使用实际写入文件的时间戳所用的时间基覆盖此字段(取决于格式，该时间戳可能和用户提供的时间戳有关，也可能无关)

`AVStream.time_base` 是 `AVPacket` 中 pts/dts 的时间单位，输入流和输出流的时间基：

- 输入流：打开输入文件后，调用 `avformat_find_stream_info()` 可获取每个流的时间基
- 输出流：打开输出文件后，调用 `avforamt_write_header()` 根据输出文件封装格式确定每个流的时间基

### 转封装过程的时间基转换

```c
// doc/example/transcoding.c
// int main(int argc, char **argv)
while (1) {
    // 从 demuxer 读取数据包：av_read_frame
    // 直接复用读取的数据包: 写入输出之前需要先将时间基转为输出流的时间基
    av_packet_rescale_ts(&packet,
                          ifmt_ctx->streams[stream_index]->time_base,
                          ofmt_ctx->streams[stream_index]->time_base);
    // muxer 写入数据包：av_interleaved_write_frame(ofmt_ctx, &packet)
}
```

## AVCodecContext.time_base

对应编解码器中的时间基。

这是时间(单位秒)的基本单位，表示帧的时间戳。对于固定帧率(fps)的内容，时间基应该是 `1/framerate`，且时间戳的增量应该是 1。这通常，但不总是视频帧率或场速率的倒数。如果帧率不是常数，`1/time_base` 也不是平均帧率。

像容器一样，基本流也可以存储时间戳，`1/time_base` 是指定这些时间戳的单位。作为此类编解码器时间基的示例，参考 ISO/IEC 14496-2:2001(E) `vop_time_increment_resolution` 和 `fixed_vop_rate`(`fixed_vop_rate` 为 0 表示它不同于帧率)。

- 编码：**必须**由用户指定
- 解码：解码使用此字段是过时的。请使用 `framerate` 代替。

### 音视频编解码过程的时间基转换

- 解码后的原始视频帧的时间基为 `1/framerate`。
- 解码后的原始音频帧的时间基为 `1/sample_rate`。

```c
// doc/example/transcoding.c
// int open_output_file(const char *filename)
// for 循环处理所有的输入流
for (i = 0; i < ifmt_ctx->nb_streams; i++) {
    // 示例中，转码成相同的属性(图像大小、采样率等)
    if (dec_ctx->codec_type == AVMEDIA_TYPE_VIDEO) {
        // 编码器视频时间基设置为解码器的时间基：即解码器帧率的倒数
        enc_ctx->time_base = av_inv_q(dec_ctx->framerate);
    } else {
        // 编码器音频采样率设置为解码器的采样率
        enc_ctx->sample_rate = dec_ctx->sample_rate;
        // 编码器音频时间基：即编码器采样率的倒数
        enc_ctx->time_base = (AVRational){1, enc_ctx->sample_rate};
    }
}
```

```c
// int main(int argc, char **argv)
while (1) {
    // 从 demuxer 读取数据包：av_read_frame
    // 解码数据包: 先将输入流时间基转为解码器的时间基
    av_packet_rescale_ts(&packet,
                          ifmt_ctx->streams[stream_index]->time_base,
                          stream_ctx[stream_index].dec_ctx->time_base);
    // decoder 解码数据包得到音视频原始帧
}
```

```c
// doc/example/transcoding.c
// int encode_write_frame(AVFrame *filt_frame, unsigned int stream_index, int *got_frame) 
// encoder 编码音视频原始帧得到数据包 enc_pkt
// 编码得到的数据包写入 muxer 之前需要转为输出流的时间基
av_packet_rescale_ts(&enc_pkt,
                      stream_ctx[stream_index].enc_ctx->time_base,
                      ofmt_ctx->streams[stream_index]->time_base);
// muxer 写入编码的帧 av_interleaved_write_frame(ofmt_ctx, &enc_pkt)
```

## AVFilterLink.time_base

定义将传递给此链接的帧/采样的 PTS 使用的时间基。在配置阶段，每个过滤器应该只修改输出的时间基,而输入连接的时间基应假定是不可更改的属性。

## AV_TIME_BASE/AV_TIME_BASE_Q

在 `libavutil/avutil.h` 中定义：

```c
/**
 * Internal time base represented as integer
 */
#define AV_TIME_BASE            1000000

/**
 * Internal time base represented as fractional value
 */
#define AV_TIME_BASE_Q          (AVRational){1, AV_TIME_BASE}
```

`AV_TIME_BASE` 和 `AV_TIME_BASE_Q` 用于 ffmpeg 内部处理，对应的时间单位是微妙(microsecond)。

在渲染视频帧的时候，会根据帧率等待一定的时间再渲染：

```c
// doc/example/filtering_video.c:
// void display_frame(const AVFrame *frame, AVRational time_base)
if (frame->pts != AV_NOPTS_VALUE) {
    if (last_pts != AV_NOPTS_VALUE) {
        /* sleep roughly the right amount of time;
          * usleep is in microseconds, just like AV_TIME_BASE. */
        delay = av_rescale_q(frame->pts - last_pts,
                              time_base, AV_TIME_BASE_Q);
        if (delay > 0 && delay < 1000000)
            usleep(delay);
    }
    last_pts = frame->pts;
}
```

## 常用的时间基转换函数

### av_q2d

在 `libavutil/rational.h` 中定义：

```h
/**
 * Convert an AVRational to a `double`.
 * @param a AVRational to convert
 * @return `a` in floating-point form
 * @see av_d2q()
 */
static inline double av_q2d(AVRational a){
    return a.num / (double) a.den;
}
```

`av_q2d` 将时间从分数转为小数(单位秒)。

```c
// fftools/ffmpeg.c:
// void do_video_stats(OutputStream *ost, int frame_size)
// 计算 pts(单位秒)：流 pts * 时间基
ti1 = av_stream_get_end_pts(ost->st) * av_q2d(ost->st->time_base);
if (ti1 < 0.01)
    ti1 = 0.01;

// 计算比特率：帧大小(单位比特) / 时间
bitrate     = (frame_size * 8) / av_q2d(enc->time_base) / 1000.0;
avg_bitrate = (double)(ost->data_size * 8) / ti1 / 1000.0;
fprintf(vstats_file, "s_size= %8.0fkB time= %0.3f br= %7.1fkbits/s avg_br= %7.1fkbits/s ",
        (double)ost->data_size / 1024, ti1, bitrate, avg_bitrate);
```

```c
// fftools/ffplay.c
// int audio_thread(void *arg)
typedef struct Frame {
    AVFrame *frame;
    double pts;           /* presentation timestamp for the frame */
    double duration;      /* estimated duration of the frame */
} Frame;
AVFrame *frame; // pts 是 int64_t
Frame *af; // pts 是 double
if (got_frame) {
    // 计算时间基：帧率/采样率的倒数
    tb = (AVRational){1, frame->sample_rate};
    // 计算 pts: 
    af->pts = (frame->pts == AV_NOPTS_VALUE) ? NAN : frame->pts * av_q2d(tb);
    // 计算 duration
    af->duration = av_q2d((AVRational){frame->nb_samples, frame->sample_rate});
}
```

### av_rescale/av_rescale_rnd/av_rescale_q/av_rescale_q_rnd

在 `libavutil/mathematics.h` 中定义：

```h
/**
 * Rescale a 64-bit integer with rounding to nearest.
 *
 * The operation is mathematically equivalent to `a * b / c`, but writing that
 * directly can overflow.
 *
 * This function is equivalent to av_rescale_rnd() with #AV_ROUND_NEAR_INF.
 *
 * @see av_rescale_rnd(), av_rescale_q(), av_rescale_q_rnd()
 */
int64_t av_rescale(int64_t a, int64_t b, int64_t c) av_const;

/**
 * Rescale a 64-bit integer with specified rounding.
 *
 * The operation is mathematically equivalent to `a * b / c`, but writing that
 * directly can overflow, and does not support different rounding methods.
 *
 * @see av_rescale(), av_rescale_q(), av_rescale_q_rnd()
 */
int64_t av_rescale_rnd(int64_t a, int64_t b, int64_t c, enum AVRounding rnd) av_const;

/**
 * Rescale a 64-bit integer by 2 rational numbers.
 *
 * The operation is mathematically equivalent to `a * bq / cq`.
 *
 * This function is equivalent to av_rescale_q_rnd() with #AV_ROUND_NEAR_INF.
 *
 * @see av_rescale(), av_rescale_rnd(), av_rescale_q_rnd()
 */
int64_t av_rescale_q(int64_t a, AVRational bq, AVRational cq) av_const;

/**
 * Rescale a 64-bit integer by 2 rational numbers with specified rounding.
 *
 * The operation is mathematically equivalent to `a * bq / cq`.
 *
 * @see av_rescale(), av_rescale_rnd(), av_rescale_q()
 */
int64_t av_rescale_q_rnd(int64_t a, AVRational bq, AVRational cq,
                         enum AVRounding rnd) av_const;
```

`av_rescalexxx` 用于不同时间基的转换，将时间值从一种时间基转为另一种时间基。

### av_packet_rescale_ts

在 `libavcodec/avcodec.h` 中定义：

```h
/**
 * Convert valid timing fields (timestamps / durations) in a packet from one
 * timebase to another. Timestamps with unknown values (AV_NOPTS_VALUE) will be
 * ignored.
 *
 * @param pkt packet on which the conversion will be performed
 * @param tb_src source timebase, in which the timing fields in pkt are
 *               expressed
 * @param tb_dst destination timebase, to which the timing fields will be
 *               converted
 */
void av_packet_rescale_ts(AVPacket *pkt, AVRational tb_src, AVRational tb_dst);
```

`av_packet_rescale_ts` 将 `AVPacket` 内有效的时间字段(时间戳/持续时间)从一个时间基转为另一个时间基。

## tbr/tbn/tbc

- tbr: 视频流的帧率或者场率(帧率的 2 倍)
- tbn: 对应容器的时间基，是 `AVStream.time_base` 的倒数
- tbc: 对应编解码器的时间基，是 `AVCodecContext.time_base` 的倒数

```c
// libavformat/dump.c
// void dump_stream_format(AVFormatContext *ic, int i, int index, int is_output)

if (st->codecpar->codec_type == AVMEDIA_TYPE_VIDEO) {
    // 计算帧率: avg_frame_rate
    if (fps)
        print_fps(av_q2d(st->avg_frame_rate), tbr || tbn || tbc ? "fps, " : "fps");
    // 计算 tbr: 帧率 r_frame_rate
    if (tbr)
        print_fps(av_q2d(st->r_frame_rate), tbn || tbc ? "tbr, " : "tbr");
    // 计算 tbn: 流时间基的倒数
    if (tbn)
        print_fps(1 / av_q2d(st->time_base), tbc ? "tbn, " : "tbn");
    // 计算 tbc: 编解码器的时间基的倒数
    if (tbc)
        print_fps(1 / av_q2d(st->codec->time_base), "tbc");
}
```
