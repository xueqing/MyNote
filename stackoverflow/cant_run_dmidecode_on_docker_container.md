# 不能在 docker 容器运行 dmidecode

原文 [Can't run dmidecode on docker container](https://stackoverflow.com/questions/54068234/cant-run-dmidecode-on-docker-container)

## 问题

尝试在我的 docker 容器运行 dmidecode 命令

```sh
docker run --device /dev/mem:/dev/mem -it jin/ubu1604
```

但是，报错没有权限

```sh
root@bd1062dfd8ab:/# dmidecode
# dmidecode 3.0
Scanning /dev/mem for entry point.
/dev/mem: Operation not permitted
root@bd1062dfd8ab:/# ls -l /dev
total 0
crw--w---- 1 root tty  136, 0 Jan  7 03:21 console
lrwxrwxrwx 1 root root     11 Jan  7 03:20 core -> /proc/kcore
lrwxrwxrwx 1 root root     13 Jan  7 03:20 fd -> /proc/self/fd
crw-rw-rw- 1 root root   1, 7 Jan  7 03:20 full
crw-r----- 1 root kmem   1, 1 Jan  7 03:20 mem
drwxrwxrwt 2 root root     40 Jan  7 03:20 mqueue
crw-rw-rw- 1 root root   1, 3 Jan  7 03:20 null
lrwxrwxrwx 1 root root      8 Jan  7 03:20 ptmx -> pts/ptmx
drwxr-xr-x 2 root root      0 Jan  7 03:20 pts
crw-rw-rw- 1 root root   1, 8 Jan  7 03:20 random
drwxrwxrwt 2 root root     40 Jan  7 03:20 shm
lrwxrwxrwx 1 root root     15 Jan  7 03:20 stderr -> /proc/self/fd/2
lrwxrwxrwx 1 root root     15 Jan  7 03:20 stdin -> /proc/self/fd/0
lrwxrwxrwx 1 root root     15 Jan  7 03:20 stdout -> /proc/self/fd/1
crw-rw-rw- 1 root root   5, 0 Jan  7 03:20 tty
crw-rw-rw- 1 root root   1, 9 Jan  7 03:20 urandom
crw-rw-rw- 1 root root   1, 5 Jan  7 03:20 zero
```

这使我困惑，因为我可以在主机(ubuntu 14.04)上正常运行 `dmidecode -t system`。我甚至按照下面的建议设置 dmidecode 可执行文件的权限

```sh
setcap cap_sys_rawio+ep /usr/sbin/dmidecode
```

仍然没有效果。

有其他想法吗？

### 更新

基于 David Maze 的答案，应该是下面的命令

```sh
run --device /dev/mem:/dev/mem --cap-add SYS_RAWIO -it my/ubu1604a
```

仅当你相信容器中运行的内容时才这样做，比如，如果你在原始操作系统上测试安装程序。

## 答案

Docker 提供了一个隔离层，且 Docker 的主要目标之一是向容器隐藏主机硬件的细节。查询主机硬件底层的详细信息的最简单、最合适的方法是从主机的 root shell，完全忽略 Docker。

其实际机制是通过限制 Linux 的[能力](http://man7.org/linux/man-pages/man7/capabilities.7.html)。capabilities(7) 说明你需要 `CAP_SYS_RAWIO` 来访问 `/dev/mem`，因此原则上你可以使用 `--cap-add SYS_RAWIO` 启动你的容器。你可能需要其他能力或/和设备访问权限来使其真正起作用，因为 Docker 的设计目标隐藏了你尝试访问的内容细节。
