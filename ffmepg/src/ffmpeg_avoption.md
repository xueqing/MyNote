# 关于 ffmpeg AVOption 使用

服务使用 ffmpeg 库时，想要查看 ffmpeg 内部一些信息，比如 rtsp 链路的状态之类的信息，可以使用 `AVOption`。

方法：在对应的 `const AVOption ff_xxxx_options[]` 添加对应选项，表示想要读取的信息。比如查看 onvif 相机是否支持语音对讲：

- 在 RTSP 协议中，通过 `Describe` 请求头域添加 `Require: www.onvif.org/ver20/backchannel` 可查看 onvif 相机是否支持语音对讲
  - 如果回复的 SDP 消息体中包含 `a=sendonly` 的媒体流，表示支持语音对讲
- 在 `RTSPState` 结构体添加 `int enable_talkback;`
- 在 `const AVOption ff_rtsp_options[]` 中添加 `{ "enable_talkback", "get talkback flag", OFFSET(enable_talkback), AV_OPT_TYPE_INT, {.i64 = 0 }, 0, 1, DEC|ENC },`
- 如果解析到 `a=sendonly` 的媒体流，更新 `rt->enable_talkback = 1;`
- 外部服务需要读取时，可使用类似下面的代码：

  ```c
  int64_t enable_talkback = 0;
  // pOutputContext 是建立 rtsp 连接的上下文
  av_opt_get_int(pOutputContext->priv_data, "enable_talkback", 0, &enable_talkback);
  std::cout <<"==========enable_talkback=" << enable_talkback << std::endl;
  ```
