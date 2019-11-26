# Janus 模块

[参考](https://janus.conf.meetecho.com/docs/modules.html)

```text
core              服务的核心实现
  protocol            WebRTC 协议的实现
plugin            外部可访问的 Janus 插件
  plugin API          插件 API(即如何编写插件)
  Lua plugin API      Lua 插件(即如何使用 Lua 编写插件)
  Duktape plugin API  Duktape 插件(即如何使用 JavaScript 编写插件)
transport         外部可访问的传输插件
  transport API       传输 API(即如何编写传输插件)
event handler     外部可访问的事件句柄插件
  event handler API   事件句柄 API(即如何编写事件句柄插件)
tools/utilities   工具和辅助函数
  recordings post-processing utility 后期处理录像的工具
```
