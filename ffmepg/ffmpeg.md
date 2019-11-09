# FFMPEG/FFPLAY 源码剖析

## 播放器一般原理

Windows DirectShow

- 媒体文件基本模块：读文件、解复用、视频解码、音频解码、颜色空间转换、视频显示、音频播放
- 模块：过滤器 filter。
  - 输入输出：pin，管脚。input pin 和 output pin
    - source filter 和 sink filter
  - filter 组成 graph。媒体文件的数据流在 graph 中流动
- source filter：
- demux filter：
- decoder filter：
- color space converter filter：
- render filter：
