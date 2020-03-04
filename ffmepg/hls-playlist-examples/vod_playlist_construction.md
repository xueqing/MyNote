# VOD playlist 构造

- [VOD playlist 构造](#vod-playlist-%e6%9e%84%e9%80%a0)
  - [概述](#%e6%a6%82%e8%bf%b0)
  - [示例](#%e7%a4%ba%e4%be%8b)
    - [EXTM3U](#extm3u)
    - [EXT-X-TARGETDURATION](#ext-x-targetduration)
    - [EXT-X-VERSION](#ext-x-version)
    - [EXT-X-MEDIA-SEQUENCE](#ext-x-media-sequence)
    - [EXTINF](#extinf)
    - [EXT-X-ENDLIST](#ext-x-endlist)
  - [相对路径](#%e7%9b%b8%e5%af%b9%e8%b7%af%e5%be%84)

## 概述

对于 VOD(video on demand, 点播) 会话，可以访问的媒体文件表示显示的整个时间段。索引文件是静态的，且包含相关 URL 的一个完整列表，可以访问从显示开始创建的所有媒体文件。这种会话支持用户对整个程序的完整控制。

## 示例

下面的代码是一个 VOD playlist 的示例：

```m3u8
#EXTM3U
#EXT-X-PLAYLIST-TYPE:VOD
#EXT-X-TARGETDURATION:10
#EXT-X-VERSION:4
#EXT-X-MEDIA-SEQUENCE:0
#EXTINF:10.0,
http://example.com/movie1/fileSequenceA.ts
#EXTINF:10.0,
http://example.com/movie1/fileSequenceB.ts
#EXTINF:10.0,
http://example.com/movie1/fileSequenceC.ts
#EXTINF:9.0,
http://example.com/movie1/fileSequenceD.ts
#EXT-X-ENDLIST
```

VOD playlist 示例中使用的标记有：

### EXTM3U

表明这个 playlist 是一个扩展的 M3U 文件。这种文件类型通过修改第一行标记为 EXTM3U 以区别于基本的 M3U 文件。所有的 HLS playlist 必须以这个标记开始。

### EXT-X-TARGETDURATION

指定最大的媒体文件时长。

### EXT-X-VERSION

表明该 playlist 文件的兼容性版本。playlist 媒体及其服务器必须遵守 HLS 规范的 IETF 互联网草案最新版本的所有规定，此规范定义了协议版本。

### EXT-X-MEDIA-SEQUENCE

表明出现在 playlist 文件的第一个 URL 的序列号。playlist 中的每个媒体文件 URL 有一个唯一的整数序列号。一个 URL 的序列号比前一个 URL 加 1。这个媒体序列号和文件名字无关。

**注意**：EXT-X-MEDIA-SEQUENCE 标记的值

### EXTINF

一个记录标识，描述了媒体文件，通过其后的 URL 标记该媒体文件。每个媒体文件 URL 前面必须有一个 EXTINF 标记。这个标记包含一个时长属性，是一个十进制的整数或浮点数，指定了这个媒体片段的时长(单位是秒)。这个时长属性的值必须不大于 EXT-X-TARGETDURATION 的值。

**注意**：总使用浮点的 EXTINF 时长(在协议版本 3 支持)。这支持客户端在流内部跳转(seek)时最小化四舍五入的差错。

### EXT-X-ENDLIST

表明不会再向 playlist 文件增加媒体文件了。

## 相对路径

上述的 VOD playlist 示例对于媒体文件 playlist 条目使用完整的路径名。虽然支持这么做，更鼓励使用相对路径。相对路径比绝对路径更易移植且相对于 playlist 文件的 URL。对于单个 playlist 条目使用完整路径名比使用相对路径经常导致文本更长。下面是使用相对路径的相同的 playlist：

```m3u8
#EXTM3U
#EXT-X-PLAYLIST-TYPE:VOD
#EXT-X-TARGETDURATION:10
#EXT-X-VERSION:4
#EXT-X-MEDIA-SEQUENCE:0
#EXTINF:10.0,
fileSequenceA.ts
#EXTINF:10.0,
fileSequenceB.ts
#EXTINF:10.0,
fileSequenceC.ts
#EXTINF:9.0,
fileSequenceD.ts
#EXT-X-ENDLIST
```
