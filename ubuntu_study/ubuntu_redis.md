# redis 环境搭建

- [redis 环境搭建](#redis-%E7%8E%AF%E5%A2%83%E6%90%AD%E5%BB%BA)
  - [1 安装 redis-server](#1-%E5%AE%89%E8%A3%85-redis-server)
  - [2 命令](#2-%E5%91%BD%E4%BB%A4)
  - [3 开启远程访问并加密访问](#3-%E5%BC%80%E5%90%AF%E8%BF%9C%E7%A8%8B%E8%AE%BF%E9%97%AE%E5%B9%B6%E5%8A%A0%E5%AF%86%E8%AE%BF%E9%97%AE)

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
# 查看 redis 内存
keys *
# 退出 redis
exit
```

## 3 开启远程访问并加密访问

```sh
sudo vim /etc/redis/redis.conf
# 开启远程访问
# 注释掉 bind 127.0.0.1

# 加密访问
# 打开注释 requirepass xxxxx，并且把密码 xxxx 改为 admin
```