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
```
