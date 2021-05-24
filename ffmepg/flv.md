# FLV 文件格式

- [FLV 文件格式](#flv-文件格式)
  - [概述](#概述)
  - [文件头](#文件头)
  - [文件体](#文件体)
  - [Tag 定义](#tag-定义)
    - [音频 Tag](#音频-tag)
      - [AUDIODATA](#audiodata)
        - [SoundRate 定义](#soundrate-定义)
        - [SoundFormat 定义](#soundformat-定义)
        - [音频载荷](#音频载荷)
    - [视频 Tag](#视频-tag)
      - [VIDEODATA](#videodata)
        - [FrameType 定义](#frametype-定义)
        - [CodecID 定义](#codecid-定义)
        - [视频载荷](#视频载荷)
    - [数据 Tag](#数据-tag)
      - [SCRIPTDATA](#scriptdata)
      - [SCRIPTDATAVALUE](#scriptdatavalue)
      - [onMetaData](#onmetadata)
  - [示例](#示例)
  - [参考](#参考)

## 概述

FLV 代表 Flash Video，文件后缀使用 `.flv`，使用 Adobe Flash 播放器或 Adobe Air 通过网络传输视频或音频内容。FLV 文件的数据和 SWF 文件的编码方式相同。出于 FLV 的限制，Adobe 系统在 2007 年创建了 F4V。

总的来说，FLV 文件包括文件头(FLV header)和文件体(FLV body)两部分，其中文件体由一系列的 Tag 和 Tag Size 对组成。有三种 Tag：

- audio 音频
- video 视频
- script 脚本，包含关键字或文件元信息之类

## 文件头

FLV 文件头包含 9 个字节：

| 字段 | 长度 | 默认值 | 描述 |
| --- | --- | --- | --- |
| 签名(Signature) | UI32 | FLV | 文件格式标识，总是 `FLV`，即 `0x46 0x4c 0x56` |
| 版本(Version) | UI8 | 1 | 只有 `0x01` 是有效的 |
| 保留标记(TypeFlagsReserved) | UB[5] | 0 | 必须是 0 |
| 音频标记(TypeFlagsAudio) | UB[1] | 1 | 1 表示存在音频 |
| 保留标记(TypeFlagsReserved) | UB[1] | 0 | 必须是 0 |
| 视频标记(TypeFlagsVideo) | UB[1] | 1 | 1 表示存在视频 |
| 头大小(DataOffset) | UI32 | 9 | 用于跳过新的扩展头，以支持将来可能出现的较大头部 |

第 5 个字节是位掩码，其值一般有三种：

- 0x01 表示只有视频
- 0x04 表示只有音频
- 0x05 表示音视频复合

## 文件体

在文件头之后，FLV 文件的剩余部分应包含交替的反向指针和 Tag。它们按照下表进行交织：

| 字段 | 类型 | 描述 |
| --- | --- | --- |
| PreviousTagSize0 | UI32 | 总是 0 |
| Tag1 | FLVTAG | 第一个 Tag |
| PreviousTagSize1 | UI32 | 上一个 Tag 的大小，包含其头部，单位 byte。对于 FLV 版本 1，此值是上一个 Tag 的 DataSize 加上 11 |
| Tag2 | FLVTAG | 第二个 Tag |
| …… | | |
| PreviousTagSizeN-1 | UI32 | 倒数第二个 Tag 的大小，包含其头部，单位 byte |
| TagN | FLVTAG | 最后一个 Tag |
| PreviousTagSizeN | UI32 | 最后一个 Tag 的大小，包含其头部，单位 byte |

## Tag 定义

FLV Tag 包含音频、视频、脚本的元数据，以及加密信息和载荷。

| 字段 | 类型 | 描述 |
| --- | --- | --- |
| Reserved | UB[2] | 为 FMS 保留，应为 0 |
| Filter | UB[1] | 指示包是否被过滤。0 表示不需要预处理；1 表示在渲染该包之前需要预处理(比如解密)。在未加密文件应为 0，加密的 Tag 应为 1 |
| TagType | UB[5] | 此 Tag 内容的类型。定义了下面的类型：8 表示音频，9 表示视频，18(0x12) 表示脚本数据 |
| DataSize | UI24 | - | 消息的长度。StreamIDx 之后到 Tag 末尾的字节数(等于 Tag 的长度 - 11) |
| Timestamp | UI24 | 0 | 第一包设置为 0。表示此 tag 数据的时间戳。此值相对于 FLV 文件的第一个 Tag(其时间戳为 0) |
| TimestampExtended | UI8 | 0 | 扩展字段，用于创建 uint32 的时间戳值。此字段表示较高的 8 比特，前一个 Timestamp 字段表示时间戳(毫秒)较低的 24 比特 |
| StreamID | UI24 | 0 | 相同类型的第一个流设置为 0。总为 0 |
| AudioTagHeader | 如果 TagType=8，则为 AudioTagHeader | - |
| VideoTagHeader | 如果 TagType=9，则为 VideoTagHeader | - |
| EncryptionHeader | 如果 Filter=1，则为 EncryptionTagHeader | 每个受保护的采样应包含 EncryptionHeader |
| FilterParams | 如果 Filter=1，则为 FilterParams | 每个受保护的采样应包含 FilterParams |
| Data | AUDIODATA/VIDEODATA/SCRIPTDATA | 由包类型定义的数据，长度由`DataSize`指定 |

### 音频 Tag

音频 Tag 类似于 SWF 文件格式中的 DefineSound Tag。对于 SWF 也支持的格式，FLV 和 SWF 中的载荷数据是相同的。

#### AUDIODATA

`AudioTagHeader` 包含音频相关的元数据。

| 字段 | 类型 | 描述 |
| --- | --- | --- |
| SoundFormat | UB[4] | SoundData 的格式 |
| SoundRate | UB[2] | 采样率 |
| SoundSize | UB[1] | 每个音频采样的大小。此参数只适用未压缩格式。压缩格式内部都压缩到 16 bit。0 表示 8-bit 采样；1 表示 16-bit 采样 |
| SoundType | UB[1] | 单声道或立体声：0 表示单声道；1 表示立体声 |
| AACPacketType | 如果 SoundFormat=10，则是 UI8 | 0 表示 AAC sequence header；1 表示 AAC raw |

##### SoundRate 定义

| 值 | 描述 |
| --- | --- |
| 0 | 5.5 kHz |
| 1 | 22 kHz |
| 2 | 44 kHz |

##### SoundFormat 定义

| 值 | 描述 |
| --- | --- |
| 0  | Linear PCM, platform endian |
| 1  | ADPCM |
| 2  | MP3 |
| 3  | Linear PCM, little endian |
| 4  | Nellymoser 16 kHz mono |
| 5  | Nellymoser 8 kHz mono |
| 6  | Nellymoser |
| 7  | G.711 A-law logarithmic PCM |
| 8  | G.711 mu-law logarithmic PCM |
| 9  | reserved |
| 10 | AAC |
| 11 | Speex |
| 14 | MP3 8 kHz |
| 15 | Device-specific sound |

其中，7/8/14/15 是保留的。

格式 3 是 Linear PCM，存储原始的 PCM 采样。如果数据是 8-bit，则采样是无符号字节。如果采样是 16-bit，则采样按照小端存储为有符号数字。如果数据是立体声，左采样和右采样交替存储：`左-右-左-右-……`。

格式 0 是 PCM，和格式 3 PCM 相同，除了格式 0 存储 16-bit 的采样，按照创建文件所在平台的端顺序。出于这个原因，不应使用格式 0。

Nellymoser 8 kHz 和 16 kHz 是特殊情况，因为 `SoundFormat` 字段不能表示 8 或 16 kHz 采样率。当在 `SoundFormat` 指定 Nellymoser 8 kHz 或 16 kHz 时，Flash 播放器忽略 `SoundRate` 和 `SoundType` 字段。对于其它 Nellymoser 采样率，指定正常的 Nellymoser `SoundFormat`，并像往常一样使用 `SoundRate` 和 `SoundType` 字段。

如果 `SoundFormat` 指示 AAC，`SoundType` 应为 1(立体声)，且 `SoundRate` 应为 3(44 kHz)。但是，这不意味着 FLV 中的 AAC 音频总是立体声、44 kHz 的数据。相反，Flash 播放器忽视这些值，并提取 AAC 比特率中编码的通道和采样率。

如果 `SoundFormat` 指示 Speex，音频被压缩成单声道、16 kHz 的采样，`SoundRate` 应为 0，且 `SoundSize` 应为 1，`SoundType` 应为 0。当存储在 SWF 文件中时，关于 Speex 的能力和限制，查看 [SWF 文件格式规范](https://www.adobe.com/devnet/swf.html)。

##### 音频载荷

`AUDIODATA` 端中包含音频载荷。根据是否加密，载荷可能是 `EncryptedBody` 或 `AudioTagBody`。`AudioTagBody` 持有音频载荷。如果 `SoundFormat` 为 10，则对应 `AACAUDIODATA`，否则数据取决于格式。

如果 `AACPacketType` 为 0，则 `AACAUDIODATA` 的数据是 `AudioSpecificConfig`。如果 `AACPacketType` 为 1，则 `AACAUDIODATA` 的数据是原始的 AAC 帧数据，类似是 UI8 数组。其中，`AudioSpecificConfig` 在 ISO 14496-3 中定义。

### 视频 Tag

视频 Tag 类似于 SWF 文件格式中的 VideoFrame Tag，且其载荷数据是相同的。

#### VIDEODATA

`VideoTagHeader` 包含视频相关的元数据。

| 字段 | 类型 | 描述 |
| --- | --- | --- |
| FrameType | UB[4] | 视频帧类型 |
| CodecID | UB[4] | 编解码器标识符 |
| AVCPacketType | 如果 CodecID=7，则为 UI8 | 0 表示 AVC sequence header；1 表示 AVC NALU；2 表示 AVC end of sequence(较低等级的 NALU end of sequence 不需要或不支持) |
| CompositionTime | 如果 CodecID=7，则为 SI24 | 如果 AVCPacketType=1 表示合成时间偏移量；否则为 0 |

##### FrameType 定义

| 值 | 描述 |
| --- | --- |
| 1 | 关键帧(用于 AVC，可 seek 的帧) |
| 2 | 非关键帧(用于 AVC，不可 seek 的帧) |
| 3 | 可丢弃中间帧(只用于 H.263) |
| 4 | 生成的关键帧(只用于服务端) |
| 5 | 视频信息/命令帧 |

##### CodecID 定义

| 值 | 描述 |
| --- | --- |
| 0 | RGB |
| 1 | run-length |
| 2 | Sorenson H.263 |
| 3 | Screen 视频 |
| 4 | On2 TrueMotion VP6 |
| 5 | 带 alpha 通道的 VP6 |
| 6 | Screen 视频版本 2 |
| 7 | AVC |
| 8 | ITU H.263 |
| 9 | MPEG-4 ASP |

##### 视频载荷

`VIDEODATA` 段包含视频元数据、可选的加密元数据，和视频载荷。根据是否加密，载荷可能是 `EncryptedBody` 或 `VideoTagBody`。`VideoTagBody` 包含视频帧载荷或帧信息。`VideoTagBody` 的数据取决于 `FrameType` 和 `CodecID`：

- 如果 `FrameType` 为 5，则 `VideoTagBody` 不是视频载荷，而是 UI8，含义如下
  - 0 Start of client-side seeking video frame sequence
  - 1 End of client-side seeking video frame sequence
- 如果 `CodecID` 为 2，则 `VideoTagBody` 是 `H263VIDEOPACKET`
- 如果 `CodecID` 为 3，则 `VideoTagBody` 是 `SCREENVIDEOPACKET`
- 如果 `CodecID` 为 4，则 `VideoTagBody` 是 `VP6FLVVIDEOPACKET`
- 如果 `CodecID` 为 5，则 `VideoTagBody` 是 `VP6FLVALPHAVIDEOPACKET`
- 如果 `CodecID` 为 6，则 `VideoTagBody` 是 `SCREENV2VIDEOPACKET`
- 如果 `CodecID` 为 7，则 `VideoTagBody` 是 `AVCVIDEOPACKET`。`AVCVIDEOPACKET` 携带 AVC 视频数据的载荷
  - 如果 `AVCPacketType` 为 0，则对应 `AVCDecoderConfigurationRecord`。参阅 ISO 14496-15 5.2.4 了解 `AVCDecoderConfigurationRecord` 的描述。
  - 如果 `AVCPacketType` 为 1，则对应一或多个 NALU(需要完整的帧)

### 数据 Tag

数据 Tag 封装单方法调用，通常在 Flash 播放器的 NetStream 对象上调用该方法。数据 tag 包含一个方法名称和一组参数。

#### SCRIPTDATA

`SCRIPTDATA` 段包含可选的加密数据，和脚本载荷。根据是否加密，可能是 `EncryptedBody` 或 `ScriptTagBody`。`ScriptTagBody` 包含编码到 AMF(Action Message Format) 中的 `SCRIPTDATA`，AMF 是一个紧凑的二进制格式，用于序列化 ActionScript 对象图。AMF0 的规范[参阅](ref/amf0-file-format-specification.pdf)。

| ScriptTagBody 字段 | 类型 | 描述 |
| --- | --- | --- |
| Name | SCRIPTDATAVALUE | 方法或对象名。SCRIPTDATAVALUE.Type=2(字符串) |
| Value | SCRIPTDATAVALUE | AMF 参数或对象属性，SCRIPTDATAVALUE.Type=8(ECMA 数组) |

#### SCRIPTDATAVALUE

一个 `SCRIPTDATAVALUE` 记录包含一个有类型的 ActionScript 值。包含两个字段：

- `Type` 字段，类型为 UI8，表示 `ScriptDataValue` 的类型。定义了下面的类型：
  - 0 Number
  - 1 Boolean
  - 2 String
  - 3 Object
  - 4 MovieClip(保留的，不支持)
  - 5 Null
  - 6 Undefined
  - 7 Reference
  - 8 ECMA array
  - 9 Object end marker
  - 10 Date
  - 12 Long String
- `ScriptDataValue` 字段，表示脚本数据值。Boolean 值 (ScriptDataValue 不等于 0)。其类型取决于 `Type` 字段的值
  - 如果 `Type` 为 0，`ScriptDataValue` 为 DOUBLE
  - 如果 `Type` 为 1，`ScriptDataValue` 为 UI8
  - 如果 `Type` 为 2，`ScriptDataValue` 为 SCRIPTDATASTRING
  - 如果 `Type` 为 3，`ScriptDataValue` 为 SCRIPTDATAOBJECT
  - 如果 `Type` 为 7，`ScriptDataValue` 为 UI16
  - 如果 `Type` 为 8，`ScriptDataValue` 为 SCRIPTDATAECMAARRAY
  - 如果 `Type` 为 10，`ScriptDataValue` 为 SCRIPTDATASTRICTARRAY
  - 如果 `Type` 为 11，`ScriptDataValue` 为 SCRIPTDATADATE
  - 如果 `Type` 为 12，`ScriptDataValue` 为 SCRIPTDATALONGSTRING

#### onMetaData

应在一个名为 `onMetadata` 的 SCRIPTDATA Tag 中携带 FLV 元数据对象。其中的属性取决于创建该 FLV 文件的软件。典型的属性包括：

| 属性 | 类型 | 描述 |
| --- | --- | --- |
| audiocodecid | Number | 文件使用的音频 CodecID |
| audiodatarate | Number | 音频比特率，单位 kb/s |
| audiodelay | Number | 音频编解码引入的延迟，单位 s |
| audiosamplerate | Number | 音频流重新播放的速率 |
| audiosamplesize | Number | 单个音频采样的分辨率 |
| canSeekToEnd | Boolean | 指示最后一个视频帧是一个关键帧 |
| creationdate | String | 创建日期和时间 |
| duration | Number | 文件的总时长，单位 s |
| filesize | Number | 文件的总大小，单位 byte |
| framerate | Number | 每秒的帧数 |
| height | Number | 视频的高度，单位 pixel |
| stereo | Boolean | 指示立体音频 |
| videocodecid | Number | 文件使用的视频 CodecID |
| videodatarate | Number | 视频比特率，单位 kb/s |
| width | Number | 视频的宽度，单位 pixel |

## 示例

## 参考

- [Flash Video](https://en.wikipedia.org/wiki/Flash_Video)
- [FLV File Format](https://docs.fileformat.com/video/flv/)
- [Adobe Flash Video File Format Specification Version 10.1](ref/adobe_flash_video_file_format_spec_v10_1.pdf)
