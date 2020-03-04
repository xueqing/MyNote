# 创建一个 master playlist

## 概述

master playlist 描述了对于你的内容所有可访问的 variant(变体)。每个 variant 是一个特定比特率的流版本且被包含在一个单独的 playlist。客户端基于测量的网络比特率切换到最合适的 variant。调节客户端的播放器最小化回放的停顿，以便给用户尽量好的流体验。

![hls master playlist](../hls/hls_master_playlist.png)

master playlist 不能重复读。一旦客户端读到 master playlist，它假定 variant 集合不会改变。当客户端在其中一个单一的 variant playlist 中看到 EXT-X-ENDLIST 标记时流结束。

## 示例

下面的示例展示了定义不同 variant 的一个 master playlist：

```m3u8
#EXTM3U
#EXT-X-STREAM-INF:BANDWIDTH=150000,RESOLUTION=416x234,CODECS="avc1.42e00a,mp4a.40.2"
http://example.com/low/index.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=240000,RESOLUTION=416x234,CODECS="avc1.42e00a,mp4a.40.2"
http://example.com/lo_mid/index.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=440000,RESOLUTION=416x234,CODECS="avc1.42e00a,mp4a.40.2"
http://example.com/hi_mid/index.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=640000,RESOLUTION=640x360,CODECS="avc1.42e00a,mp4a.40.2"
http://example.com/high/index.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=64000,CODECS="mp4a.40.5"
http://example.com/audio/index.m3u8
```

master playlist 示例中使用的标记有：

### EXTM3U

表明这个 playlist 是一个扩展的 M3U 文件。这种文件类型通过修改第一行标记为 EXTM3U 以区别于基本的 M3U 文件。所有的 HLS playlist 必须以这个标记开始。

### EXT-X-STREAM-INF

表示 playlist 文件的下一个 URL 标识了另一个 playlist 文件。EXT-X-STREAM-INF 标记包含下面的参数：

#### AVERAGE-BANDWIDTH

(可选，但是建议使用)一个整数，表示这个 variant 流的平均比特率。

#### BANDWIDTH

(必选)一个整数，表示对于每个媒体文件所有比特率的上限，单位是 比特/秒。上限值的计算包含了所有出现或将会出现在 playlist 中的容器负载。

#### FRAME-RATE

(可选，但是建议使用)一个浮点值，描述了一个 variant 流的最大帧率。

#### HDCP-LEVEL

(可选)表明使用的加密类型。有效值是 TYPE-0 和 NONE。如果只有使用 HDCP 保护输出才能播放这个流，使用 TYPE-0。

#### RESOLUTION

(可选，但是建议使用)这个选项展示了播放 playlist 所有视频的大小，单位是像素。所有包含视频的流都应该包含这个参数。

#### VIDEO-RANGE

(视编码而定)一个字符串，有效值是 SDR 或 PQ。如果没有指定传输特征编码 1, 16 或 18，那么必须忽视这个参数。

#### CODECS

(可选，但是建议使用)一个引用字符串，包含了一个逗号分隔的格式列表，其中每个格式指定了出现在 playlist 中的一个媒体片段的媒体采样类型。有效的格式标识是根据 RFC 6381 定义的 ISO 文件格式命名空间。

**注意**：虽然 CODECS 参数可选，每个 EXT-X-STREAM-INF 标记应该包含这个属性。这个属性提供了解码一个特定流所需的完整编码。它支持客户端区分只包含音频的 variant 和包含音频及视频的 variant。然后，客户端可以利用这个信息在切换流的时候提供更好的用户体验。
