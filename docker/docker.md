# docker

- [docker](#docker)
  - [更新Ubuntu内核](#%E6%9B%B4%E6%96%B0ubuntu%E5%86%85%E6%A0%B8)
  - [安装lxc-docker](#%E5%AE%89%E8%A3%85lxc-docker)
  - [测试doctor是否安装成功](#%E6%B5%8B%E8%AF%95doctor%E6%98%AF%E5%90%A6%E5%AE%89%E8%A3%85%E6%88%90%E5%8A%9F)
  - [编译](#%E7%BC%96%E8%AF%91)
  - [运行](#%E8%BF%90%E8%A1%8C)
  - [docker ps 命令：](#docker-ps-%E5%91%BD%E4%BB%A4)
  - [删除容器](#%E5%88%A0%E9%99%A4%E5%AE%B9%E5%99%A8)
  - [其他命令](#%E5%85%B6%E4%BB%96%E5%91%BD%E4%BB%A4)
  - [提交/保存镜像](#%E6%8F%90%E4%BA%A4%E4%BF%9D%E5%AD%98%E9%95%9C%E5%83%8F)

## 更新Ubuntu内核

- 使用如下命令行更新内核至 3.8.0-25
  - `sudo apt-get install linux-image-3.8.0-25-generic`
  - `sudo apt-get install linux-headers-3.8.0-25-generic`
- 完成后重启电脑，通过命令`uname -r`来查看内核是否成功更新

## 安装lxc-docker

- 方法1
  - `sudo apt-get install software-properties-common`增加 add-apt-repository 命令
  - `sudo apt-get install python-software-properties`
  - `sudo add-apt-repository ppa:dotcloud/lxc-docker`增加一个 ppa 源，如：ppa:user/ppa-name
  - `sudo apt-get update`更新系统
  - 方法
    - `sudo apt-get install lxc-docker`
    - `sudo apt-get install docker.io`
- 方法2
  - 载脚本并且安装 Docker 及依赖包`wget -qO- https://get.docker.com/ | sh`

## 测试doctor是否安装成功

- `Docker`
- 停止或者查看服务状态
  - 进入 root 权限
  - `service docker stop/start/restart/status`

## 编译

- 写 Dockerfile
- 在 Dockerfile 同级目录`sudo docker build -t $image_name .`

## 运行

- 当要以非 root 用户可以直接运行 docker 时
  - 需要执行`sudo usermod -aG docker runoob`命令
  - 重启机器，检查当前用户是否在 docker 组中`groups`
- 交互方式`sudo docker run -i -t $image_name /bin/bash`
  - `-t`为构建的镜像制定一个标签，便于记忆/索引等
  - `.`指定 Dockerfile 文件在当前目录下

## docker ps 命令：

- 列出当前正在运行的 container：`sudo docker ps`
- 列出最近一次启动的，且正在运行的 container：`sudo docker ps -l`
- 列出所有的 container：`sudo docker ps -a`

## 删除容器

- 删除所有容器```sudo docker rm `sudo docker ps -a -q` ```
- 删除具体某个容器`sudo docker rm $container_id`

## 其他命令

- 查看本地镜像`sudo docker images`
- 启动一个已经存在的 docker 实例`sudo docker attach $container_id`
- 停止 docker 实例`sudo docker stop $container_id`
- 查看 docker 实例运行日志，确保正常运行`sudo docker logs $container_id`
- 查看 container 的实例属性，如 ip 等`sudo docker inspect $container_id`

## 提交/保存镜像

- 在[docker 网站](https://index.docker.io/)注册一个账号
- 构建镜像`docker build -t $image_name`
- 登录`docker login`
- 提交到 Docker 索引仓库`docker push $image_name`上传 OK 的话，可以得到类似地址：https://index.docker.io/u/yongboy/java7/
- 使用镜像`docker pull $image_name`