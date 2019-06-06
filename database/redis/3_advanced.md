# 3 Redis 进阶

- [3 Redis 进阶](#3-redis-%E8%BF%9B%E9%98%B6)
  - [3.1 Redis 数据备份与恢复](#31-redis-%E6%95%B0%E6%8D%AE%E5%A4%87%E4%BB%BD%E4%B8%8E%E6%81%A2%E5%A4%8D)
  - [3.2 Redis 安全](#32-redis-%E5%AE%89%E5%85%A8)
  - [3.3 Redis 性能测试](#33-redis-%E6%80%A7%E8%83%BD%E6%B5%8B%E8%AF%95)
  - [3.4 Redis 客户端命令](#34-redis-%E5%AE%A2%E6%88%B7%E7%AB%AF%E5%91%BD%E4%BB%A4)
  - [3.5 Redis 管道技术](#35-redis-%E7%AE%A1%E9%81%93%E6%8A%80%E6%9C%AF)
  - [3.6 Redis 分区](#36-redis-%E5%88%86%E5%8C%BA)

## 3.1 Redis 数据备份与恢复

| 命令 | 描述 |
| --- | --- |
| SAVE | 创建当前数据库的备份，在 Redis 安装目录创建 dump.rdb 文件 |
| CONFIG GET dir | 获取 Redis 安装目录。将备份文件 dump.rdb 移动到安装目录并启动服务即可 |
| BGSAVE | 在后台执行命令，创建 Redis 备份文件 |

## 3.2 Redis 安全

- 通过配置文件设置密码，使得客户端连接到 Redis 服务需要密码验证

| 命令 | 描述 |
| --- | --- |
| CONFIG get requirepass | 查看是否设置了密码验证。默认 requirepass 参数为空，即无需密码 |
| CONFIG set requirepass password | 设置密码。之后客户端连接 Redis 服务需要密码验证 |
| AUTH password | 输入密码验证 |

## 3.3 Redis 性能测试

- 通过同时执行多个命令实现性能测试
- 基本命令 `redis-benchmark [option] [option value]`
  - 在 Redis 安装目录下执行
  - 不是 Redis 客户端的内部命令

| 可选参数 | 描述 | 默认值 |
| --- | --- | --- |
| -h | 指定服务器主机名 | 127.0.0.1 |
| -p | 指定服务器端口 | 6379 |
| -s | 指定服务器 socket | - |
| -c | 指定并发连接数 | 50 |
| -n | 指定请求数 | 10000 |
| -d | 以字节的形式指定 SET/GET 值的数据大小 | 2 |
| -k | 1=keep alive 0=reconnect | 1 |
| -r | SET/GET/INCR 使用随机 key, SADD 使用随机值 | - |
| -P | 通过管道传输 numreq 请求 | 1 |
| -q | 强制退出 redis。仅显示 query/sec 值 | - |
| --csv | 以 CSV 格式输出 | - |
| -l | 生成循环，永久执行测试 | - |
| -t | 仅运行以逗号分隔的测试命令列表 | - |
| -I | Idle 模式。仅打开 N 个 idle 连接并等待 | - |

## 3.4 Redis 客户端命令

- Redis 通过监听一个 TCP 端口或 Unix socket 方式接收来自客户端的连接。建立一个连接后，Redis 内部会进行
  - 客户端 socket 被设置为非阻塞模式，因为 Redis 在网络事件处理上采用的是非阻塞多路复用模型
  - 为该 socket 设置 TCP_NODELAY 属性，禁用 Nagle 算法
  - 创建一个可读的文件事件用于监听该客户端 socket 的数据发送
- 最大连接数： Redis 2.4 中，最大连接数被硬编码到代码内部。2.6 之后可配置
  - `CONFIG get maxclients` 查看最大连接数
  - `CONFIG set maxclients 1000` 修改最大连接数
  - `redis-server --maxclients 10000` 在服务启动时设置最大连接数

| 命令 | 描述 |
| --- | --- |
| CLIENT LIST | 返回连接到 Redis 服务的客户端列表 |
| CLIENT SETNAME | 设置当前连接的名称 |
| CLIENT GETNAME | 获取通过 CLIENT SETNAME 命令设置的服务名称 |
| CLIENT PAUSE | 挂起客户端连接，指定挂起的时间以毫秒计 |
| CLIENT KILL | 关闭 |

## 3.5 Redis 管道技术

- Redis 是一种基于客户端-服务端模型以及请求/响应协议的 TCP 服务。一般步骤
  - 客户端向服务端发送一个查询请求，并监听 socket 返回。通常以阻塞模式，等待服务端响应
  - 服务端处理命令，将结果返回给客户端
- Redis 管道技术可在服务端未响应时，客户端可继续向服务端发送请求，并最终一次性读取所有服务端的响应
- 管道技术提高了 Redis 服务的性能

## 3.6 Redis 分区

- 分区是分割数据到多个 Redis 实例的处理过程。每个实例只保存 key 的一个子集
- 优势
  - 通过利用多台计算机内存的和值，使得可以构造更大的数据库
  - 通过多核和多台计算机，支持扩展计算能力；通过多台计算机和网络适配器，支持扩展网络带宽
- 不足
  - 通常不支持涉及多个 key 的操作。如，当两个 set 映射到不同的 Redis 实例上时，不能对两个 set 做交集操作
  - 不能使用涉及多个 key 的 Redis 事务
  - 数据处理复杂。如，需要处理多个 rdb/aof 文件，并且从多个实例和主机备份持久化文件
  - 增删容量复杂。Redis 集群大多支持在运行时增删节点的透明数据平衡能力。类似于客户端分区、代理等其他系统则不支持此特性。可参考 presharding 技术
- 分区类型
  - 范围分区：映射一定范围的对象到特定的 Redis 实例
    - 不足：要有一个区间范围到实例的映射表，要管理表和各种对象的映射表
  - 哈希分区：对任何 key 都适用。操作方法
    - 用一个 hash 函数将 key 转换为一个数字
    - 对整数取模(按照 Redis 实例数目)，从而映射到其中一个 Redis 实例
