# FFmpeg 过滤器文档

- [FFmpeg 过滤器文档](#ffmpeg-过滤器文档)
  - [1 描述](#1-描述)
  - [2 过滤介绍](#2-过滤介绍)
  - [3 graph2dot](#3-graph2dot)
  - [4 filtergraph 描述](#4-filtergraph-描述)
    - [4.1 filtergraph 语法](#41-filtergraph-语法)

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

filtergraph 中的每个过滤器是一个过滤器类的实例，这些过滤器类注册到应用中，定义了过滤器的功能和输入输出 pad 的数目。

没有输入 pad 的过滤器叫做 *source*，没有输出 pad 的过滤器叫做 *sink*。

### 4.1 filtergraph 语法
