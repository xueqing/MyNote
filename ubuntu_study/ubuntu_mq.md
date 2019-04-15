# rabbitMQ 环境搭建

- [rabbitMQ 环境搭建](#rabbitmq-%E7%8E%AF%E5%A2%83%E6%90%AD%E5%BB%BA)
  - [1 安装依赖](#1-%E5%AE%89%E8%A3%85%E4%BE%9D%E8%B5%96)
  - [2 安装 RabbitMQ](#2-%E5%AE%89%E8%A3%85-rabbitmq)
  - [3 启用 WEB UI](#3-%E5%90%AF%E7%94%A8-web-ui)
    - [3.1 创建用户并设置角色](#31-%E5%88%9B%E5%BB%BA%E7%94%A8%E6%88%B7%E5%B9%B6%E8%AE%BE%E7%BD%AE%E8%A7%92%E8%89%B2)

## 1 安装依赖

```sh
# 添加 erlang 源到 apt 仓库
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
sudo dpkg -i erlang-solutions_1.0_all.deb
# 更新安装
sudo apt-get update
sudo apt-get install erlang
```

## 2 安装 RabbitMQ

```sh
# 调用官方安装脚本
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.deb.sh | sudo bash
# 添加 RabbitMQ 签名 (会出现 403 错误，可忽略不运行)
wget -O- https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | sudo apt-key add -
# 更新并安装
sudo apt-get update  #（可忽略不运行）
sudo apt-get install rabbitmq-server
```

## 3 启用 WEB UI

启用管理插件和STOMP插件:

```sh
sudo rabbitmq-plugins enable rabbitmq_management rabbitmq_stomp
# 重启服务器
sudo systemctl restart rabbitmq-server
```

登录 <http://localhost:15672> web管理页面 默认提供 guest 账号(密码：guest)，但是该账号只提供 localhost 登录，所以需要单独创建用户，使用 rabbitmqctl。
用户相关命令如下：

```sh
$ sudo rabbitmqctl help | grep user
    add_user <username> <password>  # 创建用户
    delete_user <username>          # 删除用户
    change_password <username> <newpassword>  # 修改密码
    clear_password <username>                 # 清楚密码，直接登录
    authenticate_user <username> <password>   # 测试用户认证（我也不知道2333）
    set_user_tags <username> <tag> ...        # 设置用户权限 []
    list_users
    set_permissions [-p <vhost>] <user> <conf> <write> <read>
    clear_permissions [-p <vhost>] <username>
    list_user_permissions <username>
```

### 3.1 创建用户并设置角色

创建管理员用户，负责整个 MQ 的运维：

```sh
# 添加用户
sudo rabbitmqctl add_user  admin  admin
# 赋予其 administrator 角色
sudo rabbitmqctl set_user_tags admin administrator
# 为用户赋权
sudo rabbitmqctl  set_permissions -p / admin '.*' '.*' '.*'
# 查看权限
sudo rabbitmqctl list_user_permissions admin
```