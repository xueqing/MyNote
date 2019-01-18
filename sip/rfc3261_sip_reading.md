# SIP

- [SIP](#sip)
  - [请求的消息头](#%E8%AF%B7%E6%B1%82%E7%9A%84%E6%B6%88%E6%81%AF%E5%A4%B4)
  - [回复的消息头](#%E5%9B%9E%E5%A4%8D%E7%9A%84%E6%B6%88%E6%81%AF%E5%A4%B4)
  - [消息](#%E6%B6%88%E6%81%AF)
  - [处理应答](#%E5%A4%84%E7%90%86%E5%BA%94%E7%AD%94)
  - [Invite 客户事务](#invite-%E5%AE%A2%E6%88%B7%E4%BA%8B%E5%8A%A1)
  - [应答代码](#%E5%BA%94%E7%AD%94%E4%BB%A3%E7%A0%81)

## 请求的消息头

- 举例：以 Alice 向 Bob 发起会话为例

```text
    INVITE sip:bob@biloxi.com SIP/2.0
    Via: SIP/2.0/UDP pc33.atlanta.com;branch=z9hG4bK776asdhds
    Max-Forwards: 70
    To: Bob <sip:bob@biloxi.com>
    From: Alice <sip:alice@atlanta.com>;tag=1928301774
    Call-ID: a84b4c76e66710@pc33.atlanta.com
    CSeq: 314159 INVITE
    Contact: <sip:alice@pc33.atlanta.com>
    Content-Type: application/sdp
    Content-Length: 142
    (Alice’s SDP not shown)
```

名称 | 描述
--- | ---
Method name | 位于第一行(INVITE sip:bob@biloxi.com SIP/2.0)
Via | 描述当前请求经历的路径，表示了应答所应当经过的路径。包含请求发起者期待收到回复的地址(pc33.atlanta.com)。包含一个 branch 参数标识会话(branch=z9hG4bK776asdhds)，**branch 必须以 "z9hG4bK" 开头**。缩写是 v
To | 包含一个展示名(Bob)和一个 SIP 或 SIPS URI(sip:bob@biloxi.com)，标识请求原本要发送的目的地。缩写是 t
From | 包含一个展示名(Alice)和一个 SIP 或 SIPS URI(sip:alice@atlanta.com)，指示请求的发起者。也包含一个 tag 参数，包含一个随机的字符串。用于身份目的。简写是 f
Call-ID | 包含此会话的一个全局唯一标识符，由一个随机字符串和这个 softphone 的主机名或 IP 地址联合生成
CSeq | Command Sequence，包含一个整数和一个方法名。在一个会话中，每一个新的请求，CSeq 会加 1
Contact | 包含一个 SIP 或 SIPS URI，表示直接路由到此请求发起者，通常是一个 FQDN(fully qualified domain name) 上的一个用户名。如果没有注册域名，可以使用 IP 地址
Max-Forwards | 限制一个请求到达目的地的转发次数。每跳一次数目减 1
Content-Type | 描述请求的消息体，简写是 c
Content-Length | 请求的消息体的十进制字节数，简写是 I

- To tag，From tag 和 Call-ID 完全定义了一个端到端的 SIP 关系，称为一个会话
- Via 告诉其它元素回复发送到哪里；Contact 告诉其它元素未来的请求发送到哪里
- 回复和请求包含一样的 To，From，Call-ID，CSeq，Via 的 branch
- 代理服务：atlanta.com SIP server 是一个代理服务。代理服务接收 SIP 请求，代表请求者转发请求
  - 100 (Trying)：表示代理服务已经收到请求，正在代表请求者路由请求到目的地
  - 代理服务器路由之前，会在 Via 加上或者删掉自己的地址信息

其他头域

名称 | 描述
--- | ---
Route | 用于强制一个请求经过一个 proxy 路由列表，保证正确路由
Record-Route | proxy 在请求中增加的，包含解析代理主机名或 IP 地址的 URI，用于强制会话中的后续请求经过本 proxy
Content-Encoding | 如果消息正文通过某种形式的编码，如压缩等，必须在此头域指明，简写是 e
Content-Language | 消息正文的语言
Content-Disposition | 指明消息体部分并非可选的消息体，描述消息体，或者消息的多个部分，或者消息体的一部分应被 UAC 或 UAS 怎样解释
Supported | 包含了一个 option tag 的列表，列举了 UAC 或 UAS 支持的 SIP 扩展，必须是 RFCs 的标准扩展。缩写是 k
Require | 说明处理本特定请求需要什么样的 option tags，以便 UAS 可以处理 UAC 的特定请求
Proxy-Require | 说明需要 proxy 支持什么样的 option tag 扩展
Unsupported | UAS 回复中，表明不支持的扩展
Accept | UAS 指明支持的媒体类别
Accept-Encoding | UAS 指明支持的编码方法
Accept-Language | UAS 指明支持的语言
Allow | UAS 列举支持的方法
expires | 有效时间，以秒为单位的整数，非法值视为 3600
Retry-After | 可用于 500 或 503 应答，标识大约服务还会处于不可用状态多久；在 404,413,480,486,600,603 应答标识何时被叫方会恢复正常，以秒为单位
Warning | UAS 回复中，表明拒绝服务的原因，包括一个 3 位的警告代码，主机名和警告正文
In-Reply-To | 列举了本次呼叫相关的或者返回的 Call-ID
Min-Expires | 包含了一个服务器所支持的内部状态(soft-state)的最小的刷新时间间隔，包括被注册服务器所注册的 Contact 头域
Organization | 包含了发出请求或者应答的 SIP 节点所属的组织名字。可以用于让客户端软件过滤呼叫
Priority | 标识了客户端请求的紧急程度，描述了 SIP 应当处理人工或者 UA 发过来的请求的优先级
Proxy-Authenticate | 认证使用
Proxy-Authorization | 允许客户端向一个要求认证的 proxy 证明自己(或证明它的使用者)的身份
WWW-Authenticate | 包含了认证信息
Server | 包含了关于 UAS 处理请求所使用的软件信息
Subject | 提供了呼叫的一个概览，允许呼叫不用分析会话描述就可以大致过滤。缩写是 s
Timestamp | 描述了 UAC 发送请求到 UAS 的时间戳
User-Agent | 包含了发起请求的 UAC 信息

## 回复的消息头

- 举例：以 Bob 回复 Alice 为例

```text
    SIP/2.0 200 OK
    Via: SIP/2.0/UDP server10.biloxi.com
        ;branch=z9hG4bKnashds8;received=192.0.2.3
    Via: SIP/2.0/UDP bigbox3.site3.atlanta.com
        ;branch=z9hG4bK77ef4c2312983.1;received=192.0.2.2
    Via: SIP/2.0/UDP pc33.atlanta.com
        ;branch=z9hG4bK776asdhds ;received=192.0.2.1
    To: Bob <sip:bob@biloxi.com>;tag=a6c85cf
    From: Alice <sip:alice@atlanta.com>;tag=1928301774
    Call-ID: a84b4c76e66710@pc33.atlanta.com
    CSeq: 314159 INVITE
    Contact: <sip:bob@192.0.2.4>
    Content-Type: application/sdp
    Content-Length: 131
    (Bob’s SDP not shown)
```

名称 | 描述
--- | ---
响应码和原因短语 | 位于第一行，如 200 和 OK
Via | 和请求相同，多的两个是二者的代理服务分别添加的
To | 和请求相同，添加了 tag 参数，会话双方在未来的通讯中会用这两个 tag
From | 和请求相同
Call-ID | 和请求相同
CSeq | 和请求相同
Contact | 包含回复一方可以直接到达的 URI
Content-Type | 描述回复的消息正文，包括消息的媒体类别
Content-Length | 回复的消息正文的十进制字节数

## 消息

- SIP 协议基于文本，使用 utf-8 字符集
- 每个消息包括一个起始行，一个或多个头域，一个空行标识头域的结束，一个可选的消息体
  - CRLF：carriage-return(回车) line-feed(换行)
  - SP: space，空格
  - 请求的开始行是 Request-Line
  - 回复的开始行是 Status-Line
    - 客户端不要求检查或显示 reason-phrase
  - `HCOLON = *(SP/HTAB) ":" SWS`允许在冒号之前有空白，但是不允许有行分隔符，并且允许在冒号之后有空白，或者行分隔符
    - 推荐冒号之前无空格，冒号之后有一个空格
    - HTAB 水平制表符，即 Tab 键
    - `LWS = [*WSP CRLF] 1*WSP` 线性空白
    - `SWS = [LWS]` 线性空白可选
  - 不同的 header-name 的顺序是无关的，但是建议将代理处理流程相关的域放在前面；相同的 header-name 的顺序是有关的

```text
    generic-message  =  start-line
                        *message-header
                        CRLF
                        [ message-body ]
    start-line       =  Request-Line / Status-Line
    Request-Line     =  Method SP Request-URI SP SIP-Version CRLF
    Status-Line      =  SIP-Version SP Status-Code SP Reason-Phrase CRLF
    message-header   =  "header-name" HCOLON header-value *(COMMA header-value)
```

## 处理应答

- UAC 对于不能识别的最终响应，必须将其视为对应的 x00 类的响应代码，且 UAC 必须能够处理所有的 x00 响应代码
- UAC 必须能够处理 100 和 183 (会话进行) 响应
- 在应答中，有不止一个 Via 头域值存在，UAC 应该丢弃这个消息。包含超过一个 Via 头域值的消息是因为被错误的路由或者消息被破坏

## Invite 客户事务

- T1：是一个估计的循环时间（round-trip time，RTT），缺省设置为 500ms

## 应答代码

- 临时应答 1xx：标志了对方服务器正在处理请求，还没有决定最后应答。如果服务需要 200ms 以上才可产生最终应答，应发送一个 1xx 应答。1xx 不是可靠传输的，不会导致客户端发送 ACK。可以包含消息体，描述会话

应答码 | 描述
--- | ---
100 Trying | 表示下一个节点的服务器以及接收到请求且还未执行这个请求。和其他临时应答的不同点在于，它永远不会被有状态 proxy 转发到上行流
180 Ringing | UA 收到 Invite 请求并尝试提示客户
181 Call is Being Forwarded | 表示呼叫正在转发到另一个目的地集合
182 Queued | 当呼叫的对方暂时不能接收呼叫，且服务器决定将呼叫排队等候，而不是拒绝呼叫
183 Session Progress | 用于提示建立对话的进度信息。Reason-Phrase (表达原因的句子)、头域或消息体可用于提示呼叫进度的更详细的信息

- 成功信息 2xx：表示请求是成功的

应答码 | 描述
--- | ---
200 OK | 请求已经处理成功。应答的信息取决于请求的方法

- 转发请求 3xx： 用于提示用户的新位置信息，或为了满足呼叫转发的可选服务地点

应答码 | 描述
--- | ---
300 Multiple Choices | 请求的地址有多个选择，每个选择都有自己的地址，用户或 UA 可选择合适的通讯终端，并且转发请求到这个地址
301 Moved Permanently | 不能在 Request-URI 指定的地址找到用户，请求的客户端应使用 Contact 头域所指出的新地址重新尝试
302 Moved Temporarily | 请求方应把请求重新发到这个 Contact 所指出的新地址
305 Use Proxy | 请求的资源必须通过 Contact 头域中指出的 proxy 来访问。接收到这个应答的对象应通过这个 proxy 重新发送这个请求
380 Alternative Service | 呼叫不成功，但是可以尝试可选的服务

- 请求失败 4xx：定义了特定服务响应的请求失败的情况

应答码 | 描述
--- | ---
400 Bad Request | 请求语法错误。Reason-Phrase 应当标识这个详细的语法错误
401 Unauthorized | 请求需要用户认证，应答是由 UAS 和 注册服务器产生的，407 是 proxy 服务器产生的
402 Payment Required | 预留，之后使用
403 Forbidden | 服务器支持这个请求，但是拒绝执行请求。增加验证信息是没有必要的，并且请求不应该被重试
404 Not Found | 用户在 Request-URI 指定的域不存在。当 Request-URI 的 domain 和 接收这个请求的 domain 不匹配时，也会产生这个应答
405 Method Not Found | 服务器支持 Request-Line 的方法，但是这个 Request-URI 的地址不允许使用这个方法。应答应包含一个 Allow 头域，包含了指定地址允许的方法列表
406 Not Acceptable | 请求的资源只能产生回复实体包含的内容不被请求的 Accept 域接收
407 Proxy Authentication Required | 标志了客户端应首先在 proxy 上通过认证
408 Request Timeout | 在一段时间内，服务器不能产生一个终结应答。客户端可稍后不更改请求内容重试请求
410 Gone | 请求的资源在服务器上已经不存在了，且不知道应把请求转发到哪里
413 Request Entity Too Large | 请求实体超过了服务器期望或可以处理的大小
414 Request-URI Too Long | Request-URI 超过了服务器可以处理的长度
415 Unsupported Media Type | 服务器不支持请求的消息体格式，服务器必须根据内容的故障类型返回一个 Accept，Accept-Encoding 或 Accept-Language
416 Unsupported URI Scheme | 服务器不支持 Request-URI 的 URI 方案
420 Bad Extension | 服务器不知道请求的 Proxy-Require 或 Require 指出的协议扩展。在应答的 Unsupported 头域中列出不支持的扩展
421 Extension Required | UAS 需要特定的扩展来处理请求，但是请求的 Supported 头域没有列出。应答的 Require 头域应列出所需扩展
423 Interval Too Brief | 请求设置的资源刷新时间(或有效时间)过短而被服务器拒绝。比如注册服务器拒绝 Contact 头域中有效期过短的注册请求
480 Temporarily Unavailable | 请求到达被叫方，但被叫方当前不可用。应增加一个 Retry-After 告诉呼叫方多久可以重试呼叫，Reason-Phrase 应当有详细信息
481 Call/Transaction Does Not Exist | UAS 收到请求，但是没有和现存的对话或事务匹配
482 Loop Detected | 服务器检测到循环
483 Too Many Hops | 请求的 Max-Forwards 头域是 0
484 Address Incomplete | Request-URI 不完整，Reason-Phrase 应当有附加信息
485 Ambiguous | Request-URI 是不明确的
486 Busy Here | 成功联系到被叫方的终端系统，但是被叫方在当前终端不能接听，应增加一个 Retry-After 告诉呼叫方多久可以重试呼叫。其它终端(如电话、邮箱)可能有效。如果知道没有其他终端系统可以接受呼叫，返回 600
487 Request Terminated | 请求被 BYE 或 CANCEL 终止
488 Not Acceptable Here | 和 606 相同，但只应用于 Request-URI 所指出的特定资源不能接受，在其它地方请求可能可以接受
491 Request Pending | 同一对话中，UAS 收到的请求有一个依赖的请求正在处理
493 Undecipherable | UAS 收到的请求包含了一个加密的 MIME，且不知道或没有提供合适的解密密钥

- 服务错误 5xx：服务器本身故障的时候给出的失败应答

应答码 | 描述
--- | ---
500 Server Internal Error | 服务器遇到未知的情况，不能继续处理请求
501 Not Implemented | 服务器没有实现相关请求功能
502 Bad Gateway | 服务器作为 gateway 或 proxy，从下行服务器收到一个非法应答
503 Service Unavailable | 由于临时过载或服务器管理导致的服务器暂时不可用。可增加一个 Retry-After 告诉呼叫方多久可以继续呼叫
504 Server Time-out | 服务器在一个外部服务器上没有收到及时的应答。如果从上行服务器收到的请求中 Expires 超时，则返回 408
505 Version Not Supported | 服务器不支持对应的 SIP 版本
513 Message Too Large | 消息长度超过服务器可以处理的长度

- 全局错误 6xx：服务给特定用户有一个最终的信息，并不只是在 Request-URI 的特定实例有最终信息

应答码 | 描述
--- | ---
600 Busy Everywhere | 成功连到到被叫方的终端系统，但是被叫方处于忙的状态，不打算接听电话。可增加一个 Retry-After 告诉呼叫方多久可以继续呼叫
603 Decline | 成功访问到被叫方的设备，但是用户明确的不行应答。可增加一个 Retry-After 告诉呼叫方多久可以继续呼叫
604 Does Not Exist Anywhere | Request-URI 中的用户信息验证失败
606 Not Acceptable | 成功联系到 UA，但是会话描述的一部分(如请求的媒体、带宽或地址类型)不被接受