# webrtc2sip

- [webrtc2sip](#webrtc2sip)
  - [1 术语](#1-%E6%9C%AF%E8%AF%AD)
  - [2 webrtc2sip 架构](#2-webrtc2sip-%E6%9E%B6%E6%9E%84)
  - [3 webrtc2sip 配置](#3-webrtc2sip-%E9%85%8D%E7%BD%AE)
  - [4 编译源码](#4-%E7%BC%96%E8%AF%91%E6%BA%90%E7%A0%81)
    - [4.1 编译 Doubango IMS Framework](#41-%E7%BC%96%E8%AF%91-doubango-ims-framework)
      - [4.1.1 编译 libsrtp](#411-%E7%BC%96%E8%AF%91-libsrtp)
      - [4.1.2 编译 OpenSSL](#412-%E7%BC%96%E8%AF%91-openssl)
      - [4.1.3 编译 libspeex 和 libspeexdsp](#413-%E7%BC%96%E8%AF%91-libspeex-%E5%92%8C-libspeexdsp)
      - [4.1.4 编译 YASM](#414-%E7%BC%96%E8%AF%91-yasm)
      - [4.1.5 编译 libvpx](#415-%E7%BC%96%E8%AF%91-libvpx)
      - [4.1.6 编译 linyuv](#416-%E7%BC%96%E8%AF%91-linyuv)
      - [4.1.7 编译 opencore-amr](#417-%E7%BC%96%E8%AF%91-opencore-amr)
      - [4.1.8 编译 libopus](#418-%E7%BC%96%E8%AF%91-libopus)
      - [4.1.9 编译 libgsm](#419-%E7%BC%96%E8%AF%91-libgsm)
      - [4.1.10 编译 g729](#4110-%E7%BC%96%E8%AF%91-g729)
      - [4.1.11 编译 iLBC](#4111-%E7%BC%96%E8%AF%91-ilbc)
      - [4.1.12 编译 x264](#4112-%E7%BC%96%E8%AF%91-x264)
      - [4.1.13 编译 FFMpeg](#4113-%E7%BC%96%E8%AF%91-ffmpeg)
      - [4.1.14 编译 Doubango](#4114-%E7%BC%96%E8%AF%91-doubango)
    - [4.2 编译 webrtc2sip 和第三方库](#42-%E7%BC%96%E8%AF%91-webrtc2sip-%E5%92%8C%E7%AC%AC%E4%B8%89%E6%96%B9%E5%BA%93)
    - [4.3 运行 webrtc2sip](#43-%E8%BF%90%E8%A1%8C-webrtc2sip)
  - [5 测试网关](#5-%E6%B5%8B%E8%AF%95%E7%BD%91%E5%85%B3)
    - [5.1 本地测试 sipML5 和 webrtc2sip](#51-%E6%9C%AC%E5%9C%B0%E6%B5%8B%E8%AF%95-sipml5-%E5%92%8C-webrtc2sip)
  - [6 互操作性](#6-%E4%BA%92%E6%93%8D%E4%BD%9C%E6%80%A7)
    - [6.1 关于服务](#61-%E5%85%B3%E4%BA%8E%E6%9C%8D%E5%8A%A1)
      - [6.1.1 Asterisk](#611-asterisk)
      - [6.1.2 FreeSwitch](#612-freeswitch)
    - [6.2 关于 web 浏览器](#62-%E5%85%B3%E4%BA%8E-web-%E6%B5%8F%E8%A7%88%E5%99%A8)
      - [6.2.1 Chrome](#621-chrome)
      - [6.2.2 Firefox Nightly](#622-firefox-nightly)
      - [6.2.3 Firefox，Safari，IE 和 Opera](#623-firefoxsafariie-%E5%92%8C-opera)
      - [6.2.4 Ericsson Bowser](#624-ericsson-bowser)
  - [7 安全问题](#7-%E5%AE%89%E5%85%A8%E9%97%AE%E9%A2%98)
  - [8 一些编译问题](#8-%E4%B8%80%E4%BA%9B%E7%BC%96%E8%AF%91%E9%97%AE%E9%A2%98)
    - [8.1 webrtc2sip 编译出错](#81-webrtc2sip-%E7%BC%96%E8%AF%91%E5%87%BA%E9%94%99)
    - [8.2 视频编解码崩溃](#82-%E8%A7%86%E9%A2%91%E7%BC%96%E8%A7%A3%E7%A0%81%E5%B4%A9%E6%BA%83)
    - [8.3 webrtc2sip 项目配置](#83-webrtc2sip-%E9%A1%B9%E7%9B%AE%E9%85%8D%E7%BD%AE)
    - [8.4 关于 sipML5 服务](#84-%E5%85%B3%E4%BA%8E-sipml5-%E6%9C%8D%E5%8A%A1)
    - [8.4.1 webrtc2sip 解析 sipML5 请求失败](#841-webrtc2sip-%E8%A7%A3%E6%9E%90-sipml5-%E8%AF%B7%E6%B1%82%E5%A4%B1%E8%B4%A5)
    - [8.5 关于 Chrome 使用](#85-%E5%85%B3%E4%BA%8E-chrome-%E4%BD%BF%E7%94%A8)
    - [8.6 守护进程](#86-%E5%AE%88%E6%8A%A4%E8%BF%9B%E7%A8%8B)
  - [9 运行问题](#9-%E8%BF%90%E8%A1%8C%E9%97%AE%E9%A2%98)
    - [9.1 ERR_SSL_VERSION_OR_CIPHER_MISMATCH](#91-errsslversionorciphermismatch)
  - [10 参考](#10-%E5%8F%82%E8%80%83)

## 1 术语

| 缩写 | 定义 | 术语 |
| --- | --- | --- |
| RTC | real-time communication |实时通信 |
| W3C | world wide web consortium | |
| SIP | session initiation protocol | 会话初始协议 |
| VoIP | voice over IP | 网络电话 |
| IMS | IP multimedia subsystem | 多媒体子系统 |
| LTE | long term evolution | 长期演进技术 |
| PSTN | public switched telephone networks | 公共交换电话网 |
| SMS | short message service | 短信服务 |
| ICE | Internet communication engine | 互联网通讯引擎 |
| DTLS | datagram transport layer security | 数据报传输层安全 |
| SRTP| secure real-time transport protocol | 安全实时传输协议 |
| AoR | address of record | 地址记录 |
| b2bua | back to back user agent | 背对背用户代理 |
| MTI | mandatory to implement | 命令到实现 |
| WSS | secure websocket| - |
| AMR | adaptive multi rate | 自适应多速率 |
| GSM | global system for mobile | 全球移动通讯系统 |

## 2 webrtc2sip 架构

- HTML SIP 客户端：使用 [sipML5](https://www.doubango.org/sipml5/) 实现
- 网关包括 4 个模块
  - SIP Proxy：把来自 WebSocket 的 SIP 传输转换成 UDP/TCP/TLS 等传统 SIP 网络支持的协议
    - 如果后台服务支持通过 WebSocket 的 SIP 协议，可以跨过这个模块直接与客户端连接
    - 如果使用 RTCWeb Breaker 或 Media Coder 模块，则建议使用此模块
  - RTCWeb Breaker
    - RTCWeb支持 ICE 和 DTLS/SRTP，而传统的 SIP 终端不支持
    - RTCWeb Breaker 转换媒体流以协商两种媒体方式
    - 默认是不使用 RTCWeb Breaker，需要客户端再注册之前启用
      - 在 URI 参数中包含"rtcweb-breaker=true"
  - Media Coder
    - Chrome 使用 VP8 的视频编解码，Bowser 使用 H.264 AVC
    - Media Coder 使得可以在 Chrome 和 Bowser 直接建立视频会话
    - 可使用 xml 配置文件启用 Media Coder，同时需要启用 RTCWeb breaker 模块
  - click-to-call service
    - 基于其他三个模块的完整 SIP click-to-call 解决方案
    - 允许通过一个链接直接打电话
    - 包括 4 个组件
      - SMTP Client：为新注册的用户发送激活链接的邮件
      - HTTPS Server：交换浏览器和 click-to-call 服务之间的内容
      - Database connector：连接数据库的接口
      - JSON API：用于认证用户和管理用户账户

## 3 webrtc2sip 配置

- 网关使用 `config.xml` 文件进行配置，和网关的运行目录相同

## 4 编译源码

- 基于 CentOS 64，也可在 Linux，Windows 或 OS X 环境编译

```sh
# 准备系统
sudo yum update
sudo yum install make libtool autoconf subversion git cvs wget libogg-devel gcc gcc-c++ pkgconfig
sudo yum install nasm
```

- ubuntu 环境下错误

```sh
# E: Unable to locate package libogg-devel
sudo apt-get install libogg-dev
# E: Unable to locate package gcc-c+
# E: Couldn't find any package by regex 'gcc-c+'
sudo apt-get install g++
# E: Unable to locate package pkgconfig
sudo apt-get install pkg-config
```

### 4.1 编译 Doubango IMS Framework

- [Doubango IMS Framework](https://code.google.com/archive/p/doubango/) 包含所有的信号协议(SIP/SDP/WebSocket 等)和媒体引擎(RTP 栈/音视频编解码)

```sh
# 检出 Doubango 2.0 的源码
svn checkout https://doubango.googlecode.com/svn/branches/2.0/doubango doubango
```

- ubuntu 环境下错误

```sh
# svn: E170013: Unable to connect to a repository at URL 'https://doubango.googlecode.com/svn/branches/2.0/doubango'
# svn: E000110: Error running context: Connection timed out
wget https://storage.googleapis.com/google-code-archive-source/v2/code.google.com/webrtc2sip/source-archive.zip
## git 仓库没有 2.0 分支
##git clone https://github.com/DoubangoTelecom/doubango.git
```

#### 4.1.1 编译 libsrtp

```sh
# 源码编译安装
git clone https://github.com/cisco/libsrtp/
cd libsrtp
git checkout v1.5.0
CFLAGS="-fPIC" ./configure --enable-pic && make && sudo make install
```

#### 4.1.2 编译 OpenSSL

- 如果使用 RTCWeb Breaker 模块或者 WSS，需要 OpenSSL
- 如果需要支持 DTLS-SRTP，需要 OpenSSL 1.0.1 版本

```sh
# 检查版本
openssl version
# 源码编译安装
wget http://www.openssl.org/source/openssl-1.0.1c.tar.gz
tar -xvzf openssl-1.0.1c.tar.gz
cd openssl-1.0.1c
./config shared --prefix=/usr/local --openssldir=/usr/local/openssl && make && sudo make install
```

- 编译错误

```sh
# installing man1/cms.1
# cms.pod around line 457: Expected text after =item, not a number
# cms.pod around line 461: Expected text after =item, not a number
sudo make install_sw
```

#### 4.1.3 编译 libspeex 和 libspeexdsp

- libspeex(音频编解码) 和 libspeexdsp(音频处理和抖动缓冲区)是可选的，建议启用 libspeexdsp

```sh
# 命令行安装 dev 包
sudo yum install speex-devel
# 源码编译安装
wget http://downloads.xiph.org/releases/speex/speex-1.2beta3.tar.gz
tar -xvzf speex-1.2beta3.tar.gz
cd speex-1.2beta3
./configure --disable-oggtest --without-libogg && make && sudo make install
```

- ubuntu 环境

```sh
# E: Unable to locate package speex-devel
sudo apt-get install libspeex-dev
sudo apt-get install libspeexdsp-dev
```

#### 4.1.4 编译 YASM

- 如果要使能 VPX(VP8 视频编解码) 或 x264(H.264 编解码)，需要 YASM

```sh
# 源码编译安装
wget http://www.tortall.net/projects/yasm/releases/yasm-1.2.0.tar.gz
tar -xvzf yasm-1.2.0.tar.gz
cd yasm-1.2.0
./configure && make && sudo make install
```

#### 4.1.5 编译 libvpx

- libvpx 支持 VP8，是可选的，但是如果需要使用 Chrome 或 Firefox 的视频会话，推荐编译

```sh
# 命令行安装 dev 包
sudo yum install libvpx-devel
# 源码编译安装
git clone http://git.chromium.org/webm/libvpx.git
cd libvpx
./configure --enable-realtime-only --enable-error-concealment --disable-examples --enable-vp8 --enable-pic --enable-shared --as=yasm
make && make install
```

- ubuntu 环境

```sh
# E: Unable to locate package libvpx-devel
sudo apt-get install libvpx-dev
```

#### 4.1.6 编译 linyuv

- libyuv 可选，支持视频缩放和 chroma 转换

```sh
# 源码编译安装
mkdir libyuv && cd libyuv
svn co http://src.chromium.org/svn/trunk/tools/depot_tools .
./gclient config http://libyuv.googlecode.com/svn/trunk
./gclient sync && cd trunk
make -j6 V=1 -r libyuv BUILDTYPE=Release
make -j6 V=1 -r libjpeg BUILDTYPE=Release
cp out/Release/obj.target/libyuv.a /usr/local/lib
cp out/Release/obj.target/third_party/libjpeg_turbo/libjpeg_turbo.a /usr/local/lib
mkdir --parents /usr/local/include/libyuv/libyuv
cp -rf include/libyuv.h /usr/local/include/libyuv
cp -rf include/libyuv/*.h /usr/local/include/libyuv/libyuv
```

- svn 源码仓库克隆失败，跳过
- 查找到资料：[安装 libyuv](https://chromium.googlesource.com/libyuv/libyuv/+/master/docs/getting_started.md)

#### 4.1.7 编译 opencore-amr

- opencore-amr 可选，支持 AMR 音频编解码

```sh
# 源码编译安装
git clone git://opencore-amr.git.sourceforge.net/gitroot/opencore-amr/opencore-amr
cd opencore-amr
autoreconf --install && ./configure && make && sudo make install
```

#### 4.1.8 编译 libopus

- libopus 是用于 WebRTC 的 MTI 编解码，可选但建议使用，支持 Opus 音频编解码

```sh
# 源码编译安装
wget http://downloads.xiph.org/releases/opus/opus-1.0.2.tar.gz
tar -xvzf opus-1.0.2.tar.gz
cd opus-1.0.2
./configure --with-pic --enable-float-approx && make && sudo make install
```

#### 4.1.9 编译 libgsm

- libgsm 可选，支持 GSM 音频编解码

```sh
# 命令行安装 dev 包(建议)
sudo yum install gsm-devel
# 源码编译安装
wget http://www.quut.com/gsm/gsm-1.0.13.tar.gz
tar -xvzf gsm-1.0.13.tar.gz
cd gsm-1.0-pl13 && make && make install
#cp -rf ./inc/* /usr/local/include
#cp -rf ./lib/* /usr/local/lib
```

- ubuntu 环境

```sh
# E: Unable to locate package gsm-devel
sudo apt-get install libgsm1-dev
```

#### 4.1.10 编译 g729

- G729 可选，支持 G.729 音频编解码

```sh
# 源码编译安装
svn co http://g729.googlecode.com/svn/trunk/ g729b
cd g729b
./autogen.sh && ./configure --enable-static --disable-shared && make && make install
```

- svn 源码仓库克隆失败，跳过

#### 4.1.11 编译 iLBC

- iLBC 可选，支持 ILBC 音频编解码

```sh
# 源码编译安装
svn co http://doubango.googlecode.com/svn/branches/2.0/doubango/thirdparties/scripts/ilbc
cd ilbc
wget http://www.ietf.org/rfc/rfc3951.txt
awk -f extract.awk rfc3951.txt
./autogen.sh && ./configure
make && make install
```

- svn 源码仓库克隆失败，跳过

#### 4.1.12 编译 x264

- x264 可选，支持 H.264 视频编解码(要求有 FFMpeg)

```sh
# 源码编译安装
wget ftp://ftp.videolan.org/pub/x264/snapshots/last_x264.tar.bz2
tar -xvjf last_x264.tar.bz2
# the output directory may be difference depending on the version and date
cd x264-snapshot-20121201-2245
./configure --enable-shared --enable-pic && make && sudo make install
```

- ubuntu 环境

```sh
# Found no assembler
# Minimum version is nasm-2.13
# If you really want to compile without asm, configure with --disable-asm.
```

#### 4.1.13 编译 FFMpeg

- FFMPeg 可选，支持 H.263，H.264(需要 x264) 和 MP4V-ES 视频编解码

```sh
# 源码编译安装
git clone git://source.ffmpeg.org/ffmpeg.git ffmpeg
cd ffmpeg
# grap a release branch
git checkout n1.2
# configure source code
./configure \
--extra-cflags="-fPIC" \
--extra-ldflags="-lpthread" \
\
--enable-pic --enable-memalign-hack --enable-pthreads \
--enable-shared --disable-static \
--disable-network --enable-pthreads \
--disable-ffmpeg --disable-ffplay --disable-ffserver --disable-ffprobe \
\
--enable-gpl \
\
--disable-debug
# 加入 H.264 编码，在 configure 后添加 --enable-libx264
make && sudo make install
```

#### 4.1.14 编译 Doubango

```sh
# 源码编译安装
## 最小化编译
cd doubango && ./autogen.sh && ./configure --with-ssl --with-srtp --with-speexdsp
make && sudo make install
## 建议的编译
cd doubango && ./autogen.sh && ./configure --with-ssl --with-srtp --with-speexdsp --with-ffmpeg
make && sudo make install
## 完整的编译
cd doubango && ./autogen.sh && ./configure --with-ssl --with-srtp --with-vpx --with-yuv
--with-amr --with-speex --with-speexdsp --with-gsm --with-ilbc --with-g729 --with-ffmpeg
make && sudo make install
```

### 4.2 编译 webrtc2sip 和第三方库

- webrtc2sip 依赖于 Doubango IMS Framework v2.0 和 libxml2

```sh
# 检出源码
svn co http://webrtc2sip.googlecode.com/svn/trunk/ webrtc2sip
# 安装 libxml2
yum install libxml2-devel
# 编译 webrtc2sip
export PREFIX=/opt/webrtc2sip
cd webrtc2sip && ./autogen.sh && ./configure --prefix=$PREFIX
# ./configure --prefix=$PREFIX LDFLAGS='-ldl' LIBS='-ldl'
make clean && make && sudo make install
cp -f ./config.xml $PREFIX/sbin/config.xml
```

- svn 源码仓库克隆失败，跳过
- ubuntu 环境

```sh
git clone https://github.com/DoubangoTelecom/webrtc2sip.git
sudo apt-get install libxml2-dev
```

### 4.3 运行 webrtc2sip

- 需要有效的配置文件，默认的配置文件是与 `webrtc2sip` 同目录的 `config.xml`

```sh
# 执行二进制文件运行
webrtc2sip
```

| 命令行参数 | 支持的版本 | 描述 | 示例 |
| --- | --- | --- | --- |
| --config=PATH | 2.1.0 | 覆盖 `config.xml` 的默认路径 | --config=/tmp/config.xml |
| --help | 2.1.0 | 显示帮助信息 | - |
| --version | 2.1.0 | 显示网关版本 | - |

- 运行时错误

```sh
# sqlite/mp_db_sqlite.cc"
# line: "51"
# MSG: Failed to open SQLite database with error code = 14 and connectionInfo=./c2c_sqlite.db
# 在 webrtc2sip 所在文件夹执行语句，修改文件夹权限
sudo chown -R ubuntu:ubuntu ./
```

## 5 测试网关

- 假定 webrtc2sip 运行在 192.168.0.1 机器，SIP 服务运行在 192.168.0.2 机器
  - 在浏览器打开 `http://sipml5.org/expert.htm`
  - 在`WebSocket Server URL`区域填写 webrtc2sip 网关监听的 IP 和端口，比如`ws://192.168.0.1:10060`或`ws://192.168.0.1:10062`。注意不要忘记`ws://`或`wss://`
  - 在`SIP outbound Proxy URL`设置目的 IP 和端口，忽视域名，如`udp://192.168.0.2:5060`
  - 如果调用传统的 SIP 终端，检查`Enable RTCWeb Breaker`选项

### 5.1 本地测试 sipML5 和 webrtc2sip

- 开启 sipML5 服务，使用[lite_server](https://www.npmjs.com/package/lite-server)，网址默认`http://localhost:3000/`
- 配置注册信息，具体值见下面的表格
  - 假定 sipML5 服务运行在 192.168.1.140 机器
  - 传统的 SIP 网关接收待认证的注册，用户编码是 34020000001110000001，密码是 12345678(默认)，端口是 5062(默认)

| 注册项 | 值 | 必填(Y/N) |
| --- | --- | --- |
| Display Name | test | N |
| Private Identity | 34020000001110000001 | Y |
| Public Identity | sip:34020000001110000001@192.168.1.140:5062 | Y |
| Password | 12345678 | N |
| Realm | 192.168.1.140 | Y |

- 配置`http://localhost:3000/`设置网关信息，具体值见下面的表格
  - 假定传统的 SIP 服务运行在 192.168.1.140 机器，端口是 5060(默认)
  - 假定 webrtc2sip 运行在 192.168.1.140 机器，端口是 10060(默认)

| 网关配置项 | 值 |
| --- | --- |
| WebSocket Server URL | ws://192.168.1.140:10060 |
| SIP outbound Proxy URL | udp://192.168.1.140:5060 |

- 会话配置 phonenumber 为 34020000001310000001

## 6 互操作性

- 建议使用 Chrome 的文档版本

### 6.1 关于服务

#### 6.1.1 Asterisk

- Asterisk 和 Chrome 在同时获得视频和音频时会有一些问题，解决方法有两种
  - 使能 RTCWeb Breaker(建议)
  - Patching Asterisk：当作为开发者且正在尝试学习新特性时使用。但是 Asterisk 不支持 VP8。打补丁的[教程参考](https://code.google.com/archive/p/sipml5/wikis/Asterisk.wiki)

#### 6.1.2 FreeSwitch

- FreeSwitch 不支持 ICE 和其他的 RTCWeb 特性
- 使能 RTCWeb Breaker 模块可以解决

### 6.2 关于 web 浏览器

#### 6.2.1 Chrome

- 建议使用稳定版本
- Chrome 使用 SAVPF 配置文件。S 即 secure(SRTP)，F 即 feedback。如果远端的 SIP 客户端/服务器不支持这些特性，需要使能 RTCWeb Breaker 模块（web 浏览器端）
- Chrome 只包含 VP8 视频编解码，但是大多数 SIP 客户端/服务器不支持。如果 SIP 客户端/服务器 支持 H.264，H.263，The偶然 或 MP4V-ES，那么需要使能 RTCWeb Breaker 和 Media Coder 模块
  - 注意：Media Coder 很可能在 sipml5.org 的服务上不能启用

#### 6.2.2 Firefox Nightly

- 目前只有 Firefox Nightly 原生支持 RTCWeb
- 关于 DTLS-SRTP 解码的 [issue](http://code.google.com/p/doubango/issues/detail?id=194)
- Firefox Nightly 使用 DTLS-SRTP 实现 RTCWeb，Chrome 使用 SDES-SRTP，因此在两个浏览器之间会话需要使能 RTCWeb Breaker 模块

#### 6.2.3 Firefox，Safari，IE 和 Opera

#### 6.2.4 Ericsson Bowser

- Ericsson Bowser 不支持 SRTP，且只有 H.264 视频编解码
- Ericsson Bowser 可以与大部分 SIP 客户端通信，但是和 Canary 及其他 RTCWeb 客户端不兼容
- 使能 RTCWeb Breaker(浏览器端) 可以支持 Bowser 与 Chrome 音频会话，因为 G.711 是一个普遍的编解码。需要支持视频的话，需要使能 Media Coder(服务器端)

## 7 安全问题

- 当在客户端(web 浏览器)使能 RTCWeb Breaker 模块，服务器会为所有到 web 浏览器收到的和传出去的 INVITE 请求承担 b2bua 的角色。这只适用于绑定到指定 web 浏览器的 SIP 账户
- 作为 b2bua 意味着为每个 INVITE 生成一个全新的请求。新的请求可能被远端的传统 SIP 网络认证，即 b2bua 必须持有 SIP 账户的鉴权信息

## 8 一些编译问题

### 8.1 webrtc2sip 编译出错

```sh
# Error: configure: error: Failed to find libtinyIPSec
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig"
# 编译 webrtc2sip
```

```sh
# mp_object.h:23:23: fatal error: tsk_debug.h: No such file or directory
make -I/usr/local/include/tinysak/
```

```sh
# /usr/bin/ld: webrtc2sip-sqlite3.o: undefined reference to symbol 'dlclose@@GLIBC_2.2.5'
# //lib/x86_64-linux-gnu/libdl.so.2: error adding symbols: DSO missing from command line
# collect2: error: ld returned 1 exit status
./configure --prefix=$PREFIX LDFLAGS='-ldl' LIBS='-ldl'
```

```sh
# /usr/local/lib/libtinyNET.so: undefined reference to `CT_POLICY_EVAL_CTX_set1_cert'
# /usr/local/lib/libtinyNET.so: undefined reference to `X509_get0_pubkey'
# /usr/local/lib/libtinyNET.so: undefined reference to `SM2_compute_share_key'
# /usr/local/lib/libtinyNET.so: undefined reference to `CRYPTO_THREAD_write_lock'
# /usr/local/lib/libtinyNET.so: undefined reference to `OPENSSL_sk_insert
# 检查 Doubango，重新编译
```

### 8.2 视频编解码崩溃

- 修改文件：`doubango/tinySAK/src/tsk_object.c`(199)
- 修改函数：`tsk_object_unref()`
- 修改内容：将 `tsk_object_delete(self);` 替换为 `TSK_OBJECT_SAFE_FREE(self);`

### 8.3 webrtc2sip 项目配置

- 操作系统配置：局域网使用时，将 DNS 配置清空

```sh
vim /etc/resolv.conf
# 注释掉下面的行
nameserver 172.17.192.21
```

- FreeSwitch 添加 H264 编码支持

```sh
vim freeswitch/conf/vars.xml
# <X-PRE-PROCESS cmd="set" data="global_codec_prefs=G722,PCMU,PCMA,GSM,H264"/>
# <X-PRE-PROCESS cmd="set" data="outbound_codec_prefs=PCMU,PCMA,GSM,H264"/>
```

### 8.4 关于 sipML5 服务

- [源码地址](https://github.com/DoubangoTelecom/sipml5)
- sipML5 服务连接失败，可能的原因和解决方案
  - 根本原因是没有连接上 webrtc2sip 或 FreeSwitch 服务
  - 可能原因1：网络中断。解决方法：恢复网络连接
  - 可能原因2：Linux 的防火墙阻止了webrtc2sip 和 FreeSwitch 服务，关闭防火强可以解决此类问题
- Sipml5连接无反应，可能的原因及解决方案
  - 可能的原因是 webrtc2sip 有问题，重新启动 webrtc2sip
- sipML5 与 Yealink 可视电话进行语音通话成功，但是视频通话呼叫方语音进入 echo 模式，视频不通，可能的原因及解决方案
  - 可能是 webrtc2sip 的配置中`<enable-media-coder>no</enable-media-coder>` 应该改成 yes
- webrtc2sip 启动自动退出，可能的原因及解决方案
  - 可能是配置中所设置的本地 IP 地址与服务器的 IP 地址不一致造成的。修改 IP 地址可以解决此问题

### 8.4.1 webrtc2sip 解析 sipML5 请求失败

- 注册配置中`Realm`配置成编号，修改成 IP 地址

```text
***[DOUBANGO ERROR]: function: "tsip_message_parse()"
file: "src/parsers/tsip_parser_message.c"
line: "226"
MSG: Failed to parse SIP message: /WS df7jal23ls0d.invalid;branch=z9hG4bKy6rW8Wp53Xb2ScABiUoaIJSmmfVGnfyi;rport
From: "test"<sip:34020000001310000001@192.168.1.140:5062>;tag=TvKDkETklspHcSTWievL
To: "test"<sip:34020000001310000001@192.168.1.140:5062>
Contact: "test"<sip:34020000001310000001@df7jal23ls0d.invalid;rtcweb-breaker=yes;transport=ws>;expires=200;click2call=no;+g.oma.sip-im;+audio;language="en,fr"
Call-ID: 5b7f4bd8-b0c2-1511-b1f1-2360114685dd
CSeq: 31494 REGISTER
Content-Length: 0
Route: <sip:192.168.1.140:5060;lr;sipml5-outbound;transport=udp>
Max-Forwards: 70
User-Agent: IM-client/OMA1.0 sipML5-v1.2016.03.04
Organization: Doubango Telecom
Supported: path


***[DOUBANGO ERROR]: function: "tsip_transport_layer_ws_cb()"
file: "src/transports/tsip_transport_layer.c"
line: "632"
MSG: Failed to parse SIP message
```

### 8.5 关于 Chrome 使用

- Chrome 浏览器呼叫时出现 “Media stream permission denied”
  - 可能原因1：使用本地网页访问时容易出现这样的问题。请使用网址访问网站上的网页
  - 可能原因2：如果是询问时禁止访问了麦克风和摄像头，请关闭 Chrome，重启
    - 如果是 chrome for Android，到应用管理里，清除所有数据
- Chrome 浏览器主叫，被叫方隔很长时间才振铃
  - 很有可能是 webrtc2sip 所在的服务器设置了 DNS，删除 DNS

### 8.6 守护进程

- 使用守护进程，当 webrtc2sip 服务崩溃时，自动重启该服务
- 使用进程守护者[process-monitor](https://github.com/russells/process-monitor)
  - 拷贝二进制文件 process-monitor 到 webrtc2sip 的 sbin 目录
  - 执行命令 `./process-monitor webrtc2sip`

## 9 运行问题

### 9.1 ERR_SSL_VERSION_OR_CIPHER_MISMATCH

- sipML5 报错：Error in connection establishment: net::ERR_SSL_VERSION_OR_CIPHER_MISMATCH
- webrtc2sip 报错：Remote party requesting DTLS-DTLS (UDP/TLS/RTP/SAVPF) but this option is not enabled
  - <https://github.com/DoubangoTelecom/webrtc2sip/blob/master/FAQ.md#i-see-remote-party-requesting-dtls-dtls-udptlsrtpsavpf-but-this-option-is-not-enabled-how-can-i-fix-this>
  - <https://stackoverflow.com/questions/36293964/dtls-dtls-is-not-enabled>

## 10 参考

- [webrtc2sip - Building_Source_v2_0.wiki](https://code.google.com/archive/p/webrtc2sip/wikis/Building_Source_v2_0.wiki)
- [ice](https://doc.zeroc.com/ice/3.7/introduction)
- [WebRTC tutorial using SIPML5](https://wiki.asterisk.org/wiki/display/AST/WebRTC+tutorial+using+SIPML5)