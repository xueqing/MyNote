# ISO 基本媒体文件格式

- [ISO 基本媒体文件格式](#iso-基本媒体文件格式)
  - [介绍](#介绍)
  - [概念](#概念)
  - [对象结构文件组织](#对象结构文件组织)
    - [文件结构](#文件结构)
    - [对象结构](#对象结构)
    - [File Type Box](#file-type-box)
      - [定义](#定义)
      - [语法](#语法)
      - [语义](#语义)
  - [设计注意事项](#设计注意事项)
    - [用途](#用途)
      - [介绍](#介绍-1)
      - [交换](#交换)
      - [内容创建](#内容创建)
      - [流传输的准备](#流传输的准备)
      - [本地演示](#本地演示)
      - [流式演示](#流式演示)
    - [设计原则](#设计原则)
  - [ISO 基本媒体文件组织](#iso-基本媒体文件组织)
    - [演示结构](#演示结构)
      - [文件结构](#文件结构-1)
      - [对象结构](#对象结构-1)
      - [元数据和媒体数据](#元数据和媒体数据)
      - [轨道标识](#轨道标识)
    - [Metadata 结构(对象)](#metadata-结构对象)
      - [Box 顺序](#box-顺序)
  - [流式支持](#流式支持)
    - [流式协议的处理](#流式协议的处理)
    - [hint 轨道协议](#hint-轨道协议)
    - [hint 轨道格式](#hint-轨道格式)
  - [box 定义](#box-定义)
    - [Movie Box](#movie-box)
    - [Media Data Box](#media-data-box)
    - [Movie Header Box](#movie-header-box)
    - [Track Box](#track-box)
    - [Track Header Box](#track-header-box)
    - [Track Reference Box](#track-reference-box)
    - [Media Box](#media-box)
    - [Media Header Box](#media-header-box)
    - [Handler Reference Box](#handler-reference-box)
    - [Media Information Box](#media-information-box)
    - [Media Information Header Box](#media-information-header-box)
      - [Video Media Header Box](#video-media-header-box)
      - [Sound Media Header Box](#sound-media-header-box)
      - [Hint Media Header Box](#hint-media-header-box)
      - [NULL Media Header Box](#null-media-header-box)
    - [Data Information Box](#data-information-box)
    - [Data Reference Box](#data-reference-box)
    - [Sample Table Box](#sample-table-box)
    - [Time to Sample Box](#time-to-sample-box)
      - [Decoding Time to Sample Box](#decoding-time-to-sample-box)
      - [Composition Time to Sample Box](#composition-time-to-sample-box)
    - [Sample Description Box](#sample-description-box)
    - [Sample Size Box](#sample-size-box)
    - [Sample To Chunk Box](#sample-to-chunk-box)
    - [Chunk Offset Box](#chunk-offset-box)
    - [Sync Sample Box](#sync-sample-box)
    - [Shadow Sync Sample Box](#shadow-sync-sample-box)
    - [Degradation Priority Box](#degradation-priority-box)
    - [Padding Bits Box](#padding-bits-box)
    - [Free Space Box](#free-space-box)
    - [Edit Box](#edit-box)
    - [Edit List Box](#edit-list-box)
    - [User Data Box](#user-data-box)
    - [Copyright Box](#copyright-box)
    - [Movie Extends Box](#movie-extends-box)
    - [Movie Extends Header Box](#movie-extends-header-box)
    - [Track Extends Box](#track-extends-box)
    - [Movie Fragment Box](#movie-fragment-box)
    - [Movie Fragment Header Box](#movie-fragment-header-box)
    - [Track Fragment Box](#track-fragment-box)
    - [Track Fragment Header Box](#track-fragment-header-box)
    - [Track Fragment Run Box](#track-fragment-run-box)
    - [Movie Fragment Random Access Box](#movie-fragment-random-access-box)
    - [Track Fragment Random Access Box](#track-fragment-random-access-box)
    - [Movie Fragment Random Access Offset Box](#movie-fragment-random-access-offset-box)
    - [AVC Extensions](#avc-extensions)
      - [Independent and Disposable Samples Box](#independent-and-disposable-samples-box)
      - [Sample Groups](#sample-groups)
        - [SampleToGroup Box](#sampletogroup-box)
  - [参考](#参考)

## 介绍

ISO/IEC 基本媒体文件格式包含演示的定时媒体信息，被设计为一种灵活、可扩展的格式，以方便媒体的交换、管理、编辑和展示。媒体展示对于包含演示的系统可以是本地的，或经由网络或其他流传递机制。

文件结构是面向对象的；可以非常简单地将文件分解为基本对象，且直接从基本对象的类型推测对象的结构。

此文件格式被设计为它的设计独立于任何特定的网络协议，但总体高效支持这些网络协议。

ISO/IEC 基本媒体文件格式是媒体文件格式的基础。

ISO/IEC 14496 的此部分适用于 MPEG-4，但其技术内容与 ISO/IEC 15444-12 相同，后者适用于 JPEG 2000。

## 概念

```txt
box
  面向对象的构建块，由一个唯一的类型标识符和长度定义(在一个规范中称为'atom'， 包括 MP4 的第一个定义)
chunk
  某个轨道的一组连续样本
container box
  一种 box，只用于容纳和分组一系列相关的 box
hint track
  不包含媒体信息的特殊轨道。相反，它包含将一个或多个轨道打包到一个流通道的说明
hinter
  一种工具，运行在只包含媒体的文件，可以向该文件增加一个或多个提示轨道以方便流传输
Movie Box
  一种容器 box，其中的子 box 定义了演示的元数据('moov')
Media Data Box
  一种容器 box，包含演示的实际媒体数据('mdat')
ISO Base Media File
  此规范描述的文件格式的名称
presentation
  一个或多个运行序列(q.v.)，可能结合了音频
sample
  在非提示轨道中，采样是单个视频帧、视频帧的时间连续序列，或音频的时间连续压缩段。在提示轨道中，采样定义了一个或多个流数据包的形成。轨道内任何两个采样不能共享相同的时间戳
sample description
  一种结构，用于定义和描述轨道中的一些采样的格式
sample table
  一个压缩目录，用于轨道内采样的时间和物理布局
track
  ISO 基本媒体文件中的相关样本(q.v.)集合。对于媒体数据，轨道对应图像或采样音频的序列。对于提示轨道，轨道对应流通道
```

## 对象结构文件组织

### 文件结构

文件由一系列对象组成，在本规范中称为 box。所有数据都包含在 box 中；文件中没有其他数据。这包括特定文件格式所需的任何初始签名。

本规范中符合此章节的所有对象结构文件(所有对象结构文件)都应包含文件类型 box。

### 对象结构

此属于中的对象是 box。

box 开始的头部提供了大小和类型。头部支持紧凑或扩展的大小(32 或 64 位)，以及紧凑或扩展的类型(32 位或完整的 UUID)。标准的 box 均使用紧凑的类型(32 位)，且大多数 box 使用紧凑的大小(32 位)。通常，只有 Media Data Box 需要 64 位大小。

大小是 box 的整个大小，包含大小和类型头、字段，以及所有包含的 box。这有助于文件的常规解析。

在 MPEG-4(参阅第 2 节的参考)使用语法描述语言(SDL)定义了 box。本规范中代码片段的注释表示信息性材料。

对象中的字段先存储高位有效字节，通常称为网络字节顺序或大端格式。

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

两个字段的语义是：

- `size`: 整数，指定 box 的字节数，包含其所有字段和容纳的 bxo；如果 `size` 为 1，那么实际大小保存在字段 `largesize`；如果 `size` 为 0，那么该 box 是文件中的最后一个，且其内容延伸到文件末尾(通常只用于媒体数据 box)
- `type`: 标识 box 类型；标准 box 使用紧凑类型，通常是 4 个可打印字符，以便于标识，并在下面的 box 中显式。用户扩展使用扩展类型；在这种情况下，类型字段设置为 “uuid”

无法识别类型的 box 应该给忽略和跳过。

许多对象也包含一个版本号 version 和标识字段 flags。

```code
aligned(8) class FullBox(unsigned int(32) boxtype, unsigned int(8) v, bit(24) f)
  extends Box(boxtype) {
  unsigned int(8) version = v;
  bit(24) flags = f;
}
```

两个字段的语义是：

- `version`: 证书，指定 box 格式的版本
- `flags`: 标识的映射

无法识别版本的 box 应该给忽略和跳过。

### File Type Box

#### 定义

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| ftype | 文件 | Y | 1 |

必须尽可能早地在文件中放置此 box (例如，在任何强制性签名之后，但在任何重要的可变大小 box 之前，比如 Movie Box、Media Data Box 或 Free Space)。它表示文件的“最佳使用”规范，以及该规范的次版本；还有文件符合的其他一系列规范。读者实现此格式时，应该尝试读取标记与其实现的任何规范兼容的文件。因此，规范中任何不兼容的更改应注册新的 “brand” 标识符，以表示符合新规范的文件。

在本规范的这部分，定义 “isom”(ISO 基本媒体文件) 类型标识符合 ISO 基本媒体文件格式第 1 版的文件。

通常在文件外部标记(比如，带有文件扩展名或 mime 类型)，以标识“最佳使用”(主要的 brand)，或作者认为将提供最大兼容性的 brand。

应该使用 “iso2” brand 标识与 ISO 基础媒体文件格式的此修订版本兼容；可以将其作为 “isom” brand 的补充或替代，并且和 “isom” 适用相同的使用规则。如果未使用 “isom” brand 标识此规范的第一版，标识需要支持此修订版引入的部分或全局技术，比如要求子第 8.40 到 8.45 小节的函数，或者第 10 节中的 SRTP 支持。

“avc1” brand 应用于表示该文件符合子章节的 “AVC 扩展名”。如果未使用其他 brand，这意味着需要支持这些扩展。规范可能支持使用 “avc1” 作为主要的 brand；在这种情况下，该规范定义文件扩展名和所需行为。

如果在文件级别使用了具有 MPEG-7 句柄类型的 meta-box，那么 “mp71” brand 应该是 File Type Box 的 brand 兼容列表的成员之一。

#### 语法

```code
aligned(8) class FileTypeBox
  extends Box(‘ftyp’) {
  unsigned int(32) major_brand;
  unsigned int(32) minor_version;
  unsigned int(32) compatible_brands[]; // to end of the box
}
```

#### 语义

此 box 标识文件符合的规范。

每个 brand 是可打印的 4 字符代码，通过 ISO 注册，用于表示精确的规范。

- `major_brand`: brand 标识符
- `minor_brand`: 信息性的证书，用于主要 brand 的次版本
- `compatible_brands`: 一个 brand 列表，在 box 末尾

## 设计注意事项

### 用途

#### 介绍

文件格式旨在用作许多操作的基础。在这些不同的角色中，可将其用于不同的方式，以及整个设计的不同方面。

#### 交换

当用作交换格式时，文件通常是独立的(不引用其他文件的媒体)，值包含演示中实际使用的媒体数据，且不包含任何流相关的信息。这将产生一个很小的、独立于协议的独立文件，其中包含核心媒体数据和对其操作所需的信息。

下图给出了一个简单的交换文件的示例，其中包含两个流：

![简单的交换文件](simple_interchange_file.png)

#### 内容创建

在内容创建阶段，可对格式的多个区域进行有效使用，特别是：

- 能够分别存储每个基本流(不交错)，可能存储在单独的文件
- 能够在包含媒体数据和其他流的单个(比如，以未压缩格式编辑音频轨道，以使其与已经准备的视频轨道对齐)

这些特征意味着可以准备演示、进行编辑、开发和集成内容，而无需反复将演示重新写在磁盘上——如果需要交错且必须删除未使用数据，重写是必要的；且无需反复解码和编码数据——如果必须以编码状态存储数据，编解码是必要的。

下图显示了内容创建过程中使用的一组文件：

![内容创建文件](content_creation_file.png)

#### 流传输的准备

在准备流传输时，文件必须包含信息，用于信息发送过程中指导流媒体服务器。此外，如果将这些指令和媒体数据进行交织，那么为演示提供服务时可以避免过度搜索，这是很有用的。这对于原始媒体数据保持无损也同样重要，以便对文件进行验证、重新编辑或另外重用。最后，如果可为多个协议准备单个文件，以便不同服务器通过不同协议使用文件，这将很有帮助。

#### 本地演示

“本地”查看演示(即直接从文件而不是通过流式互联)是一个重要应用；将其用于分发演示时(比如在 CD 或 DVD ROM 上)、开发过程中，以及在流媒体服务器上验证内容。必须支持这种本地查看，并可完全随机访问。如果演示在 CD 或 DVD ROM 上，那么交错很重要，因为搜索可能会很慢。

#### 流式演示

当服务器从文件生成流时，生成的流必须符合使用的协议规范，且文件本身不应包含任何文件格式信息的痕迹。服务器需要能够随机访问演示。这对于通过多个演示引用相同媒体内容以重用服务内容可能有用；它也可以帮助在准备流式传输时，媒体数据可在只读媒体(比如 CD)上且不复制只扩充。

下图显示了通过多路复用协议准备流式传输演示，只需要一个 hint 轨道：

![用于流传输的带提示的演示](hinted_Presentation_for_streaming.png)

### 设计原则

文件结构是面向对象的；可以非常简单地将文件分解为基本对象，且直接从基本对象的类型推测对象的结构。

媒体数据不是通过文件格式“分帧”；文件格式声明提供媒体数据单元的大小、类型和位置，在物理上和媒体数据不连续。这使得可以对媒体数据划分子集，并以其自然状态进行使用，而无需将其复制以为分帧流出空间。元数据用于通过引用而不是包含来描述媒体数据。

类似的，用于特定流协议的协议信息不对媒体数据分帧；协议头和媒体数据在物理上不联系。相反，可通过引用包含媒体数据。这使得可以媒体数据的自然状态进行演示，而无需任何协议。这也使得同一组媒体数据可用于本地演示和多种协议。

协议信息的构建方式使得流媒体服务器仅需要了解该协议及其发送方式；协议信息抽象了媒体知识，以便服务器在很大程度上与媒体类型无关。同样地，媒体数据以未知协议的方式存储，使得媒体工具与协议无关。

文件格式不要求单个演示位于单个文件中，这样可以设置内容子部分，以及重用内容。当和非帧的方法结合使用时，未按照此规范格式化的文件(比如，仅包含媒体数据且不包含声明性信息的“raw”文件，或者已在媒体或计算机行业使用的文件格式)还可以包含这些媒体数据。

文件格式基于一组统一的设计，以及一组丰富的可能的结构和用法。相同的格式适用所有用法；不需要翻译。然而，当以特定方式(比如本地演示)使用时，可能需要以某些方式结构化文件以实现最佳行为(比如，数据的时间顺序)。除非使用受限的配置文件，否则本规范未定义规范性结构规则。

## ISO 基本媒体文件组织

### 演示结构

#### 文件结构

演示可能包含在多个文件中。一个文件包含整个演示的元信息，且格式化成此规范。此文件也可能包含所有的媒体数据，因此演示是独立的。如果使用了其他文件，则无需将其格式化为此规范；它们用于包含媒体数据，也可能包含未使用的媒体数据或其他信息。本规范仅涉及演示文件的结构。此规范中关于媒体数据文件的格式，只限制其中的媒体数据必须可以通过此处定义的元数据进行描述。

其他文件可以是 ISO 文件、图像文件或其他格式。其他这些文件中只存储媒体数据本身，比如 JPEG 2000 图像；所有时间和帧(位置和大小)信息都存储在 ISO 基本媒体文件中，因此辅助文件本质上是自由格式的。如果 ISO 文件包含 hint 轨道，从媒体轨道引用的媒体数据构建 hint 轨道，即使 hint 轨道没有直接引用媒体轨道的数据，仍将媒体轨道保留在文件中；删除所有 hint 轨道后，将保留整个没有 hint 的演示。但是请注意，媒体轨道可能为其媒体数据引用外部文件。

附录 A 提供了内容丰富的介绍，可能对初学者有所帮助。

#### 对象结构

文件被构造为一系列对象；其中一些对象可能包含其他对象。文件中的对象序列应该只包含一个演示元数据包装器(Movie Box)。它通常靠近未见的开头或结尾，以方便对其定位。在此级别找到的其他对象可能是 File Type Box、Free Space Box、Movie Fragments、Meta-data 或 Media Data Box。

#### 元数据和媒体数据

元数据包含在元数据包装器(Movie Box)中；媒体数据包含在相同文件的 Media Data Box 或其他文件中。媒体数据由图像或音频数据组成；媒体数据对象或媒体数据文件，可能包含其他未引用的信息。

#### 轨道标识

ISO 文件中使用的轨道标识符在该文件中是唯一的；没有两个轨道可以使用相同的标识符。

下一个轨道标识符存储在 Movie Header Box 的 `next_track_ID`，通常包含一个值，该值比文件中找到的最大轨道标识符值大 1。在大多数情况下，这使得易于生成轨道标识符。但是，如果该值为全 1(32 位无符号数 maxint)，则所有增加需要搜索未使用的轨道标识符。

### Metadata 结构(对象)

#### Box 顺序

下表提供了常规封装结构的整体视图。

该表最左侧一栏显示了肯呢个出现在顶层的 box；索引用于显示可能的包含关系。因此，比如可以在 Movie Box(moov) 中找到 Track Box(trak)，在 trak 中找到 Track Header Box(tkhd)。并非所有文件需要用到所有 box；必须使用的 box 使用星号(*)标记。请参阅各个 box 的描述，以讨论如果不存在可选 box 需要假定的内容。

用户数据对象仅应放在 Movie 或 Track Box 中，且使用扩展类的对象可以放在各种容器中，而不仅仅是顶层。

为了提高文件的互操作性和实用性，对于 box 的顺序应遵循下面的规则和准则：

1. 文件类型 box “ftyp” 应出现在任何长度可变的 box (比如 movie、free space、media data)之前。如果需要，只有固定大小的 box (比如文件签名)可以在其之前。
2. 强烈**建议**容器中首先放置所有头部 box：这些 box 是 Movie Header、Track Header、Media Header 和 Media Information Box 内特定的媒体头(比如 Video MediaHeader)。
3. 所有 Movie Fragment Box **应该**按顺序排列(参阅第 8.33 节)。
4. **建议** Sample Table Box 内的 box 按照下面的顺序：Sample Description、Time to Sample、Sample to Chunk、Sample Size、Chunk Offset。
5. 强烈**建议** Track Reference Box 和 Edit List(如果有)**应该**在 Media Box 之前，且 Handler Reference Box **应该**在 Media Information Box 之前，Data Information Box 在 Sample Table Box 之前。
6. **建议**容器中最后放置 User Data Box，即 Movie Box 或 Track Box。
7. **建议**将 Movie Fragment Random Access Box (如果有)放在文件最后。
8. **建议**Progressive Download Information Box 尽早放置在文件中，以便发挥最大效用。

表 1 —— Box 类型、结构和交叉引用

| # | # | # | # | # | # | 必要性 | 定义 | 描述 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| ftyp |   |   |   |   |   | * | 4.3  | file type and compatibility |
| pdin |   |   |   |   |   |   | 8.43 | progressive download information |
| moov |   |   |   |   |   | * | 8.1  | container for all the metadata |
|   | mvhd |   |   |   |   | * | 8.3  | movie header, overall declarations |
|   | trak |   |   |   |   | * | 8.4  | container for an individual track or stream |
|   |   | tkhd |   |   |   | * | 8.5  | track header, overall information about the track |
|   |   | tref |   |   |   |   | 8.6  | track reference container |
|   |   | edts |   |   |   |   | 8.25 | edit list container |
|   |   |   | elst |   |   |   | 8.26 | an edit list |
|   |   | mdia |   |   |   | * | 8.7  | container for the media information in a track |
|   |   |   | mdhd |   |   | * | 8.8  | media header, overall information about the media |
|   |   |   | hdlr |   |   | * | 8.9  | handler, declares the media (handler) type |
|   |   |   | minf |   |   | * | 8.10 | media information container |
|   |   |   |   | vmhd |   |   | 8.11.2 | video media header, overall information (video track only) |
|   |   |   |   | smhd |   |   | 8.11.3 | sound media header, overall information (sound track only) |
|   |   |   |   | hmhd |   |   | 8.11.4 | hint media header, overall information (hint track only) |
|   |   |   |   | nmhd |   |   | 8.11.5 | Null media header, overall information (some tracks only) |
|   |   |   |   | dinf |   | * | 8.12   | data information box, container |
|   |   |   |   |   | dref | * | 8.13   | data reference box, declares source(s) of media data in track |
|   |   |   |   | stbl |   | * | 8.14   | sample table box, container for the time/space map |
|   |   |   |   |   | stsd | * | 8.16   | sample descriptions (codec types, initialization etc.) |
|   |   |   |   |   | stts | * | 8.15.2 | (decoding) time-to-sample |
|   |   |   |   |   | ctts |   | 8.15.3 | (composition) time to sample |
|   |   |   |   |   | stsc | * | 8.18   | sample-to-chunk, partial data-offset information |
|   |   |   |   |   | stsz |   | 8.17.2 | sample sizes (framing) |
|   |   |   |   |   | stz2 |   | 8.17.3 | compact sample sizes (framing) |
|   |   |   |   |   | stco | * | 8.19   | chunk offset, partial data-offset information |
|   |   |   |   |   | co64 |   | 8.19   | 64-bit chunk offset |
|   |   |   |   |   | stss |   | 8.20   | sync sample table (random access points) |
|   |   |   |   |   | stsh |   | 8.21   | shadow sync sample table |
|   |   |   |   |   | padb |   | 8.23   | sample padding bits |
|   |   |   |   |   | stdp |   | 8.22   | sample degradation priority |
|   |   |   |   |   | sdtp |   | 8.40.2 | independent and disposable samples |
|   |   |   |   |   | sbgp |   | 8.40.3.2 | sample-to-group |
|   |   |   |   |   | sgpd |   | 8.40.3.3 | sample group description |
|   |   |   |   |   | subs |   | 8.42   | sub-sample information |
|   | mvex |   |   |   |   |   | 8.29   | movie extends box |
|   |   | mehd |   |   |   |   | 8.30   | movie extends header box |
|   |   | trex |   |   |   | * | 8.31   | track extends defaults |
|   | ipmc |   |   |   |   |   | 8.45.4 | IPMP Control Box |
| moof |   |   |   |   |   |   | 8.32   | movie fragment |
|   | mfhd |   |   |   |   | * | 8.33   | movie fragment header |
|   | traf |   |   |   |   |   | 8.34   | track fragment |
|   |   | tfhd |   |   |   | * | 8.35   | track fragment header |
|   |   | trun |   |   |   |   | 8.36   | track fragment run |
|   |   | sdtp |   |   |   |   | 8.40.2 | independent and disposable samples |
|   |   | sbgp |   |   |   |   | 8.40.3.2 | sample-to-group |
|   |   | subs |   |   |   |   | 8.42   | sub-sample information |
| mfra |   |   |   |   |   |   | 8.37   | movie fragment random access |
|   | tfra |   |   |   |   |   | 8.38   | track fragment random access |
|   | mfro |   |   |   |   | * | 8.39   | movie fragment random access offset |
| mdat |   |   |   |   |   |   | 8.2    | media data container |
| free |   |   |   |   |   |   | 8.24   | free space |
| skip |   |   |   |   |   |   | 8.24   | free space |
|   | udta |   |   |   |   |   | 8.27   | user-data |
|   |   | cprt |   |   |   |   | 8.28   | copyright etc. |
| meta |   |   |   |   |   |   | 8.44.1 | metadata |
|   | hdlr |   |   |   |   | * | 8.9    | handler, declares the metadata (handler) type |
|   | dinf |   |   |   |   |   | 8.12   | data information box, container |
|   |   | dref |   |   |   |   | 8.13   | data reference box, declares source(s) of metadata items |
|   | ipmc |   |   |   |   |   | 8.45.4 | IPMP Control Box |
|   | iloc |   |   |   |   |   | 8.44.3 | item location |
|   | ipro |   |   |   |   |   | 8.44.5 | item protection |
|   |   | sinf |   |   |   |   | 8.45.1 | protection scheme information box |
|   |   |   | frma |   |   |   | 8.45.2 | original format box |
|   |   |   | imif |   |   |   | 8.45.3 | IPMP Information box |
|   |   |   | schm |   |   |   | 8.45.5 | scheme type box |
|   |   |   | schi |   |   |   | 8.45.6 | scheme information box |
|   | iinf |   |   |   |   |   | 8.44.6 | item information |
|   | xml  |   |   |   |   |   | 8.44.2 | XML container |
|   | bxml |   |   |   |   |   | 8.44.2 | binary XML container |
|   | pitm |   |   |   |   |   | 8.44.4 | primary item reference  |

## 流式支持

### 流式协议的处理

此文件格式支持媒体数据通过网络的流式播放和本地回放。发送协议数据单元的过程是基于时间的，就像显示基于时间的数据，因此可以通过基于时间的格式进行适当描述。支持流式传输的文件或“影片”包含有关流的数据单元信息。此信息包含在文件额外的轨道，称之为 “hint” 轨道。

hint 轨道包含指示，以帮助流媒体服务器形成传输的数据包。这些指示可能包含即时数据供服务器发送(比兔头部信息)或媒体数据的引用段。这些指示被编码到文件中的方式，和将编辑或演示信息编码到文件以进行本地播放的方式相同。为服务器提供信息而不是编辑或演示信息，允许服务器以适用于特定网络传输流的方式对媒体数据分包。

无论是本地回放还是通过多种不同协议进行流传输，包含 hint 的文件中使用相同的媒体数据。同一文件内部可能为不同的协议包含单独的 “hint” 轨道，且媒体将在所有此类协议上播放，而无需另外复制媒体本身。此外，通过为特定协议添加合适的 hint 轨道，可轻松使现有媒体流式传输。媒体数据本身不需要以任何方式重新广播或格式化。

相比针对特定传输和媒体格式要求媒体信息划分为实际传输的数据单元，这种流传输方法具有更高的空间效率。按照前一种种方法，本地回放需要从数据包重新组合媒体，或者生成两个媒体副本——一个用户本地回放，一个用于流媒体。类似地，通过多种协议流式传输此类媒体对于每次传输，都需要媒体数据的多个副本。这在空间上是低效的，除非媒体数据为进行流传输被大量转换(比如通过纠错编码技术或加密)。

### hint 轨道协议

支持流式基于下面三个设计参数：

- 媒体数据表示为一组网络无关的标准轨道，可以正常播放、编辑等
- 服务器 hint 轨道具有统一的声明和基本结构；这种通用格式和协议无关，但是包含服务器 hint 轨道中描述了哪些协议的声明
- 对于每种可能传输的协议，服务器 hint 轨道都有特定的设计；所有这些设计使用相同的基本结构。比如，可能存在 RTP (用于 Internet) 和 MPEG-2 传输(用于广播)，或新标准，或特定供应商协议的设计

服务器按照 hint 轨道指示发送的结果流不能包含特定文件的信息痕迹。该设计不需要在有限数据或解码站中使用文件结构或声明样式。例如，使用 H.261 视频和 DVI 音频的文件通过 RTP 进行流传输，产生的数据流包完全符合将这些编码打包到 RTP 的 IETF 规范。

hint 轨道的构建和标记，使得在本地回放演示(而非流式)时可以忽略它们。

### hint 轨道格式

hint 轨道用于向服务器描述，如何通过流传输协议为文件中的基本流数据提供服务。每个协议都有自己的 hint 轨道格式。hint 的格式通过 hint 轨道的采样描述进行描述。大多数协议对于每个轨道仅需要一个采样描述格式。

服务器查找这些 hint 轨道时，首先找到所有 hint 轨道，然后使用其协议(采样描述格式)在该集合查找。如果当前有选择，那么服务器的选择将根据首选协议，或通过比较 hint 轨道头部的功能或采样描述中特定协议的信息。

hint 轨道根据引用将数据从其他轨道拉下来以构造流。这些其他轨道可能是 hint 轨道或基本流轨道。这些指针的确切形式由协议的采样格式定义，但通常它们由 4 部分信息组成：轨道引用索引、采样编号、偏移量和长度。其中一些对于特定协议可能是隐式的、这些“指针”始终指向数据的实际来源。如果一个 hint 轨道建在另一个 hint 轨道“顶部”，则第二个 hint 轨道必须包含第一个 hint 轨道使用的媒体轨道的直接引用，这些媒体轨道的数据被放在流中。

所有 hint 轨道使用通用的一组声明和结构：

- 将 hint 轨道链接到其携带的基本流轨道，通过 “hint” 类型的轨道引用
- 它们使用一个句柄—— Handler Reference Box 中是 “hint” 类型
- 它们使用一个 Hint Media Header Box
- 它们使用一个 hint 采样入口，位于采样描述，包含一个名称和格式，对于其代表的协议是唯一的
- 归于本地回放通常将它们标记为不可用，将其轨道头部标记置为 0

hint 轨道可通过创作工具创建，或通过提示工具增加到一个现有的演示。这样的工具可以充当媒体和协议之间的“桥梁”，因为它对两者都有深刻的了解。这支持创作工具了解媒体格式但不了解协议，且服务器可以理解协议(及其 hint 轨道)但不理解媒体数据的详细信息。

hint 轨道不是有单独的合成时间；hint 轨道中没有 “ctts” 表。hint 过程将传输时间正确计算为解码时间。

## box 定义

### Movie Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| moov | 文件 | Y | 1 |

演示的元数据存储在位于文件顶部的单个 Movie Box。通常，尽管不是必须的，此 box 靠近文件的开头或结尾。

```code
aligned(8) class MovieBox extends Box(‘moov’){
}
```

### Media Data Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| mdat | 文件 | N | >=0 |

此 box 包含媒体数据。在视频轨道中，此 box 包含视频帧。演示可以包含 0 个或多个 Media Data Box。实际的媒体数据遵循 type 字段。其结构由元数据描述(尤其参阅第 8.14 节的 Sample Table，和第 8.44.3 节的 Item Location Box)。

在大型演示中，可能希望此 box 中的数据超过 32 位大小的限制。在这种情况下，使用上面 6.2 小节中的 size 字段的对应的大数 largesize。

文件中可包含任意数量的 Media Data Box (如果所有媒体数据在其他文件中，则包含 0)。元数据通过其在文件中的绝对偏移量来引用媒体数据(参阅 8.19 小节的 Chunk Offset Box)；因此，可以轻松跳过 Media Data Box 头部和可用空间，还可以引用和使用没有任何 box 结构的文件。

```code
aligned(8) class MediaDataBox extends Box(‘mdat’) {
  bit(8) data[];
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| data | - | 包含的媒体数据 |

### Movie Header Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| mvhd | Movie Box (moov) | Y | 1 |

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
| duration | 整数 | 声明演示的长度(在指定的时间范围内)。此属性源自演示的轨道：此字段的值对应演示最长轨道的时长 |
| rate | 定点数 16.16 | 指示播放演示的首选速率；1.0(0x00010000) 是正常的正向回放 |
| volume | 定点数 8.8 | 指示首选的回放音量。1.0(0x00010000) 是全音量 |
| matrix | - | 为视频提供转化矩阵；(u,v,w) 在这里限制为 (0,0,1)，16 进制值(0,0,0x40000000) |
| next_track_ID | 非 0 整数 | 指示要添加到演示的下一个轨道的轨道 ID 值。零不是有效的轨道 ID 值。next_track_ID 值应大于在用的最大轨道 ID。如果此值大于等于全 1(32 位 maxint)，且要增加新的媒体轨道，必须在文件中搜索未使用的轨道 ID |

### Track Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| trak | Movie Box (moov) | Y | >=1 |

这是用于演示单个轨道的容器 box。每个演示包含一个或多个轨道。每个轨道都独立于演示中的其他轨道，并携带自己的时间和空间信息。每个轨道将包含其关联的 Media Box。

轨道用于两个目的：

- 包含媒体数据(媒体轨道)
- 包含流协议的打包信息(hint 轨道)

ISO 文件中至少应包含一个媒体轨道，且即使 hint 轨道未引用媒体轨道中的媒体数据，所有帮助组成 hint 轨道的媒体轨道应保留在文件中；删除所有 hint 轨道之后，将保留整个不带 hint 的演示。

```code
aligned(8) class TrackBox extends Box(‘trak’) {
}
```

### Track Header Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| tkhd | Track Box (trak) | Y | 1 |

此 box 指定单个轨道的特征。每个轨道中仅包含一个 Track Header Box。

在没有 Edit List 的情况下，轨道的显示从整个演示的开头开始。空 Edit 用于抵消轨道的开始时间。

媒体轨道的轨道头部 flags 的默认值为 7(track_enabled、track_in_movie、track_in_preview)。如果演示中所有轨道均未设置 track_in_movie 或 track_in_preview，则应将所有轨道视为在其上设置了中两个标记。hint 轨道应将轨道头部 flags 设为 0，以便在本地回放和预览时将其忽略。

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
| flags | 24 位带标记的整数 | 定义了下面的值：track_enabled(指示轨道是否启用。flags 值是 0x000001。禁用的轨道将其视为不存在，低位为 0)、track_in_movie(指示演示使用此轨道。flags 值为 0x000002)、track_in_preview(指示预览演示时使用此轨道。flags 值是 0x000004) |
| creation_time | 整数 | 声明此轨道的创建时间(从 1904-1-1 午夜起的秒数，UTC 时间) |
| modification_time | 整数 | 声明此轨道最近一次修改时间(从 1904-1-1 午夜起的秒数，UTC 时间) |
| track_ID | 整数 | 在演示整个生命周期唯一地标识此轨道。轨道 ID 永远不会重复使用，且不能为 0 |
| duration | 整数 | 指示此轨道的时长(以 Movie Header Box 的时间刻度为单位)。此字段值等于所有轨道的 Edit 总和。如果没有 Edit List，那么等于采样时长(转换为 Movie Header Box 的时间刻度)的总和。如果此轨道的时长不能确定，则将其设置为全 1(32 位 maxint) |
| layer | 整数 | 指定视频轨道从前到后的顺序；编号较小的轨道更靠近观看者。0 是正常值，且 -1 将位于轨道 0 的前面，以此类推 |
| alternate_group | 整数 | 指定轨道组或集合。如果此字段为 0，则没有和其他轨道可能关系的信息。如果不为 0，则对于包含备用数据的轨道应该相同，对于属于不同组的轨道不同。在任何时候备用组中只应有一个轨道播放或流式传输，且必须通过属性(比如比特率、编解码器、语言、包大小等)与该组中其他轨道区分。一个组可能只有一个成员 |
| volume | 定点数 8.8 | 指定轨道的相对音频音量。全音量是 1.0(0x0100)，是正常值。该值与纯视觉轨道无关。可根据轨道音量组合轨道，然后使用整体的 Movie Header Box 的音量设置；或可以使用更复杂的音频组合(比如 MPEG-4 BIFS)  |
| matrix | - | 为视频提供转化矩阵；(u,v,w) 在这里限制为 (0,0,1)，16 进制值(0,0,0x40000000) |
| width/height | 定点数 16.16 | 指定轨道的视觉显示尺寸。它们不必等同于采样描述记录的图像的像素尺寸；在对矩阵表示的轨道进行任何整体转换之前，将序列中的所有图像缩放到指定的尺寸。图像的像素尺寸是默认值 |

### Track Reference Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| tref | Track Box (trak) | N | 0/1 |

此 box 提供了从包含的轨道到演示中另一个轨道的引用。这些引用是带类型的。“hint” 引用将包含的 hint 轨道链接到其提示的媒体数据。内容描述引用 “cdsc” 将描述性或元数据轨道链接到期描述的内容。

Track Box 内中可包含一个 Track Reference Box。

如果不存在此 box，则改轨道不会以任何方式引用任何其他轨道。调整引用数组以填充引用类型 box。

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
| reference_type | 整数 | 应设为下面某个值：“hint”(引用的轨道包含此 hint 轨道的原始媒体)；“cdsc”(此轨道描述了引用的轨道) |

### Media Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| mdia | Track Box (trak) | Y | 1 |

媒体声明容器包含所有声明轨道内媒体数据信息的对象。

```code
aligned(8) class MediaBox extends Box(‘mdia’) {
}
```

### Media Header Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| mdhd | Media Box (mdia) | Y | 1 |

媒体头部声明了与媒体无关，且与轨道中的媒体特征相关的整体信息。

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
| duration | 整数 | 声明此媒体的时长(以时间刻度为单位) |
| language | - | 声明此媒体的语言代码。参阅 ISO 639-2/T 的三个字符的代码集合。每个字符打包为其 ASCII 值和 0x60 的差值。由于代码仅限于三个小写字母，因此这些值严格为正。 |

### Handler Reference Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| hdlr | Media Box (mdia) 或 Meta Box (meta) | Y | 1 |

此 box 在 Media Box 内，声明展示轨道中媒体数据的过程，从而声明轨道中媒体的性质。例如，视频轨道将由视频句柄处理。

此 box 存在 Meta Box 内时，声明“元” box 内容的结构或格式。

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

### Media Information Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| minf | Media Box (mdia) | Y | 1 |

此 box 包含所有声明轨道中媒体特征信息的对象。

```code
aligned(8) class MediaInformationBox extends Box(‘minf’) {
} 
```

### Media Information Header Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| vmhd/smhd/hmhd/nmhd | Media Information Box (minf) | Y | 1 |

每个轨道类型(对应媒体的句柄类型)有一个不同的媒体信息头；匹配的头部应该存在，可以是此处定义的头部之一，也可以是派生规范中定义。

#### Video Media Header Box

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

#### Sound Media Header Box

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

#### Hint Media Header Box

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

#### NULL Media Header Box

除了视频和音频的流可能在此处定义的 NULL Media Header Box。

```code
aligned(8) class NullMediaHeaderBox
  extends FullBox(’nmhd’, version = 0, flags) {
} 
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| version | 整数 | 指定此 box 的版本 |
| flags | 24 位整数 | 标记位(目前都是 0) |

### Data Information Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| dinf | Media Information Box (minf) 或 Meta Box (meta) | Y(minf)/N(meta) | 1 |

box 包含声明轨道内媒体信息位置的对象。

```code
aligned(8) class DataInformationBox extends Box(‘dinf’) {
}
```

### Data Reference Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| url/urn/dref | Data Information Box (dinf) | Y | 1 |

数据引用对象包含一个数据引用表(通常是 URL)，这些表声明了演示中使用的媒体数据的位置。采样描述内的数据引用索引将此表中的条目和轨道中的采样关联。可通过此方式将轨道分为多个源。

如果设置了标记以指示数据与此 box 在同一文件，则在条目字段中不应提供任何字符串(空字符串也不行)。

DataReferenceBox 内的 DataEntryBox 应该是 DataEntryUrnBox 或 DataEntryUrlBox。

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
  for (i=1; i • entry_count; i++) { entry_count; i++) {
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

### Sample Table Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| stbl | Media Information Box (minf) | Y | 1 |

采样表包含轨道内媒体采样的所有时间和数据索引。使用这里的表格，可以及时定位采样、确定采样类型(例如是否是 I 帧)，并确定采样的大小、容器以及到该容器的偏移。

如果包含 Sample Table Box 的轨道没有引用数据，那么 Sample Table Box 不需要包含任何子 box (这不是非常有用的媒体轨道)。

如果包含 Sample Table Box 的轨道确实引用了数据，则需要以下子 box：Sample Description、Sample Size、Sample To Chunk 和 Chunk Offset。此外，Sample Description Box 应包含至少一个条目。需要 Sample Description Box 是因为其中包含数据引用索引字段，用来指示检索媒体采样时使用的 Data Reference Box。没有 Sample Description，就无法确定媒体采样存储的位置。Sync Sample Box 是可选的。如果它不存在，则所有采样都是同步采样。

附录 A 使用 Sample Table Box 中定义的结构，对随机访问做了叙述性描述。

```code
aligned(8) class SampleTableBox extends Box(‘stbl’) {
}
```

### Time to Sample Box

采样的合成时间(CT)和解码时间(DT)来自 Time to Sample Box，其中有两种类型。解码时间再 Decoding Time to Sample Box 中定义，给出连续解码时间之间的时间增量。合成时间在 Composition Time to Sample Box 中，由合成时间与解码时间的时间偏移量得到。如果轨道中每个采样的合成时间和解码时间都相同，则仅需要 Decoding Time to Sample Box；一定不能出现 Composition Time to Sample Box。

Time to Sample Box 必须为所有采样提供非零的时长，最后一个采样可能除外。“stts” box 中的时长是严格的正数(非零)，除了最后一条条目可能为零。此规则源于流中没有两个时间戳可以相同的规则。将采样添加到流中时必须格外小心，为了遵守该规则，可能需要将先前最后一个采样的时长设为非零。如果最后一个采样的时长不确定，使用任意小的值和 “dwell” edit。

在以下示例中，有一个 I、P 和 B 帧序列，每帧的解码时间增量为 10。按以下方式存储采样，包含标明的解码时间增量和合成时间偏移量(实际的 CT 和 DT 仅供参考)。因为必须在双向预测的 B 帧之前对预测的 P 帧进行解码，因此需要重新排序。采样的 DT 值始终是之前采样的差值之和。注意，解码增量的综合是该轨道中媒体的时长。

表 2——闭合的 GOP 示例

![闭合的 GOP 示例](closed_gop_example.png)

表 3——开放的 GOP 示例

![开放的 GOP 示例](open_gop_example.png)

#### Decoding Time to Sample Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| stts | Sample Table Box (stbl) | Y | 1 |

此 box 包含表格的紧凑版本，该表允许从解码时间到采样版本的索引。其他表格则根据采样编号给出采样大小和指针。表中的每个条目给出具有相同时间增量的连续采样的数目，以及这些采样的增量。通过添加增量可以构建完整的采样时间图。

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
| sample_count | 整数 | 给定时长的连续采样的数目 |
| sample_delta | 整数 | 在媒体的时间范围内给出这些采样的增量 |

#### Composition Time to Sample Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| ctts | Sample Table Box (stbl) | N | 0/1 |

此 box 提供解码时间和合成时间的偏移量。因为解码时间必须小于合成时间，偏移表示为无符号数，以使 CT(n)=DT(n)+CTTS(n)，其中 CTTS(n) 是采样 n 的(未压缩)表条目。Composition Time to Sample Box 是可选的，且只有所有采样的 DT 与 CT 不同时才必须存在。

hint 轨道不使用此 box。

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

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| version | 整数 | 指定此 box 的版本 |
| entry_count | 整数 | 对下表的条目计数 |
| sample_count | 整数 | 给定偏移量的连续采样的数目 |
| sample_offset | 非负整数 | 给出 CT 和 DT 的偏移量，以使 CT(n)=DT(n)+CTTS(n) |

### Sample Description Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| stsd | Sample Table Box (stbl) | Y | 1 |

Sample Description Box 提供了有关使用的编码类型的详细信息，以及该编码所需的任何初始化信息。

存储在 Sample Description Box 内 entry_count 之后的信息是特定轨道类型的，且在轨道类型内也可以有变体(例如，即使在视频轨道中，不同的编码可能在某些公共字段之后使用不同的特定信息)。

视频轨道使用 VisualSampleEntry；音频轨道使用 AudioSampleEntry。hint 轨道使用特定协议的条目格式，且具有合适的名称。

对于 hint 轨道，Sample Description 包含使用于所用流协议的声明性数据，以及 hint 轨道的格式。Sample Description 的描述定义特定于协议。

轨道内可能使用多个描述。

“protocol” 和 “codingname” 字段是已注册的标识符，用于唯一标识要使用的流协议和压缩格式解码器。给定的协议或编码名称对 Sample Description 可能有可选或必需的扩展名(例如编解码器初始化参数)。所有这些扩展名应在 box 诶；这些 box 出现在必选字段之后。无法识别的 box 应被忽略。

如果 SampleEntry  的 “format” 字段无法识别，则不应对 Sample Description 本身或相关的媒体采样进行解码。

在音频轨道中，音频采样率应作为媒体的时间刻度，并记录在这里的 samplerate 字段。

在视频轨道中，除非媒体格式的规范明确记录了此模板字段允许更大值，frame_count 字段必须是 1。改规范必须记录如何找到视频各个帧(其大小信息)，以及如何确定他们的时间。时间可能非常简单，跟用采样时长除以帧计数以构建帧的时长一样。

```code
aligned(8) abstract class SampleEntry (unsigned int(32) format)
  extends Box(format){
  const unsigned int(8)[6] reserved = 0;
  unsigned int(16) data_reference_index;
}
class HintSampleEntry() extends SampleEntry (protocol) {
  unsigned int(8) data [];
}
// Visual Sequences
class VisualSampleEntry(codingname) extends SampleEntry (codingname){
  unsigned int(16) pre_defined = 0;
  const unsigned int(16) reserved = 0;
  unsigned int(32)[3] pre_defined = 0;
  unsigned int(16) width;
  unsigned int(16) height;
  template unsigned int(32) horizresolution = 0x00480000; // 72 dpi
  template unsigned int(32) vertresolution = 0x00480000; // 72 dpi
  const unsigned int(32) reserved = 0;
  template unsigned int(16) frame_count = 1;
  string[32] compressorname;
  template unsigned int(16) depth = 0x0018;
  int(16) pre_defined = -1;
}
// Audio Sequences
class AudioSampleEntry(codingname) extends SampleEntry (codingname){
  const unsigned int(32)[2] reserved = 0;
  template unsigned int(16) channelcount = 2;
  template unsigned int(16) samplesize = 16;
  unsigned int(16) pre_defined = 0;
  const unsigned int(16) reserved = 0 ;
  template unsigned int(32) samplerate = {timescale of media}<<16;
}
aligned(8) class SampleDescriptionBox (unsigned int(32) handler_type)
  extends FullBox('stsd', 0, 0){
  int i ;
  unsigned int(32) entry_count;
  for (i = 1 ; i <= entry_count ; i++){
    switch (handler_type){
      case ‘soun’: // for audio tracks
        AudioSampleEntry();
        break;
      case ‘vide’: // for video tracks
        VisualSampleEntry();
        break;
      case ‘hint’: // Hint track
        HintSampleEntry();
        break;
    }
  }
} 
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| version | 整数 | 指定此 box 的版本 |
| entry_count | 整数 | 给出下表的条目计数 |
| SampleEntry | - | 适合的采样条目 |
| data_reference_index | 整数 | 包含数据引用的索引，用于检索使用此采样描述的关联采样的数据。数据引用存储在 Data Reference Box。索引范围是 1 到数据引用计数 |
| channelcount | 整数 | 1(单声道)/2(立体声) |
| samplesize | 整数 | 比特数，默认值是 16 |
| samplerate | 定点数 16.16 | 采样率(hi.lo) |
| horizresolution/vertresolution | 定点数 16.16 | 给出图像的分辨率(像素/英寸) |
| frame_count | 整数 | 指示每个采样中存储的压缩视频帧数。默认值是 1，即每个采样一帧；对于每个采样多帧的情况值可能大于 1 |
| compressorname | 字符串 | 名称，用于参考。以固定的 32 字节字段设置，第一个字节设置为要显示的字节数，其后是对应字节数的显示数据，然后填充到完整的 32 字节(包含大小占用的字节)。此字段可设为 0 |
| depth | 整数 | 取自下值之一：0x0018(图像带颜色，没有透明度) |
| width/height | 整数 | 此采样描述描述的流的最大可视宽度和高度(像素) |

### Sample Size Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| stsz/stz2 | Sample Table Box (stbl) | Y | 1(变体) |

此 box 包含采样计数和一个表格，该表给出每个采样的字节数。这允许媒体数据本身未分帧。媒体中的采样总数使用显示在采样技术中。

Sample Size Box 有两种。第一种有一个固定 32 位的字段用于表示采样尺寸；它允许为轨道内的所有采样定义固定尺寸。第二章允许更小的字段，以便在尺寸不同且较小时可以节省空间。必须存在这两种 box 之一；为了最大兼容性首选第一个版本。

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

### Sample To Chunk Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| stsc | Sample Table Box (stbl) | Y | 1 |

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

### Chunk Offset Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| stso/co64 | Sample Table Box (stbl) | Y | 1(变体) |

块偏移表给出每个块到包含文件的索引。有两种表。允许使用 32 位或 64 位偏移。后者在管理非常大的演示时非常有用。在采样表的任何单个实例中，至多有其中一种表。

偏移是文件的偏移，而不是文件中任何 box (比如 Media Data Box)的偏移。这允许引用没有任何 box 结构的文件内的媒体数据。这也意味着在构造一个独立的 ISO 文件且其前面有元数据(Movie Box)时需要格外小心，因为 Movie Box 的大小会影响媒体数据的块偏移。

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

### Sync Sample Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| stss | Sample Table Box (stbl) | N | 0/1 |

此 box 提供了流内随机访问点的紧凑标记。该表按采样编号的严格递增顺序排序。

如果不存在 Sync Sample Box，则每个采样都是一个随机访问点。

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
| sample_number | 整数 | 给出采样的编号，这些采样是流内的随机访问点 |

### Shadow Sync Sample Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| stsh | Sample Table Box (stbl) | N | 0/1 |

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

### Degradation Priority Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| stdp | Sample Table Box (stbl) | N | 0/1 |

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

### Padding Bits Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| padb | Sample Table Box (stbl) | N | 0/1 |

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

### Free Space Box

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

### Edit Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| edts | Track Box(trak) | N | 0/1 |

Edit Box 将演示时间线映射到存储在文件中的媒体时间线。Edit Box 是 Edit List Box 的容器。

Edit Box 是可选的。在没有此 box 的情况下，这些时间线存在隐式的一对一映射，且轨道的显示从演示的开头开始。空的 Edit Box 用于抵消轨道的开始时间。

```code
aligned(8) class EditBox extends Box(‘edts’) {
}
```

### Edit List Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| elst | Edit Box(edts) | N | >=0 |

此 box 包含一个显式的时间线映射。每个条目定义轨道时间线的一部分：通过映射媒体时间线的一部分，或通过指示“空”时间，或通过定义 “dwell”，对应媒体内的单个时间点将保持一段时间。

请注意，未限制 edit 落在采样时间上。这意味着，当进入 edit 时，可能有必要：

- 备份到一个同步点，并从该位置预滚动，然后
- 注意第一个采样的时长——如果 edit 进入采样的正常时长内，采样可能被截断

如果是音频，则可能需要对该帧重新解码，然后完成最后的切片。同样，在 edit 中最后一个采样的时长可能需要切片。

轨道(流)的起始偏移量有一个初始的空 edit 表示。比如，要从轨道开始播放 30 秒，但是在演示播放第 10 秒时，我们有下面的 edit list：

```txt
entry_count = 2
segment_duration = 10s
media_time = -1
media_rate = 1
segment_duration = 30s (可能是整个轨道的长度)
media_time = 0s
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

### User Data Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| udta | Movie Box(moov)/Track Box(trak) | N | 0/1 |

此 box 包含一些对象，这些对象声明关于包含的 box 及其数据(演示或轨道)的用户信息。

User Data Box 是容器 box，用于提供用户数据信息。这些用户数据被格式化为一组 box，这些 box 具有更特定的类型，这些类型更精确地声明了它们的内容。

此规范中只定义了版权声明。

```code
aligned(8) class UserDataBox extends Box(‘udta’) {
}
```

### Copyright Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| cprt | User Data Box(udta) | N | 0/1 |

Copyright Box 包含版权声明，当包含在 Movie Box 中时适用整个演示，或包含在轨道中使用整个轨道。可能有多个使用不同语言代码的 Copyright Box。

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

### Movie Extends Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| mvex | Movie Box(moov) | N | 0/1 |

此 box 警告读者文件中可能有 Movie Fragment Box。要了解鼓捣中的所有采样，必须按顺序查找和扫描这些 Movie Fragment Box，并将其信息逻辑添加到 Movie Box 找到的片段上。

附录 A 有 Movie Fragment 的叙述性介绍。

```code
aligned(8) class MovieExtendsBox extends Box(‘mvex’){
}
```

### Movie Extends Header Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| mehd | Movie Extends Box(mvex) | N | 0/1 |

Movie Extends Header 是可选的，且提供分段影片的整体时长，包括片段。如果不存此 box，则必须通过检查每个片段来计算总体时长。

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

### Track Extends Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| trex | Movie Extends Box(mvex) | Y | Movie Box 内每个轨道一个 |

此 box 设置影片片段使用的默认值。通过此方式设置默认值，可为每个 Track Fragment Box 节省空间和复杂度。

将采样片段内的标记字段编码为 32 位的值，包括这里以及 Track Fragment Header Box 的 default_sample_flags，Track Fragment Run Box 内的 sample_flags 和 first_sample_flags。该值具有下面的结构：

```code
bit(6) reserved=0;
unsigned int(2) sample_depends_on;
unsigned int(2) sample_is_depended_on;
unsigned int(2) sample_has_redundancy;
bit(3) sample_padding_value;
bit(1) sample_is_difference_sample;
 // i.e. when 1 signals a non-key or non-sync sample
unsigned int(16) sample_degradation_priority;
```

sample_depends_on、sample_is_depended_on 和 sample_has_redundancy 值在 Independent and Disposable Samples Box 内定义。

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

### Movie Fragment Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| moof | 文件 | N | 0/1 |

影片片段会及时扩展演示。它们提供了以前在 Movie Box 中的信息。如果实际采样在同一文件中，则和通常一样，这些采样在 Media Data Box。数据引用索引在采样描述中，因此当媒体数据在除包含 Movie Box 的文件之外，可以构建增量演示。

Movie Fragment Box 是顶级 box(即和 Movie Box、Media Data Box 对等)。它包含一个 Movie Fragment Header Box，以及一个或多个 Track Fragment Box。

```code
aligned(8) class MovieFragmentBox extends Box(‘moof’){
}
```

### Movie Fragment Header Box

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
| sequence_number | 整数 | 片段的序数，以递增顺序 |

### Track Fragment Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| traf | Movie Fragment Box(moof) | N | 0/1 |

影片片段内有一组轨道片段，每个轨道 0 或多个片段。轨道片段又包含 0 或多个轨道组，每个轨道组记录该轨道的连续采样组。在这些结构中，许多字段是可选的，且可以是默认的。

可以使用这些结构向轨道增加“空时间”和采样。比如，可在音频轨道中使用空插入实现静音。

```code
aligned(8) class TrackFragmentBox extends Box(‘traf’){
}
```

### Track Fragment Header Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| tfhd | Track Fragment Box(traf) | Y | 1 |

每个影片片段可以增加 0 或多个片段到每个轨道；每个轨道片段可增加 0 或多个连续采样组。Track Fragment Header 设置这些采样组所用的信息和默认值。

在 tf_flags 定义下面的标记：

- 0x000001 base-data-offset-present: 指示存在 base_data_offset 字段。这为每个轨道组的数据偏移量提供了一个明确的定位点(参见下文)。如果未提供，则影片片段中第一个轨道的 base_data_offset 是封闭的 Movie Fragment Box 的第一个字节的位置，且对于第二个及后续轨道片段，默认值是前一个片段定义的数据数据结尾。片段以这种方式“继承”其偏移量必须全部使用相同的数据引用(即，这些轨道的数据必须位于同一文件)
- 0x000002 sample-description-index-present：指示存在 sample_description_index 字段，它会在此片段覆盖 Track Extends Box 设置的默认值
- 0x000008 default-sample-duration-present
- 0x000010 default-sample-size-present
- 0x000020 default-sample-flags-present
- 0x010000 duration-is-empty：指示由 default_sample_duration 或 default_sample_duration 内的 default_sample_duration 提供的时长为空，即此时间间隔没有采样。制作的演示同时具有 Movie Box 的 edit list 和空时长片段，则该演示是错误的

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

### Track Fragment Run Box

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
| sample_count | 整数 | 增加到此片段的采样数；也是下标的行数(行数可为空) |
| data_offset | 整数 | 增加到data-offset，在 Track Fragment Header 中隐式或显式建立的 |
| first_sample_flags | 整数 | 仅为此组第一个采样提供一组设置 |

### Movie Fragment Random Access Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| mfra | 文件 | N | 1 |

Movie Fragment Random Access Box(“mfra”) 提供一个表，可帮助读者使用影片片段查找文件中的随机访问点。对于每个提供信息的轨道(可能不是所有轨道)，它包含一个 Track Fragment Random Access Box。通常将此 box 放在文件末尾或靠近末尾；Movie Fragment Random Access Box 内最后一个 box 提供了 Movie Fragment Random Access Box 的 length 字段的副本。读者可通过检查文件的最后 32 位来尝试查找 Movie Fragment Random Access Box，或从文件末尾向后扫描获取 Movie Fragment Random Access Offset Box 并使用其中的大小信息，以查看该 box 是否位于 Movie Fragment Random Access Box 的开头。

此 box 仅提供随机访问点的位置提示；影片片段本身是确定的。建议读者在定位和使用此 box 时格外注意，因为在创建文件后修改文件可能会导致指针或随机访问点的声明不正确。

```code
aligned(8) class MovieFragmentRandomAccessBox
 extends Box(‘mfra’) {
}
```

### Track Fragment Random Access Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| tfra | Movie Fragment Random Access Box(mfra) | N | >=1 |

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
  for(i=1; i • number_of_entry; i++){
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

### Movie Fragment Random Access Offset Box

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

### AVC Extensions

此章节记录的技术补充最初为 AVC 支持而设计，但这些补充更加通用。

#### Independent and Disposable Samples Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| sdtp | Sample Table Box(stbl)/Track Fragment Box(traf) | N | 0/1 |

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

表的大小 sample_count 取自 Sample Size Box(“stsz”) 或 Compact Sample Size Box (“stz2”) 的 sample_count。

Track Fragment Box 中也可能出现采样依赖 box。

```code
aligned(8) class SampleDependencyTypeBox
  extends FullBox(‘sdtp’, version = 0, 0) {
  for (i=0; i < sample_count; i++){
    unsigned int(2) reserved = 0;
    unsigned int(2) sample_depends_on;
    unsigned int(2) sample_is_depended_on;
    unsigned int(2) sample_has_redundancy;
  }
}
```

| 字段 | 类型 | 含义 |
| --- | --- | --- |
| sample_depends_on | 整数 | 取自下面 4 个值之一：0-这个采样的依赖未知；1-这个采样依赖其他采样(不是 I 帧)；2-这个采样不依赖其他采样(I 帧)；3-保留 |
| sample_is_depended_on | 整数 | 取自下面 4 个值之一：0-其他采样对这个采样的依赖未知；1-其他采样依赖这个采样(不可丢弃的)；2-其他采样不依赖这个采样(可丢弃的)；3-保留 |
| sample_has_redundancy | 整数 | 取自下面 4 个值之一：0-这个采样是否有冗余编码未知；1-这个采样有冗余编码；2-这个采样没有冗余编码；3-保留 |

#### Sample Groups

本节指定了表示轨道中采样分区的一种通用机制。采样分组是根据分组标准，将轨道的每个采样分配为一个采样组的成员。采样分组中的采样组不限于连续的采样，且可以包含不相邻的采样。由于轨道中的采样可能有多个采样分组，因此每个采样分组有一个 type 字段来指示分组的类型。例如，一个文件可能包含包含同一轨道的两个分组：一个基于样本对图层的分配，另一个基于对子序列的分配。

采样分组由两个链接的数据结构表示：

1. SampleToGroup Box 表示将采样分配给采样组
2. SampleGroupDescription Box 为每个采样组包含一个采样组条目，描述该组的属性

根据不同的分组标准，可能存在 SampleToGroup Box 和 SampleGroupDescription Box 的多个实例。

使用这些表的一个示例是，表示根据图层分配采样。在这种情况下，每个采样分组表示一层，具有的 SampleToGroup Box 实例描述了采样所属的层。

##### SampleToGroup Box

| box 类型 | 容器 | 必要性 | 数量 |
| --- | --- | --- | --- |
| sbgp | Sample Table Box(stbl)/Track Fragment Box(traf) | N | >=0 |

此表可用于查找采样所属的组，以及该采样组相关的描述。该表经过紧凑编码，每个条目给出一组采样的第一个采样的索引，这些采样具有相同的 Sample Group Description。group_description_index 是引用 SampleGroupDescription box 的索引，其中包含的条目描述每个采样组的特征。

如果轨道内的采样有多个采样分组，则此 box 可能有多个实例。每个 SampleToGroup box 的实例有一个类型码以区分不同的采样分组。在一个轨道内部，应最多有一个此 box 的实例，带有特定的分组类型。相关的 SampleGroupDescription 应为分组类型指示相同的值。

```code
aligned(8) class SampleToGroupBox
  extends FullBox(‘sbgp’, version = 0, 0)
{
  unsigned int(32) grouping_type;
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
| version | 整数 | 指定此 box 的版本 |
| grouping_type | 整数 | 标识采样分组的类型(即用于构成采样组的标准)，并将其链接到具有相同分组类型值的 SampleGroupDescription 表。对于一个轨道，具有相同 grouping_type 值的此 box 应最多出现一次 |
| entry_count | 整数 | 给出下表的条目数 |
| sample_count | 整数 | 给出具有相同 SampleGroupDescription 的连续采样的数目。如果此 box 的采样计数综合少于总的采样计数，则读者应有效扩展其条目，使剩下的样本与任何分组都不相关。如果此 box 内的总数大于其他地方记录的 sample_count，那么将无法定义读者行为 |
| group_description_index | 整数 | 给出采样组条目的索引，该条目描述此分组中的采样。索引范围是 1 到 SampleGroupDescription box 内的采样组条目数，或者取值 0 表示该采样不属于此类型任何分组 |

## 参考

- iso14496-12: ISO Base Media File Format, 20050401
