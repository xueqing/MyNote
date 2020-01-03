# Event playlist 构造

- [Event playlist 构造](#event-playlist-%e6%9e%84%e9%80%a0)
  - [概述](#%e6%a6%82%e8%bf%b0)
  - [示例](#%e7%a4%ba%e4%be%8b)
    - [EXTM3U](#extm3u)
    - [EXT-X-PLAYLIST-TYPE](#ext-x-playlist-type)
    - [EXT-X-TARGETDURATION](#ext-x-targetduration)
    - [EXT-X-VERSION](#ext-x-version)
    - [EXT-X-MEDIA-SEQUENCE](#ext-x-media-sequence)
    - [EXTINF](#extinf)
  - [更新 playlist 文件](#%e6%9b%b4%e6%96%b0-playlist-%e6%96%87%e4%bb%b6)

## 概述

通过 EXT-X-PLAYLIST-TYPE 标记的值设为 EVENT 指定一个 event playlist。它起初没有 EXT-X-ENDLIST 标签，表示当新的媒体文件可访问时将会被加到 playlist。

## 示例

下面的代码是一个第一个出现在会话中的 event playlist 的示例：

```m3u8
#EXTM3U
#EXT-X-PLAYLIST-TYPE:EVENT
#EXT-X-TARGETDURATION:10
#EXT-X-VERSION:4
#EXT-X-MEDIA-SEQUENCE:0
#EXTINF:10.00,
fileSequence0.ts
#EXTINF:10.0,
fileSequence1.ts
#EXTINF:10.0,
fileSequence2.ts
#EXTINF:10.0,
fileSequence3.ts
#EXTINF:10.0,
fileSequence4.ts
```

event playlist 示例中使用的标记有：

### EXTM3U

表明这个 playlist 是 一个扩展的 M3U 文件。这种文件类型通过修改第一行标记为 EXTM3U 以区别于基本的 M3U 文件。所有的 HLS playlist 必须以这个标记开始。

### EXT-X-PLAYLIST-TYPE

提供了适用于整个 playlist 文件的易变信息。这个标记可能包含一个 EVENT 或 VOD 值。如果标记存在且值为 EVENT，服务器一定不能修改或删除 playlist 文件的任意部分(但是它可以追加行到 playlist 文件)。如果标记存在且值为 VOD，playlist 文件一定不能改变。

### EXT-X-TARGETDURATION

指定最大的媒体文件时长。

### EXT-X-VERSION

表明该 playlist 文件的兼容性版本。playlist 媒体及其服务器必须遵守 HLS 规范的 IETF 互联网草案最新版本的所有规定，此规范定义了协议版本。

### EXT-X-MEDIA-SEQUENCE

表明出现在 playlist 文件的第一个 URL 的序列号。playlist 中的每个媒体文件 URL 有一个唯一的整数序列号。一个 URL 的序列号比前一个 URL 加 1。这个媒体序列号和文件名字无关。

### EXTINF

一个记录标识，描述了媒体文件，通过其后的 URL 标记该媒体文件。每个媒体文件 URL 前面必须有一个 EXTINF 标记。这个标记包含一个时长属性，是一个十进制的整数或浮点数，指定了这个媒体片段的时长(单位是秒)。这个时长属性的值必须不大于 EXT-X-TARGETDURATION 的值。

**注意**：总使用浮点的 EXTINF 时长(在协议版本 3 支持)。这支持客户端在流内部跳转(seek)时最小化四舍五入的差错。

## 更新 playlist 文件

当使用 EVENT 标记时，你不能从 playlist 中删除任何东西；你只可能追加新的片段到文件直到这个事件终止，那是会追加一个 EXT-X-ENDLIST 标签。下面的示例展示了使用新的媒体 URL 更新且该事件已经终止的同一 playlist：

```m3u8
#EXTM3U
#EXT-X-PLAYLIST-TYPE:EVENT
#EXT-X-TARGETDURATION:10
#EXT-X-VERSION:4
#EXT-X-MEDIA-SEQUENCE:0
#EXTINF:10.0,
fileSequence0.ts
#EXTINF:10.0,
fileSequence1.ts
#EXTINF:10.0,
fileSequence2.ts
#EXTINF:10.0,
fileSequence3.ts
#EXTINF:10.0,
fileSequence4.ts

// List of files between 4 and 120 go here.

#EXTINF:10.0,
fileSequence120.ts
#EXTINF:10.0,
fileSequence121.ts
#EXT-X-ENDLIST
```

大概你想要支持用户跳转到事件内的任何一点时，比如一个音乐会或者运动事件，通常使用 event playlist。
