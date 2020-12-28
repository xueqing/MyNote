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

也可以参考[通用编译指南](generic.md)获取关于编译软件的额外信息。

懒惰或不能编译的人也可以使用最近的[静态构建](https://ffmpeg.org/download.html#LinuxBuilds)。这些静态构建不支持非免费库。

> 注意：FFmpeg 是 Ubuntu 包的一部分，且可使用 `apt-get install ffmpeg` 安装。如果想要最新版本、遇到错误或想要，可能仍然希望编译 FFmpeg，且它不会干扰存储库中的 FFmpeg 包。

这篇指南是非侵入性的，将在主目录创建一些目录：

- `ffmpeg_sources`——源码文件下载的位置。当本指南结束时如果希望可以删掉。
- `ffmpeg_build`——文件构建以及库安装的位置。当本指南结束时如果希望可以删掉。
- `bin`——生成的二进制文件(`ffmpeg`、`ffplay`、`ffprobe`、`x264`、`x265`)安装的位置。

可以按照[撤销此文档的修改](#撤销此文档的修改)轻易撤销任何操作。

## 获取依赖

这些是编译需要的包，但是如果愿意可以在结束的时候移除它们：

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

在主目录创建新目录存放所有源码和二进制文件：

```sh
mkdir -p ~/ffmpeg_sources ~/bin
```

## 编译和安装

这篇指南假定想要安装一些最常用的第三方库。每个章节提供了安装这些库需要的命令。

对于每个章节，复制-粘贴整个代码段到 shell。

如果不需要一些特性，可能想要跳过相关章节(如果不是必须的)，然后移除 FFmpeg 中合适的 `./configure` 选项。比如，如果不需要 `libvpx`，跳过这个章节并移除[安装 FFmpeg](#ffmpeg) 章节中的 `--enable-libvpx`。

> 建议：为了显著加速多核系统的编译过程，每个 `make` 命令可以使用 `-j` 选项，比如 `make -j4`。

### NASM

一些库使用的汇编器。

如果存储库

### libx264

### libx265

### libvpx

### libfdk-aac

### libmp3lame

### libopus

### libaom

### libsvtav1

### FFmpeg

### 使用

### 文档

## 更新 FFmpeg

## 撤销此文档的修改

## 常见问题

### 为什么安装到 ~/bin

### 为什么这篇指南的命令这么复杂

### make[1]: Nothing to be done for 'all'/'install'

## 如果需要帮助

## 其他资料
