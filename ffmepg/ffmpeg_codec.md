# ffmpeg 的编解码

## libavcodec 库

`avcodec_send_packet()`/`avcodec_receive_frame()`/`avcodec_send_frame()`/`avcodec_receive_packet()` 函数提供编码/解码 API，将输入和输出解耦。

这些 API 对于编解码以及音视频非常相似，如下方式工作：

- 设置和打开 `AVCodecContext`
- 发送有效的输入：
  - 对于解码，调用 `avcodec_send_packet()` 给解码器一个包含原始压缩数据的 `AVPacket`
  - 对于编码，调用 `avcodec_send_frame()` 给编码器一个包含未压缩音频或视频的 `AVFrame`
  - 两种情形中，建议 `AVPacket` 和 `AVFrame` 都是引用计数的，苟泽 libavcodec 可能需要拷贝输入数据。(libavformat 总是返回引用计数的 `AVPacket`，且 `av_frame_get_buffer()` 分配引用计数的 `AVFrame`)
- 在一个循环中接收输出。定期调用其中一个 `avcodec_receive_*()` 函数并处理它们的输出：
  - 对于解码，调用 `avcodec_receive_frame()`。如果成功，返回一个包含未压缩的音频或视频数据的 `AVFrame`
  - 对于解码，调用 `avcodec_receive_packet()`。如果成功，返回一个包含一个压缩帧的 `AVPacket`
  - 重复调用 `avcodec_receive_*()` 直到返回 `AVERROR(EAGAIN)` 或一个错误。`AVERROR(EAGAIN)` 返回值表示新的输入数据要求返回新的输出。在这种情况下，继续发送数据。对于每个输入的帧/包，编解码器一般会返回一个输出的帧/包，但是也可以返回 0 或者大于 1

解码或编码一开始，编解码器可以接收多个输入帧/包而不用返回一个帧，直到填充其内部缓存。这种情形可以按照上述步骤透明地处理。

理论上。发送输入可以导致 `EAGAIN`——并未接收所有输出才会出现。可以使用者来构造可选的解码或编码循环，而不是上述建议的。比如，可以尝试在每次迭代发送一个新的输入，当返回 `EAGAIN` 时尝试接收输入。

流结束的情形。因为解码器可能出于性能或必要性(考虑 B 帧)在内部缓存多个帧或包，因此需要刷新(即耗尽)编解码器。按照下面的步骤处理：

- 取而代之有效的输入，发送 `NULL` 给 `avcodec_send_packet()`(解码器)或 `avcodec_send_frame()`(编码器)函数。这会进入耗尽模式
- 在一个循环中调用 `avcodec_receive_frame()`(解码器)或 `avcodec_receive_packet()`(编码器)，直到返回 `AVERROR_EOF`。这个函数不会返回 `AVERROR(EAGAIN)`，除非你忘记进入耗尽模式
- 在重新恢复解码之前，必须使用 `avcodec_flush_buffers()` 重置编解码器

强烈建议使用上述 API。但是也可以在这些严格的模式之外调用函数。比如，可以重复调用 `avcodec_send_packet()` 而不调用 `avcodec_receive_frame()`。在这种情况下，`avcodec_send_packet()` 会一直成功之道编解码器内部的缓存填充满(一般在初始输入后，每个输出帧大小是 1)，然后使用 `AVERROR(EAGAIN)` 拒绝输入。一旦开始拒绝输入，只能读取一些输出。

并非所有编解码器会遵循严格且可预测的数据流；唯一的保证是，在一端调用发送/接收调用上的 `AVERROR(EAGAIN)` 返回值意味着另一端的接收/发送调用会成功，或者至少不会因为 `AVERROR(EAGAIN)` 失败。一般来说，没有编解码器允许无限缓存输入或输出。
