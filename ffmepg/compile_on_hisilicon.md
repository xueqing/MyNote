# 在 Hisilicon 平台编译 ffmpeg

- [在 Hisilicon 平台编译 ffmpeg](#在-hisilicon-平台编译-ffmpeg)
  - [一. 编译准备](#一-编译准备)
    - [1. 克隆 FFmpeg 源码](#1-克隆-ffmpeg-源码)
    - [2. 克隆 libx264 源码](#2-克隆-libx264-源码)
    - [3. 克隆 libx265 源码](#3-克隆-libx265-源码)
  - [二. 编译附加库](#二-编译附加库)
    - [1. 编译 libx264](#1-编译-libx264)
      - [1 配置 libx264](#1-配置-libx264)
      - [2 编译和安装 libx264](#2-编译和安装-libx264)
    - [2. 编译 libx265](#2-编译-libx265)
      - [1 进入交叉编译目录](#1-进入交叉编译目录)
      - [2 修改 CMake 文件](#2-修改-cmake-文件)
      - [3 执行 CMake](#3-执行-cmake)
      - [4 修改 CMake 配置](#4-修改-cmake-配置)
      - [5 完成配置](#5-完成配置)
      - [6 编译和安装 libx264](#6-编译和安装-libx264)
  - [三. 配置 PKG-Config](#三-配置-pkg-config)
    - [1. 导出环境变量](#1-导出环境变量)
    - [2. 验证配置结果](#2-验证配置结果)
  - [四. 编译 FFmpeg](#四-编译-ffmpeg)
    - [1.配置 FFmpeg](#1配置-ffmpeg)
    - [2 编译和安装 FFmpeg](#2-编译和安装-ffmpeg)

## 一. 编译准备

### 1. 克隆 FFmpeg 源码

`git clone git@gitlab.bmi:ylrc/bmi-av/ffmpeg-4.1.git`

### 2. 克隆 libx264 源码

`git clone https://code.videolan.org/videolan/x264.git`

### 3. 克隆 libx265 源码

`hg clone http://hg.videolan.org/x265`

## 二. 编译附加库

### 1. 编译 libx264

#### 1 配置 libx264

```sh
./configure \
--prefix=/Path/To/libx264 \
--enable-static \
--disable-asm \
--enable-pic \
--host=arm-hisiv600-linux \
--cross-prefix=arm-hisiv600-linux- \
--extra-cflags='-mcpu=cortex-a7 -mfloat-abi=softfp -mfpu=neon-vfpv4 -mno-unaligned-access -fno-aggressive-loop-optimizations'
```

#### 2 编译和安装 libx264

`make -j4 && make install`

### 2. 编译 libx265

#### 1 进入交叉编译目录

`cd x265/build/arm-linux/`

#### 2 修改 CMake 文件

修改前：

```txt
set(CROSS_COMPILE_ARM 1)
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR armv6l)

# specify the cross compiler
set(CMAKE_C_COMPILER arm-linux-gnueabi-gcc)
set(CMAKE_CXX_COMPILER arm-linux-gnueabi-g++)

# specify the target environment
SET(CMAKE_FIND_ROOT_PATH  /usr/arm-linux-gnueabi)
 ```

修改后：

```txt
set(CROSS_COMPILE_ARM 1)
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR crotex-a7)

# specify the cross compiler
set(CMAKE_C_COMPILER arm-hisiv600-linux-gcc)
set(CMAKE_CXX_COMPILER arm-hisiv600-linux-g++)

# specify the target environment
SET(CMAKE_FIND_ROOT_PATH  /opt/hisi-linux/x86-arm/arm-hisiv600-linux/)
```

#### 3 执行 CMake

`cmake -DCMAKE_TOOLCHAIN_FILE=crosscompile.cmake -G "Unix Makefiles" ../../source && ccmake ../../source`

#### 4 修改 CMake 配置

```txt
CMAKE_INSTALL_PREFIX: /usr/local - /Path/To/libx265
ENABLE_ASSEMBLY: ON - OFF
ENABLE_LIBNUMA: ON - OFF
ENABLE_SHARED: ON - OFF
LIBDL: LIBDL-NOTFOUND - /opt/hisi-linux/x86-arm/arm-hisiv600-linux/target/usr/lib/libdl.so
```

#### 5 完成配置

```sh
[c] Configure
[e] to exit screen
[q] Quit without generating
```

#### 6 编译和安装 libx264

`make -j4 && make install`

## 三. 配置 PKG-Config

### 1. 导出环境变量

`export PKG_CONFIG_PATH=/Path/To/libx264/lib/pkgconfig:/Path/To/libx265/lib/pkgconfig:$PKG_CONFIG_PATH`

### 2. 验证配置结果

```sh
pkg-config --modversion x264
pkg-config --modversion x265
```

## 四. 编译 FFmpeg

### 1.配置 FFmpeg

```sh
./configure \
--prefix=/Path/To/FFmpeg \
--enable-filters   \
--enable-ffmpeg \
--disable-asm \
--disable-ffplay \
--disable-ffprobe \
--disable-doc \
--enable-cross-compile \
--cross-prefix=arm-hisiv600-linux- \
--cc=arm-hisiv600-linux-gcc \
--cxx=arm-hisiv600-linux-g++ \
--arch=arm \
--target-os=linux \
--host-os=arm-hisiv600-linux \
--enable-gpl \
--enable-shared \
--disable-static \
--enable-libx264 \
--enable-libx265 \
--pkg-config="pkg-config --static" \
--extra-cflags='`pkg-config --cflags --libs x264 x265`' \
--extra-libs='-ldl -lpthread'
```

### 2 编译和安装 FFmpeg

`make -j4 && make install`
