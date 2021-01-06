# ffmpeg 相关命令

- [ffmpeg 相关命令](#ffmpeg-相关命令)
  - [常用帮助类和参数说明](#常用帮助类和参数说明)
  - [ffplay 命令](#ffplay-命令)
    - [ffplay 常用选项](#ffplay-常用选项)
    - [ffplay 示例](#ffplay-示例)
    - [ffplay 快捷键](#ffplay-快捷键)
  - [ffmpeg 命令](#ffmpeg-命令)
    - [ffmpeg 常用选项](#ffmpeg-常用选项)
      - [音频选项](#音频选项)
      - [视频选项](#视频选项)
    - [ffmpeg 示例](#ffmpeg-示例)
      - [推流](#推流)
      - [提取单个媒体流](#提取单个媒体流)
      - [视频截断](#视频截断)
      - [修改媒体信息](#修改媒体信息)
      - [合并视频](#合并视频)
        - [使用 -map 实现高级合并](#使用--map-实现高级合并)
  - [使用 libavfilter](#使用-libavfilter)
    - [graph2dot](#graph2dot)
    - [testsrc](#testsrc)

## 常用帮助类和参数说明

| 命令参数 | 功能 |
| --- | --- |
| -version | 显示版本 |
| -buildconf | 显示编译配置 |
| -protocols | 显示可用的协议 |
| -filters | 显示可用的过滤器 |
| -formats | 显示可用的格式 muxers+demuxers |
| -demuxers | 显示可用的解复用器 |
| -muxers | 显示可用的复用器 |
| -codecs | 显示可用的编解码器 decoders+encoders |
| -decoders | 显示可用的解码器 |
| -encoders | 显示可用的编码器 |
| -pix_fmts | 显示可用的像素格式 |
| -layouts | 显示标准声道名称和布局 |
| -sample_fmts | 显示可用的音频采样格式 |
| -colors | 显示可用的颜色名称 |
| -devices | 显示可用的设备 |
| -bsfs  | 显示可用的比特流 filter |

## ffplay 命令

### ffplay 常用选项

- `-v loglevel`: 或 `-loglevel loglevel`，设置日志等级，最高 48。日志等级划分

  ```h
  #define AV_LOG_QUIET    -8
  #define AV_LOG_PANIC     0
  #define AV_LOG_FATAL     8
  #define AV_LOG_ERROR    16
  #define AV_LOG_WARNING  24
  #define AV_LOG_INFO     32
  #define AV_LOG_VERBOSE  40
  #define AV_LOG_DEBUG    48
  ```

- `-f fmt`: 强制使用指定格式播放
- `-i input_file`: 读取指定文件

### ffplay 示例

```sh
# 播放承载 H.264 裸流的 UDP
ffplay -f h264 udp://233.233.233.223:6666
# 播放 MPEG2 裸流
ffplay -vcodec mpeg2video udp://233.233.233.223:6666
# 播放承载 H.264 裸流的 RTP
ffplay test.sdp
# 播放 YUV
ffplay -f rawvideo -video_size 352x288 foreman_cif.yuv
# 播放本地名称为 Integrated Camera 的摄像头(从设备管理器中查看相机名称)
ffplay -f dshow -i video="Integrated Camera"
# 播放 MPEG
ffplay -loglevel 48 -f mpeg test 1>log.txt 2>&1
# 播放 RTP
ffplay -loglevel 64 -f rtp rtp://192.168.1.10:7002 1>log.txt 2>&1
# 播放 USB 摄像头
ffplay /dev/video0
# 从摄像头拉取 RTSP 流进行播放
ffplay rtsp://admin:xxxxxx@192.168.10.100:554
```

- `1` 表示标准输出，`1>log.txt` 表示把标准输出定向到 log.txt 文件
- `2` 表示标准错误，`2>&1` 表示把标准错误定向到和标准输出相同的地方

### ffplay 快捷键

播放视音频文件的时候，可以通过下列按键控制视音频的播放

| 按键 | 作用 |
| --- | --- |
| q/ESC | 退出 |
| f | 全屏 |
| p/空格 | 暂停 |
| w | 显示音频波形 |
| s | 逐帧显示 |
| 左/右 | 向后10s/向前10s |
| 上/下 | 向后1min/向前1min |
| page down/page up | 向后10min/向前10min |
| 鼠标点击屏幕 | 跳转到指定位置(根据鼠标位置相对屏幕的宽度计算) |

## ffmpeg 命令

### ffmpeg 常用选项

关于选项和参数的顺序。除了 `-i xxx` 必须在最前面且输出文件必须在最后面，其他选项的顺序没有关系。但是选项与其参数不可分割。

- `-c copy`: 或 `-codec copy`，拷贝所有编解码器
- `-c:v`: 或 `-vcodec copy`，拷贝视频编解码器
- `-c:a`: 或 `-acodec copy`，拷贝音频编解码器
- `-f fmt (input/output)`: 强制输入或输出文件的使用指定格式
- `-i url (input)`: 指定输入文件的 URL。**在文件名包含空格或其他特殊字符的时候，必须用半角双引号包起来**
- `-re (input)`: 按照原始帧率读输入。主要用于模拟一个摄像头或直播输入流。ffmpeg 默认尝试尽可能快地读取输入
- `-ss pos`: 指定位置。单位秒，也支持 `hh:mm:ss.xxx` 格式
- `-t duration`: 限制输入/输出文件的时长，单位秒，也支持 `hh:mm:ss.xxx` 格式
- `-vframes number`: 指定输出的视频帧数量
- `-y`: 覆盖输出文件而不询问
- `-n`: 不要覆盖输出文件。如果已经存在立即退出
- `-help muxer=xxx`: 查看指定 muxer 的基本信息
- `-metadata`: 更改输出文件的元数据(标题、艺术家、专辑等)
- `-map input_index:stream_index`: 指定媒体流映射关系。[参考](#使用--map-实现高级合并)

#### 音频选项

- `-ar xxx`: 音频采样率，单位 Hz。**采样率只能变小，不能变大**
- `-an`: 去除音频
- `-vol xxx`: 相对源文件的音量大小。标准音量是 256，因此减小一半就是 128

#### 视频选项

- `-r xxx`: 视频帧率，单位 Hz，即“帧每秒”(fps)。**帧率只能变小，不能变大**
- `-s WxH`: 视频尺寸，单位是像素。格式是`宽度x高度`。比如 720P 是 `-s 1280x720`
- `-vn`: 去除视频
- `-vf filter_graph`: 给视频添加滤镜(颠倒、放大、改变颜色、模糊等)

### ffmpeg 示例

#### 推流

```sh
# 推 RTMP
ffmpeg -re -i source.flv -vcodec copy -acodec copy -f flv -y rtmp://127.0.0.1:1935/live/livestream
# 推 RTP
ffmpeg -re -i cw.ts -vcodec copy -acodec copy -f rtp_mpegts rtp://238.123.46.66:8001
# 推 UDP
ffmpeg -re -i cw.ts -vcodec copy -acodec copy -f mpegts  udp://238.123.46.66:8001
ffmpeg -re -i chunwan.h264 -vcodec copy -f rtp rtp://233.233.233.223:6666>test.sdp
# 边通过 SDL 播放视频，边发送视频流至 RTMP 服务器
ffmpeg -re -i chunwan.h264 -pix_fmt yuv420p –f sdl xxxx.yuv -vcodec copy -f flv rtmp://localhost/oflaDemo/livestream
```

`test.sdp` 用于将 ffmpeg 的输出信息存储成一个 sdp 文件。该文件用于 RTP 的接收。不加 `>test.sdp` 时，ffmpeg 会直接把 sdp 信息输出到控制台。将该信息复制出来保存成一个后缀是 `.sdp` 文本文件，也是可以用来接收该 RTP 流的。加上 `>test.sdp` 后，可以直接把这些 sdp 信息保存成文本。

#### 提取单个媒体流

```sh
# 只提取音频
ffmpeg -i summer.mp4 -vn -acodec copy audio.flv
# 只提取视频
ffmpeg -i summer.mp4 -an -vcodec copy video.flv
```

#### 视频截断

```sh
# 维持原视频文件的质量，相当于每秒一个 I 帧，在剪辑视频时作为输入文件可以保证时间的准确性
ffmpeg -i winter.mp4 -qscale 0 tmpw.mp4
# 截取 winter.mp4 中 1:27:54 开始的 5 分钟视频，保存到 juanxincai.mp4
ffmpeg -ss 1:27:54 -t 00:05:00 -i winter.mp4 -c copy juanxincai.mp4
# 把视频前 30 帧转成一个 gif
ffmpeg -i winter.mp4 -vframes 30 -y -f gif a.gif
# 截取多个视频片段
ffmpeg -ss 00:05:00 -t 00:00:30 -i winter.mp4 -c copy 1.mp4
ffmpeg -ss 00:06:00 -t 00:00:30 -i winter.mp4 -c copy 2.mp4
```

#### 修改媒体信息

```sh
# 修改媒体标题
ffmpeg -i summer.mp4 -c copy -metadata title="xiaosenlin" video.mp4
ffmpeg -i "no metadata.mp3" -c copy -metadata title="song name" -metadata artist="artist name" -metadata album="albun name" "with metadata.mp3"
```

#### 合并视频

```sh
# 合并视频。inputs.txt 文件内容: 描述要合并的视频片段
## file 1.mp4
## file 2.mp4
## file 3.mp4
ffmpeg -f concat -i inputs.txt -c copy concat.mp4
# 音视频合并
ffmpeg -i out.h264 -i out.aac -vcodec copy -acodec copy out.mp4
# 合并音视频和字幕文件(合并后的视频多了一个媒体流)：指定编码格式
ffmpeg -i "no subtitle.mp4" -i sub.srt -c:v copy -c:a copy -c:s ass "with subtitle.mkv"
# 合并音视频和字幕文件：使用目的文件的默认编码格式
ffmpeg -i "no subtitle.mp4" -i sub.srt "with subtitle.mkv"
# 合并音视频和字幕文件(合并后的字幕编入视频流)
ffmpeg -i "no subtitle.mp4" -vf subtitles=sub.srt "within subtitle.mkv"
## 运行上述命令报错：[AVFilterGraph @ 0x24a3780] No such filter: 'subtitles'
## 使用 subtitles 过滤器需要编译时添加 `--enable-libass`，先安装库
## sudo apt-get install -y libass-dev 
```

##### 使用 -map 实现高级合并

`-map` 的参数是 `输入文件编号:文件的媒体流编号`，指定一次代表该文件的指定媒体流会分配到输出文件，输出文件的流编号从 0 开始。输入文件的编号取决于 `-i` 的顺序，从 0 开始。

`-map` 选项可指定多次，从而依次指定输出的媒体流顺序，即第一次的 `-map` 指定的媒体流是输出文件的 0 号媒体流，第二次的 `-map` 指定的媒体流是输出文件的 1 号媒体流，以此类推。

```sh
# 将 file1.mp4 的视频流(编号是 0)和 file2.mp4 的音频流(编号是 1)合并成一个文件
## 需要先用 ffprobe 之类的命令查看文件的视频和音频流对应的编号
ffmpeg -i file1.mp4 -i file2.mp4 -map 0:0 -map 1:1 -c copy merge.mp4
```

## 使用 libavfilter

### graph2dot

```sh
# 编译 tools/graph2dot: 先切换到 ffmpeg 源码主目录
make tools/graph2dot
# 安装 graphviz 使用 dot
sudo apt install -y graphviz
# 测试 graph2dot
echo "nullsrc,scale=640:360,nullsink" | tools/graph2dot -o graph.tmp
dot -Tpng graph.tmp -o graph.png
display graph.png
```

- `graph.tmp` 内容：

```txt
digraph G {
node [shape=box]
rankdir=LR
"Parsed_nullsrc_0\n(nullsrc)" -> "Parsed_scale_1\n(scale)" [ label= "inpad:default -> outpad:default\nfmt:yuv420p w:320 h:240 tb:1/25" ];
"Parsed_scale_1\n(scale)" -> "Parsed_nullsink_2\n(nullsink)" [ label= "inpad:default -> outpad:default\nfmt:yuv420p w:640 h:360 tb:1/25" ];
}
```

- `graph.png` 如图：

![graph.png](ref/graph.png)

### testsrc

```sh
# 将视频的上半部分镜像复制到输出视频的下半部分
ffplay -f lavfi testsrc -vf "split [main], [main] overlay=0:H/2"
# 将视频的上半部分镜像映射到输出视频的下半部分
ffplay -f lavfi testsrc -vf "split [main][tmp]; [tmp] crop=iw:ih/2:0:0, vflip [flip]; [main][flip] overlay=0:H/2"
```
