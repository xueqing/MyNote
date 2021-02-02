# ISO 基本媒体文件格式

- [ISO 基本媒体文件格式](#iso-基本媒体文件格式)
  - [缩写](#缩写)
  - [介绍](#介绍)
  - [1 范围](#1-范围)
  - [3 术语、定义和缩略语](#3-术语定义和缩略语)
    - [3.1 术语和定义](#31-术语和定义)
    - [3.2 缩略语](#32-缩略语)
  - [4 对象结构文件组织](#4-对象结构文件组织)
    - [4.1 文件结构](#41-文件结构)
    - [4.2 对象结构](#42-对象结构)
    - [4.3 File Type Box](#43-file-type-box)
  - [5 设计注意事项](#5-设计注意事项)
    - [5.1 用途](#51-用途)
      - [5.1.1 介绍](#511-介绍)
      - [5.1.2 交换](#512-交换)
      - [5.1.3 内容创建](#513-内容创建)
      - [5.1.4 流传输的准备](#514-流传输的准备)
      - [5.1.5 本地演示](#515-本地演示)
      - [5.1.6 流式演示](#516-流式演示)
    - [5.2 设计原则](#52-设计原则)
  - [6 ISO 基本媒体文件组织](#6-iso-基本媒体文件组织)
    - [6.1 演示结构](#61-演示结构)
      - [6.1.1 文件结构](#611-文件结构)
      - [6.1.2 对象结构](#612-对象结构)
      - [6.1.3 元数据和媒体数据](#613-元数据和媒体数据)
      - [6.1.4 轨道标识](#614-轨道标识)
    - [6.2 Metadata 结构(对象)](#62-metadata-结构对象)
      - [6.2.1 Box](#621-box)
      - [6.2.2 数据类型和字段](#622-数据类型和字段)
      - [6.2.3 Box 顺序](#623-box-顺序)
      - [6.2.4 URI 作为类型指示符](#624-uri-作为类型指示符)
    - [6.3 brand 识别](#63-brand-识别)
  - [7 流式支持](#7-流式支持)
    - [7.1 流式协议的处理](#71-流式协议的处理)
    - [7.2 hint 轨道协议](#72-hint-轨道协议)
    - [7.3 hint 轨道格式](#73-hint-轨道格式)
  - [8 box 定义](#8-box-定义)
    - [8.1 文件结构和常规 box](#81-文件结构和常规-box)
      - [8.1.1 Media Data Box](#811-media-data-box)
      - [8.1.2 Free Space Box](#812-free-space-box)
      - [8.1.3 Progressive Download Information Box](#813-progressive-download-information-box)
    - [8.2 影片结构](#82-影片结构)
      - [8.2.1 Movie Box](#821-movie-box)
      - [8.2.2 Movie Header Box](#822-movie-header-box)
    - [8.3 轨道结构](#83-轨道结构)
      - [8.3.1 Track Box](#831-track-box)
      - [8.3.2 Track Header Box](#832-track-header-box)
      - [8.3.3 Track Reference Box](#833-track-reference-box)
      - [8.3.4 Track Group Box](#834-track-group-box)
    - [8.4 轨道媒体结构](#84-轨道媒体结构)
      - [8.4.1 Media Box](#841-media-box)
      - [8.4.2 Media Header Box](#842-media-header-box)
      - [8.4.3 Handler Reference Box](#843-handler-reference-box)
      - [8.4.4 Media Information Box](#844-media-information-box)
      - [8.4.5 Media Information Header Box](#845-media-information-header-box)
        - [8.4.5.1 定义](#8451-定义)
        - [8.4.5.2 Null Media Header Box](#8452-null-media-header-box)
      - [8.4.6 Extended Language Tag](#846-extended-language-tag)
    - [8.5 采样表](#85-采样表)
      - [8.5.1 Sample Table Box](#851-sample-table-box)
      - [8.5.2 Sample Description Box](#852-sample-description-box)
      - [8.5.3 Degradation Priority Box](#853-degradation-priority-box)
    - [8.6 轨道时间结构](#86-轨道时间结构)
      - [8.6.1 Time to Sample Box](#861-time-to-sample-box)
        - [8.6.1.1 定义](#8611-定义)
        - [8.6.1.2 Decoding Time to Sample Box](#8612-decoding-time-to-sample-box)
        - [8.6.1.3 Composition Time to Sample Box](#8613-composition-time-to-sample-box)
        - [8.6.1.4 Composition to Decode Box](#8614-composition-to-decode-box)
      - [8.6.2 Sync Sample Box](#862-sync-sample-box)
      - [8.6.3 Shadow Sync Sample Box](#863-shadow-sync-sample-box)
      - [8.6.4 Independent and Disposable Samples Box](#864-independent-and-disposable-samples-box)
      - [8.6.5 Edit Box](#865-edit-box)
      - [8.6.6 Edit List Box](#866-edit-list-box)
    - [8.7 轨道数据布局结构](#87-轨道数据布局结构)
      - [8.7.1 Data Information Box](#871-data-information-box)
      - [8.7.2 Data Reference Box](#872-data-reference-box)
      - [8.7.3 Sample Size Boxes](#873-sample-size-boxes)
        - [8.7.3.1 定义](#8731-定义)
        - [8.7.3.2 Sample Size Box](#8732-sample-size-box)
        - [8.7.3.3 Compact Sample Size Box](#8733-compact-sample-size-box)
      - [8.7.4 Sample To Chunk Box](#874-sample-to-chunk-box)
      - [8.7.5 Chunk Offset Box](#875-chunk-offset-box)
      - [8.7.6 Padding Bits Box](#876-padding-bits-box)
      - [8.7.7 Sub-Sample Information Box](#877-sub-sample-information-box)
      - [8.7.8 Sample Auxiliary Information Sizes Box](#878-sample-auxiliary-information-sizes-box)
      - [8.7.9 Sample Auxiliary Information Offsets Box](#879-sample-auxiliary-information-offsets-box)
    - [8.8 影片结构](#88-影片结构)
      - [8.8.1 Movie Extends Box](#881-movie-extends-box)
      - [8.8.2 Movie Extends Header Box](#882-movie-extends-header-box)
      - [8.8.3 Track Extends Box](#883-track-extends-box)
      - [8.8.4 Movie Fragment Box](#884-movie-fragment-box)
      - [8.8.5 Movie Fragment Header Box](#885-movie-fragment-header-box)
      - [8.8.6 Track Fragment Box](#886-track-fragment-box)
      - [8.8.7 Track Fragment Header Box](#887-track-fragment-header-box)
      - [8.8.8 Track Fragment Run Box](#888-track-fragment-run-box)
      - [8.8.9 Movie Fragment Random Access Box](#889-movie-fragment-random-access-box)
      - [8.8.10 Track Fragment Random Access Box](#8810-track-fragment-random-access-box)
      - [8.8.11 Movie Fragment Random Access Offset Box](#8811-movie-fragment-random-access-offset-box)
      - [8.8.12 Track Fragment Decode Time](#8812-track-fragment-decode-time)
      - [8.8.13 Level Assignment Box](#8813-level-assignment-box)
      - [8.8.14 Sample Auxiliary Information in Movie Fragments](#8814-sample-auxiliary-information-in-movie-fragments)
      - [8.8.15 Track Extension Properties Box](#8815-track-extension-properties-box)
      - [8.8.16 Alternative Startup Sequence Properties Box](#8816-alternative-startup-sequence-properties-box)
      - [8.8.17 影片片段中的元数据和用户数据](#8817-影片片段中的元数据和用户数据)
    - [8.9 采样分组结构](#89-采样分组结构)
      - [8.9.1 介绍](#891-介绍)
      - [8.9.2 Sample To Group Box](#892-sample-to-group-box)
      - [8.9.3 Sample Group Description Box](#893-sample-group-description-box)
      - [8.9.4 Movie Fragment 的组结构表示](#894-movie-fragment-的组结构表示)
    - [8.10 用户数据](#810-用户数据)
      - [8.10.1 User Data Box](#8101-user-data-box)
      - [8.10.2 Copyright Box](#8102-copyright-box)
      - [8.10.3 Track Selection Box](#8103-track-selection-box)
        - [8.10.3.1 介绍](#81031-介绍)
        - [8.10.3.2 定义](#81032-定义)
        - [8.10.3.3 语法](#81033-语法)
        - [8.10.3.4 语义](#81034-语义)
        - [8.10.3.5 属性](#81035-属性)
      - [8.10.4 Track kind](#8104-track-kind)
    - [8.11 元数据支持](#811-元数据支持)
      - [8.11.1 The Meta Box](#8111-the-meta-box)
      - [8.11.2 XML Box](#8112-xml-box)
      - [8.11.3 The Item Location Box](#8113-the-item-location-box)
      - [8.11.4 Primary Item Box](#8114-primary-item-box)
      - [8.11.5 Item Protection Box](#8115-item-protection-box)
      - [8.11.6 Item Information Box](#8116-item-information-box)
      - [8.11.7 Additional Metadata Container Box](#8117-additional-metadata-container-box)
      - [8.11.8 Metabox Relation Box](#8118-metabox-relation-box)
      - [8.11.9 Meta Box 的 URL 格式](#8119-meta-box-的-url-格式)
      - [8.11.10 静态的元数据](#81110-静态的元数据)
        - [8.11.10.1 简单的文本](#811101-简单的文本)
        - [8.11.10.2 其他格式](#811102-其他格式)
        - [8.11.10.3 MPEG-7 元数据](#811103-mpeg-7-元数据)
      - [8.11.11 Item Data Box](#81111-item-data-box)
      - [8.11.12 Item Reference Box](#81112-item-reference-box)
      - [8.11.13 Auxiliary video metadata](#81113-auxiliary-video-metadata)
    - [unknown](#unknown)
      - [8.4.5.2 Video Media Header Box](#8452-video-media-header-box)
      - [8.4.5.3 Sound Media Header Box](#8453-sound-media-header-box)
      - [8.11.4 Hint Media Header Box](#8114-hint-media-header-box)
    - [8.40 AVC Extensions](#840-avc-extensions)
      - [8.40.1 介绍](#8401-介绍)
      - [8.40.4 Random Access Recovery Points](#8404-random-access-recovery-points)
    - [8.41 Sample Scale Box](#841-sample-scale-box)
    - [8.45 支持受保护的流](#845-支持受保护的流)
      - [8.45.1 Protection Scheme Information Box](#8451-protection-scheme-information-box)
      - [8.45.2 Original Format Box](#8452-original-format-box)
      - [8.45.3 IPMP Info Box](#8453-ipmp-info-box)
      - [8.45.4 IPMP Control Box](#8454-ipmp-control-box)
      - [8.45.5 Scheme Type Box](#8455-scheme-type-box)
      - [8.45.6 Scheme Information Box](#8456-scheme-information-box)
  - [9 可扩展性](#9-可扩展性)
    - [9.1 对象](#91-对象)
    - [9.2 存储格式](#92-存储格式)
    - [9.3 派生的文件格式](#93-派生的文件格式)
  - [10 RTP 和 SRTP hint 轨道格式](#10-rtp-和-srtp-hint-轨道格式)
    - [10.1 介绍](#101-介绍)
    - [10.2 采样描述格式](#102-采样描述格式)
      - [10.2.1 SRTP Process Box](#1021-srtp-process-box)
    - [10.3 采样格式](#103-采样格式)
      - [10.3.1 Packet Entry 格式](#1031-packet-entry-格式)
      - [10.3.2 Constructor 格式](#1032-constructor-格式)
    - [10.4 SDP 信息](#104-sdp-信息)
      - [10.4.1 影片 SDP 信息](#1041-影片-sdp-信息)
      - [10.4.2 轨道 SDP 信息](#1042-轨道-sdp-信息)
    - [10.5 统计信息](#105-统计信息)
  - [附录 A (提供信息) 概述和介绍](#附录-a-提供信息-概述和介绍)
    - [A.1 章节概述](#a1-章节概述)
    - [A.2 核心概念](#a2-核心概念)
    - [A.3 媒体的物理结构](#a3-媒体的物理结构)
    - [A.4 媒体的时间结构](#a4-媒体的时间结构)
    - [A.5 交织](#a5-交织)
    - [A.6 组成](#a6-组成)
    - [A.7 随机访问](#a7-随机访问)
    - [A.8 分段的影片文件](#a8-分段的影片文件)
  - [附录 C (提供信息) 指导对此规范的派生](#附录-c-提供信息-指导对此规范的派生)
    - [C.1 介绍](#c1-介绍)
    - [C.2 一般原则](#c2-一般原则)
    - [C.3 brand 标识符](#c3-brand-标识符)
      - [C.3.1 介绍](#c31-介绍)
      - [C.3.2 brand 的使用](#c32-brand-的使用)
      - [C.3.3 引入新的 brand](#c33-引入新的-brand)
      - [C.3.4 播放器指南](#c34-播放器指南)
      - [C.3.5 创作指南](#c35-创作指南)
      - [C.3.6 示例](#c36-示例)
    - [C.4 box 布局和顺序](#c4-box-布局和顺序)
    - [C.5 新媒体类型的存储](#c5-新媒体类型的存储)
    - [C.6 模板字段的使用](#c6-模板字段的使用)
    - [C.7 分段影片的构造](#c7-分段影片的构造)
  - [参考](#参考)

## 缩写

```txt
Universal Unique IDentifiers, UUID  统一唯一标识符
Multipurpose Internet Mail Extension, MIME  多用途 Internet 邮件扩展名
computed composition time, CTS  计算的合成时间

supplemental enhancement information, SEI  补充增强信息
byte order mark, BOM  字节顺序标记
object descriptor, OD  对象描述符
registration authority, RA  注册机构

syntax description language, SDL  语法描述语言
```

## 介绍

ISO/IEC 基本媒体文件格式旨在包含演示的定时媒体信息，被设计为一种灵活、可扩展的格式，以方便媒体的交换、管理、编辑和展示。此演示对于包含演示的系统可以是本地的，或经由网络或其他流传递机制。

文件结构是面向对象的；可以非常简单地将文件分解为基本对象，且直接从基本对象的类型推测对象的结构。

此文件格式被设计为它的设计独立于任何特定的网络协议，但总体高效支持这些网络协议。

ISO/IEC 基本媒体文件格式是媒体文件格式的基础。

## 1 范围

ISO/IEC 14496 的此部分适用于 MPEG-4，但其技术内容与 ISO/IEC 15444-12 相同，后者适用于 JPEG 2000。

## 3 术语、定义和缩略语

### 3.1 术语和定义

以下术语和定义适用本文档。

```txt
box
  面向对象的构建块，由一个唯一的类型标识符和长度定义。
  注释 1：在一些规范中称为 'atom'，包括 MP4 的第一个定义
chunk
  某个轨道的一组连续样本
container box
  一种 box，只用于容纳和分组一系列相关的 box。
  注释 1：容器 box 通常不是从 'fullbox' 派生
hint track
  不包含媒体信息的特殊轨道。相反，它包含将一个或多个轨道打包到一个流通道的说明
hinter
  一种工具，运行在只包含媒体的文件，可以向该文件增加一个或多个 hint 轨道以方便流传输
ISO Base Media File
  符合此规范描述的文件格式的文件名
leaf subsegment
  不包含任何索引信息的字段，这些信息使能进一步将其细分为子段
Media Data Box
  包含演示的实际媒体数据('mdat')的 box
movie box
  一种容器 box，其中的子 box 定义了演示的元数据('moov')
movie-fragment relative addressing 
  电影片段中的媒体数据偏移量的信令，与电影片段开始有关的，特别是在 Track Fragment Header Box 中设置 base‐data‐offset‐present 为 0，设置 default‐base‐is‐moof 为 1
  注释 1：将 default‐base‐is‐moof 设置为 1 仅与包含多个轨道组(在同一轨道或多个轨道)的电影片段有关
presentation
  一个或多个运行序列，可能与音频结合
random access point (RAP)
  轨道中的采样，起始于附录 I 中定义的类型 1/2/3 的 SAP 的 ISAU；非正式地，一个采样，从其开始解码时，采样本身及其之后按照合成顺序的所有采样都可以正确解码
random access recovery point
  轨道中的采样，其显示时间等于附录 I 中定义的类型 4 的 SAP 的 TSAP；非正式地，一个采样，按照解码顺序对此采样之前的多个采样解码之后，可以正确解码此采样，有时也称为逐步解码刷新
sample
  和单个时间戳相关的所有数据
  注释 1：轨道内任何两个采样不能共享相同的时间戳
  注释 2：在非 hint 轨道中，一个采样是，比如，按解码顺序的一系列视频帧、或按解码顺序的音频压缩段；在 hint 轨道中，一个采样定义了一个或多个流数据包的形成
sample description
  一种结构，用于定义和描述轨道中的一些采样的格式
sample table
  一个压缩目录，用于轨道内采样的时间和物理布局
sync sample
  轨道中的采样，起始于附录 I 定义的类型 1/2 的 SAP 的 ISAU；非正式地，一个媒体采样，起始于一个新的独立采样序列；如果解码从同步采样开始，则可以正确解码该同步采样及其之后按解码顺序的采样，并且所得解码后的采样集合形成了媒体的正确演示，该演示起始于合成时间最早的解码后的采样；每个格式可为该格式的同步采样提供更精确的定义
segment
  ISO 基本媒体文件格式文件的一部分，由 (a)一个 Movie Box 及其关联的媒体数据(如果有)和其他关联的 box组成，或由 (b)一个或多个 Movie Fragment Box 及其关联的媒体数据和其他关联的 box 组成
subsegment
  来自 Movie Fragment Box 组成的片段的时间间隔，也是一个有效片段
track
  ISO 基本媒体文件中的相关采样的定时序列
  注释 1：对于媒体数据，一个轨道对应一个图像序列或采样的音频序列；对于 hint 轨道，一个轨道对应一个流通道
```

### 3.2 缩略语

以下缩略语适用本文档。

```txt
ALC   Asynchronous Layered Coding 
FD    File Delivery 
FDT   File Delivery Table 
FEC   Forward Error Correction 
FLUTE File Delivery over Unidirectional Transport 
IANA  Internet Assigned Numbers Authority 
LCT   Layered Coding Transport 
MBMS  Multimedia Broadcast/Multicast Service
```

## 4 对象结构文件组织

### 4.1 文件结构

文件由一系列对象组成，在本规范中称为 box。所有数据都包含在 box 中；文件中没有其他数据。这包括特定文件格式所需的任何初始签名。

本规范中符合此章节的所有对象结构文件(所有对象结构文件)都应包含一个 File Type Box。

### 4.2 对象结构

此术语中的对象是 box。

box 开始的头部提供了大小和类型。头部支持紧凑或扩展的大小(32 或 64 位)，以及紧凑或扩展的类型(32 位或完整的 统一唯一标识符，即 UUID)。标准的 box 均使用紧凑的类型(32 位)，且大多数 box 将使用紧凑的大小(32 位)。通常，只有 Media Data Box 需要 64 位大小。

大小是 box 的整个大小，包含大小和类型头、字段，以及所有包含的 box。这有助于文件的常规解析。

使用 MPEG-4(参阅第 2 节的引用)定义的语法描述语言(SDL)给出 box 的定义。本规范中代码片段的注释表示信息性材料。

对象中的字段先存储高位有效字节，通常称为网络字节顺序或大端格式。定义小于一个字节的字段时，或定义跨越字节边界的字段时，从每个字节的最高有效位到最低有效位分比特。比如，2 位的字段后跟 6 位的字段，占据字节的高位中的两位。

```code
aligned(8) class Box (unsigned int(32) boxtype,
          optional unsigned int(8)[16] extended_type) {
  unsigned int(32) size;
  unsigned int(32) type = boxtype;
  if (size==1) {
    unsigned int(64) largesize;
  } else if (size==0) {
    // box extends to end of file
  }
  if (boxtype==‘uuid’) {
    unsigned int(8)[16] usertype = extended_type;
  }
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| size | 整数 | 指定 box 的字节数，包含其所有字段和容纳的 box；如果为 1，那么实际大小保存在字段 largesize；如果为 0，那么该 box 是文件中的最后一个，且其内容延伸到文件末尾(通常只用于 Media Data Box) |
| type | - | 标识 box 类型；标准 box 使用紧凑类型，通常是 4 个可打印字符，以便于标识，并在下面的 box 中显式。用户扩展使用扩展类型；在这种情况下，类型字段设置为 “uuid” |

无法识别类型的 box 应该忽略和跳过。

许多对象也包含一个版本号 version 和标记字段 flags。

```code
aligned(8) class FullBox(unsigned int(32) boxtype, unsigned int(8) v, bit(24) f)
  extends Box(boxtype) {
  unsigned int(8) version = v;
  bit(24) flags = f;
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| version | 整数 | 指定 box 格式的版本 |
| flags | - | 标记的映射 |

无法识别版本的 box 应该忽略和跳过。

### 4.3 File Type Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| ftyp | 文件 | Y | 1 |

按照本规范此版本写入的文件必须包含一个 File Type Box。为了兼容此规范的更早版本，文件可能符合此规范但并未包含 File Type Box。读取不包含 File Type Box 的文件时，应将其视为包含一个 FTYP box，且 major_brand='mp41'，minor_version=0，以及单个兼容性 brand “mp41”。

按照本规范这一部分构造的媒体文件可能兼容多个具体规范，因此，并非总是可以为文件讨论单个 “type” 或 “brand”。这意味着文件扩展名和多用途 Internet 邮件扩展名(MIME)类型的功能有所减少。

必须尽可能早地在文件中放置此 box(例如，在任何强制性签名之后，但在任何重要的可变大小 box 之前，比如 Movie Box、Media Data Box 或 Free Space)。它标识文件的“最佳使用”规范，以及该规范的次版本；还有文件符合的其他一系列规范。读者实现此格式时，应该尝试读取标记与其实现的任何规范兼容的文件。因此，规范中任何不兼容的更改应注册新的 “brand” 标识符，以标识符合新规范的文件。

minor_version 仅提供信息。它不会出现在 compatible_brands，且不得用于确定文件是否符合标准。它可以允许更精确地识别主要规范，以便检查、调试或改进的解码。

通常在外部标识文件(比如使用文件扩展名或 MIME 类型)，以标识“最佳使用”(major_brand)，或创作者认为将提供最大兼容性的 brand。

本规范的本节未定义任何 brand。但是对于符合整个规范而不仅仅是本节的文件，参阅下面的 6.3 节了解 brand。此规范定义的所有文件格式 brand 都包含在附录 E，包含一个总结关于它们需要哪些功能。

```code
aligned(8) class FileTypeBox
  extends Box(‘ftyp’) {
  unsigned int(32) major_brand;
  unsigned int(32) minor_version;
  unsigned int(32) compatible_brands[]; // to end of the box
}
```

此 box 标识文件符合的规范。

每个 brand 是可打印的 4 字符代码，通过 ISO 注册，用于标识精确的规范。

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| major_brand | 整数 | brand 标识符 |
| minor_brand | 整数 | 信息性的整数，用于主要 brand 的次版本 |
| compatible_brands | - | 一个 brand 列表，到 box 末尾 |

## 5 设计注意事项

### 5.1 用途

#### 5.1.1 介绍

文件格式旨在用作许多操作的基础。在这些不同的角色中，可将其用于不同的方式，以及整个设计的不同方面。

#### 5.1.2 交换

当用作交换格式时，文件通常是独立的(不引用其他文件的媒体)，只包含演示中实际使用的媒体数据，且不包含任何流相关的信息。这将产生一个很小的、独立于协议的独立文件，其中包含核心媒体数据和对其操作所需的信息。

下图给出了一个简单的交换文件的示例，其中包含两个流：

![简单的交换文件](simple_interchange_file.png)

#### 5.1.3 内容创建

在内容创建阶段，可对格式的多个区域进行有效使用，特别是：

- 能够分别存储每个基本流(不交错)，可能存储在单独的文件
- 能够在包含媒体数据和其他流的单个演示中工作(比如，以未压缩格式编辑音频轨道，使其与已经准备好的视频轨道对齐)

这些特征意味着可以准备演示、进行编辑、开发和集成内容，而无需反复将演示重新写在磁盘上——如果需要交错且必须删除未使用数据，重写是必要的；且无需反复解码和重新编码数据——如果必须以编码状态存储数据，编解码是必要的。

下图显示了内容创建过程中使用的一组文件：

![内容创建文件](content_creation_file.png)

#### 5.1.4 流传输的准备

在准备流传输时，文件必须包含信息，用于信息发送过程中指导流媒体服务器。此外，如果这些指令和媒体数据是交织的，以便为演示提供服务时避免过度搜索，这是很有用的。这对于原始媒体数据保持无损也同样重要，以便对文件进行验证、重新编辑或另外重用。最后，如果可为多个协议准备单个文件，以便不同服务器通过不同协议使用文件，这将很有帮助。

#### 5.1.5 本地演示

“本地”查看演示(即直接从文件而不是通过流式互联)是一个重要应用；将其用于分发演示时(比如在 CD 或 DVD ROM 上)、开发过程中，以及在流媒体服务器上验证内容。必须支持这种本地查看，并可完全随机访问。如果演示在 CD 或 DVD ROM 上，那么交错很重要，因为搜索可能会很慢。

#### 5.1.6 流式演示

当服务器从文件生成流时，生成的流必须符合使用的协议规范，且文件本身不应包含任何文件格式信息的痕迹。服务器需要能够随机访问演示。这对于通过多个演示引用相同媒体内容以重用服务内容(比如生成摘要)可能有用；它也可以帮助在准备流式传输时，媒体数据可在只读媒体(比如 CD)上且不复制只扩充。

下图显示了通过多路复用协议准备流式传输演示，只需要一个 hint 轨道。

![用于流传输的带提示的演示](hinted_Presentation_for_streaming.png)

### 5.2 设计原则

文件结构是面向对象的；可以非常简单地将文件分解为基本对象，且直接从基本对象的类型推测对象的结构。

媒体数据不是通过文件格式“分帧”；文件格式声明提供媒体数据单元的大小、类型和位置，在物理上和媒体数据不连续。这使得可以对媒体数据划分子集，并以其自然状态进行使用，而无需将其复制以为分帧留出空间。元数据用于通过引用而不是包含来描述媒体数据。

类似的，用于特定流协议的协议信息不对媒体数据分帧；协议头和媒体数据在物理上不连续。相反，可通过引用包含媒体数据。这使得可以媒体数据的自然状态进行演示，而无需任何协议。这也使得同一组媒体数据可用于本地演示和多种协议。

协议信息的构建方式使得流媒体服务器仅需要了解该协议及其发送方式；协议信息抽象了媒体知识，以便服务器在很大程度上与媒体类型无关。同样地，媒体数据以未知协议的方式存储，使得媒体工具与协议无关。

文件格式不要求单个演示位于单个文件中。这样可以设置内容子部分，以及重用内容。当和非帧的方法结合使用时，还可以包含未按照此规范格式化的文件的媒体数据(比如，仅包含媒体数据且不包含声明性信息的“raw”文件，或者已在媒体或计算机行业使用的文件格式)。

文件格式基于一组统一的设计，以及一组丰富的可能的结构和用法。相同的格式适用所有用法；不需要翻译。然而，当以特定方式使用时(比如本地演示)，可能需要以某些方式结构化文件以实现最佳行为(比如，数据的时间顺序)。除非使用受限的配置文件，否则本规范未定义标准的结构化规则。

## 6 ISO 基本媒体文件组织

### 6.1 演示结构

#### 6.1.1 文件结构

演示可能包含在多个文件中。一个文件包含整个演示的元信息，且按照此规范格式化。此文件也可能包含所有的媒体数据，则该演示是独立的。如果使用了其他文件，则无需按照此规范格式化；它们用于包含媒体数据，也可能包含未使用的媒体数据或其他信息。本规范仅涉及演示文件的结构。此规范中关于媒体数据文件的格式，只限制其中的媒体数据必须可以通过此处定义的元数据进行描述。

其他文件可以是 ISO 文件、图像文件或其他格式。其他这些文件中只存储媒体数据本身，比如 JPEG 2000 图像；所有时间和帧(位置和大小)信息都存储在 ISO 基本媒体文件中，因此辅助文件本质上是自由格式的。

如果 ISO 文件包含 hint 轨道，则引用媒体数据(从这些数据建立 hint)的媒体轨道应保留在文件中，即使 hint 轨道没有直接引用媒体轨道内的数据；删除所有 hint 轨道后，将保留整个没有 hint 的演示。但是请注意，媒体轨道可能为其媒体数据引用外部文件。

附录 A 提供了内容丰富的介绍，可能对初学者有所帮助。

#### 6.1.2 对象结构

文件被构造为一系列对象；其中一些对象可能包含其他对象。文件中的对象序列应该只包含一个演示元数据包装器(Movie Box)。它通常靠近文件的开头或结尾，以方便对其定位。在此级别找到的其他对象可能是 File Type Box、Free Space Box、Movie Fragments、Meta-data 或 Media Data Box。

#### 6.1.3 元数据和媒体数据

元数据包含在元数据包装器(Movie Box)中；媒体数据包含在相同文件的 Media Data Box 或其他文件中。媒体数据由图像或音频数据组成；媒体数据对象或媒体数据文件，可能包含其他未引用的信息。

#### 6.1.4 轨道标识

ISO 文件中使用的轨道标识符在该文件中是唯一的；没有两个轨道可以使用相同的标识符。

下一个轨道标识符存储在 Movie Header Box 的 next_track_ID，通常包含一个比文件中找到的最大轨道标识符值大 1 的值。在大多数情况下，这使得易于生成轨道标识符。但是，如果该值为全 1(32 位无符号数 maxint)，则所有增加需要搜索未使用的轨道标识符。

### 6.2 Metadata 结构(对象)

#### 6.2.1 Box

保留此处未定义的 type 字段。应通过 “uuid” 类型实现私有扩展名。此外，在本规范的未来版本中，不使用且也不会使用以下类型，或者仅以其现有含义使用，以避免与现有内容重入，这些内容使用此格式的较早标准版本：

- clip、crgn、matt、kmat、pnot、ctab、load、imap
- 这些轨道引用类型(在 Track Reference Box 的 reference_type 找到)：tmcd、chap、sync、scpt、 ssrc

许多 box 包含其他 box 中的序列的索引值。这些索引从 1 开始(1 是序列中的第一个条目)。

#### 6.2.2 数据类型和字段

此规范的许多 box 中，有两个变体形式：对于相同的字段，版本 0 使用 32 位字段，版本 1 使用 64 位大小。通常，如果可以则应该使用使用版本 0 的 box(字段大小为 32 位)；仅当需要它们允许的 64 位字段大小时，才使用版本 1 的 box。

内容创建阶段为了方便起见，文件中存储了创建和修改时间。这些值可以是 32 位或 64 位数字，计算自 1904-1-1 午夜以来的秒数，这是闰年计算的方便日期。在大约 2040 年之前 ，32 位就足够了。这些时间应表示成 UTC。因此如果显示可能需要调整到本地时间。

定点数是通过将整数除以适当的 2 的幂得到的有符号或无符号值。例如，通过将 32 位整数除以 4，可以形成 30.2 的定点数。

box 描述中显示为 “template” 的字段在使用此规范的规范中是可选的。如果在另一规范中使用了该字段，则该使用必须符合此处对其的定义，且规范必须定义该使用是可选的还是强制性的。类似地，在此规范的较早版本中使用了标记为 “predefined” 的字段。对于这两种字段，如果规范中未使用该类型的字段，则应将其设置为指示的默认值。如果未使用该字段，在复制 box 时必须对其未经检查地复制，并在读取时将其忽略。

出现在头部的矩阵值指定显示的视频图像的转换。并非所有派生规范使用矩阵；如果未使用矩阵，应将其设置为单位矩阵；如果使用矩阵，则使用矩阵将点 (p,q) 转换为 (p',q)，如下所示：

$$(p\,q\,1) *
\begin{vmatrix}
a & b & u\\
c & d & v\\
x & y & w
\end{vmatrix}
= (m\,n\,z)
$$

$$m=ap+cq+x; n=bp+dq+y;z=up+vq+w;$$

$$p'=m/z; q'=n/z$$

坐标 {p,q} 在解压缩的帧上，{p',q'}在渲染输出上。因此，比如，矩阵 {2,0,0, 0,2,0, 0,0,1} 正好使图像的像素尺寸加倍。通过矩阵转换的坐标不会以任何方式归一化，而是代表实际的采样位置。因此 {x,y} 例如可以视为图像的翻译向量。

坐标原点位于左上角，X 值向右增加，Y 值向下增加。将 {p,q} 和 {p',q'} 视为绝对像素位置，分别相对于原始图像的左上角(缩放到 Track Header 的宽度和高度确定的尺寸之后)，以及转换的(渲染的)表面。

每个轨道使用指定的矩阵组成整个图像；然后根据 MovieHeaderBox 中影片级别的矩阵对其转换和合成。例如，生成的图像是否被“裁剪”以消除在窗口的垂直矩形区域没有显示的像素，这取决于应用程序。因此，例如，如果只显示一个视频轨道并将其翻译向量 {20,30}，且 MovieHeaderBox 有一个单位矩阵，则应用程序可能选择不显示图像和原点之间的空白 “L” 形区域。

矩阵中的所有制均存储为 16.16 定点值，除了 u、v 和 w，这三个存储为 2.30 定点值。

矩阵中的值以 {a,b,u, c,d,v, x,y,w} 顺序存储。

#### 6.2.3 Box 顺序

下面信息性的表 1 —— Box 类型、结构和交叉引用(信息性)，提供了常规封装结构的整体视图。如果此表和解释发生冲突，则以解释为准。容器内的 box 顺序不一定是表中指示的顺序。

该表最左侧一栏显示了可能出现在顶层的 box；使用缩进显示可能的包含关系。因此，比如在 Movie Box(moov) 中找到 Track Box(trak)，在 trak 中找到 Track Header Box(tkhd)。并非所有文件需要用到所有 box；必须使用的 box 使用星号(*)标记。请参阅各个 box 的描述，以讨论如果不存在可选 box 需要假定的内容。

用户数据对象仅应放在 Movie 或 Track Box 中，且使用扩展类型的对象可以放在各种容器中，而不仅仅是顶层。

为了提高文件的互操作性和实用性，对于 box 的顺序应遵循下面的规则和准则：

1. File Type Box “ftyp” 应出现在任何长度可变的 box(比如 movie、free space、media data)之前。如果需要，只有固定大小的 box(比如文件签名)可以在其之前。
2. 强烈**建议**容器中首先放置所有头部 box：这些 box 是 Movie Header、Track Header、Media Header 和 Media Information Box 内特定的媒体头(比如 Video Media Header)。
3. 所有 Movie Fragment Box **应该**按顺序排列(参阅第 8.8.5 节)。
4. **建议** Sample Table Box 内的 box 按照下面的顺序：Sample Description、Time to Sample、Sample to Chunk、Sample Size、Chunk Offset。
5. 强烈**建议** Track Reference Box 和 Edit List(如果有)**应该**在 Media Box 之前，且 Handler Reference Box **应该**在 Media Information Box 之前，Data Information Box 在 Sample Table Box 之前。
6. **建议**容器中最后放置 User Data Box，即 Movie Box 或 Track Box。
7. **建议**将 Movie Fragment Random Access Box(如果有)放在文件最后。
8. **建议** Progressive Download Information Box 尽早放置在文件中，以便发挥最大效用。

表 1 —— Box 类型、结构和交叉引用

| # | # | # | # | # | # | 必要性 | 定义 | 描述 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| ftyp |   |   |   |   |   | * | 4.3    | file type and compatibility |
| pdin |   |   |   |   |   |   | 8.1.3  | progressive download information |
| moov |   |   |   |   |   | * | 8.2.1  | container for all the metadata |
|   | mvhd |   |   |   |   | * | 8.2.2  | movie header, overall declarations |
|   | meta |   |   |   |   |   | 8.11.1 | metadata |
|   | trak |   |   |   |   | * | 8.3.1  | container for an individual track or stream |
|   |   | tkhd |   |   |   | * | 8.3.2  | track header, overall information about the track |
|   |   | tref |   |   |   |   | 8.3.3  | track reference container |
|   |   | trgr |   |   |   |   | 8.3.4  | track grouping indication |
|   |   | edts |   |   |   |   | 8.6.4  | edit list container |
|   |   |   | elst |   |   |   | 8.6.6  | an edit list |
|   |   | meta |   |   |   |   | 8.11.1 | metadata |
|   |   | mdia |   |   |   | * | 8.4    | container for the media information in a track |
|   |   |   | mdhd |   |   | * | 8.4.2  | media header, overall information about the media |
|   |   |   | hdlr |   |   | * | 8.4.3  | handler, declares the media (handler) type |
|   |   |   | elng |   |   |   | 8.4.6  | extended language tag |
|   |   |   | minf |   |   | * | 8.4.4  | media information container |
|   |   |   |   | vmhd |   |   | 12.1.2 | video media header, overall information (video track only) |
|   |   |   |   | smhd |   |   | 12.2.2 | sound media header, overall information (sound track only) |
|   |   |   |   | hmhd |   |   | 12.4.2 | hint media header, overall information (hint track only) |
|   |   |   |   | sthd |   |   | 12.6.2 | subtitle media header, overall information (subtitle track only) |
|   |   |   |   | nmhd |   |   | 8.4.5.2 | Null media header, overall information (some tracks only) |
|   |   |   |   | dinf |   | * | 8.7.1  | data information box, container |
|   |   |   |   |   | dref | * | 8.7.2  | data reference box, declares source(s) of media data in track |
|   |   |   |   | stbl |   | * | 8.5.1  | sample table box, container for the time/space map |
|   |   |   |   |   | stsd | * | 8.5.2  | sample descriptions (codec types, initialization etc.) |
|   |   |   |   |   | stts | * | 8.6.1.2 | (decoding) time-to-sample |
|   |   |   |   |   | ctts |   | 8.6.1.3 | (composition) time to sample |
|   |   |   |   |   | cslg |   | 8.6.1.4 | composition to decode timeline mapping |
|   |   |   |   |   | stsc | * | 8.7.4  | sample-to-chunk, partial data-offset information |
|   |   |   |   |   | stsz |   | 8.7.3.2 | sample sizes (framing) |
|   |   |   |   |   | stz2 |   | 8.7.3.3 | compact sample sizes (framing) |
|   |   |   |   |   | stco | * | 8.7.5  | chunk offset, partial data-offset information |
|   |   |   |   |   | co64 |   | 8.7.5  | 64-bit chunk offset |
|   |   |   |   |   | stss |   | 8.6.2  | sync sample table (random access points) |
|   |   |   |   |   | stsh |   | 8.6.3  | shadow sync sample table |
|   |   |   |   |   | padb |   | 8.7.6  | sample padding bits |
|   |   |   |   |   | stdp |   | 8.7.6  | sample degradation priority |
|   |   |   |   |   | sdtp |   | 8.6.4  | independent and disposable samples |
|   |   |   |   |   | sbgp |   | 8.9.2  | sample-to-group |
|   |   |   |   |   | sgpd |   | 8.9.3  | sample group description |
|   |   |   |   |   | subs |   | 8.7.7  | sub-sample information |
|   |   |   |   |   | saiz |   | 8.7.8  | sample auxiliary information sizes |
|   |   |   |   |   | saio |   | 8.7.9  | sample auxiliary information offsets |
|   |   | udta |   |   |   |   | 8.10.1 | user-data |
|   | mvex |   |   |   |   |   | 8.8.1  | movie extends box |
|   |   | mehd |   |   |   |   | 8.8.2  | movie extends header box |
|   |   | trex |   |   |   | * | 8.8.3  | track extends defaults |
|   |   | leva |   |   |   | * | 8.8.13 | level assignment |
| moof |   |   |   |   |   |   | 8.8.4  | movie fragment |
|   | mfhd |   |   |   |   | * | 8.8.5  | movie fragment header |
|   | meta |   |   |   |   |   | 8.11.1 | metadata |
|   | traf |   |   |   |   |   | 8.8.6  | track fragment |
|   |   | tfhd |   |   |   | * | 8.8.7  | track fragment header |
|   |   | trun |   |   |   |   | 8.8.8  | track fragment run |
|   |   | sbgp |   |   |   |   | 8.9.2  | sample-to-group |
|   |   | sgpd |   |   |   |   | 8.9.3  | sample group description |
|   |   | subs |   |   |   |   | 8.7.7  | sub-sample information |
|   |   | saiz |   |   |   |   | 8.7.8  | sample auxiliary information sizes |
|   |   | saio |   |   |   |   | 8.7.9  | sample auxiliary information offsets |
|   |   | tfdt |   |   |   |   | 8.8.12 | track fragment decode time |
|   |   | meta |   |   |   |   | 8.11.1 | metadata |
| mfra |   |   |   |   |   |   | 8.8.9  | movie fragment random access |
|   | tfra |   |   |   |   |   | 8.8.10 | track fragment random access |
|   | mfro |   |   |   |   | * | 8.8.11 | movie fragment random access offset |
| mdat |   |   |   |   |   |   | 8.2.2  | media data container |
| free |   |   |   |   |   |   | 8.1.2  | free space |
| skip |   |   |   |   |   |   | 8.1.2  | free space |
|   | udta |   |   |   |   |   | 8.10.1 | user-data |
|   |   | cprt |   |   |   |   | 8.10.2 | copyright etc. |
|   |   | tsel |   |   |   |   | 8.10.3 | track selection box  |
|   |   | strk |   |   |   |   | 8.10.3 | sub track box |
|   |   |   | stri |   |   |   | 8.14.4 | sub track information box |
|   |   |   | strd |   |   |   | 8.14.5 | sub track definition box |
| meta |   |   |   |   |   |   | 8.11.1 | metadata |
|   | hdlr |   |   |   |   | * | 8.4.3  | handler, declares the metadata (handler) type |
|   | dinf |   |   |   |   |   | 8.7.1  | data information box, container |
|   |   | dref |   |   |   |   | 8.7.2  | data reference box, declares source(s) of metadata items |
|   | iloc |   |   |   |   |   | 8.11.3 | item location |
|   | ipro |   |   |   |   |   | 8.11.5 | item protection |
|   |   | sinf |   |   |   |   | 8.12.1 | protection scheme information box |
|   |   |   | frma |   |   |   | 8.12.2 | original format box |
|   |   |   | schm |   |   |   | 8.12.5 | scheme type box |
|   |   |   | schi |   |   |   | 8.12.6 | scheme information box |
|   | iinf |   |   |   |   |   | 8.11.6 | item information |
|   | xml  |   |   |   |   |   | 8.11.2 | XML container |
|   | bxml |   |   |   |   |   | 8.11.2 | binary XML container |
|   | pitm |   |   |   |   |   | 8.11.4 | primary item reference |
|   | fiin |   |   |   |   |   | 8.13.2 | file delivery item information |
|   |   | paen |   |   |   |   | 8.13.2 | partition entry |
|   |   |   | fire |   |   |   | 8.13.7 | file reservoir |
|   |   |   | fpar |   |   |   | 8.13.3 | file partition |
|   |   |   | fecr |   |   |   | 8.13.4 | FEC reservoir  |
|   |   | segr |   |   |   |   | 8.13.5 | file delivery session group  |
|   |   | gitn |   |   |   |   | 8.13.6 | group id to name  |
|   | idat |   |   |   |   |   | 8.11.11 | item data |
|   | iref |   |   |   |   |   | 8.11.12 | item reference |
| meco |   |   |   |   |   |   | 8.11.7 | additional metadata container |
|   | mere |   |   |   |   |   | 8.11.8 | metabox relation |
|   |   | meta |   |   |   |   | 8.11.1 | metadata  |
| styp |   |   |   |   |   |   | 8.16.2 | segment type |
| sidx |   |   |   |   |   |   | 8.16.3 | segment index |
| ssix |   |   |   |   |   |   | 8.16.4 | subsegment index |
| prft |   |   |   |   |   |   | 8.16.5 | producer reference time |

#### 6.2.4 URI 作为类型指示符

当 URI 用作类型指示符时(例如采样条目中或用于不定时的元数据)，URI 必须是绝对的，而不是相对的，且数据的格式和含义必须由相关的 URI 定义。此标识可能是分层的，因为 URI 的初始子字符串可能标识数据的整体性质或家族(例如，urn:oid: 标识元数据已由 ISO 标准对象标识符标记)。

URI 应该是可引用的，但非必需的。读者可将它与它知道和识别出的 URI 类型集进行字符串比较。URI 为类型标识符提供了一个很大的非冲突的未注册空间。

如果 URI 包含域名(例如，它是一个 URL)，则它还应包含 mmyyyy 格式的月份。该日期必须接近扩展名的定义时间，且必须以该日期的域名所有者授权的方式定义 URI(这避免了域名更改所有权出现的问题)。

### 6.3 brand 识别

附录 E 中提供了适用于文件格式的 brand 的定义。

## 7 流式支持

### 7.1 流式协议的处理

此文件格式支持媒体数据通过网络的流式播放和本地回放。发送协议数据单元的过程是基于时间的，就像显示基于时间的数据，因此可以通过基于时间的格式进行适当描述。支持流式传输的文件或“影片”包含有关流的数据单元信息。此信息包含在文件额外的轨道，称之为 “hint” 轨道。hint 轨道也可用于记录流；这些称之为 Reception Hint Track，以和普通的(或服务器，或传输) hint 轨道区分。

传输或服务器 hint 轨道包含指示，以帮助流媒体服务器形成传输的数据包。这些指示可能包含即时数据供服务器发送(比如头部信息)或媒体数据的引用段。这些指示被编码到文件中的方式，和将编辑或演示信息编码到文件以进行本地播放的方式相同。为服务器提供信息而不是编辑或演示信息，允许服务器以适用于特定网络传输流的方式对媒体数据分包。

无论是本地回放还是通过多种不同协议进行流传输，包含 hint 的文件中使用相同的媒体数据。同一文件内部可能为不同的协议包含单独的 “hint” 轨道，且媒体将在所有此类协议上播放，而无需另外复制媒体本身。此外，通过为特定协议添加合适的 hint 轨道，可轻松使现有媒体流式传输。媒体数据本身不需要以任何方式重新广播或格式化。

相比要求将媒体信息划分为针对给定传输和媒体格式进行传输的实际数据单元的方法，这种流传输和记录方法具有更高的空间效率。按照前一种方法，本地回放需要从数据包重新组合媒体，或者生成两个媒体副本——一个用于本地回放，一个用于流媒体。类似地，使用这种方法通过多种协议流式传输此类媒体，每次传输都需要媒体数据的多个副本。这在空间上是低效的，除非媒体数据被大量转换用于流传输(比如通过纠错编码技术或加密)。

记录第一个或多个数据包流时，可以使用 Reception Hint Track。Reception Hint Track 指示接收的包的顺序、接收时间和内容等。

注意：播放器可以根据 Reception Hint Track 再现接收到的数据包流，并像重新接收到的处理再现的数据包流。

### 7.2 hint 轨道协议

支持流式基于下面三个设计参数：

- 媒体数据表示为一组网络无关的标准轨道，可以正常播放、编辑等
- 服务器 hint 轨道具有统一的声明和基本结构；这种通用格式和协议无关，但是包含 hint 轨道中描述了哪些协议的声明
- 对于每种可能传输的协议，hint 轨道都有特定的设计；所有这些设计使用相同的基本结构。比如，可能存在 RTP (用于 Internet) 和 MPEG-2 传输(用于广播)，或新标准，或特定供应商协议的设计

服务器按照服务器 hint 轨道指示发送的结果流，或者从 Reception Hint Track 重新构造的结果流，不能包含特定文件的信息痕迹。该设计不需要在有限数据或解码站中使用文件结构或声明样式。例如，使用 ITU-T H.261 视频和 DVI 音频的文件通过 RTP 进行流传输，产生的数据流包完全符合将这些编码打包到 RTP 的 IETF 规范。

hint 轨道的构建和标记，使得在本地回放演示(而非流式)时可以忽略它们。

### 7.3 hint 轨道格式

hint 轨道用于描述文件中的基本流数据。每个协议或相关协议的每个家族都有自己的 hint 轨道格式。对于同一协议，服务器 hint 轨道格式和 Reception Hint Track 格式使用采样描述条目关联的四字符代码区分。也就是说，同一协议的服务器 hint 轨道格式和 Reception Hint Track 格式使用不同的四字符代码。同一协议的服务器 hint 轨道格式和 Reception Hint Track 格式的语法应该相同或兼容，以便 Reception Hint Track 可用于重新发送流，前提是正确处理了接收到的流的潜在降级。大多数协议对于每个轨道仅需要一个采样描述格式。

服务器查找这些 hint 轨道时，首先找到所有 hint 轨道，然后使用其协议(采样描述格式)在该集合查找服务器 hint 轨道。如果当前有选择，那么服务器的选择将根据首选协议，或通过比较 Hint Track Header 的功能或采样描述中特定协议的信息。特别是在没有服务器 hint 轨道的情况下，服务器也可以使用其协议的 Reception Hint Track。但是，服务器应适当处理使用的 Reception Hint Track 描述的接收流的潜在降级。

无论是媒体轨道还是Reception Hint Track，设置了 track_in_movie 标记的轨道是回放的候选。

hint 轨道根据引用将数据从其他轨道拉下来以构造流。这些其他轨道可能是 hint 轨道或基本流轨道。这些指针的确切形式由协议的采样格式定义，但通常它们由 4 部分信息组成：轨道引用索引、采样编号、偏移量和长度。其中一些对于特定协议可能是隐式的、这些“指针”始终指向数据的实际来源。如果一个 hint 轨道建在另一个 hint 轨道“顶部”，则第二个 hint 轨道必须包含第一个 hint 轨道使用的媒体轨道的直接引用，这些媒体轨道的数据被放在流中。

所有 hint 轨道使用通用的一组声明和结构：

- 将 hint 轨道链接到其携带的基本流轨道，通过 “hint” 类型的轨道引用
- 它们使用一个 handler 类型——Handler Reference Box 中是 “hint” 类型
- 它们使用一个 Hint Media Header Box
- 它们使用一个 hint 采样条目，位于采样描述，包含一个名称和格式，对于其代表的协议是唯一的
- 归于本地回放通常将它们标记为不可用，将其轨道头部标记置为 0

hint 轨道可通过创作工具创建，或通过 hint 工具增加到一个现有的演示。这样的工具可以充当媒体和协议之间的“桥梁”，因为它对两者都有深刻的了解。这支持创作工具了解媒体格式但不了解协议，且服务器可以理解协议(及其 hint 轨道)但不理解媒体数据的详细信息。

hint 轨道不使用单独的合成时间；hint 轨道中没有 “ctts” 表。hint 过程将正确计算传输时间作为解码时间。

## 8 box 定义

### 8.1 文件结构和常规 box

#### 8.1.1 Media Data Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| mdat | 文件 | N | >=0 |

此 box 包含媒体数据。在视频轨道中，此 box 包含视频帧。演示可以包含 0 个或多个 Media Data Box。实际的媒体数据遵循 type 字段；其结构由元数据描述(尤其参阅 8.5 节的 Sample Table，和 8.11.3 节的 Item Location Box)。

在大型演示中，可能希望此 box 中的数据超过 32 位大小的限制。在这种情况下，使用上面 4.2 小节中的 size 字段的对应的大数 largesize。

文件中可包含任意数量的 Media Data Box(如果所有媒体数据在其他文件中，则包含 0)。元数据通过其在文件中的绝对偏移量来引用媒体数据(参阅 8.7.5 小节的 Chunk Offset Box)；因此，可以轻松跳过 Media Data Box 头部和可用空间，还可以引用和使用没有任何 box 结构的文件。

```code
aligned(8) class MediaDataBox extends Box(‘mdat’) {
  bit(8) data[];
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| data | - | 包含的媒体数据 |

#### 8.1.2 Free Space Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| free/skip | 文件/其他 box | N | >=0 |

Free Space Box 的内容无关紧要，且可以忽略或删除对象，而不会影响演示。(删除对象时应格外注意，因为这可能使 Sample Table 中使用的偏移量无效，除非删除的对象位于所有媒体数据之后)。

```code
aligned(8) class FreeSpaceBox extends Box(free_type) {
  unsigned int(8) data[];
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| free_type | - | free/skip |

#### 8.1.3 Progressive Download Information Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| pdin | 文件 | N | 0/1 |

Progressive Download Information Box 帮助渐进式下载 ISO 文件，box 包含成对数字(到 box 末尾)，指定有效文件下载比特率(字节/秒)，以及建议的初始播放延迟(毫秒)。

接收方可以预估正在下载的速率，并通过对条目对线性差值或从第一个条目或最后一个条目进行外推，获得合适的初始延迟的较高估计值。

```code
aligned(8) class ProgressiveDownloadInfoBox
  extends FullBox(‘pdin’, version = 0, 0) {
  for (i=0; ; i++) { // to end of box
    unsigned int(32) rate;
    unsigned int(32) initial_delay;
  }
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| rate | - | 下载速率，表示为 字节/秒 |
| initial_delay | - | 播放文件时建议使用的延迟，由此如果以给定速率继续下载，文件内所有数据将及时到达以供使用，且回放无需暂停 |

### 8.2 影片结构

#### 8.2.1 Movie Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| moov | 文件 | Y | 1 |

演示的元数据存储在位于文件顶部的单个 Movie Box。通常，尽管不是必须的，此 box 通常靠近文件的开头或结尾。

```code
aligned(8) class MovieBox extends Box(‘moov’){
}
```

#### 8.2.2 Movie Header Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| mvhd | Movie Box(moov) | Y | 1 |

此 box 定义了和媒体无关的整体信息，并且与整个演示相关。

```code
aligned(8) class MovieHeaderBox extends FullBox(‘mvhd’, version, 0) {
  if (version==1) {
    unsigned int(64) creation_time;
    unsigned int(64) modification_time;
    unsigned int(32) timescale;
    unsigned int(64) duration;
  } else { // version==0
    unsigned int(32) creation_time;
    unsigned int(32) modification_time;
    unsigned int(32) timescale;
    unsigned int(32) duration;
  }
  template int(32) rate = 0x00010000; // typically 1.0
  template int(16) volume = 0x0100; // typically, full volume
  const bit(16) reserved = 0;
  const unsigned int(32)[2] reserved = 0;
  template int(32)[9] matrix =
    { 0x00010000,0,0,0,0x00010000,0,0,0,0x40000000 };
    // Unity matrix
  bit(32)[6] pre_defined = 0;
  unsigned int(32) next_track_ID;
} 
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| version | 整数 | 指定此 box 的版本(此规范是 0 或 1) |
| creation_time | 整数 | 声明演示的创建时间(从 1904-1-1 午夜起的秒数，UTC 时间) |
| modification_time | 整数 | 声明演示最近一次修改时间(从 1904-1-1 午夜起的秒数，UTC 时间) |
| timescale | 整数 | 指定整个演示的时间刻度；是经过一秒的时间单位数。比如，以 1/60 秒为单位测量时间的时间坐标系的时间刻度是 60 |
| duration | 整数 | 声明演示的长度(以指定的 timescale 为单位)。此属性源自演示的轨道：此字段的值对应演示最长轨道的时长。如果不能确定时长，则时长设置为全 1 |
| rate | 定点数 16.16 | 指示播放演示的首选速率；1.0(0x00010000) 是正常的正向回放 |
| volume | 定点数 8.8 | 指示首选的回放音量。1.0(0x0100) 是全音量 |
| matrix | - | 为视频提供转化矩阵；(u,v,w) 在这里限制为 (0,0,1)，16 进制值(0,0,0x40000000) |
| next_track_ID | 非 0 整数 | 指示要添加到演示的下一个轨道所用的轨道 ID 值。零不是有效的轨道 ID 值。next_track_ID 值应大于在用的最大轨道 ID。如果此值大于等于全 1(32 位 maxint)，且要增加新的媒体轨道，那么必须在文件中搜索未使用的轨道 ID |

### 8.3 轨道结构

#### 8.3.1 Track Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| trak | Movie Box(moov) | Y | >=1 |

这是一个容器 box，用于演示的单个轨道。每个演示包含一个或多个轨道。每个轨道都独立于演示中的其他轨道，并携带自己的时间和空间信息。每个轨道将包含其关联的 Media Box。

轨道用于两个目的：

- 包含媒体数据(媒体轨道)
- 包含流协议的打包信息(hint 轨道)

ISO 文件中至少应包含一个媒体轨道，且即使 hint 轨道未引用媒体轨道中的媒体数据，所有帮助组成 hint 轨道的媒体轨道应保留在文件中；删除所有 hint 轨道之后，将保留整个不带 hint 的演示。

```code
aligned(8) class TrackBox extends Box(‘trak’) {
}
```

#### 8.3.2 Track Header Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| tkhd | Track Box(trak) | Y | 1 |

此 box 指定单个轨道的特征。每个轨道中仅包含一个 Track Header Box。

在没有 Edit List 的情况下，轨道的显示从整个演示的开头开始。空 Edit 用于抵消轨道的开始时间。

媒体轨道的轨道头部 flags 的默认值为 7(track_enabled、track_in_movie、track_in_preview)。如果演示中所有轨道均未设置 track_in_movie 或 track_in_preview，则应将所有轨道视为在其上设置了中两个标记。服务器 hint 轨道应将 track_in_movie 和 track_in_preview 设为 0，以便在本地回放和预览时将其忽略。

在 “iso3” brand 以及共享要求的 brand 之下，轨道头部的 width 和 height 是在概念性的“正方形”(均匀)网格上测量的。在由布局或合成系统引起的任何转换或放置之前，将轨道视频数据按照这些尺寸归一化(逻辑上)。轨道(和影片)矩阵(如果使用)也可以在此均匀缩放的空间中操作。

此处的 duration 字段不包含之后的影片片段(如果有)的时长，而仅包括闭合的 Movie Box 的媒体的时长。当需要且可能时，可使用 Movie Extends Header Box 记录影片片段在内的时长。

```code
aligned(8) class TrackHeaderBox
  extends FullBox(‘tkhd’, version, flags){
  if (version==1) {
    unsigned int(64) creation_time;
    unsigned int(64) modification_time;
    unsigned int(32) track_ID;
    const unsigned int(32) reserved = 0;
    unsigned int(64) duration;
  } else { // version==0
    unsigned int(32) creation_time;
    unsigned int(32) modification_time;
    unsigned int(32) track_ID;
    const unsigned int(32) reserved = 0;
    unsigned int(32) duration;
  }
  const unsigned int(32)[2] reserved = 0;
  template int(16) layer = 0;
  template int(16) alternate_group = 0;
  template int(16) volume = {if track_is_audio 0x0100 else 0};
  const unsigned int(16) reserved = 0;
  template int(32)[9] matrix=
    { 0x00010000,0,0,0,0x00010000,0,0,0,0x40000000 };
    // unity matrix
  unsigned int(32) width;
  unsigned int(32) height;
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| version | 整数 | 指定此 box 的版本(此规范是 0 或 1) |
| flags | 24 位带标记的整数 | 定义了下面的值：track_enabled-指示轨道是否启用。flags 值是 0x000001。禁用的轨道(低位为 0)将其视为不存在；track_in_movie-指示演示使用此轨道。flags 值为 0x000002；track_in_preview-指示预览演示时使用此轨道。flags 值是 0x000004；Track_size_is_aspect_ratio-指示 width 和 height 字段不以像素为单位。值具有相同的单位，但是这些单位未指定。这些值仅表示所需的纵横比。如果该轨道和其他相关轨道的纵横比不相同，则轨道的相应位置不确定，可能由外部上下文定义。flags 值为 0x000008 |
| creation_time | 整数 | 声明此轨道的创建时间(从 1904-1-1 午夜起的秒数，UTC 时间) |
| modification_time | 整数 | 声明此轨道最近一次修改时间(从 1904-1-1 午夜起的秒数，UTC 时间) |
| track_ID | 整数 | 在演示整个生命周期唯一地标识此轨道。轨道 ID 永远不会重复使用，且不能为 0 |
| duration | 整数 | 指示此轨道的时长(以 Movie Header Box 的 timescale 为单位)。此字段值等于所有轨道的 Edit 总和。如果没有 Edit List，那么等于采样时长(转换为 Movie Header Box 的 timescale)的总和。如果此轨道的时长不能确定，则将其设置为全 1 |
| layer | 整数 | 指定视频轨道从前到后的顺序；编号较小的轨道更靠近观看者。0 是正常值，且 -1 将位于轨道 0 的前面，以此类推 |
| alternate_group | 整数 | 指定轨道组或集合。如果此字段为 0，则没有和其他轨道可能关系的信息。如果不为 0，则对于包含备用数据的轨道应该相同，对于属于不同组的轨道不同。在任何时候备用组中只应有一个轨道播放或流式传输，且必须通过属性(比如比特率、编解码器、语言、包大小等)与该组中其他轨道区分。一个组可能只有一个成员 |
| volume | 定点数 8.8 | 指定轨道的相对音频音量。全音量是 1.0(0x0100)，是正常值。该值与纯视觉轨道无关。可根据轨道音量组合轨道，然后使用整体的 Movie Header Box 的音量设置；或可以使用更复杂的音频组合(比如 MPEG-4 BIFS)  |
| matrix | - | 为视频提供转化矩阵；(u,v,w) 在这里限制为 (0,0,1)，16 进制值(0,0,0x40000000) |
| width/height | 定点数 16.16 | 值取决于轨道，如下所示 |

对于文本和字幕轨道，它们可能取决于编码格式来描述渲染区域的建议大小。对于此类轨道。值 0x0 也可以用于指示可以任何大小渲染数据，未指示任何首选大小，且可由外部环境或通过复用另一轨道的 width/height 确定实际大小。对于那些轨道，也可使用 track_size_is_aspect_ratio 标记。

对于非视觉轨道(比如音频)，应将其设置为 0。

对于所有其他轨道，它们指定轨道的可视展示大小。这些不必等同于采样描述记录的图像的像素尺寸；在对矩阵表示的轨道进行任何整体转换之前，将序列中的所有图像缩放到指定的尺寸。图像的像素尺寸是默认值。

#### 8.3.3 Track Reference Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| tref | Track Box(trak) | N | 0/1 |

此 box 提供了从包含的轨道到演示中另一个轨道的引用。这些引用是带类型的。“hint” 引用将包含的 hint 轨道链接到其提示的媒体数据。内容描述引用 “cdsc” 将描述性或元数据轨道链接到其描述的内容。“hind” 依赖表示引用的轨道可能包含媒体数据，解码包含此轨道引用的轨道需要这些数据。引用的轨道应该是 hint 轨道。比如，“hind” 依赖可以用于指示 hint 轨道之间的依赖，这些 hint 轨道记录 RTP 上的分层 IP 多播。

Track Box 内中仅可包含一个 Track Reference Box。

如果不存在此 box，则该轨道不会以任何方式引用任何其他轨道。调整引用数组以填充 Reference Type Box。

```code
aligned(8) class TrackReferenceBox extends Box(‘tref’) {
}
aligned(8) class TrackReferenceTypeBox (unsigned int(32) reference_type) extends
Box(reference_type) {
  unsigned int(32) track_IDs[];
} 
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| track_ID | 整数 | 提供了从包含的轨道到演示中另一个轨道的引用。track_IDs 永远不能重用且不能等于 0 |
| reference_type | 整数 | 应设为下面某个值，或是一个注册的或来自派生规范或注册的值：“hint”-引用的轨道包含此 hint 轨道的原始媒体；“cdsc”-此轨道描述了引用轨道；“font”-此轨道使用引用轨道携带/定义的字体；“hind”-此轨道依赖引用的 hint 轨道，即，只有使用引用的 hint 轨道时才应使用；“vdep”-此轨道包含引用视频轨道的辅助视差视频信息；“vplx”-此轨道包含引用视频轨道的辅助宽度视频信息；“subt”-此轨道包含字幕、定时的文本或叠加图形信息，用于引用的轨道或此轨道所属备用组中的任何轨道(如果有) |

#### 8.3.4 Track Group Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| trgr | Track Box(trak) | N | 0/1 |

此 box 可以指示轨道组，其中每个组共享特定的特征，或者组内的轨道具有特定的关系。该 box 包含零个或多个 box，并且通过所包含 box 的 box 类型指示特定的特征或关系。包含的 box 包括一个标识符，可用于推断属于同一轨道组的轨道。如果轨道 Track Group Box 内包含的 box 类型相同，且这些包含的 box 内具有相同标识符值，则这些轨道属于同一轨道组。

轨道组不得用于指示轨道之间的依赖关系。而是将 Track Reference Box 用于此类目的。

```code
aligned(8) class TrackGroupBox('trgr') {
}
aligned(8) class TrackGroupTypeBox(unsigned int(32) track_group_type) extends
  FullBox(track_group_type, version = 0, flags = 0)
{
  unsigned int(32) track_group_id;
  // the remaining data may be specified for a particular track_group_type
} 
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| track_group_type | 整数 | 指示分组类型，且应设置为下面某个值，或是一个注册的或来自派生规范或注册的值：“msrc”-指示此轨道属于一个多源演示。如果轨道有一个 track_group_type 为 “msrc” 的 Track Group Box，且 box 内的 track_group_id 相同，则将这些轨道映射为来自同一源。比如，视频电话呼叫的记录可能同时具有两个参与者的音频和视频，且一个参与者的音频轨道和视频轨道关联的 track_group_id 值，不同于另一个参与者的轨道关联的 track_group_id |
| track_group_id | 整数 | track_group_id 和 track_group_type 对标识文件内的轨道组。如果轨道包含特定轨道组类型 box，且 box 的 track_group_id 值相同，则这些轨道属于同一轨道组 |

### 8.4 轨道媒体结构

#### 8.4.1 Media Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| mdia | Track Box(trak) | Y | 1 |

此媒体声明容器包含所有对象，它们声明了轨道内媒体数据的信息。

```code
aligned(8) class MediaBox extends Box(‘mdia’) {
}
```

#### 8.4.2 Media Header Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| mdhd | Media Box(mdia) | Y | 1 |

此媒体头部声明了与媒体无关，且与轨道中的媒体特征相关的整体信息。

```code
aligned(8) class MediaHeaderBox extends FullBox(‘mdhd’, version, 0) {
  if (version==1) {
    unsigned int(64) creation_time;
    unsigned int(64) modification_time;
    unsigned int(32) timescale;
    unsigned int(64) duration;
  } else { // version==0
    unsigned int(32) creation_time;
    unsigned int(32) modification_time;
    unsigned int(32) timescale;
    unsigned int(32) duration;
  }
  bit(1) pad = 0;
  unsigned int(5)[3] language; // ISO-639-2/T language code
  unsigned int(16) pre_defined = 0;
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| version | 整数 | 指定此 box 的版本(0 或 1) |
| creation_time | 整数 | 声明此轨道中媒体的创建时间(从 1904-1-1 午夜起的秒数，UTC 时间) |
| modification_time | 整数 | 声明此轨道中媒体最近一次修改时间(从 1904-1-1 午夜起的秒数，UTC 时间) |
| timescale | 整数 | 指定此媒体的时间刻度；是经过一秒的时间单位数。比如，以 1/60 秒为单位测量时间的时间坐标系的时间刻度是 60 |
| duration | 整数 | 声明此媒体的时长(以 timescale 为单位)。如果无法确定时长，则将 duration 设置为全 1 |
| language | - | 声明此媒体的语言代码。参阅 ISO 639-2/T 的三个字符的代码集合。每个字符打包为其 ASCII 值和 0x60 的差值。由于代码仅限于三个小写字母，因此这些值严格为正 |

#### 8.4.3 Handler Reference Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| hdlr | Media Box(mdia) 或 Meta Box(meta) | Y | 1 |

此 box 在 Media Box 内，声明轨道中媒体的性质，从而声明展示轨道中媒体数据的过程。例如，视频轨道将由视频 handler 处理。比如，剑气分发视频的格式将存储在视频轨道中，标识由视频 handler 处理。媒体格式的存储文档标识该格式使用的媒体类型。

此 box 存在 Meta Box 内时，声明“元” box 内容的结构或格式。

对于任何类型的元数据流都有一个通用的 handler；比如，对于视频或音频，通过采样条目标识特定的格式。

```code
aligned(8) class HandlerBox extends FullBox(‘hdlr’, version = 0, 0) {
  unsigned int(32) pre_defined = 0;
  unsigned int(32) handler_type;
  const unsigned int(32)[3] reserved = 0;
  string name;
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| version | 整数 | 指定此 box 的版本 |
| handler_type | 整数 | 在 Media Box 内时包含下面的某个值(vide-视频轨道；soun-音频轨道；hint-hint 轨道)或来自派生规范。在 Meta Box 内时包含一个合适的值，以支持元 box 内容的格式 |
| name | null 结尾的字符串 | UTF-8 字符表示，为轨道类型提供易于理解的名称(便于调试和检查) |

#### 8.4.4 Media Information Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| minf | Media Box(mdia) | Y | 1 |

此 box 包含所有声明轨道中媒体特征信息的对象。

```code
aligned(8) class MediaInformationBox extends Box(‘minf’) {
} 
```

#### 8.4.5 Media Information Header Box

##### 8.4.5.1 定义

每个轨道类型(对应媒体的 handler 类型)有一个不同的媒体信息头；匹配的头部应该存在，可以是 12 节定义的头部之一，也可以是派生规范中定义。

媒体头类型的使用由媒体类型的定义缺点，且必须与媒体 handler 匹配。

##### 8.4.5.2 Null Media Header Box

未标识特定媒体头的流使用此处定义的 NULL Media Header Box。

```code
aligned(8) class NullMediaHeaderBox
  extends FullBox(’nmhd’, version = 0, flags) {
} 
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| version | 整数 | 指定此 box 的版本 |
| flags | 24 位整数 | 标记位(目前都是 0) |

#### 8.4.6 Extended Language Tag

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| elng | Media Box(mdia) | N | 0/1 |

Extended Language Tag Box 表示媒体的语言信息，基于 RFC 4646 (最佳实践——BCP-47)行业标准。它是 Media Header Box 的可选对等项，且必须出现在 Media Header Box 之后。

与 Media Header 中 language 字段相比，Extended Language Tag 可以提供更好的语言信息，包括作为部分(或子标签)的信息(比如区域、字体、变体等)。

Extended Language Tag Box 是可选的，如果不存在，则应使用媒体语言。如果它们不一致，则 Extended Language Tag 覆盖媒体语言。

为了最好地兼容早期的播放器，如果指定了 Extended Language Tag，则应在 Media Header Box 的 language 字段指定最兼容的语言代码(例如，如果 Extended Language Tag 为 “en-UK”，则使用 “eng”)。如果没有相当兼容的标签，则可以使用 “und” 的打包格式。

```code
aligned(8) class ExtendedLanguageBox extends FullBox(‘elng’, 0, 0) {
  string extended_language;
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| extended_language | null 结尾的字符串 | 包含符合 RFC 4646 (BCP 47) 的语言标签字符串，比如 “en-US”、“fr-FR” 或 “zh-CN” |

### 8.5 采样表

#### 8.5.1 Sample Table Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| stbl | Media Information Box(minf) | Y | 1 |

采样表包含轨道内媒体采样的所有时间和数据索引。使用这里的表格，可以及时定位采样、确定采样类型(例如是否是 I 帧)，并确定采样的大小、容器以及到该容器的偏移。

如果包含 Sample Table Box 的轨道没有引用数据，那么 Sample Table Box 不需要包含任何子 box(这不是非常有用的媒体轨道)。

如果包含 Sample Table Box 的轨道确实引用了数据，则需要以下子 box：Sample Description、Sample Size、Sample To Chunk 和 Chunk Offset。此外，Sample Description Box 应包含至少一个条目。需要 Sample Description Box 是因为其中包含 data_reference_index 字段，用来指示检索媒体采样时使用的 Data Reference Box。没有 Sample Description，就无法确定媒体采样存储的位置。Sync Sample Box 是可选的。如果它不存在，则所有采样都是同步采样。

A.7 使用 Sample Table Box 中定义的结构，对随机访问做了叙述性描述。

```code
aligned(8) class SampleTableBox extends Box(‘stbl’) {
}
```

#### 8.5.2 Sample Description Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| stsd | Sample Table Box(stbl) | Y | 1 |

Sample Description Table 提供了有关使用的编码类型的详细信息，以及该编码所需的任何初始化信息。

存储在 Sample Description Box 内 entry_count 之后的信息是特定轨道类型的，正如此处记录的，且在轨道类型内也可以有变体(例如，即使在视频轨道中，不同的编码可能在某些公共字段之后使用不同的特定信息)。

由媒体 handler 决定所用采样条目形式的类型，使用合适的形式，比如 12 节定义的形式，或派生规范定义的或注册的形式。

一个轨道内可能使用多个描述。

注意：虽然计数是 32 位，item 数目通常非常小，且受限于采样条目中的引用索引只有 16 位的事实。

如果无法识别 SampleEntry 的 “format” 字段，则不应解码 Sample Description 本身或相关的媒体采样。

注意：采样条目的定义以特定顺序指定 box ，且派生规范通常也遵循。为了最大的兼容性，编写者构造文件应遵守规范和继承隐含的顺序，而读者应准备接受任何 box 顺序。

即使未使用，所有字符串应该是 null 结尾的。“可选的”意味着至少有一个 null 字节。

通过 MIME 类型标识格式的条目，比如 TextSubtitleSampleEntry、TextMetaDataSampleEntry 或     SimpleTextSampleEntry，所有这些包含一个 MIME 类型，可用于表示流格式应用的 MIME 类型。如果可选的配置 box 内的字符串内容(没有 null 结束符)，之后是一组采样(起始于一个同步采样，并在同步采样之前的采样结束)的内容，将字符串内容完整地连接起来，并且结果满足 MIME 类型文档的解码需求，则使用该 MIME 类型。仅当格式指定“逐步解码”行为才应使用非同步采样，然后采样时间指示何时应显示这种逐步解码结果(根据媒体类型)。

注意：如果轨道都是同步采样，因此其中的采样都是该 MIME 类型的有效文档。

在一些派生自 SampleEntry 的类中，使用 namespace 和 schema_location 标识 XML 文档内容，声明 “brand” 或配置兼容性。多个 namespace 标识符标识轨道符合每个标识符代表的规范，其中一些标识符可能表示存在特征的超集。解码器应能够解码所有 namespace，以便能够解码和正确呈现与此采样条目关联的媒体。

注意：此外，namespace 标识符可能表示性能约束(比如文档大小、字体大小、绘图速率等限制)以及语法约束(比如不支持或忽略的功能)。

```code
aligned(8) abstract class SampleEntry (unsigned int(32) format)
  extends Box(format){
  const unsigned int(8)[6] reserved = 0;
  unsigned int(16) data_reference_index;
}
class BitRateBox extends Box(‘btrt’){
  unsigned int(32) bufferSizeDB;
  unsigned int(32) maxBitrate;
  unsigned int(32) avgBitrate;
}
aligned(8) class SampleDescriptionBox (unsigned int(32) handler_type)
  extends FullBox('stsd', version, 0){
  int i ;
  unsigned int(32) entry_count;
  for (i = 1 ; i <= entry_count ; i++){
  SampleEntry(); // an instance of a class derived from SampleEntry
  }
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| version | 整数 | 指定此 box 的版本 |
| entry_count | 整数 | 给出下表的条目计数 |
| SampleEntry | - | 适合的采样条目 |
| data_reference_index | 整数 | 包含数据引用的索引，用于检索使用此采样描述的采样相关的数据。数据引用存储在 Data Reference Box。索引范围从 1 到数据引用数 |
| bufferSizeDB | 整数 | 给出基本流的解码缓冲区的大小，单位是字节 |
| maxBitrate | 整数 | 给出任何一秒的窗口的最大速率，单位是 比特/秒 |
| avgBitrate | 定点数 16.16 | 给出整个演示的平均速率，单位是 比特/秒 |

#### 8.5.3 Degradation Priority Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| stdp | Sample Table Box(stbl) | N | 0/1 |

此 box 包含每个采样的降级优先级。每个采样一个值，将这些值存储在表中。表的大小 sample_count 取自 Sample Size Box(“stsz”) 的 sample_count。由此派生的规范为 priority 字段定义确切含义和可接受范围。

```code
aligned(8) class DegradationPriorityBox
  extends FullBox(‘stdp’, version = 0, 0) {
  int i;
  for (i=0; i < sample_count; i++) {
    unsigned int(16) priority;
  }
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| version | 整数 | 指定此 box 的版本 |
| priority | 整数 | 为每个采样指定降级优先级 |

### 8.6 轨道时间结构

#### 8.6.1 Time to Sample Box

##### 8.6.1.1 定义

采样的合成时间(CT)和解码时间(DT)来自 Time to Sample Box，其中有两种类型。解码时间在 Decoding Time to Sample Box 中定义，给出连续解码时间之间的时间增量。合成时间在 Composition Time to Sample Box 中，由合成时间与解码时间的时间偏移量得到。如果轨道中每个采样的合成时间和解码时间都相同，则仅需要 Decoding Time to Sample Box；一定不能出现 Composition Time to Sample Box。

Time to Sample Box 必须为所有采样提供非零的时长，最后一个采样可能除外。“stts” box 中的时长是严格的正数(非零)，除了最后一条条目可能为零。此规则源于流中没有两个时间戳可以相同的规则。将采样添加到流中时必须格外小心，为了遵守该规则，可能需要将先前最后一个采样的时长设为非零。如果最后一个采样的时长不确定，使用任意小的值和 “dwell” edit。

某些编码系统可能允许只用做引用而非输出的采样(比如视频中未显示的引用帧)。轨道中出现任何这样的非输出采样时，以下内容适用：

1. 应给出非输出采样的合成时间，此时间在输出采样的时间范围之外
2. 应使用 edit list 排除非输出采样的合成时间
3. 当轨道包含一个 CompositionOffsetBox(“ctts”) 时
   1. 应使用 CompositionOffsetBox 第 1 版
   2. 对于每个非输出采样，应设置 sample_offset 值等于最大可能的负数(32 位就是 -2^31)
   3. 轨道的 SampleTableBox 应包含 CompositionToDecodeBox(“cslg”)，且
   4. 当轨道出现 CompositionToDecodeBox，box 中的 leastDecodeToDisplayDelta 字段值应等于 CompositionOffsetBox 中的最小合成偏移量，不包含非输出采样的 sample_offset 值
      1. 注意：因此，leastDecodeToDisplayDelta 大于 -2^31

在以下示例中，有一个 I、P 和 B 帧序列，每帧的解码时间增量为 10。按以下方式存储采样，包含标明的解码时间增量和合成时间偏移量(实际的 CT 和 DT 仅供参考)。因为必须在双向预测的 B 帧之前对预测的 P 帧进行解码，因此需要重新排序。采样的 DT 值始终是之前采样的差值之和。注意，解码增量的综合是该轨道中媒体的时长。

表 2——闭合的 GOP 示例

![闭合的 GOP 示例](closed_gop_example.png)

表 3——开放的 GOP 示例

![开放的 GOP 示例](open_gop_example.png)

##### 8.6.1.2 Decoding Time to Sample Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| stts | Sample Table Box(stbl) | Y | 1 |

此 box 包含表格的紧凑版本，该表允许从解码时间到采样编号的索引。其他表格则根据采样编号给出采样大小和指针。表中的每个条目给出具有相同时间增量的连续采样的数目，以及这些采样的增量。通过添加增量可以构建完整的采样时间图。

Decoding Time to Sample Box 包含解码时间增量：DT(n+1)=DT(n)+STTS(n)，其中 STTS(n) 是采样 n 的(未压缩)表条目。

采样条目通过解码时间戳排序；因此增量都是非负的。

DT 轴的原点为零；DT(i)=SUM(for j=0 to i-1 of delta(j))，所有 delta 的总和给出轨道中媒体的长度(未映射到整体时间范围，且未考虑任何 Edit List)。

如果 Edit List Box 非空(非零)，则其提供初始的 CT 值。

```code
aligned(8) class TimeToSampleBox
  extends FullBox(’stts’, version = 0, 0) {
  unsigned int(32) entry_count;
  int i;
  for (i=0; i < entry_count; i++) {
    unsigned int(32) sample_count;
    unsigned int(32) sample_delta;
  }
}
```

比如对于表 2，条目会是：

| sample_count | sample_delta |
| --- | --- |
| 14 | 10 |

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| version | 整数 | 指定此 box 的版本 |
| entry_count | 整数 | 对下表的条目计数 |
| sample_count | 整数 | 具有给定时长的连续采样的数目 |
| sample_delta | 整数 | 在媒体的时间范围内给出这些采样的增量 |

##### 8.6.1.3 Composition Time to Sample Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| ctts | Sample Table Box(stbl) | N | 0/1 |

此 box 提供解码时间和合成时间的偏移量。因为解码时间必须小于合成时间，偏移表示为无符号数，以使 CT(n)=DT(n)+CTTS(n)，其中 CTTS(n) 是采样 n 的(未压缩)表条目。在此 box 第 1 版中，合成时间线和解码时间线仍来自彼此，但是偏移量是有符号的。建议对于计算的合成时间戳，刚好有一个值为 0。

不管 box 是哪个版本，每个采样必须有一个唯一的合成时间戳值，即两个采样的时间戳不能相同。

有可能在时间 0 没有帧可以合成；对此的处理是未指定的(系统可以将第一帧显示更长时间或更合适的填充色)。

当使用此 box 的第 1 版时，CompositionToDecodeBox 也可能出现在采样表中，以关联合成和解码时间线。当需要向后兼容或兼容一组未知的阅读器时，应尽可能使用此 box 第 0 版。不管是哪个版本，尤其是在第 0 版，如果希望媒体从轨道时间 0 开始，且第一个媒体采样的合成时间不为 0，则可以使用 edit list 来“移动”媒体到时间 0。

Composition Time to Sample Table 是可选的，且只有所有采样的 DT 与 CT 不同时才必须存在。

hint 轨道不使用此 box。

比如对于表 2，条目会是：

| sample_count | sample_offset |
| --- | --- |
| 1 | 10 |
| 1 | 30 |
| 2 | 0 |
| 1 | 30 |
| 2 | 0 |
| 1 | 10 |
| 1 | 30 |
| 2 | 0 |
| 1 | 30 |
| 2 | 10 |

```code
aligned(8) class CompositionOffsetBox
  extends FullBox(‘ctts’, version = 0, 0) {
  unsigned int(32) entry_count;
  int i;
  for (i=0; i < entry_count; i++) {
    unsigned int(32) sample_count;
    unsigned int(32) sample_offset;
  }
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| version | 整数 | 指定此 box 的版本 |
| entry_count | 整数 | 对下表的条目计数 |
| sample_count | 整数 | 具有给定偏移量的连续采样的数目 |
| sample_offset | 非负整数 | 给出 CT 和 DT 的偏移量，以使 CT(n)=DT(n)+CTTS(n) |

##### 8.6.1.4 Composition to Decode Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| cslg | Sample Table Box(stbl)/Track Extension Properties Box(trep) | N | 0/1 |

使用有符号的合成偏移量时，此 box 可用于关联合成和解码时间线，并处理有符号合成偏移量引入的一些歧义。

注意，所有这些字段适用整个媒体(而不仅是 edit 选中的)。建议任何显式或隐式的 edit，都不要选择合成时间线中未映射到采样的任何部分。例如，如果最小合成时间是 1000，则默认从 0 到媒体市场的 edit 留出从 0 到 1000 的时间段，这段时间没有媒体采样关联。在这种情况下，播放器的行为以及此间隔内构成的内容是不确定的。建议最小的计算的 CTS 是 0，或匹配第一个 edit 的开始。

轨道中最后一个采样的合成时长可能(通常是)模糊或不清楚；compositionEndTime 字段可用于澄清这种歧义，并结合 compositionStartTime 为轨道建立清楚的合成时长。

当 Composition to Decode Box 包含在 Sample Table Box 中时，它仅记录 Movie Box 中采样的合成和解码时间的关系，不包含任何后续的影片片段。当 Composition to Decode Box 包含在 Track Extension Properties Box 中时，它记录 Movie Box 之后所有影片片段采样的合成和解码时间的关系。

此 box 的第 1 版支持 64 位时间戳，且只在需要时才应该使用(至少一个值不适用 32 位)。

```code
class CompositionToDecodeBox extends FullBox(‘cslg’, version, 0) {
  if (version==0) {
    signed int(32) compositionToDTSShift;
    signed int(32) leastDecodeToDisplayDelta;
    signed int(32) greatestDecodeToDisplayDelta;
    signed int(32) compositionStartTime;
    signed int(32) compositionEndTime;
  } else {
    signed int(64) compositionToDTSShift;
    signed int(64) leastDecodeToDisplayDelta;
    signed int(64) greatestDecodeToDisplayDelta;
    signed int(64) compositionStartTime;
    signed int(64) compositionEndTime;
  }
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| compositionToDTSShift | 整数 | 如果增加此值到合成时间(通过 CTS 到 DTS 的偏移量计算)，则对于所有采样，确保其 CTS 大于等于 DTS，并且将会接受指示的配置文件/级别隐含的缓冲区模型；如果 leastDecodeToDisplayDelta 大于等于 0，此字段可为 0；否则至少为 (-leastDecodeToDisplayDelta) |
| leastDecodeToDisplayDelta | 整数 | 轨道的 CompositionTimeToSample Box 中最小的合成偏移量 |
| greatestDecodeToDisplayDelta | 整数 | 轨道的 CompositionTimeToSample Box 中最大的合成偏移量 |
| compositionStartTime | 整数 | 最小的计算的合成时间(CTS)，包含此轨道中的媒体所有采样 |
| compositionEndTime | 整数 | 对于此轨道媒体中具有最大 CTS 的采样，合成时间加上合成时长；如果此字段取值 0，则合成结束时间未知 |

#### 8.6.2 Sync Sample Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| stss | Sample Table Box(stbl) | N | 0/1 |

此 box 提供了流内随机访问点的紧凑标记。该表按采样编号的严格递增顺序排序。

如果不存在 Sync Sample Box，则每个采样都是同步采样。

```code
aligned(8) class SyncSampleBox
  extends FullBox(‘stss’, version = 0, 0) {
  unsigned int(32) entry_count;
  int i;
  for (i=0; i < entry_count; i++) {
    unsigned int(32) sample_number;
  }
 }
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| version | 整数 | 指定此 box 的版本 |
| entry_count | 整数 | 给出下表的条目数。如果为 0，则流内没有随机访问点，且下表为空 |
| sample_number | 整数 | 给出采样(同步采样)的计数 |

#### 8.6.3 Shadow Sync Sample Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| stsh | Sample Table Box(stbl) | N | 0/1 |

Shadow Sync Table 提供一组可选的同步样本，这些采样可用于 seek 或类似目的。在正常的前向播放中，将其忽略。

Shadow Sync Table 中的每个条目由一对采样编号组成。第一个编号 (shadowed-sample-number) 指示将为该采样编号定义 shadow sync。这应该总是非同步采样(比如帧差异)。第二个采样编号  (sync-sample-number) 指示当在 shadowed-sample-number 或在其之前有随机访问时，可使用的同步采样(比如关键帧)的采样编号。

Shadow Sync Box 中的条目应基于 shadowed-sample-number 字段进行排序。

尽管不是必须的，但是通常将 shadow sync sample 放在正常播放期间未显示的轨道区域(通过 Edit List 进行编辑)。可以忽略 Shadow Sync Table，且忽略时轨道将正确(尽管可能不是最佳的)播放(和 seek)。

Shadow Sync Sample 替换而不是增加其 shadow 的采样(也就是，下一个发送的采样是 shadowed-sample-number+1)。将 Shadow Sync Sample 视为好像在其 shadow 的采样发生时一样，具有该采样的时长。

如果 shadow 采样也用作正常回放的一部分，或不止一次用作 shadow，hint 和传输可能会变得更加复杂。在这种情况下，hint 轨道可能需要单独的 shadow sync，所有 shadow sync 都可以从媒体轨道的一个 shadow sync 中获取其媒体数据，以允许其头部所需的不同时间戳等。

```code
aligned(8) class ShadowSyncSampleBox
  extends FullBox(‘stsh’, version = 0, 0) {
  unsigned int(32) entry_count;
  int i;
  for (i=0; i < entry_count; i++) {
    unsigned int(32) shadowed_sample_number;
    unsigned int(32) sync_sample_number;
  }
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| version | 整数 | 指定此 box 的版本 |
| entry_count | 整数 | 给出下表的条目数 |
| shadowed_sample_number | 整数 | 给出存在备用同步采样的采样编号 |
| sync_sample_number | 整数 | 给出备用同步采样的编号 |

#### 8.6.4 Independent and Disposable Samples Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| sdtp | Sample Table Box(stbl) | N | 0/1 |

这个可选的表格回答关于采样独立性的三个问题：

1. 这个采样依赖其他采样吗(它是否是一个 I-picture)？
2. 其他采样依赖这个采样吗？
3. 这个采样在此瞬间(可能有不同的依赖)包含多个(冗余)的数据编码吗？

在缺少此表的情况下：

1. Sync Sample Table 回答第一个问题；在大多数视频编码中，I-picture 也是同步点
2. 其他采样对这个采样的依赖是未知的
3. 冗余编码的存在性是未知的

当执行 “trick” 模式时，比如快速向前，可以使用第一条信息定位独立可解码的采样。类似地，当执行随机访问时，可能需要定位先前的同步点或随机访问恢复点，并从同步点或随机访问回复点的预滚动开始点向前滚动到所需的点。在向前滚动时，不需要检索或解码没有其他采样依赖的采样。

“sample_is_depended_on” 值与冗余编码的存在性无关。然而，冗余编码可能对主编码有不同的依赖；如果有冗余编码，则 “sample_depends_on” 仅记录主要编码。

相对于参考采样定义了前导采样(通常是视频中的图片)，参考样本是紧挨着的前一个采样，该采样标记为 “sample_depends_on” 没有依赖(一个 I 帧)。前导采样的合成时间在参考采样之前，还可能对参考采样之前的采样具有解码依赖性。因此，比如，如果回放和解码从参考采样开始，则那些标记为前导的采样将不再需要，且可能无法解码。因此，前导采样本身不能标记为没有依赖性。

对于 handler_type 不是 “vide”、“soun”、“hint”或“auxv”的轨道，如果已经处理了 sample_depends_on=2 或标记为“同步采样”的另一个样本，除非另外指定，可以丢弃标记为 sample_depends_on=2 以及 sample_has_redundancy=1 的采样，并将其时长增加到前一个采样的时长，以保持后续采样的时间。

表的大小 sample_count 取自 Sample Size Box(“stsz”) 或 Compact Sample Size Box(“stz2”) 的 sample_count。

Track Fragment Box 中也可能出现采样依赖 box。

```code
aligned(8) class SampleDependencyTypeBox
  extends FullBox(‘sdtp’, version = 0, 0) {
  for (i=0; i < sample_count; i++){
  unsigned int(2) is_leading;
  unsigned int(2) sample_depends_on;
  unsigned int(2) sample_is_depended_on;
  unsigned int(2) sample_has_redundancy;
  }
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| is_leading | - | 取自下面 4 个值之一：0-此采样的前导属性位置；1-此采样是前导采样，对参考的 I 帧之前有依赖(因此不可解码)；2-此采样不是前导采样；3-次采样是前导采样，对参考的 I 帧之前没有依赖(因此可以解码) |
| sample_depends_on | 整数 | 取自下面 4 个值之一：0-此采样的依赖未知；1-此采样依赖其他采样(不是 I 帧)；2-此采样不依赖其他采样(I 帧)；3-保留 |
| sample_is_depended_on | 整数 | 取自下面 4 个值之一：0-其他采样对此采样的依赖未知；1-其他采样依赖此采样(不可丢弃的)；2-其他采样不依赖此采样(可丢弃的)；3-保留 |
| sample_has_redundancy | 整数 | 取自下面 4 个值之一：0-此采样是否有冗余编码未知；1-此采样有冗余编码；2-此采样没有冗余编码；3-保留 |

#### 8.6.5 Edit Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| edts | Track Box(trak) | N | 0/1 |

Edit Box 将演示时间线映射到存储在文件中的媒体时间线。Edit Box 是 Edit List Box 的容器。

Edit Box 是可选的。在没有此 box 的情况下，这些时间线存在隐式的一对一映射，且轨道的显示从演示的开头开始。空的 Edit Box 用于抵消轨道的开始时间。

```code
aligned(8) class EditBox extends Box(‘edts’) {
}
```

#### 8.6.6 Edit List Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| elst | Edit Box(edts) | N | >=0 |

此 box 包含一个显式的时间线映射。每个条目定义轨道时间线的一部分：通过映射媒体时间线的一部分，或通过指示“空”时间，或通过定义 “dwell”，对应媒体内的单个时间点将保持一段时间。

请注意，未限制 edit 落在采样时间上。这意味着，当进入 edit 时，可能有必要：

- 备份到一个同步点，并从该位置预滚动，然后
- 注意第一个采样的时长——如果 edit 进入采样的正常时长内，采样可能被截断

如果是音频，则可能需要对该帧重新解码，然后完成最后的切片。同样，在 edit 中最后一个采样的时长可能需要切片。

轨道(流)的起始偏移量用一个初始的空 edit 表示。比如，要从轨道开始播放 30 秒，但是在演示播放第 10 秒时，我们有下面的 edit list：

```txt
entry_count = 2

segment_duration = 10s
media_time = -1
media_rate = 1

segment_duration = 30s (可能是整个轨道的长度)
media_time = 0s
media_rate = 1
```

非空 edit 啃个会插入媒体时间线的一部分，该部分在初始影片中不存在，且仅在后续影片片段中存在。特别是分段影片文件的空初始影片中(还没有出现媒体采样)，此 edit 的 segment_duration 可为 0，因此，edit 为影片和后续的影片片段提供了媒体合成时间到影片显示时间的偏移量。当使用合成偏移量时，建议用这样的 edit 为第一个显示的采样构建显示时间为 0。

例如，如果第一个合成帧的和城市间是 20，则将媒体时间从 20 开始映射到影片时间 0 开始的 edit，将显示为：

```txt
entry_count = 1

segment_duration = 0
media_time = 20
media_rate = 1
```

```code
aligned(8) class EditListBox extends FullBox(‘elst’, version, 0) {
  unsigned int(32) entry_count;
  for (i=1; i <= entry_count; i++) {
  if (version==1) {
    unsigned int(64) segment_duration;
    int(64) media_time;
  } else { // version==0
    unsigned int(32) segment_duration;
    int(32) media_time;
  }
  int(16) media_rate_integer;
  int(16) media_rate_fraction = 0;
  }
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| version | 整数 | 指定此 box 的版本(0 或 1) |
| entry_count | 整数 | 指定下标的条目数 |
| segment_duration | 整数 | 指定此 edit 段的时长，单位是 Movie Header Box 的 timescale |
| media_time | 整数 | 包含此 edit 段的媒体内的起始时间(以媒体的时间刻度为单位，以合成时间为单位)。如果此字段为 -1，则为空 edit。轨道中最后一个 edit 不应为空。Movie Header Box 的时长和轨道时长的任何差异表示为最后隐含的空 edit |
| media_rate_integer/media_rate_fraction | 整数 | 指定播放对应此 edit 段的媒体的相对速率。如果值为 0，则说明 edit 指定了 “dwell”：在 media_time 处的媒体显示 segment_duration。否则此字段的值应为 1 |

### 8.7 轨道数据布局结构

#### 8.7.1 Data Information Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| dinf | Media Information Box(minf)/Meta Box(meta) | Y(minf)/N(meta) | 1 |

box 包含声明轨道内媒体信息位置的对象。

```code
aligned(8) class DataInformationBox extends Box(‘dinf’) {
}
```

#### 8.7.2 Data Reference Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| dref | Data Information Box(dinf) | Y | 1 |

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| url/urn | Data Information Box(dref) | Y(至少出现一个 url 或 urn) | >=1 |

数据引用对象包含一个数据引用表(通常是 URL)，这些表声明了演示中使用的媒体数据的位置。采样描述内的数据引用索引将此表中的条目和轨道中的采样关联。可通过此方式将轨道分为多个源。

如果设置了标记以指示数据与此 box 在同一文件，则在条目字段中不应提供任何字符串(空字符串也不行)。

DataReferenceBox 内的 entry_count 应该大于等于 1；DataReferenceBox 内的每个 DataEntryBox 应该是 DataEntryUrnBox 或 DataEntryUrlBox。

```code
aligned(8) class DataEntryUrlBox (bit(24) flags)
  extends FullBox(‘url ’, version = 0, flags) {
  string location;
}
aligned(8) class DataEntryUrnBox (bit(24) flags)
  extends FullBox(‘urn ’, version = 0, flags) {
  string name;
  string location;
}
aligned(8) class DataReferenceBox
  extends FullBox(‘dref’, version = 0, 0) {
  unsigned int(32) entry_count;
  for (i=1; i <= entry_count; i++) { entry_count; i++) {
    DataEntryBox(entry_version, entry_flags) data_entry;
  }
} 
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| version | 整数 | 指定此 box 的版本 |
| entry_count | 整数 | 对实际条目计数 |
| entry_version | 整数 | 指定条目格式的版本 |
| entry_flags | 24 位整数 | 定义 0x000001 标记，表示媒体数据与包含此数据引用的 Movie Box 在同一文件 |
| data_entry | - | URL 或 URN 条目。name 是 URN， 且在 URN 条目是必须的。location 是 URL (URL 条目必须，URN 条目可选)，提供位置以使用给定名称查找资源。每个都是使用 UTF-8 字符以空字符结尾的字符串。如果设置了 selfcontained 标记，使用 URL 形式且不存在任何字符串；box 以 entry_flags 字段结尾。URL 类型(如类型为文件、http、ftp 等)应该是提供文件的服务，且该服务理想情况下支持还支持随机访问。允许相对 URL，且是相对于包含 Movie Box 的文件，该 Movie Box 包含此数据引用 |

#### 8.7.3 Sample Size Boxes

##### 8.7.3.1 定义

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| stsz/stz2 | Sample Table Box(stbl) | Y | 1(变体) |

此 box 包含采样计数和一个表格，该表给出每个采样的字节数。这允许媒体数据本身未分帧。媒体中的采样总数使用显示在采样技术中。

Sample Size Box 有两种。第一种有一个固定 32 位的字段用于表示采样尺寸；它允许为轨道内的所有采样定义固定尺寸。第二章允许更小的字段，以便在尺寸不同且较小时可以节省空间。必须存在这两种 box 之一；为了最大兼容性首选第一个版本。

注意，通常不禁止将采样大小设为 0，但是对于采样所属的编码系统(如采样条目所定义)，该大小必须有效且已定义。

##### 8.7.3.2 Sample Size Box

```code
aligned(8) class SampleSizeBox extends FullBox(‘stsz’, version = 0, 0) {
  unsigned int(32) sample_size;
  unsigned int(32) sample_count;
  if (sample_size==0) {
    for (i=1; i <= sample_count; i++) {
      unsigned int(32) entry_size;
    }
  }
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| version | 整数 | 指定此 box 的版本 |
| sample_size | 整数 | 指定默认采样大小。如果所有采样大小相同，此字段包含该值。如果此字段为 0，那么采样大小不相同，且采样大小保存保存在采样尺寸表中。如果此字段不是 0，它指定固定采样大小，且之后没有数组 |
| sample_count | 整数 | 给出轨道内的采样数；如果 sample_size 为 0，这也是下表的条目数 |
| entry_size | 整数 | 指定采样大小，通过采样编号进行索引 |

##### 8.7.3.3 Compact Sample Size Box

```code
aligned(8) class CompactSampleSizeBox extends FullBox(‘stz2’, version = 0, 0) {
  unsigned int(24) reserved = 0;
  unisgned int(8) field_size;
  unsigned int(32) sample_count;
  for (i=1; i <= sample_count; i++) {
    unsigned int(field_size) entry_size;
  }
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| version | 整数 | 指定此 box 的版本 |
| field_size | 整数 | 指定下标条目的大小(单位比特)；其值应取自 4/8/16。如果使用 4，则每个字节包含两个值：entry\[i\]<=4+entry\[i+1\]；如果大小不能填充整数字节，则最后一个字节使用零填充 |
| sample_count | 整数 | 给出下表的条目数 |
| entry_size | 整数 | 指定采样大小，通过采样编号进行索引 |

#### 8.7.4 Sample To Chunk Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| stsc | Sample Table Box(stbl) | Y | 1 |

媒体内的采样分分组成块。块大小可以不同，且同一块中的采样大小可以不同。此表可用于查找包含采样的块，块的位置和相关的样本描述。

此表示紧凑编码的。每个条目给出一组块的第一个块的索引，这些块具有相同特征。通过从上一个条目减去一个条目，可以计算该组有多少块。你可以将其乘以合适的“采样数/块”从而转换为采样数。

```code
aligned(8) class SampleToChunkBox
  extends FullBox(‘stsc’, version = 0, 0) {
  unsigned int(32) entry_count;
  for (i=1; i <= entry_count; i++) {
    unsigned int(32) first_chunk;
    unsigned int(32) samples_per_chunk;
    unsigned int(32) sample_description_index;
  }
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| version | 整数 | 指定此 box 的版本 |
| entry_count | 整数 | 给出下表的条目数 |
| first_chunk | 整数 | 给出一组块的第一个块的索引，这些块有相同的 samples_per_chunk 和sample_description_index；轨道中第一个块的索引值是 1(此 box 的第一个记录的 first_chunk 值为 1，表示第一个采样映射到该块) |
| samples_per_chunk | 整数 | 给出这些块中每个块的采样数 |
| sample_description_index | 整数 | 给出采样条目的索引，该条目描述此块的采样。索引范围从 1 到 Sample Description Box 的采样条目数 |

#### 8.7.5 Chunk Offset Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| stso/co64 | Sample Table Box(stbl) | Y | 1(变体) |

块偏移表给出每个块到包含文件的索引。有两种表。允许使用 32 位或 64 位偏移。后者在管理非常大的演示时非常有用。在采样表的任何单个实例中，至多有其中一种表。

偏移是文件的偏移，而不是文件中任何 box(比如 Media Data Box)的偏移。这允许引用没有任何 box 结构的文件内的媒体数据。这也意味着在构造一个独立的 ISO 文件且其前面有元数据(Movie Box)时需要格外小心，因为 Movie Box 的大小会影响媒体数据的块偏移。

```code
aligned(8) class ChunkOffsetBox
  extends FullBox(‘stco’, version = 0, 0) {
  unsigned int(32) entry_count;
  for (i=1; i u entry_count; i++) {
    unsigned int(32) chunk_offset;
  }
}
aligned(8) class ChunkLargeOffsetBox
  extends FullBox(‘co64’, version = 0, 0) {
  unsigned int(32) entry_count;
  for (i=1; i u entry_count; i++) {
    unsigned int(64) chunk_offset;
  }
} 
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| version | 整数 | 指定此 box 的版本 |
| entry_count | 整数 | 给出下表的条目数 |
| chunk_offset | 32/64 位证书 | 给出块的开始到其包含的媒体文件内的偏移量 |

#### 8.7.6 Padding Bits Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| padb | Sample Table Box(stbl) | N | 0/1 |

在某些流中，媒体采样并未占据采样大小给定的字节所有位，而是在末尾填充到字节边界。在某些情况下，需要在外部记录所用的填充位数。此表提供了该信息。

```code
aligned(8) class PaddingBitsBox extends FullBox(‘padb’, version = 0, 0) {
  unsigned int(32) sample_count;
  int i;
  for (i=0; i < ((sample_count + 1)/2); i++) {
    bit(1) reserved = 0;
    bit(3) pad1;
    bit(1) reserved = 0;
    bit(3) pad2;
  }
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| sample_count | 整数 | 对轨道中的采样计数；应该和其他表中的计数匹配 |
| pad1 | 0-7 | 指示采样 (i*2)+1 末尾的比特数 |
| pad2 | 0-7 | 指示采样 (i*2)+2 末尾的比特数 |

#### 8.7.7 Sub-Sample Information Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| subs | Sample Table Box(stbl)/Track Fragment Box(traf) | N | 0/1 |

此 box 名为 Sub-Sample Information Box，旨在包含子采样信息。

子采样是采样字节的连续范围。应为给定的编码系统(例如 ISO/IEC 14496-10，高级视频编码)提供子采样的具体定义。在缺少这种具体定义时，不应对使用该编码系统的采样应用此 box。

如果任何条目的 subsample_count 为 0，则这些采样没有子采样信息，之后也没有数组。表格是稀疏编码的；通过记录每个条目之间的采样数量差异来标识哪些采样具有子采样结构。表格第一个条目记录第一个具有子采样信息的采样编号。

请注意：可以结合 subsample_priority 和 discardable，以便当 subsample_priority 小于某个值时，将 discardable 设为 1。然而，因为不同的系统可能使用不同比例的优先级值，可以安全地将二者分开，使用干净的解决方案处理可丢弃的子采样。

同一容器 box 内出现多个 Sub-Sample Information Box 时，每个 Sub-Sample Information Box 的 flags 值应互不相同。如果 flags 对于给定的编码系统没有语义，flags 值应为 0。

```code
aligned(8) class SubSampleInformationBox
  extends FullBox(‘subs’, version, flags) {
  unsigned int(32) entry_count;
  int i,j;
  for (i=0; i < entry_count; i++) {
    unsigned int(32) sample_delta;
    unsigned int(16) subsample_count;
    if (subsample_count > 0) {
      for (j=0; j < subsample_count; j++) {
        if(version == 1)
        {
          unsigned int(32) subsample_size;
        }
        else
        {
          unsigned int(16) subsample_size;
        }
        unsigned int(8) subsample_priority;
        unsigned int(8) discardable;
        unsigned int(32) codec_specific_parameters;
      }
    }
  }
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| version | 整数 | 指定此 box 的版本(此规范是 0 或 1) |
| entry_count | 整数 | 给出下表的条目数 |
| sample_delta | 整数 | 指定有子采样结构的采样的编号。将其编码为所需的采样的编号和前一个条目指示的采样编号的差值。如果当前条目是第一个，该值指示第一个有子采样结构的采样编号，即该值为采样编号和 0 的差值 |
| subsample_count | 整数 | 指定当前采样的子采样数目。如果没有子采样结构，则此字段值为 0 |
| subsample_size | 整数 | 指定当前子采样的字节数 |
| subsample_priority | 整数 | 指定每个子采样的降级优先级。subsample_priority 值越高，表示子采样对解码质量很重要且影响更大 |
| discardable | 整数 | 等于 0 表示解码当前采样需要子采样，而等于 1 表示解码当前采样不需要子采样，但可用于增强，例如子采样包含补充增强信息(SEI)消息 |
| codec_specific_parameters 整数 | 由使用中的编解码器定义。如果没有这样的定义，此字段应设为 0 |

#### 8.7.8 Sample Auxiliary Information Sizes Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| saiz | Sample Table Box(stbl)/Track Fragment Box(traf) | N | >=0 |

每个采样的采样辅助信息可与采样数据本身存储在同一文件的任何地方；对于独立的媒体文件，这通常在 MediaData Box 或派生规范的 box 中。它(a)或者存储在多个块中(包含每个块的采样数以及与主采样数据块匹配的块的数目)，(b)或者在单个块中存储一个 Movie Sample Table (或 Movie Fragment)中的所有采样。单个采样块(或轨道组)中所有采样的 Sample Auxiliary Information 存储连续(类似采样数据)。

Sample Auxiliary Information (如果存在) 总是和相关采样存储在同一文件，因为它们共享相同的数据引用(“dref”)结构。但是，此数据可能位于文件中任何位置，使用 Auxiliary Information Offset (“saio”) 来指示数据的位置。

采样辅助信息是允许还是需要的，可以通过使用的 brand 或编码格式指定。采样辅助信息的格式由 aux_info_type 确定。如果省略了 aux_info_type 和 aux_info_type_parameter，则 aux_info_type 的隐含值为(a)对于转换后的内容(比如受保护的内容)，Protection Scheme Information box 中包含的 scheme_type，否则为(b)采样条目类型。aux_info_type_parameter 的，默认值为 0。aux_info_type 的某些值可能会限制为仅用于特定轨道类型。轨道可能具有多个不同类型的采样辅助信息流。这些类型注册在注册机构中。

尽管 aux_info_type 确定辅助信息的格式，当其 aux_info_type_parameter 值不同时，这些辅助信息流可以使用相同格式。必须指定特定 aux_info_type 值的 aux_info_type_parameter 语义，同时指定特定 aux_info_type 值的语义以及隐含的辅助信息格式。

此 box 提供每个采样的辅助信息大小。对于此 box 的每个实例，必须有一个匹配的 SampleAuxiliaryInformationOffsetsBox(aux_info_type 和 aux_info_type_parameter 值相同)，提供此辅助信息的偏移量信息。

注意，关于使用采样辅助信息和其他机制的讨论，参阅附录 C.8。

```code
aligned(8) class SampleAuxiliaryInformationSizesBox
  extends FullBox(‘saiz’, version = 0, flags) {
  if (flags & 1) {
    unsigned int(32) aux_info_type;
    unsigned int(32) aux_info_type_parameter;
  }
  unsigned int(8) default_sample_info_size;
  unsigned int(32) sample_count;
  if (default_sample_info_size == 0) {
    unsigned int(8) sample_info_size[ sample_count ];
  }
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| aux_info_type | 整数 | 标识采样辅助信息的类型。包含相同 aux_info_type 和 aux_info_type_parameter 的此 box 在包含的 box 中至多出现一次 |
| aux_info_type_parameter | 整数 | 标识具有相同 aux_info_type且关联到同一轨道的辅助信息的“流”。aux_info_type_parameter 的语义由 aux_info_type 的值确定 |
| default_sample_info_size | 整数 | 当所有指示的采样具有相同的采样辅助信息大小时，default_sample_info_size 用于指定采样辅助信息大小。如果采样辅助信息大小不一，则此字段应为 0 |
| sample_count | 整数 | 给出已定义大小的采样数。对于出现在 Sample Table Box 中 Sample Auxiliary Information Sizes Box，此值必须等于或小于 Sample Size Box 或 Compact Sample Size Box 中的 sample_count。对于出现在 Track Fragment Box 中 Sample Auxiliary Information Sizes Box，此 box 必须等于或小于 Track  Fragment 的 Track Fragment Run Box 内 sample_count 条目的综总和。如果此值小于采样数，则为初始采样提供辅助信息，且其余采样没有关联的辅助信息 |
| sample_info_size | 整数 | 给出采样辅助信息的字节数。可以为 0 指示采样没有关联的辅助信息 |

#### 8.7.9 Sample Auxiliary Information Offsets Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| saio | Sample Table Box(stbl)/Track Fragment Box(traf) | N | >=0 |

参阅 Sample Auxiliary Information Sizes Box 的定义，获取采样辅助信息的介绍。

此 box 为采样辅助信息提供位置信息，此方式类似采样数据的块偏移量。

```code
aligned(8) class SampleAuxiliaryInformationOffsetsBox
  extends FullBox(‘saio’, version, flags) {
  if (flags & 1) {
    unsigned int(32) aux_info_type;
    unsigned int(32) aux_info_type_parameter;
  }
  unsigned int(32) entry_count;
  if ( version == 0 ) {
    unsigned int(32) offset[ entry_count ];
  }
  else {
    unsigned int(64) offset[ entry_count ];
  }
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| aux_info_type | 整数 | 标识采样辅助信息的类型。包含相同 aux_info_type 和 aux_info_type_parameter 的此 box 在包含的 box 中至多出现一次 |
| aux_info_type_parameter | 整数 | 标识具有相同 aux_info_type且关联到同一轨道的辅助信息的“流”。aux_info_type_parameter 的语义由 aux_info_type 的值确定 |
| default_sample_info_size | 整数 | 当所有指示的采样具有相同的采样辅助信息大小时，default_sample_info_size 用于指定采样辅助信息大小。如果采样辅助信息大小不一，则此字段应为 0 |
| sample_count | 整数 | 给出已定义大小的采样数。对于出现在 Sample Table Box 中 Sample Auxiliary Information Sizes Box，此值必须等于或小于 Sample Size Box 或 Compact Sample Size Box 中的 sample_count。对于出现在 Track Fragment Box 中 Sample Auxiliary Information Sizes Box，此 box 必须等于或小于 Track  Fragment 的 Track Fragment Run Box 内 sample_count 条目的综总和。如果此值小于采样数，则为初始采样提供辅助信息，且其余采样没有关联的辅助信息 |
| sample_info_size | 整数 | 给出采样辅助信息的字节数。可以为 0 指示采样没有关联的辅助信息 |

### 8.8 影片结构

#### 8.8.1 Movie Extends Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| mvex | Movie Box(moov) | N | 0/1 |

此 box 警告读者文件中可能有 Movie Fragment Box。要了解轨道中的所有采样，必须按顺序查找和扫描这些 Movie Fragment Box，并将其信息逻辑添加到 Movie Box 找到的片段上。

附录 A 有 Movie Fragment 的叙述性介绍。

```code
aligned(8) class MovieExtendsBox extends Box(‘mvex’){
}
```

#### 8.8.2 Movie Extends Header Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| mehd | Movie Extends Box(mvex) | N | 0/1 |

Movie Extends Header 是可选的，且提供分段影片的整体时长，包括片段。如果此 box 不存在，则必须通过检查每个片段来计算总体时长。

```code
aligned(8) class MovieExtendsHeaderBox extends FullBox(‘mehd’, version, 0) {
  if (version==1) {
    unsigned int(64) fragment_duration;
  } else { // version==0
    unsigned int(32) fragment_duration;
  }
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| fragment_duration | 整数 | 声明包含片段的整个影片演示的长度(以 Movie Header Box 的时间刻度为单位)。此字段的值对应最长轨道(包含片段)的时长。如果实时创建 MP4 文件，例如实时流使用，fragment_duration 不太可能事先已知，因此可以忽略此 box |

#### 8.8.3 Track Extends Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| trex | Movie Extends Box(mvex) | Y | Movie Box 内每个轨道一个 |

此 box 设置影片片段使用的默认值。通过此方式设置默认值，可为每个 Track Fragment Box 节省空间和复杂度。

将采样片段内的采样标记字段编码为 32 位的值(包括这里以及 Track Fragment Header Box 的 default_sample_flags，Track Fragment Run Box 内的 sample_flags 和 first_sample_flags)。该值具有下面的结构：

```code
bit(4) reserved=0;
unsigned int(2) is_leading;
unsigned int(2) sample_depends_on;
unsigned int(2) sample_is_depended_on;
unsigned int(2) sample_has_redundancy;
bit(3) sample_padding_value;
bit(1) sample_is_non_sync_sample;
unsigned int(16) sample_degradation_priority;
```

is_leading、sample_depends_on、sample_is_depended_on 和 sample_has_redundancy 值在 Independent and Disposable Samples Box 内定义。

sample_is_non_sync_sample 标记提供和 Sync Sample Table (8.6.2) 相同的信息。当采样的此值设为 0，等同于该采样不在影片片段中，且 Sync Sample Table 内有一个条目对其标记(或者，如果所有采样都是同步采样，则不存在 Sync Sample Table)。

sample_padding_value 的定义和 Padding Bits Box 相同。sample_degradation_priority 定义和 Degradation Priority Box 相同。

```code
aligned(8) class TrackExtendsBox extends FullBox(‘trex’, 0, 0){
  unsigned int(32) track_ID;
  unsigned int(32) default_sample_description_index;
  unsigned int(32) default_sample_duration;
  unsigned int(32) default_sample_size;
  unsigned int(32) default_sample_flags
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| track_ID | 整数 | 标识轨道；这应该是 Movie Box 内的轨道的 track_ID |
| default_xxx | 整数 | 这些字段设置轨道片段所用的默认值 |

#### 8.8.4 Movie Fragment Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| moof | 文件 | N | 0/1 |

影片片段会及时扩展演示。它们提供了以前在 Movie Box 中的信息。如果实际采样在同一文件中，则和通常一样，这些采样在 Media Data Box。数据引用索引在采样描述中，因此当媒体数据在除包含 Movie Box 的文件之外，可以构建增量演示。

Movie Fragment Box 是顶级 box(即和 Movie Box、Media Data Box 对等)。它包含一个 Movie Fragment Header Box，以及一个或多个 Track Fragment Box。

注意，不需要任何特定影片片段扩展存在于 Movie Header 中的所有轨道，且对影片片段引用的媒体数据的位置也没有限制。但是，派生规范可以有这样的限制。

```code
aligned(8) class MovieFragmentBox extends Box(‘moof’){
}
```

#### 8.8.5 Movie Fragment Header Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| mfhd | Movie Fragment Box(moof) | Y | 1 |

Movie Fragment Header 包含一个序列号，作为安全检查。序列号通常从 1 开始，且按照文件内每个影片片段出现的顺序，此值增加。这使读者可以验证序列的完整性；构成片段乱序的文件是错误的。

```code
aligned(8) class MovieFragmentHeaderBox
  extends FullBox(‘mfhd’, 0, 0){
  unsigned int(32) sequence_number;
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| sequence_number | 整数 | 此片段关联的数字 |

#### 8.8.6 Track Fragment Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| traf | Movie Fragment Box(moof) | N | 0/1 |

影片片段内有一组轨道片段，每个轨道 0 或多个片段。轨道片段又包含 0 或多个轨道组，每个轨道组记录该轨道的连续采样组。在这些结构中，许多字段是可选的，且可以是默认的。

可以使用这些结构向轨道增加“空时间”和采样。比如，可在音频轨道中使用空插入实现静音。

```code
aligned(8) class TrackFragmentBox extends Box(‘traf’){
}
```

#### 8.8.7 Track Fragment Header Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| tfhd | Track Fragment Box(traf) | Y | 1 |

每个影片片段可以增加 0 或多个片段到每个轨道；每个轨道片段可增加 0 或多个连续采样组。Track Fragment Header 设置这些采样组所用的信息和默认值。

base_data_offset (如果显式提供)是一个数据偏移量，和 Chunk Offset Box 中的块偏移量相同，即应用到整个文件(比如，以 File Type Box 和 Movie Box 开头)。不存在完整文件或文件大小未知的情况下，可能无法使用显式的 base_data_offset；那么，需要构建相对于影片片段的偏移量。

在 tf_flags 定义下面的标记：

- 0x000001 base-data-offset-present: 指示存在 base_data_offset 字段。这为每个轨道组的数据偏移量提供了一个明确的定位点(参见下文)。如果未提供，则影片片段中第一个轨道的 base_data_offset 是封闭的 Movie Fragment Box 的第一个字节的位置，且对于第二个及后续轨道片段，默认值是前一个片段定义的数据数据结尾。片段以这种方式“继承”其偏移量必须全部使用相同的数据引用(即，这些轨道的数据必须位于同一文件)
- 0x000002 sample-description-index-present：指示存在 sample_description_index 字段，它会在此片段覆盖 Track Extends Box 设置的默认值
- 0x000008 default-sample-duration-present
- 0x000010 default-sample-size-present
- 0x000020 default-sample-flags-present
- 0x010000 duration-is-empty：指示由 default_sample_duration 或 default_sample_duration 内的 default_sample_duration 提供的时长为空，即此时间间隔没有采样。制作的演示同时具有 Movie Box 的 edit list 和空时长片段，则该演示是错误的
- 0x020000 default‐base‐is‐moof：如果 base-data-offset-present 是 1，则忽视此标记。如果 base-data-offset-present 是 0，此标记指示此轨道片段的 base-data-offset 是闭合的 Movie Fragment Box 的第一个字节的位置。在 “iso5” brand 下要求支持 default‐base‐is‐moof 标记，且不应在 brand 内或 iso5 之前的兼容 brand 内使用此标记

注意：default‐base‐is‐moof 标记的使用破坏了此文件格式早期 brand 的兼容性，因为它设置偏移量计算的锚点和之前的版本不同。因此，当 File Type Box 包含早期 brand 时，不能设置 default‐base‐is‐moof 标记。

```code
aligned(8) class TrackFragmentHeaderBox
  extends FullBox(‘tfhd’, 0, tf_flags){
  unsigned int(32) track_ID;
  // all the following are optional fields
  unsigned int(64) base_data_offset;
  unsigned int(32) sample_description_index;
  unsigned int(32) default_sample_duration;
  unsigned int(32) default_sample_size;
  unsigned int(32) default_sample_flags
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| base_data_offset | 整数 | 计算数据偏移量时所用的基本偏移量 |

#### 8.8.8 Track Fragment Run Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| trun | Track Fragment Box(traf) | N | >=0 |

Track Fragment Box 内部有 0 或多个 Track Run Box。如果 tf_flags 设置了 duration-is-empty，则没有轨道组。每个轨道组记录轨道连续的一组采样。

可选字段的数目由 flags 的低字节设置的位数决定，且记录的大小由 flags 第二个字节设置的位数确定。应该遵循此程序，以允许定义新字段。

如果不存在 data-offset，则此组的数据将在上一组的数据之后立即开始，或者如果是轨道片段的第一组，则从轨道片段头部定义的 base-data-offset 开始。如果存在 data-offset，则它是相对于 Track Fragment Header 中定义的 base-data-offset。

定义下面的标记：

- 0x000001 data-offset-present
- 0x000004 first-sample-flags-present：这将仅覆盖第一个采样的默认标记。这使得可以记录一组帧，其中第一个是关键帧，其他的是差异帧，而无需为每个采样提供显式的标记。如果使用此标记和字段，则不应存在 sample-flags
- 0x000100 sample-duration-present-present：每个采样有自己的时长，否则使用默认值
- 0x000200 sample-size-present:每个采样有自己的大小，否则使用默认值
- 0x000400 sample-flags-present：每个采样有自己的标记，否则使用默认值
- 0x000800 sample-composition-time-offsets-present：每个采样有一个合成时间偏移量(即用于 MPEG 的 I/P/B 视频)

Composition Time to Sample Box 和 Track Run Box 内的 合成偏移量值可以是有符号或无符号的。Composition Time to Sample Box 中给出的关于有符号合成偏移量的用法也在这里适用。

```code
aligned(8) class TrackRunBox
  extends FullBox(‘trun’, 0, tr_flags) {
  unsigned int(32) sample_count;
  // the following are optional fields
  signed int(32) data_offset;
  unsigned int(32) first_sample_flags;
  // all fields in the following array are optional
  {
    unsigned int(32) sample_duration;
    unsigned int(32) sample_size;
    unsigned int(32) sample_flags
    unsigned int(32) sample_composition_time_offset;
  }[ sample_count ]
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| sample_count | 整数 | 增加到此片段的采样数；也是下表的行数(行数可为空) |
| data_offset | 整数 | 增加到 Track Fragment Header 中建立的隐式或显式的 data-offset |
| first_sample_flags | 整数 | 仅为此组第一个采样提供一组设置 |

#### 8.8.9 Movie Fragment Random Access Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| mfra | 文件 | N | 0/1 |

Movie Fragment Random Access Box(“mfra”) 提供一个表，可帮助读者使用影片片段查找文件中的随机访问点。对于每个提供信息的轨道(可能不是所有轨道)，它包含一个 Track Fragment Random Access Box。通常将此 box 放在文件末尾或靠近末尾；Movie Fragment Random Access Box 内最后一个 box 提供了 Movie Fragment Random Access Box 的 length 字段的副本。读者可通过检查文件的最后 32 位来尝试查找 Movie Fragment Random Access Box，或从文件末尾向后扫描获取 Movie Fragment Random Access Offset Box 并使用其中的大小信息，以查看该 box 是否位于 Movie Fragment Random Access Box 的开头。

此 box 仅提供随机访问点的位置提示；影片片段本身是确定的。建议读者在定位和使用此 box 时格外注意，因为在创建文件后修改文件可能会导致指针或随机访问点的声明不正确。

```code
aligned(8) class MovieFragmentRandomAccessBox
 extends Box(‘mfra’) {
}
```

#### 8.8.10 Track Fragment Random Access Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| tfra | Movie Fragment Random Access Box(mfra) | N | 0 或每个轨道 1 个 |

每个条目包含随机访问采样的位置和显示时间。它表示可以随机访问条目中的采样。请注意，并不需要在此表中列举轨道中的每个随机访问采样。

没有此 box 并不意味着所有采样都是同步采样。不管是否存在此 box，都应适当设置 “trun”、“traf” 和 “trex” 中的随机访问信息。

```code
aligned(8) class TrackFragmentRandomAccessBox
  extends FullBox(‘tfra’, version, 0) {
  unsigned int(32) track_ID;
  const unsigned int(26) reserved = 0;
  unsigned int(2) length_size_of_traf_num;
  unsigned int(2) length_size_of_trun_num;
  unsigned int(2) length_size_of_sample_num;
  unsigned int(32) number_of_entry;
  for(i=1; i <= number_of_entry; i++){
  if(version==1){
    unsigned int(64) time;
    unsigned int(64) moof_offset;
  }else{
    unsigned int(32) time;
    unsigned int(32) moof_offset;
  }
  unsigned int((length_size_of_traf_num+1) * 8) traf_number;
  unsigned int((length_size_of_trun_num+1) * 8) trun_number;
  unsigned int((length_size_of_sample_num+1) * 8) sample_number;
  }
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| track_ID | 整数 | 标识轨道 ID |
| length_size_of_traf_num | 整数 | traf_number 字段的字节长度 - 1 |
| length_size_of_trun_num | 整数 | trun_number 字段的字节长度 - 1 |
| length_size_of_sample_num | 整数 | sample_number 字段的字节长度 - 1 |
| number_of_entry | 整数 | 给出此轨道的条目数。如果值为 0，标识每个采样是一个随机访问点，且之后没有表条目 |
| time | 32 或 64 位整数 | 指示此随机访问采样的显示时间，使用相关轨道的 “mdhd” 定义的单位 |
| moof_offset | 32 或 64 位整数 | 给出此条目所用 “moof” 的偏移量。偏移量是文件开头到 “moof” 开头的字节差值 |
| traf_number | 整数 | 指示包含随机访问采样的 “traf” 数目。每个 “moof” 内此数值范围从 1 开始(第一个 traf 编号是 1) |
| trun_number | 整数 | 指示包含随机访问采样的 “trun” 数目。每个 “traf” 内此数值范围从 1 开始 |
| sample_number | 整数 | 指示包含随机访问采样的采样编号。每个 “trun” 内此数值范围从 1 开始 |

#### 8.8.11 Movie Fragment Random Access Offset Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| mfro | Movie Fragment Random Access Box(mfra) | Y | 1 |

Movie Fragment Random Access Offset Box 提供闭合的 Movie Fragment Random Access Box 的 length 字段的拷贝。将其放置在该 box 最后，以便 size 字段也在闭合的 Movie Fragment Random Access Box 最后。当 Movie Fragment Random Access Box 也在文件末尾时，这允许轻松定位。这里的 size 字段必须正确。然而，Movie Fragment Random Access Box 是否存在，以及其位置是否在文件末尾都不能保证。

```code
aligned(8) class MovieFragmentRandomAccessOffsetBox
  extends FullBox(‘mfro’, version, 0) {
  unsigned int(32) size;
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| size | 整数 | 给出闭合的 “mfra” box 的字节数。此字段放在闭合的 box 最后，以支持读者在查找 “mfra” box 时从文件末尾扫描 |

#### 8.8.12 Track Fragment Decode Time

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| tfdt | Track Fragment Box(traf) | N | 0/1 |

Track Fragment Base Media Decode Time Box 提供在媒体时间线上测量，轨道片段中按解码顺序第一个采样的绝对解码时间。例如，在文件中执行随机访问时这很有用；不需要对之前片段中所有之前采样的采样时长求和即可找到此值(采样时长是 Decoding Time to Sample Box 的增量和之前轨道组的 sample_durations)。

Track Fragment Base Media Decode Time Box(如果存在)放在 Track Fragment Header Box 之后，在第一个 Track Fragment Run Box 之前。

注意，解码时间线是媒体时间线，在媒体时间到显式时间的任何显式或隐式映射(比如通过编辑列表或类似结构)之前建立。

如果 Track Fragment Decode Time (“tfdt”) 中表示的时间，超过之前的影片和影片片段中采样的时长总和，则此轨道片段之前的最后一个采样的时长将延长，以使总和现在等于此 box 中给出的时间。这样，在尚不知道下一个采样的时间时，可以生成包含采样的片段。

特别地，可以使用空的轨道片段(没有采样，但是有 Track Fragment Decode Time Box)构建最后一个采样的时长。

```code
aligned(8) class TrackFragmentBaseMediaDecodeTimeBox
  extends FullBox(‘tfdt’, version, 0) {
  if (version==1) {
    unsigned int(64) baseMediaDecodeTime;
  } else { // version==0
    unsigned int(32) baseMediaDecodeTime;
  }
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| version | 整数 | 指定此 box 的版本(此规范是 0 或 1) |
| baseMediaDecodeTime | 整数 | 等于媒体中所有更早的采样的解码时长之和，单位是媒体的 timescale。它不包含闭合的轨道片段中增加的采样 |

#### 8.8.13 Level Assignment Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| leva | Movie Extends Box(mvex) | N | 0/1 |

等级指定文件的子集。映射到等级 n 的采样可能依赖等级 m 的任何采样(m <= n)，且不应依赖等级 p 的任何采样(p > n)。比如，可根据时间等级(比如 SVC 或 MVC 的 temporal_id)指定等级。

不能为初始影片指定等级。存在 Level Assignment Box 时，它适用于初始影片之后的所有影片片段。

对于 Level Assignment Box 的上下文，定义 fraction 组成一个或多个 Movie Fragment Box 以及关联的 Media Data Box，可能仅包含最后一个 Media Data Box 的一个初始部分。在 fraction 内部，每个等级的数据应连续出现。fraction 内部的等级数据应该按照等级值递增的出现。应将 fraction 内的所有数据分配给等级。

注意，在 DASH (ISO/IEC 23009-1) 的上下文中，Subsegment Index Box 内索引的每个子片段是一个 fraction。

Level Assignment Box 提供功能(比如可伸缩性层)到等级的映射。可以通过一个轨道、轨道内的一个子轨道，或轨道的一个采样分组指定功能。

padding_flag 等于 1，这表示构建符合的 fraction，可以通过连接 fraction 内任何正整数等级，并用零字节填充最后一个 Media Data Box 直到最后一个 Media Data Box 头部指示的完整大小。比如，下面的条件为真时可设置 padding_flag 为 1：

- 每个 fraction 包含统一视频比特率的两个或更多 AVC、SVC 或 MVC (ISO/IEC 14496-15) 轨道
- fraction 的每个轨道的采样是连续的，且按照 Media Data Box 中的解码顺序
- 第一个 AVC、SVC 或 MVC 等级的采样包含提取器 NAL 单元，用于包含来自同一 fraction 其他等级的视频编码 NAL 单元

```code
aligned(8) class LevelAssignmentBox extends FullBox(‘leva’, 0, 0)
{
  unsigned int(8) level_count;
  for (j=1; j <= level_count; j++) {
    unsigned int(32) track_id;
    unsigned int(1) padding_flag;
    unsigned int(7) assignment_type;
    if (assignment_type == 0) {
      unsigned int(32) grouping_type;
    }
    else if (assignment_type == 1) {
      unsigned int(32) grouping_type;
      unsigned int(32) grouping_type_parameter;
    }
    else if (assignment_type == 2) {} // no further syntax elements needed
    else if (assignment_type == 3) {} // no further syntax elements needed
    else if (assignment_type == 4) {
      unsigned int(32) sub_track_id;
    }
    // other assignment_type values are reserved
  }
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| level_count | 整数 | 指定每个 fraction 分组的等级数。值应大于等于 2 |
| track_id | 整数 | 用于循环条目 j 指定分配给等级 j 的轨道的轨道标识符 |
| padding_flag | 整数 | 等于 1 表示构建符合的 fraction，可以通过连接 fraction 内任何正整数等级，并用零字节填充最后一个 Media Data Box 直到最后一个 Media Data Box 头部指示的完整大小。padding_flag 等于 0 表示不确定 |
| assignment_type | 整数 | 表示用于指定给等级赋值的机制。预留 assignment_type 大于 4 的值，而其他值的语义按如下规则指定。限制 assignment_type 的序列为类型 2 或 3 的集合(零个或多个)，其后是一个类型的零个或多个：0-采样组用于指定等级，即映射到特定采样组的不同采样组描述索引的采样，位于标识轨道内的不同等级；其他轨道不受影响且其数据必须在一个等级；1-和 0 相同，除了通过参数化采样分组对等级赋值；2/3-通过轨道对等级赋值(参阅 Subsegment Index Box 获取处理这些等级的差异)；4-各个等级包含一个自轨道的采样。通过 Sub Track Box 指定子轨道；其他轨道不受影响且其数据必须在一个等级 |
| grouping_type/grouping_type_parameter | 整数 | 如果存在，指定所用的采样分组，用于映射 Sample Group Description Box 内的采样组描述条目到等级。等级 n 包含映射到采样组描述条目的采样，这些条目在 Sample Group Description Box 内索引是 n，且 grouping_type 和 grouping_type_parameter (如果存在)和此 box 提供的相同 |
| sub_track_id | 整数 | 表示循环条目 j 内通过 sub_track_id 标识的子轨道映射到等级 j |

#### 8.8.14 Sample Auxiliary Information in Movie Fragments

Movie Fragment Box 中存在采样辅助信息(8.7.8 和 8.7.9)时，将 Sample Auxiliary Information Offsets Box 中的偏移量视为和 Track Fragment Run Box 中的 data_offset 相同，也就是说，他们都相对于为该轨道片段构建的任何基本数据偏移量。如果使用影片片段相对取址(Track Fragment Header 中未提供基本数据偏移量)，且存在辅助信息，则还必须在该 Track Fragment Header 的标记中设置 default_base_is_moof。

如果仅提供一个偏移量，则片段中所有轨道组的 Sample Auxiliary Information 将连续存储，否则必须为每个轨道组提供一个偏移量。

如果在这些 box 中有一个 default_sample_info_size 字段不为零，则辅助信息的大小对于所标识的采样是恒定的。

此外，如果：

- 此 box 出现在 Movie Box 中
- 且 Movie Box 中的这个 box 中，default_sample_info_size 不为零
- 且影片片段中不存在 Sample Auxiliary Information Offsets Box

则对于影片片段中的每个采样，辅助信息也必须有相同的恒定大小；这样就不必在影片片段中重复这个 box。

#### 8.8.15 Track Extension Properties Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| trep | Movie Extends Box(mvex) | N | 0 或者每个轨道 1 个 |

此 box 可用于记录或概括后续影片片段中轨道的特点。它可以包含任意数量的子 box。

```code
class TrackExtensionPropertiesBox extends FullBox(‘trep’, 0, 0) {
  unsigned int(32) track_id;
  // Any number of boxes may follow
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| track_id | 整数 | 指示此 box 中为该轨道提供了轨道扩展属性 |

#### 8.8.16 Alternative Startup Sequence Properties Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| assp | Track Extension Properties Box(trep) | N | 0/1 |

此 box 指示备用启动序列采样组的属性，这些采样组在轨道(包含的 Track Extension Properties Box 指示)的后续轨道片段中。

如果将版本 0 的 Sample to Group Box 用于备用启动序列采样分组，则使用 Alternative Startup Sequence Properties Box 的版本 0。如果将版本 1 的 Sample to Group Box 用于备用启动序列采样分组，则使用 Alternative Startup Sequence Properties Box 的版本 1。

```code
class AlternativeStartupSequencePropertiesBox extends FullBox(‘assp’, version, 0) {
  if (version == 0) {
    signed int(32) min_initial_alt_startup_offset;
  }
  else if (version == 1) {
    unsigned int(32) num_entries;
    for (j=1; j <= num_entries; j++) {
      unsigned int(32) grouping_type_parameter;
      signed int(32) min_initial_alt_startup_offset;
    }
  }
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| min_initial_alt_startup_offset | 整数 |备用启动序列采样分组引用的采样组描述条目的 sample_offset\[1\] 不应当小于 min_initial_alt_startup_offset。在此 box 的版本 0 中，引用使用 Sample to Group Box  版本 0 的备用启动序列采样分组。在此 box 的版本 1 中，引用使用 Sample to Group Box  版本 1 的备用启动序列采样分组，按照 grouping_type_parameter 进一步限制|
| num_entries | 整数 | 指示此 box 中记录的备用启动序列采样分组的数目 |
| grouping_type_parameter | 整数 | 指示此喜欢条目使用的备用采样分组 |

#### 8.8.17 影片片段中的元数据和用户数据

Meta Box 出现在 Movie Fragment 或 Track Fragment Box 中时，适用下面的内容。必须对文件分段，以使影片或轨道片段中需要的任何元数据都是联合 Movie Box 中的元数据与片段形成的，而不考虑或使用其他任何片段中的元数据。影片或轨道片段中的元数据在逻辑上“迟到”，但是对于整个轨道有效。在对文件进行分段逆向处理时，影片或轨道片段中的元数据必须分别合并到 Movie 或 Track Box。此过程允许“及时”交付支持字段和带宽管理，同时保留未定时元数据的本质时空性质。如果元数据确实随时间变化，可能需要定时的元数据轨道。

如果在此合并期间，或者(a)有相同 item_ID 的元数据 item，或者(b)有相同类型的元数据 item，则适用以下内容：

- 对于整个影片(包含所有片段)，所有数据(user-data box 或元数据 item)的出现必须为 “true”
- 在更高编号的影片片段(“较晚”出现)在的出现可能更准确或“更优先”
- 特别是，空的初始影片 atom 中的数据可能只是估计值或“不超过”值，而最终的空影片片段中的数据可能是“最终的”或最准确的值

### 8.9 采样分组结构

#### 8.9.1 介绍

本节指定了表示轨道中采样分区的一种通用机制。采样分组是根据分组标准，将轨道的每个采样分配为一个采样组的成员。采样分组中的采样组不限于连续的采样，且可以包含不相邻的采样。由于轨道中的采样可能有多个采样分组，因此每个采样分组有一个 type 字段来指示分组的类型。例如，一个文件可能包含包含同一轨道的两个分组：一个基于样本对图层的分配，另一个基于对子序列的分配。

采样分组由两个链接的数据结构表示：(1)SampleToGroup Box 表示将采样分配给采样组；(2)SampleGroupDescription Box 为每个采样组包含一个采样组条目，描述该组的属性。根据不同的分组标准，可能存在 SampleToGroup Box 和 SampleGroupDescription Box 的多个实例。

特定分组类型的分组可使用采样中的参数进行分组映射；如果是这样，必须在组中记录参数的含义。一个例子可能是在多个视频流的多路复用中记录同步点；组定义可能是“是一个 I 帧”，且组参数可能是每个流的标识符。因为 Sample To Group Box 对于每个流只出现一次，因此它现在既是紧凑的，有分别将每个流通知给读者。

使用这些表的一个示例是，表示根据图层分配采样。在这种情况下，每个采样分组表示一层，具有的 SampleToGroup Box 实例描述了采样所属的层。

#### 8.9.2 Sample To Group Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| sbgp | Sample Table Box(stbl)/Track Fragment Box(traf) | N | >=0 |

此表可用于查找采样所属的组，以及该采样组相关的描述。该表经过紧凑编码，每个条目给出一组采样的第一个采样的索引，这些采样具有相同的采样组描述。group_description_index 是引用 SampleGroupDescription Box 的索引，其中包含的条目描述每个采样组的特征。

如果一个轨道内的采样有多个采样分组，则此 box 可能有多个实例。SampleToGroup Box 的每个实例都有一个类型码以区分不同的采样分组。在一个轨道内部，应最多有一个具有特定分组类型的此 box 的实例。相关的 SampleGroupDescription 应为分组类型指示相同的值。

只有需要分组类型参数时才应使用此 box 的版本 1。

```code
aligned(8) class SampleToGroupBox
  extends FullBox(‘sbgp’, version, 0) {
  unsigned int(32) grouping_type;
  if (version == 1) {
    unsigned int(32) grouping_type_parameter;
  }
  unsigned int(32) entry_count;
  for (i=1; i <= entry_count; i++)
  {
    unsigned int(32) sample_count;
    unsigned int(32) group_description_index;
  }
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| version | 整数 | 指定此 box 的版本(0 或 1) |
| grouping_type | 整数 | 标识采样分组的类型(即用于构成采样组的标准)，并将其链接到具有相同分组类型值的 SampleGroupDescription 表。对于一个轨道，具有相同 grouping_type(且，如果使用，grouping_type_parameter) 值的此 box 应最多出现一次 |
| grouping_type_parameter | 整数 | 指示分组的子类型 |
| entry_count | 整数 | 给出下表的条目数 |
| sample_count | 整数 | 给出具有相同采样组描述符的连续采样的数目。如果此 box 的采样计数综合少于总的采样计数，或某些采样没有适用的 Sample To Group Box(比如轨道片段没有)，则读者应将没有显式分组描述的采样关联到 SampleDescriptionGroup Box 中定义的默认分组(如果有)，或者如果没有则不与分组关联。如果此 box 内的总数大于其他地方记录的 sample_count，这是一个错误，且读者行为将是未定义的 |
| group_description_index | 整数 | 给出采样组条目的索引，该条目描述此分组中的采样。索引范围是 1 到 SampleGroupDescription box 内的采样组条目数，或者取值 0 表示该采样不属于此类型任何分组 |

#### 8.9.3 Sample Group Description Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| sgpd | Sample Table Box(stbl)/Track Fragment Box(traf) | N | >=0，每个 Sample To Group Box 一个 |

这个描述表给出相同分组的特征信息。描述性的信息定义和表征采样组所需的任何其他信息。

如果一个轨道中的采样有多个采样分组，则此 box 可能有多个实例。SampleGroupDescription Box 的每个实例都有一个类型码以区分不同的采样分组。在 Sample Table Box 或 Track Fragment Box 中，应最多有一个具有特定分组类型的此 box 的实例。相关的 SampleToGroup 应为分组类型指示相同的值。

信息存储在 Sample Group Description Box 的 entry_count 之后。定义了抽象条目类型，采样分组应定义派生类型以表示每个采样组的描述。对于视频轨道，将抽象的 VisualSampleGroupEntry 与类似类型的音频和 hint 轨道一起使用。

请注意：在此条目的版本 0 中，采样组描述条目的基类既不是 box 也没有指示的大小。出于这个愿意。弃用对版本 0 条目的使用。当定义派生类时，确保它们有固定的大小，或使用 length 字段明确标识大小。不建议使用隐含的大小(例如，通过解析数据获得)，因为这会使得扫描数组变得困难。

```code
// Sequence Entry
abstract class SampleGroupDescriptionEntry (unsigned int(32) grouping_type) {
}
abstract class VisualSampleGroupEntry (unsigned int(32) grouping_type) extends
SampleGroupDescriptionEntry (grouping_type) {
}
abstract class AudioSampleGroupEntry (unsigned int(32) grouping_type) extends
SampleGroupDescriptionEntry (grouping_type) {
}
abstract class HintSampleGroupEntry (unsigned int(32) grouping_type) extends
SampleGroupDescriptionEntry (grouping_type) {
}
abstract class SubtitleSampleGroupEntry (unsigned int(32) grouping_type) extends
SampleGroupDescriptionEntry (grouping_type) {
}
abstract class TextSampleGroupEntry (unsigned int(32) grouping_type) extends
SampleGroupDescriptionEntry (grouping_type) {
}
aligned(8) class SampleGroupDescriptionBox (unsigned int(32) handler_type)
  extends FullBox('sgpd', version, 0){
  unsigned int(32) grouping_type;
  if (version==1) {
    unsigned int(32) default_length;
  }
  if (version>=2) {
    unsigned int(32) default_sample_description_index;
  }
  unsigned int(32) entry_count;
  int i;
  for (i = 1 ; i <= entry_count ; i++){
    if (version==1) {
      if (default_length==0) {
        unsigned int(32) description_length;
      }
    }
    SampleGroupEntry (grouping_type);
    // an instance of a class derived from SampleGroupEntry
    // that is appropriate and permitted for the media type
  }
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| version | 整数 | 指定此 box 的版本 |
| grouping_type | 整数 | 标识与此采样组描述关联的 SampleToGroup box。如果给定的 grouping_type 未定义 grouping_type_parameter，则具有该 grouping_type 的此 box 只应出现一次 |
| default_sample_description_index | 整数 | 指定采样组描述条目的索引，该条目适用轨道中所有未通过 SampleToGroup box 提供采样到组的映射的采样。此字段的默认值为 0(表示采样未映射到此类型的任何组) |
| entry_count | 整数 | 给出下表的条目数 |
| default_length | 整数 | 指示每个分组条目的长度(如果长度恒定)，如果长度可变则为 0 |
| description_length | 整数 | 当条目之间存在差异且 default_length 为 0，指示单个组条目的长度 |

#### 8.9.4 Movie Fragment 的组结构表示

通过使用 SampleToGroup Box 以支持 Movie Fragment 中的新 SampleGroup，SampleToGroup Box 的容器变为 Track Fragment Box(“traf”)。在 8.9.2 小节中指定其定义、语法和语义。

SampleToGroup Box 可用于查找轨道片段中的采样所属分组，以及该采样组的关联描述。此表经过紧凑编码，每个条目给出一组采样的第一个采样的索引，这些采样具有相同的采样组描述。采样组描述 ID 是一个引用 SampleGroupDescription Box 的索引，该 Box 包含的条目描述每个采样组特征，且存在 SampleTableBox 中。

如果一个轨道片段内的采样有多个采样分组，则可能有多个 SampleToGroup Box 实例。SampleToGroup Box 的每个实例都有一个类型码以区分不同的采样分组。相关的 SampleGroupDescription 应为分组类型指示相同的值。

轨道片段中所有 SampleToGroup Box 内表示的采样总数必须和所有轨道片段组的采样总数匹配。每个 SampleToGroup Box 记录相同采样的不同分组。

Track Fragment Box 中也可能存在 0 个或多个 SampleGroupDescription box。这些定义补充 Movie Box 中轨道的 Sample Table 中提供的定义。影片片段中的组定义也可以从同一影片片段中引用和使用。

在该影片片段的 SampleToGroup box 内，同一片段内定义的组的组描述索引从 0x10001 开始，即索引值为 1，前 16 位为 1。这意味着在 Movie Box 的 Sample Table 中，此轨道和分组类型的组定义必须小于 65535。

更改影片片段大小或删除它们时，需要将这些片段局部组定义合并到 Movie Bpx 的定义中，或合并到新的影片片段，并调相应地调整 SampleToGroup box 中的索引号。在此过程中，建议不要在任何 SampleGroupDescription box 中创建相同(因此重复)的定义，但应合并重复项并响应地调整索引。

### 8.10 用户数据

#### 8.10.1 User Data Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| udta | Movie Box(moov)/Track Box(trak)/Movie Fragment Box(moof)/Track Fragment Box(traf) | N | 0/1 |

此 box 包含一些对象，这些对象声明关于包含的 box 及其数据(演示或轨道)的用户信息。

User Data Box 是容器 box，用于提供用户数据信息。这些用户数据被格式化为一组 box，这些 box 具有更特定的类型，这些类型更精确地声明了它们的内容。

影片片段中的用户数据的处理在 8.8.17 中描述。

```code
aligned(8) class UserDataBox extends Box(‘udta’) {
}
```

#### 8.10.2 Copyright Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| cprt | User Data Box(udta) | N | 0/1 |

Copyright Box 包含版权声明，当包含在 Movie Box 中时适用整个演示，或包含在轨道中适用整个轨道。可能有多个使用不同语言代码的 Copyright Box。

```code
aligned(8) class CopyrightBox
  extends FullBox(‘cprt’, version = 0, 0) {
  const bit(1) pad = 0;
  unsigned int(5)[3] language; // ISO-639-2/T language code
  string notice;
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| language | - | 声明下面文本的语言代码。参阅 ISO 639-2/T 获取三字符代码集合。每个字符是其 ASCII 值和 0x60 的差值。此代码限制为三个小写字母，因此这些值是严格为正 |
| notice | null 结尾的字符串 | UTF-8 或 UTF-16 字符，给出版权声明。如果使用 UTF-16，字符串应以 BYTE ORDER MARK(0xFEFF) 开头，以便区分 UTF-8 字符串。最后的字符串不包含此标识 |

#### 8.10.3 Track Selection Box

##### 8.10.3.1 介绍

存储在文件中的典型演示会为每个媒体类型包含一个备用组：一个用于视频，一个用于音频等。此类文件可能包含多个视频轨道，尽管在任何时间点仅应播放或流传输其中的一个轨道。这是通过将所有视频轨道分配给同一备用组实现的。(参阅 8.3.2 节获取备用组的定义。)

备用组中的所有轨道都是媒体选择的候选项，但是会话期间在其中一些轨道之间切换可能没有意义。例如可能允许以不同比特率在视频轨道之间切换并保持帧大小，但是不允许在不同帧大小的轨道之间切换。可能希望在不同的视频编解码器或不同的音频编解码器之间以相同的方式选择——但不切换。

通过将轨道分配给备用组之外的交换组，处理选择和切换轨道的区别。备用组可能包含一个或多个交换组。备用组中的所有轨道都是媒体选择的候选项，而交换组中的轨道在会话期间都可以用于切换。不同的交换组表示不同的操作点，比如不同的帧大小、高/低质量等。

对于不可伸缩的比特流，交换组中可能包含多个轨道。这同样适用非分层的可伸缩比特流，比如传统的 AVC 流。

通过使用属性标记轨道，可以对其特征化。每个轨道可标记有一系列属性，这些属性可用于描述特定交换组中的轨道或属于不同交换组的不同轨道。

##### 8.10.3.2 定义

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| tsel | User Data Box(udta) | N | 0/1 |

Track Selection Box 包含在其修改轨道的 User Data Box 中。

##### 8.10.3.3 语法

```code
aligned(8) class TrackSelectionBox
  extends FullBox(‘tsel’, version = 0, 0) {
  template int(32) switch_group = 0;
  unsigned int(32) attribute_list[]; // to end of the box
}
```

##### 8.10.3.4 语义

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| switch_group | 整数 | 指定轨道的组或集合。如果此字段为 0(默认值)，或没有 Track Selection Box，则不会提供有关播放或流传输期间此轨道是否可用于切换的信息。如果此整数不为 0，则可用于彼此之间切换的轨道应相同。属于同一交换组的轨道应属于同一备用组。交换组可能只有一个成员 |
| attribute_list | 列表 | box 末尾的属性列表。应将此列表中的属性用作轨道的描述，或同一备用或交换组中轨道的区分标准。每个区分属性管理指向该字段的指针或区分轨道的信息 |

##### 8.10.3.5 属性

以下属性是描述性的：

| 名称 | 属性 | 描述 |
| --- | --- | --- |
| Temporal scalability | tesc | 轨道在时间上可伸缩 |
| Fine‐grain SNR scalability | fgsc | 轨道在质量上可伸缩 |
| Coarse‐grain SNR scalability | cgsc | 轨道在质量上可伸缩 |
| Spatial scalability | spsc | 轨道在空间上可伸缩 |
| Region‐of‐interest scalability | resc | 轨道在兴趣区域上可伸缩 |
| View scalability | vwsc | 轨道在观看次数上可伸缩 |

以下属性是区分的：

| 名称 | 属性 | 指针 |
| --- | --- | --- |
| Codec | cdec | 采样条目(在媒体轨道的 Sample Description Box) |
| Screen size | scsz | Visual Sample Entries 的 width 和 height 字段 |
| Max packet size | mpsz | RTP Hint Sample Entry 的 Maxpacketsize 字段 |
| Media type | mtyp | (媒体轨道的) Handler Box 的 handlertype |
| Media language | mela | Media Header box 的 language 字段 |
| Bitrate | bitr | 轨道中的采样总大小除以 Track Header Box 的 duration |
| Frame rate | frar | 轨道中的采样数除以 Track Header Box 的 duration |
| Number of views | nvws | 子轨道中的观看次数 |

描述性属性描述它们修改的轨道，而区分属性则区分属于同一备用或交换组的轨道。区分属性的指针指示信息的位置，该信息将轨道和具有相同属性的其他轨道区分开。

#### 8.10.4 Track kind

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| kind | 轨道中的 User Data Box(udta) | N | >=0 |

Kind Box 标记轨道的角色或种类。

它包含一个 URI，之后可能跟随一个 value。如果只出现 URI，则通过该 URI 定义种类；如果跟随一个 value，则通过该 URI 标识该 value 的命名 scheme。URI 和 value 都是 null 结尾的 C 字符串。

轨道中可出现多个此类 box，包含不同的内容但是包含合适的语义(比如，两个 scheme 都定义一个种类指示子标题)

```code
aligned(8) class KindBox
  extends FullBox(‘kind’, version = 0, 0) {
  string schemeURI;
  string value;
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| schemeURI | null 结尾的 C 字符串 | 声明种类的标识符(如果之后没有 value)，或为后面的 value 声明命名 scheme 的标识符 |
| value | 字符串 | 来自声明的 scheme 的名称 |

### 8.11 元数据支持

使用一个通用的基本结构包含一般的元数据，该结构称为 Meta Box。

#### 8.11.1 The Meta Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| meta | 文件/Movie Box(moov)/Track Box(trak)/Additional Metadata Container Box(meco)/Movie Fragment Box(moof)/Track Fragment Box(traf) | N | 0/1(在文件/moov/trak)，>=1(在 meco) |

Meta box 包含描述性或注释性元数据，“meta” box 需要包含一个 “hdlr” box，指示 “meta” box 内容的结构或格式。该元数据位于此 box 内的一个 box(比如 XML box)，或是通过 Primary Item Box 标识的 item 定位。

包含的所有其他 box 都特定于 Handler Box 指定的格式。

对于给定的格式，此处定义的其他 box 可能定义为可选或必需的。如果使用它们，则必须使用此处指定的格式。这些可选 box 包括：data-information box，用于记录放置元数据值(例如图片)的其他文件；item location box，用于记录每个 item 在这些文件中的位置(比如常见情况是在同一文件存放多张图片)。在文件、影片或轨道级别，每个级别最多出现一个 meta box，除非包含在Additional Metadata Container Box(“meco”)。

如果出现一个 Item Protection Box，除非考虑了保护系统，否则某些或所有元数据(可能包括主资源)可能已经被保护且无法读取。

```code
aligned(8) class MetaBox (handler_type)
 extends FullBox(‘meta’, version = 0, 0) {
 HandlerBox(handler_type) theHandler;
 PrimaryItemBox primary_resource; // optional
 DataInformationBox file_locations; // optional
 ItemLocationBox item_locations; // optional
 ItemProtectionBox protections; // optional
 ItemInfoBox item_infos; // optional
 IPMPControlBox IPMP_control; // optional
 ItemReferenceBox item_refs; // optional
 ItemDataBox item_data; // optional
 Box other_boxes[]; // optional
}
```

元数据的结构或格式由 handler 声明。如果通过 Primary Item 标识主要数据，则该 Primary Item 有一个包含 item_type 的 item 信息条目，handler_type 可能和 item_type 相同。

#### 8.11.2 XML Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| xml/bxml | Meta Box(meta) | N | 0/1 |

当主要数据是 XML 格式，且希望将 XML 直接存储在 Meta Box 中时，可以使用这些格式之一。仅当 handler 标识的已定义格式存在定义良好的 XML 二进制文件时，才可以使用 BinaryXML Box。

XML box 内的数据为 UTF-8 格式，除非数据以字节顺序标记 (BOM) 开头，这种情况标识数据是 UTF-16 格式。

```code
aligned(8) class XMLBox
  extends FullBox(‘xml ’, version = 0, 0) {
  string xml;
}
aligned(8) class BinaryXMLBox
  extends FullBox(‘bxml’, version = 0, 0) {
  unsigned int(8) data[]; // to end of box
}
```

#### 8.11.3 The Item Location Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| iloc | Meta Box(meta) | N | 0/1 |

Item Location Box 提供此文件或其他文件中的资源目录，通过定位其包含文件、在文件内的偏移量，及其长度实现。以二进制格式存放此 box，即使系统不了解所用的特定元数据系统(handler)，也能对这些数据进行通用处理。比如，系统可能将所有外部引用元数据资源整合到一个文件，相应地重新调整文件偏移量和文件引用。

此 box 以三个或四个值开头，分别指定 offset、length、base_offset 字段，以及此 box 的版本 1 和 2 中的 extent_index 字段的字节大小。这些值必须来自集合 {0,4,8}。

construction_method 字段指示 item 的“构造方法”：

- file_offset: 通过到位于 data_reference_index 的文件的普通绝对文件偏移量(construction_method == 0)
- idat_offset: 通过到同一 meta box 的 idat box 的 box 偏移量；不使用 data_reference_index 和 extent_index 字段；(construction_method == 1)
- item_offset: 通过到 extent_index 标识的 item 的item 偏移量，(目前)只有此构造方法使用。(construction_method == 2)

extent_index 只用于 item_offset 方法；它表示从此 item 链接的 item 引用的基于 1 的索引，该 item 引用带有 referenceType “iloc”。如果 index_size 为 0，则值 1 是隐含的；保留值 0。

可将 item 存储成区间碎片，比如启用交织。区间是资源字节的连续子集；通过合并区间形成资源。如果只使用一个区间(extent_count=1)，则可能隐含 offset、length 之一或二者：

- 如果未标识 offset(此字段长度为 0)，则标识文件开头(offset=0)
- 如果未指定或指定 length 为 0，则标识整个文件长度。与此元数据相同的文件引用，或划分为不止一个区间的 item，应该具有显式的 offset 和 length，或使用 MIME 类型要求对该文件进行不同的解释，以避免无限递归

item 的大小是区间长度的总和。

请注意：区间可能和轨道 Sample Table 定义的块交织。

偏移量相对于数据原点。该原点按下面内容确定：

1. 当 Meta Box 位于 Movie Fragment，且 construction_method 指定文件偏移量，且数据引用指示“相同文件”时，数据原点是闭合 Movie Fragment Box 的第一个字节(正如 Track Fragment Header 中的 default‐base‐is‐moof 标记)
2. 在所有其他情况下，当 construction_method 指定文件偏移量时，数据原点是数据引用标识的文件的开头
3. 当 construction_method 指定到 Item Data box 的偏移量时，数据原点是 Item Data box 中的 data[] 的开头
4. 当数据引用指定另一个 item 时，数据原点是该 item 连接数据(在所有范围内)的第一个字节

注意：此文件格式的其他部分根据 box header 开头计算偏移量；相反，item 数据偏移量是相对 box 内容计算的

data_reference_index 可能取值为 0，表示与此元数据相同的文件引用，或 data_reference 表的索引。

某些引用数据本身可能使用 offset/length 技术来寻址其中的资源(比如，可能以这种方式“包含” MP4 文件)。通常，此类偏移量相对于包含文件的开头。base_offset 字段提供额外的偏移量，用于包含的数据内部的偏移量计算。比如，如果按照此规范格式化的文件包含一个 MP4 文件，则该 MP4 节中的数据偏移通常是相对于文件开头的；base_offset 增加到这些偏移量。

如果通过其他 item 构造 item，且这些源 item 是受保护的，则源 item 的偏移量和长度信息适用它们取消保护之后。即目标 item 数据由不受保护的源数据形成。

为了获得最大的兼容性，应使用此 box 的版本 0 优先于带有 construction_method==0 的版本 1，或尽可能使用版本 2。类似地，仅当需要或期望支持大的 item_ID 值(超过 65535)时，才应使用此 box 的版本 2。

```code
aligned(8) class ItemLocationBox extends FullBox(‘iloc’, version, 0) {
  unsigned int(4) offset_size;
  unsigned int(4) length_size;
  unsigned int(4) base_offset_size;
  if ((version == 1) || (version == 2)) {
    unsigned int(4) index_size;
  } else {
    unsigned int(4) reserved;
  }
  if (version < 2) {
    unsigned int(16) item_count;
  } else if (version == 2) {
    unsigned int(32) item_count;
  }
  for (i=0; i<item_count; i++) {
    if (version < 2) {
      unsigned int(16) item_ID;
    } else if (version == 2) {
      unsigned int(32) item_ID;
    }
    if ((version == 1) || (version == 2)) {
      unsigned int(12) reserved = 0;
      unsigned int(4) construction_method;
    }
    unsigned int(16) data_reference_index;
    unsigned int(base_offset_size*8) base_offset;
    unsigned int(16) extent_count;
    for (j=0; j<extent_count; j++) {
      if (((version == 1) || (version == 2)) && (index_size > 0)) {
      unsigned int(index_size*8) extent_index;
      }
      unsigned int(offset_size*8) extent_offset;
      unsigned int(length_size*8) extent_length;
    }
  }
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| offset_size | {0,4,8} | 标识 offset 字段的字节长度 |
| length_size | {0,4,8} | 标识 length 字段的字节长度 |
| base_offset_size | {0,4,8} | 标识 base_offset 字段的字节长度 |
| item_count | 整数 | 计数下面的数组资源 |
| item_ID | 整数 | 此资源的随机“名称”，可用于引用该资源(比如在 URL) |
| construction_method | 整数 | 0-文件；1-idat；2-item |
| data_reference_index | 整数 | 0 标识本文件；基于 1 的索引，索引 Data Information Box 的数据引用 |
| base_offset | 整数 | 为引用的数据内的偏移量计算提供基础值。如果 base_offset_size 为 0，base_offset 取值为 0，即其未被使用 |
| extent_count | 整数 | 提供资源被划分的区间计数；值必须大于等于 1 |
| extent_index | 整数 | 提供为 construction_method 定义的索引 |
| extent_offset | 整数 | 提供此区间数据的绝对偏移量(单位是字节)，从容器的数据原点开始。如果 offset_size 为 0，则 extent_offset 为 0  |
| extent_length | 整数 | 提供此元数据 item 区间的绝对长度(单位是字节)。如果 length_size 为 0，extent_length 为 0。如果此值为 0，则区间的长度是整个引用容器的长度 |

#### 8.11.4 Primary Item Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| pitm | Meta Box(meta) | N | 0/1 |

对于给定的 handler，当希望将其存储在其他地方或将划分为区间时，主要数据可以是引用的 item 之一；或者主要元数据可能包含在 Meta Box(比如在 XML Box)。或者此 box 必须出现，或者 Meta Box 中必须有一个 box(比如 XML Box)，其中包含标识的 handler 所需格式的主要信息。

```code
aligned(8) class PrimaryItemBox
  extends FullBox(‘pitm’, version, 0) {
  if (version == 0) {
    unsigned int(16) item_ID;
  } else {
    unsigned int(32) item_ID;
  }
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| item_ID | 整数 | 主要 item 的标识符。仅当需要或期望支持大的 item_ID 值(超过 65535)时，才应使用版本 1 |

#### 8.11.5 Item Protection Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| ipro | Meta Box(meta) | N | 0/1 |

Item Protection Box 提供一组 item 保护信息，由 Item Information Box 使用。

```code
aligned(8) class ItemProtectionBox
  extends FullBox(‘ipro’, version = 0, 0) {
  unsigned int(16) protection_count;
  for (i=1; i<=protection_count; i++) {
    ProtectionSchemeInfoBox protection_information;
  }
}
```

#### 8.11.6 Item Information Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| iinf | Meta Box(meta) | N | 0/1 |

Item Information Box 提供有关所选 item 的其他信息，包括符号(“文件”)名称。其出现是可选的，但是如果出现，必须对其进行解释，因为 item 保护或内容编码可能已经更改了 item 中的数据格式。如果 item 同时标识了内容编码和保护，则读者应该先取消对 item 的保护，然后对 item 的内容编码进行解码。如果需要更多控制，可以使用 IPMP 序列码。

此 box 包含一组条目，且每个条目都被格式化为一个 box。该数组在条目记录中按照增加的 item_ID 排序。

定义了 4 个版本的 item 信息条目。版本 1 比版本 0 包含额外的信息，由扩展类型指定。比如，对于 File Partition Box(“fpar”) 引用的 item，应与扩展名 “dfel” 一起使用，File Partition Box 是为源文件分区定义的，且适用于文件分发传输。版本 2 和 3 提供一种可选结构，通过其中 32 位(通常是 4 个字符) 注册或定义的代码指示元数据 item 类型；定义其中两个代码以指示 MIME 类型或 URI 键入的元数据。版本 2 支持 16 位 item_ID 值，而版本 3 支持 32 位 item_ID 值。

如果不需要扩展，则 box 可能在没有 extension_type 字段和扩展的情况下终止；此外，如果不希望使用 content_encoding，则该字段也可能不存在，且 box 会在该字段之前终止。如果需要没有显式 content_encoding 的扩展，则必须在 extension_type 指示之前，为 content_encoding 提供一个空字节表示空字符串。

如果需要文件分发 item 信息，且使用版本 2 或 3 的 ItemInfoEntry，则文件分发信息存储为类型 “fdel” 的单独 item，也通过该 item 的 item 引用将其链接到类型为 “fdel” 的文件分发信息。如果需要文件分发信息，则必须只有一个这样的引用。

可能存在用于 MPEG-7 元数据的有效 URI 格式(比如，带有标识特定元素的片段的 schema URI)，且这些结构也可能用于 MPEG-7。

但是，在 ISO 基本媒体文件格式家族文件中对 MPEG-7 有明确的支持，且其允许这种明确的支持在其他中是首选的：

- 元数据的增量更新(从逻辑上将，视频方式上是 I/P 编码)，而此草案是“仅限 I 帧”
- 二进制化并因此压缩
- 使用多个 schema

因此，在 MPEG-7 中弃用(且未记录)这些结构。

有关某些元数据系统的 URI 形式的信息可以在附录 G 中找到。

仅当需要或预期需要支持大量 ItemInfoEntry(超过 65535) 时，才应使用 ItemInfoBox 的版本 1。

```code
aligned(8) class ItemInfoExtension(unsigned int(32) extension_type)
{
}
aligned(8) class FDItemInfoExtension() extends ItemInfoExtension (’fdel’)
{
 string content_location;
 string content_MD5;
 unsigned int(64) content_length;
 unsigned int(64) transfer_length;
 unsigned int(8) entry_count;
 for (i=1; i <= entry_count; i++)
  unsigned int(32) group_id;
}
aligned(8) class ItemInfoEntry
  extends FullBox(‘infe’, version, 0) {
  if ((version == 0) || (version == 1)) {
    unsigned int(16) item_ID;
    unsigned int(16) item_protection_index
    string item_name;
    string content_type;
    string content_encoding; //optional
  }
  if (version == 1) {
    unsigned int(32) extension_type; //optional
    ItemInfoExtension(extension_type); //optional
  }
  if (version >= 2) {
    if (version == 2) {
      unsigned int(16) item_ID;
    } else if (version == 3) {
      unsigned int(32) item_ID;
    }
    unsigned int(16) item_protection_index;
    unsigned int(32) item_type;
    string item_name;
    if (item_type==’mime’) {
      string content_type;
      string content_encoding; //optional
    } else if (item_type == ‘uri ‘) {
      string item_uri_type;
    }
  }
}
aligned(8) class ItemInfoBox
  extends FullBox(‘iinf’, version, 0) {
  if (version == 0) {
    unsigned int(16) entry_count;
  } else {
    unsigned int(32) entry_count;
  }
  ItemInfoEntry[ entry_count ] item_infos;
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| item_ID | 整数 | 主要资源(比如 “xml” box 中包含的 XML)是 0，或者是 item 的 ID，下面的信息为此 item 定义 |
| item_protection_index | 整数 | 未保护的 item 是 0，或者基于 1 的索引，索引 Item Protection Box，其中定义此 item 应用的保护(Item Protection Box 中第一个 box 索引是 1) |
| item_name | null 结尾的字符串 | UTF-8 字符。包含 item(文件分发传输的源文件) 的符号名称 |
| item_type | 32 位整数 | 通常是 4 个可打印字符，是一个已定义的有效的 item 类型指示符，比如 “mime” |
| content_type | null 结尾的字符串 | UTF-8 字符。具有 item 的 MIME 类型。如果 item 是内容编码(参阅下面)的，则此内容类型指示内容编码后的 item |
| item_uri_type | 字符串 | 是一个绝对 URI，用作类型指示符 |
| content_encoding | null 结尾的字符串 | 可选的，UTF-8 字符。用于标识二进制文件已编码，且在解释之前需要解码。这些值定义在 HTTP/1.1 的 Content-Encoding。一些可能的值是 “gzip”、“compress” 和 “deflate”。空字符串标识没有内容编码。注意，在应用内容编码后存储 item |
| extension_type | 整数 | 可打印 4 字符代码，表示版本 1 的 extension 字段，相对于版本 0 的 Item 信息条目 |
| content_location | null 结尾的字符串 | UTF-8 字符。包含 HTTP/1.1(RFC 2616)中定义的文件的 URI |
| content_MD5 | null 结尾的字符串 | UTF-8 字符。包含文件的 MD5 摘要。参阅 HTTP/1.1(RFC 2616) 和 RFC  1864 |
| content_length | 整数 | 给出(未编码)文件的总长度(单位是字节) |
| transfer_length | 整数 | 给出(编码)文件的总长度(单位是字节)。注意，如果应用了内容编码(参阅上面)，则传输长度等于内容长度 |
| entry_count | 整数 | 提供下面数组的条目计数 |
| group_ID | 整数 | 指示文件 item(源文件)所属的文件组。参阅 3GPP TS 26.346 获取更多文件组的信息 |

#### 8.11.7 Additional Metadata Container Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| meco | 文件/Movie Box(moov)/Track Box(trak) | N | 0/1 |

Additional Metadata Container Box 包含一个或多个 Meta Box。此 box 可以放在文件顶级、Movie Box(“moov”) 或 Track Box(“trak”) 携带，且只有在同一容器中带有 Meta Box 的情况下才可以出现。首选(主要) Meta Box 是未包含在 Additional Metadata Container Box 中的。Additional Metadata Container Box 中的 Meta Box 可以补充或提供其他元数据信息。例如，当单个 handler 不能处理所有元数据时，可能需要使用多个 Meta Box。在特定级别上的所有 Meta Box，包括首选的和 Additional Metadata Container Box 中的，都必须有不同的 handler 类型。

包含在 Additional Metadata Container Box 中的 Meta Box 应包含 handler 所需的 Primary Item Box 或 Primary Data Box(比如 XML Box)。它不包括有关 item 的 box 或语法元素，除了当前的 Primary Item Box 或 XML Box 指示的主 item。包含在 Additional Metadata Container Box 中的 Meta Box 中的 URL 相对于首选 Meta Box 的上下文。

```code
aligned(8) class AdditionalMetadataContainerBox extends Box('meco') {
}
```

#### 8.11.8 Metabox Relation Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| mere | Additional Metadata Container Box(meco) | N | >=0 |

Metabox Relation Box 指示相同等级(比如文件顶级、Movie Box 或 Track Box)的两个 Meta Box 之间的关系。如果这些 Meta Box 的 Metabox Relation Box，则两个 Meta Box 之间的关系未指定。通过指定 Meta Box 的 handler 类型引用 Meta Box。

```code
aligned(8) class MetaboxRelationBox
  extends FullBox('mere', version=0, 0) {
  unsigned int(32) first_metabox_handler_type;
  unsigned int(32) second_metabox_handler_type;
  unsigned int(8) metabox_relation;
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| first_metabox_handler_type | 整数 | 指示第一个要关联的 Meta Box |
| second_metabox_handler_type | 整数 | 指示第二个要关联的 Meta Box |
| metabox_relation | 整数 | 指示两个 Meta Box 之间的关系。定义下面的值：1-box 之间的关系未知(当此 box 不存在时的默认情况)；2-两个 box 在语义上不相关(比如，一个是演示，一个是注释)；3-两个 box 在语义上相关但是互补(比如，两个不同的元数据系统中表示的两个不相交的元数据集合) ；4-两个 box 在语义上相关但是重叠(比如，两个元数据集合，没有一个是另一个的子集)；两者没有“首选的”；5-两个 box 在语义上相关，但是第二个是第一个的子集或较弱版本；第一个是首选的；6-两个 box 在语义上相关但是相等(比如，两个不同的元数据系统中表示的两个本质上相同的元数据集合) |

#### 8.11.9 Meta Box 的 URL 格式

当使用 meta-box 时，可能使用绝对或相对的 URL 引用 meta-box 中的 item。绝对 URL 仅可用于引用文件级 meta-box 中的 item。

当解释 meta-box 内容中的数据时(即文件级别的 meta-box 指文件，影片级别指演示，轨道级别指轨道)，将 meta-box 中的 item 视为 shadowing 文件，该文件和容器文件的位置相同。这个 shadowing 表示如果引用和容器文件同一位置的另一个文件，则可以解析为容器文件本身的一个 item。通过在容器文件本身之后追加 URL 片段，可以在容器文件内对该 item 进行寻址。该片段以 “#” 字符开头，且包含任意一项：

- item_ID=\<n\>，通过 ID 标识 item (主要资源的 ID 可能为 0)
- item_name=\<item_name\>，当使用 Item Information Box 时

如果包含的 item 内的片段必须可以寻址，则该片段的初始 “#” 字符将替换为 “*”。

考虑下面的示例：<http://a.com/d/v.qrv#item_name=tree.html*branch1>。我们假定 v.qrv 是一个文件，且在文件级别有一个 meta-box。

- 客户端首先解析片段，使用 HTTP 从 a.com 拉取 v.qrv
- 然后检查顶级 meta box，并将其中的 item 逻辑添加到 a.com 目录 d 的缓存中
- 然后将 URL 重新格式化为 <http://a.com/d/tree.html#branch1>。注意，该片段已经提升为完整的文件名，并且第一个 “*” 已转回 “#”
- 然后，客户端或者在 meta box 中找到名为 tree.html 的 item，或从 a.com 拉取 tree.html，然后在 tree.html 中找到锚点 “branch1”
- 如果在 html 内部使用相对 URL (比如 “flower.gif”)引用了文件，客户端会使用正常规则将其转换为绝对 URL <http://a.com/d/flower.gif>，并再次检查 flower.gif 是否是命名的 item (并因此 shadow 一个此名称的单独文件)。如果不是命名的 item，从 a.com 拉取 flower.gif

#### 8.11.10 静态的元数据

这节定义 ISO 文件格式家族中静态(非定时)元数据的存储。

元数据的读者支持通常是可选的，因此对于此处或其他地方定义的格式也是可选的，除非派生规范将其变成强制性的。

##### 8.11.10.1 简单的文本

user-data box 形式有简单文本标签的支持；当前只定义了一个——版权声明。如果满足以下条件，则可以支持其他使用此简单格式的元数据：

- 使用注册的 box 类型，或使用 UUID 转义(今天允许使用后者)
- 使用注册的标签，必须记录等效的 MPEG-7 结构称为注册的一部分

##### 8.11.10.2 其他格式

当需要其他格式的元数据时，上面定义的 “meta” box 可以包含在文档的适当级别。如果该文档本身是一个元数据文档，则 meta box 在文件级别。如果元数据注释了整个演示，则 meta box 在影片级别；如果注释整个流，则在轨道级别。

##### 8.11.10.3 MPEG-7 元数据

MPEG-7 元数据存储在此规范的 meta box 中。

- 对于 Unicode 格式的文本元数据，handler 类型为 “mp7t”
- 对于以 BIM 格式压缩的二进制元数据，handler 类型为 “mp7b”。在这种情况下，二进制 XML box 包含配置信息，紧跟的二进制的 XML
- 当为文本格式时，或者在元数据容器 “meta” 中有另一个名为 “xml” 的 box，其中包含文本的 MPEG-7 文档，或者有一个 Primary Item Box 用于标识包含 MPEG-7 XML 的 item
- 当为二进制格式时，或者在元数据容器 “meta” 中有另一个名为 “bxml” 的 box，其中包含二进制的 MPEG-7 文档，或者有一个 Primary Item Box 用于标识包含 MPEG-7 二进制 XML 的 item
- 如果在文件级别使用一个 MPEG-7 box，则 File Type Box 内的 compatible_brands 列表成员应该有 “mp71” brand

#### 8.11.11 Item Data Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| idat | Metadata Box(meta) | N | 0/1 |

此 box 包含元数据 item 的数据，这些 item 使用使用构造方法指示 item 的数据区间存储在此 box 中。

```code
aligned(8) class ItemDataBox extends Box(‘idat’) {
  bit(8) data[];
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| data | 整数 | 包含的元数据 |

#### 8.11.12 Item Reference Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| iref | Metadata Box(meta) | N | 0/1 |

todo

```code
aligned(8) class SingleItemTypeReferenceBox(referenceType) extends
  Box(referenceType) {
  unsigned int(16) from_item_ID;
  unsigned int(16) reference_count;
  for (j=0; j<reference_count; j++) {
    unsigned int(16) to_item_ID;
  }
}
aligned(8) class SingleItemTypeReferenceBoxLarge(referenceType) extends
  Box(referenceType) {
  unsigned int(32) from_item_ID;
  unsigned int(16) reference_count;
  for (j=0; j<reference_count; j++) {
    unsigned int(32) to_item_ID;
  }
}
aligned(8) class ItemReferenceBox extends FullBox(‘iref’, version, 0) {
  if (version==0) {
    SingleItemTypeReferenceBox references[];
  } else if (version==1) {
    SingleItemTypeReferenceBoxLarge references[];
  }
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| referenceType | 整数 | 包含此引用类型的指示符 |
| from_item_ID | 整数 | 包含引用其他 item 的 item 的 ID |
| reference_count | 整数 | 引用的数目 |
| to_item_ID | 整数 | 包含引用的 item 的 ID |

#### 8.11.13 Auxiliary video metadata

用于深度或视差信息的辅助视频轨道可能会携带 “auvd”(辅助视频描述符)类型的元数据项；该 item 的数据正好是 ISO/IEC 23002-3 中指定的si_rbsp()。(请注意，si_rbsp() 是外部分帧的，长度由文件格式的 item 位置信息提供)。这些元数据 item 可能不止一个(例如，在同一流服务的情况下，一个用于视差信息，另一个用于深度)。

### unknown

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| vmhd/smhd/hmhd/nmhd | Media Information Box(minf) | Y | 1 |

每个轨道类型(对应媒体的 handler 类型)有一个不同的媒体信息头；匹配的头部应该存在，可以是此处定义的头部之一，也可以是派生规范中定义。

#### 8.4.5.2 Video Media Header Box

视频媒体头部包含视频媒体的常规演示信息，与编码无关。请注意 flags 字段值为 1.

```code
aligned(8) class VideoMediaHeaderBox
  extends FullBox(‘vmhd’, version = 0, 1) {
  template unsigned int(16) graphicsmode = 0; // copy, see below
  template unsigned int(16)[3] opcolor = {0, 0, 0};
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| version | 整数 | 指定此 box 的版本 |
| graphicsmode | - | 从以下枚举集合为该视频轨道指定组合模式，可通过派生规范对齐扩展：copy=0 复制现有图像 |
| opcolor | - | 3 色值(红绿蓝)集合，可供 graphicsmode 使用 |

#### 8.4.5.3 Sound Media Header Box

音频媒体头部包含音频媒体的常规演示信息，与编码无关。此头部用于所有包含音频的轨道。

```code
aligned(8) class SoundMediaHeaderBox
  extends FullBox(‘smhd’, version = 0, 0) {
  template int(16) balance = 0;
  const unsigned int(16) reserved = 0;
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| version | 整数 | 指定此 box 的版本 |
| balance | 定点数 8.8 | 将单声道音频放在立体空间中；0 为中心(正常值)；全左为 -1.0，全右 为 1.0 |

#### 8.11.4 Hint Media Header Box

hint 媒体头部包含 hint 轨道的常规演示信息，与编码无关。

```code
aligned(8) class HintMediaHeaderBox
  extends FullBox(‘hmhd’, version = 0, 0) {
  unsigned int(16) maxPDUsize;
  unsigned int(16) avgPDUsize;
  unsigned int(32) maxbitrate;
  unsigned int(32) avgbitrate;
  unsigned int(32) reserved = 0;
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| version | 整数 | 指定此 box 的版本 |
| maxPDUsize | 整数 | 给出此 (hint) 流内最大 PDU 的字节数 |
| avgPDUsize | 整数 | 给出整个演示内 PDU 的平均大小 |
| maxbitrate | 整数 | 给出在任何一秒窗口的最大速率(比特/秒) |
| avgbitrate | 整数 | 整个演示的平均速率(比特/秒) |

### 8.40 AVC Extensions

#### 8.40.1 介绍

此章节记录的技术补充最初为 AVC 支持而设计，但这些补充更加通用。

#### 8.40.4 Random Access Recovery Points

在某些编码系统中，可以在解码一些样本之后随即访问流并实现正确解码。这称为逐步解码刷新。例如，在视频中，编码器可能编码流中的帧内编码宏块，这样编码器就知道在一定的时间段内，整个图像的组成像素仅依赖该时间段内提供的帧内编码宏块。

可以进行此类逐步刷新的采样被标记为该组的成员。组定义允许在周期的开始或末尾进行标记。然而，党羽特定媒体类型一起使用时，该组的使用可能限于仅标记一个末尾(即仅限于正火负滚动至)。将滚动组定义为具有相同滚动距离的采样组。

```code
class VisualRollRecoveryEntry() extends VisualSampleGroupEntry (’roll’) {
 signed int(16) roll_distance;
}
class AudioRollRecoveryEntry() extends AudioSampleGroupEntry (’roll’) {
 signed int(16) roll_distance;
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| roll_distance | 有符号整数 | 给出必须解码才能正确解码一个采样的采样数。正值表示必须解码对应数目的采样(位于组成员采样之后)，以完成最后一次恢复，即最后一个采样正确。负值表示必须解码对应数目的采样(位于组成员采样之前)，以完成被标记的采样。不能使用零值；Sync Sample Table 记录不需要恢复滚动的随机访问点 |

### 8.41 Sample Scale Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| stsl | Sample Entry | N | 0/1 |

此 box 可出现在任何视觉采样条目中。它表示当视觉材料的宽高(在任何视觉采样条目内声明的 width 和 height 值)与轨道的宽高(在 Track Header Box 声明)不匹配时，应采用的缩放方法。此 box 的实现是可选的；如果存在且解码器可以解释，则应根据此 box 指定的缩放行为显示所有采样。否则，将所有采样缩放到 Track Header Box 指示的 width 和 height 大小。

如果图像的尺寸大于显示区域，且 Sample Scale Box 应用了“隐藏”比例，则无法显示整个图像。在这种情况下，提供信息以确定显示区域很有用。然后，center 值将会标识每个视觉采样内的高优先级区域的中心。解码器可以根据这些值显示高优先级区域。center 值暗示一个序列中所有图像的一致裁剪。当所需视觉中心在图像中心下方或右侧时，偏移值为正，否则偏移值为负。

scale_method 值的语义在 SMIL 1.0 区域的 “fit” 属性指定。

```code
aligned(8) class SampleScaleBox extends FullBox(‘stsl’, version = 0, 0) {
  bit(7) reserved = 0;
  bit(1) constraint_flag;
  unsigned int(8) scale_method;
  int(16) display_center_x;
  int(16) display_center_y;
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| constraint_flag | - | 如果设置此标记，此采样条目描述的所有采样都应根据 scale_method 字段指定的方法进行缩放。否则，建议所有采样根据 scale_method 字段指定的方法进行缩放，但可以依据实现相关的方式进行显示，这可能包括不缩放图像(即既不缩放到 Track Header Box 指示的 width 和 height，也不根据这里指定的方法缩放) |
| scale_method | 8 位 无符号整数 | 定义要使用的缩放模式。在 256 个可能的值中，0~127 保留给 ISO 使用，而 128~256 是用户定义的，在本国际标准中未指定；可由应用程序确定使用。在保留值中，目前定义了以下模式：1-fill 模式；2-hidden 模式；3-meet 模式；4-X 轴是 slice 模式；5-Y 轴是 slice 模式 |
| display_center_x | 整数 | 应该优先显示的区域中心相对图像中心的水平偏移量(单位是像素)。默认值是 0。正值表示显示中心在图像中心右侧 |
| display_center_y | 整数 | 应该优先显示的区域中心相对图像中心的垂直偏移量(单位是像素)。默认值是 0。正值表示显示中心在图像中心下方 |

### 8.45 支持受保护的流

这节记录用于受保护内容的文件格式转换。下面的情况可使用这些转换：

- 当内容已经转换(比如加密)，以致普通解码器无法再对其解码，必须使用
- 仅在理解和实现保护系统时，才能对内容解码时，可以使用

转换通过封装原始的数据声明起作用。封装修改了采样条目的四字符代码，以致不了解保护的读者将媒体流视为新的流格式。

因为采样条目的格式随媒体类型而异，因此每种媒体类型(音频、视频、文本等)都是要不同的封装四字节代码。它们是：

| 流(轨道)类型 | 采样条目代码 |
| --- | --- |
| 视频 | encv |
| 音频 | enca |
| 文本 | enct |
| 系统 | encs |

采样描述的转换通过下面的流程描述：

1. 采样描述的四字符代码被替换为指示保护封装的四字符代码：这些代码仅根据媒体类型变化。比如，“mp4v” 替换为 “encv”，且 “mp4a” 替换为 “enca”
2. 向采样描述添加 ProtectionSchemeInfoBox(在下面定义)，其他所有 box 都保持不变
3. 原始采样条目类型(四字符代码)保存在 ProtectionSchemeInfoBox 中，在一个新的名为 OriginalFormatBox(在下面定义)的 box 中

有三种方法用于标记保护性质，可以单独使用或结合使用。

1. 使用 MPEG-4 系统时，必须使用 IPMP 以标记此流是受保护的
2. MPEG-4 系统上下文之外也可使用 IPMP 描述符，使用包含 IPMP 描述符的 box
3. 也可使用 scheme 类型和信息 box 描述应用的保护

在 MPEG-4 系统之外使用 IPMP 时，在 “moov” atom 内也会出现“全局的”  IPMPControlBox。

请注意，使用 MPEG-4 系统时，MPEG-4 系统终端可以使用 IPMP 描述符有效地处理，比如带有原始格式 “mp4v” 的 “encv” 视为和 “mp4v” 完全相同。

#### 8.45.1 Protection Scheme Information Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| sinf | Protected Sample Entry/Item Protection Box(ipro) | Y | 1 |

Protection Scheme Information Box 包含了了解应用的加密转化及其参数以及查找其他信息(例如密钥管理系统的类型和位置)所需的所有信息。它还记录了媒体的原始(未加密)格式。Protection Scheme Information Box 是一个容器 box。如果采样条目使用了指示受保护流的代码，则此 box 是必需的。

当用于受保护的采样条目时，此 box 必须包含原始格式 box 来记录原始格式。以下指示方法必须使用至少一种，以标识应用的保护：

- 带 IPMP 的 MPEG-4 系统：在 MPEG-4 系统流中使用 IPME 描述符时，没有其他 box
- 标准的 IPMP：在 MPEG-4 系统之外使用 IPMP 描述符时，有一个 IPMPInfoBox
- scheme 标识：使用 SchemeTypeBox 和 SchemeInformationBox(同时出现或只出现一个)

```code
aligned(8) class ProtectionSchemeInfoBox(fmt) extends Box('sinf') {
  OriginalFormatBox(fmt) original_format;
  IPMPInfoBox IPMP_descriptors; // optional
  SchemeTypeBox scheme_type_box; // optional
  SchemeInformationBox info; // optional
}
```

#### 8.45.2 Original Format Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| frma | Protection Scheme Information Box(sinf) | Y(在受保护的采样条目中) | 1 |

Original Format Box “frma” 包含原始未转换采样描述符的四字符代码：

```code
aligned(8) class OriginalFormatBox(codingname) extends Box ('frma') {
  unsigned int(32) data_format = codingname;
  // format of decrypted, encoded data
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| data_format | - | 原始未转换采样描述符的四字符代码(例如，如果流包含受保护的 MPEG-4 视觉资源则为 “mp4v”) |

#### 8.45.3 IPMP Info Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| imif | Protection Scheme Information Box(sinf) | N | 1 |

IPMP Info Box 包含 IPMP 描述符，它们记录流应用的保护。

IPMP_Descriptor 在 14496-1 中定义。它是 MPEG-4 对象描述符(OD)的一部分，描述如何访问和编码对象。在 ISO 基本媒体文件格式中，IPMPInfoBox 可直接携带 IPMP 描述符而无需 OD 流。

IPMPInfoBox 中存在 IPMP 描述符表示相关的媒体流受此描述符描述的 IPMP 工具的保护。

每个 IPMP_Descriptor 有一个 IPMP_ToolID，指示保护所需的 IPMP 工具。使用了独立的注册机构(RA)，因此任何一方都可以注册自己的 IPMP 工具并进行识别，而不会发生冲突。

IPMP_Descriptor 携带的 IPMP 信息用于一个或多个 IPMP 工具实例，它包含但是不限于 IPMP Rights Data、IPMP Key Data、Tool Configuration Data 等。

如果此媒体流受多个 IPMP 工具保护，则此 IPMPInfoBox 可携带多个 IPMP 描述符。

```code
aligned (8) class IPMPInfoBox extends FullBox(‘imif’, 0, 0){
  IPMP_Descriptor ipmp_desc[];
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| ipmp_desc | - | IPMP 描述符的数组 |

#### 8.45.4 IPMP Control Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| ipmc | Movie Box(moov)/Meta Box(meta) | N | 0/1 |

IPMP Control Box 可能包含 IPMP 描述符，文件中的任何流可引用这些描述符。

IPMP_ToolListDescriptor 在 14496-1 中定义，它在 ISO 基本媒体文件或 meta-box 中传达访问媒体流所需的 IPMP 工具列表，也可能包含备选的 IPMP 工具列表，或访问内容所需工具的参数描述。

此 IPMPControlBox 中存在 IPMP 描述符 表示该文件或 metabox 中的媒体流受 IPMP 描述符描述的 IPMP 工具保护。如果有多个提供全局管理的 IPMP 工具，则此处可以携带多个 IPMP 描述符。

```code
aligned(8) class IPMPControlBox extends FullBox('ipmc', 0, flags) {
  IPMP_ToolListDescriptor toollist;
  int(8) no_of_IPMPDescriptors;
  IPMP_Descriptor ipmp_desc[no_of_IPMPDescriptors];
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| toollist | - | 一个 IPMP_ToolListDescriptor，在 14496-1 中定义 |
| no_of_IPMPDescriptors | - | 下面数据的大小 |
| ipmp_desc | - | IPMP 描述符的数组 |

#### 8.45.5 Scheme Type Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| schm | Protection Scheme Information Box(sinf)/ SRTP Process Box(srpp) | N | 1 |

Scheme Type Box(“schm”) 定义保护方案。

```code
aligned(8) class SchemeTypeBox extends FullBox('schm', 0, flags) {
  unsigned int(32) scheme_type; // 4CC identifying the scheme
  unsigned int(32) scheme_version; // scheme version
  if (flags & 0x000001) {
    unsigned int(8) scheme_uri[]; // browser uri
  }
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| scheme_type | - | 定义保护方案的代码 |
| scheme_version | 整数 | 用于创建内容的方案版本 |
| scheme_uri | null 结尾的字符串 | 如果用户系统上未安装方案，允许将用户定义到网页。它是一个绝对 URI，UTF-8 字符组成 |

#### 8.45.6 Scheme Information Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| schi | Protection Scheme Information Box(sinf)/ SRTP Process Box(srpp) | N | 0/1 |

Scheme Information Box 是一个容器 box，仅由使用的方案解释。加密系统需要的所有信息都存储在这里。此 box 的内容是一系列 box，这些 box 的类型和格式通过 SchemeTypeBox 内声明的方案定义。

```code
aligned(8) class SchemeInformationBox extends Box('schi') {
  Box scheme_specific_data[];
}
```

## 9 可扩展性

### 9.1 对象

此规范中定义的规范对象通过 32 位值标识，该值通常是 ISO 8859-1 字符集中四个可打印字符的集合。

为了允许用户扩展格式、存储新的对象类型，以及允许格式化为此规范的文件和某些分布式计算环境互操作，有一个类型映射和类型扩展机制，二者一起形成一对。

分布式计算中常用的是 16 字节的 UUID(统一唯一标识符)。通过组合 4 字节类型值和 12 字节的 ISO 保留值(0xXXXXXXXX-0011-0010-8000-00AA00389B71)，可以将此处指定的任何规范类型直接映射到 UUID 空间。四字节替换前面数字中的 XXXXXXXX。ISO 将这些类型标识为本规范中使用的对象类型。

用户对象使用转义类型 “uuid”。它们已记录在上面的 6.2 小节。在 size 和 type 字段之后，有一个完整的 16 字节的 UUID。

希望将每个对象视为对象具有 UUID 的系统可以采用以下算法：

```code
size := read_uint32();
type := read_uint32();
if (type==‘uuid’)
  then uuid := read_uuid()
  else uuid := form_uuid(type, ISO_12_bytes);
```

类似地，将一组对象线性化为按此规范格式化的文件时，应用下面的算法：

```code
write_uint32( object_size(object) );
uuid := object_uuid_type(object);
if (is_ISO_uuid(uuid))
  write_uint32( ISO_type_of(uuid) )
else {
  write_uint32(‘uuid’);
  write_uuid(uuid);
}
```

如果文件包含此规范的 box，这些 box 使用 “uuid” 转义和完整的 UUID 编写，则该文件不符合要求；系统不需要识别使用 “uuid” 和 ISO UUID 编写的标准的 box。

### 9.2 存储格式

包含元数据的主文件可能使用其他文件来存储媒体数据。这些其他文件可能包含来自各种标准(包括此标准)的头部声明。

如果此类次要文件设置了元数据声明，则该元数据不属于整个演示的一部分。这允许将小演示文件整合成较大的整个演示，通过构建新的元数据并引用该媒体数据，而不是复制它。

对这些其他文件的引用不必使用这些文件中的所有数据；以这种方式，可以使用媒体数据的子集，或者忽略不需要的头部。

### 9.3 派生的文件格式

出于限制目的，可将此规范用作特定文件格式的基础：比如，MPEG-4 的 MP4 文件格式和 Motion JPEG 2000 文件格式二者都由此规范衍生。编写衍生的规范时，必须制定以下内容：

新格式的名称，以及 File Type Box 的 brand 和兼容性类型。通常会使用新的文件扩展名，以及新的 MIME 类型和 Machintosh 文件类型，尽管这些定义和注册在本规范的范围之外。

必须显式声明所有模板字段；且其使用必须符合此处的规范。

必须定义采样描述内使用的确切 “codingname” 和 “protocol” 标识符。这些代码点标识的采样格式也必须定义。然而，与其在此级别定义新代码点，可能不如将新编码系统适合现有框架(比如 MPEG-4 系统框架)。比如，新的音频格式可以使用新的 codingname，或使用 “mp4a” 并在 MPEG-4 音频框架内注册新的标识符。

尽管不建议，但可以定义新的 box。

如果衍生规范需要除了视频和音频以外的新轨道类型，则必须注册新的 handler-type。必须标识此轨道所需的媒体头。如果是新 box，必须对其定义并注册其 box 类型。通常，期望大多数系统可以使用现有轨道类型。

所有新的轨道引用类型必须注册和定义。

如上定义，可用可选或必需的 box 扩展采样描述格式。这样做的通常语法是定义一个具有特定名称的新 box，扩展 VisualSampleEntry (比如)，并包含新 box。

## 10 RTP 和 SRTP hint 轨道格式

### 10.1 介绍

RTP 是由 IETF (RFC 1889 和 1890)定义的实时流传输协议，当前定义为能够携带一组有限的媒体类型(主要是音频和视频)和编码。双方都在讨论将 MPEG-4 基本流打包到 RTP 中。但是，很明显，媒体打包方式与现有技术在种类上没有不同，即 RTP 中其他编解码器所使用和此方案支持的技术。

在标准 RTP 中，每个媒体流都作为单独的 RTP 流发送；多路复用的实现是通过使用 IP 端口即多路复用，而非将多个流中的数据交织到单个 RTP 会话。但是，如果使用 MOEG，可能需要独用多个媒体轨道到一个 RTP 轨道(比如，在 RTP 中使用 MPEG-2 传输或 FlexMux)。因此，通过轨道引用将每个 hint 轨道绑定到一组媒体轨道。hint 轨道通过索引此表从其媒体轨道提取数据。媒体轨道的 hint 轨道引用的引用类型是 “hint”。

此设计在创建 hint 轨道时确定包大小；因此，我们在 hint 轨道的声明中指示选择的包大小。它在采样描述中。请注意，每个媒体轨道有多个具有不同数据包大小选择的 RTP hint 轨道，这是有效的。类似地，提供了 RTP 时钟的时间刻度。hint 轨道时间刻度的选择通常与媒体轨道的时间刻度匹配，或为服务器选择合适的值。在某些情况下，RTP 时间刻度不相同(比如，一些 MPEG 负载是 90kHz)，并且支持这种变化。会话描述(SAP/SDP) 循序存储在轨道的用户数据 box。

RTP hint 轨道不是有合成时间偏移表(ctts)。hint 不是“合成的”。相反，hint 过程可能使用传输时间偏移来设置传输时间，建立正确的传输顺序和时间戳。

hinted 内容可能需要流使用 SRTP，通过使用此处定义的 SRTP hint 轨道格式。SRTP hint 轨道与 RTP hint 轨道相同，除了：

- 采样条目名称从 “rtp” 变为 “srtp”，以指示需要 SRTP 的服务
- 采样条目增加一个额外的 box，可用于指导服务器必须应用的实时加密和完整性保护

### 10.2 采样描述格式

RTP hint 轨道是 hint 轨道(媒体 handler “hint”)，采样描述中有一个 “rtp” 条目格式：

```code
class RtpHintSampleEntry() extends SampleEntry (‘rtp‘) {
  uint(16) hinttrackversion = 1;
  uint(16) highestcompatibleversion = 1;
  uint(32) maxpacketsize;
  box additionaldata[];
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| hinttrackversion | 整数 | 目前是 1；最高兼容性 version 字段指定次轨道向后兼容的最旧版本 |
| maxpacketsize | 整数 | 指示此轨道将生成的最大包的大小 |
| additionaldata | - | 来自下面的一组 box |

```code
class timescaleentry() extends Box(‘tims’) {
 uint(32) timescale;
}
class timeoffset() extends Box(‘tsro’) {
 int(32) offset;
}
class sequenceoffset extends Box(‘snro’) {
 int(32) offset;
}
```

timescaleentry 是必须的。另外两个是可选的。offset 覆盖默认的服务器行为，即选择随机偏移量。因此，0 值将导致服务器不分别对时间戳和序列号应用偏移。

当需要 SRTP 处理时，使用 SRTP Hint Sample Entry。

```code
class SrtpHintSampleEntry() extends SampleEntry (‘srtp‘) {
  uint(16) hinttrackversion = 1;
  uint(16) highestcompatibleversion = 1;
  uint(32) maxpacketsize;
  box additionaldata[];
}
```

字段和 box 定义和 ISO 基本媒体文件格式的 RtpHintSampleEntry(“rtp”) 相同。但是，SrtpHintSampleEntry 应包含一个 SRTP Process Box 作为 additionaldata 的 box 之一。

#### 10.2.1 SRTP Process Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| srpp | 相同。但是，SrtpHintSampleEntry | Y | 1 |

SRTP Process Box 可以指导服务器应该应用的 SRTP 算法。

```code
aligned(8) class SRTPProcessBox extends FullBox(‘srpp’, version, 0) {
  unsigned int(32) encryption_algorithm_rtp;
  unsigned int(32) encryption_algorithm_rtcp;
  unsigned int(32) integrity_algorithm_rtp;
  unsigned int(32) integrity_algorithm_rtcp;
  SchemeTypeBox scheme_type_box;
  SchemeInformationBox info;
}
```

上面受保护媒体轨道已经定义了SchemeTypeBox 和 SchemeInformationBox 的语法。它们用于提供应用 SRTP 所需的参数。SchemeTypeBox 用于指示流必要的密钥管理和安全策略，以扩展到 SRTPProcessBox提供的已定义算法指针。密钥管理功能还用于建立所有必须的 SRTP 参数，参数在 SRTP 规范的 8.2 小结列举。保护方案的确定定义超出了文件格式的范围。

SRTP 定义了加密和完整性保护的算法。此处定义以下格式标识符。可以使用四个空格($20$20$20$20)的条目表示加密或完整性保护算法的选择由文件格式之外的进程决定。

| 格式 | 算法 |
| --- | --- |
| $20$20$20$20 | 加密或完整性保护算法的选择由文件格式之外的进程决定 |
| ACM1 | 加密使用 AES，带 128 位密钥的 Counter Mode，在 SRTP 规范的 4.1.1 小节定义 |
| AF81 | 加密使用 AES，带 128 位密钥的 F8-Mode，在 SRTP 规范的 4.1.2 小节定义 |
| ENUL | 加密使用 NULL 算法，在 SRTP 规范的 4.1.3 小节定义 |
| SHM2 | 完整性保护使用 HMAC-SHA-1，带 160 位密钥，在 SRTP 规范的 4.2.1 小节定义 |
| ANUL | 完整性保护未应用到 RTP(但是仍应用到 RTCP)。请注意：这只对 integrity_algorithm_rtp 有效 |

### 10.3 采样格式

hint 轨道的每个采样将生成一个或多个 RTP 包，其 RTP 时间戳和 hint 采样时间相同。因此，一个采样生成的所有包具有相同的时间戳。但是，规定要求服务器“扭曲”实际的传输时间，例如用于数据速率平滑处理。

每个采样包含两个区域: 组成数据包的说明，以及发送这些包所需的任何其他数据(比如媒体数据的加密版本)。请注意，采样大小可从 Sample Size Table 得知。

```code
aligned(8) class RTPsample {
  unsigned int(16) packetcount;
  unsigned int(16) reserved;
  RTPpacket packets[packetcount];
  byte extradata[];
}
```

#### 10.3.1 Packet Entry 格式

Packet Entry Table 中的每个包具有下面的结构：

```code
aligned(8) class RTPpacket {
  int(32) relative_time;
  // the next fields form initialization for the RTP
  // header (16 bits), and the bit positions correspond
  bit(2) reserved;
  bit(1) P_bit;
  bit(1) X_bit;
  bit(4) reserved;
  bit(1) M_bit;
  bit(7) payload_type;
  unsigned int(16) RTPsequenceseed;
  unsigned int(13) reserved = 0;
  unsigned int(1) extra_flag;
  unsigned int(1) bframe_flag;
  unsigned int(1) repeat_flag;
  unsigned int(16) entrycount;
  if (extra_flag) {
    uint(32) extra_information_length;
    box extra_data_tlv[];
  }
  dataentry constructors[entrycount];
}
class rtpoffsetTLV() extends Box(‘rtpo’) {
  int(32) offset;
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| relative_time | - | “扭曲”实际传输时间偏离采样时间。这可以实现平滑处理 |
| - | 2 字节(2+1+1+4+1+7) | 下面的两个字节正好覆盖 RTP 头部；它们帮助服务器生成 RTP 头(服务器会填充剩下的字段) |
| RTPsequenceseed | - | RTP 序列号基础。如果 hint 轨道导致传输相同 RTP 包的多个副本，那么此值对于副本都是相同的。服务器通常增加一个随机偏移到此值(但是参阅上面的 “sequenceoffset”) |
| extra_flag | - | 指示在构造器之前有其他信息，是“类型-长度-值”形式的集合。目前只定义了一个这样的集合；“rtpo” 提供 32 位有符号整数偏移量，用于要放置在数据包中的实际 RTP 时间戳。这使数据包可以按解码顺序放置在 hint 轨道，但是传输的数据包中的演示时间采用不同的顺序。这对于某些 MPEG 负载是必需的 |
| bframe_flag | - | 指示一个可丢弃的“b 帧” |
| repeat_flag | - | 指示一个“重复包”，作为前一包的副本被传输。服务器可能希望优化对这些包的处理 |
| extra_information_length | 整数 | 此字段以及所有 TLV 条目的字节长度。注意，TLV box 在 32 位边界上对齐；box 大小指示实际使用的字节数，而非填充长度。extra_information_length 将是正确的 |

#### 10.3.2 Constructor 格式

有多种形式的构造器。每个构造器都是 16 字节，使得迭代更简单。第一个字节是一个联合判别器：

```code
aligned(8) class RTPconstructor(type) {
  unsigned int(8) constructor_type = type;
}
aligned(8) class RTPnoopconstructor
  extends RTPconstructor(0)
{
  uint(8) pad[15];
}
aligned(8) class RTPimmediateconstructor
  extends RTPconstructor(1)
{
  unsigned int(8) count;
  unsigned int(8) data[count];
  unsigned int(8) pad[14 - count];
}
aligned(8) class RTPsampleconstructor
  extends RTPconstructor(2)
{
  signed int(8) trackrefindex;
  unsigned int(16) length;
  unsigned int(32) samplenumber;
  unsigned int(32) sampleoffset;
  unsigned int(16) bytesperblock = 1;
  unsigned int(16) samplesperblock = 1;
}
aligned(8) class RTPsampledescriptionconstructor
  extends RTPconstructor(3)
{
  signed int(8) trackrefindex;
  unsigned int(16) length;
  unsigned int(32) sampledescriptionindex;
  unsigned int(32) sampledescriptionoffset;
  unsigned int(32) reserved;
}
```

immediate 模式允许插入负载特定的头部(比如 RTP H.261 头部)。

对于“明文”发送媒体的 hint 轨道，采样条目会指定要从媒体轨道复制的字节数，通过给出采样编号(samplenumber)、数据偏移(sampleoffset)和要复制的长度(length)。轨道引用(trackrefindex, 严格为正)可以索引到轨道引用表，命名 hint 轨道本身(-1)，或命名唯一关联的媒体轨道(0)(因此，零值等于 1)。bytesperblock 和 samplesperblock 与使用 MP4 之前方案的压缩音频有关，该方案中的文件音频分帧不明显。对于 MP4 文件这些字段固定值为 1。

sampledescription 模式允许通过引用发送采样描述符(其中将包含基本流描述符)，作为 RTP 包的一部分。该索引(sampledescriptionindex)是 Sample Description Box 中的 SampleEntry 的索引，且偏移量(sampledescriptionoffset)是相对于 SampleEntry 的开头。

对于复杂的情况(例如加密或前向纠错)，转换后的数据会放在 hint 采样内的 extradata 字段，然后将使用 sample 模式引用 hint 轨道本身。

注意，不要求连续的包传输媒体流的连续字节。例如，为了符合 H.261 RTP 标准打包，有时需要在一个数据包末尾和下一个数据包起始发送一个字节(当宏块边界落入一个字节时)。

### 10.4 SDP 信息

使用 RTSP 和 SDP 的流媒体服务器通常使用 SDP 作为描述格式；且 SDP 信息和 RTP 流之间有必要联系，比如负载 ID 和 mime 名称的映射。因此要求 hinterland 在文件中保留 SDP 信息片段，以帮助服务器形成完整的 SDP 描述。请注意，服务还应生成必需的 SDP 条目。这里的 SDP 信息仅仅是部分的。

在影片和轨道级别，将 SDP 信息格式化为用户数据 box 内的一组 box。影片级别的 SDP box 内的文本应放置在任何媒体特定行之前(SDP 文件中的第一个 “m=” 之前)。

#### 10.4.1 影片 SDP 信息

在影片级别，用户数据 box("udta") 内，可能有一个 hint 信息容器 box：

```code
aligned(8) class moviehintinformation extends box(‘hnti’) {
}
aligned(8) class rtpmoviehintinformation extends box(‘rtp ‘) {
  uint(32) descriptionformat = ‘sdp ‘;
  char sdptext[];
}
```

hint 信息 box 可能包含多个协议的信息；这里只定义 RTP。RTP box 可能包含多种描述格式的信息；此只定义 SDP。按照 SDP 要求将 sdptext 正确格式化为一系列行，每行以 \<crlf\> 终止。

#### 10.4.2 轨道 SDP 信息

在轨道级别，结构类似；但是，我们已经从采样描述知道该轨道是一个 RTP hint 轨道。因此子 box 仅仅指定描述格式。

```code
aligned(8) class trackhintinformation extends box(‘hnti’) {
}
aligned(8) class rtptracksdphintinformation extends box(‘sdp ‘) {
  char sdptext[];
}
```

按照 SDP 要求将 sdptext 正确格式化为一系列行，每行以 \<crlf\> 终止。

### 10.5 统计信息

除了 hint 媒体头部的统计数据之外，hinter 可能在轨道用户数据 box 内的 hint statistics box 中放置额外数据。这是一个容器 box，其中可能包含许多子 box。

```code
aligned(8) class hintstatisticsbox extends box(‘hinf’) {
}
aligned(8) class hintBytesSent extends box(‘trpy’) {
  uint(64) bytessent; // total bytes sent, including 12-byte RTP headers
}
aligned(8) class hintPacketsSent extends box(‘nump’) {
  uint(64) packetssent; // total packets sent
}
aligned(8) class hintBytesSent extends box(‘tpyl’) {
  uint(64) bytessent; // total bytes sent, not including RTP headers
}
aligned(8) class hintBytesSent extends box(‘totl’) {
  uint(32) bytessent; // total bytes sent, including 12-byte RTP headers
}
aligned(8) class hintPacketsSent extends box(‘npck’) {
  uint(32) packetssent; // total packets sent
}
aligned(8) class hintBytesSent extends box(‘tpay’) {
  uint(32) bytessent; // total bytes sent, not including RTP headers
}
aligned(8) class hintmaxrate extends box(‘maxr’) { // maximum data rate
  uint(32) period; // in milliseconds
  uint(32) bytes; // max bytes sent in any period ‘period’ long
                  // including RTP headers
}
aligned(8) class hintmediaBytesSent extends box(‘dmed’) {
  uint(64) bytessent; // total bytes sent from media tracks
}
aligned(8) class hintimmediateBytesSent extends box(‘dimm’) {
  uint(64) bytessent; // total bytes sent immediate mode
}
aligned(8) class hintrepeatedBytesSent extends box(‘drep’) {
  uint(64) bytessent; // total bytes in repeated packets
}
aligned(8) class hintminrelativetime extends box(‘tmin’) {
  int(32) time; // smallest relative transmission time, milliseconds
}
aligned(8) class hintmaxrelativetime extends box(‘tmax’) {
  int(32) time; // largest relative transmission time, milliseconds
}
aligned(8) class hintlargestpacket extends box(‘pmax’) {
  uint(32) bytes; // largest packet sent, including RTP header
}
aligned(8) class hintlongestpacket extends box(‘dmax’) {
  uint(32) time; // longest packet duration, milliseconds
}
aligned(8) class hintpayloadID extends box(‘payt’) {
  uint(32) payloadID; // payload ID used in RTP packets
  uint(8) count;
  char rtpmap_string[count];
}
```

注意，并非所有子 box 都会出现，且可能有多个 “maxr” box 覆盖不同时期。

## 附录 A (提供信息) 概述和介绍

### A.1 章节概述

本节介绍了文件格式，可以帮助读者理解文件格式底层的整体概念。它构成本规范的信息性附录。

### A.2 核心概念

在文件格式中，整个演示称为**影片(movie)**。逻辑上将其分为**轨道(track)**；每个轨道代表媒体的一个定时序列(比如视频帧)。每个轨道内部的每个定时单元称为**采样(sample)**；它可能是一个视频或音频帧。按顺序对采样隐式编号。请注意，一个音频帧可能被解压缩为一个音频采样序列(从这个词在音频使用的意义来说)；通常，此规范使用单词采样表示定时的帧或数据单元。每个轨道有一个或多个**采样描述(sample description)**；轨道中的每个采样都通过引用绑定到一个描述。该描述定义如何解码采样(比如，它标识了使用的压缩算法)。

与许多其他媒体文件格式不同，此格式及其祖先将经常链接的基本概念拆分开。理解这种拆分是理解文件格式的关键。尤其是：

文件的物理结构不依赖媒体本身的物理结构。比如，许多文件格式将媒体数据“分帧”，在每个视频帧之前或之后紧接着放置头部或其他数据；此文件格式不这样做。

文件的物理结构和媒体的布局都与媒体的时间顺序无关。视频帧不需要按照时间顺序放置在文件中(尽管可能是)。

这意味着存在文件结构描述媒体的放置和时间；这些文件结构允许但不要求文件按时间排序。

符合的文件内所有数据都等都封装在 **box** 中(此文件格式之前称为 **atom**)。box 结构之外没有数据。所有元数据，包括定义媒体的放置和时间的元数据，都包含在结构化的 box 中。此规范定义了 box。通过此元数据索引媒体数据(比如视频帧)。媒体数据可能在同一文件中(包含在一个或多个 box 中)，也可能在其他文件中；元数据支持通过 URL 引用其他文件。这些次级文件内媒体数据的放置完全通过主文件中的元数据描述。虽然它们可能是格式化的，但是不需要按照此规范格式化；比如这些次级媒体文件中可能没有 box。

轨道可以是不同类型。这里有三个重要类型。**视频轨道(video track)**包含视觉采样；**音频轨道(audio track)**包含音频媒体。**hint 轨道(hint track)**大不相同；它们包含流媒体服务器的说明，用于说明如何从文件内的媒体轨道为流协议构造包。读取文件进行本地回放时可以忽略 hint 轨道；它们只和流传输相关。

### A.3 媒体的物理结构

在采样表中查找定义媒体数据布局的 box。这些 box 包括 Data Reference、Sample SizeTable、Sample To Chunk Table 和 Chunk Offset Table。在它们中间，这些表允许对轨道内的每个采样进行定位和确定其大小。

**数据引用(data reference)**允许定位次级媒体文件内的媒体。这允许从单独文件内的媒体“库”构造组合，而无需将媒体实际复制到单个文件中。例如，这极大方便了媒体编辑。

压缩表格以节省空间。另外，希望不是逐个采样地交织，而是单个轨道的多个采样一起出现，然后是另一轨道的一组采样，以此类推。一个轨道内的这些连续采样集称为**块(chunk)**。每个块在其包含文件内都有一个偏移量(从该文件开头开始)。在块内部，连续存储采样。因此，如果一个块包含两个采样，可以通过将第一个采样大小增加到该块的偏移量，来找到第二个采样的位置。Chunk Offset Table 提供偏移量；Sample To Chunk Table 提供采样编号到块编号的映射。

请注意，在块之间(但非块内部)，可能存在“死区”，媒体数据未对其引用。因此，在编辑期间，如果不需要某些媒体数据，可以简单地将其保留为未引用状态；不需要复制数据来删除它。同样，如果媒体数据在格式化为“外部”文件格式的次级文件中，则可以直接跳过该外部格式强加的头部或其他结构。

### A.4 媒体的时间结构

可通过多种结构理解文件中的时序。影片和每个轨道都有一个**时间刻度(timescale)**。它定义了一个时间轴，每秒具有多个滴答声(tick)。通过合适选择该数量，可以时间精确定时。通常，对于音频轨道这是音频采样率。对于食品，应选择合适的比例。比如，媒体时间刻度为 30000，且媒体采样时长为 1001，它准确定义了 NTSC 视频(通常，但不正确，称为 29.97)，并以 32 位提供 19.9 小时时间。(译者注：30000/1001=29.97)

轨道的时间结构可能收到**编辑列表(edit list)**的影响。这些提供两个关键功能：轨道时间线在整个影片中的局部移动(基于可能的复用)，以及“空白”时间的插入(称为空编辑)。尤其注意，如果轨道不是从演示的开头开始，则需要一个初始的空编辑。

每个轨道的总时长在头部定义；这提供了有用的轨道总结。每个采样都一个定义的**时长(duration)**。通过之前采样的时长总和定义采样的准确显示时间(其时间戳)。

### A.5 交织

文件的物理和时间结构可以对齐。这意味着媒体数据按照使用的时间顺序，在其容器中具有物理顺序。此外，如果同一文件包含多个轨道的媒体数据，此媒体数据将被交织。通常，为了简化读取一个轨道的媒体数据，并保持表的紧凑，这种交织是在适当的时间间隔(比如 1 秒)完成的，而不是逐个采样交织。这样可以减少块的数量，从而减小 Chunk Offset Table。

### A.6 组成

如果同一文件包含多个音频轨道，则回放会将其混合。这种混合受整个轨道**音量(volume)**和左/右**平衡(balance)**的影响。

同样，通过遵循视频轨道的层号(从后向前)及其组成模式，组成视频轨道。另外，可通过**矩阵(matrix)**变换每个轨道和整个影片。这样支持简单的操作(比如像素加倍、90 度旋转校正)，和复杂的操作(比如剪切、任意旋转)。

派生规范可能会使用功能更强大的系统覆盖默认的音频和视频组成(比如 MPEG-4 BIFS)。

### A.7 随机访问

本节描述如何 seek。seek 主要是通过 Sample Table Box 内包含的子 box 完成。如果存在编辑列表，必须参考该列表。

如果你想 seek 给定的轨道到时间 T，T 在 Movie Header Box 的时间范围内，你可以执行下面的操作：

1. 如果轨道包含一个编辑列表，通过迭代其中的编辑确定哪个编辑包含时间 T。然后必须从时间 T 减去影片时间刻度中编辑的起始时间，得到 T'，即影片时间刻度中编辑的时长。然后将 T' 转换为轨道媒体的时间刻度，生成 T''。最后，通过 T'' 加上编辑的媒体开始时间，计算得到要用的媒体刻度的时间。
2. 轨道的 Time to Sample Box 指示该轨道的采样和时间的关联。使用此 box 查找给定时间之前的第一个采样。
3. 在步骤 1 定位的采样可能不是随机访问点。定位最近的随机访问点需要查询两个 box。Sync Sample Table 指示哪些采样实际上是随机访问点。你可以使用此表定位指定时间之前的第一个同步采样。缺少Sync Sample Table 表示所有采样都是同步点，这使得问题更加简单。Shadow Sync Box 为内容创建者机会提供采样，这些采样正常分发过程中不会发送，但是可以将其插入以提供额外的随机访问点。这可以改善随机访问，而不会影响正常分发过程中的比特率。此 box 映射非随机访问点采样到备用的随机访问点。如果存在此表，你应该查询此表找到有关采样之前的第一个 shadow 同步采样。查询 Sync Sample Table 和 Shadow Sync Table 之后，你可能希望 seek 得到的采样，它最接近步骤 1 中找到的采样，但是在该采样之前。
4. 现在你知道了将用于随机访问的采样。使用 Sample To Chunk Table 确定该采样位于哪个块。
5. 知道哪个块包含讨论的采样，使用 Chunk Offset Box 确定块开始的位置。
6. 从该偏移量开始，使用 Sample To Chunk Box 和 Sample Size Box 包含的信息，确定讨论的采样在该块中的位置。这是所需的信息。

### A.8 分段的影片文件

本节介绍 ISO 文件可能使用的一种技术，用于在影片中构造单个 Movie Box 比较繁琐的情况。至少在以下场景会出现这种情况：

- 录制。目前，如果录制应用程序崩溃、磁盘用完或发生其他意外，在将大量媒体写入磁盘之后但是在写入 Movie Box 之前，录制的数据将无法使用。出现这种情况是因为文件格式要求将所有元数据(Movie Box)写入文件的一个连续区域。
- 录制。在嵌入设备上，尤其是静态相机，由于可用存储的大小，没有 RAM 可以缓存 Movie Box，且在影片关闭时重新计算 Movie Box 太慢。也存在相同的崩溃风险。
- HTTP 快速启动。如果影片大小合适(就 Movie Box 而言，如果时间不是)，则在快速启动之前，需要花费较长时间下载 Movie Box。

在初始的 Movie Box 中设置影片的基本“形状”：轨道数、可用的采样描述、宽度、高度、组成等。但是 Movie Box 不包含影片的全部时长信息；特别是它的轨道中包含很少或没有采样。

对于这种最小或空的影片，将添加额外的采样，其结构称为影片片段(movie fragment)。

基本设计原理和 Movie Box 中的相同；数据不“分帧”。但是，这样的设计如果需要，可以视为“分帧”设计。结构很容易映射到 Movie Box，因此可将分段的演示重写为单个 Movie Box。

方法是为全局(每个轨道一次)和每个片段内的每个采样设置默认值。只有那些具有非默认值的片段需要包含这些值。这使得普通情况——规则、重复、结构——紧凑，而不会禁用具有变体影片的增量构建。

常规的 Movie Box 设置影片的结构。它可能出现在文件中的任何位置，尽管如果位于片段之前对读者最好。(这不是规则，因为对 Movie Box 的小改动以强制将其放在文件末尾是不可能的。)此 Movie Box：

- 必须自己代表一部有效的影片(尽管轨道可能根本没有采样)
- 内部有一个 box，指示应该发现和使用的片段
- 用于包含完整的边界列表(如果有)

请注意，不理解片段的软件只会播放初始影片。理解片段并得到非分段影片的软件不会扫描片段，因为找不到片段指示 box。

## 附录 C (提供信息) 指导对此规范的派生

### C.1 介绍

此附录提供了信息文本，解释如何从 ISO 基本媒体文件格式衍生特定文件格式。

ISO/IEC 14496-12 | 15444-12 ISO 基本媒体文件格式定义文件格式的基础结构。从 ISO 基本媒体文件格式派生的其他规范中，可以提供特定媒体的扩展和用户定义的扩展。因此将存在许多规范，取决于编解码器、编解码器的组合等等。

### C.2 一般原则

许多现有的文件格式使用 ISO 基本媒体文件格式，至少有 MPEG-4 MP4 文件格式和 Motion JPEG 2000 MJ2 文件格式。当考虑 ISO 基本媒体文件格式的新派生规范时，应使用所有现有规范既作为示例以及定义和技术的来源。特别是，如果现有规范已经覆盖了如何在文件格式中存储特定的媒体类型(比如 MP4 中的 MPEG-4 视频)，则应使用该定义，而不应发明新定义。这样，共享技术的规范也会共享技术表示方式的定义。

对于文件中是否存在其他信息，应尽可能宽容；指示可以忽略无法识别的 box 和媒体(不是“应该忽略”)。这允许创建来自多个规范的混合文件，以及创建可以处理多个规范的多格式播放器。

### C.3 brand 标识符

#### C.3.1 介绍

本节覆盖 File Type Box 中的 brand 标识符的使用，包括：

- 引入新的 brand
- 播放器的行为取决于 brand
- 创建 ISO 基本媒体文件时 brand 的设置

#### C.3.2 brand 的使用

为了标识文件符合的规范，在文件格式中使用 brand 作为标识符。这些 brand 在 File Type Box 中设置。在 File Type Box 中，可以指示两种 brand。一种是 major_brand，标识文件最佳使用规范。第二种是 compatible_brands，标识文件符合的多种规范。

比如，一个 brand 可能指示：

1. 文件中可能出现的编解码器
2. 每个编解码器的数据如何存储
3. 文件适用的限制和扩展

如果需要制定不完全符合现有标准的新规范，可以注册新 brand。比如，3GPP 允许在文件格式中使用 AMR 和 H.263。因为当时任何标准都不支持这些编解码器，因此 3GPP 在 ISO 基本媒体文件格式中了 SampleENtry 和模板字段的用法，并定义了这些编解码器引用的新 box。考虑到将来文件格式使用更加广泛，因此预计需要更多 brand。

#### C.3.3 引入新的 brand

如果必须指出符合新规范，则可以定义一个新 brand。这通常意味着对于新 brand 的定义，以下条件应至少满足一个：

1. 任何现有 brand 不支持使用的编解码器
2. 任何现有 brand 不支持使用的多个编解码器的组合。此外，仅当播放器支持文件中所有媒体的解码时，才允许回放文件
3. 使用特定用户的限制和/或扩展(box、模板字段等)

如果定义了新 brand，不应要求它是 major_brand。但是，可以定义 brand 仅允许作为 compatible_brands。

#### C.3.4 播放器指南

如果 compatible_brands 列表中存在多个 brand，且播放器支持一个或多个 brand，则播放器应该播放文件中符合这些规范的部分。在这种情况下，播放器可能不呢解码不支持的媒体。

#### C.3.5 创作指南

如果作者想创建符合多个规范的文件，则应考虑以下因素：

1. 文件中不能有任何内容与 brand 标识的规范矛盾。比如，如果规范要求文件是独立的，则非独立的文件中不能使用该规范的 brand 指示
2. 如果作者满足仅符合一种规范的播放器，只能播放符合该规范的媒体，那么可以指示该 brand
3. 如果作者要求可以播放来自多个规范的媒体，那么需要一个新 brand，因为这表示对播放器的新的一致性要求

#### C.3.6 示例

在本节，我们一可以定义新 brand 的情况为例。

首先，我们解释两个目前已有的 brand。如果 compatible_brands 列表有 “3gp5”，它表示该文件包含按照 3GPP TS 26.234 (版本 5) 标准指定方式定义的媒体。例如，“3gp5” brand 文件可能包含 H.263。同样，如果 compatible_brands 列表有 “mp42”，它表示文件包含按照 ISO/IEC 14496-14 指定方式定义的媒体。例如，“mp42” brand 文件可能包含 MP3。但是，“3gp5” brand 不支持 MP3。

假定文件包含 H.263 和 MP3，且 compatible_brands 包含 “3gp5” 和 “mp42”。如果播放器只符合 “3gp5” 且不支持 MP3，播放器的建议行为是只播放 H.263。如果内容创作者不希望这样的行为，定义新 brand 来指示文件支持 H.263 和 MP3。通过在 compatible_brands 列表指定新定义的 brand，可以避免上述行为，且仅在播放器同时支持 H.263 和 MP3 时才能播放该文件。

### C.4 box 布局和顺序

尽可能避免要求任何现有的或你定义的新 box 放在特定位置。比如，现有的 JPEG 2000 规范需要一个签名 box，且该签名 box 应位于文件开头。如果另一个规范也定义一个签名 box，并且也要求在文件开头，那么不能构造同时符合这两个规范的文件。

### C.5 新媒体类型的存储

对于定义如何存储新的媒体类型，有两个选择。

首先，如果需要或接受 MPEG-4 系统构造，那么：

- 应该请求和使用一个新的 ObjectTypeIndication
- 该编解码器的解码器特定信息应定义为 MPEG-4 描述符
- 应该为此媒体定义访问单元格式

然后媒体在文件格式中使用 MPEG-4 代码点；例如，新的视频编解码器将使用 “mp4v” 类型的采样条目。

如果 MPEG-4 系统层不适合或不需要，那么：

- 应该请求和使用一个新的采样条目四字符代码
- 解码器需要的任何额外信息应定义为要存储在采样条目中的 box
- 应该为此媒体定义文件格式采样格式

注意，在第二种情况下，注册机构还将分配一个 ObjectTypeIndication 供 MPEG-4 系统使用。

### C.6 模板字段的使用

模板字段定义在文件格式中，如果派生规范使用任何模板字段，其用法必须与基本定义兼容，且显式记录该用法。

### C.7 分段影片的构造

当构建分段文件用于回放时，有一些构造内容的建议，以优化回放和随机访问。建议如下：

- 文件应该按照下面的顺序包含 box：
  - “ftyp”
  - “moov”
  - “moof” 和 “mdat” 对(数量任意)
  - “mfra”
- 对于每个媒体，“moof” box 至多包含一个“traf”。当文件包含单个视频轨道和单个音频轨道时，“moof” 将包含两个 “traf”，分别用于视频和音频
- 对于视频，将随机可访问的采样存储为每个 “traf” 的第一个采样。在逐步解码器刷新的情况下，随机可访问采样和对应的恢复点存储在同一影片片段。对于音频，和每个视频随机可访问采样显示时间最接近的采样存储为每个 “traf” 的第一个采样。因此，“moof” 中每个媒体的第一个采样有近似相等的显示时间
- 对于视频和音频，第一个(随机可访问)采样记录在 “mfra”
- “mdat” 内的所有采样均以适当的交错深度进行交错

对于音频和视频，每个 “moof” 的偏移量和初始显示时间在 “mfra” 给出。

播放器将首先加载 “moov” 和 “mfra”，并在回放期间将其保存在内存中。当需要随机访问时，播放器将搜索 “mfra”，为指定时间找到显示时间最接近的随机访问点。

因为 “moof” 内第一个采样是随机可访问的，因此播放器可在随机访问点上跳转目录。播放器可以从头开始读取 “moof” 的随机访问点。随后的 “mdat” 从随机可访问采样开始。这样，对于随机访问将不需要两步 seek。

注意，“mfra” 是可选的，且可能永远不会出现。

## 参考

- iso14496-12: ISO Base Media File Format, 20151215
