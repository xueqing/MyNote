# ffmpeg 过滤器

- [ffmpeg 过滤器](#ffmpeg-过滤器)
  - [libavfilter 库](#libavfilter-库)
    - [数据结构](#数据结构)
      - [AVFilterPad](#avfilterpad)
      - [AVFilter](#avfilter)
      - [AVFilterContext](#avfiltercontext)
      - [AVFilterLink](#avfilterlink)
      - [AVFilterInOut](#avfilterinout)

## libavfilter 库

libavfilter 是基于图的帧编辑库。

### 数据结构

#### AVFilterPad

在 `libavfilter/internal.h` 中定义。

`AVFilterPad` 是过滤器 pad，用于输入或输出。

```c
struct AVFilterPad {
    const char *name;     // pad 名称。在所有输入和输出中唯一，但是输入和输出和重名，可为 NULL
    enum AVMediaType type;// AVFilterPad 媒体类型

    /**
     * 获取视频缓存的回调函数。如果为 NULL，过滤器系统会使用 ff_default_get_video_buffer()。
     * 只用于输入视频 pad。
     */
    AVFrame *(*get_video_buffer)(AVFilterLink *link, int w, int h);

    /**
     * 获取音频缓存的回调函数。如果为 NULL，过滤器系统会使用 ff_default_get_audio_buffer()。
     * 只用于输入音频 pad。
     */
    AVFrame *(*get_audio_buffer)(AVFilterLink *link, int nb_samples);

    /**
     * 过滤处理的回调函数。过滤器接受包含音视频数据的帧，并对其进行处理。
     * 只用于输入 pad。
     * 返回值：成功返回 0，出错返回负值。此函数不能确保当帧没有传递给另一个过滤器时，可以正确解引用此帧。
     */
    int (*filter_frame)(AVFilterLink *link, AVFrame *frame);

    /**
     * 轮询帧的回调函数。函数返回立即可用的采样数。如果下次调用 request_frame() 确保返回一帧(没有延迟)，此函数应返回一个正数。
     * 默认仅调用源的 poll_frame() 方法。
     * 只用于输出 pad。
     */
    int (*poll_frame)(AVFilterLink *link);

    /**
     * 请求帧的回调函数。对此函数的调用应导致一些处理可以为给定的 link 生成输出。
     * 返回值：成功返回 0，否则表示出错。
     * 只用于输出 pad。
     */
    int (*request_frame)(AVFilterLink *link);

    /**
     * 配置 link 回调函数。
     * 对于输出 pad，此函数应设置 link 属性(比如宽度/高度)。不应设置格式属性——在调用此函数之前，过滤器系统使用 query_formats() 在过滤器之间协商。
     * 对于输出 pad，此函数应该检查 link 属性，并按需更新过滤器的内部状态。
     * 对于输入和输出过滤器，成功返回 0，否则表示出错。
     */
    int (*config_props)(AVFilterLink *link);

    /**
     * 过滤器希望在其输入 link 插入 fifo，通常是因为过滤器有延迟。
     * 只用于输入 pad。
     */
    int needs_fifo;

    /**
     * 过滤器从其输入 link 获取可写帧，并在需要时复制数据缓冲区。
     * 只用于输入 pad。
     */
    int needs_writable;
};
```

#### AVFilter

在 `libavfilter/avfilter.h` 中定义。

`AVFilter` 定义过滤器包含的 pad，及所有与过滤器交互的回调函数。

过滤器公共 API 包括：

```c
typedef struct AVFilter {
    const char *name;           // 过滤器名称。在过滤器中必须唯一且非 NULL
    const AVFilterPad *inputs;  // 输入列表，零元素作为终止符
    const AVFilterPad *outputs; // 输出列表，零元素作为终止符

    /**
    * 私有数据类，用于声明过滤器私有选项。如果没有选项则为 NULL。
    * 如果不为 NULL，这个过滤器的私有数据第一个成员必须是 AVClass 的指针，libavfilter 的通用代码会设置这个指针。
    */
    const AVClass *priv_class;

    /*****************************************************************
     * 下面的字段不是公共 API。不能在 libavfilter 之外使用，也不能删除或修改。
     * 在上面添加新的公共字段。
     *****************************************************************
     */

    /**
     * 过滤器预初始化函数。
     * 在分配过滤器上下文之后会立即调用此函数，以分配和初始化子对象。
     * 如果为 NULL，分配失败会调用 uninit 回调。
     * 返回值：成功返回 0，失败返回错误码(但是调用代码会丢弃错误码并将其视为 ENOMEM)。
     */
    int (*preinit)(AVFilterContext *ctx);

    /**
     * 过滤器初始化函数。
     * 在过滤器生命周期内此回调只调用一次，在所有选项设置完成之后，但是在完成过滤器之间的 link 建立和格式协商之前。
     * 函数内应完成过滤器的基本初始化工作。具有动态输入和/或输出的过滤器应基于选项在这里创建输入/输出。这个回调之后不能再修改过滤器的输入/输出。
     * 此回调不能假定存在过滤器 link 或已知帧参数。
     * 即使初始化失败也确保会调用 AVFilter.uninit 函数，所以此回调失败也不会清理内存。
     * 返回值：成功返回 0，失败返回错误码
     */
    int (*init)(AVFilterContext *ctx);

    /**
     * 如果过滤器想要传递一个 AVOption 字典给 AVFilter.init 期间分配的上下文，需要此过滤器设置而不是由 AVFilter.init 设置这些选项。
     * 返回时，应该释放选项字典，并替换为新的字典，包含此过滤器不能处理的所有选项(如果处理了所有选项则设置为 NULL)。
     */
    int (*init_dict)(AVFilterContext *ctx, AVDictionary **options);

    /**
     * 过滤器去初始化函数。
     * 在释放过滤器之前只调用一次。函数内部应该释放过滤器持有的所有内存和缓存引用等。不需要释放 AVFilterContext.priv 本身。
     * AVFilter.init 未调用或返回失败也可能调用此回调，所以必须在内部处理这种情况。
     */
    void (*uninit)(AVFilterContext *ctx);

    /**
     * 查询过滤器输入和输出支持的格式。
     * 此回调在过滤器初始化之后(因此输入和输出是固定的)，协商格式之前调用。可以调用多次。
     * 此回调必须将每个输入 link 的 AVFilterLink.out_formats 和输出 link 的 AVFilterLink.in_formats 设置为像素/采样格式列表，此列表是过滤器在该 link 上支持的格式。对于音频 link，过滤器还必须设置 AVFilterLink.in_samplerates、AVFilterLink.out_samplerates、AVFilterLink.in_channel_layouts 和 AVFilterLink.out_channel_layouts。
     * 对于只有一个输入的过滤器，此回调可能为 NULL，在这种情况下，libavfilter 假定过滤器支持所有输入格式并在输出格式中保留。
     * 返回值：成功返回 0，失败返回错误码
     */
    int (*query_formats)(AVFilterContext *);

    int priv_size;          // 为过滤器分配的私有数据大小
    struct AVFilter *next; // 过滤器注册系统使用。其它代码不能使用

    /**
     * 使过滤器实例处理一个命令。
     * 参数 cmd: 要处理的命令，出于处理的简单化要求命令只包含数字和字母
     * 参数 arg: 命令的参数
     * 参数 res: 长度为 res_len 的缓存，可以保存过滤器的回复。如果不支持此命令不能修改此内存
     * 参数 flags: 如果设置了 AVFILTER_CMD_FLAG_FAST，那么如果命令是耗费时间的，过滤器应将其视为不支持的命令
     * 返回值：成功返回 0，失败返回错误码。AVERROR(ENOSYS) 表示不支持此命令
     */
    int (*process_command)(AVFilterContext *, const char *cmd, const char *arg, char *res, int res_len, int flags);

    /**
     * 过滤器初始化函数，可替代 init() 回调。Args 包含用户提供的参数，opaque 用于提供二进制数据
     */
    int (*init_opaque)(AVFilterContext *ctx, void *opaque);

    /**
     * 过滤器激活函数。
     * 需要过滤器处理而非 pad 上的 filter_frame/request_frame 时调用此函数。
     * 此函数必须检查 inlinks 和 outlinks，并执行单步处理。如果无事可做，函数无需处理且不能返回错误。如果可能执行更多步骤，必须使用 ff_filter_set_ready() 设置再次激活的时间。
     */
    int (*activate)(AVFilterContext *ctx);
```

#### AVFilterContext

在 `libavfilter/avfilter.h` 中定义。

`AVFilterContext` 表示一个过滤器实例。

```c
struct AVFilterContext {
    const AVClass *av_class;  // av_log() 和过滤器通用选项所需
    const AVFilter *filter;   // 过滤器实例所属类
    char *name;               // 过滤器实例名称

    AVFilterPad *input_pads;  // 输入 pad 链表
    AVFilterLink **inputs;    // 指向输入 link 的指针链表
    unsigned nb_inputs;       // 输入 pad 数目

    AVFilterPad *output_pads; // 输出 pad 链表
    AVFilterLink **outputs;   // 指向输出 link 的指针链表
    unsigned nb_outputs;      // 输出 pad 数目

    void *priv;                   // 过滤器使用的私有数据
    struct AVFilterGraph *graph;  // 过滤器所属的 filtergraph

    unsigned ready; // 过滤器就绪状态。非零值表示过滤器需要激活；值越高表示需要激活的优先级越高
};
```

#### AVFilterLink

在 `libavfilter/avfilter.h` 中定义。

`AVFilterLink` 表示两个过滤器之间的 link。它包含 link 所在的源过滤器和目的过滤器的指针，以及相关 pad 的索引。除此之外，link 还包含过滤器协商一致的参数，比如图像尺寸、格式等。

应用程序通常不能直接访问 link 结构，请使用 `buffersrc` 和 `buffersink` API。未来，可为实现过滤器保留对头的访问。

```c
struct AVFilterLink {
    AVFilterContext *src; // 源过滤器
    AVFilterPad *srcpad;  // 源过滤器的输出 pad
    AVFilterContext *dst; // 目的过滤器
    AVFilterPad *dstpad;  // 目的过滤器的输入 pad

    enum AVMediaType type;  // 过滤器媒体类型

    /* 这些参数只用于视频 */
    int w;  // 协商的图像宽度
    int h;  // 协商的图像高度
    AVRational sample_aspect_ratio; // 协商的采样长宽比

    /* 这些参数只用于音频 */
    uint64_t channel_layout;  // 当前缓存的通道布局(参阅 libavutil/channel_layout.h)
    int sample_rate;          // 每秒采样数

    int format; // 协商的媒体格式

    /**
     * 定义发送给此 link 的帧/采样的 PTS 所用时间基。
     * 在配置阶段每个过滤器应该只修改输出时间基，而输入 link 的时间基属性应是不可修改的。
     */
    AVRational time_base;

    /*****************************************************************
     * 下面的字段不是公共 API。不能在 libavfilter 之外使用，也不能删除或修改。
     * 在上面添加新的公共字段。
     *****************************************************************
     */

    /**
     * 分别保存输入和输出过滤器支持的格式和通道布局列表。
     * 这些列表用于协商实际要使用的格式，选中之后会加载到上述的 format 和 channel_layout 成员。
     */
    AVFilterFormats *in_formats;
    AVFilterFormats *out_formats;

    /**
     * 自动协商所用的通道布局和采样率的列表。
     */
    AVFilterFormats  *in_samplerates;
    AVFilterFormats *out_samplerates;
    struct AVFilterChannelLayouts  *in_channel_layouts;
    struct AVFilterChannelLayouts *out_channel_layouts;

    /**
     * 只用于音频。目的过滤器将其设置为非零值，用于请求缓存，缓存包含应发送的采样数
     * 还要设置对应输入 pad 的 AVFilterPad.needs_fifo。
     * EOF 之前的最后缓存将使用静音填充。
     */
    int request_samples;

    /* link 属性(尺寸等)的初始化阶段 */
    enum {
        AVLINK_UNINIT = 0,  // 未开始
        AVLINK_STARTINIT,   // 开始但未完成
        AVLINK_INIT         // 完成
    } init_state;

    struct AVFilterGraph *graph; // 过滤器所属的 AVFilterGraph
    int64_t current_pts;    // link 当前的时间戳，由最新的帧定义，单位是 link 的时间基
    int64_t current_pts_us; // link 当前的时间戳，由最新的帧定义，单位是 AV_TIME_BASE

    /**
     * link 上流的帧率，未知或可变是 1/0；如果是 0/0，将自动拷贝源过滤器(如果存在)的第一个输入。
     * 源应将此设置为真实帧率的最好估计值。如果源帧率未知或可变，设置为 1/0。
     * 过滤器应依据其功能按需更新此值。sink 可用于设置默认的输出帧率。
     * 这个属性类似于 AVStream.r_frame_rate。
     */
    AVRational frame_rate;

    AVFrame *partial_buf; // 填充了部分采样的缓存，用于固定/最小尺寸
    int partial_buf_size; // 分配的 partial_buf 大小。必须介于 min_samples 和 max_samples
    /**
     * 过滤器每次最少的采样数。如果使用更少的采样调用 filter_frame()，过滤器会将其累积到 partial_buf。过滤开始之后不能修改 min_samples 及相关字段。
     * 如果是 0，会忽略所有相关字段。
     */
    int min_samples;
    int max_samples; // 过滤器每次最多的采样数. 如果使用更多的采样调用 filter_frame()，过滤器会分割采样
    
    int64_t frame_count_in, frame_count_out; // 经 link 发送过的帧数

    /**
     * 如果过滤器的输出当前需要一帧则设置为 True。
     * 由输出过滤器调用 ff_request_frame() 时设置，过滤处理一帧的时候重置。
     */
    int frame_wanted_out;

    FFFrameQueue fifo; // 等待过滤处理的帧队列
    int frame_blocked_in; // 设置之后源过滤器不能生成帧。目的是避免在同一 link 重复调用 request_frame
    int status_in; // link 输入状态。如果非零，所有 filter_frame 调用会返回失败对应的错误法
    int64_t status_in_pts; // 输入状态改变的时间戳
    int status_out; // link 输出状态。如果非零，所有 request_frame 调用会返回失败对应的错误法
};
```

#### AVFilterInOut

在 `libavfilter/avfilter.h` 中定义。

`AVFilterInOut` 表示输入输出过滤器 chain 的链接列表。主要用于 `avfilter_graph_parse()`/`avfilter_graph_parse2()`，调用者用于通信打开输入(未链接)和输出。结构体指定了 graph 包含的未连接的 pad，创建 link 所需的过滤器上下文和 pad 索引。

```c
 typedef struct AVFilterInOut {
    char *name;                 // 链表中输入/输出的唯一名称
    AVFilterContext *filter_ctx;// 和输入输出相关的过滤器上下文
    int pad_idx;                // 链接所用的 filt_ctx pad 的索引
    struct AVFilterInOut *next; // 链表中下个输入/输出，如果是最后一个此字段为 NULL
} AVFilterInOut;
```
