# 在 docker 容器内获取宿主机 CPU 和 MAC 地址

- docker 内获取的 mac 地址不包含在宿主机的 mac 地址列表内，且考虑到可能使用环境变量的方式修改 docker 容器内的 mac 地址

```sh
# 1 拉取基础镜像
docker pull ubuntu:16.04
# 2 创建目录
mkdir -p docker-image/ubuntu-dmidecode && cd docker-image/ubuntu-dmidecode
# 3 编写 Dockerfile
## ====== Dockerfile begin ======
FROM ubuntu:16.04
MAINTAINER kiki
RUN  sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list
### 更新 apt
RUN  apt-get update && apt-get install -y
### 安装依赖
RUN  apt-get install dmidecode -y \
  && apt-get install lshw -y
## ====== Dockerfile end ======
# 4 制作镜像
docker build -t xxx:5000/ubuntu-dmidecode-lshw .
## 查看镜像
docker images
## 运行容器
docker run -i -t xxx:5000/ubuntu-dmidecode-lshw /bin/bash
## 进入 docker 之后，运行 dmidecode
dmidecode
lshw
# 5 推送到私有仓库
docker push xxx:5000/ubuntu-dmidecode-lshw
```
