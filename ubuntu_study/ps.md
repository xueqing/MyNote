# ps 命令

- [ps 命令](#ps-命令)
  - [描述](#描述)
  - [语法](#语法)
  - [选项](#选项)
  - [注意](#注意)
  - [进程标志](#进程标志)
  - [进程状态码](#进程状态码)
  - [标准格式化标识符](#标准格式化标识符)
  - [示例](#示例)

## 描述

ps 命令用于报告当前系统活跃的进程状态。如果想要重复刷新这些进程状态，使用 `top`。可以搭配 `kill` 指令随时中断、删除不必要的程序。ps 命令是最基本同时也是非常强大的进程查看命令，使用该命令可以确定有哪些进程正在运行和运行的状态、进程是否结束、进程有没有僵死、哪些进程占用了过多的资源等等，总之大部分信息都是可以通过执行该命令得到的。

当前版本的 ps 接收一些选项：

- UNIX 选项，可分组，必须有一个 `-` 前缀
- BSD 选项，可分组，不能使用 `-`
- GNU 长选出，有两个 `-` 前缀

不同类型的选项可以自由混合，但是可能出现冲突。由于许多标准和 ps 兼容的的实现，有一些相似的选项，功能相同。

## 语法

`ps 选项`

## 选项

- `a`: 显示现行终端机下的所有程序，包括其他用户的程序
- `-A/-e`: 显示所有程序
- `-f`: 显示 UID/PPIP/C/STIME
- `l`: 显示 BSD 长格式
- `u`: 以用户为主的格式来显示程序状况
- `-V`: 显示 procps-ng 版本
- `x`: 显示所有程序，不以终端机来区分
- `-x`: 显示扩展格式

## 注意

ps 通过读 `/proc` 下的虚拟文件工作。不要给 ps 任何特殊权限。

## 进程标志

下面的值显示在 `F` 列：

- 1: 已经 fork 但是不能执行
- 4: 使用了超级用户权限

## 进程状态码

下面是 `s/stat/state`(头是 `STAT` 或 `S`):

- D: 不可中断的睡眠(通常是 IO)
- R: 运行或可运行(在运行队列)
- S: 可中断的睡眠(等待一个事件完成)
- T: 通过 job 控制信号停止
- t: 调试器在 trace 阶段停止
- W: 页置换(paging)(2.6.xx 内核之后不再有效)
- X: 死亡的(不应再看到)
- Z: 僵尸进程，终止了，但是未被父进程获取

对于 BSD 格式，当使用 `stat` 关键字时，可能显示额外的字符：

- <: 高优先级(对其他用户不是 nice 的)
- N: 低优先级(对其他用户是 nice 的)
- L: 有页锁定在内存中(用于实时和用户 IO)
- s: 会话 leader，有子进程
- l: 多线程(使用 CLONE_THREAD，像 NPLT pthread)
- +: 在前台进程组

## 标准格式化标识符

| 代码 | 头 | 描述 |
| --- | --- | --- |
| uname | USER | 该进程是由哪个用户产生的 |
| uid | UID | 运行此进程的用户 ID |
| pid | PID | 进程 ID |
| ppid | PPID | 父进程 ID |
| %cpu/pcpu | %CPU | 该进程占用 CPU 资源的百分比，占用的百分比越高，进程越耗费资源 |
| %mem/pmem | %MEM | 进程占用物理内存的百分比，占用的百分比越高，进程越耗费资源 |
| rss | RSS | 该进程占用实际物理内存的大小，单位为 KB |
| vsz/vsize | VSZ | 该进程占用虚拟内存的大小，单位为 KB |
| stat/state | STAT/S | 进程状态 |
| pri | PRI | 进程的优先级，数值越小，该进程的优先级越高，越早被 CPU 执行 |
| ni/nice | NI | 进程的优先级，数值越小，该进程越早被执行 |
| args/cmd | COMMAND/CMD | 产生此进程的命令名 |
| bsdstart | START | 该进程的启动时间 |
| bsdtime/cputime | TIME | 该进程占用 CPU 的运算时间，注意不是系统时间 |
| f/flags/flag | F | 进程标志，说明进程的权限 |
| tname | TTY | 该进程由哪个终端产生 |
| nwchanwchan/ | WCHAN | 该进程是否运行。"-"代表正在运行 |

## 示例

```sh
# ps aux | head -1 首先显示 ps 命令的标题，便于查看
# sort 命令使用了 -r(反转)、-n(数字值)、-k(关键字)，使 sort 命令对 ps 命令的结果按照第四列(内存使用情况)中的数字逆序进行排列并输出
kiki@ubuntu:~/qt-workspace/ffmpeg-3.4.1$ ps aux | head -1; ps aux | sort -rnk 4 | head -5
USER        PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
kiki      76031 62.6  6.0 2069240 494428 pts/2  Sl+  09:56 148:03 ./ffplay -v 32 -rtsp_transport udp rtsp://admin:admin@192.168.5.180:554
kiki      76392  0.2  2.5 982096 204460 ?       Sl   09:59   0:35 /usr/share/code/code --type=zygote --no-sandbox
kiki      76497  0.1  2.2 772524 179924 ?       Sl   09:59   0:14 /usr/share/code/code /usr/share/code/resources/app/out/bootstrap-fork --type=extensionHost
kiki      76574  0.0  2.1 1234672 174660 ?      Sl   09:59   0:10 /home/kiki/.vscode/extensions/ms-vscode.cpptools-0.27.1/bin/cpptools
kiki      76518  0.0  1.7 686116 144316 ?       Sl   09:59   0:04 /usr/share/code/code /usr/share/code/resources/app/out/bootstrap-fork --type=watcherService
# 指定一个别名并把该命令添加到你的 ~/.bashrc 文件中，可以一直使用
kiki@ubuntu:~/qt-workspace/ffmpeg-3.4.1$ alias mem-by-proc="ps aux | head -1; ps aux | sort -rnk 4"
# 使用 grep 命令来筛选得到某个用户的所有进程
kiki@ubuntu:~/qt-workspace/ffmpeg-3.4.1$ ps aux | head -1; ps aux | grep ^kiki| sort -rnk 4 | more
USER        PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
kiki      76031 62.6  6.2 2134776 508756 pts/2  Rl+  09:56 152:03 ./ffplay -v 32 -rtsp_transport udp rtsp://admin:admin@192.168.5.180:554
kiki      76392  0.2  2.5 982096 205196 ?       Sl   09:59   0:35 /usr/share/code/code --type=zygote --no-sandbox
kiki      76497  0.1  2.2 772524 179924 ?       Sl   09:59   0:14 /usr/share/code/code /usr/share/code/resources/app/out/bootstrap-fork --type=extensionHost
kiki      76574  0.0  2.1 1234672 174660 ?      Sl   09:59   0:11 /home/kiki/.vscode/extensions/ms-vscode.cpptools-0.27.1/bin/cpptools
kiki      76518  0.0  1.7 686116 144316 ?       Sl   09:59   0:04 /usr/share/code/code /usr/share/code/resources/app/out/bootstrap-fork --type=watcherService
kiki      76345  0.1  1.5 1085692 122512 ?      Sl   09:59   0:23 /usr/share/code/code --unity-launch
kiki@ubuntu:~/qt-workspace/ffmpeg-3.4.1$ cat show_user_total_mem_usage.sh
#!/bin/bash
stats=""
echo "%   user"
echo "============"
for user in `ps aux | grep -v COMMAND | awk '{print $1}' | sort -u`
do
  stats="$stats\n`ps aux | egrep ^$user | awk 'BEGIN{total=0}; \
    {total += $4};END{print total,$1}'`"
done
echo -e $stats | grep -v ^$ | sort -rn | head
kiki@ubuntu:~/qt-workspace/ffmpeg-3.4.1$ ./show_user_total_mem_usage.sh
%   user
============
26.1 kiki
1.3 root
1 mysql
0.6 www-data
0.2 rabbitmq
0.1 whoopsie
0.1 colord
0 systemd+
0 syslog
0 rtkit
```

```sh
# 后台开启服务 xxx，包含一个守护进程 yyy，现在需要杀掉服务释放监听端口，需要先杀掉守护进程
## 根据服务的监听端口找到服务命令
kiki@ubuntu:~$ lsof -i :10018
COMMAND   PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
VDMSGBC 92794 kiki    4u  IPv4 600329      0t0  TCP bogon:10018 (LISTEN)
VDMSGBC 92794 kiki    5u  IPv4 600330      0t0  TCP localhost:10018 (LISTEN)
## 根据服务命令找到相关服务(也可使用 ps aux)
kiki@ubuntu:~$ ps lax | head -1
F   UID    PID   PPID PRI  NI    VSZ   RSS WCHAN  STAT TTY        TIME COMMAND
kiki@ubuntu:~$ ps lax | grep VDMSGBC
1  1000  92172      1  20   0 143408  7008 hrtime Ss   ?          0:03 /home/kiki/qt-workspace/ai/VDMSGBC/build/debug/VDMSGBC
1  1000  92794      1  20   0 1012968 33092 hrtime Sl  ?          0:45 /home/kiki/qt-workspace/ai/VDMSGBC/build/debug/VDMSGBC
0  1000  98464  98350  20   0  14224   956 pipe_w S+   pts/2      0:00 grep --color=auto VDMSGBC
## 杀掉守护进程
kiki@ubuntu:~$ kill -9 92172
kiki@ubuntu:~$ ps lax | grep VDMSGBC
1  1000  92794      1  20   0 1012968 33092 hrtime Sl  ?          0:45 /home/kiki/qt-workspace/ai/VDMSGBC/build/debug/VDMSGBC
0  1000  98506  98350  20   0  14224   980 pipe_w S+   pts/2      0:00 grep --color=auto VDMSGBC
## 杀掉监听服务
kiki@ubuntu:~$ kill -9 92794
kiki@ubuntu:~$ lsof -i :10018
```
