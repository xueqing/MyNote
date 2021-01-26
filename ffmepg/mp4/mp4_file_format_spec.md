# MP4 文件格式

- [MP4 文件格式](#mp4-文件格式)
  - [概念](#概念)
  - [介绍](#介绍)
    - [0.1 派生](#01-派生)
    - [0.2 交换](#02-交换)
    - [0.3 内容创建](#03-内容创建)
    - [0.4 流传输的准备](#04-流传输的准备)
  - [1 范围](#1-范围)
  - [3 MPEG-4 的存储](#3-mpeg-4-的存储)
    - [3.1 基本流轨道](#31-基本流轨道)
      - [3.1.1 基本流数据](#311-基本流数据)
      - [3.1.2 基本流描述符](#312-基本流描述符)
      - [3.1.3 对象描述符](#313-对象描述符)
    - [3.2 轨道标识符](#32-轨道标识符)
    - [3.3 流同步](#33-流同步)
    - [3.4 组成](#34-组成)
    - [3.5 FlexMux 的处理](#35-flexmux-的处理)
  - [参考](#参考)

## 概念

```txt
elementary stream  基本流
access unit  访问单元
Object Descriptor, OD  对象描述符
Object Descriptor Framework  对象描述符框架
Initial Object Descriptor  初始对象描述符
Clock Reference  时钟参考
Elementary Stream Descriptor, ESDescriptor  基本流描述符
```

## 介绍

### 0.1 派生

此规范定义 MP4 作为 ISO 媒体文件格式(ISO/IEC 14496 和 ISO/IEC 15444-12)的一个实例。

MP4 完全使用了 ISO 媒体文件格式的通用特点。MPEG-4 演示可以高度动态化，并且有一个基础架构——对象描述符框架——用于管理演示中的对象和流。使用一个初始对象描述符作为此框架的起点。在 ISO 媒体文件记录的使用模式中，通常会存在一个初始对象描述符，如下图所示。

### 0.2 交换

下图给出一个简单的交换文件的示例，文件包含两个流。

![简单的交换文件](simple_interchange_file.png)

### 0.3 内容创建

在下图中，显示内容创建过程中使用的一组文件。

![内容创建文件](content_creation_file_mp4.png)

### 0.4 流传输的准备

下图显示了通过多路复用协议准备流式传输演示，只需要一个 hint 轨道：

![用于流传输的带提示的演示](hinted_Presentation_for_streaming_mp4.png)

## 1 范围

此国际标准定义 MP4 文件格式，从 ISO 基本媒体文件格式派生。

## 3 MPEG-4 的存储

### 3.1 基本流轨道

#### 3.1.1 基本流数据

为了维持流媒体协议独立性的目标，以媒体数据最“自然”的格式进行存储，且未分段。这能够简化本地处理媒体数据。因此，将媒体数据存储为访问单元，每个访问单元是一段连续的字节(单个访问单元是MPEG-4 媒体流的采样的定义)。这极大促进了 hint 轨道中使用的分段过程。文件格式可以描述和使用存储在其他文件中的媒体数据，但是此限制仍然适用。因此，如果要使用的文件包含“预分段的”媒体数据(比如光盘上的 FlexMux 流)，则需要复制媒体数据以重新形成访问单元，以便将数据导入此文件格式。

这适用于本规范的所有流类型，包括对象描述符和时钟参考之类的“元信息”流。从积极的角度来看，这样做的结果是文件格式平等对待所有流；从消极的角度看，这意味着流之间存在“内部”交叉链接。这意味着从演示中增加和删除流将不仅仅涉及添加或删除轨道及其关联的媒体数据。不仅必须在场景中放置或删除流，可能还需要更新对象描述符流。

对于每个轨道，将整个 ES 描述符存储为一个或多个采样描述符。媒体轨道的 SLConfigDescriptor 应使用默认值(predefined=2)存储在文件中，除非基本流描述符通过 URL 引用流，即引用的流不在 MP4 文件范围内。在那种情况下，SLConfigDescriptor 不受此预定义值的限制。

在发送的比特流中，SL 包中的访问单元在字节边界上发送。这意味着 hint 轨道将使用媒体轨道中的信息构造 SL 包，且 hint 轨道将引用媒体轨道中的访问单元。hint 期间头部的放置可能无需移位，因为每个 SL 包和对应包含的访问单元都将从字节边界开始。

#### 3.1.2 基本流描述符

如本文档所述，MP4 文件范围内流的 ESDescriptor 存储在采样描述中，且字段和包含的结构限制如下：

- ES_ID: 存储设置为 0；当构建到流中时，使用 TrackID 的低 16 位
- streamDependenceFlag: 存储设置为 0；如果存在依赖，使用轨道引用类型 “dpnd” 进行指示
- URLflag: 保持不变，即设置为 false，因为流在文件中，而不是远端
- SLConfigDescriptor: 是预定义类型 2
- OCRStreamFlag: 文件中设置为 false

通过 ES URL 引用的流的 ESDescriptor 存储在采样描述中，且字段和包含的结构限制如下：

- ES_ID: 存储设置为 0；当构建到流中时，使用 TrackID 的低 16 位
- streamDependenceFlag: 存储设置为 0；如果存在依赖，使用轨道引用类型 “dpnd” 进行指示
- URLflag: 保持不变，即设置为 true，因为流不在文件中
- SLConfigDescriptor: 保持不变
- OCRStreamFlag: 文件中设置为 false

注意，传输时也可能需要重写 QoSDescriptor，因为其中包含有关 PDU 大小等信息。

#### 3.1.3 对象描述符

初始对象描述符和对象描述符流是在文件格式中专门处理的。对象描述符包括 ES 描述符，而 ESDescriptor 包含流特定的信息。另外，为了方便编辑，将轨道相关的信息作为 ESDescriptor 存储在该轨道的采样描述中。必须从那里获取信息，进行适当的重写，并在流传输演示时作为 OD 流的一部分进行传输。

因此，ES 描述符并未存储在 OD 轨道或初始对象描述符。相反，初始对象描述符有一个仅在文件中使用的描述符，仅包含基本流的轨道 ID。使用时，来自引用轨道中适当重写的 ESDescriptor 将替换此描述符。同样，通过轨道引用将 OD 轨道链接到 ES 轨道。如果在 OD 轨道内使用 ES 描述符，则使用另一个描述符，该描述符也仅出现在文件中。它包含该 OD 轨道拥有的 mpod 轨道引用集的索引。适当重写的 ESDescriptor 通过此轨道的 hint 将其进行替换。

Object Descriptor Box 中使用 ES_ID_inc：

```code
class ES_ID_Inc extends BaseDescriptor : bit(8) tag=ES_IDIncTag {
  unsigned int(32) Track_ID; // ID of the track to use
}
ES_ID_IncTag = 0x0E is reserved for file format usage.
```

OD 流中使用 ES_ID_Ref：

```code
class ES_ID_Ref extends BaseDescriptor : bit(8) tag=ES_IDRefTag {
  bit(16) ref_index; // track ref. index of the track to use
}
ES_ID_RefTag = 0x0F is reserved for file format usage.
MP4_IOD_Tag = 0x10 is reserved for file format usage.
MP4_OD_Tag = 0x11 is reserved for file format usage.
IPI_DescrPointerRefTag = 0x12 is reserved for file format usage.
ES_DescrRemoveRefTag = 0x07 is reserved for file format usage (command tag).
```

注意：上述标签值在 MPEG-4 系统规范的 8.2.2.2 表 1 和 8.2.3.2 表 2 中定义，且应从这些表中参考实际值。

hinter 可能需要发送的 OD 事件比 OD 轨道中实际发生的要多：比如，如果 ESDescriptor 改变时，OD 轨道没有事件。通常，应改发送明确创建到 OD 轨道的任何 OD 事件，与指示其他更改所需的事件一起。OD 轨道中发送的 ES 描述符取自 ES 轨道中时间上(按照解码时间)下一个采样的描述。

### 3.2 轨道标识符

### 3.3 流同步

### 3.4 组成

### 3.5 FlexMux 的处理

## 参考

- iso14496-14: MP4 File Format, 20031115
