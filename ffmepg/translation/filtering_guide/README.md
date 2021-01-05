# FFmpeg 过滤指南

- [FFmpeg 过滤指南](#ffmpeg-过滤指南)
  - [文档](#文档)
  - [过滤器语法](#过滤器语法)
    - [Filtergraph、Chain、Filter 的关系](#filtergraphchainfilter-的关系)
    - [转义字符](#转义字符)
  - [示例](#示例)
    - [缩放](#缩放)
    - [加速视频](#加速视频)
    - [2x2 网格中叠加多个输入](#2x2-网格中叠加多个输入)
    - [写入时间码](#写入时间码)
    - [合成输入](#合成输入)
    - [其他过滤器示例](#其他过滤器示例)
  - [过滤器元数据](#过滤器元数据)
  - [脚本化过滤器](#脚本化过滤器)
    - [使用文件](#使用文件)
    - [使用 shell 脚本](#使用-shell-脚本)
  - [开发自己的过滤器](#开发自己的过滤器)
  - [可视化过滤器](#可视化过滤器)
  - [附件](#附件)

翻译[原文](https://trac.ffmpeg.org/wiki/FilteringGuide)。

FFmpeg 可以访问很多过滤器，并且会定期添加更多过滤器。使用 `ffmpeg -filters` 查看你的 FFmpeg 构建版本支持的过滤器。

## 文档

参考 [FFmpeg 过滤器文档](../ffmpeg_filters.md)获取每个过滤器的更多信息和示例。此维基页面用于用户提供示例和技巧，并且鼓励所有人优化此页面。

## 过滤器语法

当文档提及`过滤器选项`，或者说`过滤器接受下面的选项`，这些选项的用法正如 “FFmpeg 过滤器: 4.1 [Filtergraph](../ffmpeg_filters.md#41-filtergraph-语法) 语法”章节中描述的。简而言之，在过滤器名称之后，添加一个 `=`，然后是第一个过滤器选项的名字，一个 `=`，接着是该选项对应的值。如果想要指定更多选项，使用 `:` 分隔符，然后追加下一个选项的名称，一个 `=`，然后是这个新选项的值。

比如，将 [loudnorm 过滤器](../ffmpeg_filters.md#882-loudnorm)应用到一个音频流，基本语法是：

```sh
ffmpeg -i input -filter:a loudnorm output
```

使用下面的语法添加 `print_format` 和 `linear` 选项：

```sh
ffmpeg -i inout -filter:a loudnorm=print_format=summary:linear=true output
```

正如 “FFmpeg 过滤器: 4.1 [Filtergraph](../ffmpeg_filters.md#41-filtergraph-语法) 语法”章节中描述的，你可以省略选项名称和 `=`，只提供选项值，国歌选项值用`:` 分隔。比如，下面的命令：

```sh
ffmpeg -i input -vf scale=iw/2:-1 output
```

FFmpeg 按照源代码中声明的选项顺序匹配选项名。比如，在上述 [scale 过滤器](../ffmpeg_filters.md#11178-scale)的使用示例中，FFmpeg 认为 `width` 选项的值是 `iw/2`，`height` 选项的值是 `-1`。

### Filtergraph、Chain、Filter 的关系

ffmpeg 命令行中跟在 `-vf` 之后的是 [filtergraph](../ffmpeg_filters.md#4-filtergraph-描述) 描述。这个 filtergraph 可以包含多个 chain，每个 chain 可以包含多个 filter。

虽然的完整的 filtergraph 描述可能很复杂，但是如果可以避免混淆，可以将比较简单的 filtergraph 描述简单化。

请记住使用 `,` 分隔一个 chain 中的 filter，使用 `;` 分隔多个 chain。此外，如果未指定输入或输出，则假定输入来自 chain 的前一项，或者输出到 chain 的后一项。

下面的命令是等价的：

```sh
ffmpeg -i input -vf [in]scale=iw/2:-1[out] output
# 隐含输入和输出不会有歧义
ffmpeg -i input -vf scale=iw/2:-1 output
```

```sh
# 2 个 chain：每个 chain 包含一个 filter，通过 [middle] pad 连接两个 chain
ffmpeg -i input -vf [in]yadif=0:0:0[middle];[middle]scale=iw/2:-1[out] output
# 1 个 chain：chain 包含 2 个 filter, 隐式连接 filter
ffmpeg -i input -vf [in]yadif=0:0:0,scale=iw/2:-1[out] output
# 隐含输入和输出不会有歧义
ffmpeg -i input -vf yadif=0:0:0,scale=iw/2:-1  output
```

### 转义字符

正如文档所述，有时候需要转义出现在参数中的 `,`，比如下面的 select 过滤器：

```sh
# 只选择 I 帧
ffmpeg -i input -vf select='eq(pict_type\,I)' -vsync vfr output_%04d.png
```

但是，你也可以使用双引号 `""` 将整个 filtergraph 引起来，这种方式支持 filtergraph 内部包含空格，也有助于清晰阅读复杂的 filtergraph。因此：

```sh
# 只选择 I 帧
ffmpeg -i input -vf "select='eq(pict_type,I)'" output
# 去隔行再调整大小
ffmpeg -i input -vf "yadif=0:-1:0, scale=iw/2:-1" output
```

请注意，文档中给出的示例混合匹配使用了“全引号”和“\”转义，并且在特殊的 shell 使用转义可能比较复杂。有关更多信息，参考 [filtergraph 转移的注意事项](../ffmpeg_filters.md#42-关于-filtergraph-转移的注意事项)。

## 示例

### 缩放

从简单的操作开始。将 640x480 的输入调整为 320x240 的输出：

```sh
ffmpeg -i input -vf scale=iw/2:-1 output
```

`iw` 是输入的宽度。在这个示例中输入宽度是 640，且 640/2=320。`-1` 告诉 scale 过滤器保留输出的原长宽比，因此这个示例中 scale 过滤器选择 240.有关更多信息查看 [FFmpeg 文档](../ffmpeg_filters.md#11178-scale)。

### 加速视频

查看[如何加快/减慢视频](https://trac.ffmpeg.org/wiki/How%20to%20speed%20up%20/%20slow%20down%20a%20video)获取更多示例。

### 2x2 网格中叠加多个输入

![multiple_input_overlay](multiple_input_overlay.jpg)

这里使用 `-filter_complex` 选项将 4 个输入一起过滤。在这个示例中，所有输入都是 `-f lavfi -i testsrc`(查看 [testsrc source 过滤器](../ffmpeg_filters.md#149-allrgb-allyuv-color-haldclutsrc-nullsrc-pal75bars-pal100bars-rgbtestsrc-smptebars-smptehdbars-testsrc-testsrc2-yuvtestsrc))，但也可以是其他输入。

在 filtergraph 内部，第一个输入没有更改，其他三个输入分别使用 [hflip](../ffmpeg_filters.md#1195-hflip)、[negate](../ffmpeg_filters.md#11137-negate) 和 [edgedetect](../ffmpeg_filters.md#1163-edgedetect) 过滤。然后使用 hstack 和 vstack 过滤器将每个视频入栈到所需的位置。

```sh
ffmpeg -f lavfi -i testsrc -f lavfi -i testsrc -f lavfi -i testsrc -f lavfi -i testsrc -filter_complex \
"[1:v]negate[a]; \
 [2:v]hflip[b]; \
 [3:v]edgedetect[c]; \
 [0:v][a]hstack=inputs=2[top]; \
 [b][c]hstack=inputs=2[bottom]; \
 [top][bottom]vstack=inputs=2[out]" -map "[out]" -c:v ffv1 -t 5 multiple_input_grid.avi
```

下一个示例等同于上述示例，但是使用了 [pad](../ffmpeg_filters.md#11150-pad) 和 [overlay](../ffmpeg_filters.md#11147-overlay) 过滤器。pad 过滤器用于生成合适大小的背景，而 overlay 过滤器用于将每个视频放在正确的位置。这个方法比上述使用 `hstack+vstack` 慢：

```sh
ffmpeg -f lavfi -i testsrc -f lavfi -i testsrc -f lavfi -i testsrc -f lavfi -i testsrc -filter_complex \
"[0:v]pad=iw*2:ih*2[a]; \
 [1:v]negate[b]; \
 [2:v]hflip[c]; \
 [3:v]edgedetect[d]; \
 [a][b]overlay=w[x]; \
 [x][c]overlay=0:h[y]; \
 [y][d]overlay=w:h[out]" -map "[out]" -c:v ffv1 -t 5 multiple_input_grid.avi
```

请注意，每个输入视频的帧是按照时间顺序取出的，因此通过给所有 overlay 输入传递一个 `setpts=PTS-STARTPTS` 过滤器，以便所有输入从相同的零时间戳开始是比较好的做法，比如 `[0:v]hflip,setpts=PTS-STARTPTS[a];[1:v]setpts=PTS-STARTPTS[b];[a][b]overlay`。

### 写入时间码

使用 [drawtext](../ffmpeg_filters.md#1162-drawtext) 视频过滤器。

PAL 25 fps 非丢帧：

```sh
ffmpeg -i in.mp4 -vf "drawtext=fontfile=/usr/share/fonts/truetype/DroidSans.ttf: timecode='09\:57\:00\:00': r=25: \
x=(w-tw)/2: y=h-(2*lh): fontcolor=white: box=1: boxcolor=0x00000000@1" -an -y out.mp4
```

NTSC 30 fps 丢帧:

```sh
# 在帧数前将 : 修改为 ;
ffmpeg -i in.mp4 -vf "drawtext=fontfile=/usr/share/fonts/truetype/DroidSans.ttf: timecode='09\:57\:00\;00': r=30: \
x=(w-tw)/2: y=h-(2*lh): fontcolor=white: box=1: boxcolor=0x00000000@1" -an -y out.mp4
```

### 合成输入

[testsrc 源过滤器](../ffmpeg_filters.md#149-allrgb-allyuv-color-haldclutsrc-nullsrc-pal75bars-pal100bars-rgbtestsrc-smptebars-smptehdbars-testsrc-testsrc2-yuvtestsrc)生成一个测试视频模式，该模式显示一个颜色模式，一个滚动渐变和一个时间戳。它在测试时非常有用。

这个示例会创建一个 10 秒的输出，30 fps(一共 300 帧)，且帧大小为 1280x720：

```sh
ffmpeg -f lavfi -i testsrc=duration=10:size=1280x720:rate=30 output.mpg
```

也可使用 `ffplay` 查看生成的 filtergraph：

```sh
ffplay -f lavfi -i "testsrc=duration=10:size=1280x720:rate=30"
```

也可以指定 testsrc 作为一个过滤器：

```sh
ffmpeg -filter_complex testsrc OUTPUT
```

testsrc 的另一种类型是使用 [smptebars 源过滤器](../ffmpeg_filters.md#149-allrgb-allyuv-color-haldclutsrc-nullsrc-pal75bars-pal100bars-rgbtestsrc-smptebars-smptehdbars-testsrc-testsrc2-yuvtestsrc)：

```sh
ffmpeg -f lavfi -i "smptebars=duration=5:size=1280x720:rate=30" output.mp4
```

或者是使用 color：

```sh
./ffmpeg -f lavfi -i color=c=red:size=100x100
```

生成合成视频输入还有其他选项，参考[没有实际的输入文件如何直接从 FFmpeg 过滤器生成视频文件](http://stackoverflow.com/questions/11640458/how-can-i-generate-a-video-file-directly-from-an-ffmpeg-filter-with-no-actual-in)和[使用ffmpeg 创建视频和音频噪声、伪像和错误](http://stackoverflow.com/a/15795112/32453)(“通用方程式”过滤器)。

### 其他过滤器示例

- [花式过滤示例](https://trac.ffmpeg.org/wiki/FancyFilteringExamples)——各种迷幻效果和其他怪异过滤的示例
- [Null](https://trac.ffmpeg.org/wiki/Null)——描述 nullsink 过滤器

## 过滤器元数据

过滤器可以写入元数据条目，这些条目可用于调试过滤器的功能，或者从输入文件中提取额外的信息。通用描述可查看[元数据过滤器文档](../ffmpeg_filters.md#1611-metadata-ametadata)。

元数据的键由相应的过滤器定义，并且没有全局可访问的列表。过滤器文档本身提到一些键：

| 过滤器 | 键 | 描述|
| --- | --- | --- |
| aphasemeter | phase | - |
| astats | Bit_depth2 | - |
| astats | Bit_depth | - |
| astats | Crest_factor | - |
| astats | DC_offset | - |
| astats | Dynamic_range | - |
| astats | Flat_factor | - |
| astats | Max_difference | - |
| astats | Max_level | - |
| astats | Mean_difference | - |
| astats | Min_difference | - |
| astats | Min_level | - |
| astats | Overall.Bit_depth2 | - |
| astats | Overall.Bit_depth | - |
| astats | Overall.DC_offset | - |
| astats | Overall.Flat_factor | - |
| astats | Overall.Max_difference | - |
| astats | Overall.Max_level | - |
| astats | Overall.Mean_difference | - |
| astats | Overall.Min_difference | - |
| astats | Overall.Min_level | - |
| astats | Overall.Number_of_samples | - |
| astats | Overall.Peak_count | - |
| astats | Overall.Peak_level | - |
| astats | Overall.RMS_difference | - |
| astats | Overall.RMS_level | - |
| astats | Overall.RMS_peak | - |
| astats | Overall.RMS_trough | - |
| astats | Peak_count | - |
| astats | Peak_level | - |
| astats | RMS_difference | - |
| astats | RMS_level | - |
| astats | RMS_peak | - |
| astats | RMS_trough | - |
| astats | Zero_crossings_rate | - |
| astats | Zero_crossings | - |
| bbox | h | - |
| bbox | w | - |
| bbox | x1 | - |
| bbox | x2 | - |
| bbox | y1 | - |
| bbox | y2 | - |
| blackframe | pblack | - |
| cropdetect | h | - |
| cropdetect | w | - |
| cropdetect | x1 | - |
| cropdetect | x2 | - |
| cropdetect | x | - |
| cropdetect | y1 | - |
| cropdetect | y2 | - |
| cropdetect | y | - |
| ebur128 | r128.I | - |
| ebur128 | r128.LRA.high | - |
| ebur128 | r128.LRA.low | - |
| ebur128 | r128.LRA | - |
| ebur128 | r128.M | - |
| ebur128 | r128.S | - |
| freezedetect | freeze_duration | freeze 周期的持续时间 |
| freezedetect | freeze_end | freeze 周期的结束时间 |
| freezedetect | freeze_start | freeze 周期的起始时间 |
| psnr | mse.u | - |
| psnr | mse.v | - |
| psnr | mse.y | - |
| psnr | mse_avg | - |
| psnr | psnr.u | - |
| psnr | psnr.v | - |
| psnr | psnr.y | - |
| psnr | psnr_avg | - |
| signalstats | HUEAVG | - |
| signalstats | HUEMED | - |
| signalstats | key | - |
| signalstats | SATAVG | - |
| signalstats | SATHIGH | - |
| signalstats | SATLOW | - |
| signalstats | SATMAX | - |
| signalstats | SATMIN | - |
| signalstats | UAVG | - |
| signalstats | UBITDEPTH | - |
| signalstats | UDIF | - |
| signalstats | UHIGH | - |
| signalstats | ULOW | - |
| signalstats | UMAX | - |
| signalstats | UMIN | - |
| signalstats | VAVG | - |
| signalstats | VBITDEPTH | - |
| signalstats | VDIF | - |
| signalstats | VHIGH | - |
| signalstats | VLOW | - |
| signalstats | VMAX | - |
| signalstats | VMIN | - |
| signalstats | YAVG | - |
| signalstats | YBITDEPTH | - |
| signalstats | YDIF | - |
| signalstats | YHIGH | - |
| signalstats | YLOW | - |
| signalstats | YMAX | - |
| signalstats | YMIN | - |
| silencedetect | silence_duration | silence 周期的持续时间 |
| silencedetect | silence_end | silence 周期的结束时间 |
| silencedetect | silence_start | silence 周期的开始时间 |
| ssim | All | - |
| ssim | dB | - |
| ssim | u | - |
| ssim | v | - |
| ssim | y | - |

## 脚本化过滤器

### 使用文件

假定你想要基于一个输入文件修改一些过滤器参数。一些过滤器支持使用 [sencmd](../ffmpeg_filters.md#1615-sendcmd-asendcmd) 选项接受命令。运行 `ffmpeg -filters` 并检查 `C` 列——如果存在 `C`，该过滤器支持这种方式输入。

比如，如果你想对输入文件的 0、1、2 秒进行旋转。创建 `cmd.txt` 文件，包含下面的内容：

```sh
0 rotate angle '45*PI/180';
1 rotate angle '90*PI/180';
2 rotate angle '180*PI/180';
```

现在运行一个示例流：

```sh
ffmpeg -f lavfi -i testsrc -filter_complex "[0:v]sendcmd=f=cmd.txt,rotate" -f matroska - | ffplay -
```

可以查看 [ffmpeg 的 sendcmd](https://stackoverflow.com/a/49600924/435093) 获取此用法的更多示例。

### 使用 shell 脚本

当构建复杂的 filtergraph 时，使用 shell 脚本有助于将命令分成可管理的部分。但是，将这些部分全部结合到一起时需要注意转义字符的问题。

下面的示例显示了一个简单的 bash 脚本，该脚本包含一个 filtergraph，该 filtergraph 有一个chain，这个 chain 包含三个 filter：yadif、scale 和 drawtext。

```sh
#!/bin/bash

# ffmpeg 测试脚本
path="/path/to/file/"

in_file="in.mp4"
out_file="out.mp4"

cd $path

filter="yadif=0:-1:0, scale=400:226, drawtext=fontfile=/usr/share/fonts/truetype/DroidSans.ttf: \
text='tod- %X':x=(w-text_w)/2:y=H-60 :fontcolor=white :box=1:boxcolor=0x00000000@1"
codec="-vcodec libx264  -pix_fmt yuv420p -b:v 700k -r 25 -maxrate 700k -bufsize 5097k"

command_line=(ffmpeg -i "$in_file" -vf "$filter" "$codec" -an $out_file")

echo "${command_line[@]}"
"${command_line[@]}"
exit
```

请注意，这个 filtergraph 跨越多行。echo 命令显示了执行的完整命令。这有助于调试。

`$command_line` 变量中的数组有助于避免引号丢失的问题。其他 shell 的结果可能不相同。

## 开发自己的过滤器

- 查看 [FFmpeg 过滤器机制](../ffmpeg_filter_howto.md)

## 可视化过滤器

有时候 `ffmpeg` 在 filtergraph 中插入不同的 filter (比如像素格式转换过滤器)以便 filtergraph 可以正常工作。可以运行类似 `ffmpeg -loglvel debug ...` 的命令查看实际发生了什么。有助于查看自动插入的过滤器。

通过运行类似 `graph2dot "my filter graph"` 的命令，你也可以看到 filtergraph 有趣的图形表示。

如果你可以转换到 `lavfi` 语法(`ffmpeg -dumpgraph 1 -f lavfi -i ...`)，也可以使用 `dumpgraph` 选项，可以输出 filtergraph 漂亮的 ASCII 图形。

## 附件

- [multiple_input_overlay.jpg](multiple_input_overlay.jpg)——llogan [8 年前](https://trac.ffmpeg.org/timeline?from=2012-10-18T06%3A37%3A22%2B03%3A00&precision=second)添加。
