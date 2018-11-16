# 学习 libp2p

## 介绍

解决兼容性问题：分布式文件系统运行的网络配置、网络性能、设备不同

### 愿景

建立分布式系统，由开发者决定在网络中的交互，以及支持的配置和扩展性

### 目标

- 支持多种协议：
  - 传输：TCP，UDP，STCP，UDT，uTP，QUIC，SSH 等
  - 认证的传输：TLS，DTLS，CurveCPU，SSH
- 有效使用套接字（连接复用 connection reuse）
- 支持 peer 之间的通讯可以通过一个套接字复用（multiplex）（避免握手的负载）
- 支持 peer 之间通过协商过程，使用不同的协议或者不同的版本
- 向后兼容
- 在现有系统上运行
- 使用现有网络技术的所有能力
- 有 NAT 穿墙（raversal）
- 支持连接中继（relay）
- 支持加密的通道（channel）
- 有效使用底层传输（如 native stream muxing，native auth）

## 网络堆栈技术现状分析

分析网络栈可用的协议和架构

### 客户端-服务端（C/S）模型

- C/S 模型表明通道两端承担不同的角色，支持不同的服务，或者具有不同的能力
- C/S 应用成为趋势的原因
  - 数据中心的带宽比相互连接的客户端之间的带宽高很多
  - 数据中心的资源更便宜，因为利用充分以及存储量大（bulk stocking）
  - 开发者和系统管理更容易拥有对应用的较好的细粒度控制
  - 减少了要处理的异构系统的数目（数字仍然很大）
  - 像 NAT 的系统使得客户端机器很难找到彼此并且互相通信，迫使开发者解决这些问题
  - 协议开始设计的前提是开发者会开发一个C/S应用
- libp2p 在拨号者-监听者（dialer-listener）交互上前进了一步
  - 不明确 dialer 和 listener 各自的功能以及可以执行的操作
  - dialer 和 listener 可以独立地执行请求

### 按解决方案对网络分类

- 传统的 7 层 OSI 模型不适用于 libp2p，OSI 模型按照通讯功能划分
  - 物理层 Physical Layer：通过物理介质传输比特流
  - 数据链路层 Data Link Layer：将比特组合成字节，再将字节组合成帧，使用链路层地址访问介质，并进行差错检测
    - 逻辑链路控制子层 LLC：定义一些字段使上层协议可以共享数据链路层，不是必须的
    - 媒体访问控制子层 MAC：处理 CSMA/CD 算法、数据出错校验、成帧等
  - 网络层 Network Layer：通过 IP 寻址建立两个节点之间的连接
  - 传输层 Transport Layer：建立主机端到端的链接，为上层协议提供端到端的可靠和透明的数据传输服务，包括处理差错控制和流量控制等
  - 会话层 Session Layer：负责建立、管理和终止表示层实体之间的通话会。由不同设备中的应用程序之间的服务请求和响应组成
  - 表示层 Presentation Layer：提供各种用于应用层数据的编码和转换功能，确保一个系统的应用层发送的数据能被另一个系统的应用层识别
  - 应用层 Application Layer：为计算机用户提供应用接口，也为用户直接提供各种网络服务
- libp2p 根据角色将协议分类
  - 建立物理链路：Ethernet，Wi-Fi，Bluetooth，USB
  - 寻址一个机器或程序：IPv4，IPv6，隐藏的寻址（无 SDP）
  - 发现其他 peer 或服务：ARP，DHCP，DNS，Onion
  - 通过网络路由消息：RIP(1,2)，OSPF，BGP，PPP，Tor，I2P，cjdns
  - 传输：TCP，UDP，UDT，QUIC，WebRTC 数据通道
  - 商定应用通讯的语义：RMI，Remoting，RPC，HTTP

### 目前的缺点

- 大量的协议和解决方案使得让一个应用支持多种传输或通过多种传输并可用比较困难
  - 如浏览器应用缺少 TCP/UDP 栈
- 一个 peer 不能在不同传输 announce 自己，使得其他的 peer 确信是同一个 peer

## 要求

### 匿名传输

- 为了推理可能的传输，libp2p 使用多地址（multiaddr），一种自描述的地址格式
  - libp2p 可以在系统的任何地方将地址视为不透明的，支持网络层的不同传输协议
  - libp2p 的地址格式是 ipfs-addr，以 IPFS 的节点 ID 结尾的多地址
- 目前，没有不可靠的实现存在。即定义和使用不可靠的传输协议接口未被定义

### 多种多路复用（multi-multiplexing）

- libp2p 收集了多种协议，为了保留资源，是的建立连接更容易，libp2p 可以在一个端口（TCP 或 UDP，取决于使用的传输）上执行所有的操作
- libp2p 可以通过一个端到端的连接复用多种协议。这个复用包括可靠的流和不可靠的数据包
- libp2p 网络层提供的多路复用包括
  - 可以复用多个监听网络接口
  - 可以复用多个传输协议
  - 每个 peer 可以复用多个连接
  - 可以复用多个客户端协议
  - 每个协议，每个连接可以复用多个流
  - 具有流控制（backpressure，fairness）
  - 用不同的短暂的 key 为每个连接加密

### 加密

- libp2p 中的通讯是三种状态
  - 加密的
  - 签名的（未加密）
  - 清楚的（未加密，未签名）
- 对于一些性能要求高的数据中心，加密是不可行的。建议
  - 实现默认为所有的通讯加密
  - 实现是审核的（audited）
  - 除非绝对必须，用户通常只操作加密的通讯

### NAT 遍历（traversal）

- NAT（Network Address Translation，网络地址转换）在互联网普遍存在
  - 大部分消费者设备在很多层的 NAT 后面
  - 大多数数据中心节点尝尝处于安全或虚拟化原因也在 NAT 后面
  - 在基于容器的部署阶段，这个现象更加普遍
- IPFS 的实现应该提高一种方式来遍历 NAT，否则操作会受影响，即使是在真实 IP 地址运行的节点也要实现 NAT 遍历，因为节点可能需要和 NAT 之后的节点建立连接
- libp2p 使用 ICE-like 的协议实现完全的 NAT 遍历
  - 不是真的 ICE，因为 IPFS 网络可能为了 hole-punching 或者中继通讯通过 IPFS 协议中继通讯
- 建议使用一些现有的 NAT 遍历库来实现：libnice，libwebrtc，natty

### 中继（relay）

- 由于对称的 NAT，容器和 VM NAT，以及其他的 impossible-to-bypass 的 NAT，libp2p 必须中继通讯以建立完整的连接图
- 因此，实现必须支持中继，虽然可能是可选的，而且可能被终端用户拒绝
- 连接中继应该作为传输实现，以便于传给上层

### 启用多个网络拓扑

- P2P 的拓扑分为：
  - unstructed 无结构的：网络是完全随机的，或者不确定的
  - structed 结构化的：有一种隐式的方式来识别网络节点
  - hybrid 混合的：无结构和结构化的拓扑混合
  - centralized 中心化的：中心化的拓扑是 web 应用框架中最常见的，它要求一个或一些指定的服务在已知的静态位置一直存在
- libp2p 必须执行不同的路由机制和 peer 的发现，以便建立路由表

### 资源发现

- libp2p 通过记录（records）解决王路内部的资源发现问题
  - 一个 record 是一个数据单元，可以按位签名，加时间戳或/和使用其他方法给它一个时效性
  - 这些 records 持有信息包括网络中的位置、资源的有效性等
- 资源可以是数字，存储，CPU 周期和其他类型的服务
- libp2p 不能限制资源的位置，但是提供方式简单的发现网络中的资源或者使用一个 side channel

### 消息

- 有效的消息协议提供方法来发送消息，使得延迟最小，且/或支持庞大复杂的拓扑以便于分布式
- libp2p 结合 Multicast 和 PubSub 来实现这些需求

### 命名

- 网络变化和应用可以使用网络以使得对于拓扑是匿名的，命名用于解决这个问题

## 架构

- libp2p 包括多个子系统。这些子系统可以遵循统一的接口建立在其他子系统之上
  - Peer Routing：节点路由。这个机制决定使用哪些节点来路由指定的消息。路由可以是递归的、迭代的，甚至是广播或多播的模式
  - Swarm：集群。处理 libp2p2 中和打开流相关的部分，包括多传输过程中的协议复用，流复用，NAT 遍历，连接中继
  - Distributed Record Store：分布式记录存储。存储和分发记录的系统。记录是指被其他吸烟使用的小的条目，用于发送信号，建立链路，announce 节点或内容等。和网络中的 DNS 类似
  - Discovery：发现。发现和识别网络中的其他节点

### 节点路由

- 子系统暴露了一个接口来识别一个消息应该被路由到 DHT 中的哪些节点：接收一个 key，返回一个或多个 PeerInfo 对象
  - kad-routing：基于 Kademlia DHT，实现了 Kademlia 路由表，每个节点持有一个 k-bucket 的集合。每个k-bucket 包含几个 PeerInfo 对象
  - mDNS-routing：使用 mDNS 探测和识别，当局域网内的节点有一个指定的 key 或者节点容易出现

### 集群

- Stream Muxer：必须实现 [interface-stream-muxer](https://github.com/libp2p/interface-stream-muxer) 中的接口
- Protocol Muxer：在应用层被处理而不是传统的端口层（不同的服务或协议监听不同的端口）。使得我们支持多种协议在一个套接字被复用，节约了多端口 NAT 遍历的花费
  - 协议复用通过 [multistream](https://github.com/multiformats/multistream-select) 完成，一个协议和不同的流协商使用 [multicodec](https://github.com/multiformats/multicodec)
- Transport：传输
- Crypto：加密
- Identify：鉴别是 Swarm 之上的一些协议，是 Connection Handler。使得节点之间可以互换监听者地址(listenAddrs)和观察者(observeAddrs)地址。因为每个开放的套接字会实现 REUSEPORT，另一个节点的 ObserveAddr 可以使得第三个节点连接进来，因为端口已经是开放的，可以在 NAT 上重定向到开放的端口
- Relay：中继，参考 [Circuit Relay](https://github.com/libp2p/specs/tree/master/relay)

### 分布式记录存储

- Record
- abstract-record-store
- kad-record-store
- mDNS-record-store
- s3-record-store

### 发现

发现和识别网络中的其他节点

#### mDNS-discovery

- mDNS-discovery 是局域网内使用 mDNS 的一个发现协议。它发射一个 mDNS 信号来发现是否有更多可用的节点。局域网内的节点对于 peer-to-peer 是非常有用的，因为链路延迟更低
- mDNS-discovery 是一个独立的协议，不依靠 libp2p2 中的其他协议。可以不依赖其他底层架构在局域网内生成可用的节点
- mDNS-discovery 可为每个服务配置，也可以在私有网络配置
- 原始的 mDNS 会暴露本地 IP 地址，正在设法加密 mDNS-discovery 信号，使得局域网内其他节点不能识别正在使用的服务
  - 不建议将 mDNS-discovery 应用到隐私敏感的应用或者未知到路由协议

#### random-walk

- random-walk 是应用于 DHT （或其他有路由表的协议）的发现协议。它生成随机的 DHt 请求以快速了解大量的节点
- 这个会在一开始的时候花费一些负载，但是可以使得 DHT （或其他协议）更快聚合

#### bootstrap-list

- bootstrap-list 是用本地存储来缓存网络中的高稳定（或信任的）节点的发现协议
  - 列表应当被存储在对于本地节点来说是长期的本地存储
  - 在大部分情况下应该是可以用户配置的

### 消息-架构

#### 发布订阅

- PubSub 参考 [pubsub](https://github.com/libp2p/specs/tree/master/pubsub) 和 [pubsub/gossippub](https://github.com/libp2p/specs/tree/master/pubsub/gossipsub)

### 命名-架构

#### IPRS

参考 [IPRS spec](https://github.com/libp2p/specs/blob/master/IPRS.md)

#### IPNS

## 数据结构

网络协议处理的数据结构包括

- PrivateKey：节点的私钥
- PublicKey：节点的公钥
- PeerId：节点公钥的一个哈希
- PeerInfo：一个对象，包含节点的 PeerId 和已知的多地址
- Transport：用于和其他 peer 建立连接的传输，必须实现 [interface-transport](https://github.com/libp2p/interface-transport)
- Connection：两个 node 之间的一个 point-to-point 链路，必须实现 [interface-connection](https://github.com/libp2p/interface-connection)
- Muxed-Stream：一个双向（duplex）的消息通道
- Stream-Muxer：流复用器，必须实现 [interface-stream-muxer](https://github.com/libp2p/interface-stream-muxer)
- Record：LPLD（IPFS Linked Data）描述的对象，实现 [IPRS](https://github.com/libp2p/specs/blob/master/IPRS.md)
- multiaddr：自描述的网络地址，参考 [multiaddr](https://github.com/multiformats/multiaddr)
- multicodec：自描述的编码类型，参考 [multicodec](https://github.com/multiformats/multicodec)
- multihash：自描述的哈希，参考 [multihash](https://github.com/multiformats/multihash)

## 接口

- libp2p
- 传输
- 链接
- 流多路复用器
- 集群
- 节点发现
- 节点路由
- 内容路由
  - 接口-分布式记录存储
- libp2p 接口和 UX

## 特性

### 通信模型-流

### 端口-受限入口

### 传输协议

### 非 IP 网络

### 网线

- 协议复用-同一个流上运行多个协议
  - 多流-自描述协议流，为协议定义一个协议头
  - 多流选择器-自描述协议流选择器
    - 允许列举和选择其他协议。协议复用有一个注册协议的列表，监听一个协议，然后包装或升级连接来描述注册的协议
    - 直接利用了多流，可以交替多个协议，检查远端可能使用的协议
  - 流复用-通过一个网线运行多个独立流
    - 将多个流复用或合并成一个单独的流
- 便携式编码-使用便携的序列格式
  - 目前使用 protobuf，候选的还有 capnp，bson，ubjson
- 安全通信-使用加密算法建立安全和隐私（像 TLS）
- 协议多解码（multicodecs）

## 实现

## 参考