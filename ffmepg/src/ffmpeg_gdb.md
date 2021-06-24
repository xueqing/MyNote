# 使用 gdb 调试 ffmpeg 编译生成的可执行程序

ffmpeg 使用 `make` 编译时会生成 `xxx` 和 `xxx_g`，如 `ffplay` 和 `ffplay_g`。使用 gdb 调试时应加载 `xxx_g` 文件，`xxx` 文件没有调试符号表。

```sh
Type "apropos word" to search for commands related to "word".
(gdb) file ffplay
Reading symbols from ffplay...(no debugging symbols found)...done.
(gdb) file ffplay_g
Reading symbols from ffplay_g...done.
```

方便起见，可以先编译成静态库进行调试，即 `configure` 不加 `--enable-shared` 选项。可以方便对照源码添加断点。

```sh
Type "apropos word" to search for commands related to "word".
(gdb) file ffplay
Reading symbols from ffplay...(no debugging symbols found)...done.
(gdb) file ffplay_g
Reading symbols from ffplay_g...done.
(gdb) b libavformat/utils.c:init_input
Breakpoint 1 at 0x833957: file libavformat/utils.c, line 396.
(gdb) file ffplay_g
Load new symbol table from "ffplay_g"? (y or n) y
Reading symbols from ffplay_g...done.
(gdb) b rtsp_read_packet
Breakpoint 2 at 0x80303c: file libavformat/rtspdec.c, line 828.
(gdb) r -f rtp udp://192.168.1.140:6000
Starting program: /home/kiki/github/ffmpeg-4.1/ffplay_g -f rtp udp://192.168.1.140:6000
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
ffplay version git-2021-05-26-4ee2cfb Copyright (c) 2003-2018 the FFmpeg developers
  built with gcc 5.4.0 (Ubuntu 5.4.0-6ubuntu1~16.04.12) 20160609
  configuration: --prefix=/home/kiki/ffmpeg/ffmpeg-4.1 --enable-shared --enable-libx265 --enable-libx264 --enable-gpl --enable-libass
  libavutil      56. 19.100 / 56. 19.100
  libavcodec     58. 27.101 / 58. 27.101
  libavformat    58. 18.100 / 58. 18.100
  libavdevice    58.  4.101 / 58.  4.101
  libavfilter     7. 26.100 /  7. 26.100
  libswscale      5.  2.100 /  5.  2.100
  libswresample   3.  2.100 /  3.  2.100
  libpostproc    55.  2.100 / 55.  2.100
[New Thread 0x7fffeb7d6700 (LWP 7044)]
[New Thread 0x7fffdb0e9700 (LWP 7054)]
[New Thread 0x7fffda8e8700 (LWP 7055)]
[New Thread 0x7fffd9bc2700 (LWP 7056)]
```
