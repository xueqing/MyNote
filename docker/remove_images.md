# 删除 docker 镜像的完整指南

- [删除 docker 镜像的完整指南](#删除-docker-镜像的完整指南)
  - [前言](#前言)
  - [删除 docker 镜像的方法](#删除-docker-镜像的方法)
    - [删除关联一个容器的 docker 镜像](#删除关联一个容器的-docker-镜像)
    - [删除关联多个容器的 docker 镜像](#删除关联多个容器的-docker-镜像)
    - [一次删除多个 docker 镜像](#一次删除多个-docker-镜像)
    - [一次删除所有未使用和悬空的 docker 镜像](#一次删除所有未使用和悬空的-docker-镜像)
    - [从系统中删除所有 docker 镜像](#从系统中删除所有-docker-镜像)
  - [总结(原创)](#总结原创)

[原文](https://linuxhandbook.com/remove-docker-images/)。

## 前言

如果你持续创建 docker 镜像，你会很快用完空间。删除旧的和未使用的 docker 镜像将为你释放大量磁盘空间。

在此文中，我会讨论从系统中删除 docker 镜像的多种场景。

## 删除 docker 镜像的方法

首先，使用此命令检查系统中存在的 docker 镜像：

```sh
docker images
```

输出会显示所有 docker 镜像及其镜像 ID。你需要此镜像名称(repository 一列)或镜像 ID 从系统中删除镜像。

```sh
abhishek@linuxhandbook:~$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
debian              latest              67e34c1c9477        2 weeks ago         114MB
ubuntu              latest              775349758637        6 weeks ago 
```

你可以按以下方法使用镜像 ID 删除 docker 镜像：

```sh
docker rmi image_name_or_id
```

或者使用此命令，二者相同：

```sh
abhishek@linuxhandbook:~$ docker rmi 67e34c1c9477
Untagged: debian:latest
Untagged: debian@sha256:79f0b1682af1a6a29ff63182c8103027f4de98b22d8fb50040e9c4bb13e3de78
Deleted: sha256:67e34c1c9477023c0ce84c20ae5af961a6509f9952c2ebbf834c5ea0a286f2b8
Deleted: sha256:f2b4f0674ba3e6119088fe8a98c7921ed850c48d4d76e8caecd7f3d57721b4cb
```

如果使用镜像 ID，它会删除和该 ID 关联的所有镜像。

### 删除关联一个容器的 docker 镜像

如果你能像这样删除 docker 镜像，生活将会更简简单。但是这并不经常发生。

如果你有容器与 docker 镜像关联，当尝试删除镜像时会遇到一些错误。

```sh
abhishek@linuxhandbook:~$ docker rmi 775349758637
Error response from daemon: conflict: unable to delete 775349758637 (cannot be forced) - image is being used by running container 13dc0f4226dc
```

你必须先停止容器：

```sh
abhishek@linuxhandbook:~$ docker stop 13dc0f4226dc
13dc0f4226dc
```

即使你停止容器仍然有此问题，它仍然会抱怨你是否在尝试删除镜像：

```sh
abhishek@linuxhandbook:~$ docker rmi 67e34c1c9477
Error response from daemon: conflict: unable to delete 67e34c1c9477 (must be forced) - image is being used by stopped container 5ced86b1fcee
```

这里你有两个选择：

- 强制删除 docker 镜像(关联的容器会保留在系统中)
- 删除关联的容器，然后再删除 docker 镜像

要强制删除镜像，你可以使用 `-f` 选项：

```sh
docker rmi -f image_id
```

要删除关联的容器，然后再删除 docker 镜像，你可以使用类似下面的：

```sh
docker rm container_id
docker rmi image_id
```

### 删除关联多个容器的 docker 镜像

如果 docker 镜像只关联一个容器，生活仍然是比较简单的。但是一个镜像可以关联多个容器，而且删除此类 docker 镜像很痛苦。

你会看到类似的错误：

```sh
abhishek@itsfoss:~$ docker rmi 775349758637
Error response from daemon: conflict: unable to delete 775349758637 (must be forced) - image is referenced in multiple repositories
```

首先，你需要查找与该镜像名称(不是 ID)关联的所有容器。

```sh
docker ps -a -q --filter ancestor=docker_image_name
```

- `-a` 选项显示所有正在运行和已停止的容器。
- `-q` 选择只显示容器 ID。

然后，你需要停止所有这些容器。你可以依次使用容器 ID 但是那会非常耗时。你可以使用管道和 [xargs](https://linuxhandbook.com/xargs-command/) 来[停止与镜像关联的所有容器](https://linuxhandbook.com/docker-stop-container/)。

```sh
docker ps -a -q --filter ancestor=ubuntu | xargs docker stop
```

然后，你可以删除已经停止的容器，或强制删除删除镜像(正如你在上一章看到的)。

如果你想删除与镜像关联的所有容器，只需要运行此命令：

```sh
docker ps -a -q --filter ancestor=ubuntu | xargs docker rm
```

现在，你可以使用本教程中先前显示的命令删除 docker 镜像了。

### 一次删除多个 docker 镜像

你也可以在一个命令中删除多个 docker 镜像。它和之前的命令相同。你只需要指定镜像 ID 或镜像名称。

```sh
docker rmi image_id_1 image_id_2 image_id_3
```

当然，你必须停止镜像关联的正在运行的容器。

### 一次删除所有未使用和悬空的 docker 镜像

在这之前，我先解释什么是未使用和悬空的镜像：

任何 docker 镜像如果有任意类型的容器与之关联(已经停止的或正在运行的)就是在用的镜像。如果 docker 镜像没有关联的容器，它变成未使用的 docker 镜像。

[悬空的 docker 镜像](https://stackoverflow.com/questions/45142528/what-is-a-dangling-image-and-what-is-an-unused-image/45143234#45143234)表示你已经创建了该镜像的新构建，但是未赋予其新名称。因此拥有的旧镜像变成悬空的镜像。这些旧镜像是当你运行 `docker images` 命令时，没有打标签且在 name 一列显示 `<none>` 的镜像。

如果你想删除悬空的镜像，可以使用 [prune 选项](https://docs.docker.com/engine/reference/commandline/image_prune/):

```sh
docker image prune
```

如果你一次删除未使用和悬空的镜像，你可以使用带 `-a` 选项的 `prune`：

```sh
docker image prune -a
```

你在输出末尾应该看到该目录释放的空间：

```sh
abhishek@linuxhandbook:~$ docker image prune -a
WARNING! This will remove all images without at least one container associated to them.
Are you sure you want to continue? [y/N] y
Deleted Images:
untagged: ubuntu:latest
untagged: ubuntu@sha256:6e9f67fa63b0323e9a1e587fd71c561ba48a034504fb804fd26fd8800039835d
untagged: debian:latest
untagged: debian@sha256:79f0b1682af1a6a29ff63182c8103027f4de98b22d8fb50040e9c4bb13e3de78
deleted: sha256:67e34c1c9477023c0ce84c20ae5af961a6509f9952c2ebbf834c5ea0a286f2b8
deleted: sha256:f2b4f0674ba3e6119088fe8a98c7921ed850c48d4d76e8caecd7f3d57721b4cb
untagged: fedora:latest
untagged: fedora@sha256:d4f7df6b691d61af6cee7328f82f1d8afdef63bc38f58516858ae3045083924a
deleted: sha256:f0858ad3febdf45bb2e5501cb459affffacef081f79eaa436085c3b6d9bd46ca
deleted: sha256:2ae3cee18c8ef9e0d448649747dab81c4f1ca2714a8c4550eff49574cab262c9

Total reclaimed space: 308.3MB
```

你可以更聪明地使用 `prune` 命令，并只删除旧的未使用和悬空的镜像。因此，如果你想删除超过 24 小时的旧镜像，使用类似的命令：

```sh
docker image prune -a --filter "until=24h"
```

### 从系统中删除所有 docker 镜像

或许你在一个测试环境中，而且你想删除所有 docker 镜像重新开始。

要删除所有 docker 镜像，首先你需要停止所有[运行的容器](https://linuxhandbook.com/run-docker-container/)：

```sh
docker ps -a -q | xargs docker rm
```

现在，你可以用此方式删除所有镜像：

```sh
docker images -a -q | xargs docker rmi -f
```

大功告成。我认为这写参考资料对于删除 docker 镜像足够多，现在你应该对于这个主题有更好的理解。你还可以查看[删除 docker 容器](https://linuxhandbook.com/remove-docker-containers/)的教程。

## 总结(原创)

1. 确定需要删除镜像的名称或 ID，使用 `docker images` 可以查看 ID
2. 使用 `docker rmi image_name_or_id` 删除镜像
   1. 如果出现类似 `Error response from daemon: conflict: unable to delete 67e34c1c9477 (must be forced) - image is being used by stopped container 5ced86b1fcee` 的报错，说明镜像关联到一个已经停止的容器
      1. 使用 `docker rmi -f image_name_or_id` 强制删除镜像，或
      2. 先使用 `docker rm container_id` 删除容器，再使用 `docker rmi image_name_or_id` 删除镜像
   2. 如果出现类似 `Error response from daemon: conflict: unable to delete 775349758637 (cannot be forced) - image is being used by running container 13dc0f4226dc` 的报错，说明镜像关联到一个正在运行的容器
      1. 先使用 `docker stop container_name_or_id` 停止容器
      2. 再使用上述方法强制删除 docker 镜像，或先删除关联的容器，再删除 docker 镜像
   3. 如果出现类似 `Error response from daemon: conflict: unable to delete 775349758637 (must be forced) - image is referenced in multiple repositories` 的报错，说明镜像关联到多个容器
      1. 使用 `docker ps -a -q --filter ancestor=docker_image_name` 查找与镜像名称(不是 ID)关联的所有容器
      2. 使用 `docker ps -a -q --filter ancestor=ubuntu | xargs docker stop` 停止与镜像关联的所有容器
      3. 可以使用 `docker ps -a -q --filter ancestor=ubuntu | xargs docker rm` 删除与镜像关联的所有容器
      4. 再使用上述方法删除 docker 镜像
