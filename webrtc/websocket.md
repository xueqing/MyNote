# 学习 WebSocket

- [学习 WebSocket](#学习-websocket)
  - [关于 WebSocket](#关于-websocket)
  - [WebSocket vs Ajax](#websocket-vs-ajax)
  - [WebSocket vs HTTP](#websocket-vs-http)
  - [参考](#参考)

## 关于 WebSocket

WebSocket 是一种在单个 TCP 连接上进行全双工通讯的协议，从 HTML5 开始提供。

WebSocket 使得客户端和服务器之间的数据交换变得更加简单，允许服务端主动向客户端推送数据。在 WebSocket API 中，浏览器和服务器只需要完成一次握手，两者之间就直接可以创建持久性的连接，并进行双向数据传输。

在 WebSocket API 中，浏览器和服务器只需要做一个握手的动作，然后，浏览器和服务器之间就形成了一条快速通道。两者之间就直接可以数据互相传送。

## WebSocket vs Ajax

很多网站使用 Ajax 轮询实现推送技术。轮询是在特定的的时间间隔(如每 1 秒)，由浏览器对服务器发出 HTTP 请求，然后由服务器返回最新的数据给客户端的浏览器。这个机制有一些缺点：一是实时性不够；二是频繁的请求会给服务器带来极大的压力；因为浏览器需要不断的向服务器发出请求，而 HTTP 请求可能包含较长的头部，其中真正有效的数据可能只是很小的一部分，这样也会浪费很多的带宽等资源。

HTML5 定义的 WebSocket 协议，能更好的节省服务器资源和带宽，并且能够更实时地进行通讯。浏览器通过 JavaScript 向服务器发出建立 WebSocket 连接的请求，连接建立以后，客户端和服务器端就可以通过 TCP 连接直接交换数据。

![Ajax vs WebSocket](ajaxws.png)

## WebSocket vs HTTP

传统的 HTTP 协议是一个“请求——响应”协议，请求必须先由浏览器发给服务器，服务器才能响应这个请求，再把数据发送给浏览器。换句话说，浏览器不主动请求，服务器不能主动发数据给浏览器。HTTP 协议建立在 TCP 协议之上，TCP 协议本身实现了全双工通信，但是 HTTP 协议的“请求——响应”机制限制了全双工通信。

Comet 本质上也是轮询，但是在没有消息时，服务器会等到有消息了再回复。这个机制暂时解决了实时性问题，但是带来了新问题：以多线程模式运行的服务器会让大部分线程大部分时间都处于挂起状态，极大地浪费服务器资源。另外，一个 HTTP 连接在长时间没有数据传输的情况下，链路上的任何一个网关都可能关闭这个连接，而网关是不可控的，这就要求 Comet 连接必须定期发一些 ping 数据表示连接“正常工作”。

WebSocket 标准让浏览器和服务器之间可以建立无限制的全双工通信，任何一方都可以主动发消息给对方。

总结如下：

- 较少的控制开销。WebSocket 连接创建后，服务器和客户端之间交换数据时，用于协议控制的数据包头部相对较小。在不包含扩展的情况下，服务器到客户端的内容，头部只有 2-10 字节(和数据包长度有关)；客户端到服务器的内容，头部还需要加上额外的 4 字节的掩码。然而，HTTP 请求每次都要携带完整的头部。
- 更强的实时性。由于是全双工协议，服务器可以随时主动给客户端下发数据。相比 HTTP 请求需要等待客户端发起请求服务端才能响应，延迟明显更少；即使是和 Comet 等类似的长轮询比较，其也能在短时间内更多次地传递数据。
- 保持连接状态。与 HTTP 不同的是，WebSocket 需要先创建连接，这就使得其成为一种有状态的协议，之后通信时可以省略部分状态信息。而 HTTP 请求可能需要在每个请求都携带状态信息(如身份认证等)。
- 更好的二进制支持。WebSocket 定义了二进制帧，相对 HTTP，可以更轻松地处理二进制内容。
- 可以支持扩展。WebSocket 定义了扩展，用户可以扩展协议、实现部分自定义的子协议。如部分浏览器支持压缩等。
- 更好的压缩效果。相对于 HTTP 压缩，WebSocket 在适当的扩展支持下，可以沿用之前内容的上下文，在传递类似的数据时，可以显著地提高压缩率。

## 参考

- [WebSocket 百科](https://baike.baidu.com/item/WebSocket)
- [HTML5 WebSocket](https://www.runoob.com/html/html5-websocket.html)
- [WebSocket](https://www.liaoxuefeng.com/wiki/1022910821149312/1103303693824096)
