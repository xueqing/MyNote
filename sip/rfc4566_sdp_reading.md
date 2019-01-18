# sdp

术语 | 描述
--- | ---
会议 | 一个多媒体会议是一个集合，这个集合包含两个或更多的通信用户以及用于通信的软件
会话 | 一个多媒体会话是一个集合，这个集合包含发送者和接受者，以及他们之间所通信的媒体流。多媒体会议是多媒体会话的一个例子
会话描述 | 定义良好的格式，用于传送足够的信息来发现和参与一个多媒体会话

- 两个目的
  - 通讯一个会话的存在性
  - 传递足够的信息使能连接和参加到存在的会阿虎

```text
    v=  (protocol version)
    o=  (owner/creator and session identifier)
    s=  (session name)
    i=* (session information)
    u=* (URI of description)
    e=* (email address)
    p=* (phone number)
    c=* (connection information - not required if included in all media)
    b=* (bandwidth information)
    One or more time descriptions (see below)
    z=* (time zone adjustments)
    k=* (encryption key)
    a=* (zero or more session attribute lines)
    Zero or more media descriptions (see below)

    # Time description
    t=  (time the session is active) (t=<start time>  <stop time>)
    r=* (zero or more repeat times) (r=<repeat interval> <active duration> <list of offsets from start-time>)

    # Media description
    m=  (media name and transport address) (m=<media> <port>/<number of ports> <transport> <fmt list>)
    i=* (media title)
    c=* (connection information - optional if included at session-level)
    b=* (bandwidth information)
    k=* (encryption key)
    a=* (zero or more media attribute lines)
```

- 不能解析的属性可以忽略
- `a=* (zero or more session attribute lines)`非标准格式的名字以`X-`为前缀，但是不推荐使用`X-`前缀的参数
- `m=<media> <port>/<number of ports> <transport> <fmt list>`
  - media 可以是 audio/video/application/text/message (data/control 弃用)
  - port 1024~65535 (udp 限制)，偶数 (RTP 兼容性，大一位的奇数是 RTCP 端口)
- 检验 sdp 的信息和媒体流的链路信息是否一致(包括接收地址端口和发送地址端口)