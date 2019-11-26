# janus plugin 开发

- [janus plugin 开发](#janus-plugin-%e5%bc%80%e5%8f%91)
  - [概念](#%e6%a6%82%e5%bf%b5)
  - [plugin.h](#pluginh)
    - [使用 janus_callback 转发数据给浏览器](#%e4%bd%bf%e7%94%a8-januscallback-%e8%bd%ac%e5%8f%91%e6%95%b0%e6%8d%ae%e7%bb%99%e6%b5%8f%e8%a7%88%e5%99%a8)
    - [插件需要实现 janus_plugin 接口](#%e6%8f%92%e4%bb%b6%e9%9c%80%e8%a6%81%e5%ae%9e%e7%8e%b0-janusplugin-%e6%8e%a5%e5%8f%a3)
    - [注意](#%e6%b3%a8%e6%84%8f)

## 概念

```text
JSEP
  JavaScript session establishment protocol, JavaScript 会话建立协议议，是一个信令 API。
  JSEP 一方面提供接口如 `createOffer` 供 web 应用程序调用生成 SDP，另一方面提供 ICE 功能接口。这些功能都由浏览器实现。
  JSEP 不是信令协议，可在 JSEP 基础上引入 SIP 等信令协议。
SCTP
  stream control transmission protocol, 流控制传输协议，是一种在网络连接两端之间同时传输多个数据流的协议。
NACK
  negative acknowledgment, 否定应答或非应答，用于数字通信中确认数据收到但是有小错误。表示需要重新发送。
SSL/TLS
  socket security layer/transport layer security, 这两者没有本质的区别，都是传输层之上的加密(介于传输层及应用层之间)。TLS 是后续 SSL 版本分支的名称。TLS 在 TCP 传输协议之上。
DTLS
  datagram transport layer security, 数据包传输层安全性协议。提供了 UDP 传输场景下的安全解决方案，能防止消息被窃听、篡改、身份冒充等问题。
ICE
  interactive connectivity establishment, 互动式连接建立，使各种 NAT 穿透技术可以实现统一。
NAT
  network address translation, 网络地址转换。当专用网内部的一些主机本来已经分配到了本地 IP 地址(即仅在本专用网内使用的专用地址)，但又想和因特网上的主机通信(并不需要加密)时，可使用 NAT 方法。
  这种方法需要在专用网连接到因特网的路由器上安装 NAT 软件。装有 NAT 软件的路由器叫做 NAT 路由器，它至少有一个有效的外部全球 IP 地址。这样，所有使用本地地址的主机在和外界通信时，都要在 NAT 路由器上将其本地地址转换成全球 IP 地址，才能和因特网连接。
  这种通过使用少量公有 IP 地址代表较多私有 IP 地址的方式，将有助于减缓可用的 IP 地址空间的枯竭。
STUN
  session traversal utilities for nat, NAT 会话穿越应用程序。是一种网络协议，它允许位于 NAT (或多重 NAT )后的客户端找出自己的公网地址，查出自己位于哪种类型的 NAT 之后以及 NAT 为某一个本地端口所绑定的 Internet 端口。这些信息被用来在两个同时处于 NAT 路由器之后的主机之间创建 UDP 通信。
TURN
  traversal using relay nat， 一种数据传输协议(data-transfer protocol)。允许在 TCP 或 UDP 连线上跨越 NAT 或防火墙。
  TURN 是一个 C/S 协议。TURN 的 NAT 穿透方法与 STUN 类似，都是通过取得应用层中的公有地址达到 NAT穿透。但实现 TURN client 的终端必须在通讯开始前与 TURN server 进行交互，并要求 TURN server 产生 "relay port", 也就是 relayed-transport-address。这时 TURN server 会建立 peer, 即远端端点(remote endpoints), 开始进行中继(relay)的动作，TURN client 利用 relay port 将数据传送至 peer, 再由 peer 传到另一方的 TURN client。
```

## plugin.h

### 使用 janus_callback 转发数据给浏览器

头文件包含了回调函数的定义，这是 janus core 和所有插件互相交互需要实现的函数。头文件中也定义通信相关的结构。

一般的，janus core 实现了 `janus_callback` 接口。因此，插件可以使用 core 暴露的一些方法调用 core，比如转发一个消息、时间或 RTP/RTCP 包给正在处理的 peer。暴露给插件的方法有：

- `push_event()`: 给 peer 发送/转发一个 JSON 消息/事件(用或不予一个附带的 JSEP 格式的 SDP 来协商一个 WebRTC PeerConnection)；消息/事件的语法可以自己定义，但是必须是一个 JSON 对象，因为它会被包含在 janus 的会话/句柄协议中。
- `relay_rtp()`: 给 peer 发送/转发一个 RTP 包。
- `relay_rtcp()`: 给 peer 发送/转发一个 RTCP 包。
- `relay_data()`: 给 peer 发送/转发一个 SCTP/DataChannel 消息。

```h
// 与 janus core 通信的回调函数
struct janus_callbacks {
  // 给 peer 推送一个消息/事件的回调函数。janus core 会增加消息和 jsep 对象的引用。因此调用 push_event 之后需要手动调用 json_decref 减小引用
  int (* const push_event)(janus_plugin_session *handle, janus_plugin *plugin, const char *transaction, json_t *message, json_t *jsep);

  // 给 peer 转发一个 RTP 包的回调函数
  void (* const relay_rtp)(janus_plugin_session *handle, int video, char *buf, int len);
  // 给 peer 转发一个 RTCP 消息的回调函数
  void (* const relay_rtcp)(janus_plugin_session *handle, int video, char *buf, int len);
  // 给 peer 转发一个 SCTP/DataChannel 消息的回调函数
  void (* const relay_data)(janus_plugin_session *handle, char *label, char *buf, int len);

  // 请求 core 关闭一个 WebRTC PeerConnection 的回调函数。调用此方法会导致关闭后 core 对插件调用 hangup_media 回调函数
  void (* const close_pc)(janus_plugin_session *handle);
  // 请求 core 去除一个插件/网关会话的回调函数。调用此方法会导致去除后 core 对插件调用 destroy_session 回调函数
  void (* const end_session)(janus_plugin_session *handle);

  // 请求检查一个事件句柄机制是否启用。如果禁用返回 FALSE，表示不应调用 notify_event
  gboolean (* const events_is_enabled)(void);
  // 请求对注册和订阅的事件句柄发送一个事件通知。core 会取消引用事件对象
  void (* const notify_event)(janus_plugin *plugin, janus_plugin_session *handle, json_t *event);

  // 请求检查一个签名的 token 是否有效。如果签名有效且未过期返回 TRUE。只接受带有插件标识符的 token 作为域
  gboolean (* const auth_is_signature_valid)(janus_plugin *plugin, const char *token);
  // 请求检查一个签名的 token 是否授权访问一个描述子。如果签名有效、未过期且包含该描述子返回 TRUE。只接受带有插件标识符的 token 作为域
  gboolean (* const auth_signature_contains)(janus_plugin *plugin, const char *token, const char *descriptor);
};
```

### 插件需要实现 janus_plugin 接口

另一方面，想要注册到 janus core 的插件需要实现 `janus_plugin` 接口。此外，因为插件是一个共享的对象，且对 core 本身是外部的，为了在启动时动态加载需要插件实现 `create_p()` 钩子，接口应该返回指向插件实例的一个指针。步骤示例：

```c
static janus_plugin myplugin = {
    [..]
};

janus_plugin *create(void) {
    JANUS_LOG(LOG_VERB, , "%s created!\n", MY_PLUGIN_NAME);
    return &myplugin;
}
```

这可以确保如果部署在合适的文件夹，插件在启动时被 janus core 加载。

正如上述例子预期和描述的，一个插件必须是 `janus_plugin` 类型的一个实例。即必须实现下面的方法和回调函数：

```h
// 插件的会话和回调函数接口
struct janus_plugin {
  // 插件的初始化/构造函数。如果出错返回负数。插件一启动 core 就会调用此函数，应在这里设置插件(比如静态信息或读配置文件)
  int (* const init)(janus_callbacks *callback, const char *config_path);
  // 插件的反初始化/析构函数
  void (* const destroy)(void);

  // 信息方法，请求插件编译的 API 版本。必须返回 JANUS_PLUGIN_API_VERSION
  int (* const get_api_compatibility)(void);
  // 信息方法，请求插件的数字版本号，如 3
  int (* const get_version)(void);
  // 信息方法，请求插件的字符串版本号，如 "v1.0.1"
  const char *(* const get_version_string)(void);
  // 信息方法，请求插件的描述字符串，如 "This is my awesome plugin that does this and that"
  const char *(* const get_description)(void);
  // 信息方法，请求插件的名字，应是一个简短的显示名，如 "My Awesome Plugin"
  const char *(* const get_name)(void);
  // 信息方法，请求插件的作者
  const char *(* const get_author)(void);
  // 信息方法，请求插件的包名，这是 web 应用引用插件使用的名字，应是唯一的标识，如 "janus.plugin.myplugin"
  const char *(* const get_package)(void);

  // 为 peer 创建一个新的会话/句柄
  void (* const create_session)(janus_plugin_session *handle, int *error);
  // 处理来自 peer 的新消息/请求。是通知 peer 发送了一个消息/请求的回调函数
  struct janus_plugin_result * (* const handle_message)(janus_plugin_session *handle, char *transaction, json_t *message, json_t *jsep);
  // 处理 Admin API 的新消息/请求。是通知 Admin API 发送了一个消息/请求的回调函数
  struct json_t * (* const handle_admin_message)(json_t *message);
  // 通知关联的 PeerConnection 已经就绪的回调函数
  void (* const setup_media)(janus_plugin_session *handle);
  // 处理来自 peer 的新 RTP 包。是通知 peer 发送了一个 RTP 包的回调函数
  void (* const incoming_rtp)(janus_plugin_session *handle, int video, char *buf, int len);
  // 处理来自 peer 的新 RTCP 包。是通知 peer 发送了一个 RTCP 包的回调函数
  void (* const incoming_rtcp)(janus_plugin_session *handle, int video, char *buf, int len);
  // 处理来自 peer 的新 SCTP/DataChannel 数据(暂时只支持文本)。是通知 peer 在 SCTP DataChannel 发送了一个消息的回调函数。DataChannel 发送的不带结束符的字符串，需要手动使用 \0 终止
  void (* const incoming_data)(janus_plugin_session *handle, char *label, char *buf, int len);
  // 当 janus 发送或收到太多 NACK 时 core 通知的回调函数。这意味着 peer 的网络是慢的且可能不可靠的。
  void (* const slow_link)(janus_plugin_session *handle, int uplink, int video);
  // 通知 peer 的 DTLS 警告(比如 PeerConnection 不再有效)的回调函数
   * @param[in] handle The plugin/gateway session used for this peer */
  void (* const hangup_media)(janus_plugin_session *handle);
  // 销毁 peer 的一个会话/句柄
  void (* const destroy_session)(janus_plugin_session *handle, int *error);
  // 获取指定插件的一个会话/句柄的信息。不要返回常量
  json_t *(* const query_session)(janus_plugin_session *handle);
};
```

上述所有方法和回调函数，除了 `incoming_rtp`/`incoming_rtcp`/`incoming_data`/`slow_link`，都必须实现：janus core 会拒绝没有实现这些回调函数的插件。`incoming_rtp`/`incoming_rtcp`/`incoming_data`/`slow_link` 是可选的，可以实现自己关心的。比如，如果插件不会处理任何数据通道，那么不是想 `incoming_data` 回调函数是有意义的。同时，如果你的插件值打算使用数据通道，不关心 RTP 或 RTCP，`incoming_rtp` 和 `incoming_rtcp` 可以不实现。最后，`slow_link` 只是一个辅助函数，可以得到一些感兴趣的附加信息。

janus core 提供 `janus_callback` 接口给插件，在 `init` 方法中提供配置文件的路径。路径可用于读入和解析插件的配置文件：实现即可用的插件使用包名作为配置文件名称(比如 `janus.plugin.echotest.cfg` 作为 Echo Test 插件的配置文件名)，也可以指定其他不冲突的名字。此外，现有的插件使用相同的 INI 格式作为 core 使用的配置文件格式(依赖于 `janus_config`)，也可以使用其他不同格式( XML/JSON 等)。

janus core 和插件都可以和相同或不同 peer 有多个不同的会话：插件可依赖 janus_plugin_seesion 映射来匹配一个会话，这是插件和 core 通信(即 core 和插件调用的回调函数)会使用的。`janus_videoroom.c` 是一个 peer 关联多个句柄的示例。

插件发送和接收的所有消息/请求/时间是异步的，比如不能立即回复浏览器发送的一些消息。但是在 `handle_message` 回调函数中，来自浏览器的消息/请求都有一个事务标识符，如果有需要，你可以在 `push_event` 回复中使用它以便浏览器匹配原来的请求。

`handle_message` 和 `push_event` 都可以附加一个 JSEP/SDP 载荷。这意味着一个浏览器可以携带一个 JSEP/SDP offer 和插件协商 WebRTC PeerConnection：插件就需要提供，即时或异步，一个 JSEP/SDP answer。同时，一个插件可能想发起一个会话：这种情况下，一个插件会在 `push_event` 调用中携带一个 JSEP/SDP offer，那么浏览器需要回复一个 JSEP/SDP answer。也可使用相同的机制重新协商一个会话：万一插件想强制一个 ICE 宠物，它们必须在发送给 core 之前增加一个 `restart` 属性到 JSEP 对象。无论何时远端用户请求重新协商，core 会增加 `update` 属性，不管是 ICE 重启还是一些媒体相关的改变。

### 注意

janus core 本身会实现 WebRTC PeerConnection 设置，包括 ICE/DTLS/RTP/RTCP，插件实际是控制媒体流的，因此需要插件关注 JSEP/SDP offer/answer 中的编解码协商。如果插件会生成媒体帧，你只支持一些编解码器或你想在不同会话中使用相同的 SDP offer，你需要确保你的 offer/answer 不会包含你不支持的内容。此外，你也需要确保你一致地使用 SDP 提供的信息(如负载类型、重新协商时增加版本)。
