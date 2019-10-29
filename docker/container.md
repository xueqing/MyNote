# 容器操作

- [容器操作](#%e5%ae%b9%e5%99%a8%e6%93%8d%e4%bd%9c)
  - [列出容器](#%e5%88%97%e5%87%ba%e5%ae%b9%e5%99%a8)
  - [连接容器](#%e8%bf%9e%e6%8e%a5%e5%ae%b9%e5%99%a8)
  - [获取容器日志](#%e8%8e%b7%e5%8f%96%e5%ae%b9%e5%99%a8%e6%97%a5%e5%bf%97)

## 列出容器

```sh
docker ps [OPTIONS]
```

OPTIONS 说明：

- -a: 显示所有的容器，包括未运行的
- -f: 根据条件过滤显示的内容
- --format: 指定返回值的模板文件
- -l: 显示最近创建的容器
- -n: 列出最近创建的n个容器
- --no-trunc: 不截断输出
- -q: 静默模式，只显示容器编号
- -s: 显示总的文件大小

列出所有在运行的容器信息。

```sh
docker ps
```

输出详情介绍：

- CONTAINER ID: 容器 ID
- IMAGE: 使用的镜像
- COMMAND: 启动容器时运行的命令
- CREATED: 容器的创建时间
- STATUS: 容器状态。状态有 7 种
  - created（已创建）
  - restarting（重启中）
  - running（运行中）
  - removing（迁移中）
  - paused（暂停）
  - exited（停止）
  - dead（死亡）
- PORTS: 容器的端口信息和使用的连接类型（tcp\udp）
- NAMES: 自动分配的容器名称

列出最近创建的 5 个容器信息。

```sh
docker ps -n 5
```

列出所有创建的容器 ID。

```sh
docker ps -a
```

## 连接容器

```sh
docker attach [OPTIONS] CONTAINER
```

要 attach 上去的容器必须正在运行，可以同时连接上同一个容器来共享屏幕（与 screen 命令的 attach 类似）。

容器 mynginx 将访问日志指到标准输出，连接到容器查看访问信息。

```sh
docker attach --sig-proxy=false mynginx
```

## 获取容器日志

```sh
docker logs [OPTIONS] CONTAINER
```

OPTIONS 说明：

- -f: 跟踪日志输出
- --since: 显示某个开始时间的所有日志
- -t: 显示时间戳
- --tail: 仅列出最新 N 条容器日志

跟踪查看容器 mynginx 的日志输出。

```sh
docker logs -f mynginx
```

查看容器 mynginx 从 2016 年 7 月 1 日后的最新 10 条日志。

```sh
docker logs --since="2016-07-01" --tail=10 mynginx
```
