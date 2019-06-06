# 1 Redis 简介

- [1 Redis 简介](#1-redis-%E7%AE%80%E4%BB%8B)
  - [1.1 key-value 缓存产品特点](#11-key-value-%E7%BC%93%E5%AD%98%E4%BA%A7%E5%93%81%E7%89%B9%E7%82%B9)
  - [1.2 Redis 优点](#12-redis-%E4%BC%98%E7%82%B9)
  - [1.3 Redis 配置](#13-redis-%E9%85%8D%E7%BD%AE)
  - [1.4 Redis 数据类型](#14-redis-%E6%95%B0%E6%8D%AE%E7%B1%BB%E5%9E%8B)
  - [1.5 Redis 数据库](#15-redis-%E6%95%B0%E6%8D%AE%E5%BA%93)

## 1.1 key-value 缓存产品特点

- 支持数据持久化：可将内存数据保存到磁盘，重启的时候再次加载使用
- 支持简单的 key-value 类型，也支持 list/set/zset/hash 数据的存储
- 支持数据备份：master-slave 模式的数据备份

## 1.2 Redis 优点

- 性能极高：读写速度快
- 数据类型丰富：支持 string/list/hash/set/zset(sorted set)
- 原子性：单个操作是原子性的。多个操作支持事务，即原子性，通过 MULTI 和 EXEC 指令包起来
- 特性丰富：支持 publish/subscribe，通知，key 过期等

## 1.3 Redis 配置

- 配置文件位于安装目录，文件名 `redis.conf`(Windows 下是 `redis.windows.conf`)
- 查看配置项 `CONFIG GET CONFIG_STRING_NAME`
  - `CONFIG_STRING_NAME` 为 `*` 表示获取所有配置项
- 设置配置项 `CONFIG GET CONFIG_STRING_NAME NEW_CONFIG_VALUE`

## 1.4 Redis 数据类型

| 类型 | 简介 | 特性 | 命令 | 场景 |
| --- | --- | ---- | --- | --- |
| string | key-value | 二进制安全，即 string 可包含任何数据(jpg 对象或序列化的对象等) |`SET key val`/`GET key` | - |
| hash | key-value 对集合，即编程中的 Map | 适合存储对象，可像数据库只修改某一属性值 | `HMSET hash_name key1 val1 [key2 val2...]`/`HGET hash_name key` | 存储/读取/修改用户属性 |
| list | string 列表(双向链表)，按插入顺序排序，下标从 0 开始 | 增删快，可操作某一段元素 | `lpush list_key value`/`lrange list_key start_index end_index` | 消息队列；最新消息排行等(如朋友圈时间线) |
| set | string 无序集合，不允许 member 重复，hash 表实现 | 增删查的复杂度都是 O(1)；为集合提供交并差运算 |`sadd set_key member`：添加 member 到 set_key 对应的集合，成功返回 1，已存在返回 0，set_key 对应集合不存在返回错误；`smembers set_key` | 共同好友；利用唯一性，统计访问网站的所有独立 IP；根据 tag 求交集，大于某阈值可推荐好友 |
| zset | string 集合，member 唯一，score 可重复。score是 double 类型，根据 score 为 member 从小到大排序 | 数据插入时已排序 | `zadd zset_key score member`/`ZEANGEBYSCORE zset_key score1 score2` | 排行榜；带权重的消息队列 |

## 1.5 Redis 数据库

- 一个 Redis 示例提供了多个字典用于存储数据。客户端可指定存储的字典。每个字典可理解成一个独立的数据库。每个数据库数据隔离不共享
- Redis 不支持自定义数据名字，每个数据库以编号(0 开始)命名。默认支持 16 个数据库，可通过配置文件修改
- 客户端连接 Redis 之后，默认选择 0 号数据库，可使用 `SELECT db_no` 更换数据库
- 局限性
  - 开发者需要自己记录每个数据库存储的数据
  - 不支持为每个数据库单独设置密码。所以所有数据库的权限是绑定的
  - 多个数据库不是完全隔离，如 `FLUSHALL` 可清除一个 Redis 示例所有数据库的数据。所以不建议多个应用程序使用一个 Redis 实例的不同数据库存储数据。且 Redis 是轻量级的，一个空的实例占用内存很小
