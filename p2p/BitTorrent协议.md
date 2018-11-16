# BitTorrent 协议

## 约定

- peers vs 客户端（client）：
  - 一个 peer 可以是任何参与下载的 BitTorrent 客户端
  - 客户端也是一个 peer
- 片（piece） vs 块（block）：
  - 片指在元信息文件中描述的一部分已下载的数据，可通过 sha-1 hash 验证
  - 块是客户端向 peer 请求的一部分数据。两块或更多块可以组成一个完整的可被验证的片
- B 编码（Bencoding）：B 编码是一种以简洁的格式描述和组织数据的方法，支持字节串、整数、lists 和 dictionaries
  - 字节串：
    - 字节串没有开始和结束分隔符
    - 编码方式`<以十进制 ASCII 编码的串长度>:<串数据>`
    - 如：`4:spam`表示字节串"spam"
  - 整数：
    - 编码方式`i<以十进制 ASCII 编码的整数>e`
    - `i`和`e`分别是开始和结束分隔符
    - 如`i0e`，`i-1e`；`i01e`是无效的
  - lists：
    - 编码方式`l<B 编码值>e`
    - `l`是小写的`L`，是开始分隔符；`e`是结束分隔符
    - lists 可以包含任何 B 编码的类型，包括整数、串、dictionaries 和其他的 lists
    - 如`l4:spam4:eggse`表示含义两个串的 lists：["spam", "eggs"]
  - dictionaries：
    - 编码方式`d<B 编码串><B 编码元素>e`
    - `d`和`e`分别是开始和结束分隔符
    - 键 key 必须被 B 编码为串
      - 串必须以排序的方式出现（以原始串排序，而不是字母数字顺序）
      - 串采用二进制比较方式，而不是特定于某种文化的自然比较（不是中文或英文的排序方式）
    - 值 value 可以是任何 B 编码的类型，包括整数、串、lists 和其他的 dictionaries
    - 如 `d3:cow3:moo4:spam4:eggse`表示 dictionaries {"cow"=>"moo", "spam"=>"eggs"}
    - 如 `d4:spaml1:a1:bee`表示 dictionaries {"spam"=>["a", "b"]}

## 重要概念

- 元信息文件结构（Metainfo file structure）：所有数据以 B 编码方式编码
- 元信息文件：一个 B 编码的 dictionary
  - 元信息文件包含的键 key 如下，其中字符串类型的值均以 UTF-8 编码
    - info：dictionary 类型，，值描述了种子文件。该 dictionary 可能是
      - 没有目录结构的单文件，即种子文件只包含一个文件
      - 有目录文件的多文件
    - announce：string 类型，值是 tracker 的 announce URL
    - announce-list： [lists/string] 类型，可选，对正式规范的一个扩展，提供向后兼容性
    - creation date：整数类型，是 unix 时间戳，可选，值是种子文件的创建时间
    - comment：string 类型，可选，值是种子文件制作者的评论
    - create by：string 类型，可选，值是只做种子文件的程序的名称和版本
    - encoding：string 类型，可选，用于生成分片（当info dictionary 过大时，需要对其分片）
  - 元信息文件包含的值 value
    - info dictionary，即 info 对应的值，其单文件和多文件模式公共的键 可以 如下：
      - piece length：整数类型，值是每个 piece 的字节数
        - 一般是 2 的整数次方，根据种子文件数据的总大小来选择 piece 的大小
        - piece 过小使得种子文件过大，piece 过大则降低下载效率
        - 以前的 piece 大小是种子文件不超过 50-75KB，目前保持为 256KB，512KB 或 1MB
        - 除了最后一块，其他块大小相同，piece 的数量取决于  total_length/piece_size
        - 多文件模式的 piece 可能跨越文件边界
      - pieces：string 类型，值由每个 piece的 20 字节 sha1 散列值连接而成，每个 piece 包含一个唯一的 sha1 散列值
      - private：整数类型，可选，值 为 0 或者 1，可不设置，表示是否有外部的 peer 源
        - 值为 1：客户端必须广播自己的存在，通过元信息文件中显式描述的 trackers 得到其他的 peers
        - 不设置或值为 0：客户端可以通过其他方式得到其他的 peers
    - 单文件模式（Single file mode）的 info dictionary 包含的键：
      - name：string 类型，文件名，建议使用
      - length：整数类型，文件所占字节数
      - md5sum：string 类型，可选，相当于文件 MD5 和的 32 个字符的 16 进制字符串， BT 不使用这个键
    - 多文件模式（Multiple file mode）的 info dictionary 包含的键：
      - name：string 类型，存储文件的目录名，建议使用，utf-8
      - name.files：[dictionaries] 每个文件对应一个 dictionary，list 中每个 dictionary 包含的键包括：
        - length：整数类型，文件所占字节数
        - md5sum：string 类型，可选，相当于文件 MD5 和的 32 个字符的 16 进制字符串， BT 不使用这个键
        - path：包含单个或多个元素的 list，元素合成在一起表示文件路径或文件名，utf-8
          - list 中每个元素对应一个目录名或文件名（最后一个元素对应文件名）
          - 如`dir1/dir2/file.txt`会被编码成 B 编码的字符串 list `l4:dir14:dir28:file.txte`
- tracker：响应 HTTP GET 请求的 HTTP/HTTPS 服务
  - 请求包含来自客户端的度量信息，这些信息能够帮助 tracker 全面统计种子文件
  - 响应包含一个 peers 列表

## BitTorrent DHT 协议

### 概述

- peer：在一个 TCP 端口上监听的客户端/服务端，实现了 BitTorrent 协议
- 节点：一个在 UDP 端口上监听的客户端/服务端，实现了 DHT 协议
  - DHT 由节点组成，存储了 peer 的位置
  - BitTorrent 客户端包含一个 DHT 节点，该节点用来联系 DHT 中其他节点，从而得到 peer 的位置，进而通过 BitTorrent 协议下载
- 节点为种子文件寻找 peer 时，返回值包含一个不透明的值，称之为令牌 token。如果一个节点 announce 它控制的 peer 正在下载一个种子，必须在回复中加上被请求方之前在 get_peers 回复中发送的 token
  - 当节点试图 announce 一个种子时，被请求的节点会核对 token 和请求节点的 IP 地址。这可以防止恶意的主机登记其他主机的种子
  - token 只能由请求查询的节点返回给之前发送此 token 给它的节点
  - token 必须在发布的一段时间内被接收，即有时效性。BitTorrent 使用 SHA1 哈希 IP 地址，后面跟上一个 secret（5 分钟改变一次），token 在 10 分钟之内是可接受的

### 路由表

- 每个节点维护一个路由表保存已知的好节点，用来作为在 DHT 请求的起始点。路由表中的节点是在向其他节点请求过程中，被请求的节点回复的
- 一个好的节点是在过去 15 分钟回复过某个请求的节点，或者增加回复过请求而且在过去 15 分钟发送过请求的节点
  - 当节点 15 分钟没有活跃，则成为可疑的节点
  - 当节点连续不能回复时，节点变为坏的
  - 和状态未知的节点相比，已知的好节点有更高的优先级
- 目前每个 k-bucket 中可疑保存 8 个节点，即 k=8
- k-bucket 节点的更新
  - 当得到一个新的好节点时
    - 如果已有节点都是好的，则丢弃新的节点
    - 如果已知有坏节点，则用新节点替换坏节点
    - 如果有可疑的节点，则试图 ping 该节点
      - 收到回复，则 ping 下一个可疑节点，直到遇到未回复的节点或者所有节点都是好的
      - 可疑节点没有回复建议再发一次，仍然没有回复则丢弃，用新节点替换
- 每个 bucket 持有一个 last changed 属性，标记内容的新鲜度
  - ping 一个节点并且收到回复，插入一个新节点，替换一个节点都会更新 bucket 的属性
  - 15 分支没有更新的 bucket 应当被刷新
    - 在 bucket 中随机选取一个 ID，执行一个 find_node 操作
- 当在路由表中插入第一个节点并启动时，节点应该尝试一个 find_node 操作，参数是它本身，以更新 DHT 中此节点临近的节点
- 路由表应保存在客户端软件

### BitTorrent 协议扩展

- BitTorrent 协议扩展用于交换 peer 之间的 UDP 端口数
- 客户端可以通过正常的下载种子文件自动更新路由表
  - 新安装的客户端下载一个没有 tracker 的种子，一开始路由表也没有节点，需要从种子文件获得联系信息
- 支持 DHT 的 peers 在 BitTorrent 的握手协议中设置预留的 8-byte 的最后一位为 1，收到握手的 peer 表明远端的 peer 支持 DHT 协议，应该发送 PORT 消息
  - 消息一 0x09 字节开头，有两个字节的 payload，包含了该 DHT peer 使用的网络字节序的 UDP 端口
  - 收到 PORT 消息的 peer 应该尝试用收到的端口和 IP 地址 ping 这个节点。如果收到回复，该节点应该插入这个新的联系方式到它的路由表

### 种子文件扩展

- 一个没有 tracker 的种子 dictionary 没有 announce 键
  - 取而代之的是 nodes 键，这个键设为客户端路由表中 k 个最近的节点
  - 也可以设置为已知的好的节点，比如种子文件的创建者
- 不要自动加入`router.bittorrent.com`到种子文件或者自动加入此节点到客户端路由表
  - 一开始节点不在 DHT 网络中，可以向`router.bittorrent.com:6881`或`dht.transmissionbt.com:6881`等发送 find_node 请求

### KRPC 协议

- KRPC 协议是一个简单的 RPC 结构，由 bencode 编码的 dictionaries 组成，通过 UDP 发送
- 发出去一个单独的查询包然后回复一个单独的包，消息不会重试
- 有三种消息类型
  - 查询 query，有四种查询：ping，find_node，get_peers，announce_peer
  - 回复 response，
  - 错误 error，
- 一个 KRPC 消息是一个单独的 dictionary，有三个共同的键以及和消息类型相关的附加键
  - t：string 类型，表示会话 transaction ID，由查询节点生成，回复的时候携带，因此回复可能和同一节点的多个查询相关
    - 会话 ID 应当被编码成二进制的段字符串，比如 2 个字节可以覆盖 2^16 个请求
  - y：单字符类型，描述消息类型，q-query，r-response，e-error
  - v：字符串类型，表示客户端版本，2 个字符表示客户端注册标识符，2 个字符表示版本标记
    - 不是所有实现有包含 v 键
- 联系信息编码 contact encoding
  - peers 的联系信息被编码为 6 字节的字符串，又被称为“Compact IP-address/port info”
    - 4 字节的 IP 地址，网络字节序
    - 2 字节的端口，网络字节序
  - 节点的联系信息被编码为 26 字节的字符串，又被称为“Compact node info”
    - 20 字节的 Node ID，网络字节序
    - 6 字节的 “Compact IP-address/port info”
- 查询 query 消息字典
  - y：q
  - q：string 类型，包含 query 的 method 名称
  - a：dictionary 类型，包含参数名字和值
- 回复 response 消息字典
  - y：r
  - r：dictionary 类型，包含返回值名字和值
  - 当查询正确执行完成之后才会发送回复消息
- 错误 error 消息字典
  - y：e
  - e：list 类型
    - 第一个元素是一个整数代表错误码
      - 201：generic 错误
      - 202：server 错误
      - 203：protocol 错误，比如 malformed packet，无效参数，bad token
      - 204：未知的 method
    - 第二个元素是一个 string 包含错误消息
    - 当一个查询不能完成的时候发送错误消息
  - 比如`generic error={"t":"aa", "y":"e", "e":[201, "A Generic Error Occured"]}`
    - bencode 编码是`d1:eli201e23:A Generic Error Occurred1:t2:aa1:y1:ee`

### DHT 查询

- 所有的查询都有一个 id 的键，表示查询节点的 Node ID，所有的回复有一个 id 的键，表示回复节点的 Node ID
- ping：`"q"="ping"`
  - id：string 类型，20 字节，指的发送者的节点 ID，网络字节序
  - 回复的键只有 id 表示回复者的节点 ID

    ```json
      ping query:{"t":"aa", "y":"q", "q":"ping", "a":{"id":"querying_node_id"}}
      {"bencoded": "d1:ad2:id14:querying_node_ide1:q4:ping1:t2:aa1:y1:qe"}
      response:{"t":"aa", "y":"r", "r":{"id":"queried_nodes_id"}
      {"bencoded": "d1:rd2:id16:queried_node_ide1:t2:aa1:y1:re"}
    ```

- find_node：`"q"="find_node"`
  - 指定节点 ID，查询节点的联系信息
  - id：查询节点的 ID
  - target：查询者要查询的节点 ID
  - 回复的键
    - id：接收者的节点 ID
    - nodes：string 类型，包含目的节点的紧密（compact）信息或者接收者路由表中 k 个最近最好的节点信息
- get_peers：`"q"="get_peers"`
  - 请求与种子文件的 info_hash 相关
  - id：查询节点的 ID
  - info_hash：种子文件的 info_hash 值
  - 回复的键：接收者有 info_hash 的 peers 则返回 values，否则返回 nodes
    - id：接收者的节点 ID
    - token：用于后续的 announce_peer 查询，是一个短的二进制字符串
    - values：list of string 类型，每个字符串包含一个紧密（compact）格式的 peer 信息
    - nodes：接收节点路由表最接近 info_hash 的 k 个节点信息
- announce_peer：`"q"="announce_peer"`
  - 宣布一个控制请求节点的 peer 正在某个端口下载一个种子文件
  - id：查询请求节点的 ID
  - info_hash：种子文件的 info_hash
  - port：整数类型，表示在哪个端口下载
  - token：之前的一个“get_peers”回复中的 token
    - 被请求的节点必须验证 token 之前发送的节点 IP 地址与请求节点相同，然后被请求的节点保存这个请求节点的 IP 地址和提供的端口到它自己的 peer 联系信息
  - implied_port：可选，0 或者 1，如果存在且不为 0，port 参数值应该忽略，而且 UDP 包的源端口应作为 peer 的端口
    - 这对于 NAT 之后的 peer 有用，因为 peer 不知道自己外部端口，但是支持 uTP，接收同一 DHT 端口的连接
- 总结：DHT 是一个 hash 表，发送 KRPC 的 find_node 或 get_peers 消息，就是对表执行 get(key) 操作，发送 announce_peer 消息，就是对表执行 set(key,val) 操作

## Bittorrent DHT 几个重要过程

### 种子制作

- use_tracker 设置为 false，则不会产生 announce tracker 字段
- 读取本地路由表文件，从中找到 k 个离 info_hash 最近的节点，作为 nodes 字段

### 启动过程

- 从路由表文件装载之前保存的路由表 k-bucket 信息，初始化内存路由表信息
- 强制刷新路由表的每一个 k-bucket，刷新过世是随机产生一个 id 进行 find_node 操作

### 刷新路由表

- 启动的时候强制刷新
- 每 15 分钟如果 k-bucket 中信息没有更新，则刷新一次，即 refreshTable
- 每 5 分钟进行一次 checkPoint 操作，把当前的路由表保存到 routing_table 文件
  - routing_table 文件格式`{'id':node_id, 'host':node_host, 'port':node_port, 'age':int(node_age)}`
- 每个路由表的 k-bucket 有一个 last changed 属性，具体描述参考上面的`BitTorrent DHT 协议`->`路由表`