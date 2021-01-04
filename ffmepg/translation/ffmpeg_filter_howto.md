# FFmpeg 过滤器机制

- [FFmpeg 过滤器机制](#ffmpeg-过滤器机制)
  - [过滤器的定义](#过滤器的定义)
    - [AVFilter](#avfilter)
    - [AVFilterPad](#avfilterpad)
  - [图片缓存](#图片缓存)
    - [引用计数](#引用计数)
    - [权限](#权限)
  - [过滤器 link](#过滤器-link)
  - [编写一个简单的过滤器](#编写一个简单的过滤器)
    - [默认的过滤器入口点](#默认的过滤器入口点)
    - [vf_negate 过滤器](#vf_negate-过滤器)
      - [query_formats()](#query_formats)
      - [输入 pad 上的 config_props()](#输入-pad-上的-config_props)
      - [draw_slice()](#draw_slice)

翻译[原文](https://wiki.multimedia.cx/index.php/FFmpeg_filter_HOWTO)。

此页面旨在介绍为 `libavfilter` 编写过滤器。这项工作持续进行，但至少指出如何正确编写简单的过滤器。

## 过滤器的定义

### AVFilter

所有过滤器由 `AVFilter` 结构体描述。这个结构体提供初始化过滤器所需的信息，也提供了有关过滤器入口点的信息。此结构在 `libavfilter/avfilter.h` 中声明：

```c
typedef struct
{
    char *name;         ///< filter name

    int priv_size;      ///< size of private data to allocate for the filter

    int (*init)(AVFilterContext *ctx, const char *args, void *opaque);
    void (*uninit)(AVFilterContext *ctx);

    int (*query_formats)(AVFilterContext *ctx);

    const AVFilterPad *inputs;  ///< NULL terminated list of inputs. NULL if none
    const AVFilterPad *outputs; ///< NULL terminated list of outputs. NULL if none
} AVFilter;
```

`query_formats` 函数设置连接的输出 link 的 `in_formats` 成员，以及连接的输入 link 的 `out_formats` 成员，输入 link 和输出 link 在下面的 `AVFilterLink` 描述。

### AVFilterPad

快速看一下 `AVFilterPad` 结构，它用于描述过滤器的输入和输出。此结构也在 `libavfilter/avfilter.h` 中声明：

```c
typedef struct AVFilterPad
{
    char *name;
    int type;

    int min_perms;
    int rej_perms;

    void (*start_frame)(AVFilterLink *link, AVFilterPicRef *picref);
    AVFilterPicRef *(*get_video_buffer)(AVFilterLink *link, int perms);
    void (*end_frame)(AVFilterLink *link);
    void (*draw_slice)(AVFilterLink *link, int y, int height);

    int (*request_frame)(AVFilterLink *link);

    int (*config_props)(AVFilterLink *link);
} AVFilterPad;
```

头文件中的实际定义具有 doxygen 注释，这些注释描述了每个入口点、其用途以及与之相关的 pad 类型。这些字段和所有 pad 相关：

| 字段 | 描述 |
| --- | --- |
| name | pad 的名称。两个输入 pad 不能有相同的名字，两个输出 pad 也不能同名|
| type | 目前只有 `AV_PAD_VIDEO` |
| config_props | 处理和 pad 相连的 link 的配置 |

只和输入 pad 相关的字段：

| 字段 | 描述 |
| --- | --- |
| min_perms | 输入图片所需的最小权限 |
| rej_perms | 输入图片不能接受的权限 |
| start_frame | 当给定一帧作为输入时调用 |
| draw_slice | 当给定一部分帧数据作为输入时调用 |
| end_frame | 发送输入帧完成时调用 |
| get_video_buffer | 前一个过滤器调用为图像申请内存 |

只和输出 pad 相关的字段：

| 字段 | 描述 |
| --- | --- |
| request_frame | 要求过滤器输出一帧 |

## 图片缓存

### 引用计数

过滤器系统中的所有图片都是引用计数的。这意味着有一个为图像数据分配了内存的图片缓存，并且不同的过滤器可以持有对该缓存的引用。当一个引用不再需要时，其持有者释放该引用。当图片缓存的最后一个引用释放时，过滤器系统自动释放这个图片缓存。

### 权限

多个过滤器引用某个图片的结果是，它们都希望对该图像数据进行某种程度的访问。显而易见的是，如果一个过滤器希望在读取图像数据的时候数据不会改变，那么其他过滤器不应该写入这个图像数据。权限系统会处理这样的问题。

在大多数情况下，当过滤器准备输出一帧时，它会从过滤器请求输出缓存。过滤器指定缓存所需的最小权限，但是可能返回一个缓存，这个缓存的权限比过滤器请求的最小权限更多。

当过滤器想将此缓存作为输出传递给另一个过滤器，它会创建对此图片的新引用，新引用可能是权限的一个子集。接收的过滤器会持有此新引用。

因此，例如对于一类过滤器，它会丢弃和最后一个输出帧相似的帧，那么这种过滤器会希望输出图像之后保留自己的引用，并确保没有其他过滤器修改这个缓存。为此，它会自己请求权限 `AV_PERM_READ|AV_PERM_WRITE|AV_PERM_PRESERVE`，并在传递引用给其他过滤器时移除 `AV_PERM_WRITE` 权限。

可用的权限有：

| 权限 | 描述 |
| --- | --- |
| AV_PERM_READ | 可以读取图像数据 |
| AV_PERM_WRITE | 可以写入图像数据 |
| AV_PERM_PRESERVE | 可以假定其他过滤器不会修改图像数据。这意味着其他过滤器不能有 `AV_PERM_WRITE` 权限 |
| AV_PERM_REUSE | 过滤器可能多次输出相同的缓存，但是对于不同的输出，图像数据可能不会修改 |
| AV_PERM_REUSE2 | 过滤器可能多次输出相同的缓存，并且可以在输出中间修改图像数据 |

## 过滤器 link

一个过滤器的输入和输出通过 `AVFilterLink` 结构体和另一个过滤器的输入和输出相连：

```c
typedef struct AVFilterLink
{
    AVFilterContext *src;       ///< source filter
    unsigned int srcpad;        ///< index of the output pad on the source filter

    AVFilterContext *dst;       ///< dest filter
    unsigned int dstpad;        ///< index of the input pad on the dest filter

    int w;                      ///< agreed upon image width
    int h;                      ///< agreed upon image height
    enum PixelFormat format;    ///< agreed upon image colorspace

    AVFilterFormats *in_formats;    ///< formats supported by source filter
    AVFilterFormats *out_formats;   ///< formats supported by destination filter

    AVFilterPicRef *srcpic;

    AVFilterPicRef *cur_pic;
    AVFilterPicRef *outpic;
};
```

`src` 和 `dst` 成员分别指示 link 的源和目标端。`srcpad` 指示源过滤器上输出 pad 的索引。同样地，`dstpad` 指示目的过滤器上输入 pad 的索引。

`in_formats` 成员指向源过滤器支持的格式列表，而 `out_formats` 指向目的过滤器支持的格式列表。用于存储列表的 `AVFilterFormats` 结构是引用计数的，且实际上会记录其引用(参阅 `libavfilter/avfilter.h` 中有关 `AVFilterFormats` 的注释，了解如何进行颜色空间协调以及为什么需要这样做)。结果是如果过滤器在多个输入/输出 link 上提供指向同一链表的指针，那么这些 link 将被迫使用相同的格式。

连接两个过滤器时，它们需要协商将要使用的图像数据的尺寸以及数据格式。一旦达成协议，将这些参数存储在 `AVFilterLink` 结构体。

`srcpic` 成员由过滤器系统内部使用，并且不应该直接访问它。

`cur_pic` 成员用于目标过滤器。当前通过 link 发送一帧(即从调用 `start_frame()` 开始，到调用 `end_frame()` 结束)时，`cur_pic` 持有对该帧的引用，这个引用由目标过滤器持有。

`outpic` 成员在下面关于编写一个简单的过滤器教程中描述。

## 编写一个简单的过滤器

### 默认的过滤器入口点

因为大多数可能要编写的过滤器将只接受一个输入，并只产生一个输出，且对于每个输入帧只输出一帧。所以过滤器系统提供了许多默认的入口点，以简化这类过滤器的开发。

| 入口点 | 默认实现所做的事情 |
| --- | --- |
| request_frame() | 从 chain 的前一个过滤器请求一帧 |
| query_formats() | 设置所有输入 pad 支持格式的列表，以便所有 link 使用和默认格式列表相同的格式，默认格式列表包含大多数 YUV 和 RGB/BGR 格式 |
| start_frame() | 请求一个缓存存储输出帧。在和过滤器输出挂钩的 link 的 `outpic` 成员中保存此缓存的引用。调用下一个过滤器的 `start_frame()` 回调，并为函数指定对此缓存的一个引用 |
| end_frame() | 调用下一个过滤器的 `end_frame()` 回调。如果设置了引用(即使用了默认的 start_frame())，则释放输出 link 的 `outpic` 成员的引用。释放输入 link 的 `cur_pic` 引用 |
| get_video_buffer() | 返回一个缓存，此缓存出了所有请求的权限，还有 `AV_PERM_READ` 权限 |
| 输出 pad: config_props() | 为输出 link 设置图像尺寸，尺寸等同于过滤器的输入 |

### vf_negate 过滤器

已经看过涉及的数据结构和回调函数，让我们看一下实际的过滤器。vf_negate 过滤器可反转视频中的颜色。它有一个输入和一个输出，并且对于每个输入帧只输出一帧。在这种情况下，它是相当典型的，并且可以利用过滤器系统提供的许多默认回调实现。

```c
AVFilter avfilter_vf_negate =
{
    .name      = "negate",
    .priv_size = sizeof(NegContext),
    .query_formats = query_formats,
    .inputs    = (AVFilterPad[]) {{ .name            = "default",
                                    .type            = AV_PAD_VIDEO,
                                    .draw_slice      = draw_slice,
                                    .config_props    = config_props,
                                    .min_perms       = AV_PERM_READ, },
                                  { .name = NULL}},
    .outputs   = (AVFilterPad[]) {{ .name            = "default",
                                    .type            = AV_PAD_VIDEO, },
                                  { .name = NULL}},
};
```

你可以看到过滤器名字是 “negate”，并且需要 `sizeof(NegContext)` 大小的字节存储其上下文。在输入和输出列表中，名字是 `NULL` 的 pad 意味着列表结束，因此这个过滤器只有一个输入和一个输出。如果仔细查看 pad 的定义，会看到实际上指定了很少的回调函数。因为这个过滤器的简单性，默认操作可为我们完成大部分工作。

让我们看一下它定义的回调函数。

#### query_formats()

```c
static int query_formats(AVFilterContext *ctx)
{
    avfilter_set_common_formats(ctx,
        avfilter_make_format_list(10,
                PIX_FMT_YUV444P,  PIX_FMT_YUV422P,  PIX_FMT_YUV420P,
                PIX_FMT_YUV411P,  PIX_FMT_YUV410P,
                PIX_FMT_YUVJ444P, PIX_FMT_YUVJ422P, PIX_FMT_YUVJ420P,
                PIX_FMT_YUV440P,  PIX_FMT_YUVJ440P));
    return 0;
}
```

它调用了 `avfilter_make_format_list()`。这个函数的第一个参数是格式的数目，后续剩余参数作为格式，返回值是包含给定格式的 `AVFilterFormats` 结构。`AVFilterFormats` 结构传递给 `avfilter_set_common_formats()` 函数，函数设置所有连接的 link 使用此相同的格式列表，这会导致所有过滤器在协商完成后使用相同格式。如你所见，这个过滤器支持许多平面 YUV 颜色空间，包括 JPEG YUV 颜色空间(名称中带有 “J” 的颜色空间)。

#### 输入 pad 上的 config_props()

输入 pad 上的 `config_props()` 负责验证过滤器是否支持输入 pad 的属性，并对 link 属性必要的过滤器上下文进行更新。

TODO：快速说明 YUV 颜色空间、色度二次采样、YUV 和 JPEG YUV 的范围差异。

让我们看一下过滤器存储其上下文的方式：

```c
typedef struct
{
    int offY, offUV;
    int hsub, vsub;
} NegContext;
```

那就对了。`AVFilter` 结构的 `priv_size` 成员告诉过滤器系统为此结构保留多少字节。`hsub` 和 `vsub` 成员用于色度二次采样，而 `offY` 和 `offUV` 成员用于处理 YUV 和 JPEG YUV 的范围差异。让我们看看如何在输入 pad 的 `config_props()` 上设置这些属性：

```c
static int config_props(AVFilterLink *link)
{
    NegContext *neg = link->dst->priv;

    avcodec_get_chroma_sub_sample(link->format, &neg->hsub, &neg->vsub);

    switch(link->format) {
    case PIX_FMT_YUVJ444P:
    case PIX_FMT_YUVJ422P:
    case PIX_FMT_YUVJ420P:
    case PIX_FMT_YUVJ440P:
        neg->offY  =
        neg->offUV = 0;
        break;
    default:
        neg->offY  = -4;
        neg->offUV = 1;
    }

    return 0;
}
```

它简答地调用 `avcodec_get_chroma_sub_sample()` 获取色度二次采样的移位因子，并将其存储在上下文中。然后，它存储一组偏移量以补偿 JPEG YUV 的不同亮度/色度值范围，并存储一组不同的偏移量用于补偿其他的 YUV 演示空间。返回 0 表示成功，因为没有此过滤器不能处理的输入。

#### draw_slice()

最后，`draw_slice()` 函数实际执行过滤器处理：

```c
static void draw_slice(AVFilterLink *link, int y, int h)
{
    NegContext *neg = link->dst->priv;
    AVFilterPicRef *in  = link->cur_pic;
    AVFilterPicRef *out = link->dst->outputs[0]->outpic;
    uint8_t *inrow, *outrow;
    int i, j, plane;

    /* luma plane */
    inrow  = in-> data[0] + y * in-> linesize[0];
    outrow = out->data[0] + y * out->linesize[0];
    for(i = 0; i < h; i ++) {
        for(j = 0; j < link->w; j ++)
            outrow[j] = 255 - inrow[j] + neg->offY;
        inrow  += in-> linesize[0];
        outrow += out->linesize[0];
    }

    /* chroma planes */
    for(plane = 1; plane < 3; plane ++) {
        inrow  = in-> data[plane] + (y >> neg->vsub) * in-> linesize[plane];
        outrow = out->data[plane] + (y >> neg->vsub) * out->linesize[plane];

        for(i = 0; i < h >> neg->vsub; i ++) {
            for(j = 0; j < link->w >> neg->hsub; j ++)
                outrow[j] = 255 - inrow[j] + neg->offUV;
            inrow  += in-> linesize[plane];
            outrow += out->linesize[plane];
        }
    }

    avfilter_draw_slice(link->dst->outputs[0], y, h);
}
```

参数 `y` 指示当前切片的顶部，参数 `h` 指示切片的高度。不应假定此切片之外的图像区域是有意义的(尽管将来会出现一种方法，该方法允许此假设以简化某些过滤器的边界情况)。

函数设置 `inrow` 指向输入切片的第一行的开头，`outrow` 指向输出切片的第一行的开头。然后，对于每一行，函数循环遍历所有像素，从 255 中减去像素值，并添加 `config_props()` 中确定的偏移量以处理不同的值范围。

然后，函数对色度平面执行相同的操作。注意宽度和高度如何右移以解决色度二次采样。

绘制完成后，通过调用 `avfilter_draw_slice()` 将切片发送到下一个过滤器。
