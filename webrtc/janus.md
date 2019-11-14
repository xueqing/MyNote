# janus 学习

- [janus 学习](#janus-%e5%ad%a6%e4%b9%a0)
  - [简述](#%e7%ae%80%e8%bf%b0)
  - [设计思想](#%e8%ae%be%e8%ae%a1%e6%80%9d%e6%83%b3)
  - [安装](#%e5%ae%89%e8%a3%85)
    - [安装问题](#%e5%ae%89%e8%a3%85%e9%97%ae%e9%a2%98)
  - [配置](#%e9%85%8d%e7%bd%ae)
  - [运行服务](#%e8%bf%90%e8%a1%8c%e6%9c%8d%e5%8a%a1)
    - [运行 demo 服务测试](#%e8%bf%90%e8%a1%8c-demo-%e6%9c%8d%e5%8a%a1%e6%b5%8b%e8%af%95)
    - [运行 Echo Test](#%e8%bf%90%e8%a1%8c-echo-test)

## 简述

janus 可以与内网设备和浏览器同时建立连接，并将浏览器发来的音视频数据包(如 RTP/RTCP 包)，通过自定义插件转发给内网设备，也可以将发给 janus 的音视频数据包，加密后转发给浏览器。

janus 实现了与浏览器建立会话的逻辑，并提供插件机制来处理音视频数据。

janus 一般用于拓展已有的视频会议系统，提供对浏览器客户端的支持。

## 设计思想

janus 基于插件思想，实现了基础架构，与浏览器建立连接。

janus 的插件需要实现一些必须的函数，比如 RTP/RTCP 数据的接收等。

可以自定义插件，完成将浏览器数据转发到内网服务器的业务逻辑。

## 安装

环境：ubuntu16.04

```sh
# 安装依赖
sudo apt-get install aptitute
sudo aptitute install libmicrohttpd-dev libjansson-dev \
  libssl-dev libsrtp-dev libsofia-sip-ua-dev libglib2.0-dev \
  libopus-dev libogg-dev libcurl4-openssl-dev liblua5.3-dev \
  libconfig-dev pkg-config gengetopt libtool automake
# 安装 libnice
sudo apt-get install libnice-dev
# 手动安装 libnice
#git clone https://gitlab.freedesktop.org/libnice/libnice
#cd libnice
#./autogen.sh
#./configure --prefix=/usr
#make && sudo make install
# 安装 libsrtp 2.0
wget https://github.com/cisco/libsrtp/archive/v2.0.0.tar.gz
tar xfv v2.0.0.tar.gz
cd libsrtp-2.0.0
# 配置和编译
./configure --prefix=/usr --enable-openssl
make shared_library && sudo make install
# 编译安装 janus
git clone https://github.com/meetecho/janus-gateway.git
cd janus-gateway
# 生成配置文件
sh autogen.sh
./configure --prefix=/opt/janus
make
sudo make install
# janus 安装到了/opt/janus 目录
# 生成默认配置文件。重复执行此命令会覆盖可能的修改
sudo make configs
```

配置命令支持的参数查看 `./configure --help`。

```sh
# 已安装但不使用相关库
./configure --disable-websockets --disable-data-channels --disable-rabbitmq --disable-mqtt
# 编译文档。需要安装 doxygen 和 graphviz
#aptitude install doxygen graphviz
./configure --enable-docs
```

### 安装问题

手动安装 libnice 遇到 `./autogen.sh: 26: ./autogen.sh: gtkdocize: not found` 问题的解决方案：

```sh
#安装 gtkdocize
sudo apt-get install gtk-doc-tools
```

## 配置

可以编辑配置文件 `/opt/janus/etc/janus/janus.jcfg`，或者使用命令行

```sh
/opt/janus/bin/janus --help
# Compiled on:  Thu Nov 14 16:48:17 CST 2019
# janus 0.7.6
# Usage: janus [OPTIONS]...
```

通过命令行传递的选项比配置文件指定的值优先级更高。

## 运行服务

直接运行可执行文件

```sh
# 使用默认配置文件启动服务
/opt/janus/bin/janus
```

直接启动会报错

```text
Loading plugin 'libjanus_voicemail.so'...
[ERR] [plugins/janus_voicemail.c:janus_voicemail_init:352] Permission denied[WARN] The 'janus.plugin.voicemail' plugin could not be initialized
```

原因是之前使用的 `root` 权限安装的，使用 `sudo chown -R kiki:kiki /opt/janus/` 修改文件夹权限即可。

### 运行 demo 服务测试

测试 janus 是否正常工作，可以使用 `html` 文件夹下的 demo。需要在浏览器打开测试网页，需要一个 HTTP 服务器。

可以使用 Python 开启一个简单的 HTTP 服务：

```sh
# 切换到工程的 html 目录
cd html
python -m http.server
# Serving HTTP on 0.0.0.0 port 8000 ...
```

监听端口是 `8000`。现在在浏览器打开 `localhost:8000`，可以看到 janus 的官网。

### 运行 Echo Test

Echo Test demo 会发送收到的内容作为回复，发送给 janus 的音视频会返回给自己。

demo 提供了一些发送之前对媒体的控制。比如，可以关掉音频或视频，告诉服务器丢掉这些帧不用返回。可以在页面的 URL 之后添加 `?simulcast=true`，重新加载页面之后可以测试联播，可以切换不同画质的视频。

首先确保有摄像头和麦克风，选择上一章节打开的网页 `localhost:8000` 中的 `Demos >> Echo Test`，点击 `Start` 运行程序。

遇到问题 `Probably a network error, is the server down?: [object Object]` 是因为关掉了 janus 服务，需要打开服务 `/opt/janus/bin/janus`。

遇到 DataChannel 消息框不能编辑的问题是因为没有配置 DataChannel。需要安装 usrsctp。

```sh
git clone https://github.com/sctplab/usrsctp
cd usrsctp
./bootstrap
./configure --prefix=/usr && make && sudo make install
# 重新编译安装 janus 服务
./configure --prefix=/opt/janus
# 可以看到 DataChannels support:      yes
make && make install
```

Echo Test 对应的插件源码为 `plugins/janus_echotest.c`。

通过阅读 `plugins/plugin.h` 中的注释，可以基本了解插件编写的规则。
