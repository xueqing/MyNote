# FFmpeg 过滤器文档

- [FFmpeg 过滤器文档](#ffmpeg-过滤器文档)
  - [1 描述](#1-描述)
  - [2 过滤介绍](#2-过滤介绍)
  - [3 graph2dot](#3-graph2dot)
  - [4 filtergraph 描述](#4-filtergraph-描述)
    - [4.1 filtergraph 语法](#41-filtergraph-语法)
    - [4.2 关于 filtergraph 转移的注意事项](#42-关于-filtergraph-转移的注意事项)
  - [5 时间轴编译](#5-时间轴编译)
  - [8 音频过滤器](#8-音频过滤器)
    - [8.82 loudnorm](#882-loudnorm)
  - [11 视频过滤器](#11-视频过滤器)
    - [11.62 drawtext](#1162-drawtext)
    - [11.63 edgedetect](#1163-edgedetect)
    - [11.95 hflip](#1195-hflip)
    - [11.137 negate](#11137-negate)
    - [11.147 overlay](#11147-overlay)
    - [11.150 pad](#11150-pad)
    - [11.178 scale](#11178-scale)
  - [14 视频 source](#14-视频-source)
    - [14.9 allrgb, allyuv, color, haldclutsrc, nullsrc, pal75bars, pal100bars, rgbtestsrc, smptebars, smptehdbars, testsrc, testsrc2, yuvtestsrc](#149-allrgb-allyuv-color-haldclutsrc-nullsrc-pal75bars-pal100bars-rgbtestsrc-smptebars-smptehdbars-testsrc-testsrc2-yuvtestsrc)
  - [16 多媒体过滤器](#16-多媒体过滤器)
    - [16.11 metadata, ametadata](#1611-metadata-ametadata)
    - [16.15 sendcmd, asendcmd](#1615-sendcmd-asendcmd)

翻译[原文](http://ffmpeg.org/ffmpeg-filters.html)。

## 1 描述

此文档描述 `libavfilter` 库提供的 过滤器、`source` 和 `sink`。

## 2 过滤介绍

通过 `libavfilter` 库启用 FFmpeg 的过滤。

在 `libavfilter` 中，过滤器可以有多个输入和多个输出。为了演示可能的情况，我们考虑下面的 filtergraph:

```txt
                [main]
input --> split ---------------------> overlay --> output
            |                             ^
            |[tmp]                  [flip]|
            +-----> crop --> vflip -------+
```

这个 filtergraph 将输入流分成两个流，然后发送一个流到 *crop* 过滤器和 *vflip* 过滤器，然后将其覆盖在顶部，从而与另外一个流合并。你可以使用下面的命令实现：

```sh
ffmpeg -i INPUT -vf "split [main][tmp]; [tmp] crop=iw:ih/2:0:0, vflip [flip]; [main][flip] overlay=0:H/2" OUTPUT
```

结果是视频的上半部分镜像映射到输出视频的下半部分。

同一线性 chain 中的过滤器使用逗号分隔，不同线性 chain 中的过滤器使用分号分隔。在我们的示例中，*crop*、*vflip* 在一个线性 chain 中，*split* 和 *overlay* 在另一线性 chain 中。线性 chain 连接点由方括号内的名称标记。在该示例中，split 过滤器生成两个输出，分别使用 *[main]* 和 *[tmp]* 标记。

发送给 *split* 的第二个流标记为 *[tmp]*，经由 *crop* 过滤器处理，*crop* 裁剪视频的下半部分，然后垂直翻转。*overlay* 过滤器接受 *split* 过滤器第一部分未更改的输出作为输入(标记为 *[main]*)，并在其下半部分覆盖 *crop* 和 *vflip* 过滤器链的输出。

一些过滤器接受一个输入参数列表：在过滤器名称和一个等号之后指定，使用冒号分隔。

存在所谓的 *source 过滤器* 没有音频/视频输入；*sink 过滤器* 没有音频/视频输出。

## 3 graph2dot

FFmpeg `tools` 目录包含的 graph2dot 程序可用于分析一个 filtergraph 描述，并使用 dot 语言发布一个相应的文本表示形式。

调用命令：

```sh
graph2dot -h
```

查看如何使用 graph2dot。

然后你可以给 dot 程序(来自 graphviz 程序套件)传递 dot 描述，并获得 filtergraph 的图形表。

比如命令序列：

```sh
echo GRAPH_DESCRIPTION | \
tools/graph2dot -o graph.tmp && \
dot -Tpng graph.tmp -o graph.png && \
display graph.png
```

可用于创建和显示一个图像，该图标表示 *GRAPH_DESCRIPTION* 字符串描述的图。注意这个字符串必须是一个完整的自包含图，且它的输入和输出是显式定义的。比如，如果你的命令行是这样的形式：

```sh
ffmpeg -i infile -vf scale=640:360 outfile
```

那么你的 *GRAPH_DESCRIPTION* 字符串需要是这样的形式：

```sh
nullsrc,scale=640:360,nullsink
```

你可能也需要设置 *nullsrc* 参数并增加一个 *format* 过滤器，以模仿一个指定的输入文件。

## 4 filtergraph 描述

一个 filtergraph 是一个连接的过滤器的有向图。它可以包含循环，并且一对过滤器之间可以有多个 link。每个 link 的一端都有一个输入 pad，将其连接到从中获取输入的过滤器，且另一端有一个输出 pad，将其连接到接受其输出的过滤器。

filtergraph 中的每个过滤器是一个过滤器类的实例，这些过滤器类注册到应用程序中，定义了过滤器的功能和输入输出 pad 的数目。

没有输入 pad 的过滤器叫做 *source*，没有输出 pad 的过滤器叫做 *sink*。

### 4.1 filtergraph 语法

filtergraph 具有文本表示形式，可通过 `ffmpeg` 的 `-filter/-vf/-af` 和 `-filter_complex` 选项和 `ffplay` 的 `vf/-af` 选项以及在 `libavfilter/avfilter.h` 定义的 `avfilter_graph_parse_ptr()` 函数识别。

filterchain 由一系列连接的过滤器组成，每个过滤器连接到该序列中的前一个过滤器。filterchain 由 “,” 分隔的过滤器描述列表表示。

filtergraph 由一系列 filterchain 组成。filterchain 的序列由 “;” 分隔的 filterchain 描述列表表示。

过滤器表示为下面的字符串形式：`[in_link_1]...[in_link_N]filter_name@id=arguments[out_link_1]...[out_link_M]`。

- *filter_name* 是过滤器类的名称，过滤器实例所属的类，且必须是注册到应用程序中的某个过滤器的名称，之后可以添加 “@id”。过滤器名称之后可以添加字符串“=arguments”。
- *arguments* 是一个字符串，包含用于初始化过滤器示例的参数。可以有两种形式：
  - *key=value* 对的列表，使用 “:” 分隔
  - *value* 的列表，使用 “:” 分隔。这种情况下，*key* 认为是按照声明顺序对应选项名称。比如，`fade` 过滤器依次声明三个选项——type、start_frame 和 nb_frame。那么参数列表 *in:0:30* 表示 *in* 值赋给选项 type，*0* 赋给 start_frame，且 *30* 赋给 nb_frame。
  - 混合直接的 *value* 和长的 *key=value* 对的列表，使用 “:” 分隔。直接的 *value* 必须在 *key=value* 对之前，并且遵循上一点所述的相同限制。之后的 *key=value* 对可设置为任何希望的顺序。

如果选项值本身是一个元素列表(比如过滤器 `format` 接受一个像素格式列表)，列表中的元素通常使用 “|” 分隔。

参数列表可以使用 “'” 引起来，作为开始和结束标记，引用文本内部使用 “\” 转义；否则，当出现特殊字符(属于集合 “[]=;,”)时会认为参数字符串终止。

过滤器的名称和参数之前和之后可以添加 link 标签。link 标签支持对 link 命名并将其关联到过滤器的输出或输入 pad。前面的标签 *in_link_1* …… *in_link_N*，和过滤器的输入 pad 关联，后面的标签 *out_link_1* …… *out_link_M*，和输出 pad 关联。

在 filtergraph 中发现两个 link 标签名称相同时，在对应的输入和输出 pad 之间创建一个 link。

如果输出 pad 没有标签，默认将其链接到 filterchain 中下一个过滤器第一个没有标签的输入 pad。比如在 filterchain 中：

```sh
nullsrc, split[L1], [L2]overlay, nullsink
```

split 过滤器实例有两个输出 pad，且 overlay 过滤器实例有两个输入 pad。split 第一个输出 pad 标签是 “L1”，overlay 第一个输入 pad 的标签是 “L2”，split 第二个输出 pad 链接到 overlay 第二个输入 pad，这两个 pad 都没有标签。

在一个过滤器描述中，如果未指定第一个过滤器的输入标签，则认为是 “in”；如果未指定最后一个过滤器的输出标签，则认为是 “out”。

在一个完整的 filterchain 中，所有不带标签的过滤器输入和输出 pad 必须被连接起来。如果所有 filterchain 的所有输入和输出 pad 都被连接，则认为这个 filtergraph 是有效的。

当需要转化格式时，libavfilter 会自动插入 `scale` 过滤器。通过在 filtergraph 描述之前添加 `sws_flags=flags;`，可为那些自动插入的 scale 过滤器指定 swscale 标记。

下面是 filtergraph 语法的 BNF 描述：

```txt
NAME             ::= sequence of alphanumeric characters and '_'
FILTER_NAME      ::= NAME["@"NAME]
LINKLABEL        ::= "[" NAME "]"
LINKLABELS       ::= LINKLABEL [LINKLABELS]
FILTER_ARGUMENTS ::= sequence of chars (possibly quoted)
FILTER           ::= [LINKLABELS] FILTER_NAME ["=" FILTER_ARGUMENTS] [LINKLABELS]
FILTERCHAIN      ::= FILTER [,FILTERCHAIN]
FILTERGRAPH      ::= [sws_flags=flags;] FILTERCHAIN [;FILTERGRAPH]
```

### 4.2 关于 filtergraph 转移的注意事项

filtergraph 描述组成包含几个级别的转义。参阅 [(ffmpeg-utils) ffmpeg-utils 手册中的“引用和转移”章节](http://ffmpeg.org/ffmpeg-utils.html#quoting_005fand_005fescaping) 获取更多关于使用的转义程序的信息。

第一个级别的转义影响每个过滤器选项值的内容，其中可能包含用于分隔值的特殊字符 `:`，或转义字符之一 `\'`。

第二个级别的转义影响整个过滤器描述，其中可能包含转义字符 `\'` 或 filtergraph 描述使用的特殊字符 `[],:`。

最后，当你在 shell 命令行指定一个 filtergraph，你需要为其中包含的 shell 特殊字符执行第三个级别的转义。

比如，考虑下面的字符串，它会嵌入到 `drawtext` 过滤器的描述文本值中：

```txt
this is a 'string': may contain one, or more, special characters
```

这个字符串包含特殊字符 `'` 和 `:`，因此需要按下面的方式将其转义：

```txt
this is a \'string\'\: may contain one, or more, special characters
```

当在 filtergraph 描述中嵌入过滤器描述时需要用到第二个级别的转义，以便转义所有的 filtergraph 特殊字符。因此上面的例子变成：

```txt
drawtext=text=this is a \\\'string\\\'\\: may contain one\, or more\, special characters
```

(请注意，处理 `\'` 转义为特殊字符，还需要转义 `,`。)

最后，将 filtergraph 描述写入 shell 命令时需要另外一个级别的转义，这取决于所选 shell 的转义规则。比如，假定 `\` 是特殊的且需要另外一个 `\` 转义，前面的字符串最终是：

```txt
-vf "drawtext=text=this is a \\\\\\'string\\\\\\'\\\\: may contain one\\, or more\\, special characters"
```

## 5 时间轴编译

一些过滤器支持通用的 *enable* 选项。对于支持时间轴编辑的过滤器，这个选项可设置为一个表达式，该表达式在将帧发送到这个过滤器之前被计算。如果计算结果是非零，则启用过滤器，否则该帧不被修改发送到 filtergraph 中的下一过滤器。

表达式接受下面的规则：

- “t”: 时间戳，单位是秒，如果输入时间戳未知则为 NAN
- “n”: 输入帧的序列号，从 0 开始
- “pos”: 输入帧在文件中的位置，如果未知则为 NAN
- “w”/“h”: 如果输入帧是视频，则表示其宽度和高度

此外，这些过滤器支持 *enable* 命令，可用于重新定义表达式。

和其他过滤选项一样，*enable* 选项遵循相同的规则。

比如，要从 10 秒到 3 分钟启用一个 blur 过滤器([smartblur](http://ffmpeg.org/ffmpeg-filters.html#smartblur))，并在第 3 秒启用 [curves](http://ffmpeg.org/ffmpeg-filters.html#curves) 过滤器：

```sh
smartblur = enable='between(t,10,3*60)',
curves    = enable='gte(t,3)' : preset=cross_process
```

参阅 `ffmpeg -filters` 查看哪些过滤器支持时间轴。

## 8 音频过滤器

### 8.82 loudnorm

## 11 视频过滤器

### 11.62 drawtext

### 11.63 edgedetect

### 11.95 hflip

### 11.137 negate

### 11.147 overlay

### 11.150 pad

### 11.178 scale

## 14 视频 source

### 14.9 allrgb, allyuv, color, haldclutsrc, nullsrc, pal75bars, pal100bars, rgbtestsrc, smptebars, smptehdbars, testsrc, testsrc2, yuvtestsrc

## 16 多媒体过滤器

### 16.11 metadata, ametadata

### 16.15 sendcmd, asendcmd
