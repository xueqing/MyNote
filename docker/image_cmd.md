# 本地镜像管理命令

- [本地镜像管理命令](#%e6%9c%ac%e5%9c%b0%e9%95%9c%e5%83%8f%e7%ae%a1%e7%90%86%e5%91%bd%e4%bb%a4)
  - [列出本地镜像](#%e5%88%97%e5%87%ba%e6%9c%ac%e5%9c%b0%e9%95%9c%e5%83%8f)
  - [删除镜像](#%e5%88%a0%e9%99%a4%e9%95%9c%e5%83%8f)
  - [标记本地镜像](#%e6%a0%87%e8%ae%b0%e6%9c%ac%e5%9c%b0%e9%95%9c%e5%83%8f)
  - [创建镜像](#%e5%88%9b%e5%bb%ba%e9%95%9c%e5%83%8f)
  - [保存镜像](#%e4%bf%9d%e5%ad%98%e9%95%9c%e5%83%8f)
  - [导入镜像](#%e5%af%bc%e5%85%a5%e9%95%9c%e5%83%8f)

## 列出本地镜像

```sh
docker images [OPTIONS] [REPOSITORY[:TAG]]
```

OPTIONS 说明：

- -a: 列出本地所有的镜像（含中间映像层，默认情况下，过滤掉中间映像层）
- --digests: 显示镜像的摘要信息
- -f: 显示满足条件的镜像
- --format: 指定返回值的模板文件
- --no-trunc: 显示完整的镜像信息
- -q: 只显示镜像ID

列出本地镜像中 REPOSITORY 为 ubuntu 的镜像列表。

```sh
docker images ubuntu
```

## 删除镜像

删除本地一个或多少镜像。

```sh
docker rmi [OPTIONS] IMAGE [IMAGE...]
```

OPTIONS 说明：

- -f: 强制删除
- --no-prune: 不移除该镜像的过程镜像，默认移除

强制删除本地镜像 runoob/ubuntu:v4。

```sh
docker rmi -f runoob/ubuntu:v4
```

## 标记本地镜像

标记本地镜像，将其归入某一仓库。

```sh
docker tag [OPTIONS] IMAGE[:TAG] [REGISTRYHOST/][USERNAME/]NAME[:TAG]
```

将镜像 ubuntu:15.10 标记为 runoob/ubuntu:v3 镜像。

```sh
docker tag ubuntu:15.10 runoob/ubuntu:v3
```

## 创建镜像

使用 Dockerfile 创建镜像。

```sh
docker build [OPTIONS] PATH | URL | -
```

OPTIONS 说明：

- --build-arg=[]: 设置镜像创建时的变量
- --cpu-shares: 设置 cpu 使用权重
- --cpu-period: 限制 CPU CFS周期
- --cpu-quota: 限制 CPU CFS配额
- --cpuset-cpus: 指定使用的CPU id
- --cpuset-mems: 指定使用的内存 id
- --disable-content-trust: 忽略校验，默认开启
- -f: 指定要使用的Dockerfile路径
- --force-rm: 设置镜像过程中删除中间容器
- --isolation: 使用容器隔离技术
- --label=[]: 设置镜像使用的元数据
- -m: 设置内存最大值
- --memory-swap: 设置Swap的最大值为内存+swap，"-1"表示不限swap
- --no-cache: 创建镜像的过程不使用缓存
- --pull: 尝试去更新镜像的新版本
- --quiet, -q: 安静模式，成功后只输出镜像 ID
- --rm: 设置镜像成功后删除中间容器
- --shm-size: 设置/dev/shm的大小，默认值是64M
- --ulimit: Ulimit配置
- --tag, -t: 镜像的名字及标签，通常 name:tag 或者 name 格式；可以在一次构建中为一个镜像设置多个标签
- --network: 默认 default。在构建期间设置RUN指令的网络模式

使用当前目录的 Dockerfile 创建镜像，标签为 runoob/ubuntu:v1。

```sh
docker build -t runoob/ubuntu:v1 .
```

使用 URL `github.com/creack/docker-firefox` 的 Dockerfile 创建镜像。

```sh
docker build github.com/creack/docker-firefox
```

也可以通过 -f Dockerfile 文件的位置。

```sh
docker build -f /path/to/a/Dockerfile .
```

在 Docker 守护进程执行 Dockerfile 中的指令前，首先会对 Dockerfile 进行语法检查，有语法错误时会返回。

## 保存镜像

将指定镜像保存成 tar 归档文件。

```sh
docker save [OPTIONS] IMAGE [IMAGE...]
```

OPTIONS 说明：

- -o: 输出到的文件

将镜像 runoob/ubuntu:v3 生成 my_ubuntu_v3.tar 文档。

```sh
docker save -o my_ubuntu_v3.tar runoob/ubuntu:v3
docker save runoob/ubuntu:v3 > my_ubuntu_v3.tar
```

## 导入镜像

导入使用 docker save 命令导出的镜像。

```sh
docker load [OPTIONS]
```

OPTIONS 说明：

- --input, -i: 指定导入的文件，代替 STDIN
- --quiet, -q: 精简输出信息

从 busybox.tar.gz 导入镜像。

```sh
docker load < busybox.tar.gz
```

指定导入文件 fedora.tar 导入镜像。

```sh
docker load -i fedora.tar
```
