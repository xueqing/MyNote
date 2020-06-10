# AAC 添加 RTP 封装

- [AAC 添加 RTP 封装](#aac-添加-rtp-封装)
  - [过程](#过程)
  - [封装格式](#封装格式)
  - [AU-headers-length](#au-headers-length)
  - [AU-header](#au-header)

## 过程

- 去掉 7 个 字节的 ADTS 头，如果存在的话
- 添加 12 字节的 RTP-header
- 添加 2 字节的 AU-headers-length
- 添加 2 字节的 AU-header
- 从第 17 个字节开始是 payload(去掉 ADTS 的 AAC)

## 封装格式

一个 RTP 包可以有一个 AU-headers-length 和 N 个 AU-header 和 N 个 AU。

- 首先是一个 AU-headers-length
- 一个 AU-header (2 字节) 和一个 AU (去掉 ADTS 的 aac 音频数据)
- 其他 AU-header 和对应的 AU

## AU-headers-length

长度为 2 个字节，单位是 bit。一个 AU-header 是 2 个字节(16 bit)，因为可以有多个 AU-header，所以 AU-headers-length 是 16 的倍数。

一般是发送单个音频数据，所以 AU-headers-length 是 16，即只有一个 AU-header。

```c
//AU_HEADER_LENGTH
header[12] = 0x00; //高位
header[13] = 0x10; //低位
```

## AU-header

高 13 位表示一个 AU 的字节长度。

```c
//AU_HEADER
header[14] = (byte)((len & 0x1fe0) >> 5); //高位
header[15] = (byte)((len & 0x1f) << 3); //低位
```
