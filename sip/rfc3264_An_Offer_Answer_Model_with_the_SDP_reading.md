# An Offer/Answer Model with the SDP

- [An Offer/Answer Model with the SDP](#an-offeranswer-model-with-the-sdp)
  - [answer/offer](#answeroffer)
  - [协议操作](#%E5%8D%8F%E8%AE%AE%E6%93%8D%E4%BD%9C)
  - [生成初始 offer](#%E7%94%9F%E6%88%90%E5%88%9D%E5%A7%8B-offer)
  - [生成 answer](#%E7%94%9F%E6%88%90-answer)
  - [offerer 处理 answer](#offerer-%E5%A4%84%E7%90%86-answer)
  - [修改会话](#%E4%BF%AE%E6%94%B9%E4%BC%9A%E8%AF%9D)
  - [表明能力](#%E8%A1%A8%E6%98%8E%E8%83%BD%E5%8A%9B)

## answer/offer

- agent：一个 agent 是 offer/answer 交换中的一个协议实现。offer/answer 交换包括两种代理：offerer 和 answerer
- offerer：会话一方，创建或者修改一个会话。发送的 SDP 消息包含了 offerer 希望使用的媒体流和编解码器的集合，以及 offerer 接收媒体流希望使用的地址和端口
- offer：offerer 发送的 SDP 消息
- answerer：会话的另一方参与者。answerer 为接收到的 offer 生成一个回复的 SDP 消息。消息对应 offer 每个流有一个媒体流，指出这个流是否被接收，以及使用的编解码器和 answerer 接收媒体流希望使用的地址和端口
- answer：answerer 发送的用于回复 offer 的 SDP 消息

## 协议操作

- 在任何时候，代理可以生成一个新的 offer 来更新会话。但是
  - answerer 不能在收到一个 offer 之后，回复或者拒绝之前生成一个新的 offer
  - offerer 不能发送一个 offer 之后，在收到回复或拒绝之前生成一个新的 offer
- “glare”：一个代理在发送一个 offer 之后，还没有回复这个 offer 就收到一个新的 offer
  - 上层协议应该解决这种冲突

## 生成初始 offer

- 忽视 e 和 p 字段
- 没有 m 字段表示 offerer 希望通讯，但是通过后续的修改 offer 来增加会话的流信息
- 单播流
  - sendonly：offerer 只想发送媒体流
  - inactive：offerer 希望通讯，但是不希望发送或接收媒体流
  - sendrecv：offerer 想发送和接收媒体流，这个是默认选项
  - recvonly：offerer 只想接收媒体流
    - RTCP 仍然会在 sendonly/inactive/recvonly 流中发送。媒体流的方向性不影响 RTCP 的使用
    - sendrecv/recvonly：offer 中的地址和端口表示 offerer 想要接收媒体流的信息
    - sendonly：offer 中的地址和端口表示 offerer 想要接收 RTCP 包的信息
      - 如果没有明确说明 RTCP 的地址和端口，RTCP 包将会发送到比指定的端口大 1 的端口
    - offer 中的地址和端口和 offerer 发送媒体流的地址和端口无关
    - offer 中的端口为 0 表示提供流但是不会使用流，比如回复中的端口为 0 表示拒绝流，或者设置端口为 0 终止已存在的流
  - 如果 SDP 中包含多个媒体格式(应当按照倾向顺序排列)，表示 answerer 在会话中间可能会修改格式为媒体格式列表中的任一一个，同时不会发送一个新的 offer
  - 带宽为 0 不被建议，表示不应当发送任何媒体流，包括 RTP 的 RTCP 信息
  - offer 中不同类型的媒体流信息表示 offerer 同时希望使用的流；相同类型的媒体流信息表示 offerer 希望同时发送和/或接收指定类型的多个媒体流
- 多播流
  - sendonly：只想发送媒体流
  - recvonly：只想接收媒体流

## 生成 answer

- 对于 offer 中的每一个 “m=”，answer 中必须有对应的 “m=”。这便于基于顺序匹配流
- answer 的 “t=” 必须和 offer 的相等
- 如果拒绝一个流，可以将对应的流的端口设置为 0，其他的格式信息被忽略
- 单播流
  - offer 的流为 sendonly，对应的流必须是 recvonly/sendrecv
  - offer 的流为 recvonly，对应的流必须是 sendonly/sendrecv
  - offer 的流为 sendrecv(没有的话默认为 sendrecv)，对应的流必须是 sendonly/recvonly/sendrecv/inactive
  - offer 的流为 inactive，对应的流必须是 inactive
  - answer 中标记流为 recvonly，“m=” 中必须包含 offer 中至少一个媒体格式
  - answer 中标记流为 sendonly，“m=” 中必须包含 offer 中至少一个媒体格式
  - answer 中标记流为 sendrecv，“m=” 中必须包含 offer 中至少一个媒体格式
  - answer 中标记流为 inactive
    - offer 的流为 sendonly，媒体格式按照 recvonly 构造
    - offer 的流为 recvonly，媒体格式按照 sendonly 构造
    - offer 的流为 sendrecv，媒体格式按照 sendrecv 构造
    - offer 的流为 inactive，媒体格式按照 sendrecv 构造
  - 尽量按照 offer 的优先顺序排列媒体格式
  - 如果对于提供的媒体没有通用的媒体格式，answer 将设置端口为 0 来拒绝该媒体流
  - 如果对于所有的流都没有通用的格式，整个会话被拒绝
  - answerer 发送媒体流的格式应该是 offer 中最优先且在 answer 中列举的媒体格式。对于 RTP，即使和 answer 不同，也必须使用 offer 中指定的负载类型
- 多播流
  - 多播 offer 的 answer 通常涉及修改一个流的某些方面
  - 如果接受多播流，answer 的地址和端口信息必须和 offer 中的对应，且流的方向信息必须和 offer 的一致
  - answer 中的媒体格式必须和 offer 中的相同或者是 offer 的一个子集。移除一个格式表示 answerer 不支持该格式
  - 如果 offer 中有 ptime 和带宽属性，answer 必须和其一样。否则，answer 可以添加一个非 0 的 ptime 属性
  
## offerer 处理 answer

- 如果 answer 是 sendrecv/recvonly，offerer 收到 answer 时可以发送媒体流
  - offerer 必须使用 answer 中列举的媒体格式发送，且**应该(不是必须)**使用 answer 中第一个媒体格式
  - offerer 应该根据 answer 中的 ptime 和带宽来发送媒体
  - offerer 可以立即停止监听 offer 中列举但是 answer 中未显示的媒体格式

## 修改会话

- 在会话期间，任意一方可以发起一个新的 offer 来修改会话属性
- 先前的 SDP：包括 offer 或 answer 中提供的 SDP
- 新 offer 的 SDP 的 “o=” 必须和先前的 SDP 一样，版本号加 1
  - 新 offer 的 SDP 和先前的 SDP 一致的话，answerer 必须可以处理，可以返回和之前处理过程相同的 SDP
- 新 offer 的 SDP 的媒体属性必须和之前的 SDP 的每个媒体对应，即 offer 中的媒体数目不会减少。之前的 SDP 删除的媒体流不能在新的 SDP 中移除，可以不显示流的属性
- 添加一个媒体流
  - 可以复用之前拒绝的媒体流的位置，即端口设置为 0 的媒体
  - 在已有的媒体下面添加新的媒体描述
- 移除一个媒体流
  - 将媒体所在位置的端口设置为 0，可以忽视之前的其他属性，只留下媒体格式
  - 可以释放与其相关的资源
- 修改一个媒体流
  - 修改地址，端口或协议
    - offerer 一发送 offer，就必须为接收旧的和新的端口做准备。直到收到 answer 和媒体到达新的端口，offerer 才可以停止监听旧端口。此举避免在传送过程中丢掉媒体数据
    - answerer 对端口修改的处理和 offerer
    - 如果提供的流被拒绝，收到拒绝的时候就可以停止监听
    - 修改地址类比修改端口，不过更新的是连接，而不是端口
    - 修改协议和修改端口一样处理
  - 修改媒体格式集
  - 修改媒体类型：比起添加新媒体，建议修改媒体类型
  - 修改属性
- 暂停一个单播流
  - 之前标记为 sendrecv 的流，应改成 sendonly
  - 之前标记为 recvonly 的流，应改成 inactive

## 表明能力

- 代理构造一个用于表明媒体能力的 SDP
  - 必须是有效的，忽视 e 和 p 字段
  - 关于时间属性`t= 0 0`
  - 代理支持的每个媒体类型必须有对应的媒体描述
  - o 字段的会话 ID 必须是唯一的
  - 端口是 0(确保不会建立媒体流)，连接地址是任意的
  - “m=” 的传输表明媒体类型的传输
