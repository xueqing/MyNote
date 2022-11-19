# redis 环境搭建

- [redis 环境搭建](#redis-环境搭建)
  - [1 安装 redis-server](#1-安装-redis-server)
  - [2 命令](#2-命令)
    - [2.1.1 关于 key 的命令](#211-关于-key-的命令)
    - [2.1.2 关于 hash 的命令](#212-关于-hash-的命令)
  - [3 开启远程访问并加密访问](#3-开启远程访问并加密访问)
  - [4 参考](#4-参考)

## 1 安装 redis-server

```sh
sudo apt-get install redis-server
```

## 2 命令

```sh
# 查看 redis 的版本
redis-server -v
# 重启 redis 服务
sudo service redis-server restart
# 进入 redis
redis-cli
auth admin
# 查看 redis 内存，即获取 redis 中所有的 key
keys *
# 退出 redis
exit
```

### 2.1.1 关于 key 的命令

```sh
# 查找所有符合给定模式 pattern 的 key
keys pattern
# del 命令用于删除已存在的键。不存在的 key 会被忽略
del key_name
```

### 2.1.2 关于 hash 的命令

```sh
# hgetall 命令用于返回哈希表中，所有的字段和值
# 在返回值里，紧跟每个字段名(field name)之后是字段的值(value)，所以返回值的长度是哈希表大小的两倍
# 若 key 不存在，返回空列表
hgetall key_name
# hget 命令用于返回哈希表中指定字段的值
# 如果给定的字段或 key 不存在时，返回 nil
hget key_name field_name
```

## 3 开启远程访问并加密访问

```sh
sudo vim /etc/redis/redis.conf
# 开启远程访问
# 注释掉 bind 127.0.0.1，改为 bind 0.0.0.0
# 如果有其他 bind 语句也注释

## 配置外网访问需要修改 Linux 防火墙(iptables)，开启 redis 端口
# -A INPUT -m state -state NEW -m tcp -p tcp -dport 6379 -j ACCEPT
# ...
# -A INPUT -j REJECT -reject-with icmp-host-prohibited
# 执行 service iptables restart

# 加密访问
# 打开注释 requirepass xxxxx，并且把密码 xxxx 改为 admin
sudo systemctl restart redis-server.service 
```

- 不建议在公网访问 redis，因为 redis 处理速度非常快。所以如果密码简单，外部用户可通过暴力破解密码

## 4 参考

- [Redis 教程](https://www.runoob.com/redis/redis-tutorial.html)
