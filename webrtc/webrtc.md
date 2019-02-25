# WebRTC 学习

## 简述

- WebRTC，即网络实时通信(Web Real Time Communication)。最初是为了解决浏览器上视频通话提出，即两个浏览器直接进行视频和音频通信，而不经过服务器。现在还可以传输文字和其他数据

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
  ![信号图解](jsep.png)

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
  - ![SimpleWebRTC](https://github.com/andyet/SimpleWebRTC)
  - ![easyRTC](https://github.com/priologic/easyrtc)
  - ![webRTC.io](https://github.com/webRTC-io/webRTC.io)
- 点到点数据传输
  - ![PeerJS](https://peerjs.com/)
  - ![Sharefest](https://github.com/peer5/sharefest)

## 参考

- [Getting Started with WebRTC](https://www.html5rocks.com/en/tutorials/webrtc/basics/)