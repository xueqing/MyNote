# ubuntu_redis

- 安装 redis`sudo apt-get install redis-server`
- 修改配置文件`/etc/redis/redis.conf`
  - 注释`bind 127.0.0.1`
  - 添加`requirepass admin`
  - 重启 redis 服务`sudo service redis-server restart`
- 进入 redis`redis-cli`，`auth admin`
- 查看 redis 内存`keys *`
- 退出 redis`exit`