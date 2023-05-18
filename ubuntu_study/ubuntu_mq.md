# rabbitMQ 环境搭建

- [rabbitMQ 环境搭建](#rabbitmq-%E7%8E%AF%E5%A2%83%E6%90%AD%E5%BB%BA)
  - [1 安装依赖](#1-%E5%AE%89%E8%A3%85%E4%BE%9D%E8%B5%96)
  - [2 安装 RabbitMQ](#2-%E5%AE%89%E8%A3%85-rabbitmq)
  - [3 启用 RabbitMQ 管理控制台](#3-%E5%90%AF%E7%94%A8-rabbitmq-%E7%AE%A1%E7%90%86%E6%8E%A7%E5%88%B6%E5%8F%B0)
    - [3.1 创建用户并设置角色](#31-%E5%88%9B%E5%BB%BA%E7%94%A8%E6%88%B7%E5%B9%B6%E8%AE%BE%E7%BD%AE%E8%A7%92%E8%89%B2)
  - [4 RabbitMQ 服务命令](#4-rabbitmq-%E6%9C%8D%E5%8A%A1%E5%91%BD%E4%BB%A4)
  - [5 修改服务配置文件](#5-%E4%BF%AE%E6%94%B9%E6%9C%8D%E5%8A%A1%E9%85%8D%E7%BD%AE%E6%96%87%E4%BB%B6)

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

## 3 启用 RabbitMQ 管理控制台

启用管理插件和 STOMP 插件:

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

## 4 RabbitMQ 服务命令

```sh
# 启动服务
# sudo service rabbitmq-server start
sudo systemctl start rabbitmq-server
# 停止服务
sudo systemctl stop rabbitmq-server
# 重启服务
sudo systemctl restart rabbitmq-server
# 检查服务状态
sudo systemctl status rabbitmq-server
```

## 5 修改服务配置文件

```sh
# 如果需要管理最大连接数，修改配置文件
sudo vim /etc/default/rabbitmq-server
```

## 6 编译源码

- 环境：Linux
- 源码地址：
  - rabbitmq-c <https://github.com/alanxz/rabbitmq-c.git>
  - SimpleAmqpClient <https://github.com/alanxz/SimpleAmqpClient.git>

### 编译 rabbitmq-c

```sh
# git checkut v0.9.0-master
mkdir build
cd build
cmake ..
```

### 编译 SimpleAmqpClient

```sh
mkdir build
cd build
cmake ..
## 如果找不到 boost 库: 报错
## Imported targets not available for Boost version
# cmake -DBoost_INCLUDE_DIR=local_boost_header_dir/ -DBoost_LIBRARY_DIR=local_boost_library_dir/ ..
## 如果报错 ERROR: Boost_LIBRARYDIR is not the correct spelling.  The proper spelling is BOOST_LIBRARYDIR.
## 修改对应的 cmake 文件，比如 /usr/share/cmake-3.5/Modules/FindBoost.cmake，
## 注释掉 _Boost_CHECK_SPELLING(Boost_LIBRARYDIR)
## 如果找不到 rabbitmqc 库: 报错
## Rabbitmqc_INCLUDE_DIR=Rabbitmqc_INCLUDE_DIR-NOTFOUND
## Rabbitmqc_LIBRARY=Rabbitmqc_LIBRARY-NOTFOUND
# cmake -DBoost_INCLUDE_DIR=local_boost_header_dir/ -DBoost_LIBRARY_DIR=local_boost_library_dir/ -DRabbitmqc_INCLUDE_DIR=local_rabbitmqc_header_dir/ -DRabbitmqc_LIBRARY=/local_rabbitmqc_library_dir/librabbitmq.so.4.3.0 ..
## v2.4.0 编译报错
## SimpleAmqpClient/src/Channel.cpp:185:1: error: prototype for ‘AmqpClient::Channel::Channel(const string&, int, const string&, const string&, const string&, int, const string&, const string&, const string&)’ does not match any in class ‘AmqpClient::Channel’
## 切换到较新版本
# git checkut eefabcdb25b6adf841dcc226abfdce94c27a4446
make
```
