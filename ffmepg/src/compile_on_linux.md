# 在 linux 平台编译 ffmpeg

- [在 linux 平台编译 ffmpeg](#在-linux-平台编译-ffmpeg)
  - [一. 编译准备](#一-编译准备)
    - [1. 克隆 FFmpeg 源码](#1-克隆-ffmpeg-源码)
    - [2. 克隆 libx264 源码](#2-克隆-libx264-源码)
    - [3. 克隆 libx265 源码](#3-克隆-libx265-源码)
  - [二. 编译附加库](#二-编译附加库)
    - [1. 编译 libx264](#1-编译-libx264)
      - [1 配置 libx264](#1-配置-libx264)
      - [2 编译和安装 libx264](#2-编译和安装-libx264)
    - [2. 编译 libx265](#2-编译-libx265)
      - [1 进入编译目录](#1-进入编译目录)
      - [2 执行 CMake](#2-执行-cmake)
      - [3 修改 CMake 配置](#3-修改-cmake-配置)
      - [4 完成配置](#4-完成配置)
      - [5 编译和安装 libx265](#5-编译和安装-libx265)
  - [三. 配置 PKG-Config](#三-配置-pkg-config)
    - [1. 导出环境变量](#1-导出环境变量)
    - [2. 验证配置结果](#2-验证配置结果)
  - [四. 编译 FFmpeg](#四-编译-ffmpeg)
    - [1.配置 FFmpeg](#1配置-ffmpeg)
    - [2 编译和安装 FFmpeg](#2-编译和安装-ffmpeg)
    - [3 编译示例代码](#3-编译示例代码)

## 一. 编译准备

### 1. 克隆 FFmpeg 源码

`git clone https://github.com/FFmpeg/FFmpeg.git`

### 2. 克隆 libx264 源码

`git clone https://code.videolan.org/videolan/x264.git`

### 3. 克隆 libx265 源码

```sh
sudo apt install -y mercurial
hg clone http://hg.videolan.org/x265
```

## 二. 编译附加库

### 1. 编译 libx264

#### 1 配置 libx264

`./configure --prefix=/home/kiki/ffmpeg/libx264 --disable-asm --enable-shared`

#### 2 编译和安装 libx264

`make -j4 && make install`

### 2. 编译 libx265

#### 1 进入编译目录

```sh
sudo apt install -y cmake
cd x265/build/linux
```

#### 2 执行 CMake

`cmake ../../source/`

#### 3 修改 CMake 配置

```sh
sudo apt install -y cmake-curses-gui
ccmake ../../source
```

```txt
CMAKE_INSTALL_PREFIX: /usr/local 替换为 /home/kiki/ffmpeg/libx265
```

#### 4 完成配置

```sh
[c] configure
[g] generate and exit
```

#### 5 编译和安装 libx265

`make -j4 && make install`

## 三. 配置 PKG-Config

### 1. 导出环境变量

`export PKG_CONFIG_PATH=/home/kiki/ffmpeg/libx264/lib/pkgconfig:/home/kiki/ffmpeg/libx265/lib/pkgconfig:$PKG_CONFIG_PATH`

### 2. 验证配置结果

```sh
pkg-config --modversion x264
pkg-config --modversion x265
```

## 四. 编译 FFmpeg

### 1.配置 FFmpeg

```sh
sudo apt-get install -y yasm

# 编译生成 ffplay 需要安装 sdl 依赖库
sudo apt-get install -y libsdl2-dev

./configure \
--prefix=/home/kiki/ffmpeg/ffmpeg-4.1 \
--enable-shared \
--enable-gpl \
--enable-libx264 \
--enable-libx265 \
--extra-cflags='`pkg-config --cflags --libs x264 x265`' \
--pkg-config="pkg-config --static"
```

### 2 编译和安装 FFmpeg

`make -j4 && make install`

### 3 编译示例代码

```sh
# 在 ffmpeg 主目录执行下面命令
# xxx_example_deps 可以查看示例代码的依赖库，根据依赖库是否存在判断是否可以编译该示例
./configure
make examples
# 在 .bashrc 添加 ffmpeg 库路径
# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/kiki/ffmpeg/libx264/lib:/home/kiki/ffmpeg/libx265/lib:/home/kiki/ffmpeg/ffmpeg-4.1/lib
# export PKG_CONFIG_PATH=/home/kiki/ffmpeg/libx264/lib/pkgconfig:/home/kiki/ffmpeg/libx265/lib/pkgconfig:/home/kiki/ffmpeg/ffmpeg-4.1/lib/pkgconfig:$PKG_CONFIG_PATH
```
