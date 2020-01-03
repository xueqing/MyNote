# 阅读 ffmpeg mpeg2-ts 源码

- [阅读 ffmpeg mpeg2-ts 源码](#%e9%98%85%e8%af%bb-ffmpeg-mpeg2-ts-%e6%ba%90%e7%a0%81)
  - [相关文件](#%e7%9b%b8%e5%85%b3%e6%96%87%e4%bb%b6)
  - [mpegts.h](#mpegtsh)
  - [mpegts.c](#mpegtsc)
  - [mpegtsenc.c](#mpegtsencc)

## 相关文件

```text
libavformat/avformat.h
  定义 AVProgram
libavformat/mpeg.h
  MPEG-1/2 复用器和解复用器的宏定义
libavformat/mpeg.c
  MPEG-1/2 解复用器
libavformat/mpegenc.c
  MPEG-1/2 复用器
libavformat/mpegts.h
  MPEG-2 TS 宏和函数声明
libavformat/mpegts.c
  MPEG-2 TS (即 DVB) 解复用器
libavformat/mpegtsenc.c
  MPEG-2 TS (即 DVB) 复用器
libavformat/mpegvideodec.c
  原始 MPEG video 解复用器
```

```h
typedef struct AVProgram {// 主要保存频道名称，服务商等信息
    int            id;// programid(PID)
    int            flags;
    enum AVDiscard discard;// 选择要丢弃的节目以及要反馈给调用者的节目
                           // AVDISCARD_ALL 时才可以丢弃
    unsigned int   *stream_index;
    unsigned int   nb_stream_indexes;
    AVDictionary *metadata;

    int program_num;// 节目编号
    int pmt_pid;
    int pcr_pid;// PCR 的 pid
    int pmt_version;// PMT 版本

    // 下面的域不是公共 API 的一部分。不能在 libavformat 之外使用，可以修改和删除。
    // 公共域应加到上面
    int64_t start_time;
    int64_t end_time;

    int64_t pts_wrap_reference;// reference dts for wrap detection
    int pts_wrap_behavior;// behavior on wrap detection
} AVProgram;
```

## mpegts.h

```h
// TS_PACKET_SIZE 188 + 16 字节的前向纠错校验码(FEC)
#define TS_FEC_PACKET_SIZE 204
// 日本的 DVB-S 广播系统采用 192 个字节的 TS 包
#define TS_DVHS_PACKET_SIZE 192
// TS 包大小
#define TS_PACKET_SIZE 188
// 最大包尺寸
#define TS_MAX_PACKET_SIZE 204

// 固定使用的 pid
#define PAT_PID                 0x0000
#define SDT_PID                 0x0011

// 表 id
#define PAT_TID   0x00
#define PMT_TID   0x02
#define M4OD_TID  0x05
#define SDT_TID   0x42

// 解析一个 MPEG-2 描述子。如果返回值小于 0 则停止处理
int ff_parse_mpeg2_descriptor(AVFormatContext *fc, AVStream *st, int stream_type,
                              const uint8_t **pp, const uint8_t *desc_list_end,
                              Mp4Descr *mp4_descr, int mp4_descr_count, int pid,
                              MpegTSContext *ts);
// 检查 H264 起始码的出现。如果返回值小于 0 则停止处理
int ff_check_h264_startcode(AVFormatContext *s, const AVStream *st, const AVPacket *pkt);
```

## mpegts.c

宏和结构体定义：

```c
enum MpegTSFilterType {
    MPEGTS_PES,// 过滤器类型为 PES/section/PCR
    MPEGTS_SECTION,
    MPEGTS_PCR,
};

typedef struct MpegTSPESFilter {// PES 过滤器
    PESCallback *pes_cb;// 回调函数
    void *opaque;// 类似于类指针
} MpegTSPESFilter;

typedef struct MpegTSSectionFilter {// section 过滤器
    int section_index;// section 的索引
    int section_h_size;// 头大小
    int last_ver;
    unsigned crc;
    unsigned last_crc;
    uint8_t *section_buf;// 保存 section 数据
    unsigned int check_crc : 1;
    unsigned int end_of_section_reached : 1;
    SectionCallback *section_cb;// 回调函数
    void *opaque;// 类似于类指针
} MpegTSSectionFilter;

struct MpegTSFilter {// TS 文件过滤器
    int pid;
    int es_id;
    int last_cc;// 最后一个连续性计数器(第一个包为 -1)
    int64_t last_pcr;
    enum MpegTSFilterType type;
    union {
        MpegTSPESFilter pes_filter;// 是 PES 包
        MpegTSSectionFilter section_filter;// 是 section 包
    } u;
};

struct Program {
    unsigned int id;// 节目/服务 id
    unsigned int nb_pids;// 数组保存节目关联的 pid
    unsigned int pids[MAX_PIDS_PER_PROGRAM];// 一个节目最多 64 个 pid
    int pmt_found;// 是否找到节目的 PMT
};

struct MpegTSContext {
    const AVClass *class;
    // 用户数据
    AVFormatContext *stream;// 反向引用 AVFormatContext
    int raw_packet_size;// 原始包大小，如果有 FEC 包含 FEC 大小

    int size_stat[3];
    int size_stat_count;
#define SIZE_STAT_THRESHOLD 10

    int64_t pos47_full;

    int auto_guess;// 如果为 true(1)，表示分析所有 pid 查找流

    int mpeg2ts_compute_pcr;// 为每个 TS 包计算精确的 PCR

    int fix_teletext_pts;// 修正 DVB teletext pts

    int64_t cur_pcr;// 用于估算精确的 PCR
    int pcr_incr;// 用于估算精确的 PCR

    // 基于 ts 处理文件所需数据
    int stop_parse;// 停止解析循环
    AVPacket *pkt;// 包含音频/视频数据的包
    int64_t last_pos;// 检测 seek

    int skip_changes;
    int skip_clear;
    int skip_unknown_pmt;

    int scan_all_pmts;

    int resync_size;
    int merge_pmt_versions;

    // 私有 mpegts 数据
    unsigned int nb_prg; // 遍历 context，记录 节目-pid 映射的结构
    struct Program *prg; // 根据节目 id 查找对应节目

    int8_t crc_validity[NB_PID_MAX];
    MpegTSFilter *pids[NB_PID_MAX];// 用于PAT、PMT 以及 PMT 指定的可变流的过滤器
    int current_pid;
};

enum MpegTSState {
    MPEGTS_HEADER = 0,    // 头
    MPEGTS_PESHEADER,     // PES 头
    MPEGTS_PESHEADER_FILL,// PES 头填充
    MPEGTS_PAYLOAD,       // 载荷
    MPEGTS_SKIP,          // 跳过
};

typedef struct PESContext {
    int pid;
    int pcr_pid;// -1 表示所有包含 PCR 的包要考虑在内
    int stream_type;
    MpegTSContext *ts;
    AVFormatContext *stream;
    AVStream *st;
    AVStream *sub_st;// 用于 HDMV TrueHD 中内置 AC3 流
    enum MpegTSState state;
    int data_index;// 用于获取格式
    int flags;// 拷贝到 AVPacket 标记
    int total_size;
    int pes_header_size;
    int extended_stream_id;
    uint8_t stream_id;
    int64_t pts, dts;
    int64_t ts_packet_pos;// PES 包中第一个 TS 包的位置
    uint8_t header[MAX_PES_HEADER_SIZE];
    AVBufferRef *buffer;
    SLConfigDescr sl;
    int merged_st;
} PESContext;

typedef struct SectionHeader { // 表的分节 table section
    uint8_t tid;// 表 id
    uint16_t id;// 表 id 扩展域。PAT 用作 TS 标识，PMT 用作节目编号
    uint8_t version;// 版本号
    uint8_t sec_num;// 节编号
    uint8_t last_sec_num;// 最后一个节编号
} SectionHeader;

// 对应真实的 TS 流格式，也就是机顶盒直接处理的 TS 流
AVInputFormat ff_mpegts_demuxer = {
    .name           = "mpegts",
    .long_name      = NULL_IF_CONFIG_SMALL("MPEG-TS (MPEG-2 Transport Stream)"),
    .priv_data_size = sizeof(MpegTSContext),// 每个 demuxer 结构私有域的大小
    .read_probe     = mpegts_probe,// 检测是否是 TS 流格式
    .read_header    = mpegts_read_header,
    .read_packet    = mpegts_read_packet,
    .read_close     = mpegts_read_close,// 关闭 demuxer
    .read_timestamp = mpegts_get_dts,
    .flags          = AVFMT_SHOW_IDS | AVFMT_TS_DISCONT,
    .priv_class     = &mpegts_class,
};

AVInputFormat ff_mpegtsraw_demuxer = {
    .name           = "mpegtsraw",
    .long_name      = NULL_IF_CONFIG_SMALL("raw MPEG-TS (MPEG-2 Transport Stream)"),
    .priv_data_size = sizeof(MpegTSContext),
    .read_header    = mpegts_read_header,
    .read_packet    = mpegts_raw_read_packet,
    .read_close     = mpegts_read_close,
    .read_timestamp = mpegts_get_dts,
    .flags          = AVFMT_SHOW_IDS | AVFMT_TS_DISCONT,
    .priv_class     = &mpegtsraw_class,
};
```

`mpegts_probe` 被 `av_probe_input_format2` 调用，根据返回的 `score` 来判断那种格式的可能性最大。

`ff_mpegts_demuxer` 结构通过 `av_register_all` 函数注册到 ffmpeg 的主框架中，通过 `mpegts_probe` 函数检测是否是 TS 流格式，然后通过 `mpegts_read_header` 函数找到一路音频流和一路视频流(注意：该函数没有找全所有音频流和视频流)，最后调用 `mpegts_read_packet` 函数将找到的音频流和视频流数据提取出来，通过主框架推入解码器。

函数定义：

```c
// 检测数据格式是不是 mpegts 格式
static int mpegts_probe(AVProbeData *p) {
    // 调用 analyze 获取可能的包大小，根据返回的分数判断哪种格式的可能性最大
    int score      = analyze(p->buf + TS_PACKET_SIZE     *i, TS_PACKET_SIZE     *left, TS_PACKET_SIZE     , 1);
    int dvhs_score = analyze(p->buf + TS_DVHS_PACKET_SIZE*i, TS_DVHS_PACKET_SIZE*left, TS_DVHS_PACKET_SIZE, 1);
    int fec_score  = analyze(p->buf + TS_FEC_PACKET_SIZE *i, TS_FEC_PACKET_SIZE *left, TS_FEC_PACKET_SIZE , 1);
    score = FFMAX3(score, dvhs_score, fec_score);
}

// 读数据头信息，比如在 ts 流中的数据包大小、ts 流中的节目信、SDT、PMT、视频 pid、音频 pid 等，以便后面读数据使用
static int mpegts_read_header(AVFormatContext *s) {
    // 读开始的 8192 个字节判断包大小(188/192/204)，不能判断默认为 188
    ts->raw_packet_size = get_packet_size(buf, len);
    if (s->iformat == &ff_mpegts_demuxer) {// 正常解复用
        // 首先扫描得到所有服务(SDT/PAT)
        mpegts_open_section_filter(ts, SDT_PID, sdt_cb, ts, 1);// 设置解析 SDT 的回调函数
        mpegts_open_section_filter(ts, PAT_PID, pat_cb, ts, 1);// 设置解析 PAT 的回调函数
        handle_packets(ts, probesize / ts->raw_packet_size);//探测一段流，便于检测出 SDT/PAT/PMT
    }
}

// 处理多个包
static int handle_packets(MpegTSContext *ts, int64_t nb_packets) {
    for (;;) {
        packet_num++;
        if (nb_packets != 0 && packet_num >= nb_packets || ts->stop_parse > 1) {
            ret = AVERROR(EAGAIN);
            break;
        }
        if (ts->stop_parse > 0) break;
        ret = read_packet(s, packet, ts->raw_packet_size, &data);//读取一个 TS 包
        ret = handle_packet(ts, data);// 处理一个 TS 包
        finished_reading_packet(s, ts->raw_packet_size);
        if (ret != 0) break;
    }
}
// 出错或 EOF 返回 AVERROR_xxx。成功返回 0
static int read_packet(AVFormatContext *s, uint8_t *buf, int raw_packet_size,
                       const uint8_t **data) {
    for (;;) {
        //读188个字节出来，如果缓冲里有，读缓冲，如果没有，读文件
        len = ffio_read_indirect(pb, buf, TS_PACKET_SIZE, data);
        if (len != TS_PACKET_SIZE)
            return len < 0 ? len : AVERROR_EOF;
        if ((*data)[0] != 0x47) {
            //...
        } else {// 检查到同步字节
            break;
        }
    }
}
// 处理一个 TS 包，参数 packet 就是 TS 包。之前先调用 read_packet 获得一个 TS 包（通常是 188 bytes）
static int handle_packet(MpegTSContext *ts, const uint8_t *packet) {

    // 根据iso13818-1 TS 包的格式描述，可以从 TS 包获取 PID、载荷单元开始指示位(start_indicator)
    tss = ts->pids[pid];//获取 PID 对应 MpegTSFilter
    if (ts->auto_guess && !tss && is_start) {
        add_pes_stream(ts, pid, -1);//将任何一个 PID 的流当做媒体流建立对应的 PES 数据结构
        tss = ts->pids[pid];
    }
    //mpegts_read_header 调用 handle_packet 只是处理 TS 流的业务信息，因为并没有为对应 PES 建立 tss，所以 tss 为空，直接返回
    if (!tss) return 0;

    // 从 TS 包获取 适配域存在标志(00-预留;01-只有载荷;10-只有适配域;11-适配器域后是载荷)
    // 适配域长度、不连续指示位、
    // 连续性计数器(用于检查同一个 PID 的 TS 包的连续性。暂未使用)
    // 传输错误指示位 TEI(当解调器不能从 FEC 数据修改错误时，设置为 1 表示这个包是错的)

    //处理适配域(如果存在)：计算 PCR，然后跳过适配域其他属性
    p_end = packet + TS_PACKET_SIZE;//到达TS包中的有效载荷的地方

    if (tss->type == MPEGTS_SECTION) {//表示当前的TS包包含一个新的业务信息段
        if (is_start) {
            len = *p++;//获取 pointer field 字段,新的段从 pointer field 字段指示的位置开始
            if (len && cc_ok) {
                //写入上一个段末尾部分数据，也就是从 TS 载荷开始到pointer field字段指示的位置
                write_section_data(ts, tss, p, len, 0);
            }
            p += len;
            if (p < p_end) {//写入新的段数据，也就是从 pointer field 字段指示的位置到 TS 包结束;代表的新的段开始的部分
                write_section_data(ts, tss, p, p_end - p, 1);
            }
        } else {
            if (cc_ok) {//TS 包载荷仅是一个 section 的中间部分，将其写入
                write_section_data(ts, tss, p, p_end - p, 0);
            }
        }
    } else {
        int ret;//正常的PES数据的处理
        if (tss->type == MPEGTS_PES) {//pes_cb 之前设置的是 mpegts_push_data
            if ((ret = tss->u.pes_filter.pes_cb(tss, p, p_end - p, is_start,
                                                pos - ts->raw_packet_size)) < 0)
                return ret;
        }
    }
}
// 取出一个 TS 包
static int mpegts_read_packet(AVFormatContext *s, AVPacket *pkt)
{
    ret = handle_packets(ts, 0);// 处理一个包
}
// 释放 MpegTSContext 内存：清除节目信息，关闭过滤器
static int mpegts_read_close(AVFormatContext *s)
```

## mpegtsenc.c

宏和结构体定义：

```c
/* mpegts section writer */
typedef struct MpegTSSection {
    int pid;
    int cc;
    int discontinuity;
    void (*write_packet)(struct MpegTSSection *s, const uint8_t *packet);
    void *opaque;
} MpegTSSection;

typedef struct MpegTSService {
    MpegTSSection pmt; /* MPEG-2 PMT table context */
    int sid;           /* service ID */
    char *name;
    char *provider_name;
    int pcr_pid;
    int pcr_packet_count;
    int pcr_packet_period;
    AVProgram *program;
} MpegTSService;

typedef struct MpegTSWrite {
    const AVClass *av_class;
    MpegTSSection pat; /* MPEG-2 PAT table */
    MpegTSSection sdt; /* MPEG-2 SDT table context */
    MpegTSService **services;
    int sdt_packet_count;
    int sdt_packet_period;
    int pat_packet_count;
    int pat_packet_period;
    int nb_services;
    int onid;
    int tsid;
    int64_t first_pcr;
    int mux_rate; ///< set to 1 when VBR
    int pes_payload_size;

    int transport_stream_id;
    int original_network_id;
    int service_id;
    int service_type;

    int pmt_start_pid;
    int start_pid;
    int m2ts_mode;

    int reemit_pat_pmt; // backward compatibility

    int pcr_period;
#define MPEGTS_FLAG_REEMIT_PAT_PMT  0x01
#define MPEGTS_FLAG_AAC_LATM        0x02
#define MPEGTS_FLAG_PAT_PMT_AT_FRAMES           0x04
#define MPEGTS_FLAG_SYSTEM_B        0x08
#define MPEGTS_FLAG_DISCONT         0x10
    int flags;
    int copyts;
    int tables_version;
    double pat_period;
    double sdt_period;
    int64_t last_pat_ts;
    int64_t last_sdt_ts;

    int omit_video_pes_length;
} MpegTSWrite;

typedef struct MpegTSWriteStream {
    struct MpegTSService *service;
    int pid; /* stream associated pid */
    int cc;
    int discontinuity;
    int payload_size;
    int first_pts_check; ///< first pts check needed
    int prev_payload_key;
    int64_t payload_pts;
    int64_t payload_dts;
    int payload_flags;
    uint8_t *payload;
    AVFormatContext *amux;
    AVRational user_tb;

    /* For Opus */
    int opus_queued_samples;
    int opus_pending_trim_start;
} MpegTSWriteStream;

static const AVClass mpegts_muxer_class = {
    .class_name = "MPEGTS muxer",
    .item_name  = av_default_item_name,
    .option     = options,
    .version    = LIBAVUTIL_VERSION_INT,
};

AVOutputFormat ff_mpegts_muxer = {
    .name           = "mpegts",
    .long_name      = NULL_IF_CONFIG_SMALL("MPEG-TS (MPEG-2 Transport Stream)"),
    .mime_type      = "video/MP2T",
    .extensions     = "ts,m2t,m2ts,mts",
    .priv_data_size = sizeof(MpegTSWrite),
    .audio_codec    = AV_CODEC_ID_MP2,
    .video_codec    = AV_CODEC_ID_MPEG2VIDEO,
    .init           = mpegts_init,
    .write_packet   = mpegts_write_packet,
    .write_trailer  = mpegts_write_end,
    .deinit         = mpegts_deinit,
    .check_bitstream = mpegts_check_bitstream,
    .flags          = AVFMT_ALLOW_FLUSH | AVFMT_VARIABLE_FPS | AVFMT_NODIMENSIONS,
    .priv_class     = &mpegts_muxer_class,
};
```

函数定义：

```c
// 为节目生成对应服务；为流分配对应节目 PID，设置对应编解码器信息；写头；计算 SDT/PAT/PMT 发送周期
static int mpegts_init(AVFormatContext *s)
static int mpegts_write_packet_internal(AVFormatContext *s, AVPacket *pkt)
// 把一帧数据拆分成188字节，并加入PTS，DTS同步信息，这个函数封装的对象是一帧视频或者音频数据
static void mpegts_write_pes(AVFormatContext *s, AVStream *st,
                             const uint8_t *payload, int payload_size,
                             int64_t pts, int64_t dts, int key, int stream_id) {
    // 判断并插入 SDT/PAT/PMT
    // 插入 PCR 或空包
    // 循环处理载荷数据
    // ======写包头，如果需要写入适配域
    // ======如果是第一次打包，需要写 PES 头，包括编解码器信息、PTS/DTS、
    // ======写入载荷数据：根据需要分包和填充。
    // 载荷未处理完重复上述三个步骤
}
// 周期性发送 SDT/PAT/PMT
static void retransmit_si_info(AVFormatContext *s, int force_pat, int64_t dts)
```
