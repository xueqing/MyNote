# 删除 docker 容器

[原文](https://linuxhandbook.com/remove-docker-containers/)。

- [删除 docker 容器](#删除-docker-容器)
  - [前言](#前言)
  - [删除 docker 容器的实例](#删除-docker-容器的实例)
    - [删除一个 docker 容器](#删除一个-docker-容器)
    - [删除一个正在运行的容器](#删除一个正在运行的容器)
    - [强制删除一个正在运行的容器(不建议)](#强制删除一个正在运行的容器不建议)
    - [删除多个 docker 容器](#删除多个-docker-容器)
    - [删除和特定 docker 镜像关联的多个 docker 容器](#删除和特定-docker-镜像关联的多个-docker-容器)
    - [删除所有已经停止的容器](#删除所有已经停止的容器)
    - [删除所有 docker 容器](#删除所有-docker-容器)
  - [总结(原创)](#总结原创)

## 前言

删除一个指定容器，或删除属于同一镜像的所有容器，或删除所有容器。使用这些实例学习如何在不同场景删除 docker 容器。

当提到测试和部署一个项目时，容器是极好的。但是如果你创建多个容器，它们会很快消耗磁盘空间。

在此 docker 新手教程中，我会向你展示如何删除 docker 容器。

最简单的形式是，你可以使用 [docker rm 命令](https://docs.docker.com/engine/reference/commandline/container_rm/) 删除一个 docker 容器：

```sh
docker rm container_id_or_name
```

如果你想删除所有容器，首先停止所有正在运行的容器，然后删除容器：

```sh
docker ps -q | xargs docker stop
docker ps -q | xargs docker rm
```

但是，你并非总是可以简单地处理容器。这就是我为什么要展示一些场景，你可以删除 [docker](https://www.docker.com/) 容器。

## 删除 docker 容器的实例

你可以猜到，为了删除一个容器，你需要知道它的名字或 ID。你可以像这样使用 `docker ps` 命令检查系统中所有的 docker 容器(已经停止的和正在运行的)：

```sh
abhishek@nuc:~$ docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                      PORTS               NAMES
07e97581c5d8        debian              "bash"              9 minutes ago       Up 9 minutes                                    container2
6ef4545eef37        ubuntu              "bash"              11 minutes ago      Up 11 minutes                                   container1
707e40ce3c5a        ubuntu              "/bin/bash"         15 minutes ago      Exited (0) 15 minutes ago                       boring_payne
8047ab8e3673        ubuntu              "/bin/bash"         34 minutes ago      Exited (0) 15 minutes ago                       relaxed_wiles
ce84231ab213        debian              "bash"              42 minutes ago      Exited (0) 42 minutes ago                       bold_golick
12a18eaa291b        hello-world         "/hello"            2 days ago 
```

第一列给出容器 ID，最后一列给出容器名称。你也可以注意到[正在运行的 docker 容器](https://linuxhandbook.com/run-docker-container/)在 `Status` 一列是 `Up`。

既然你知道如何获取容器 ID 和名称，让我们看看如何删除它。

### 删除一个 docker 容器

这是最简单的。按照这种方式使用容器 ID 或名称：

```sh
docker rm container_id_or_name
```

你不会在输出得到类似容器已经删除的消息。它只打印你提供的容器 ID 或名称。

```sh
abhishek@nuc:~$ docker rm 12a18eaa291b
12a18eaa291b
```

### 删除一个正在运行的容器

如果容器正在运行，且你尝试删除它，你将会看到类似的错误：

```sh
abhishek@nuc:~$ docker rm container1
Error response from daemon: You cannot remove a running container 6ef4545eef378788e5e9d7ac1cf2e0a717480608adb432be99fd9b3d3a604c12. Stop the container before attempting removal or force remove
```

很明显，你应该先[停止 docker 容器](https://linuxhandbook.com/docker-stop-container/)，再删除它：

```sh
docker stop container_id_or_name
docker rm container_id_or_name
```

### 强制删除一个正在运行的容器(不建议)

docker 提供 `-f` 选项强制删除一个容器。使用这个选项，你可以删除一个正在运行的容器：

```sh
docker rm -f container_id_or_name
```

不建议这样做，因为它发送 kill 命令，且容器可能不会保存它的状态。

### 删除多个 docker 容器

你在删除时可以指定多个 docker 容器：

```sh
docker rm container1 container2 container3
```

### 删除和特定 docker 镜像关联的多个 docker 容器

在这示例中，假定你想删除 docker 镜像 ubuntu 关联的所有容器。

我建议你首先停止容器：

```sh
docker ps -a -q --filter ancestor=ubuntu | xargs docker stop
```

然后删除这些容器：

```sh
docker ps -a -q --filter ancestor=ubuntu | xargs docker rm
```

为了解释上述命令，过滤 `docker ps` 命令输出中使用 `ubuntu` 镜像关联的容器，然后 `-q` 选项只给出容器 ID。将其与 [xargs 命令](https://linuxhandbook.com/xargs-command/) 结合，将容器 ID (与 ubuntu 关联的)传递给 `docker rm` 命令。

### 删除所有已经停止的容器

如果你想删除所有已经停止的容器，你可以根据它们的状态进行过滤，然后按照这种方式停止它们：

```sh
docker ps -a -q -f status=exited | xargs docker rm
```

### 删除所有 docker 容器

如果你想从系统删除所有容器，你应该确保首先停止所有容器，然后删除它们：

```sh
docker ps -q | xargs docker stop
docker ps -q | xargs docker rm
````

我希望你喜欢这篇 docker 教程。继续关注更多教程。

## 总结(原创)

1. 确定需要删除容器的名称或 ID，使用 `docker ps -a` 命令可以看到正在运行和已经停止的所有容器信息
2. 使用 `docker rm container_id_or_name` 删除一个容器
3. 如果有多个容器，使用 `docker rm container_id_or_name_1 container_id_or_name_2 container_id_or_name_3`
4. 如果删除和特定 docker 镜像关联的多个 docker 容器，先使用 `docker ps -a -q --filter ancestor=IMAGE_NAME | xargs docker stop` 停止容器，再使用 `docker ps -a -q --filter ancestor=IMAGE_NAME | xargs docker rm` 删除容器
5. 如果删除所有已经停止的容器，使用 `docker ps  -a -q -f status=exited | xargs docker rm`
6. 如果要删除系统中的所有容器，使用 先使用 `docker ps -q | xargs docker stop` 停止容器，再使用 `docker ps -q | xargs docker rm` 删除容器
