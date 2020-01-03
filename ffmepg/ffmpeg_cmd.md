# ffmpeg 相关命令

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

## ffmpeg 命令

### ffmpeg 常用选项

- `-c copy`: 或 `-codec copy`，拷贝所有编解码器
- `-f fmt (input/output)`: 强制输入或输出文件的使用指定格式
- `-i url (input)`: 指定输入文件的 URL
- `-re (input)`: 按照原始帧率读输入。主要用于模拟一个摄像头或直播输入流。ffmpeg 默认尝试尽可能快地读取输入
- `-s position (input/output)`: 指定位置
- `-t duration (input/output)`: 限制输入输出的时长
- `-vframes number`: 指定输出的视频帧数量
- `-y`: 覆盖输出文件而不询问

### ffmpeg 示例

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
# 截取 winter.mp4 中 1:27:54 开始的 5 分钟视频，保存到 juanxincai.mp4
ffmpeg -ss 1:27:54 -t 00:05:00 -i winter.mp4 -c copy juanxincai.mp4
# 维持原视频文件的质量，相当于每秒一个 I 帧，在剪辑视频时作为输入文件可以保证时间的准确性
ffmpeg -i winter.mp4 -qscale 0 tmpw.mp4
# 把视频前 30 帧转成一个 gif
ffmpeg -i winter.mp4 -vframes 30 -y -f gif a.gif
```

`test.sdp` 用于将 ffmpeg 的输出信息存储成一个 sdp 文件。该文件用于 RTP 的接收。不加 `>test.sdp` 时，ffmpeg 会直接把 sdp 信息输出到控制台。将该信息复制出来保存成一个后缀是 `.sdp` 文本文件，也是可以用来接收该 RTP 流的。加上 `>test.sdp` 后，可以直接把这些 sdp 信息保存成文本。

```sh
# 截取多个视频片段
ffmpeg -ss 00:05:00 -t 00:00:30 -i winter.mp4 -c copy 1.mp4
ffmpeg -ss 00:06:00 -t 00:00:30 -i winter.mp4 -c copy 2.mp4
# 合并视频
ffmpeg -f concat -i inputs.txt -c copy concat.mp4
# inputs.txt 文件内容: 描述要合并的视频片段
file 1.mp4
file 2.mp4
# 音视频合并
ffmpeg -i out.h264 -i out.aac -vcodec copy -acodec copy out.mp4
```
