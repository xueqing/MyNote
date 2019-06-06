# 2 Redis 命令

- [2 Redis 命令](#2-redis-%E5%91%BD%E4%BB%A4)
  - [2.1 命令](#21-%E5%91%BD%E4%BB%A4)
  - [2.2 键命令](#22-%E9%94%AE%E5%91%BD%E4%BB%A4)
  - [2.3 字符串命令](#23-%E5%AD%97%E7%AC%A6%E4%B8%B2%E5%91%BD%E4%BB%A4)
  - [2.4 哈希命令](#24-%E5%93%88%E5%B8%8C%E5%91%BD%E4%BB%A4)
  - [2.5 列表命令](#25-%E5%88%97%E8%A1%A8%E5%91%BD%E4%BB%A4)
  - [2.6 集合命令](#26-%E9%9B%86%E5%90%88%E5%91%BD%E4%BB%A4)
  - [2.7 有序集合命令](#27-%E6%9C%89%E5%BA%8F%E9%9B%86%E5%90%88%E5%91%BD%E4%BB%A4)
  - [2.8 Redis HyperLogLog 命令](#28-redis-hyperloglog-%E5%91%BD%E4%BB%A4)
  - [2.9 Redis 发布订阅命令](#29-redis-%E5%8F%91%E5%B8%83%E8%AE%A2%E9%98%85%E5%91%BD%E4%BB%A4)
  - [2.10 Redis 事务命令](#210-redis-%E4%BA%8B%E5%8A%A1%E5%91%BD%E4%BB%A4)
  - [2.11 Redis 脚本命令](#211-redis-%E8%84%9A%E6%9C%AC%E5%91%BD%E4%BB%A4)
  - [2.12 Redis 连接命令](#212-redis-%E8%BF%9E%E6%8E%A5%E5%91%BD%E4%BB%A4)
  - [2.13 Redis 服务器命令](#213-redis-%E6%9C%8D%E5%8A%A1%E5%99%A8%E5%91%BD%E4%BB%A4)

## 2.1 命令

通过 Redis 客户端再 Redis 服务上执行 Redis 命令

```sh
# 启动客户端，连接本地 redis 服务
redis-cli
# 检查 redis 服务是否启动
PING
# 连接远程 redis 服务
redis-cli -h host -p port -a password
```

- 避免中文乱码 `redis-cli --raw`

## 2.2 键命令

用于管理 redis 的 key：`COMMAND key_name`

| 命令 | 描述 |
| --- | --- |
| DEL key | key 存在时删除 key |
| DUMP key | 序列化 key，返回被序列化的值 |
| EXISTS key | 检查 key 是否存在 |
| EXPIRE key seconds | 为给定 key 设置过期时间，以秒计 |
| EXPIREAT key timestamp | EXPIREAT 的作用和 EXPIRE 类似，都用于为 key 设置过期时间。EXPIREAT 命令接受的时间参数是 UNIX 时间戳(unix timestamp) |
| PEXPIRE key milliseconds | 设置 key 的过期时间以毫秒计 |
| PEXPIREAT key milliseconds-timestamp | 设置 key 过期时间的时间戳(unix timestamp) 以毫秒计 |
| KEYS pattern | 查找所有符合给定模式(pattern)的 key |
| MOVE key db | 将当前数据库的 key 移动到给定的数据库 db 当中 |
| PERSIST key | 移除 key 的过期时间，key 将持久保持 |
| PTTL key | 以毫秒为单位返回 key 的剩余的过期时间 |
| TTL key | 以秒为单位，返回给定 key 的剩余生存时间(TTL, time to live) |
| RANDOMKEY | 从当前数据库中随机返回一个 key |
| RENAME key newkey | 修改 key 的名称 |
| RENAMENX key newkey | 仅当 newkey 不存在时，将 key 改名为 newkey |
| TYPE key | 返回 key 所储存的值的类型 |

## 2.3 字符串命令

用于管理字符串值：`COMMAND key_name`

| 命令 | 描述 |
| --- | --- |
| SET key value | 设置 key 的值 |
| GET key | 获取 key 的值 |
| GETRANGE key start end | 返回 key 中字符串值的子字符 |
| GETSET key value | 将 key 的值设为 value ，并返回 key 的旧值(old value) |
| GETBIT key offset | 对 key 所储存的字符串值，获取指定偏移量上的位(bit) |
| MGET key1 [key2..] | 获取所有(一个或多个)给定 key 的值 |
| SETBIT key offset value | 对 key 所储存的字符串值，设置或清除指定偏移量上的位(bit) |
| SETEX key seconds value | 将值 value 关联到 key ，并将 key 的过期时间设为 seconds (秒) |
| SETNX key value | 只有在 key 不存在时设置 key 的值 |
| SETRANGE key offset value | 用 value 覆写给定 key 所储存的字符串值，从偏移量 offset 开始 |
| STRLEN key | 返回 key 所储存的字符串值的长度 |
| MSET key value [key value ...] | 同时设置一个或多个 key-value 对 |
| MSETNX key value [key value ...] | 同时设置一个或多个 key-value 对，当且仅当所有给定 key 都不存在 |
| PSETEX key milliseconds value | 和 SETEX 命令相似，以毫秒为单位设置 key 的生存时间 |
| INCR key | 将 key 中储存的数字值增一 |
| INCRBY key increment | 将 key 所储存的值加上给定的增量值(increment) |
| INCRBYFLOAT key increment | 将 key 所储存的值加上给定的浮点增量值(increment) |
| DECR key | 将 key 中储存的数字值减 1 |
| DECRBY key decrement | key 所储存的值减去给定的减量值(decrement) |
| APPEND key value | 如果 key 已经存在并且是一个字符串， 将 value 追加到该 key 原来值的末尾 |

## 2.4 哈希命令

| 命令 | 描述 |
| --- | --- |
| HDEL key field1 [field2] | 删除一个或多个哈希表字段 |
| HEXISTS key field | 查看哈希表 key 中，指定的字段是否存在 |
| HGET key field | 获取存储在哈希表中指定字段的值 |
| HGETALL key | 获取在哈希表中指定 key 的所有字段和值 |
| HINCRBY key field increment | 为哈希表 key 中的指定字段的整数值加上增量 increment |
| HINCRBYFLOAT key field increment | 为哈希表 key 中的指定字段的浮点数值加上增量 increment |
| HKEYS key | 获取所有哈希表中的字段 |
| HLEN key | 获取哈希表中字段的数量 |
| HMGET key field1 [field2] | 获取所有给定字段的值 |
| HMSET key field1 value1 [field2 value2 ] | 同时将多个 field-value (域-值)对设置到哈希表 key 中 |
| HSET key field value | 将哈希表 key 中的字段 field 的值设为 value |
| HSETNX key field value | 只有在字段 field 不存在时，设置哈希表字段的值 |
| HVALS key | 获取哈希表中所有值 |
| HSCAN key cursor [MATCH pattern] [COUNT count] | 迭代哈希表中的键值对 |

## 2.5 列表命令

| 命令 | 描述 |
| --- | --- |
| BLPOP key1 [key2 ] timeout | 移出并获取列表的第一个元素， 如果列表没有元素会阻塞列表直到等待超时或发现可弹出元素为止 |
| BRPOP key1 [key2 ] timeout | 移出并获取列表的最后一个元素， 如果列表没有元素会阻塞列表直到等待超时或发现可弹出元素为止 |
| BRPOPLPUSH source destination timeout | 从列表中弹出一个值，将弹出的元素插入到另外一个列表中并返回它； 如果列表没有元素会阻塞列表直到等待超时或发现可弹出元素为止 |
| LINDEX key index | 通过索引获取列表中的元 |
| LINSERT key BEFORE|AFTER pivot value | 在列表的元素前或者后插入元 |
| LLEN key | 获取列表长 |
| LPOP key | 移出并获取列表的第一个元 |
| LPUSH key value1 [value2] | 将一个或多个值插入到列表头 |
| LPUSHX key value | 将一个值插入到已存在的列表头 |
| LRANGE key start stop | 获取列表指定范围内的元 |
| LREM key count value | 移除列表元 |
| LSET key index value | 通过索引设置列表元素的 |
| LTRIM key start stop | 对一个列表进行修剪(trim)，就是说，让列表只保留指定区间内的元素，不在指定区间之内的元素都将被删除 |
| RPOP key | 移除列表的最后一个元素，返回值为移除的元素 |
| RPOPLPUSH source destination | 移除列表的最后一个元素，并将该元素添加到另一个列表并返 |
| RPUSH key value1 [value2] | 在列表中添加一个或多个 |
| RPUSHX key value | 为已存在的列表添加 |

## 2.6 集合命令

| 命令 | 描述 |
| --- | --- |
| SADD key member1 [member2] | 向集合添加一个或多个成员 |
| SCARD key | 获取集合的成员数 |
| SDIFF key1 [key2] | 返回给定所有集合的差集 |
| SDIFFSTORE destination key1 [key2] | 返回给定所有集合的差集并存储在 destination 中 |
| SINTER key1 [key2] | 返回给定所有集合的交集 |
| SINTERSTORE destination key1 [key2] | 返回给定所有集合的交集并存储在 destination 中 |
| SISMEMBER key member | 判断 member 元素是否是集合 key 的成员 |
| SMEMBERS key | 返回集合中的所有成员 |
| SMOVE source destination member | 将 member 元素从 source 集合移动到 destination 集合 |
| SPOP key | 移除并返回集合中的一个随机元素 |
| SRANDMEMBER key [count] | 返回集合中一个或多个随机数 |
| SREM key member1 [member2] | 移除集合中一个或多个成员 |
| SUNION key1 [key2] | 返回所有给定集合的并集 |
| SUNIONSTORE destination key1 [key2] | 所有给定集合的并集存储在 destination 集合中 |
| SSCAN key cursor [MATCH pattern] [COUNT count] | 迭代集合中的元素 |

## 2.7 有序集合命令

| 命令 | 描述 |
| --- | --- |
| ZADD key score1 member1 [score2 member2] | 向有序集合添加一个或多个成员，或者更新已存在成员的分数 |
| ZCARD key | 获取有序集合的成员数 |
| ZCOUNT key min max | 计算在有序集合中指定区间分数的成员数 |
| ZINCRBY key increment member | 有序集合中对指定成员的分数加上增量 increment |
| ZINTERSTORE destination numkeys key [key ...] | 计算给定的一个或多个有序集的交集并将结果集存储在新的有序集合 key 中 |
| ZLEXCOUNT key min max | 在有序集合中计算指定字典区间内成员数量 |
| ZRANGE key start stop [WITHSCORES] | 通过索引区间返回有序集合成指定区间内的成员 |
| ZRANGEBYLEX key min max [LIMIT offset count] | 通过字典区间返回有序集合的成员 |
| ZRANGEBYSCORE key min max [WITHSCORES] [LIMIT] | 通过分数返回有序集合指定区间内的成员 |
| ZRANK key member | 返回有序集合中指定成员的索引 |
| ZREM key member [member ...] | 移除有序集合中的一个或多个成员 |
| ZREMRANGEBYLEX key min max | 移除有序集合中给定的字典区间的所有成员 |
| ZREMRANGEBYRANK key start stop | 移除有序集合中给定的排名区间的所有成员 |
| ZREMRANGEBYSCORE key min max | 移除有序集合中给定的分数区间的所有成员 |
| ZREVRANGE key start stop [WITHSCORES] | 返回有序集中指定区间内的成员，通过索引，分数从高到底 |
| ZREVRANGEBYSCORE key max min [WITHSCORES] | 返回有序集中指定分数区间内的成员，分数从高到低排序 |
| ZREVRANK key member | 返回有序集合中指定成员的排名，有序集成员按分数值递减(从大到小)排序 |
| ZSCORE key member | 返回有序集中，成员的分数值 |
| ZUNIONSTORE destination numkeys key [key ...] | 计算给定的一个或多个有序集的并集，并存储在新的 key 中 |
| ZSCAN key cursor [MATCH pattern] [COUNT count] | 迭代有序集合中的元素(包括元素成员和元素分值) |

> 集合是通过哈希表实现的，所以添加，删除，查找的复杂度都是O(1)其实不太准确
>
> 在redis sorted sets里面当items内容大于64的时候同时使用了hash和skiplist两种设计实现。这也会为了排序和查找性能做的优化。所以如上可知：
>
>> 添加和删除都需要修改skiplist，所以复杂度为O(log(n))。但是如果仅仅是查找元素的话可以直接使用hash，其复杂度为O(1)。
>> 其他的range操作复杂度一般为O(log(n))。
>
> 当然如果是小于64的时候，因为是采用了ziplist的设计，其时间复杂度为O(n)

## 2.8 Redis HyperLogLog 命令

- Redis 2.8.9 版本添加 HyperLogLog 结构，用于做基数统计
- 优点：输入元素的数量或提交非常大时，计算基数所需空间小且固定
- 原因：HyperLogLog 只根据输入元素计算基数，不会存储元素本身。所以也不能返回输入的各个元素
- 基数估计：在误差可接受范围内，快速计算基数

| 命令 | 描述 |
| --- | --- |
| PFADD key element [element ...] | 添加指定元素到 HyperLogLog 中 |
| PFCOUNT key [key ...] | 返回给定 HyperLogLog 的基数估算值 |
| PFMERGE destkey sourcekey [sourcekey ...] | 将多个 HyperLogLog 合并为一个 HyperLogLog |

## 2.9 Redis 发布订阅命令

- Redis 发布订阅(pub/sub)是一种消息通信模式：发送者发送消息，订阅者接收消息
  - Redis 客户端可以订阅任意数量的频道

| 命令 | 描述 |
| --- | --- |
| PSUBSCRIBE pattern [pattern ...] | 订阅一个或多个符合给定模式的频道 |
| PUBSUB subcommand [argument [argument ...]] | 查看订阅与发布系统状态 |
| PUBLISH channel message | 将信息发送到指定的频道 |
| PUNSUBSCRIBE [pattern [pattern ...]] | 退订所有给定模式的频道 |
| SUBSCRIBE channel [channel ...] | 订阅给定的一个或多个频道的信息 |
| UNSUBSCRIBE [channel [channel ...]] | 退订给定的频道 |

## 2.10 Redis 事务命令

- Redis 事务可一次执行多个命令，且保证
  - 批量操作在发送 EXEC 命令前被放入缓存队列
  - 收到 EXEC 命令后进入事务执行，事务中任意命令执行失败，其余命令仍旧执行
  - 事务执行过程中，其他客户端提交的命令请求不会插入到事务执行命令序列
- 一个事务从开始到执行有三个阶段：开始事务、命令入列、执行事务
- **注意**：单个 Redis 命令的执行是原子性的。但 Redis 未在事务上增加维护原子性的机制，所以 Redis 事务的执行不是原子性的
  - 事务可理解为一个打包的批量执行脚本，但批量指令不是原子化的，中间指令的失败不会回滚前面已做指令，也不会停止执行后续指令
- 事务的原子性是指：事务要么完整的被执行，要么完全不执行

| 命令 | 描述 |
| --- | --- |
| DISCARD | 取消事务，放弃执行事务块内的所有命令 |
| EXEC | 执行所有事务块内的命令 |
| MULTI | 标记一个事务块的开始 |
| UNWATCH | 取消 WATCH 命令对所有 key 的监视 |
| WATCH key [key ...] | 监视一个(或多个) key ，如果在事务执行之前这个(或这些) key 被其他命令所改动，那么事务将被打断 |

## 2.11 Redis 脚本命令

- Redis 脚本使用 Lua 解释器执行脚本。Redis 2.6 内嵌支持 Lua 环境

| 命令 | 描述 |
| --- | --- |
| EVAL script numkeys key [key ...] arg [arg ...] | 执行 Lua 脚本 |
| EVALSHA sha1 numkeys key [key ...] arg [arg ...] | 执行 Lua 脚本 |
| SCRIPT EXISTS script [script ...] | 查看指定的脚本是否已经被保存在缓存当中 |
| SCRIPT FLUSH | 从脚本缓存中移除所有脚本 |
| SCRIPT KILL | 杀死当前正在运行的 Lua 脚本 |
| SCRIPT LOAD script | 将脚本 script 添加到脚本缓存中，但并不立即执行这个脚本 |

## 2.12 Redis 连接命令

| 命令 | 描述 |
| --- | --- |
| AUTH password | 验证密码是否正确 |
| ECHO message | 打印字符串 |
| PING | 查看服务是否运行 |
| QUIT | 关闭当前连接 |
| SELECT index | 切换到指定的数据库 |

## 2.13 Redis 服务器命令

- `INFO` 命令获取 Redis 服务器的统计信息

| 命令 | 描述 |
| --- | --- |
| BGREWRITEAOF | 异步执行一个 AOF(AppendOnly File) 文件重写操作 |
| BGSAVE | 在后台异步保存当前数据库的数据到磁盘 |
| CLIENT KILL [ip:port] [ID client-id] | 关闭客户端连接 |
| CLIENT LIST | 获取连接到服务器的客户端连接列表 |
| CLIENT GETNAME | 获取连接的名称 |
| CLIENT PAUSE timeout | 在指定时间内终止运行来自客户端的命令 |
| CLIENT SETNAME connection-name | 设置当前连接的名称 |
| CLUSTER SLOTS | 获取集群节点的映射数组 |
| COMMAND | 获取 Redis 命令详情数组 |
| COMMAND COUNT | 获取 Redis 命令总数 |
| COMMAND GETKEYS | 获取给定命令的所有键 |
| TIME | 返回当前服务器时间 |
| COMMAND INFO command-name [command-name ...] | 获取指定 Redis 命令描述的数组 |
| CONFIG GET parameter | 获取指定配置参数的值 |
| CONFIG REWRITE | 对启动 Redis 服务器时所指定的 redis.conf 配置文件进行改写 |
| CONFIG SET parameter value | 修改 redis 配置参数，无需重启 |
| CONFIG RESETSTAT | 重置 INFO 命令中的某些统计数据 |
| DBSIZE | 返回当前数据库的 key 的数量 |
| DEBUG OBJECT key | 获取 key 的调试信息 |
| DEBUG SEGFAULT | 让 Redis 服务崩溃 |
| FLUSHALL | 删除所有数据库的所有key |
| FLUSHDB | 删除当前数据库的所有key |
| INFO [section] | 获取 Redis 服务器的各种信息和统计数值 |
| LASTSAVE | 返回最近一次 Redis 成功将数据保存到磁盘上的时间，以 UNIX 时间戳格式表示 |
| MONITOR | 实时打印出 Redis 服务器接收到的命令，调试用 |
| ROLE | 返回主从实例所属的角色 |
| SAVE | 同步保存数据到硬盘 |
| SHUTDOWN [NOSAVE] [SAVE] | 异步保存数据到硬盘，并关闭服务器 |
| SLAVEOF host port | 将当前服务器转变为指定服务器的从属服务器(slave server) |
| SLOWLOG subcommand [argument] | 管理 redis 的慢日志 |
| SYNC | 用于复制功能(replication)的内部命令 |
