# FFmpeg 编译指南

- [FFmpeg 编译指南](#ffmpeg-编译指南)
  - [所有平台](#所有平台)
  - [Linux](#linux)
  - [macOS](#macos)
  - [Windows](#windows)
  - [其他平台](#其他平台)
  - [性能建议](#性能建议)
  - [开发者指南](#开发者指南)

翻译[原文](https://trac.ffmpeg.org/wiki/CompilationGuide)。

此页面包含的资源列表描述了从头编译 FFmpeg 的必要步骤，包括使用构建脚本或包管理器编译。

## 所有平台

不管本地平台是什么，阅读[通用编译指南](generic.md)。这篇文章提供了一些通用的编译和安装指南。包括 `configure` 的使用。

- `[vcpkg](https://trac.ffmpeg.org/wiki/CompilationGuide/vcpkg)`——vcpkg 也用于跨平台可移植。在 Windows 上使用 MinGW/MSYS 编译工具链。

## Linux

- [在 Ubuntu/Debian/Mint 编译 FFmpeg](https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu)
- [在 CentOS/RHEL/Fedora 编译 FFmpeg](https://trac.ffmpeg.org/wiki/CompilationGuide/Centos)

在 Linux 下其他获取和编译 FFmpeg 的方法：

- [包含预编译的 FFmpeg 和库的 Docker 镜像](https://hub.docker.com/r/jrottenberg/ffmpeg/)
- [Linuxbrew](https://linuxbrew.sh/)

## macOS

- [在 macOS 上编译 FFmpeg](https://trac.ffmpeg.org/wiki/CompilationGuide/macOS)

## Windows

- [MinGW](https://trac.ffmpeg.org/wiki/CompilationGuide/MinGW)——MinGW 编译指南(编译带有 Windows/MinGW/MSYS 的 FFmpeg)
- [Windows 跨平台编译](https://trac.ffmpeg.org/wiki/CompilationGuide/CrossCompilingForWindows)——Windows 的跨平台编译有时比使用 MinGW+MSYS 更简单
- [WinRT](https://trac.ffmpeg.org/wiki/CompilationGuide/WinRT)——编译 Windows APPs 的 FFmpeg(Windows 10 和 Windows 8.1)
- [MSVC](https://trac.ffmpeg.org/wiki/CompilationGuide/MSVC)——使用 MinGW+MSYS 编译 FFmpeg
  - [参考网页上的说明](http://ffmpeg.org/platform.html)
  - [Roxlu 的指南](https://www.roxlu.com/2019/062/compiling-ffmpeg-with-x264-on-windows-10-using-msvc)

使用外部脚本或工具：

- [媒体自动构建套件](https://github.com/m-ab-s/media-autobuild_suite)——自动编译 Windows 下的 FFmpeg
- [Linuxbrew](https://linuxbrew.sh/)——可用于 Windows Linux 子系统(WSL)
- [Chocolatey](https://chocolatey.org/packages/ffmpeg)——Windows 带有 FFmpeg 包的包管理器

## 其他平台

- [如何编译树莓派(Raspbian) FFmpeg](https://trac.ffmpeg.org/wiki/CompilationGuide/RaspberryPi)
  - [为树莓派预编译的 FFmpeg Docker 镜像](https://github.com/sitkevij/ffmpeg/tree/master/ffmpeg-3.4.1-resin-rpi-raspbian)
- [如何编译安卓 FFmpeg](https://trac.ffmpeg.org/wiki/CompilationGuide/Android)
- [如何跨平台编译 MIPS FFmpeg](https://trac.ffmpeg.org/wiki/CompilationGuide/MIPS)
- [如何编译 Haiku FFmpeg](https://trac.ffmpeg.org/wiki/CompilationGuide/Haiku)

## 性能建议

从源码构建 FFmpeg 时，有很多方法从 FFmpeg 提取最大性能。下面的列表描述了一些方法：

- 如果使用 `GCC/lang`，考虑在 `--extra-cflags` 增加 `-march=native`，以更好利用硬件。另外，对于更通用的解决方案，检查 `-arch` 和 `-cpu` 选项。增益是可变的，且通常很小。但是，这通常比上述方法更安全，因此在此处列出。
- 依据用例而定，`--enable-hardcoded-tables` 可能是一个有用的选项。它导致 `libavcodec` 大小增加了大约 15%，这是此更改影响的主要库。它在编解码器初始化时只处理一次，可以节省表生成时间。因为通过对表进行硬编码，不需要在运行时对其计算。然而，节省的花费通常可以忽略不计(通常约 100k 个周期)，尤其是分摊到整个编码/解码操作时。这个功能默认是未启用的。正在对运行时初始化进行改进，因此随着时间推移，这个选项会对越来越少的编解码器产生影响。
- 可以通过测试 `./configure --help` 查看其他选项。

## 开发者指南

- [为 FFmpeg(Linux) 设置 Eclipse IDE](https://trac.ffmpeg.org/wiki/Setup_Eclipse_IDE_for_FFmpeg_(Linux))
