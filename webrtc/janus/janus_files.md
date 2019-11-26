# Janus 源码目录结构

[参考](https://janus.conf.meetecho.com/docs/files.html)

## 目录

### conf 配置文件

```text
janus.eventhandler.xxx.jcfg.sample  事件句柄(MQTT/Nanomsg/RabbitMQ/WebSockets)
janus.jcfg.sample.in                通用配置：配置文件和插件位置；日志输出格式；Janus 运行方式；默认接口；调试/日志等级；鉴权机制等
janus.plugin.xxx.jcfg.sample[.in]   插件
janus.transport.xxx.jcfg.sample     传输插件(HTTP webserver/MQTT/Nanomsg/Unix Sockets/RabbitMQ/WebSockets)
```

### docs 文档

### events 事件

```text
eventhandler.h        Janus event 句柄模块
janus_mqttevh.c       Janus MQTTEventHandler 插件
janus_nanomsgevh.c    Janus NanomsgEventHandler 插件
janus_rabbitmqevh.c   Janus RabbitMQEventHandler plugin
janus_sampleevh.c     Janus 示例 EventHandler 插件插件
janus_wsevh.c         Janus WebSockets EventHandler 插件
```

### fuzzers 模糊测试工具

```text
  corpora/        对应测试文件
  engines/        测试引擎
  build.sh
  config.sh
  rtcp_fuzzer.c
  rtp_fuzzer.c
  run.sh
  sdp_fuzzer.c
```

### html 静态网页

呈现 https://janus.conf.meetecho.com/docs/

### npm

### plugins 插件

```text
duktape/      Duktape JavaScript 封装
duktape-deps/ Duktape 库和依赖源码
lua/          Lua 语言常用工具函数以及实现的应用示例
recordings/   录像文件(.nfo 或.mjr)
streams/      流文件
janus_xxx.c
  janus_audiobridge.c   Janus AudioBridge 插件
  janus_duktape.c       Janus JavaScript 插件(通过 Duktape)
  janus_duktape_data.h  Janus Duktape 数据/会话定义
  janus_duktape_extra.c(h) Janus Duktape 插件其他钩子
  janus_echotest.c      Janus EchoTest 插件
  janus_lua.c           Janus Lua 插件
  janus_lua_data.h      Janus Lua 数据/会话定义
  janus_lua_extra.c(h)  Janus Lua 插件其他钩子
  janus_nosip.c         Janus NoSIP 插件
  janus_recordplay.c    Janus 录像和播放插件
  janus_sip.c           Janus SIP 插件
  janus_sipre.c         Janus SIPre 插件 (libre)
  janus_streaming.c     Janus Streaming 插件
  janus_textroom.c      Janus TextRoom 插件
  janus_videocall.c     Janus VideoCall 插件
  janus_videoroom.c     Janus VideoRoom 插件
  janus_voicemail.c     Janus VoiceMail 插件
plugin.c(h)   插件和 Core 通信
```

### postprocessing 后期处理工具函数

```text
janus-pp-rec.1
janus-pp-rec.c    后期处理 Janus 保存的 .mjr 录像文件的简单工具函数
janus-pp-rec.ggo
mjr2pcap.1
mjr2pcap.c        将 Janus .mjr 录像文件转换为 .pcap 文件的帮助工具
pp-g711.c(h)      后期处理生成 .wav 文件
pp-g722.c(h)      后期处理 G.722 生成 .wav 文件
pp-h264.c(h)      后期处理生成 .mp4 文件
pp-opus-silence.h 一个只包含 silence 的示例 Opus 包
pp-opus.c(h)      后期处理生成 .opus 文件
pp-rtp.h          后期处理 RTP 的辅助数据结构
pp-srt.c(h)       后期处理生成 .srt 文件
pp-webm.c(h)      后期处理生成 .webm 文件
```

### transports 传输

```text
janus_http.c          Janus RESTs 传输插件
janus_mqtt.c          Janus MQTT 传输插件
janus_nanomsg.c       Janus Nanomsg 传输插件
janus_pfunix.c        Janus Unix Sockets 传输插件
janus_rabbitmq.c      Janus RabbitMQ 传输插件
janus_websockets.c    sJanus WebSockets 传输插件
transport.c(h)    Janus 传输 API 模块
```

## 文件

```text
apierror.c(h)     Janus API 错误码定义
auth.c(h)         请求鉴权Requests authentication
autogen.sh
bower.json
config.c(h)       配置文件解析
configure.ac
debug.h           日志和调试
dtls-bio.c(h)     OpenSSL BIO 代理 writer
dtls.c(h)         DTLS/SRTP 处理
emacs.el
events.c(h)       event 句柄通知
ice.c(h)          ICE/STUN/TURN 处理
ip-utils.c(h)     IP 地址相关的工具函数
janus-cfgconv.1
janus-cfgconv.c   将 Janus .cfg 文件和 .jcfg 文件相互转换的简单工具函数
janus-valgrind.supp
janus.1
janus.c(h)        Janus core
janus.ggo
log.c(h)          带缓冲的日志
mach_gettime.h
mainpage.dox
mutex.h           信号量、互斥锁和条件变量
package.json
record.c(h)       音频/视频录像
refcount.h        引用计数机制
rtcp.c(h)         RTCP 处理
rtp.c(h)          RTP 处理
rtpsrtp.h         SRTP 定义
sctp.c(h)         SCTP 数据通道处理
sdp-utils.c(h)    SDP 工具函数
sdp.c(h)          SDP 处理
text2pcap.c(h)    导出 RTP/RTCP 包为 text2pcap 或 pcap 格式
turnrest.c(h)     TURN REST API 客户端
utils.c(h)        工具和帮助函数
version.h         Janus GitHub 版本
```
