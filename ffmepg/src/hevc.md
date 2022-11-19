# HEVC 视频解码器

- [HEVC 视频解码器](#hevc-视频解码器)
  - [结构体](#结构体)
    - [ff_hevc_parser](#ff_hevc_parser)
      - [hevc_parse](#hevc_parse)
    - [ff_hevc_decoder](#ff_hevc_decoder)
      - [hevc_decode_init](#hevc_decode_init)
      - [hevc_decode_frame](#hevc_decode_frame)

## 结构体

和 HEVC 解码器相关的结构体主要是 `ff_hevc_parser` 和 `ff_hevc_decoder`。

### ff_hevc_parser

- 在 `libavcodec/hevc_parser.c` 定义
- 功能：解析 HEVC 码流。几个重要的函数说明如下

```c
// 解析 hevc 码流：首先解析 extradata(开始只解析一次)，然后查找
static int hevc_parse(AVCodecParserContext *s, AVCodecContext *avctx,
                      const uint8_t **poutbuf, int *poutbuf_size,
                      const uint8_t *buf, int buf_size)

// 分析流开头的参数集，判断是否存在 vps/sps/pps
static int hevc_split(AVCodecContext *avctx, const uint8_t *buf, int buf_size)

// 关闭 hevc 解析器
static void hevc_parser_close(AVCodecParserContext *s)
```

#### hevc_parse

`hevc_parse` 函数的流程：

- 如果存在且未解析过 extradata，调用 `ff_hevc_decode_extradata` 解析其中的 vps/sps/pps 等信息
- 调用 `hevc_find_frame_end` 查找比特流中当前包的结尾，`hevc_find_frame_end` 返回下一包第一个字节的位置，或者返回 `END_NOT_FOUND`
- 调用 `parse_nal_units` 将上面找到的包分割成 NAL 单元进行解析，根据 NAL 单元类型调用对应的解析函数(`ff_hevc_decode_nal_vps`/`ff_hevc_decode_nal_sps`/`ff_hevc_decode_nal_pps`/`ff_hevc_decode_nal_sei`/`hevc_parse_slice_header`)

### ff_hevc_decoder

- 在 `libavcodec/hevcdec.c` 定义
- 功能：解码 HEVC 码流。几个重要的函数说明如下

```c
// 初始化 hevc 解码器
static av_cold int hevc_decode_init(AVCodecContext *avctx)

//  关闭 hevc 解码器，释放所有内存
static av_cold int hevc_decode_free(AVCodecContext *avctx)

// 解码 hevc 码流
static int hevc_decode_frame(AVCodecContext *avctx, void *data, int *got_output,
                             AVPacket *avpkt)

// 刷新 hevc 解码器，包括丢弃 DPB 中所有现有帧
static void hevc_decode_flush(AVCodecContext *avctx)
```

#### hevc_decode_init

`hevc_decode_init` 函数的流程：

- 调用 `hevc_init_context` 初始化 hevc 解码器上下文
- 调用 `hevc_decode_extradata` 解码 AVCodecContext 中的 extradata，并从第一个 sps 导出流参数

#### hevc_decode_frame

`hevc_decode_frame` 函数的流程：

- `ff_hevc_output_frame`：按输出顺序找到下一帧，并在 DPB 的 HEVCFrame 结构中建立对找到帧的引用
- `av_packet_get_side_data`：获取包的辅助数据，并调用 `hevc_decode_extradata` 解码辅助数据
- `decode_nal_units`：解析 NAL 单元
  - `ff_h2645_packet_split`：将输入包分割成 NAL 单元，获取数据包中的 slice 数目上限
  - `decode_nal_unit`：解析找到的所有 NAL 单元：根据 NAL 单元类型调用对应的解析函数(`ff_hevc_decode_nal_vps`/`ff_hevc_decode_nal_sps`/`ff_hevc_decode_nal_pps`/`ff_hevc_decode_nal_sei`)。切片的解析步骤包括
    - `hls_slice_header`：解析切片头
    - `hevc_frame_start`：解析帧，为当前帧构建参考图片列表
    - `ff_hevc_slice_rpl`：为当前切片构建参考图片列表
    - `hls_slice_data`/`hls_slice_data_wpp`：解析切片数据

`hls_slice_header` 中主要的函数说明：

- 判断是 IDR，则调用 `ff_hevc_clear_refs` 将 DPB 中所有帧标记为“不用于参考”

`hls_slice_data`/`hls_slice_data_wpp` 中主要是调用 `AVCodecContext.execute` 函数接口，传入 `hls_decode_entry` 实现多线程解码。`hls_decode_entry` 是 hevc 解码器主要的解码函数，其中调用解码和滤波函数

- 解码函数 `hls_coding_quadtree`：对 CTU 进行解码，解析 hevc 码流的四叉树结构，内部递归调用
  - `hls_coding_unit`：解码 CU
    - `hls_prediction_unit`：处理 PU
      - `luma_mc_uni`/`chroma_mc_uni`：亮度/色度采样单向插值处理
      - `luma_mc_bi`/`chroma_mc_bi`：亮度/色度采样双向插值处理
    - `hls_transform_tree`：处理 TU，解析 TU 的四叉树结构，内部递归调用
      - `hls_transform_unit`：处理单个 TU
- 滤波函数 `ff_hevc_hls_filters`：调用 `ff_hevc_hls_filter` 对解码后的数据进行滤波处理
  - `deblocking_filter_CTB`：去方块滤波去除解码过程中的块效应
  - `sao_filter_CTB`：采样自适应补偿去除解码过程中的振铃效应
