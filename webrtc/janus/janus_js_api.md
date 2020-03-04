# janus JavaScript API

- [janus JavaScript API](#janus-javascript-api)
  - [概念](#%e6%a6%82%e5%bf%b5)
  - [JavaScript API](#javascript-api)
    - [使用 JavaScript API 注意](#%e4%bd%bf%e7%94%a8-javascript-api-%e6%b3%a8%e6%84%8f)
  - [使用 janus.js](#%e4%bd%bf%e7%94%a8-janusjs)
    - [使用 janus.js 注意](#%e4%bd%bf%e7%94%a8-janusjs-%e6%b3%a8%e6%84%8f)
    - [创建会话](#%e5%88%9b%e5%bb%ba%e4%bc%9a%e8%af%9d)
    - [绑定到插件](#%e7%bb%91%e5%ae%9a%e5%88%b0%e6%8f%92%e4%bb%b6)
    - [Handle 对象](#handle-%e5%af%b9%e8%b1%a1)
    - [PeerConnection 协商](#peerconnection-%e5%8d%8f%e5%95%86)
  - [更新一个已有的 PeerConnection (重新协商)](#%e6%9b%b4%e6%96%b0%e4%b8%80%e4%b8%aa%e5%b7%b2%e6%9c%89%e7%9a%84-peerconnection-%e9%87%8d%e6%96%b0%e5%8d%8f%e5%95%86)
  - [janus.js](#janusjs)

## 概念

```text
DTMF
  dual tone multi frequency, 双音多频，由高频群和低频群组成，高低频群各包含 4 个频率。一个高频信号和一个低频信号叠加组成一个组合信号，代表一个数字。DTMF 信号有 16 个编码。利用 DTMF 信令可选择呼叫相应的对讲机。
DTLS
  datagram transport layer security, 数据包传输层安全性协议。提供了 UDP 传输场景下的安全解决方案，能防止消息被窃听、篡改、身份冒充等问题。
```

## JavaScript API

假设已经编译了 HTTP 传输，janus 暴露一个伪 RESTful 接口，以及可选的 WebSocket/RabbitMQ/MQTT/Nanomsg/UnixSockets 接口，所有这些都基于 JSON 消息。这些接口都支持客户端利用 janus 提供的特性和插件提供的功能。考虑到大部分客户端会是 web 浏览器，一个常见的选择是依靠 REST 或 WebSocket。为了方便 web 开发者使用，JavaScript 库 (`janus.js`) 使用了相同的 API，可以通过该库使用 REST 或 WebSocket 接口。

这个库已经实现了与 janus core 建立会话、将 WebRTC 用户绑定到插件、发送和接收请求和事件到插件等等。注意 `janus.js` 库使用了 `webrtc-adapter` 的特性，所以你的 web 应用应该总包含它作为依赖。

### 使用 JavaScript API 注意

当前的 `janus.js` 库允许你提供对一些依赖的自定义实现，以便更容易与其他 JavaScript 库和框架整合。使用这个特性你可以确保 `janus.js` 没有(隐式)依赖一些全局变量。`janus.js` 实现了两种：

- `Janus.useDefaultDependencies` 依赖原始的浏览器 API，因此要求比较新的浏览器。
- `Janus.useOldDependencies` 使用 JQuery，应该提供和之前版本等价的行为。

默认使用 `Janus.useDefaultDependencies`，但是初始化 janus 库的时候可以通过传递一个自定义依赖对象覆盖它。

一般来说，当使用 janus 特性时，你通常做下面的事情：

1. 包含 janus JavaScript 库到你的 web 页面；
2. 初始化 janus JavaScript，且(可选地)传递它的依赖；
3. 连接到服务器并创建一个会话；
4. 创建一个或多个句柄以绑定到一个插件(比如 Echo Test 和/或 Streaming)；
5. 和插件交互(发送/接收消息，协商一个 PeerConnection)；
6. 最后，关闭所有的句柄，并关闭相关的 PeerConnection；
7. 销毁所有会话。

上述步骤要按序出现，描述了你可以如何使用底层的 API 来完成它们。

## 使用 janus.js

第一步，你应该在你的工程中包含这个 janus 库。视你的需求而定，你可以使用 `janus.js` 或生成的模块变量。

```js
<script type="text/javascript" src="janus.js" ></script>
```

JavaScript API 的核心是 `Janus` 对象。需要在第一个使用它的页面中初始化此对象。可以使用对象的静态 `init` 方法，接受下面的选项：

- `debug`: 是否在 JavaScript 控制台启用调试，以及调试等级
  - `true`/`all`: 启用所有调试器 (Janus.trace/Janus.debug/Janus.log/Janus.warn/Janus.error)
  - 数组(如 `["trace", "warn"]`): 只启用选中的调试器(支持的标记：trace/debug/log/warn/weeor)
  - `false`: 禁用所有调试器
- `callback`: 一个用户提供的函数，当完成初始化的时候调用
- `dependencies`: 一个用户提供的关于 janus 库依赖的实现

示例：

```js
Janus.init({
   debug: true,
   dependencies: Janus.useDefaultDependencies(), // 或使用 Janus.useOldDependencies() 获取之前的 janus 版本的行为
   callback: function() {
           // Done!
   });
```

### 使用 janus.js 注意

当使用 `janus.js` 的 JavaScript 模块变量时，你需要首先从模块导入 `Janus` 符号。比如，使用 ECMAScript 模块变量，上述示例应改为：

```js
import * as Janus from './janus.es.js'

Janus.init({
   debug: true,
   dependencies: Janus.useDefaultDependencies(), // 或使用 Janus.useOldDependencies() 获取之前的 janus 版本的行为
   callback: function() {
           // 完成!
   });
});
```

### 创建会话

一旦初始化库，你可以开始创建会话。通常，每个浏览器 tab 会需要和服务器的一个单独会话。实际上，每个 janus 会话可以同时包含多个不同的插件句柄，意味着你可以使用相同的 janus 会话为同一用户启动与相同或不同的插件的多个不同的 WebRTC 会话。也就是说，如果喜欢，你可以在相同页面设置不同的 janus 会话。

创建一个会话非常简单。你只需要使用 `new` 构造函数创建一个新的 `Janus` 对象，这个对象会处理和服务器的交互。考虑到 janus 会话的动态和异步特点(事件可以随时发生)，创建会话时你可以配置一些属性和回调函数：

- `server`: 服务器地址，可以是一个指定地址(如普通的 HTTP API 使用 `http://yourserver:8088/janus`，WebSocket 使用 `ws://yourserver:8088/`)或一个地址数组，支持在设置失败或故障转移的时候自动按序尝试
- `iceServers`: 一个使用的 STUN/TURN 服务器列表(如果跳过此属性会使用默认的 STUN 服务器)。
- `ipv6`: 是否应该收集 IPv6 candidate
- `withCredentials`: XHR 请求的 `withCredentials` 属性是否应该启用(默认是 `false`，且只有使用 HTTP 传输有效，WebSocket 会忽略)
- `max_poll_events`: polling 时应该返回的事件数目；默认是 1 (polling 返回一个对象)，传递一个更大的数字会使后端返回一组对象(因为只与长 polling 有关，只有使用 HTTP 传输有效，WebSocket 会忽略
- `destroyOnUnload`: 调用 `onbeforeunload` 时，是否应该自动销毁或通过 janus API 销毁会话(默认为 `true`)
- `token`/`apisecret`: 可选参数，只有认证 janus API 时需要。
- 关于事件通知的一系列回调函数：
  - `success`: 会话成功创建，且已就绪
  - `error`: 会话没有成功创建
  - `destroyed`: 会话被销毁，且不能再使用

这些属性和回调函数作为一个参数对象的属性传递给方法：也就是说，`Janus` 构造函数接收一个单一的参数，但是作为所有可用选项的容器。`success` 回调函数是开始应用的逻辑，比如绑定 peer 到一个插件并开始一个媒体会话。示例：

```js
var janus = new Janus(
    {
        server: 'http://yourserver:8088/janus',
        success: function() {
            // 完成! 绑定到插件 XYZ
        },
        error: function(cause) {
            // 出错，不能再继续...
        },
        destroyed: function() {
            // 我应该移除这个
        }
    });
```

服务器可以是一个指定的地址：

```js
var janus = new Janus(
    {
        server: 'http://yourserver:8088/janus',
            // 或
        server: 'ws://yourserver:8188/',
        [..]
```

或者是一个地址数组。当你想要库先检查 WebSocket 服务是否可用，不可用的话使用普通的 HTTP，或者只是提供故障转移的多个链接实例时是很有用的。有一个实例演示如何传递“尝试 WebSocket 失败的话使用 HTTP ”数组：

```js
var janus = new Janus(
    {
        server: ['ws://yourserver:8188/','http://yourserver:8088/janus'],
        [..]
```

### 绑定到插件

一旦创建 `Janus` 对象，这个对象表示和服务器的会话。你可以使用 `Janus` 对象用多种方式交互。一般的，定义了下面的属性和方法：

- `getServer()`: 返回服务器地址
- `isConnected()`: 如果 `Janus` 示例连接到服务器返回 `true`
- `getSessionId()`: 返回唯一的 Janus 会话标识符
- `attach(parameters)`: 绑定会话到一个插件，创建一个句柄；可以同时创建多个句柄到相同或不同的插件
- `destroy(parameters)`: 销毁和服务器的会话，并关闭会话和任意插件之间的所有句柄(和相关的 PeerConnection)

最重要的属性显然是 `attach()` 方法，因为它允许你利用插件的特性来控制 web 页面的 PeerConnection 发送和/或接收的媒体。这个方法会创建一个插件句柄，你可以使用它配置属性和回调函数。至于 `Janus` 构造函数，`attach()` 方法接收一个单一的参数，参数可以包含下面的属性和回调：

- `plugin`: 插件唯一的包名(比如 `janus.plugin.echotest`)
- `opaqueId`: 一个可选的字符串，对你的应用是有意义的(比如用来映射同一用户的所有句柄)
- 事件通知的一系列回调：
  - `success`: 句柄成功创建，且已就绪
  - `error`: 句柄没有成功创建
  - `consentDialog`: 这个回调在调用 `getUserMedia` 之前触发(参数=**true**)，且结束之后(参数=**false**)；这意味着你可用于相应地修改 UI，比如弹框提示用户需要接受设备访问同意的请求
  - `webrtcState`: 当从 Janus 角度，和一个句柄相关的 PeerConnection 变成活跃的(因此 ICE、DTLS 和其他所有都成功)，触发这个回调且值为 **true**，当 PeerConnection 宕掉时触发 **false**；用于发现你和 Janus 之间的 WebRTC 何时启动运行的(比如，用来通知一个用户在一个会议中是活跃的)；注意当 **false** 时可能会携带一个可选的参数表示原因的字符串
  - `iceState`: 当关联到这个句柄的 PeerConnection 的 ICE 状态改变时触发此回调：回调函数的参数是一个新状态的字符串(比如 “connected” 或 “failed”)
  - `mediaState`: 当 Janus 开始或停止接收你的媒体时触发这个回调：比如，`mediaState` 的参数为 `type=audio` 以及 `on=true` 意味着 Janus 开始接收你的音频流(或在停顿一秒或以上之后重新接收它们)；`mediaState` 的参数为 `type=video` 以及 `on=false` 意味着之前 Janus 检测到开始，在过去的一秒没有收到你的视频；用于发现何时 Janus 真正开始处理你的媒体，或检测媒体路径的问题(比如，媒体从未开始，或某时停止)
  - `slowLink`: 当 Janus 报告在指定的 PeerConnection 上发送或接受媒体的问题，一般是过去一秒收到/发送用户太多 NACK 的结果：比如，`slowLink` 的参数为 `uplink=true` 意味着你注意到来自 Janus 的一些缺失的包，`uplink=false` 意味着 Janus 没有收到你所有的包；用于发现何时媒体路径有问题(比如大量丢包)，以便可以做出反应(比如，如果丢失大部分包就降低码流)
  - `onmessage`: 收到插件的消息/事件
  - `onlocalstream`: 一个本地的 `MediaStream` 可用且已准备好展示
  - `onremotestream`: 一个远端的 `MediaStream` 可用且已准备好展示
  - `ondataopen`: 一个数据通道可用且已就绪
  - `ondata`: 已经通过数据通道收到数据
  - `oncleanup`: 和插件的 WebRTC PeerConnection 被关闭
  - `detached`: 插件句柄已经被插件本身解绑，因此不应该再使用

示例：

```js
// 使用先前创建的 janus 实例，绑定到 Echo Test 插件
janus.attach(
    {
        plugin: "janus.plugin.echotest",
        success: function(pluginHandle) {
            // 插件已绑定! 'pluginHandle' 是我们的句柄
        },
        error: function(cause) {
            // 不能绑定到插件
        },
        consentDialog: function(on) {
            // 比如，如果 on=true (即将执行 getUserMedia) 使屏幕变暗，否则恢复屏幕亮度
        },
        onmessage: function(msg, jsep) {
            // 我们收到来自插件的一个消息/事件 (msg)
            // 如果 jsep 不为 null, 这关联一个 WebRTC 协商
        },
        onlocalstream: function(stream) {
            // 我们有一个本地流 (getUserMedia 成功!) 要展示
        },
        onremotestream: function(stream) {
            // 我们有一个远端流 (PeerConnection 正常工作!) 要展示
        },
        oncleanup: function() {
            // 和这个插件的 PeerConnection 关闭，清除 UI
            // 插件句柄仍然有效，因此我们可以新建一个
        },
        detached: function() {
            // 和这个插件的 PeerConnection 关闭，移除它的特性
            //  插件句柄不再有效
        }
    });
```

### Handle 对象

因此 `attach()` 方法允许你绑定到一个插件，并指定调用的回调，当这次交互中相关的事件发生时调用这些回调。想要和差价积极交互，你可以使用 `Handle` 对象，它是 `success` 回调返回的(示例中是 `pluginHandle`)。

`Handle` 对象有一些方法，你可以使用这些方法和插件交互或检查会话句柄的状态：

- `getId()`: 返回唯一的句柄标识符
- `getPlugin()`: 返回绑定插件的唯一包名
- `send(parameters)`: 发送一个消息(携带或不携带 jsep 来协商一个 PeerConnection)给插件
- `createOffer(callbacks)`: 请求库创建一个 WebRTC 兼容的 OFFER
- `createAnswer(callbacks)`: 请求库创建一个 WebRTC 兼容的 ANSWER
- `handleRemoteJsep(callbacks)`: 请求库处理一个刚到的 WebRTC 兼容的会话描述
- `dtmf(parameters)`: 发送一个 DTMF tone 给 PeerConnection
- `data(parameters)`: 如果可用，通过数据通道发送数据
- `getBitrate()`: 获取当前接收的流的比特率的冗长描述
- `hangup(sendRequest)`: 告诉库关闭 PeerConnection；如果可选的 `sendRequest` 设置为 `true`，那么也发送一个 `hangup` Janus API 请求给 Janus (默认是禁用的，因为 Janus 一般可以通过 DTLS 警告类似的发现，但是有时启用是有用的)
- `detach(parameters)`: 从插件解绑，并销毁句柄，关闭相关存在的 PeerConnection

### PeerConnection 协商

虽然 `Handle` API 看起来有点复杂，一旦有了概念，它们实际上十分直白。唯一需要多一点努力理解的步骤是 PeerConnection 协商，但是如果你熟悉 WebRTC API，`Handle` 实际上使得协商过程非常简单。

用法背后的思路如下：

1. 使用 `attch()` 创建一个 `Handle` 对象；
2. 在 `success` 回调中，进入你的应用逻辑：你可能想发送一个消息给插件 (`send({msg})`)，立即与插件协商一个 PeerConnection (`createOfer` 之后调用 `send({msg, jsep})`) 或等待一些事情发生；
3. `onmessage` 回调告诉你何时从插件得到消息；如果 `jsep` 参数不为 null，只需要传递给库，库会处理参数；如果是一个 **OFFER** 使用 `createAnswer` (之后调用 `send({msg, jsep})` 关闭和插件的循环)，否则使用 `handleRemoteJsep`；
4. 无论是你还是插件发起设置一个 PeerConnection，`onlocalstream` 和/或 `onremotestream` 回调会提供流，你可以在页面展示它们；
5. 每个插件可能允许你控制什么应该流过 PeerConnection 通道：`send` 方法和 `onmessage` 回调会允许你处理这种交互(比如，告诉一个插件对你的流消音，或有人加入一个虚拟房间时通知你)，如果可用，无论何时通过数据通道收到数据触发 `ondata` 回调(且 `ondataopen` 回调会告诉你合适一个数据通道真的可用)。

下面的段落会进一步剖析 `Handle` API 提供的协商机制，尤其是描述相关的属性和回调。为了遵循 W3C WebRTC API 描述的方法，这个协商机制也主要基于异步方法。注意下面的段落描述协商第一步，即从开始创建一个新的 PeerConnection：要了解如何发起或处理一个重新协商(比如，增加/删除/替换一个媒体源，或强制一个 ICE 重启)，查看下面的“更新一个已有的 PeerConnection (重新协商)”章节。

- `createOffer` 接收一个单一的参数，可以包含下面的属性和回调：
  - `media`: 使用这个属性告诉库感兴趣的媒体(audio/video/data)，以及你是否要发送/接收它们；默认启用双向的音频和视频，禁用数据通道；这个选项是一个对象，可以接受下面的属性
    - `audioSend`: `true/false` (发送/不发送音频)
    - `audioRecv`: `true/false` (接收/不接收音频)
    - `audio`: `true/false` (接收和发送/不接收且不发送音频，比上述优先级高)
    - `audio`: 带有 `deviceId` 属性的对象(指定要捕获的音频设备的 ID，比上述优先级高；可以通过 `Janus.listDevices(callback)` 访问设备列表)
    - `videoSend`: `true/false` (发送/不发送视频)
    - `videoRecv`: `true/false` (接收/不接收视频)
    - `video`: `true/false` (接收和发送/不接收且不发送视频，比上述优先级高)
    - `video`: `"lowres"/"lowres-16:9"/"stdres"/"stdres-16:9"/"hires"/"hires-16:9"` (发送 320x240/320x180/640x480/640x360/1280x720 的视频，比上述优先级高；默认是 `"stdres"` )。这个属性会影响库调用 `getUserMedia` 的结果；注意 Firefox 不支持 `"16:9"` 变量；此外，`"hires"` 和 `"hires-16:9"` 目前是相同的，因为现在没有 4:3 高分辨率限制
    - `video`: `screen` (视频使用屏幕共享，禁用音频，比 `audio` 和 `video` 优先级高)
    - `video`: 带有 `deviceId`、`width` 和/或 `height` 属性的对象(指定要捕获的视频设备的 ID 和可选的分辨率，比上述优先级高；可以通过 `Janus.listDevices(callback)` 访问设备列表)
    - `data`: `true/false` (使用/不使用数据通道，默认是 `false`)
    - `failIfNoAudio`: `true/false` (如果请求发送音频但是没有可用的音频设备，`getUserMedia` 是否应该返回失败，默认是 `false`)
    - `failIfNoVideo`: `true/false` (如果请求发送视频但是没有可用的视频设备，`getUserMedia` 是否应该返回失败，默认是 `false`)
    - `screenshareFrameRate`: 一旦你正在共享一个屏幕/应用，支持你指定帧率(默认是 `3`)
  - `trickle`: `true/false`，告诉库你是否想要使用 Trickle ICE (`true`，默认；不想用设为 `false`)
  - `stream`: 可选的，只有当你自己使用一个 `getUserMedia` 请求获得一个 MediaStream 对象，而且你想要库使用这个对象而不是它自己获取的时候需要传递(使得 `media` 属性不可用，且它不会读或访问任何设备)
  - 关于结果通知的一系列回调：
    - `success`: 创建会话描述(作为一个附属参数)，且准备就绪发送给插件
    - `error`: 会话描述没有被成功创建
    - `customizeSdp`: 你可以按需修改 WebRTC 引擎创建的 SDP
  - `createAnswer`: 接收 `createOffer` 相同的选项，但是需要一个另外的单独的参数
    - `jsep`: 插件发送的 OFFER 会话描述(比如，在 `onmessage` 回调中接收的)

使用 `createOffer` 还是 `createAnswer` 取决于场景，你应该在结束时获得 `success` 回调返回的 `jsep` 对象。你可以将整个 `jsep` 对象附加在一个 `send` 请求的消息中，以传递给插件，并让 Janus 和你的应用协商一个 PeerConnection。

有一个实例演示如何使用 `createOffer`，选自 Echo Test demo 页：

```js
// 绑定到 Echo Test 插件
janus.attach(
    {
        plugin: "janus.plugin.echotest",
        success: function(pluginHandle) {
            // 协商 WebRTC
            echotest = pluginHandle;
            var body = { "audio": true, "video": true };
            echotest.send({"message": body});
            echotest.createOffer(
                {
                    // 没有提供媒体属性：默认，是接收/发送音频和视频
                    success: function(jsep) {
                        // 得到我们的 SDP! 给插件发送我们的 OFFER
                        echotest.send({"message": body, "jsep": jsep});
                    },
                    error: function(error) {
                        // 出现错误...
                    },
                    customizeSdp: function(jsep) {
                        // 如果你想要修改原始的 SDP，按照下面的操作
                        // oldSdp = jsep.sdp;
                        // jsep.sdp = yourNewSdp;
                    }
                });
        },
        [..]
        onmessage: function(msg, jsep) {
            // 处理消息，如果需要，检查 jsep
            if(jsep !== undefined && jsep !== null) {
                // 我们收到插件的 ANSWER
                echotest.handleRemoteJsep({jsep: jsep});
            }
        },
        [..]
        onlocalstream: function(stream) {
            // createOffer 之后调用
            // 这是我们的视频
        },
        onremotestream: function(stream) {
            // handleRemoteJsep 得到一个 PeerConnection 之后调用
            // 这是远端的视频
        },
        [..]
```

有一个实例演示如何使用 `createAnswer`，选自 Streaming demo 页：

```js
// 绑定到 Streaming 插件
janus.attach(
    {
        plugin: "janus.plugin.streaming",
        success: function(pluginHandle) {
            // 创建句柄
            streaming = pluginHandle;
            [..]
        },
        [..]
        onmessage: function(msg, jsep) {
            // 处理消息，如果需要，检查 jsep
            if(jsep !== undefined && jsep !== null) {
                // 我们收到插件的 OFFER
                streaming.createAnswer(
                    {
                        // 添加远端 OFFER
                        jsep: jsep,
                        // 只想要接收音频/视频
                        media: { audioSend: false, videoSend: false },
                        success: function(ourjsep) {
                            // 得到我们的 SDP! 给插件发送我们的 ANSWER
                            var body = { "request": "start" };
                            streaming.send({"message": body, "jsep": ourjsep});
                        },
                        error: function(error) {
                            // 出现错误...
                        }
                    });
            }
        },
        [..]
        onlocalstream: function(stream) {
            // 这个不会被调用，我们选择只接收
        },
        onremotestream: function(stream) {
            // send 得到一个 PeerConnection 之后调用
            // 这是远端的视频
        },
        [..]
```

## 更新一个已有的 PeerConnection (重新协商)

上述 JavaScript API 描述对于大所述场景已经足够...

## janus.js

在 Echo Test 例子中，前端使用了 `janus.js`。它是和 janus 服务器通信的 JavaScript 库，`janus.js` 简化了 WebRTC API 的使用，以及前端与 janus 服务器建立连接、交换 SDP 等功能。
