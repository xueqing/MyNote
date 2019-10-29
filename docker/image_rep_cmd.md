# 镜像仓库命令

- [镜像仓库命令](#%e9%95%9c%e5%83%8f%e4%bb%93%e5%ba%93%e5%91%bd%e4%bb%a4)
  - [登录/退出](#%e7%99%bb%e5%bd%95%e9%80%80%e5%87%ba)
  - [拉取镜像](#%e6%8b%89%e5%8f%96%e9%95%9c%e5%83%8f)
  - [上传镜像](#%e4%b8%8a%e4%bc%a0%e9%95%9c%e5%83%8f)

## 登录/退出

```sh
# 登陆到一个 Docker 镜像仓库，如果未指定镜像仓库地址，默认为官方仓库 Docker Hub
docker login [OPTIONS] [SERVER]
# 登出一个 Docker 镜像仓库，如果未指定镜像仓库地址，默认为官方仓库 Docker Hub
docker logout [OPTIONS] [SERVER]
```

OPTIONS 说明：

- -u: 登陆的用户名
- -p: 登陆的密码

登陆到 Docker Hub。

```sh
docker login -u username -p password
```

登出 Docker Hub。

```sh
docker logout
```

## 拉取镜像

从镜像仓库中拉取或者更新指定镜像。

```sh
docker pull [OPTIONS] NAME[:TAG|@DIGEST]
```

OPTIONS 说明：

- -a: 拉取所有 tagged 镜像
- --disable-content-trust: 忽略镜像的校验,默认开启

从 Docker Hub 下载 java 最新版镜像。

```sh
docker pull -a java
```

## 上传镜像

将本地的镜像上传到镜像仓库,要先登陆到镜像仓库。

```sh
docker push [OPTIONS] NAME[:TAG]
```

OPTIONS 说明：

- --disable-content-trust: 忽略镜像的校验,默认开启

上传本地镜像 myapache:v1 到镜像仓库中。

```sh
docker push myapache:v1
```
