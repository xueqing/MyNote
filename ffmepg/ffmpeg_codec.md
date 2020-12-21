# ffmpeg 的编解码

- [ffmpeg 的编解码](#ffmpeg-的编解码)
  - [libavcodec 库](#libavcodec-库)
    - [编解码流程](#编解码流程)
    - [数据结构](#数据结构)
      - [AVPacket](#avpacket)
      - [AVFrame](#avframe)
    - [解码 API](#解码-api)
      - [avcodec_send_packet](#avcodec_send_packet)
      - [avcodec_receive_frame](#avcodec_receive_frame)
    - [编码 API](#编码-api)
      - [avcodec_send_frame](#avcodec_send_frame)
      - [avcodec_receive_packet](#avcodec_receive_packet)

内容主要来自整理翻译源码。

## libavcodec 库

### 编解码流程

`avcodec_send_packet()`/`avcodec_receive_frame()`/`avcodec_send_frame()`/`avcodec_receive_packet()` 函数提供编码/解码 API，将输入和输出解耦。

这些 API 对于编解码以及音视频非常相似，如下方式工作：

- 设置和打开 `AVCodecContext`
- 发送有效的输入：
  - 对于解码，调用 `avcodec_send_packet()` 给解码器一个包含原始压缩数据的 `AVPacket`
  - 对于编码，调用 `avcodec_send_frame()` 给编码器一个包含未压缩音频或视频的 `AVFrame`
  - 两种情形中，建议 `AVPacket` 和 `AVFrame` 都是引用计数的，否则 libavcodec 可能需要拷贝输入数据。(libavformat 总是返回引用计数的 `AVPacket`，且 `av_frame_get_buffer()` 分配引用计数的 `AVFrame`)
- 在一个循环中接收输出。定期调用其中一个 `avcodec_receive_*()` 函数并处理它们的输出：
  - 对于解码，调用 `avcodec_receive_frame()`。如果成功，返回一个包含未压缩的音频或视频数据的 `AVFrame`
  - 对于解码，调用 `avcodec_receive_packet()`。如果成功，返回一个包含一个压缩帧的 `AVPacket`
  - 重复调用 `avcodec_receive_*()` 直到返回 `AVERROR(EAGAIN)` 或一个错误。`AVERROR(EAGAIN)` 返回值表示返回新的输出要求新的输入数据。在这种情况下，继续发送数据。对于每个输入的帧/包，编解码器一般会返回一个输出的帧/包，但是也可以返回 0 个或多于 1 个输出的帧/包

解码或编码一开始，编解码器可以接收多个输入帧/包而不用返回一个帧，直到填充其内部缓存。这种情形可以按照上述步骤透明地处理。

理论上。发送输入可以导致 `EAGAIN`——并未接收所有输出才会出现。使用者可使用这个返回值构造不同于上述建议的解码或编码循环。比如，可以尝试在每次迭代发送一个新的输入，当返回 `EAGAIN` 时尝试接收输出。

流结束的情形。因为解码器可能出于性能或必要性(考虑 B 帧)在内部缓存多个帧或包，因此需要刷新(即耗尽)编解码器。按照下面的步骤处理：

- 取而代之有效的输入，发送 `NULL` 给 `avcodec_send_packet()`(解码器)或 `avcodec_send_frame()`(编码器)函数。这会进入耗尽模式
- 在一个循环中调用 `avcodec_receive_frame()`(解码器)或 `avcodec_receive_packet()`(编码器)，直到返回 `AVERROR_EOF`。这个函数不会返回 `AVERROR(EAGAIN)`，除非你忘记进入耗尽模式
- 在重新恢复解码之前，必须使用 `avcodec_flush_buffers()` 重置编解码器

强烈建议使用上述 API。但是也可以在这些严格的模式之外调用函数。比如，可以重复调用 `avcodec_send_packet()` 而不调用 `avcodec_receive_frame()`。在这种情况下，`avcodec_send_packet()` 会一直成功之道编解码器内部的缓存填充满(一般在初始输入后，每个输出帧大小是 1)，然后使用 `AVERROR(EAGAIN)` 拒绝输入。一旦开始拒绝输入，只能读取一些输出。

并非所有编解码器会遵循严格且可预测的数据流；唯一的保证是，在一端调用发送/接收调用上的 `AVERROR(EAGAIN)` 返回值意味着另一端的接收/发送调用会成功，或者至少不会因为 `AVERROR(EAGAIN)` 失败。一般来说，没有编解码器允许无限缓存输入或输出。

### 数据结构

#### AVPacket

- 在 `libavcodec/avcodec.h` 定义
- 功能：结构体存储研所的数据。通常由解复用器导出，然后作为输入传递给解码器，或作为编码器的输出被接收，然后传递给复用器。

对于视频，通常包含一个压缩帧。对于音频可能包含多个压缩帧。解码器允许输出不带压缩数据的空包，只包含附带数据(side data)(比如，在解码最后用于更新一些流参数)。

`AVPacket` 是 ffmpeg 中少数的结构体，这些结构体的大小是公共 ABI 的一部分。因此，可以在栈上分配，且如果 `libavcodec` 和 `libavformat` 没有大的版本更新，不能添加新字段到 `AVPacket`。

数据所有权的语义取决于 `buf` 字段。如果设置了，包数据是动态分配的，且一直有效直到调用 `av_packet_unref()` 将其引用计数减为 0.

如果 `buf` 字段未设置，`av_packet_ref()` 会创建一份拷贝而不是增加其引用计数。

附带数据(side data)总是使用 `av_malloc()` 分配，通过 `av_packet_ref()` 拷贝，通过 `av_packet_unref()` 释放。

#### AVFrame

- 在 `libavutil/frame.h` 定义
- 功能：结构体描述了解码的(原始)音频或视频数据。

`AVFrame` 必须使用 `av_frame_alloc()` 分配。注意这个函数值分配 `AVFrame` 本身，`data` 缓存必须通过其他方式管理(参阅下面)。必须使用 `av_frame_free()` 释放。

`AVFrame` 通常只分配一次，然后被重复使用多次以持有不同的数据(比如，一个 `AVFrame` 保存从一个解码器接收的帧)。在这种情况下，`av_frame_unref()` 会释放该帧持有的引用，并在重用该帧之前将其重置为原始的干净状态。

`AVFrame` 描述的数据通常通过 `AVBuffer` 的 API 引用计数。底层的缓存结束保存在 `AVFrame.buf`/`AVFrame.extended_buf`。一个 `AVFrame` 至少设置了一个引用则将其视为引用计数，比如，如果 `AVFrame.buf[0] != NULL`。在这种情况下，每个单个数据平面必须包含在 `AVFrame.buf` 或 `AVFrame.extended_buf` 中的一个缓冲区。所有数据可能只有一个缓冲区，或者每个平面可能有一个单独的缓冲区，或介于两者之间。

`sizeof(AVFrame)` 不是公共 ABI 的一部分，因此可以在末尾添加新字段，并有较小的更新。

可以通过使用 `AVOptions` 访问字段，使用的名称字符串和通过 `AVOptions` 访问的 C 结构字段名称匹配。`AVFrame` 的 `AVClass` 可通过 `avcodec_get_frame_class()` 获取。

### 解码 API

- `avcodec_send_packet` 使用时，需要按照 dts 递增的顺序传递编码的数据包 `AVPacket` 给解码器，解码器按照 pts 递增的顺序输出原始帧 `AVFrame`。解码器并不需要数据包的 dts，只是按照顺序缓存和解码收到的包
- `avcodec_receive_frame` 输出原始帧之前，会设置好 `AVFrame.best_effort_timestamp`，通常也会设置 `AVFrame.pts`(通常直接拷贝自对应数据包的 pts)，因此用户需要保证发送给解码器的数据包的有正确的 pts。数据包和原始帧之间通过 pts 对应
- `avcodec_receive_frame` 输出帧时，`AVFrame.pkt_dts` 拷贝自触发返回此帧的 `AVPacket`(如果未使用帧线程)。如果 `AVPacket` 没有 pts，这也是根据 `AVPacket` 的 dts 计算的此帧的 pts。如果当前包是刷新包，解码器有缓存帧，进入刷新模式，当前及剩余的帧并不是由当前输入的包解码得到的，因此这些帧的 pkt_dts 总是 `AV_NOPTS_VALUE`，没有实际意义
- `avcodec_send_packet` 多次发送 `NULL` 数据包并不会丢弃解码器中缓存的帧，使用 `avcodec_flush_buffers()` 可立即丢掉解码器中缓存的帧。因此播放结束时应调用 `avcodec_send_packet(NULL)` 取出解码器缓存的帧，而 seek 或切换流时应调用 `avcodec_flush_buffers()` 丢弃缓存的帧
- 刷新解码器的一般操作：调用一次 `avcodec_send_packet(NULL)`(返回成功)，之后循环调用 `avcodec_receive_frame` 直至其返回 `AVERROR_EOF`。最后一次只获取到结束标志，并没有返回有效帧

#### avcodec_send_packet

- 函数原型 `int avcodec_send_packet(AVCodecContext *avctx, const AVPacket *avpkt);`
- 功能：提供原始的包数据作为编码器的输入。
  - 在内部，调用函数会复制相关的 `AVCodecContext` 字段，这些字段会影响对每包的解码，并在实际解码时应用它们。(比如，`AVCodecContext.skip_frame` 可能指导解码器丢弃此函数发送的包包含的帧。
  - **警告**：输入缓冲区 `avpkt->data` 必须是 `AV_INPUT_BUFFER_PADDING_SIZE`，比实际读取的字节数大，因为一些优化的比特流读取器一次读取 32 或 64 比特，并且可能读完所有内容。
  - **警告**：不要在相同的 `AVCodecContext` 将此 API 和传统的 API (像 `avcodec_decode_video2()`) 混用。当前或者将来的 libavcodec 版本会返回未预期的结果。
  - **注意**：在反馈包给解码器之前，必须已经使用 `avcodec_open2()` 打开 `AVCodecContext`。
- 参数 `avctx`: 编解码上下文。
- 参数(输入) `avpkt`: 输入的 `AVPacket`。通常，它是一个单独的视频帧，或几个完整的音频帧。该包的所有权由调用者保留，且解码器不会写入包。解码器可能创建对该包数据的一个引用(或拷贝包数据，如果包没有引用计数的话)。
  - 跟旧的 API 不同，该数据包总是被完全消费，并且如果它包含多个帧(比如一些音频编解码器)，要求此后多次调用 `avcodec_receive_frame()` 才能发送新的数据包。
  - 该参数可以是 `NULL`(或将一个 `AVPacket` 的 `data` 设置为 `NULL`，`size` 设置为 0)；在这种情况下，将其视为刷新数据包，它标识流的结束。
  - 发送一个刷新数据包会返回成功。后续的刷新数据包是非必须的，而且会返回 `AVERROR_EOF`。如果解码器仍有缓存的帧，在发送刷新数据包后解码器会返回这些缓存的帧。
- 返回值：0 表示成功，否则是负的错误码
  - `AVERROR(EAGAIN)`: 输入在当前状态是不可接受的——用户必须使用 `avcodec_receive_frame()` 读取输出(一旦读取所有输出，应该重发此包，且这个调用不会返回 `EAGAIN` 错误)
    - 当 `avcodec_send_packet` 和 `avcodec_receive_frame` 在两个单独的循环中调用时，可能出现此情况
  - `AVERROR_EOF`: 解码器已经刷新。且不能发送新包到解码器(当发送多于 1 个刷新包也会返回)
  - `AVERROR(EINVAL)`: 未打开编解码器，这是一个解码器，或要求刷新
  - `AVERROR(ENOMEM)`: 无法将数据包添加到内部队列，或类似的
  - 其他错误：合理的解码错误

#### avcodec_receive_frame

- 函数原型 `int avcodec_receive_frame(AVCodecContext *avctx, AVFrame *frame);`
- 功能：返回来自解码器的解码的输出数据。
- 参数 `avctx`: 编解码上下文。
- 参数 `frame`: 将设置为解码器分配的引用计数的视频或音频帧(取决于解码器类型)。注意在执行其他任何操作之前，该函数始终调用 `av_frame_unref(frame)`。
- 返回值：
  - 0: 成功，返回一个帧
  - `AVERROR(EAGAIN)`: 输出在当前状态不可用——用户必须尝试发送新的输入
  - `AVERROR_EOF`: 编码器已经完全刷新，且不会再有更多输出帧
  - `AVERROR(EINVAL)`: 未打开编解码器，或这是一个编码器
  - 其他负值：合理的解码错误

### 编码 API

- `avcodec_send_frame` 使用时，需要按照 pts 递增的顺序传递原始帧 `AVFrame` 给编码器，编码器按照 dts 递增的顺序输出编码帧 `AVPacket`。编码器不关注原始帧的 dts，只是按照顺序缓存和编码收到的原始帧
- `avcodec_receive_packet` 输出编码帧前，会设置好 `AVPacket.dts`，通常从 0 开始，每次输出一包其 dts 加 1.用户复用之前应将其转为容器层的 dts
- `avcodec_receive_packet` 输出编码帧时，`AVPacket.pts` 拷贝自 `AVFrame.pts`，用户复用之前应将其转为容器层的 pts
- `avcodec_send_frame` 多次发送 `NULL` 数据包并不会丢弃编码器中缓存的帧，使用 `avcodec_flush_buffers()` 可立即丢掉编码器中缓存的帧。因此编码结束时应调用 `avcodec_send_frame(NULL)` 取出编码器缓存的帧，而 seek 或切换流时应调用 `avcodec_flush_buffers()` 丢弃缓存的帧
- 刷新编码器的一般操作：调用一次 `avcodec_send_frame(NULL)`(返回成功)，之后循环调用 `avcodec_receive_packet` 直至其返回 `AVERROR_EOF`。最后一次只获取到结束标志，并没有返回有效数据包

#### avcodec_send_frame

- 函数原型 `int avcodec_send_frame(AVCodecContext *avctx, const AVFrame *frame);`
- 功能：提供原始的视频或音频帧给编码器。使用 `avcodec_receive_packet()` 检索缓存的输出包。
  - 参数 `avctx`: 编解码上下文
  - 参数(输入) `frame`: `AVFrame` 包含要编码的原始音频或视频帧。该帧的所有权由调用者保留，且编码器不会写入此帧。编码器可能创建对帧数据的引用(或复制该帧，如果该帧不是引用计数的)
    - 该参数可以是 `NULL`，在这种情况下，将其视为刷新数据包。它标识流的结束。如果编码器还有缓存的包，此调用之后会将其返回。一旦进入刷新模式，多余的刷新包被忽略，且发送帧会返回 `AVERROR_EOF`。
    - **对于音频**：如果设置了 `AV_CODEC_CAP_VARIABLE_FRAME_SIZE`，那么每个帧可以包含任意数目的采样点。如果没有设置，除了最后一帧，所有帧的采样点数据 `frame->nb_samples` 必须等于编码器设定的音频帧尺寸 `avctx->frame_size`。最后一帧采样点可以比 `avctx->frame_size` 小。
  - 返回值：0 表示成功，否则是负的错误码
    - `AVERROR(EAGAIN)`: 输入在当前状态是不可接受的——用户必须使用 `avcodec_receive_packet()` 读取输出(一旦读取所有输出，应该重发此帧，且这个调用不会返回 `EAGAIN` 错误)
    - 当 `avcodec_send_packet` 和 `avcodec_receive_frame` 在两个单独的循环中调用时，可能出现此情况
  - `AVERROR_EOF`: 编码器已经刷新。且不能发送新帧到编码器
  - `AVERROR(EINVAL)`: 未打开编解码器，未设置引用计数帧(refcounted_frames)，这是一个解码器，或要求刷新
  - `AVERROR(ENOMEM)`: 无法将帧添加到内部队列，或类似的
  - 其他错误：合理的编码错误

#### avcodec_receive_packet

- 函数原型 `int avcodec_receive_packet(AVCodecContext *avctx, AVPacket *avpkt);`
- 功能：读取解码器的编码数据。
- 参数 `avctx`: 编解码上下文
- 参数 `avpkt`: 将设置为编码器分配的引用计数的包。注意在执行其他任何操作之前，该函数始终调用 `av_frame_unref(frame)`。
- 返回值：0 表示成功，否则是负的错误码
  - `AVERROR(EAGAIN)`: 输出在当前状态不可用——用户必须尝试发送新的输入
  - `AVERROR_EOF`: 解码器已经完全刷新，且不会再有更多输出包
  - `AVERROR(EINVAL)`: 未打开编解码器，或这是一个解码器
  - 其他负值：合理的编码错误
