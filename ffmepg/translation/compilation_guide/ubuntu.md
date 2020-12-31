# 在 Ubuntu/Debian/Mint 编译 FFmpeg

- [在 Ubuntu/Debian/Mint 编译 FFmpeg](#在-ubuntudebianmint-编译-ffmpeg)
  - [获取依赖](#获取依赖)
  - [编译和安装](#编译和安装)
    - [NASM](#nasm)
    - [libx264](#libx264)
    - [libx265](#libx265)
    - [libvpx](#libvpx)
    - [libfdk-aac](#libfdk-aac)
    - [libmp3lame](#libmp3lame)
    - [libopus](#libopus)
    - [libaom](#libaom)
    - [libsvtav1](#libsvtav1)
    - [FFmpeg](#ffmpeg)
    - [使用](#使用)
    - [文档](#文档)
  - [更新 FFmpeg](#更新-ffmpeg)
  - [撤销此文档的修改](#撤销此文档的修改)
  - [常见问题](#常见问题)
    - [为什么安装到 ~/bin](#为什么安装到-bin)
    - [为什么这篇指南的命令这么复杂](#为什么这篇指南的命令这么复杂)
    - [make[1]: Nothing to be done for 'all'/'install'](#make1-nothing-to-be-done-for-allinstall)
  - [如果需要帮助](#如果需要帮助)
  - [其他资料](#其他资料)

翻译[原文](https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu)。

这篇指南用于受支持的 Ubuntu、Debian 和 Linux Mint 的版本，且会提供 FFmpeg 的本地非系统安装，并支持一些常见的外部编码库。

你也可以参考[通用编译指南](generic.md)获取关于编译软件的额外信息。

懒惰或不能编译的人也可以使用最近的[静态构建](https://ffmpeg.org/download.html#LinuxBuilds)。这些静态构建不支持非免费库。

> 注意：FFmpeg 是 Ubuntu 包的一部分，并且你可使用 `apt-get install ffmpeg` 安装。如果你想要最新版本、遇到错误或想要定制构建，那么你可能仍然希望编译 FFmpeg，且它不会干扰存储库中的 FFmpeg 包。

这篇指南是非侵入性的，将在主目录创建一些目录：

- `ffmpeg_sources`——源码文件下载的位置。当本指南结束时如果希望可以删掉。
- `ffmpeg_build`——文件构建以及库安装的位置。当本指南结束时如果希望可以删掉。
- `bin`——生成的二进制文件(`ffmpeg`、`ffplay`、`ffprobe`、`x264`、`x265`)安装的位置。

你可以按照[撤销此文档的修改](#撤销此文档的修改)轻易撤销任何操作。

## 获取依赖

这些是编译需要的包，但是如果愿意你可以在结束的时候移除它们：

```sh
sudo apt-get update -qq && sudo apt-get -y install \
  autoconf \
  automake \
  build-essential \
  cmake \
  git-core \
  libass-dev \
  libfreetype6-dev \
  libgnutls28-dev \
  libsdl2-dev \
  libtool \
  libva-dev \
  libvdpau-dev \
  libvorbis-dev \
  libxcb1-dev \
  libxcb-shm0-dev \
  libxcb-xfixes0-dev \
  pkg-config \
  texinfo \
  wget \
  yasm \
  zlib1g-dev
```

> 注意：服务器用户可以忽视 `ffplay` 和 x11grab 依赖：`libsdl2-dev libva-dev libvdpau-dev libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev`。

在你的主目录创建新目录存放所有源码和二进制文件：

```sh
mkdir -p ~/ffmpeg_sources ~/bin
```

## 编译和安装

这篇指南假定你想要安装一些最常用的第三方库。每个章节提供了安装这些库需要的命令。

对于每个章节，复制-粘贴整个代码段到你的 shell。

如果不需要一些特性，你可能想要跳过相关章节(如果不是必须的)，然后移除 FFmpeg 中合适的 `./configure` 选项。比如，如果不需要 `libvpx`，跳过这个章节并移除[安装 FFmpeg](#ffmpeg) 章节中的 `--enable-libvpx`。

> 建议：为了显著加速多核系统的编译过程，你可以对每个 `make` 命令使用 `-j` 选项，比如 `make -j4`。

### NASM

一些库使用的汇编器。

如果存储库提供版本大于等于 2.13 的 nasm，那么你可以不用编译直接安装：

```sh
sudo apt-get install nasm
```

否则你可以编译：

```sh
cd ~/ffmpeg_sources && \
wget https://www.nasm.us/pub/nasm/releasebuilds/2.14.02/nasm-2.14.02.tar.bz2 && \
tar xjvf nasm-2.14.02.tar.bz2 && \
cd nasm-2.14.02 && \
./autogen.sh && \
PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" && \
make && \
make install
```

### libx264

H.264 视频编码器。查看 [H.264 编码教程](https://trac.ffmpeg.org/wiki/Encode/H.264)获取更多信息和使用示例。

要求配置 `ffmpeg` 带有 `--enable-gpl --enable-libx264`。

如果你的仓库提供版本大于等于 118 的 `libx264-dev`，那么你可以不用编译直接安装：

```sh
sudo apt-get install libx264-dev
```

否则你可以编译：

```sh
cd ~/ffmpeg_sources && \
git -C x264 pull 2> /dev/null || git clone --depth 1 https://code.videolan.org/videolan/x264.git && \
cd x264 && \
PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-static --enable-pic && \
PATH="$HOME/bin:$PATH" make && \
make install
```

### libx265

H.265/HEVC 视频编码器。查看 [H.265 编码教程](https://trac.ffmpeg.org/wiki/Encode/H.265)获取更多信息和使用示例。

要求配置 `ffmpeg` 带有 `--enable-gpl --enable-libx265`。

如果你的仓库提供版本大于等于 68 的 `libx265-dev`，那么你可以不用编译直接安装：

```sh
sudo apt-get install libx265-dev libnuma-dev
```

> 警告：目前不像其他库，你需要获取完整的 libx265 仓库(因此移除 git clone 的 `--depth 1` 参数)。确实，它需要更长时间，但是必须支持创建 x265.pc 文件，构建带有 `--enable-libx265` 的 FFmpeg 需要这个文件。没有这个文件，FFmpeg 构建会失败。
> 如果你不能，或者不想获取完整的 libx265 仓库，请使用 `apt` 提供的版本。

否则你可以编译：

```sh
sudo apt-get install libnuma-dev && \
cd ~/ffmpeg_sources && \
git -C x265_git pull 2> /dev/null || git clone https://bitbucket.org/multicoreware/x265_git && \
cd x265_git/build/linux && \
PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED=off ../../source && \
PATH="$HOME/bin:$PATH" make && \
make install
```

### libvpx

VP8/VP9 视频编码器/解码器。查看 [VP9 视频编码教程](https://trac.ffmpeg.org/wiki/Encode/VP9)获取更多信息和使用示例。

要求配置 `ffmpeg` 带有 `--enable-libvpx`。

如果你的仓库提供版本大于等于 1.4.0 的 `libvpx-dev`，那么你可以不用编译直接安装：

```sh
sudo apt-get install libvpx-dev
```

否则你可以编译：

```sh
cd ~/ffmpeg_sources && \
git -C libvpx pull 2> /dev/null || git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git && \
cd libvpx && \
PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --disable-examples --disable-unit-tests --enable-vp9-highbitdepth --as=yasm && \
PATH="$HOME/bin:$PATH" make && \
make install
```

### libfdk-aac

AAC 音频解码器。查看 [AAC 音频编码教程](https://trac.ffmpeg.org/wiki/Encode/AAC)获取更多信息和使用示例。

要求配置 `ffmpeg` 带有 `--enable-libfdk-aac`(如果配置也包含 `--enable-gpl`，也需要包含 `--enable-nonfree`)。

如果你的仓库提供 `libfdk-aac-dev`，那么你可以不用编译直接安装：

```sh
sudo apt-get install libfdk-aac-dev
```

否则你可以编译：

```sh
cd ~/ffmpeg_sources && \
git -C fdk-aac pull 2> /dev/null || git clone --depth 1 https://github.com/mstorsjo/fdk-aac && \
cd fdk-aac && \
autoreconf -fiv && \
./configure --prefix="$HOME/ffmpeg_build" --disable-shared && \
make && \
make install
```

### libmp3lame

MP3 音频编码器。

要求配置 `ffmpeg` 带有 `--enable-libmp3lame`。

如果你的仓库提供版本大于等于 3.98.3 的 `libmp3lame-dev`，那么你可以不用编译直接安装：

```sh
sudo apt-get install libmp3lame-dev
```

否则你可以编译：

```sh
cd ~/ffmpeg_sources && \
wget -O lame-3.100.tar.gz https://downloads.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz && \
tar xzvf lame-3.100.tar.gz && \
cd lame-3.100 && \
PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --disable-shared --enable-nasm && \
PATH="$HOME/bin:$PATH" make && \
make install
```

### libopus

Opus 音频解码器和编码器。

要求配置 `ffmpeg` 带有 `--enable-libopus`。

如果你的仓库提供版本大于等于 1.1 的 `libopus-dev`，那么你可以不用编译直接安装：

```sh
sudo apt-get install libopus-dev
```

否则你可以编译：

```sh
cd ~/ffmpeg_sources && \
git -C opus pull 2> /dev/null || git clone --depth 1 https://github.com/xiph/opus.git && \
cd opus && \
./autogen.sh && \
./configure --prefix="$HOME/ffmpeg_build" --disable-shared && \
make && \
make install
```

### libaom

AV1 视频编码器/解码器。

> 警告：libaom 似乎还没有一个稳定的 API，因此编译 `libavcodec/libaomenc.c` 有时可能失败。请等我们一或两天来赶上这些令人讨厌的修改，重新下载 `ffmpeg-snapshot.tar.bz2`，然后重试。或完全跳过 libaom。

```sh
cd ~/ffmpeg_sources && \
git -C aom pull 2> /dev/null || git clone --depth 1 https://aomedia.googlesource.com/aom && \
mkdir -p aom_build && \
cd aom_build && \
PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED=off -DENABLE_NASM=on ../aom && \
PATH="$HOME/bin:$PATH" make && \
make install
```

### libsvtav1

AV1 视频编码器/解码器。FFmpeg 只支持它的解码器，因此禁用解码器的构建。

要求配置 `ffmpeg` 带有 `--enable-libsvtav1`。

```sh
cd ~/ffmpeg_sources && \
git -C SVT-AV1 pull 2> /dev/null || git clone https://github.com/AOMediaCodec/SVT-AV1.git && \
mkdir -p SVT-AV1/build && \
cd SVT-AV1/build && \
PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DCMAKE_BUILD_TYPE=Release -DBUILD_DEC=OFF -DBUILD_SHARED_LIBS=OFF .. && \
PATH="$HOME/bin:$PATH" make && \
make install
```

### FFmpeg

```sh
cd ~/ffmpeg_sources && \
wget -O ffmpeg-snapshot.tar.bz2 https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 && \
tar xjvf ffmpeg-snapshot.tar.bz2 && \
cd ffmpeg && \
PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
  --prefix="$HOME/ffmpeg_build" \
  --pkg-config-flags="--static" \
  --extra-cflags="-I$HOME/ffmpeg_build/include" \
  --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
  --extra-libs="-lpthread -lm" \
  --bindir="$HOME/bin" \
  --enable-gpl \
  --enable-gnutls \
  --enable-libaom \
  --enable-libass \
  --enable-libfdk-aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libsvtav1 \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libx264 \
  --enable-libx265 \
  --enable-nonfree && \
PATH="$HOME/bin:$PATH" make && \
make install && \
hash -r
```

现在重新登录或者在你当前的 shell 会话运行下面的命令，以便识别出新的 `ffmpeg` 位置：

```sh
source ~/.profile
```

**现在完成了编译和安装**，并且 `ffmpeg`(以及 `ffplay`、`ffprobe`、`lame`、`x264` 和 `x265`) 现在也可以使用了。本教程的其余部分显示了如何更新或删除 FFmpeg。

### 使用

现在你可以打开一个终端，输入 `ffmpeg` 命令，然后它应该执行新的 `ffmpeg`。

如果你需要同一系统上的多个用户访问新的 `ffmpeg`，而不仅仅是编译 FFmpeg 的用户，那么从 `~/bin` 将 `ffmpeg` 二进制文件移动或拷贝到 `/usr/local/bin`。

### 文档

如果你想运行 `man ffmpeg` 访问文档：

```sh
echo "MANPATH_MAP $HOME/bin $HOME/ffmpeg_build/share/man" >> ~/.manpath
```

你可能需要注销再登录使得 `man ffmpeg` 生效。

HTML 格式化的文档位于 `~/ffmpeg_build/share/doc/ffmpeg`。

你也可以参考[在线的 FFmpeg 文档](https://ffmpeg.org/documentation.html)，但是记住它每天会重新生成，并且应该和最新的 `ffmpeg` 一起使用(这意味着旧的构建可能与在线文档不兼容)。

## 更新 FFmpeg

FFmpeg 的开发正在进行中，并且偶尔的更新可以提供新功能和修复错误。首先你需要删除(或移动)旧文件：

```sh
rm -rf ~/ffmpeg_build ~/bin/{ffmpeg,ffprobe,ffplay,x264,x265}
```

现在可以从指南的开始进行操作。

## 撤销此文档的修改

删除构建和源文件以及二进制文件：

```sh
rm -rf ~/ffmpeg_build ~/ffmpeg_sources ~/bin/{ffmpeg,ffprobe,ffplay,x264,x265,nasm}
sed -i '/ffmpeg_build/d' ~/.manpath
hash -r
```

你可能也会删除从本指南安装的包：

```sh
sudo apt-get autoremove autoconf automake build-essential cmake git-core libass-dev libfreetype6-dev libgnutls28-dev libmp3lame-dev libnuma-dev libopus-dev libsdl2-dev libtool libva-dev libvdpau-dev libvorbis-dev libvpx-dev libx264-dev libx265-dev libxcb1-dev libxcb-shm0-dev ibxcb-xfixes0-dev texinfo wget yasm zlib1g-dev
```

## 常见问题

### 为什么安装到 ~/bin

- 避免将文件安装到任何系统目录
- 避免干扰包管理系统
- 避免和仓库的 **ffmpeg** 包冲突
- 对于 [uninstall](#撤销此文档的修改) 超级简单
- 不需要 sudo 或 root：对于共享服务器用户有用，只要他们有需要的依赖
- `~/bin` 已经在原生的 Ubuntu `PATH`(查看 `~/.profile`)
- 用户可以自由移动 `ffmpeg` 到任何其他想要的位置(比如 `/usr/local/bin`)

### 为什么这篇指南的命令这么复杂

这是为了使用户易于编译。本指南：

- 限定所有东西在用户的主目录(查看上面的 FAQ 问题)
- 目的是可在当前所有支持的 Debian 和 Ubuntu 版本上使用
- 支持用户选择他们是否想要编译一些库(最新的以及最好的)还是从其存储库中简单安装版本(快速、简单但是比较旧)

这导致一些不同的其他命令和配置，而不是一般简单的`./configure`、`make` 和 `make install`。

### make[1]: Nothing to be done for 'all'/'install'

这是来自 libvpx 的消息，有时候使得用户以为什么东西出错了。你可以忽视这个消息。它只是意味着 `make` 结束了工作。

## 如果需要帮助

随时在 #ffmpeg IRC 频道或 [ffmpeg 用户](https://ffmpeg.org/contact.html)邮件列表中提问。

## 其他资料

- [通用的 FFmpeg 编译指南](generic.md)
- [H.264 视频编码指南](https://trac.ffmpeg.org/wiki/Encode/H.264)
- [AAC 音频编码指南](https://trac.ffmpeg.org/wiki/Encode/AAC)
