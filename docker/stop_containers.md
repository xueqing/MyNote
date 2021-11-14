# 停止 docker 容器

[原文](https://linuxhandbook.com/docker-stop-container/)。

- [停止 docker 容器](#停止-docker-容器)
  - [前言](#前言)
  - [停止 docker 容器的实例](#停止-docker-容器的实例)
    - [1 停止一个 docker 容器](#1-停止一个-docker-容器)
    - [2 停止多个 docker 容器](#2-停止多个-docker-容器)
    - [3 停止一个镜像关联的所有 docker 容器](#3-停止一个镜像关联的所有-docker-容器)
    - [4 停止所有正在运行的 docker 容器](#4-停止所有正在运行的-docker-容器)
    - [5 优雅地停止一个容器](#5-优雅地停止一个容器)
  - [结语](#结语)
  - [总结(原创)](#总结原创)

## 前言

此 docker 教程讨论的方法用于停止单个 docker 容器、停止多个 docker 容器或一次停止所有正在运行的 docker 容器。你也将学习优雅地停止 docker 容器。

要停止 docker 容器，要做的就是按如下方式使用容器 ID 或容器名称：

```sh
docker stop container_ID_or_name
```

你也可以使用 [docker container stop container_id_or_name 命令](https://docs.docker.com/engine/reference/commandline/container_stop/)，但是此命令中有一个多余的单词，且并未提供额外的益处，因此使用 `docker stop`。

但是停止容器还有很多你应该知道的，尤其如果你是一个 docker 新手。

## 停止 docker 容器的实例

我会在本教程中讨论关于停止一个 docker 容器的多个方面：

- 停止一个 docker 容器
- 一次停止多个 docker 容器
- 停止某个镜像关联的所有 docker 容器
- 一次停止所有正在运行的 docker 容器
- 优雅地停止一个容器

在这之前，你应该知道如何获取容器名称或 ID。

你可以使用 `docker ps` 命令[列举所有正在运行的 docker 容器](https://linuxhandbook.com/list-containers-docker/)。不带任何选项，`docker ps` 命令只显示正在运行的容器。

```sh
abhishek@linuxhandbook:~$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
1bcf775d8cc7        ubuntu              "bash"              8 minutes ago       Up About a minute                       container-2
94f92052f55f        debian              "bash"              10 minutes ago      Up 10 minutes                           container-1
```

输出也给出容器的名称和容器 ID。你可以使用二者之一来停止一个容器。

现在让我们着手停止容器。

### 1 停止一个 docker 容器

要停止一个指定的容器，使用 [docker stop 命令](https://docs.docker.com/engine/reference/commandline/stop/)携带容器的 ID 或名称。

```sh
docker stop container_name_or_ID
```

输出本来应该描述更多，但是它只显示你提供的容器名称或 ID。

```sh
abhishek@itsfoss:~$ docker stop 1bcf775d8cc7
1bcf775d8cc7
```

你可以在一个已经停止的容器上使用 `docker stop` 命令。这不会报错或有不同的输出。

你可以使用 `docker ps -a` 命令验证容器是否已经停止。`-a` 选项显示所有容器是否正在运行或已经停止。

```sh
abhishek@itsfoss:~$ docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                      PORTS               NAMES
1bcf775d8cc7        ubuntu              "bash"              19 minutes ago      Exited (0) About a minute ago                       container-2
94f92052f55f        debian              "bash"              29 minutes ago      Up 29 minutes                                   container-1
```

如果状态是 `Exited`，表示容器不再运行。

### 2 停止多个 docker 容器

你也可以一次停止多个 docker 容器。你只需要提供容器名称和 ID。

```sh
docker stop container_id_or_name_1 container_id_or_name_2 container_id_or_name_3
```

和之前一样，输出将简单显示容器的名称或 ID。

```sh
abhishek@itsfoss:~$ docker stop container-1 container-2 container-3
container-1
container-2
container-3
```

### 3 停止一个镜像关联的所有 docker 容器

到目前为止，你看到通过显式指定容器名称或 ID 停止容器。

如果想停止某个 docker 镜像的所有正在运行的容器怎么办呢？想象一个场景，你想[删除一个 docker 镜像](https://linuxhandbook.com/remove-docker-images/)，但是你需要停止所有关联的正在运行的容器。

你可以依次提供容器名称或 ID，但是那将非常耗时。你可以做的是基于容器的基础镜像过滤所有正在运行的容器。

只需将 `IMAGE_NAME` 替换为你的 docker 镜像名称，然后你应该可以停止与该镜像关联的所有正在运行的容器。

```sh
docker ps -q --filter ancestor=IMAGE_NAME | xargs docker stop
```

`-q` 选项只显示容器 ID。感谢[奇妙的 xargs 命令](https://linuxhandbook.com/xargs-command/)，这些容器 ID 作为参数通过管道传递给 `docker stop`。

### 4 停止所有正在运行的 docker 容器

你可能面临一个场景，要求停止所有正在运行的容器。例如，如果你想[删除 docker 中的所有容器](https://linuxhandbook.com/remove-docker-containers/)，首先你应该停止它们。

为此，你可以使用类似之前章节中看到的。即删除镜像部分。

```sh
docker ps -q | xargs docker stop
```

### 5 优雅地停止一个容器

坦白说，docker 默认优雅地停止一个容器。当你使用 `docker stop` 命令，它会在强制杀掉容器之前给容器 10 秒钟。

这并非表示总是花费 10 秒停止一个容器。它只是表示如果容器正在运行一些进程，容器会获得 10 秒来停止进程并退出。

`docker stop` 命令首先发送 `SIGTERM` 命令。如果容器这期间被停止，会发送 `SIGKILL` 命令。一个进程可以忽略 `SIGTERM` 但是 `SIGKILL` 将会立即杀掉进程。

我希望你知道 [SIGTERM 和 SIGKILL 之间的区别](https://linuxhandbook.com/sigterm-vs-sigkill/)。

你可以修改使用 `-t` 选项这个优雅的 10 秒周期。假定你想在停止容器之前等待 30 秒。

```sh
docker stop -t 30 container_name_or_id
```

## 结语

我认为这么多信息很好地涵盖了话题。你知道关于停止一个 docker 容器的很多内容。

继续关注更多 docker 技巧和教程。如果你有问题或建议，请在评论区告诉我。

## 总结(原创)

1. 确定需要停止容器的名称或 ID，使用 `docker ps` 命令可以看到正在运行的容器信息
2. 使用 `docker stop container_id_or_name` 停止一个容器，用 `docker ps -a` 验证容器是否已经停止，查看状态是否是 `Exited`
3. 如果有多个容器，使用 `docker stop container_id_or_name_1 container_id_or_name_2 container_id_or_name_3`
4. 如果停止一个镜像关联的所有 docker 容器，使用 `docker ps -q --filter ancestor=IMAGE_NAME | xargs docker stop`
5. 如果停止所有正在运行的 docker 容器，使用 `docker ps -q | xargs docker stop`
6. 如果要修改停止容器之前等待的时间，使用 `docker stop -t second_number container_name_or_id` 指定
