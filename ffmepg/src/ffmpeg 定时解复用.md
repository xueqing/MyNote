# ffmpeg 定时解复用

```c
static int transcode_init(void)
{
  // 初始化帧率估计(如果命令行参数设置了 -re，在这里记录每个输入文件所有输入流的 start 参数为当前时间)
  for (i = 0; i < nb_input_files; i++) {
    InputFile *ifile = input_files[i];
    if (ifile->rate_emu)
      for (j = 0; j < ifile->nb_streams; j++)
        input_streams[j + ifile->ist_index]->start = av_gettime_relative();
  }
}
```

```c
typedef struct InputStream {
    int64_t start;// 开始读取的时间
    int64_t next_dts;// 预测此流读取下一包的 dts，或(当一包含有多帧时)预测当前包中下一帧的 dts(单位 AV_TIME_BASE units)
    int64_t dts;// 此流最后读取包的 dts(单位 AV_TIME_BASE units)

    int64_t next_pts;// 下个解码帧的合成 pts(单位 AV_TIME_BASE units)
    int64_t pts;// 当前解码帧的 pts(单位 AV_TIME_BASE units)
    int wrap_correction_done;

    int64_t min_pts;// 当前流中最小的 pts 值
    int64_t max_pts;// 当前流中最大的 pts 值

    int saw_first_ts;// 是否处理第一包数据
    AVRational framerate;// 保存使用 -r 指定的帧率
} InputStream;
```

```c
static int get_input_packet(InputFile *f, AVPacket *pkt)
{
  if (f->rate_emu) {
    int i;
    for (i = 0; i < f->nb_streams; i++) {
      InputStream *ist = input_streams[f->ist_index + i];
      // 判断流的 dts 偏移量和当前时间偏移量
      int64_t pts = av_rescale(ist->dts, 1000000, AV_TIME_BASE);
      int64_t now = av_gettime_relative() - ist->start;
      if (pts > now)
        return AVERROR(EAGAIN);
    }
  }

#if HAVE_THREADS
  if (nb_input_files > 1)
    return get_input_packet_mt(f, pkt);
#endif
  return av_read_frame(f->ctx, pkt);
}
```

```c
// 处理输入包，如果 pkt 为 NULL 表示 EOF (需要刷新解码器缓存) */
static int process_input_packet(InputStream *ist, const AVPacket *pkt, int no_eof)
{
  // InputStream.saw_first_ts 默认为 0，第一次进入此函数将其标记为 1
  if (!ist->saw_first_ts) {
    // 初始化 InputStream.dts
    ist->dts = ist->st->avg_frame_rate.num ? - ist->dec_ctx->has_b_frames * AV_TIME_BASE / av_q2d(ist->st->avg_frame_rate) : 0;
    // 初始化 InputStream.pts
    ist->pts = 0;
    if (pkt && pkt->pts != AV_NOPTS_VALUE && !ist->decoding_needed) {
      ist->dts += av_rescale_q(pkt->pts, ist->st->time_base, AV_TIME_BASE_Q);
      // pts 未使用但是最好设置为一个不完全错误的值
      ist->pts = ist->dts; //unused but better to set it to a value thats not totally wrong
    }
    ist->saw_first_ts = 1;
  }

  // 更新 next_dts
  if (ist->next_dts == AV_NOPTS_VALUE)
    ist->next_dts = ist->dts;
  // 更新 next_pts
  if (ist->next_pts == AV_NOPTS_VALUE)
    ist->next_pts = ist->pts;

  // pkt 为 NULL 表示 EOF
  if (!pkt) {
    // 处理 EOF
    av_init_packet(&avpkt);
    avpkt.data = NULL;
    avpkt.size = 0;
  } else {
    avpkt = *pkt;
  }

  // 根据 pkt 的 dts 设置 InputStream 的 next_dts/dts/next_pts/pts
  if (pkt && pkt->dts != AV_NOPTS_VALUE) {
    ist->next_dts = ist->dts = av_rescale_q(pkt->dts, ist->st->time_base, AV_TIME_BASE_Q);
    if (ist->dec_ctx->codec_type != AVMEDIA_TYPE_VIDEO || !ist->decoding_needed)
      ist->next_pts = ist->pts = ist->dts;
  }

  // while we have more to decode or while the decoder did output something on EOF
  while (ist->decoding_needed) {
    int64_t duration_dts = 0;
    int64_t duration_pts = 0;
    int got_output = 0;
    int decode_failed = 0;

    ist->pts = ist->next_pts;
    ist->dts = ist->next_dts;

    switch (ist->dec_ctx->codec_type) {
    case AVMEDIA_TYPE_AUDIO:
      ret = decode_audio  (ist, repeating ? NULL : &avpkt, &got_output,
                   &decode_failed);
      break;
    case AVMEDIA_TYPE_VIDEO:
      ret = decode_video  (ist, repeating ? NULL : &avpkt, &got_output, &duration_pts, !pkt,
                   &decode_failed);
      if (!repeating || !pkt || got_output) {
        if (pkt && pkt->duration) {
          duration_dts = av_rescale_q(pkt->duration, ist->st->time_base, AV_TIME_BASE_Q);
        } else if(ist->dec_ctx->framerate.num != 0 && ist->dec_ctx->framerate.den != 0) {
          int ticks= av_stream_get_parser(ist->st) ? av_stream_get_parser(ist->st)->repeat_pict+1 : ist->dec_ctx->ticks_per_frame;
          duration_dts = ((int64_t)AV_TIME_BASE *
                  ist->dec_ctx->framerate.den * ticks) /
                  ist->dec_ctx->framerate.num / ist->dec_ctx->ticks_per_frame;
        }

        if(ist->dts != AV_NOPTS_VALUE && duration_dts) {
          ist->next_dts += duration_dts;
        }else
          ist->next_dts = AV_NOPTS_VALUE;
      }

      if (got_output) {
        if (duration_pts > 0) {
          ist->next_pts += av_rescale_q(duration_pts, ist->st->time_base, AV_TIME_BASE_Q);
        } else {
          ist->next_pts += duration_dts;
        }
      }
      break;
    case AVMEDIA_TYPE_SUBTITLE:
      if (repeating)
        break;
      ret = transcode_subtitles(ist, &avpkt, &got_output, &decode_failed);
      if (!pkt && ret >= 0)
        ret = AVERROR_EOF;
      break;
    default:
      return -1;
    }

    if (ret == AVERROR_EOF) {
      eof_reached = 1;
      break;
    }

    if (ret < 0) {
      if (decode_failed) {
        av_log(NULL, AV_LOG_ERROR, "Error while decoding stream #%d:%d: %s\n",
             ist->file_index, ist->st->index, av_err2str(ret));
      } else {
        av_log(NULL, AV_LOG_FATAL, "Error while processing the decoded "
             "data for stream #%d:%d\n", ist->file_index, ist->st->index);
      }
      if (!decode_failed || exit_on_error)
        exit_program(1);
      break;
    }

    if (got_output)
      ist->got_output = 1;

    if (!got_output)
      break;

    // During draining, we might get multiple output frames in this loop.
    // ffmpeg.c does not drain the filter chain on configuration changes,
    // which means if we send multiple frames at once to the filters, and
    // one of those frames changes configuration, the buffered frames will
    // be lost. This can upset certain FATE tests.
    // Decode only 1 frame per call on EOF to appease these FATE tests.
    // The ideal solution would be to rewrite decoding to use the new
    // decoding API in a better way.
    if (!pkt)
      break;

    repeating = 1;
  }

  // 刷新之后，给所有依附此流的输入过滤器发送 EOF，但是循环的时候需要刷新而不用发送 EOF
  /* except when looping we need to flush but not to send an EOF */
  if (!pkt && ist->decoding_needed && eof_reached && !no_eof) {
    int ret = send_filter_eof(ist);
    if (ret < 0) {
      av_log(NULL, AV_LOG_FATAL, "Error marking filters as finished\n");
      exit_program(1);
    }
  }

  // 处理流复制
  if (!ist->decoding_needed && pkt) {
    // 更新 dts/next_dts
    ist->dts = ist->next_dts;
    switch (ist->dec_ctx->codec_type) {
    case AVMEDIA_TYPE_AUDIO:// 音频
      av_assert1(pkt->duration >= 0);
      if (ist->dec_ctx->sample_rate) {
        // 已知音频采样率，时间基*采样大小/帧率=
        ist->next_dts += ((int64_t)AV_TIME_BASE * ist->dec_ctx->frame_size) /
                  ist->dec_ctx->sample_rate;
      } else {
        // 采样率未知，使用包的时长预测 next_dts
        ist->next_dts += av_rescale_q(pkt->duration, ist->st->time_base, AV_TIME_BASE_Q);
      }
      break;
    case AVMEDIA_TYPE_VIDEO:// 视频
      if (ist->framerate.num) {
        // TODO: Remove work-around for c99-to-c89 issue 7
        AVRational time_base_q = AV_TIME_BASE_Q;
        int64_t next_dts = av_rescale_q(ist->next_dts, time_base_q, av_inv_q(ist->framerate));
        ist->next_dts = av_rescale_q(next_dts + 1, av_inv_q(ist->framerate), time_base_q);
      } else if (pkt->duration) {
        ist->next_dts += av_rescale_q(pkt->duration, ist->st->time_base, AV_TIME_BASE_Q);
      } else if(ist->dec_ctx->framerate.num != 0) {
        int ticks= av_stream_get_parser(ist->st) ? av_stream_get_parser(ist->st)->repeat_pict + 1 : ist->dec_ctx->ticks_per_frame;
        ist->next_dts += ((int64_t)AV_TIME_BASE *
                  ist->dec_ctx->framerate.den * ticks) /
                  ist->dec_ctx->framerate.num / ist->dec_ctx->ticks_per_frame;
      }
      break;
    }
    ist->pts = ist->dts;
    ist->next_pts = ist->next_dts;
  }
  for (i = 0; i < nb_output_streams; i++) {
    OutputStream *ost = output_streams[i];

    if (!check_output_constraints(ist, ost) || ost->encoding_needed)
      continue;

    do_streamcopy(ist, ost, pkt);
  }

  return !eof_reached;
}
```
