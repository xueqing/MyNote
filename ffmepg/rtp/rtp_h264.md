# H.264 添加 RTP 封装

- [H.264 添加 RTP 封装](#h264-添加-rtp-封装)
  - [术语](#术语)
  - [H.264 编解码](#h264-编解码)
  - [参数集概念](#参数集概念)
  - [rtp6184 重要关系梳理](#rtp6184-重要关系梳理)
    - [RTP 头部](#rtp-头部)
    - [NAL](#nal)
      - [NAL 单元头部](#nal-单元头部)
      - [单 NAL 单元数据包](#单-nal-单元数据包)
      - [聚合包](#聚合包)
        - [单时间聚合单元 STAP](#单时间聚合单元-stap)
        - [多时间聚合单元 MTAP](#多时间聚合单元-mtap)
      - [分片单元(FU)](#分片单元fu)
    - [解包过程](#解包过程)
  - [参考](#参考)

## 术语

```txt
NALUs
  Network Abstraction Layer Units
VCL
  Video Coding Layer, 视频编码层
NAL
  Network Abstraction Layer, 网络抽象层
Parameter Set
  参数集
SPS
  sequence parameter set, 序列参数集
PPS
  picture parameter set, 图像参数集
```

## H.264 编解码

H.264 的算法在概念上可以分为两层：VCL 和 NAL。

VCL 包含编解码的信号处理功能；一些机制比如转换、量化和运动补偿预测；一个循环滤波器。它遵循大多数当下的视频编解码器，一个基于宏块的编码器，使用带运动补偿和变换的图像间预测剩余信号的编码。VCL 编码器输出 slice：一个比特串，包含整数个宏块的宏块数据以及 slice 头域(包含 slice 中第一个宏块的空间地址，初始化量化参数，以及类似的信息)的信息。slice 中的宏块按照扫描顺序组织，除非使用 slice 组的语法指定分配一个不同的宏块。图像内预测只用于一个 slice 内部。

NAL 编码器将 VCL 编码器的 slice 输出封装到 NALUs 中。NALUs 适用于通过包网络传输，也适用于在面向包复用的环境中使用。

NAL 内部使用 NAL 单元。一个 NAL 单元包含一个字节头和载荷字节串。头指示 NAL 单元的类型，NAL 单元中(可能)出现的比特错误或语法冲突，以及解码处理相关的相关信息。

H.264 一个主要的特点是将 slice 和图像的传输时间、解码时间、采样时间、演示时间完全解耦合。H.264 的解码过程不关注时间，H.264 语法不携带跳过的帧数信息。而且有一些 NAL 单元会影响很多图像，是持久的。出于此，对一些 NAL 单元，未定义采样或演示时间，或者传输时间未知的，RTP 时间戳的处理需要特别考虑。

## 参数集概念

H.264 一个非常基础的设计概念是生成自我包含的包。这通过将和多余 slice 相关的信息从媒体流中解耦合。这个上层的元信息应该被可靠地异步传输，且在包含 slice 包的 RTP 包流之前发送。这些上层参数的组合称为一个参数集(parameter set)。

H.264 包含两种参数集：SPS 和 PPS。一个活跃的 SPS 在一个编码的视频序列中是固定的，一个活跃的 PPS 在一个编码的图像内保持不变。 SPS 和 PPS 结构保存了比如图片大小、可选编码模式和 slice 组的宏块信息。

## rtp6184 重要关系梳理

### RTP 头部

根据 [RFC 3550](https://tools.ietf.org/pdf/rfc3550) 的 RTP 头部

```txt
 0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|V=2|P|X|   CC  |M|     PT      |       sequence number         |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                           timestamp                           |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|           synchronization source (SSRC) identifier            |
+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+
|            contributing source (CSRC) identifiers             |
|                           ....                                |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```

RTP 包的前 12 个字节是固定出现的，CSRC 列表只有在混合器插入时出现。

### NAL

NAL 编码器将 VCL 编码器的 slice 输出封装到网络抽象层单元(NALU)中，这些 NALU 适用于通过分组网络传输或用于面向分组的多路复用环境。

NAL 内部使用 NAL 单元。NAL 单元包含一个字节的头和载荷字节串。头部指示 NAL 单元的类型、NAL 单元载荷中(潜在)的位错误或语法违规，以及解码过程中有关 NAL 单元的相对重要性信息。

#### NAL 单元头部

```txt
+---------------+
|0|1|2|3|4|5|6|7|
+-+-+-+-+-+-+-+-+
|F|NRI|   Type  |
+---------------+
```

NRI: 2 位 nal_ref_idc。00 值 表示 NAL 单元的内容不用于重构用于图片间预测的参考图片。可以丢弃此类 NAL 单元，而不会影响参考图片的完整性。大于 00 的值表示需要对 NAL 单元进行解码以保持参考图片的完整性。

NRI 的值指示相对传输优先级，由编码器确定。MANE 可使用此信息保护更加重要的 NAL 单元。最高的传输优先级是 11，之后是 10，然后是 01；最后，00 优先级最低。

nal_unit_type 和 nal_ref_id 值的关系：

- nal_unit_type 是 1-4(包含 1 和 4)，如果有一个图像的某个 NAL 单元的 NRI 为 0，那么该图像的所有 nal_unit_type 在 1-4(包含 1 和 4)范围内的 NAL 单元的 NRI 都是 0
- nal_unit_type 是 5(IDR)/7(SPS)/8(PPS)，NRI 等于 11(二进制)
- nal_unit_type 是 6/9/10/11/12，NRI 等于 0
- nal_unit_type 是 13-23(包括 13 和 23)，NRI 值没有建议，因为这些值是 ITU-T 和 ISO/IEC 保留的
- nal_unit_type 是 24-29(包括 24 和 29)，NRI 值**必须**是聚合包中携带的所有 NAL 单元的最大值
- nal_unit_type 是 0 或 30-31(包括 30 和 31)，NRI 值没有建议，因为这些值的语义在此文中没有指定

NAL 单元头部 Type 值和对应包类型

| NAL 单元类型 | 包类型 | 包类型名称 | 章节 |
| --- | --- | --- | --- |
| 0 | 保留 |  | - |
| 1-23 | NAL 单元 | 单 NAL 单元数据包 | 5.6 |
| 24 | STAP-A | 单时间聚合数据包 | 5.7.1 |
| 25 | STAP-B | 单时间聚合数据包 | 5.7.1 |
| 26 | MTAP16 | 多时间聚合数据包 | 5.7.2 |
| 27 | MTAP24 | 多时间聚合数据包 | 5.7.2 |
| 28 | FU-A | 分片单元 | 5.8 |
| 29 | FU-B | 分片单元 | 5.8 |
| 30-31 | 保留 |  | - |

#### 单 NAL 单元数据包

这里定义的单 NAL 单元数据包**必须**仅包含一个 NAL 单元。这意味着单 NAL 单元数据包内不能使用聚合包或分片单元。按 RTP 序列号对单 NAL 单元数据包进行解包组成的 NAL 单元流必须符合 NAL 单元解码顺序。

NAL 单元的第一个字节共同作为 RTP 载荷的头部。

单 NAL 单元数据包的 RTP 载荷格式

```txt
 0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|F|NRI|  TYPE   |                                               |
+-+-+-+-+-+-+-+-+                                               |
|                                                               |
|               Bytes 2...n of a singe NAL unit                 |
|                                                               |
|                               +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                               :...OPTIONAL RTP padding        |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```

#### 聚合包

两种类型的聚合包：

- 单时间聚合包(Single-time aggregation packet, STAP): 聚合具有相同 NALU 时间的 NAL 单元。定义了两种 STAP，没有 DON 的(STAP-A)和包含 DON 的(STAP-B)。
- 多时间聚合包(Multi-time aggregation packet, MTAP): 聚合 NAL 时间可能不同的 NAL 单元。定义了两种 MTAP，区别是 NAL 单元时间戳差值的长度。

一个聚合包中要携带的每个 NAL 单元都封装在一个聚合单元中。

聚合包的 RTP 载荷格式

```txt
 0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|F|NRI|  TYPE   |                                               |
+-+-+-+-+-+-+-+-+                                               |
|                                                               |
|             one or more aggregation units                     |
|                                                               |
|                               +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                               :...OPTIONAL RTP padding        |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```

MTAP 和 STAP 共享下面的打包规则：

- RTP 时间戳**必须**设置为要聚合的所有 NAL 单元中最早的 NALU 时间
- NAL 单元类型 8 位字节的 type 字段**必须**按照表 4 说明设置为合适值
- 如果聚合的 NAL 单元的所有 F 位都是 0，F 位**必须**清除；否则，**必须**设置 F 位
- NRI 值**必须**是聚合包中携带的所有 NAL 单元的最大值

一个聚合包可按需携带多个聚合单元；但是，一个聚合包的数据总数显然**必须**适合一个 IP 包，且选中的**大小**应该使得生成的 IP 包小于 MTU 大小。聚合包**不能**包含分片单元。聚合包**不能**被嵌套；也就是说，一个聚合包**不能**包含另一个聚合包。

##### 单时间聚合单元 STAP

以下示例的 RTP 包包含一个 STAP-A，该 STAP-A 包含两个单时间聚合单元

```txt
 0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                          RTP Header                           |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|STAP-A NAL HDR |         NALU 1 Size           | NALU 1 HDR    |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                         NALU 1 Data                           |
:                                                               :
+               +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|               | NALU 2 Size                   | NALU 2 HDR    |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                         NALU 2 Data                           |
:                                                               :
|                               +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                               :...OPTIONAL RTP padding        |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```

以下示例的 RTP 包包含一个 STAP-B，该 STAP-B 包含两个单时间聚合单元

```txt
 0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                          RTP Header                           |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|STAP-B NAL HDR | DON                           | NALU 1 Size   |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
| NALU 1 Size   | NALU 1 HDR    | NALU 1 Data                   |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+                               +
:                                                               :
+               +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|               | NALU 2 Size                   | NALU 2 HDR    |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                         NALU 2 Data                           |
:                                                               :
|                               +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                               :...OPTIONAL RTP padding        |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```

##### 多时间聚合单元 MTAP

下图包含一个 MTAP16 类型的多时间聚合包的 RTP 包的示例，包含两个多时间聚合单元

```txt
 0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                          RTP Header                           |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|MTAP16 NAL HDR |  decoding order number base   | NALU 1 Size   |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|  NALU 1 Size  |  NALU 1 DOND  |       NALU 1 TS offset        |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|  NALU 1 HDR   |  NALU 1 DATA                                  |
+-+-+-+-+-+-+-+-+                                               +
:                                                               :
+               +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|               | NALU 2 SIZE                   |  NALU 2 DOND  |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|       NALU 2 TS offset        |  NALU 2 HDR   |  NALU 2 DATA  |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+               |
:                                                               :
|                               +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                               :...OPTIONAL RTP padding        |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```

下图包含一个 MTAP24 类型的多时间聚合包的 RTP 包的示例，包含两个多时间聚合单元

```txt
 0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                          RTP Header                           |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|MTAP24 NAL HDR |  decoding order number base   | NALU 1 Size   |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|  NALU 1 Size  |  NALU 1 DOND  |       NALU 1 TS offset        |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|NALU 1 TS offs |  NALU 1 HDR   |  NALU 1 DATA                  |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+                               +
:                                                               :
+               +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|               | NALU 2 SIZE                   |  NALU 2 DOND  |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|       NALU 2 TS offset                        |  NALU 2 HDR   |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|  NALU 2 DATA                                                  |
:                                                               :
|                               +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                               :...OPTIONAL RTP padding        |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```

#### 分片单元(FU)

此载荷类型允许将一个 NAL 单元分片成多个 RTP 包。

- FU-A 包含一个 8 位字节的分片单元指示符、一个 8 位字节的分片单元头和一个分片单元载荷。
- FU-B 包含一个 8 位字节的分片单元指示符、一个 8 位字节的分片单元头、一个解码顺序号(DON)(网络字节序)和一个分片单元载荷。换句话说，FU-B 的结构和 FU-A 的结构相同，除了增加 DON 字段。

当对 NAL 单元分片并在分片单元(FU)内传送时，它被称为分片 NAL 单元。STAP 和 MTAP **不能**被分片。FU **不能**嵌套；也就是说，一个 FU **不能**包含另一个 FU。

将携带 FU 的 RTP 包的 RTP 时间戳设置为分片 NAL 单元的 NALU 时间。

NALU 单元类型 FU-B **必须**用于交织打包模式中分片 NAL 单元的第一个分片单元。NAL 单元类型 FU-B **不能**用于任何其他情况。换句话说，在交织打包模式中，每个被分片的 NALU 都有一个 FU-B 作为第一个分片，然后是一个或多个 FU-A 分片。

FU 8 位字节指示符：

```txt
+---------------+
|0|1|2|3|4|5|6|7| 
+-+-+-+-+-+-+-+-+
|F|NRI|  Type   |
+---------------+
```

FU 头：

```txt
+---------------+
|0|1|2|3|4|5|6|7| 
+-+-+-+-+-+-+-+-+
|S|E|R|  Type   |
+---------------+
```

- S: 1 位。设置为 1 时，Start 位指示一个分片 NAL 单元的开始。当后续 FU 载荷不是分片 NAL 单元的载荷的开始时，Start 位设置为 0。
- E: 1 位。设置为 1 时，End 位指示分片单元的结束，即，载荷的最后一个字节也是分片 NAL 单元的最后一个字节。当后续 FU 载荷不是分片 NAL 单元的最后一个分片时，End 位设置为 0。
- R: 1 位。Reserved 位**必须**等于 0，且接收者**必须**忽视。
- Type: 5 位。NAL 单元载荷类型，正如 [^1] 的表 7-1 所定义。

一个分片 NAL 单元**不能**在一个 FU 中传输；也就是说，同一 FU 头内的 Start 和 End 位**不能**都设置为 1。

FU 载荷包含分片 NAL 单元的载荷的分片，因此如果将连续 FU 的分片单元载荷按顺序连接，则可以重构分片 NAL 单元的载荷。分片 NAL 单元的 NAL 单元类型 8 位字节不包括在分片单元载荷中，其信息在分片单元的 FU 8 位字节指示符的 F 和 NRI 字段以及 FU 头的 type 字段中传输。FU 载荷**可以**有任意数量的 8 位字节且**可以**为空。

### 解包过程

- 如果解包的包是一个单 NAL 单元数据包，则包中包含的 NAL 单元将直接传递给解码器。
- 如果解包的包是 STAP-A，则包中包含的 NAL 单元将按照其在包中的封装顺序传递给解码器。
- 对于包含单 NAL 单元分片的所有 FU-A 包，解包的分片按照其发送顺序进行连接以恢复 NAL 单元，然后将其传递给解码器。

## 参考

- [rfc 6184-RTP Payload Format for H.264 Video](https://tools.ietf.org/html/rfc6184)
- [ITU-T Recommendation H.264, "Advanced video coding for generic audiovisual services"](https://www.itu.int/rec/T-REC-H.264-201906-I/en)
