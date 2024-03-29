# 分组化基本流 PES

- [分组化基本流 PES](#分组化基本流-pes)
  - [缩略词](#缩略词)
  - [概述](#概述)
  - [PES 包头](#pes-包头)
  - [可选的 PES 头](#可选的-pes-头)
  - [参考](#参考)

原文 [Packetized elementary stream](https://en.wikipedia.org/wiki/Packetized_elementary_stream)

## 缩略词

```text
ES
  elementary stream, 基本流。
PES
  packetized elementary stream, 分组化基本流。PES 承载 ES，或非 MPEG 的编码流。
```

## 概述

在 MPEG-2 Part 1 (Systems) (ISO/IEC 13818-1) 和 ITU-T H.222.0 中定义 PES 规范，即在 MPEG PS 和 MPEG TS 中携带分包的 ES (通常是一个音频或视频编码器的输出)。通过从 ES 封装有序的的数据字节到 PES 包头，而将 ES 分组。

传递视频或音频编码器的 ES 数据的一个典型方法是先从 ES 数据创建一个 PES 包，然后封装这些 PES 包到 TS 包或 PS 包。TS 包又可以被多路复用然后使用广播技术传输，比如 QTSC 和 DVB 使用的。

TS 和 PS 逻辑上都是从 PES 包构造的。应使用 PES 包在 TS 和 PS 之间转换。在某些场景下，当执行这些转换时不需要修改 PES 包。PES 包可能比一个 TS 包更大。

## PES 包头

| 名称 | 大小 | 描述 |
| --- | --- | --- |
| 包起始码前缀 | 3 字节 | 0x000001 |
| 流 id | 1 字节 | 示例：**音频流(0xC0-0xDF)，视频流(0xE0-0xEF)** |
| - | - | 注意：上述 4 字节叫做 32 比特起始码 |
| PES 包长度 | 2 字节 | 指定这个域之后的剩余的字节数。可以是 0。如果 PES 包长度设为 0，那么 PES 包可为任意长度。PES 包长度的零值仅可用于当 PES 包负载是视频 ES |
| 可选 PES 头 | 可变长度(>=3) | 在填充流和私有流 2(导航数据)中不会出现 |
| 数据 | - | 查看 ES。在私有流中，载荷的第一个字节是子流的编号 |

如果流 id 属于下面的集合：program stream header、private stream、private stream 2、ECM、EMM、program stream directory、DSMCC stream、ITU-T Rec.H.222.1 type E stream。后面是 PES 包数据字节，长度为 8 的倍数。

如果流 id 是 padding stream，后面是填充字节，长度为 8 的倍数。

如果流 id 不属于上面的集合：program stream header、padding stream、private stream、private stream 2、ECM、EMM、program stream directory、DSMCC stream、ITU-T Rec.H.222.1 type E stream。表示存在可选的 PES 头。

## 可选的 PES 头

| 名称 | 大小 | 描述 |
| --- | --- | --- |
| PES 标记位 | 2 | 10 二进制 |
| PES 扰乱控制 | 2 | 00 表示没有扰乱 |
| 优先级 | 1 | - |
| 数据对齐标识 | 1 | 1 表示 PES 包头之后紧跟的是视频起始码或音频同步字 |
| 受版权保护的 | 1 | 1 表示是受版权保护的 |
| 原始的或拷贝的 | 1 | 1表示原始的 |
| PTS DTS 标识 | 2 | 11-二者都出现；01-禁用；10-只有 PTS；00-没有 PTS 或 DTS |
| ESCR 标记 | 1 | - |
| ES 速率标记 | 1 | - |
| DSM trick 模式标记 | 1 | - |
| 其他的拷贝信息标记 | 1 | - |
| CRC 标记 | 1 | - |
| 扩展标记 | 1 | - |
| PES 头长度 | 8 | 给出 PES 头的剩余字节数 |
| 可选域 | 可变长度 | 通过上述标记位确定 |
| 填充字节 | 可变长度 | 0xff |

关于可选域：虽然上述标记表示值被追加到可变长度的可选域，它们不能简单写入。比如，PTS (和 DTS) 从 33 比特扩展到 5 字节(40 比特)。如果只有 PTS，通过写入 0010b 实现，PTS 最重要的 3 比特、1、跟着是 15 比特、1、其他的 15 比特 和 1。如果 PTS 和 DTS 出现，前 4 比特是 0011，DTS 前 4 比特是 0001。其他追加的字节有类似但是不同的编码。

- 如果 `PTS DTS 标识` 是 `10`: 40 比特(5 字节)

  | 名称 | 大小 | 描述 |
  | --- | --- | --- |
  | 标记位 | 4 | 0010 |
  | PTS[32...30] | 3 | - |
  | 标记位 | 1 | - |
  | PTS[29...15] | 15 | - |
  | 标记位 | 1 | - |
  | PTS[14...0] | 15 | - |
  | 标记位 | 1 | - |

- 如果 `PTS DTS 标识` 是 `11`: 80 比特(10 字节)

  | 名称 | 大小 | 描述 |
  | --- | --- | --- |
  | 标记位 | 4 | 0011 |
  | PTS[32...30] | 3 | - |
  | 标记位 | 1 | - |
  | PTS[29...15] | 15 | - |
  | 标记位 | 1 | - |
  | PTS[14...0] | 15 | - |
  | 标记位 | 1 | - |
  | 标记位 | 4 | 0001 |
  | DTS[32...30] | 3 | - |
  | 标记位 | 1 | - |
  | DTS[29...15] | 15 | - |
  | 标记位 | 1 | - |
  | DTS[14...0] | 15 | - |
  | 标记位 | 1 | - |

- 如果 `ESCR 标记` 是 `1`: 48 比特(6 字节)

  | 名称 | 大小 | 描述 |
  | --- | --- | --- |
  | 预留 | 2 | - |
  | ESCR_base[32...30] | 3 | - |
  | 标记位 | 1 | - |
  | ESCR_base[29...15] | 15 | - |
  | 标记位 | 1 | - |
  | ESCR_base[14...0] | 15 | - |
  | 标记位 | 1 | - |
  | ESCR_extension | 9 | - |
  | 标记位 | 1 | - |

- 如果 `ES 速率标记` 是 `1`: 24 比特(4 字节)

  | 名称 | 大小 | 描述 |
  | --- | --- | --- |
  | 标记位 | 1 | - |
  | ES 速率 | 22 | - |
  | 标记位 | 1 | - |

- 如果 `DSM trick 模式标记` 是 `1`: 24 比特(4 字节)

  | 名称 | 大小 | 描述 |
  | --- | --- | --- |
  | trick 模式控制 | 3 | - |
  | - | - | 如果`trick 模式控制` 为 `fast_forward` |
  | field_id | 2 | - |
  | intra_slice_refresh | 1 | - |
  | frequency_truncation | 2 | - |
  | - | - | 如果`trick 模式控制` 为 `slow_motion` |
  | rep_cntrl | 5 | - |
  | - | - | 如果`trick 模式控制` 为 `freeze_frame` |
  | field_id | 2 | - |
  | reserved | 3 | - |
  | - | - | 如果`trick 模式控制` 为 `fast_reverse` |
  | field_id | 2 | - |
  | intra_slice_refresh | 1 | - |
  | frequency_truncation | 2 | - |
  | - | - | 如果`trick 模式控制` 为 `slow_reverse` |
  | rep_cntrl | 5 | - |
  | - | - | 其他 |
  | reserved | 5 | - |

- 如果 `其他的拷贝信息标记` 是 `1`: 8 比特(1 字节)

  | 名称 | 大小 | 描述 |
  | --- | --- | --- |
  | 标记位 | 1 | - |
  | 其他的拷贝信息 | 7 | - |

- 如果 `PES CRC 标记` 是 `1`: 16 比特(2 字节)

  | 名称 | 大小 | 描述 |
  | --- | --- | --- |
  | 先前的 PES 包 CRC | 16 | - |

- 如果 `PES 扩展标记` 是 `1`: 16 比特(2 字节)

  | 名称 | 大小 | 描述 |
  | --- | --- | --- |
  | PES 私有数据标志 | 1 | - |
  | pack 头域标志 | 1 | - |
  | 节目包序列计数标志 | 1 | - |
  | P-STD 缓冲区标志 | 1 | - |
  | 预留 | 3 | - |
  | PES 扩展标记 2 | 1 | - |
  | - | - | 如果 `PES 私有数据标志` 为 `1` |
  | PES 私有数据 | 128 | - |
  | - | - | 如果 `pack 头域标志` 为 `1` |
  | pack 域长度 | 8 | - |
  | pack 头 | - | - |
  | - | - | 如果 `节目包序列计数标志` 为 `1` |
  | 标记位 | 1 | - |
  | 节目包序列计数器 | 7 | - |
  | 标记位 | 1 | - |
  | MPEG1_MPEG2 标识 | 1 | - |
  | 原始填充长度 | 6 | - |
  | - | - | 如果 `P-STD 缓冲区标志` 为 `1` |
  | 标记位 | 2 | '01' |
  | P-STD 缓冲区比例 | 1 | - |
  | P-STD 缓冲区大小 | 13 | - |
  | - | - | 如果 `PES 扩展标记 2` 为 `1` |
  | 标记位 | 1 | - |
  | PES 扩展域长度 | 7 | - |
  | 流 id 扩展标识 | 1 | - |
  | - | - | 如果 `流 id 扩展标识` 为 `0` |
  | 流 id 扩展 | 7 | - |
  | 预留 | 8*PES 扩展域长度 | - |

- 接着是填充字节: 8*N1
- 接着是 PES 包数据字节: 8*N2

## 参考

- [Packetized elementary stream](https://en.wikipedia.org/wiki/Packetized_elementary_stream)
