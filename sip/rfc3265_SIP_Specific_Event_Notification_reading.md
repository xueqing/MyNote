# SIP Specific Event Notification

- [SIP Specific Event Notification](#sip-specific-event-notification)
  - [介绍](#%E4%BB%8B%E7%BB%8D)
  - [节点行为](#%E8%8A%82%E7%82%B9%E8%A1%8C%E4%B8%BA)
    - [订阅者](#%E8%AE%A2%E9%98%85%E8%80%85)
    - [通知者](#%E9%80%9A%E7%9F%A5%E8%80%85)
    - [通知者 NOTIFY 行为](#%E9%80%9A%E7%9F%A5%E8%80%85-notify-%E8%A1%8C%E4%B8%BA)
    - [订阅者 NOTIFY 行为](#%E8%AE%A2%E9%98%85%E8%80%85-notify-%E8%A1%8C%E4%B8%BA)
  - [事件包](#%E4%BA%8B%E4%BB%B6%E5%8C%85)

## 介绍

- 网络中的实体可以订阅网络中的资源或不同资源的呼叫状态或呼叫，当这些状态改变的时候，这些实体可以发送通知
- 订阅是有时效性的，必须通过后续的 SUBSCRIBE 消息刷新

## 节点行为

- SUBSCRIBE 方法是一个用来请求远端节点的当前状态和后续状态变化的请求方法
- SUBSCRIBE 请求有 “Expires” 头域显示请求有效期，之后通过新的 SUBSCRIBE 请求来刷新有效期
  - SUBSCRIBE 回复的 200 中也必须包含一个 “Expires” 头域，必须比请求的有效期长
  - “Contact” 头域中的 “expires” 和订阅的有效期无关
  - 当 SUBSCRIBE 请求的 “Expires” 值为 0，表示取消订阅一个事件。成功的取消订阅也会触发一个 NOTIFY 消息

### 订阅者

- 订阅者必须在 SUBSCRIBE 请求包含有且仅有一个 “Event” 头域，表示订阅的事件或事件类
- 订阅者想要订阅一个资源的一个指定的状态，构造并发送一个 SUBSCRIBE 请求
  - 200 回复表示接受订阅请求，用户被鉴权订阅请求的资源
    - “Expires” 头域，必须比请求的有效期短，定义了这个订阅的实际有效期
  - 202 回复表示理解订阅请求，但是用户未被授权
  - 489 回复表示不理解订阅消息的 “Event” 头域指定的事件或事件类
  - 423 回复表示过期时间太短，即过期时间大于 0，小于 1 小时，且小于通知者配置的最小时间。回复的头域应包含 “Min-Expires” 头域指明最小时间
- 刷新订阅：发送一个 SUBSCRIBE 请求，“Event” 头域的 “id” (如果存在)必须和之前的订阅请求一致
  - 481 回复表示订阅被终止，订阅者不会收到通知。如果订阅者仍希望订阅这个状态，必须重新发送一个和之前的订阅无关的初始化订阅请求
  - 其它的非 481 的回复，订阅仍被认为是有效的，但是通常是网络问题或者通知者的问题，订阅者不会接收到 NOTIFY 消息

### 通知者

- 通知者需要保存订阅的事件包的名称， “Event” 头域以及 “id” 参数(如果存在)
- 通知者接收或者刷新一个订阅，即发送一个 200 回复之后，必须立即发送一个 NOTIFY 消息告知订阅者当前的状态
  - 如果当前资源的状态对于处理的订阅请求没有意义，NOTIFY 的消息体可以为空或者 “neutral”
  - 通知者对订阅者身份的认证，是通过一个 401 回复还不是 407 回复，即通知者在接受订阅和通知事件的时候是作为一个用户代理存在的
    - 代理节点通常使用 407 来认证身份
  - 认证失败，通知者返回 “403 Forbidden” 或 “603 Decline”
  - 如果通知者通过交互的方式决定是否允许一个订阅，应立即给出一个 “202 Accept” 应答
  - 如果通知者延迟认证，且认证失败，应构造一个 NOTIFY 消息，包含 “Subscription-State” 头域，且该头域包含一个 “terminated” 值及一个原因短语 “rejected”
  - 如果通知者过期未收到更新订阅消息，应该移除订阅，发送一个 NOTIFY 消息，包含 “Subscription-State” 头域，且该头域包含一个 “terminated” 值及一个原因短语 “reason=timeout”
- 如果不支持 PINT，且 SUBSCRIBE 请求不包含 “Accept-Event” 头域，通知者返回 “489 Vad Event”

### 通知者 NOTIFY 行为

- 如果收到 NOTIFY 消息的节点没有订阅，回复 481
- 发送一个 NOTIFY 请求，“Event” 头域的 “id” (如果存在)必须和之前的订阅请求一致
- 如果 NOTIFY 的回复超时，或者回复是非 200，则 NOTIOFY 请求失败，通知者移除对应的订阅
- 如果 NOTIFY 请求的回复是 481，通知者移除对应的订阅，表示无论是什么情况，取消对应的订阅
- NOTIFY 请求必须包含 “Subscription-State” 头域，取值范围是 “active/pending/terminated”
  - 当取值 “active/pending”，NOTIFY 的 “Subscription-State” 头域应该包含一个 “expires” 参数
  - active：表示接受订阅，且订阅通过认证
    - 如果有 “expires”  参数，订阅者应该当做认证订阅的时长，并且根据时长调整认证
    - “reason” 和 “retry-after” 参数无意义
  - pending：表示收到订阅，但是当前的策略信息不足以决定接受或者拒绝这个订阅
    - 如果有 “expires”  参数，订阅者应该当做认证订阅的时长，并且根据时长调整认证
    - “reason” 和 “retry-after” 参数无意义
  - terminated：表示订阅不是 active
    - “Subscription-State” 头域可以包含一个 “retry-after” 参数
      - 表示多久之后订阅者可以尝试重新订阅。如果没有 “retry-after” 参数，可以在任意时刻尝试重新订阅
    - “expires” 参数无意义
    - “Subscription-State” 头域应该包含一个 “reason” 参数。取值应该是下面的范围
      - deactivated：终止订阅，但是订阅者应该立即用新的订阅重试。比如允许节点之间的订阅迁移。“retry-after” 参数无意义
      - rejected：认证策略的变化而终止订阅。订阅者不应该重新订阅。“retry-after” 参数无意义
      - timeout：过期之前未刷新而终止订阅。订阅者可以立即重试订阅。“retry-after” 参数无意义
      - noresource：监视的资源状态不存在而终止订阅。订阅者不应该重试订阅。“retry-after” 参数无意义
      - probation：终止订阅，但是订阅者应该在一段时间之后重试。如果指定 “retry-after” 参数，则至少等待指定的时间之后重试订阅
      - giveup：通知者不能获得认证信息而终止订阅。如果指定 “retry-after” 参数，则至少等待指定的时间之后重试订阅；否则应立即重试订阅，但是很可能变成 “pending” 状态
- 如果订阅者认为通知式可接受的，应立即回复 200。一般，通知的回复不会包含消息体。但是如果 NOTIFY 请求包含 “Accept” 头域，回复可以包含消息体

### 订阅者 NOTIFY 行为

- 关于订阅的回复：回复和 SUBSCRIBE 请求包含相同的 “Call-ID”、“CSeq” 和“From” 头域的 “tag” 参数
- 判断 NOTIFY 和订阅是否一致：
  - NOTIFY 请求和 SUBSCRIBE 请求的有相同的 “Call-ID”，前者的 “To” 头域的 “tag” 参数和后者的 “From” 头域的 “tag” 参数相同
  - NOTIFY 请求和 SUBSCRIBE 请求的 “Event” 头域相同
    - “Event” 类型相同，且如果一方的 “Event” 头域有 “id”，二者必须都有且相同
- 如果订阅者不支持 NOTIFY 的 “Event” 头域，返回 “489 Bad Event”
- 订阅者发送一个“Expires” 值为 0 的 SUBSCRIBE 请求，表示取消订阅一个事件
  - 只有收到一个 “Subscription-State” 为 “terminated” 的 NOTIFY 消息才认为是订阅被取消或终止，“reason” 参数是 “timeout”

## 事件包

- 传递事件包的两种机制
  - 传递完整状态信息：事件包需要传递的状态信息比较小，或者仅仅传递当前状态对于特定的事件类型不是足够的
  - 增量传递信息：需要传递的状态比较大，可以使用包含增量状态的 NOTIFY 消息传递状态
    - 立即给 SUBSCRIBE 请求的 NOTIFY 消息包含全部的状态信息。后续由于状态变化传递的 NOTIFY 消息只包含改变的状态。订阅者将资源状态合并到已知的当前状态
    - 支持增量传递的事件包必须包含一个版本号，每次 NOTIFY 通信时加 1，此版本号在消息体，而不是 SIP 头
    - 第一个 NOTIFY 的版本号应该和上次最后一个 NOTIFY 的版本号响应，即第一个 NOTIFY 不增加版本号
    - 如果到达的 NOTIFY 的版本号增加大于 1，说明订阅者错过了一个增量。应当忽视这个 NOTIFY 消息，保存版本号用户检测消息丢失。然后重新发送一个 SUBSCRIBE 强制 NOTIFY 包含一个完整的状态
- 出于安全性考虑，通知者受到 SUBSCRIBE 请求，不应返回具体的 220/4xx/6xx 而暴露敏感的策略信息，而是统一返回 202。202 表示理解订阅请求，但是用户未被授权。可在后续的 NOTOFY 中表示接受或拒绝该订阅