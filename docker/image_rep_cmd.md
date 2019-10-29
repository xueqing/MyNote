# 镜像仓库命令

- [镜像仓库命令](#%e9%95%9c%e5%83%8f%e4%bb%93%e5%ba%93%e5%91%bd%e4%bb%a4)
  - [拉取镜像](#%e6%8b%89%e5%8f%96%e9%95%9c%e5%83%8f)

## 拉取镜像

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
