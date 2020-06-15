# H.264 添加 RTP 封装

- [H.264 添加 RTP 封装](#h264-添加-rtp-封装)
  - [术语](#术语)
  - [H.264 编解码](#h264-编解码)
  - [参数集概念](#参数集概念)
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

H.264 一个非常基础的设计概念是生成自我包含的包。这通过将和多余 slice 相关的信息从媒体流中解耦合。这个上层的元信息应该被可靠地异步传输，且在包含 slice 包的 RTP 包流之前发送。这些上层参数的组合称为一个参数集(parameter set)。H.264 包含两种参数集：

## 参考

- [rfc 6184-RTP Payload Format for H.264 Video](https://tools.ietf.org/html/rfc6184)
- [ITU-T Recommendation H.264, "Advanced video coding for generic audiovisual services"](https://www.itu.int/rec/T-REC-H.264-201906-I/en)
