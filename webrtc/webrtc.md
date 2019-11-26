# WebRTC 学习

- [WebRTC 学习](#webrtc-%e5%ad%a6%e4%b9%a0)
  - [简述](#%e7%ae%80%e8%bf%b0)
  - [概念](#%e6%a6%82%e5%bf%b5)
  - [APIS](#apis)
    - [MediaStream](#mediastream)
      - [约束对象`Constraints`](#%e7%ba%a6%e6%9d%9f%e5%af%b9%e8%b1%a1constraints)
      - [获取音频](#%e8%8e%b7%e5%8f%96%e9%9f%b3%e9%a2%91)
    - [RTCPeerConnection](#rtcpeerconnection)
    - [RTCDataConnection](#rtcdataconnection)
  - [服务器和协议](#%e6%9c%8d%e5%8a%a1%e5%99%a8%e5%92%8c%e5%8d%8f%e8%ae%ae)
  - [NAT和防火墙穿越](#nat%e5%92%8c%e9%98%b2%e7%81%ab%e5%a2%99%e7%a9%bf%e8%b6%8a)
  - [JS 框架](#js-%e6%a1%86%e6%9e%b6)
  - [参考](#%e5%8f%82%e8%80%83)

## 简述

- WebRTC，即网络实时通信(Web Real Time Communication)。最初是为了解决浏览器上视频通话提出，即两个浏览器直接进行视频和音频通信，而不经过服务器。现在还可以传输文字和其他数据

## 概念

```text
SFU
  selective forwarding unit, 选择性转发单元。一个 SFU 可以选择多个媒体流，并选择这些媒体流应该发送给哪些参与者。
MCU
  multipoint conferencing unit, 多点会议单元。MCU 支持在一个语音或视频会话中连接多个参与者。MCU 通常实现 mixing 架构，且因为每个会话需要很多处理能力而增加代价。
Mixing
  Mixing (混合) 是一种多点架构，每个参与者发送媒体到一个中心服务器并从该服务器接受单个媒体流，该服务器混合所有或部分收到的流。
  Mixing 服务器称为 MCU。
  优点：客户端要求很小，对于客户端而言，就是一个普通的 P2P 会话。
  缺点：因为 MCU 需要为所有的参与者解码、格式和重新编码收到的媒体，花费代价较大。
Mesh
  Mesh (网状) 是一种多点架构，每个参与者发送媒体到所有其他参与者，并从其他参与者接收媒体。
  Mesh 是 WebRTC 中一种常用的技术来建立多点会议。它通常最多可以扩展到 4 至 6 个参与者的视频会议。
  优点：在 WebRTC 中易实现；对后端架构要求小，使得服务器易于操作
  缺点：不能扩展到大量参与者；要求参与者上行带宽较大
Routing
  Routing (路由) 是一种多点架构，每个参与者发送媒体到一个中心服务器并从该中心接收所有参与者的媒体流。
  路由机制通过一个服务器“传播”媒体到所有参与者，降低了 WebRTC 客户端上行负载。
  路由机制也减少了来自服务器的负载，因为服务器不需要解码、格式和重新编码媒体再发送给所有参与者。
  有时，路由会使用 Simulcast 为每个参与者提供最合适的分辨率和比特率。
  这使得路由架构的代价可用于许多应用场景。
  优点：要求来自参与者异步带宽(下行大于上行)，使得适用于 ADSL；易于扩展到 10 个或以上参与者的应用场景和屏幕格式。
  缺点：要求后端路由服务器，比混合架构代价小；难以实现。
P2P
  peer-2-peer, 端到端。客户端可以直接通信，而不需要通过网络服务器。
  P2P 降低了服务器负载、消息延迟，增加了隐私。也可用于创建 mesh 网络。
Simulcast
  Simulcast (联播) 是一种技术，WebRTC 客户端将相同的视频流编码两次为不同的分辨率和比特率，并发送这些流给一个路由器，路由器确定谁需要接收哪个流。
  Simulcast 和 SVC 紧密相关，一个编码的视频流可被分层，且每个参与者只接收他可以处理的层。
Resolution
  Resolution (分辨率) 是一个图片的像素数目。
  一般的，像素越高，图片质量越好。WebRTC 的视频会话中常用的视频分辨率值：
    QVGA-320*240
    VGA-640*480
    720p(HD 720)-1280*720
    1080p(HD 1080)-1920*1080
    4K-4096*2160
  WebRTC 对支持的像素没有限制。限制因素包括浏览器实现、处理器能力和网络条件，因为像素越高，需要的计算和带宽约多。现在大多数 WebRTC 已经达到 720p 分辨率，并开始引入 1080p。
Bitrate
  在 VoIP (和 WebRTC) 中，bitrate (比特率/码率) 是每个时间单位(通常设置为秒)可以发送或接受的比特数。关于比特率的一些事情：
    最大可能的比特率不大于可用的带宽，带宽在一个会话中是动态的。
    语音编解码比视频编解码需要较少的比特率。
    下行和上行的比特率是不对称的。
BWE
  bandwidth estimation, 带宽估测是 WebRTC (和其他 VoIP 系统) 常用的机制，来判断对于制定的会话可用的带宽大小。
  通过 IP 网络运行的协议在处理时不能保证可用的带宽。而且，可用的带宽大小在一个会话中可动态改变。
  因此，使用带宽估测来判断可用的带宽大小并确保 WebRTC 不会使用更多(或更少带宽)。这确保会话中尽可能好的媒体质量。
  带宽估测基于启发式，即为网络行为建模并尝试预期网络行为。不同的网络类型使用不同的算法(WiFi 网络的带宽估测不必适用于 LTE 或有线)。
Codec
  在 VoIP (和 WebRTC) 中，codec (编解码器) 是一个编码和解码一个数字媒体流的软件。
  编码过程获得语音或视频的原始的数字数据，并压缩/编码数据使得更易于通过网络发送或存在再数字媒体中。
  解码过程获得编码的/压缩的数据并解压缩/解码，使得可以通过麦克风回放或展示在显示器上。
  在 VoIP 和 RTC (real time communication) 中，使用有损的编解码器。这些编解码器在编码时降低原始数字流中的信息，以牺牲质量获得更好的压缩比。
  编解码器在压缩级别、要求的 CPU(复杂度)、操作的速度(延迟)、编码一个媒体单元(规则)和依赖的专利(知识产权)方面有差异。
  编解码器可以在软件、硬件或二者之上实现。
SDP
  session description protocol,会话描述协议。WebRTC 使用 SDP 来协商会话参数。因为 WebRTC 中没有信令，认为 WebRTC 创建和使用的 SDP 由应用通信而不是 WebRTC 本身。
  关于 SDP 有很多争议，因此创建了 ORTC 倡议。
Signaling
  WebRTC 中的 Signaling (信令) 超出范围。由服务的实现者确定使用的传输和信令协议。
  对于传输，有三种主要的选项(假定需要与网络浏览器交互)：XHR、SSE、WebSocket。
  传输协议之上是信令协议，一般有三种选项：私有协议(指定服务使用)、SIP(在 WebSocket 之上)、XMPP/Jingle。
ORTC
  Object-RTC，是谷歌、微软和一些其他公司参与的致力于定义一个用于 RTC 的以对象为中心的 API。
  ORTC 的核心在于替换 WebRTC 当前使用的 SDP 接口，作为开发者使用的 API。
  SDP 的问题是它难于使用 js 代码解析和工作。
```

## APIS

- 三个主要任务
  - 获得音频和视频
  - 音频和视频通信
  - 任意数据通信
- 三个 JS APIs
  - MediaStream(也叫 getUserMedia)
  - RTCPeerConnection
  - RTCDataChannel

### MediaStream

- 访问音频或/和视频流
- 可以包含多个 track(轨)
  - 数据流对象`stream`包含方法获取音轨和视轨
    - `stream.getAudioTracks`返回数组，成员是数据流包含的音轨。使用的声音源的数量决定音轨的数量
    - `stream.getVideoTracks`返回数组，成员是数据流包含的视轨。使用的摄像头的数量决定视轨的数量
    - 每个音轨和视轨有两个属性：`kind`表示种类，即`video/audio`；`label`表示唯一的标识
- 通过`navigator.getUserMedia()`获得一个 MediaStream

```js
var constraints = {video : true};

function successCallback(stream) {
  // 返回文档中匹配指定 CSS 选择器的一个元素。
  var video = document.querySelector("video");
  // 生成能在 video 中使用 src 属性播放的 URL
  video.src = window.URL.createObjectURL(stream);
}

function errorCallback(error) {
  console.log("navigator.getUserMedia error: ", error);
}

// 第一个参数：一个约束对象，表示要获取哪些多媒体设备。此处表示获取视频
// 第二个参数：回调函数，在获取多媒体设备成功时调用，传递给它一个 Stream 对象
// 第三个参数：回调函数，在获取多媒体设备失败时调用，传递给它一个 Error 对象
navigator.getUserMedia(constraints, successCallback, errorCallback);
```

- 如果网页使用了`getUserMedia`方法，浏览器会询问用户，是否同意浏览器调用麦克风或摄像头：用户同意则调用回调函数`successCallback`，否则调用`errorCallback`
  - `errorCallback`接收一个`Error`对象，`Error`对象的`code`属性取值说明错误类型
    - PERMISSION_DENIED：用户拒绝调用设备
    - NOT_SUPPORTED_ERROR：浏览器不支持硬件设备
    - MANDATORY_UNSATISFIED_ERROR：无法发现指定的硬件设备

#### 约束对象`Constraints`

- 控制 MediaStream 的内容，包括媒体类型、分辨率、帧率

| 属性 | 描述 |
| --- | --- |
| video | 是否接受视频流 |
| audio | 是否接受音频流 |
| minWidth | 视频流的最小宽度 |
| maxWidth | 视频流的最大宽度 |
| minHeight | 视频流的最小高度 |
| maxHeight | 视频流的最大高度 |
| minAspectRatio | 视频流的最小宽高比 |
| maxAspectRatio | 视频流的最大宽高比 |
| minFramerate | 视频流的最小帧速率 |
| maxFrameRate | 视频流的最大帧速率 |

  ```js
  video: {
    mandatory: {
      minWidth: 640,
      minHeight: 360
    },
    optional [{
      minWidth: 1280,
      minHeight: 720
    }]
  }
  ```

#### 获取音频

使用`getUserMedia`+`Web Audio`获取音频

```js
// 获取音频输入成功的回调函数
function gotStream(stream) {
  var audioContext = new webkitAudioContext();
  // 为输入流创建一个 AudioNode
  var mediaStreamSource = audioContext.createMediaStreamSource(stream);
  // 连接到目的地或其他节点以处理
  mediaStreamSource.connect(audioContext.destination);
}

navigator.webkitGetUserMedia({audio:true}, gotStream);
```

### RTCPeerConnection

- 点到点(peer to peer)音频和视频通信，包括信号处理、多媒体编解码处理、端到端通信、安全性、带宽管理等
- 不同客户端直接的音频、视频传递不用通过服务器中转。但是，两个客户端需要通过服务器建立联系
  - 服务器为 WebRTC 提供 4 个方面的支持
    - 用户发现以及通信
    - 信令传输
    - NAT/防火墙穿越
    - 点对点通信建立失败时作为中转服务器
  ![WebRTC 架构](./webrtcArchitecture.png)
- `RTCPeerConnection`例子

```js
// 创建 RTCPeerConnection 实例
pc = new RTCPeerConnection(null);
// 如果检测到媒体流连接到本地，调用此函数
pc.onaddstream = gotRemoteStream;
// 向 RTCPeerConnection 中加入需要发送的流
pc.addStream(localStream);
// 作为发送方，创建并发送一个 offer 信令
pc.createOffer(gotOffer);

// 发送 offer 的函数，发送本地 session 描述
function gotOffer(desc) {
  pc.setLocalDescription(desc);
  sendOffer(desc);
}

// 得到 answer 之后，保存远端的 session 描述
function gotAnswer(desc) {
  pc.setRemoteDescription(desc);
}

function gotRemoteStream(e) {
  attachMediaStream(remoteVideo, e.stream);
}
```

### RTCDataConnection

- 支持点到点交换任意数据，包括和 WebSockets 一样的 API、超低延迟、高吞吐、可靠或不可靠、安全性
- API 例子

```js
var pc = new webkitRTCPeerConnection(servers,
  {optional: [{RtpDataChannels: true}]});

pc.ondatachannel = function(event) {
  receiveChannel = event.channel;
  receiveChannel.onmessage = function(event) {
    document.querySelector("div#receiver").innerHTML = event.data;
  };
};

sendChannel = pc.createDataChannel("sendDataChannel", {reliable: false});

document.querySelector("button#send").onlick = function() {
  var data = document.querySelector("textarea#send").value;
  sendChannel.send(data);
}
```

## 服务器和协议

- WebRTC 使用 RTCPeerConnection 在浏览器(即 peers)之间传递流数据，但仍然需要服务器来为我们传递信令(signaling)来建立这个信道
- WebRTC 没有定义信令的方法和协议，信令并不是 RTCPeerConnection API 的一部分
- 开发者可以选择采用任意的消息协议(SIP/XMPP)和任意的双工通信通道
- 信令用于交换三种消息
  - 会话控制消息：初始化或关闭通信，报告错误
  - 网络配置：告诉外部世界我的电脑的 IP 地址和端口
  - 媒体能力：我的浏览器可以处理的编解码和分辨率，以及浏览器想要通讯的媒体格式
  ![信令图解](jsep.png)

## NAT和防火墙穿越

- STUN
  - 告诉我我的公共 IP 地址是什么
  - 简单的服务器，容易穿越
  - 点到点的数据流
- TURN(Traversal Using Delay NAT，中继 NAT 实现的穿透)
  - 如果点到点通讯失败，提供一个云回退
  - 数据通过服务器发送，使用服务器的带宽
  - 确保所有环境的呼叫工作
- ICE(Interactive Connectivity Establishment，交互式连接建立)
  - 一个点到点连接的框架，可以整个各种 NAT 穿越技术
  - 尝试为每个呼叫找到最好的路径
  - 大部分的呼叫可以使用 STUN，少部分使用 TURN，即中继的呼叫
  - 优先使用 STUN，尝试建立一个基于 UDP 的连接，如果失败则尝试 TCP(先尝试 HTTP，再尝试 HTTPS)，仍然失败则使用一个中级的 TURN 服务器

## JS 框架

- 视频聊天
  - [SimpleWebRTC](https://github.com/andyet/SimpleWebRTC)
  - [easyRTC](https://github.com/priologic/easyrtc)
  - [webRTC.io](https://github.com/webRTC-io/webRTC.io)
- 点到点数据传输
  - [PeerJS](https://peerjs.com/)
  - [Sharefest](https://github.com/peer5/sharefest)

## 参考

- [Getting Started with WebRTC](https://www.html5rocks.com/en/tutorials/webrtc/basics/)
- [WebRTC 术语](https://webrtcglossary.com/)
