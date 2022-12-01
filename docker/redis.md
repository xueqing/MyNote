# 使用 docker 安装和配置 redis

- [使用 docker 安装和配置 redis](#使用-docker-安装和配置-redis)
  - [下载镜像](#下载镜像)
  - [下载配置文件](#下载配置文件)
    - [配置文件其他参数](#配置文件其他参数)
  - [启动 redis](#启动-redis)
  - [连接和查看 redis 容器](#连接和查看-redis-容器)

## 下载镜像

```sh
# 拉取镜像
docker pull redis
# 查看本地镜像
docker images | grep redis
```

## 下载配置文件

从官网下载配置文件 [redis.conf](http://download.redis.io/redis-stable/redis.conf)。下载之后进行修改：

- 注释 `bind 127.0.0.1`，该语句限制只能本地访问

### 配置文件其他参数

- `protected-mode no`，该语句开启保护模式，限制为本地访问
- `daemonize no`，该语句以守护进程方式启动，可后台运行，除非 kill 进程
- `dir ./`，输入本地 redis 数据库存放文件夹
- `appendonly yes`，该语句表示持久化 redis

## 启动 redis

```sh
# 挂载本地配置文件(上面修改之后的配置文件)
## redis-server /etc/redis/redis.conf 表示以配置文件启动 redis，找到挂载的本地配置文件
## --appendonly yes 表示持久化 redis
docker run --name redis --restart=always -p 6379:6379 -v /opt/docker/redis.conf:/etc/redis/redis.conf -v /opt/docker/data:/data -d redis redis-server /etc/redis/redis.conf --appendonly yes --requirepass "some-password"
# 不挂载配置文件
# docker run --name redis --restart=always -p 6379:6379 -d redis redis-server --appendonly yes --requirepass "some-password"
# 查看 redis
docker ps | grep redis
```

## 连接和查看 redis 容器

```sh
# 进入 redis 容器
docker exec -it redis /bin/bash
# 连接 redis
## -h ip_addr 指定 redis 的 ip，不指定默认连接 127.0.0.1
redis-cli -h ip_addr
```
