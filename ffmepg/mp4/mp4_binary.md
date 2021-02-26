# mp4 文件二进制代码解读示例

- [mp4 文件二进制代码解读示例](#mp4-文件二进制代码解读示例)
  - [1 文件结构](#1-文件结构)
  - [2 文件 box 结构分析示例](#2-文件-box-结构分析示例)
  - [3 文件级 box](#3-文件级-box)
    - [3.1 File Type Box, ftyp](#31-file-type-box-ftyp)
    - [3.2 Movie Box](#32-movie-box)
    - [3.3 Meta Box](#33-meta-box)
    - [3.4 Media Data Box](#34-media-data-box)
  - [Movie Header Box](#movie-header-box)
  - [Track Box](#track-box)
  - [Track Header Box](#track-header-box)
  - [Edit Box](#edit-box)
  - [Edit List Box](#edit-list-box)
  - [Media Box](#media-box)
  - [Media Header Box](#media-header-box)
  - [Handler Reference Box](#handler-reference-box)
  - [Media Information Box](#media-information-box)
  - [Data Information Box](#data-information-box)
  - [Sample Table Box](#sample-table-box)
  - [Sample Description Box](#sample-description-box)
  - [Decoding Time to Sample Box](#decoding-time-to-sample-box)
  - [Sample To Chunk Box](#sample-to-chunk-box)
  - [Chunk Offset Box](#chunk-offset-box)
  - [Sample Size Box](#sample-size-box)
  - [Sync Sample Box](#sync-sample-box)
  - [Composition Time to Sample Box](#composition-time-to-sample-box)
  - [Video Media Header Box](#video-media-header-box)
  - [Sound Media Header Box](#sound-media-header-box)
  - [User Data Box](#user-data-box)

## 1 文件结构

使用 UE 打开一个 MP4 文件，得到下面的二进制：

![mp4 文件二进制代码](mp4-bin.png)

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

box 开头的 4 字节表示 box 大小，该大小包含其 header 和 body 大小。大小之后紧跟 4 字节表示 box 类型，一般是四字符。

有的 box 也包含一个版本号 version 和标记字段 flags。

```code
aligned(8) class FullBox(unsigned int(32) boxtype, unsigned int(8) v, bit(24) f)
  extends Box(boxtype) {
  unsigned int(8) version = v;
  bit(24) flags = f;
}
```

在分析文件结构时，每次先分析 8 个字节，前 4 字节对应 box 大小，以此找到下一个分析的位置(当前位置加上 box 大小)，后 4 字节是一个四字符串，对应特定类型的 box。根据 ISO 基本媒体规范找到该 box 对应的结构进行分析。

## 2 文件 box 结构分析示例

| # | # | # | # | # | # | 地址 | 大小 | 描述 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| ftyp |   |   |   |   |   | 0x00000000 | 0x18 | file type and compatibility |
| moov |   |   |   |   |   | 0x00000018 | 0x769f9 | container for all the metadata |
|   | mvhd |   |   |   |   | 0x00000020 | 0x6c | movie header, overall declarations |
|   | trak |   |   |   |   | 0x0000008c, 0x00044b54 | 0x44ac8, 0x31e48 | container for an individual track or stream |
|   |   | tkhd |   |   |   | 0x00000094, 0x00044b5c | 0x5c, 0x5c | track header, overall information about the track |
|   |   | edts |   |   |   | 0x000000f0 | 0x24 | edit list container |
|   |   |   | elst |   |   | 0x000000f8 | 0x1c | an edit list |
|   |   | mdia |   |   |   | 0x00000114, 0x00044bb8 | 0x44a40, 0x31de4 | container for the media information in a track |
|   |   |   | mdhd |   |   | 0x0000011c, 0x00044bc0 | 0x20, 0x20 | media header, overall information about the media |
|   |   |   | hdlr |   |   | 0x0000013c, 0x00044be0 | 0x5f, 0x5f | handler, declares the media (handler) type |
|   |   |   | minf |   |   | 0x0000019b, 0x00044c3f | 0x449b9, 0x31d5d | media information container |
|   |   |   |   | dinf |   | 0x000001a3, 0x00044c47 | 0x24, 0x24 | data information box, container |
|   |   |   |   |   | dref | 0x000001ab, 0x00044c4f | 0x1c, 0x1c | data reference box, declares source(s) of media data in track |
|   |   |   |   | stbl |   | 0x000001c7, 0x00044c6b | 0x44979, 0x31d21 | sample table box, container for the time/space map |
|   |   |   |   |   | stsd | 0x000001cf, 0x00044c73 | 0x99, 0x69 | sample descriptions (codec types, initialization etc.) |
|   |   |   |   |   | stts | 0x00000268, 0x00044cdc | 0x18, 0x18 | (decoding) time-to-sample |
|   |   |   |   |   | stsc | 0x00000280, 0x00044cf4 | 0x34, 0xc04 | sample-to-chunk, partial data-offset information |
|   |   |   |   |   | stco | 0x000002b4, 0x000458f8 | 0x25e4, 0x25e4 | chunk offset, partial data-offset information |
|   |   |   |   |   | stsz | 0x00002898, 0x00047edc | 0x1a024, 0x2eab0 | sample sizes (framing) |
|   |   |   |   |   | stss | 0x0001c8bc | 0x36c | sync sample table (random access points) |
|   |   |   |   |   | ctts | 0x0001cc28 | 0x27f18 | (composition) time to sample |
|   |   |   |   | vmhd |   | 0x00044b40 | 0x14 | video media header, overall information (video track only) |
|   |   |   |   | smhd |   | 0x0007698c | 0x10 | sound media header, overall information (sound track only) |
|   | udta |   |   |   |   | 0x0007699c | 0x75 | user-data |
| meta |   |   |   |   |   | 0x000769a4 | 0x6d | metadata |
|   | hdlr |   |   |   |   | 0x000769d1 | 0x40 | handler, declares the metadata (handler) type |
|   | ilst |   |   |   |   | 0x000769b0 | 0x21 | ??? |
| mdat |   |   |   |   |   | 0x00076a11 | 0x26e7e75 | media data container |

可以看出来，

$$ size(moov) = size(mvhd) + size(trak_1) + size(trak_2) + size(udta) + size(box) $$
$$ size(meta) = size(hdlr) + size(ilst) + size(FullBox) $$

其中，`size(box)=8`，且 `size(FullBox)=12`

对于单个 Track Box，(注意，第 2 个轨道没有 “edts”)

$$ size(trak) = size(tkhd) + size(edts) + size(mdia) + size(box) $$
$$ size(edts) = size(elst) + size(box) $$

对于单个 Media Box，

$$ size(mdia) = size(mdhd) + size(hdlr) + size(minf) + size(box) $$

对于单个 Media Information Box，(注意，第 1 个轨道和第 2 个轨道分别包含 “vmhd” 和 “smhd”)

$$ size(minf) = size(dinf) + size(stbl) + size(vmhd/smhd) + size(box) $$

对于单个 Sample Table Box，(注意，第 2 个轨道没有 “stss” 和 “ctts”)

$$ size(stbl) = size(stsd) + size(stts) + size(stsc) + size(stco) + size(stsz) + size(stss) + size(ctts) + size(box) $$

## 3 文件级 box

下面的 box 是位于文件顶层的 box，本文件示例主要包括四个：ftyp/moov/meta/mdat。

### 3.1 File Type Box, ftyp

文件开头，即地址 `0x00000000` 处，是一个 File Type Box，主要标识文件规范。

```code
aligned(8) class FileTypeBox
  extends Box(‘ftyp’) {
  unsigned int(32) major_brand;
  unsigned int(32) minor_version;
  unsigned int(32) compatible_brands[]; // to end of the box
}
```

在二进制文件文件内对应：

![ftyp box](ftyp-box.png)

- 32bit size: `0x18`，即 24 字节
- 32bit type: `0x66747970`，即 `ftyp`
- 32bit major_brand: `0x6d703432`，即 `mp42`
- 32bit minor_version: `0x00000000`
- 32bit compatible_brands[]: `0x69736f6d 6d703432`，即 `isommp42`

### 3.2 Movie Box

根据接下来的 8 个字节找到一个 Movie Box。

```code
aligned(8) class MovieBox extends Box(‘moov’){
}
```

在二进制文件文件内对应：

![moov box](moov-box.png)

- 32bit size: `0x000769f9`，即 485881 字节
- 32bit type: `0x6d6f6f76`，即 `moov`

### 3.3 Meta Box

Movie Box  中有一个 Meta Box。

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
  Box other_boxes[]; // optional
}
```

在二进制文件文件内对应：

![meta box](meta-box.png)

- 32bit size: `0x0000006d`，即 109 字节(起始地址 0x00002898)
- 32bit type: `0x6d657461`，即 `meta`
- 8bit version: `0x00`，即对应版本 0
- 24bit flags: `0x0000`
- 33 字节的 Handler Reference Box
- 64 字节的的 “ilst” box ????

### 3.4 Media Data Box

0x00076a11 处存在一个 Media Data Box。

```code
aligned(8) class MediaDataBox extends Box(‘mdat’) {
  bit(8) data[];
}
```

在二进制文件文件内对应：

![mdat box](mdat-box.png)

- 32bit size: `0x026e7e75`，即 40,795,765 字节(起始地址 0x00076a11)
- 32bit type: `0x6d646174`，即 `mdat`

之后都是 data 数据，结束地址在 0x0275e885，即文件末尾，一共有 40,795,757 个 data。

## Movie Header Box

Movie Box 首先包含一个 Movie Header Box。

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

在二进制文件文件内对应：

![mvhd box](mvhd-box.png)

- 32bit size: `0x0000006c`，即 108 字节
- 32bit type: `0x6d766864`，即 `mvhd`
- 8bit version: `0x00`，即对应版本 0
- 24bit flags: `0x000000`
- 32bit creation_time: `0xd8a8fc08`
- 32bit modification_time: `0xd8a8fc08`
- 32bit timescale: `0x00003000`
- 32bit duration: `0x00d008ea`
- 32bit rate: `0x00010000`
- 16bit volume: `0x0100`
- 16bit reserved: `0x0000`
- 32bit[2] reserved: `0x00000000` x2
- 32bit[9] matrix: `0x00010000, 0x00000000, 0x00000000, 0x00000000, 0x00010000, 0x00000000, 0x00000000, 0x00000000,0x40000000`
- 32bit[6] pre_defined: `0x00000000` x6
- 32bit next_track_ID: `0x00000003`

## Track Box

之后是一个 Track Box。

```code
aligned(8) class TrackBox extends Box(‘trak’) {
}
```

在二进制文件文件内对应：

![trak box](trak-box.png)

- 32bit size: `0x00044ac8`，即 108 字节
- 32bit type: `0x7472616b`，即 `trak`

在 0x00044b54 处又有一个 Track Box。

在二进制文件文件内对应：

![trak box2](trak-box2.png)

- 32bit size: `0x00031e48`，即 204360 字节
- 32bit type: `0x7472616b`，即 `trak`

## Track Header Box

Track Box 中首先包含一个 Track Header Box。

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

在二进制文件文件内对应：

![tkhd box](tkhd-box.png)

- 32bit size: `0x0000005c`，即 92 字节
- 32bit type: `0x746b6864`，即 `tkhd`
- 8bit version: `0x00`，即对应版本 0
- 24bit flags: `0x000003`，设置了 track_enabled 和 track_in_movie
- 32bit creation_time: `0xd8a8fc08`
- 32bit modification_time: `0xd8a8fc08`
- 32bit track_ID: `0x00000001`
- 32bit reserved: `0x00000000`
- 32bit duration: `0x00d00800`
- 32bit[2] reserved: `0x00000000` x2
- 16bit layer: `0x0000`，表示视频层，0 是正常值
- 16bit alternate_group: `0x0000`，表示和其他轨道没有关系
- 16bit volume: `0x0000`，表示非音频轨道
- 16bit reserved: `0x0000`
- 32bit[9] matrix: `0x00010000, 0x00000000, 0x00000000, 0x00000000, 0x00010000, 0x00000000, 0x00000000, 0x00000000,0x40000000`
- 32bit width: `0x05000000`
- 32bit height: `0x02d00000`

在 0x00044b5c 处又有一个 Track Header Box。

在二进制文件文件内对应：

![tkhd box2](tkhd-box2.png)

- 32bit size: `0x0000005c`，即 92 字节
- 32bit type: `0x746b6864`，即 `tkhd`
- 8bit version: `0x00`，即对应版本 0
- 24bit flags: `0x000003`，设置了 track_enabled 和 track_in_movie
- 32bit creation_time: `0xd8a8fc08`
- 32bit modification_time: `0xd8a8fc08`
- 32bit track_ID: `0x00000002`
- 32bit reserved: `0x00000000`
- 32bit duration: `0x00d008ea`
- 32bit[2] reserved: `0x00000000` x2
- 16bit layer: `0x0000`
- 16bit alternate_group: `0x0000`，表示和其他轨道没有关系
- 16bit volume: `0x0100`，表示音频轨道，全音量
- 16bit reserved: `0x0000`
- 32bit[9] matrix: `0x00010000, 0x00000000, 0x00000000, 0x00000000, 0x00010000, 0x00000000, 0x00000000, 0x00000000,0x40000000`
- 32bit width: `0x00000000`
- 32bit height: `0x00000000`

## Edit Box

Track Header Box 中包含一个 Edit Box。

```code
aligned(8) class EditBox extends Box(‘edts’) {
}
```

在二进制文件文件内对应：

![edts box](edts-box.png)

- 32bit size: `0x00000024`，即 36 字节
- 32bit type: `0x65647473`，即 `edts`

## Edit List Box

Edit Box 中包含一个 Edit List Box。

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

在二进制文件文件内对应：

![elst box](elst-box.png)

- 32bit size: `0x0000001c`，即 28 字节
- 32bit type: `0x656c7374`，即 `elst`
- 8bit version: `0x00`，即对应版本 0
- 24bit flags: `0x000000`
- 32bit entry_count: `0x00000001`，表示列表中只有一个条目
  - 条目 1
    - 32bit segment_duration: `0xd0080000`
    - 32bit media_time: `0x00000200`
- 16bit media_rate_integer: `0x0001`
- 16bit media_rate_fraction: `0x0000`

## Media Box

接下来在 Track Box 中找到一个 Media Box。

```code
aligned(8) class MediaBox extends Box(‘mdia’) {
}
```

在二进制文件文件内对应：

![mdia box](mdia-box.png)

- 32bit size: `0x00044a40`，即 281152 字节
- 32bit type: `0x6d646961`，即 `mdia`

在 0x00044bb8 处又有一个 Media Box。

在二进制文件文件内对应：

![mdia box2](mdia-box2.png)

- 32bit size: `0x00031de4`，即 204260 字节
- 32bit type: `0x6d646961`，即 `mdia`

## Media Header Box

Media Box 首先包含一个 Media Header Box。

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

在二进制文件文件内对应：

![mdhd box](mdhd-box.png)

- 32bit size: `0x00000020`，即 32 字节
- 32bit type: `0x6d646864`，即 `mdhd`
- 8bit version: `0x00`，即对应版本 0
- 24bit flags: `0x000000`
- 32bit creation_time: `0xd8a8fc08`
- 32bit modification_time: `0xd8a8fc08`
- 32bit timescale: `0x00003000`
- 32bit duration: `0x00d00800`
- 1bit pad: `0x0`
- 5bit[3] language: `0x15 0xe 0x4`
- 16bit pre_defined: `0x0000`

在 0x00044bb8 处又有一个 Media Box。

在二进制文件文件内对应：

![mdhd box2](mdhd-box2.png)

- 32bit size: `0x00000020`，即 32 字节
- 32bit type: `0x6d646864`，即 `mdhd`
- 8bit version: `0x00`，即对应版本 0
- 24bit flags: `0x000000`
- 32bit creation_time: `0xd8a8fc08`
- 32bit modification_time: `0xd8a8fc08`
- 32bit timescale: `0x0000ac44`，即 44100
- 32bit duration: `0x02ea9c00`，即 48,929,792
- 1bit pad: `0x0`
- 5bit[3] language: `0x5 0xe 0x7`
- 16bit pre_defined: `0x0000`

## Handler Reference Box

Media Header Box 后面有一个 Handler Reference Box。

```code
aligned(8) class HandlerBox extends FullBox(‘hdlr’, version = 0, 0) {
  unsigned int(32) pre_defined = 0;
  unsigned int(32) handler_type;
  const unsigned int(32)[3] reserved = 0;
  string name;
}
```

在二进制文件文件内对应：

![hdlr box](hdlr-box.png)

- 32bit size: `00000005f`，即 95 字节
- 32bit type: `0x68646c72`，即 `hdlr`
- 8bit version: `0x00`，即对应版本 0
- 24bit flags: `0x000000`
- 32bit pre_defined: `0x00000000`
- 32bit handler_type: `0x76696465`，即 `vide`
- 32bit[3] reserved: `0x00000000` x3
- string name: 剩余 63 字节

在 0x00044be0 处又有一个 Handler Reference Box。

在二进制文件文件内对应：

![hdlr box2](hdlr-box2.png)

- 32bit size: `00000005f`，即 95 字节
- 32bit type: `0x68646c72`，即 `hdlr`
- 8bit version: `0x00`，即对应版本 0
- 24bit flags: `0x000000`
- 32bit pre_defined: `0x00000000`
- 32bit handler_type: `0x736f746e`，即 `soun`
- 32bit[3] reserved: `0x00000000` x3
- string name: 剩余 63 字节

在 0x000769b0 处又有一个 Handler Reference Box。

在二进制文件文件内对应：

![hdlr box3](hdlr-box3.png)

- 32bit size: `000000021`，即 33 字节
- 32bit type: `0x68646c72`，即 `hdlr`
- 8bit version: `0x00`，即对应版本 0
- 24bit flags: `0x000000`
- 32bit pre_defined: `0x00000000`
- 32bit handler_type: `0x6d646972`，即 `mdir`
- 32bit[3] reserved: `0x6170706c, 0x00000000, 0x00000000`
- string name: 剩余 1 字节，为 0x00

## Media Information Box

Handler Reference Box 后面有一个 Media Information Box。

```code
aligned(8) class MediaInformationBox extends Box(‘minf’) {
} 
```

在二进制文件文件内对应：

![minf box](minf-box.png)

- 32bit size: `0x000449b9`，即 281017 字节
- 32bit type: `0x6d696e66`，即 `minf`

在 0x00044c3f 处又有一个 Media Information Box。

在二进制文件文件内对应：

![minf box2](minf-box2.png)

- 32bit size: `0x00031d5d`，即 204,125 字节
- 32bit type: `0x6d696e66`，即 `minf`

## Data Information Box

Media Information Box 中包含一个 Data Information Box。

```code
aligned(8) class DataInformationBox extends Box(‘dinf’) {
}
```

在二进制文件文件内对应：

![dinf box](dinf-box.png)

- 32bit size: `0x00000024`，即 36 字节
- 32bit type: `0x64696e66`，即 `dinf`

Data Information Box 中包含一个 Data Reference Box。

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

在二进制文件文件内对应：

![dref box](dref-box.png)

- 32bit size: `0x0000001c`，即 28 字节
- 32bit type: `0x64726566`，即 `dref`
- 8bit version: `0x00`，即对应版本 0
- 24bit flags: `0x000000`
- 32bit entry_count: `0x00000001`，表示下表只有一个条目
  - 条目 1
    - 32bit size: `0x0000000c`，即 12 字节
    - 32bit type: `0x75726c20`，即 `url`
    - 8bit version: `0x00`，即对应版本 0
    - 24bit flags: `0x000001`
    - string location: 剩余 0 个字节

在 0x00044c47 处又有一个 Data Information Box。其中包含一个 Data Reference Box。

在二进制文件文件内对应：

![dinf box2](dinf-box2.png)

- 32bit size: `0x00000024`，即 36 字节
- 32bit type: `0x64696e66`，即 `dinf`

![dref box2](dref-box2.png)

- 32bit size: `0x0000001c`，即 28 字节
- 32bit type: `0x64726566`，即 `dref`
- 8bit version: `0x00`，即对应版本 0
- 24bit flags: `0x000000`
- 32bit entry_count: `0x00000001`，表示下表只有一个条目
  - 条目 1
    - 32bit size: `0x0000000c`，即 12 字节
    - 32bit type: `0x75726c20`，即 `url`
    - 8bit version: `0x00`，即对应版本 0
    - 24bit flags: `0x000001`
    - string location: 剩余 0 个字节

## Sample Table Box

Media Information Box 中又找到一个 Sample Table Box。

```code
aligned(8) class SampleTableBox extends Box(‘stbl’) {
}
```

在二进制文件文件内对应：

![stbl box](stbl-box.png)

- 32bit size: `0x00044979`，即 281017 字节
- 32bit type: `0x7374626c`，即 `stbl`

在 0x00044c6b 处又有一个 Sample Table Box。

在二进制文件文件内对应：

![stbl box2](stbl-box2.png)

- 32bit size: `0x00031d21`，即 204,065 字节
- 32bit type: `0x7374626c`，即 `stbl`

## Sample Description Box

Sample Table Box 中找到一个 Sample Description Box。

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

在二进制文件文件内对应：

![stsd box](stsd-box.png)

- 32bit size: `0x00000099`，即 153 字节 (起始地址 0x000001cf)
- 32bit type: `0x73747364`，即 `stsd`
- 8bit version: `0x00`，即对应版本 0
- 24bit flags: `0x000000`
- 32bit entry_count: `0x00000001`，表示下表有一个条目
  - 条目 1
    - 32bit size: `0x00000089`，即 137 字节
    - 32bit type: `0x61766331`，即 `avc1` (起始地址)

- avc1???

box 结束地址是 0x00000267。

在 0x00044c73 处又有一个 Sample Description Box。

在二进制文件文件内对应：

![stsd box2](stsd-box2.png)

- 32bit size: `0x00000069`，即 105 字节
- 32bit type: `0x73747364`，即 `stsd`
- 8bit version: `0x00`，即对应版本 0
- 24bit flags: `0x000000`
- 32bit entry_count: `0x00000001`，表示下表有一个条目
  - 条目 1
    - 32bit size: `0x00000059`，即 89 字节
    - 32bit type: `0x6d703461`，即 `mp4a`

- mp4a???

box 结束地址是 0x00044cdb。

## Decoding Time to Sample Box

Sample Table Box 中找到一个 Decoding Time to Sample Box。

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

在二进制文件文件内对应：

![stts box](stts-box.png)

- 32bit size: `0x00000018`，即 24 字节
- 32bit type: `0x73747473`，即 `stts`
- 8bit version: `0x00`，即对应版本 0
- 24bit flags: `0x000000`
- 32bit entry_count: `0x00000001`，表示下表只有一个条目
  - 条目 1
    - 32bit sample_count: `0x00006804`，表示有 26628 个采样
    - 32bit sample_delta: `0x00000200`

在 0x00044cdc 处又有一个 Decoding Time to Sample Box。

在二进制文件文件内对应：

![stts box2](stts-box2.png)

- 32bit size: `0x00000018`，即 24 字节
- 32bit type: `0x73747473`，即 `stts`
- 8bit version: `0x00`，即对应版本 0
- 24bit flags: `0x000000`
- 32bit entry_count: `0x00000001`，表示下表只有一个条目
  - 条目 1
    - 32bit sample_count: `0x0000baa7`，表示有 47,783 个采样
    - 32bit sample_delta: `0x00000400`

## Sample To Chunk Box

Sample Table Box 中找到一个 Sample To Chunk Box。

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

在二进制文件文件内对应：

![stsc box](stsc-box.png)

- 32bit size: `0x00000034`，即 52 字节
- 32bit type: `0x73747363`，即 `stsc`
- 8bit version: `0x00`，即对应版本 0
- 24bit flags: `0x000000`
- 32bit entry_count: `0x00000003`，表示下表有 3 个条目
  - 条目 1
    - 32bit first_chunk: `0x00000001`
    - 32bit samples_per_chunk: `0x0000000c`，表示每个块有 12 个采样
    - 32bit sample_description_index: `0x00000001`
  - 条目 2
    - 32bit first_chunk: `0x00000006`
    - 32bit samples_per_chunk: `0x0000000b`，表示每个块有 11 个采样
    - 32bit sample_description_index: `0x00000001`
  - 条目 3
    - 32bit first_chunk: `0x00000975`
    - 32bit samples_per_chunk: `0x00000003`，表示每个块有 3 个采样
    - 32bit sample_description_index: `0x00000001`

在 0x00044cf4 处又有一个 Sample To Chunk Box。

在二进制文件文件内对应：

![stsc box2](stsc-box2.png)

- 32bit size: `0x00000c04`，即 3076 字节
- 32bit type: `0x73747363`，即 `stsc`
- 8bit version: `0x00`，即对应版本 0
- 24bit flags: `0x000000`
- 32bit entry_count: `0x000000ff`，表示下表有 255 个条目
  - 条目 1
    - 32bit first_chunk: `0x00000001`
    - 32bit samples_per_chunk: `0x00000015`，表示每个块有 21 个采样
    - 32bit sample_description_index: `0x00000001`
  - 条目 2
    - 32bit first_chunk: `0x0000000b`
    - 32bit samples_per_chunk: `0x00000014`，表示每个块有 20 个采样
    - 32bit sample_description_index: `0x00000001`
  - 条目 3
    - 32bit first_chunk: `0x0000000c`
    - 32bit samples_per_chunk: `0x00000013`，表示每个块有 19 个采样
    - 32bit sample_description_index: `0x00000001`
  - ......
  - 条目 255
    - 32bit first_chunk: `0x00000975`
    - 32bit samples_per_chunk: `0x00000003`，表示每个块有 3 个采样
    - 32bit sample_description_index: `0x00000001` (地址 0x000458f7)

## Chunk Offset Box

Sample Table Box 中找到一个 Chunk Offset Box。

```code
aligned(8) class ChunkOffsetBox
  extends FullBox(‘stco’, version = 0, 0) {
  unsigned int(32) entry_count;
  for (i=1; i u entry_count; i++) {
    unsigned int(32) chunk_offset;
  }
}
```

在二进制文件文件内对应：

![stco box](stco-box.png)

- 32bit size: `0x000025e4`，即 9700 字节(起始地址 0x000002b4)
- 32bit type: `0x7374636f`，即 `stco`
- 8bit version: `0x00`，即对应版本 0
- 24bit flags: `0x000000`
- 32bit entry_count: `0x00000975`，表示下表有 2421 个条目
  - 条目 1
    - 32bit chunk_offset: `0x00076a19`
  - 条目 2
    - 32bit chunk_offset: `0x00078b5e`
  - 条目 3
    - 32bit chunk_offset: `0x0007abc0`
  - ......
  - 条目 2421
    - 32bit chunk_offset: `0x0275e3ba` (地址 0x00002897)

在 0x000458f8 处又有一个 Chunk Offset Box。

在二进制文件文件内对应：

![stco box2](stco-box2.png)

- 32bit size: `0x000025e4`，即 9700 字节(起始地址 0x000458f8)
- 32bit type: `0x7374636f`，即 `stco`
- 8bit version: `0x00`，即对应版本 0
- 24bit flags: `0x000000`
- 32bit entry_count: `0x00000975`，表示下表有 2421 个条目
  - 条目 1
    - 32bit chunk_offset: `0x00076ce5`
  - 条目 2
    - 32bit chunk_offset: `0x00078d46`
  - 条目 3
    - 32bit chunk_offset: `0x0007ada8`
  - ......
  - 条目 2421
    - 32bit chunk_offset: `0x0275e42b` (地址 0x000047edb)

## Sample Size Box

Sample Table Box 中找到一个 Sample Size Box。

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

在二进制文件文件内对应：

![stsz box](stsz-box.png)

- 32bit size: `0x0001a024`，即 106532 字节(起始地址 0x00002898)
- 32bit type: `0x7374737a`，即 `stsz`
- 8bit version: `0x00`，即对应版本 0
- 24bit flags: `0x000000`
- 32bit sample_size: `0x00000000`，表示采样大小不相同
- 32bit sample_count: `0x00006804`，表示下表有 26628 个条目
  - 条目 1
    - 32bit entry_size: `0x00000110`，即 272 字节
  - 条目 2
    - 32bit entry_size: `0x00000029`，即 41 字节
  - 条目 3
    - 32bit entry_size: `0x00000026`，即 38 字节
  - ...
  - 条目 1
    - 32bit entry_size: `0x00000025`，即 67 字节 (地址 0x0001c8bb)

在 0x000047edc 处又有一个 Chunk Offset Box。

在二进制文件文件内对应：

![stsz box2](stsz-box2.png)

- 32bit size: `0x0002eab0`，即 191,152 字节(起始地址 0x00002898)
- 32bit type: `0x7374737a`，即 `stsz`
- 8bit version: `0x00`，即对应版本 0
- 24bit flags: `0x000000`
- 32bit sample_size: `0x00000000`，表示采样大小不相同
- 32bit sample_count: `0x0000baa7`，表示下表有 47,783 个条目
  - 条目 1
    - 32bit entry_size: `0x00000173`，即 371 字节
  - 条目 2
    - 32bit entry_size: `0x00000174`，即 372 字节
  - 条目 3
    - 32bit entry_size: `0x00000173`，即 371 字节
  - ...
  - 条目 1
    - 32bit entry_size: `0x00000174`，即 372 字节 (地址 0x0007698b)

## Sync Sample Box

Sample Table Box 中找到一个 Sync Sample Box。

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

在二进制文件文件内对应：

![stss box](stss-box.png)

- 32bit size: `0x0000036c`，即 876 字节(起始地址 0x0001c8bc)
- 32bit type: `0x73747373`，即 `stss`
- 8bit version: `0x00`，即对应版本 0
- 24bit flags: `0x000000`
- 32bit entry_count: `0x000000d7`，表示下表有 215 个条目
  - 条目 1
    - 32bit sample_number: `0x00000001`，即采样编号为 1
  - 条目 2
    - 32bit sample_number: `0x00000081`，即采样编号为 129
  - 条目 3
    - 32bit sample_number: `0x00000101`，即采样编号为 257
  - ...
  - 条目 1
    - 32bit sample_number: `0x00006801`，即采样编号为 26625 (地址 0x0001cc27)

## Composition Time to Sample Box

Sample Table Box 中找到一个 Composition Time to Sample Box。

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

在二进制文件文件内对应：

![ctts box](ctts-box.png)

- 32bit size: `0x00027f18`，即 163608 字节(起始地址 0x0001cc28)
- 32bit type: `0x63747473`，即 `ctts`
- 8bit version: `0x00`，即对应版本 0
- 24bit flags: `0x000000`
- 32bit entry_count: `0x00004fe1`，表示下表有 20449 个条目
  - 条目 1
    - 32bit sample_count: `0x00000001`，即采样数为 1
    - 32bit sample_offset: `0x00000200`，即 CT 和 DT 的偏移量为 512
  - 条目 2
    - 32bit sample_count: `0x00000001`，即采样数为 1
    - 32bit sample_offset: `0x00000600`，即 CT 和 DT 的偏移量为 1536
  - 条目 3
    - 32bit sample_count: `0x00000002`，即采样数为 2
    - 32bit sample_offset: `0x00000000`，即 CT 和 DT 的偏移量为 0
  - ...
  - 条目 1
    - 32bit sample_count: `0x00000001`，即采样数为 1
    - 32bit sample_offset: `0x00000600`，即 CT 和 DT 的偏移量为 1536 (地址 0x00044B3f)

## Video Media Header Box

Media Information Box 中有一个 Video Media Header Box。

```code
aligned(8) class VideoMediaHeaderBox
  extends FullBox(‘vmhd’, version = 0, 1) {
  template unsigned int(16) graphicsmode = 0; // copy, see below
  template unsigned int(16)[3] opcolor = {0, 0, 0};
}
```

在二进制文件文件内对应：

![vmhd box](vmhd-box.png)

- 32bit size: `0x00000014`，即 20 字节(起始地址 0x00044B40)
- 32bit type: `0x766d6864`，即 `vmhd`
- 8bit version: `0x00`，即对应版本 0
- 24bit flags: `0x000001`
- 16bit graphicsmode: `0x0000`
- 16bit[3] opcolor: `0x0000` x3

## Sound Media Header Box

0x0007698c 处有一个 Sound Media Header Box。

```code
aligned(8) class SoundMediaHeaderBox
  extends FullBox(‘smhd’, version = 0, 0) {
  template int(16) balance = 0;
  const unsigned int(16) reserved = 0;
}
```

在二进制文件文件内对应：

![smhd box](smhd-box.png)

- 32bit size: `0x00000010`，即 16 字节(起始地址 0x0007698c)
- 32bit type: `0x766d6864`，即 `smhd`
- 8bit version: `0x00`，即对应版本 0
- 24bit flags: `0x0000`
- 16bit balance: `0x0000`
- 16bit reserved: `0x0000`

## User Data Box

Movie Box  中有一个 User Data Box。

```code
aligned(8) class UserDataBox extends Box(‘udta’) {
}
```

在二进制文件文件内对应：

![udta box](udta-box.png)

- 32bit size: `0x00000075`，即 117 字节(起始地址 0x00002898)
- 32bit type: `0x75647461`，即 `udta`


