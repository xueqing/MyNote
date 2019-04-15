# Node.js 环境搭建

- [Node.js 环境搭建](#nodejs-%E7%8E%AF%E5%A2%83%E6%90%AD%E5%BB%BA)
  - [1 版本要求](#1-%E7%89%88%E6%9C%AC%E8%A6%81%E6%B1%82)
  - [2 提供以下四种方式安装(PS: 建议第四种方式安装)](#2-%E6%8F%90%E4%BE%9B%E4%BB%A5%E4%B8%8B%E5%9B%9B%E7%A7%8D%E6%96%B9%E5%BC%8F%E5%AE%89%E8%A3%85ps-%E5%BB%BA%E8%AE%AE%E7%AC%AC%E5%9B%9B%E7%A7%8D%E6%96%B9%E5%BC%8F%E5%AE%89%E8%A3%85)
    - [2.1 调用官网脚本自动安装](#21-%E8%B0%83%E7%94%A8%E5%AE%98%E7%BD%91%E8%84%9A%E6%9C%AC%E8%87%AA%E5%8A%A8%E5%AE%89%E8%A3%85)
    - [2.2 使用二进制包文件](#22-%E4%BD%BF%E7%94%A8%E4%BA%8C%E8%BF%9B%E5%88%B6%E5%8C%85%E6%96%87%E4%BB%B6)
      - [2.2.1 设置文件路径](#221-%E8%AE%BE%E7%BD%AE%E6%96%87%E4%BB%B6%E8%B7%AF%E5%BE%84)
      - [2.2.2 建立软连接](#222-%E5%BB%BA%E7%AB%8B%E8%BD%AF%E8%BF%9E%E6%8E%A5)
    - [2.3 apt 安装](#23-apt-%E5%AE%89%E8%A3%85)
  - [3 查看nodejs的版本](#3-%E6%9F%A5%E7%9C%8Bnodejs%E7%9A%84%E7%89%88%E6%9C%AC)
  - [4 查看npm的版本](#4-%E6%9F%A5%E7%9C%8Bnpm%E7%9A%84%E7%89%88%E6%9C%AC)

## 1 版本要求

- node >= 8.x 目前稳定版本为 10.x
- npm >= 5.x

## 2 提供以下四种方式安装(PS: 建议第四种方式安装)

### 2.1 调用官网脚本自动安装

- [参考](https://github.com/nodesource/distributions/blob/master/README.md#debinstall)

```sh
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install -y nodejs
```

### 2.2 使用二进制包文件

#### 2.2.1 设置文件路径

```sh
# 按下载版本修改 VERSION
VERSION=v10.15.1
DISTRO=linux-x64
sudo mkdir -p /usr/local/lib/nodejs
sudo tar -xJvf node-$VERSION-$DISTRO.tar.xz -C /usr/local/lib/nodejs
```

#### 2.2.2 建立软连接

```sh
VERSION=v10.15.1
DISTRO=linux-x64
sudo ln -s /usr/local/lib/nodejs/node-$VERSION-$DISTRO/bin/node /usr/bin/node
sudo ln -s /usr/local/lib/nodejs/node-$VERSION-$DISTRO/bin/npm /usr/bin/npm
sudo ln -s /usr/local/lib/nodejs/node-$VERSION-$DISTRO/bin/npx /usr/bin/npx
```

### 2.3 apt 安装

安装版本较低，需手动更新

```sh
# 安装 nodejs
sudo apt install node
# 安装 nodejs 的依赖库管理工具 npm
sudo apt install npm
# 安装 nodejs 版本管理工具 n
sudo npm install n -g
# 升级 nodejs 的版本
sudo n stable
```

或者

```sh
sudo apt install node
sudo apt install npm
# 升级 npm
sudo npm install npm@latest -g
# 升级 node
sudo npm install -g n
sudo n stable
```

## 3 查看nodejs的版本

```sh
node
# 或
node -v
```

## 4 查看npm的版本

```sh
npm -v
```