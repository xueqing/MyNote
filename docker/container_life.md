# 容器生命周期管理命令

- [容器生命周期管理命令](#%e5%ae%b9%e5%99%a8%e7%94%9f%e5%91%bd%e5%91%a8%e6%9c%9f%e7%ae%a1%e7%90%86%e5%91%bd%e4%bb%a4)
  - [创建容器](#%e5%88%9b%e5%bb%ba%e5%ae%b9%e5%99%a8)
  - [启动/停止/重启容器](#%e5%90%af%e5%8a%a8%e5%81%9c%e6%ad%a2%e9%87%8d%e5%90%af%e5%ae%b9%e5%99%a8)
  - [杀掉容器](#%e6%9d%80%e6%8e%89%e5%ae%b9%e5%99%a8)
  - [删除容器](#%e5%88%a0%e9%99%a4%e5%ae%b9%e5%99%a8)

## 创建容器

```sh
docker run [OPTIONS] IMAGE [COMMAND] [ARG...]
```

OPTIONS 说明：

- -a stdin: 指定标准输入输出内容类型，可选 STDIN/STDOUT/STDERR 三项
- -d: 后台运行容器，并返回容器ID
- -i: 以交互模式运行容器，通常与 -t 同时使用
- -P: 随机端口映射，容器内部端口随机映射到主机的高端口
- -p: 指定端口映射，格式为：主机(宿主)端口:容器端口
- -t: 为容器重新分配一个伪输入终端，通常与 -i 同时使用
- --name string: 为容器指定一个名称
- --dns 8.8.8.8: 指定容器使用的DNS服务器，默认和宿主一致
- --dns-search example.com: 指定容器DNS搜索域名，默认和宿主一致
- -h "mars": 指定容器的hostname
- -e username="ritchie": 设置环境变量
- --env-file=[]: 从指定文件读入环境变量
- --cpuset-cpus string: 绑定容器到指定 CPU 运行("0-2"/"0,1,2")
- -m: 设置容器使用内存最大值
- --net="bridge": 指定容器的网络连接类型，支持 bridge/host/none/container: 四种类型
- --link=[]: 添加链接到另一个容器
- --expose=[]: 开放一个端口或一组端口
- --volume , -v: 绑定一个卷

使用 docker 镜像 nginx:latest 以后台模式启动一个容器,并将容器命名为 mynginx。

```sh
docker run --name "mynginx" -d nginx:latest
```

使用镜像 nginx:latest 以后台模式启动一个容器,并将容器的 80 端口映射到主机随机端口。

```sh
docker run -P -d nginx:latest
```

使用镜像 nginx:latest，以后台模式启动一个容器,将容器的 80 端口映射到主机的 80 端口,主机的目录 /data 映射到容器的 /data。

```sh
docker run -p 80:80 /data:/data -d nginx:latest
```

绑定容器的 8080 端口，并将其映射到本地主机 127.0.0.1 的 80 端口上。

```sh
docker run -p 127.0.0.1:80:8080/tcp ubuntu bash
```

使用镜像 nginx:latest 以交互模式启动一个容器,在容器内执行/bin/bash命令。

```sh
docker run -it nginx:latest /bin/bash
```

## 启动/停止/重启容器

```sh
# 启动一个或多个已经被停止的容器
docker start [OPTIONS] CONTAINER [CONTAINER...]
# 停止一个运行中的容器
docker stop [OPTIONS] CONTAINER [CONTAINER...]
# 重启容器
docker restart [OPTIONS] CONTAINER [CONTAINER...]
```

启动已被停止的容器 myrunoob。

```sh
docker start myrunoob
```

停止运行中的容器 myrunoob。

```sh
docker stop myrunoob
```

重启容器 myrunoob。

```sh
docker restart myrunoob
```

## 杀掉容器

```sh
docker kill [OPTIONS] CONTAINER [CONTAINER...]
```

OPTIONS 说明：

- -s: 向容器发送一个信号

杀掉运行中的容器 mynginx。

```sh
docker kill -s KILL mynginx
```

## 删除容器

```sh
docker rm [OPTIONS] CONTAINER [CONTAINER...]
```

OPTIONS 说明：

- -f: 通过SIGKILL信号强制删除一个运行中的容器
- -l: 移除容器间的网络连接，而非容器本身
- -v: 删除与容器关联的卷

强制删除容器db01、db02。

```sh
docker rm -f db01 db02
```

移除容器 nginx01 对容器 db01 的连接，连接名 db。

```sh
docker rm -l db
```

删除容器 nginx01，并删除容器挂载的数据卷。

```sh
docker rm -v nginx01
```
