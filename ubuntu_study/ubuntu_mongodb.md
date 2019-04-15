# mongodb 环境搭建

- [mongodb 环境搭建](#mongodb-%E7%8E%AF%E5%A2%83%E6%90%AD%E5%BB%BA)
  - [1 apt 安装](#1-apt-%E5%AE%89%E8%A3%85)
  - [2 命令](#2-%E5%91%BD%E4%BB%A4)
    - [2.1 启动 MongoDB](#21-%E5%90%AF%E5%8A%A8-mongodb)
    - [2.2 查看状态 MongoDB](#22-%E6%9F%A5%E7%9C%8B%E7%8A%B6%E6%80%81-mongodb)
    - [2.3 重新启动 MongoDB](#23-%E9%87%8D%E6%96%B0%E5%90%AF%E5%8A%A8-mongodb)
    - [2.4 停止 MongoDB](#24-%E5%81%9C%E6%AD%A2-mongodb)
  - [3 卸载 MongoDB](#3-%E5%8D%B8%E8%BD%BD-mongodb)
  - [4 设置开机自启动](#4-%E8%AE%BE%E7%BD%AE%E5%BC%80%E6%9C%BA%E8%87%AA%E5%90%AF%E5%8A%A8)
  - [5 开启远程访问](#5-%E5%BC%80%E5%90%AF%E8%BF%9C%E7%A8%8B%E8%AE%BF%E9%97%AE)
  - [6 故障问题](#6-%E6%95%85%E9%9A%9C%E9%97%AE%E9%A2%98)

## 1 apt 安装

```sh
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org
echo "mongodb-org hold" | sudo dpkg --set-selections
echo "mongodb-org-server hold" | sudo dpkg --set-selections
echo "mongodb-org-shell hold" | sudo dpkg --set-selections
echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
echo "mongodb-org-tools hold" | sudo dpkg --set-selections

```

## 2 命令

### 2.1 启动 MongoDB

```sh
sudo service mongod start
```

### 2.2 查看状态 MongoDB

```sh
sudo service mongod status
```

### 2.3 重新启动 MongoDB

```sh
sudo service mongod restart
```

### 2.4 停止 MongoDB

```sh
sudo service mongod stop
```

## 3 卸载 MongoDB

```sh
sudo service mongod stop
sudo apt-get purge mongodb-org*
sudo rm -r /var/log/mongodb
sudo rm -r /var/lib/mongodb
```

## 4 设置开机自启动

```sh
sudo systemctl enable mongod
```

## 5 开启远程访问

```sh
sudo vim /etc/mongod.conf
# 把 bindIp:127.0.0.1 修改为 bindIp:0.0.0.0

# 之后重启服务
sudo service mongod restart
```

## 6 故障问题

- 遇到连接拒绝问题 `Failed to connect to 127.0.0.1:27017, in(checking socket for error after poll), reason: Connection refused`，执行下面命令可解决

```sh
sudo rm /var/lib/mongodb/mongod.lock
sudo service mongod restart
```