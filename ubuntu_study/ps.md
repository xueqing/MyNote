# ps 命令

- [ps 命令](#ps-%e5%91%bd%e4%bb%a4)
  - [语法](#%e8%af%ad%e6%b3%95)
  - [选项](#%e9%80%89%e9%a1%b9)
  - [示例](#%e7%a4%ba%e4%be%8b)

ps 命令用于报告当前系统的进程状态。可以搭配 `kill` 指令随时中断、删除不必要的程序。ps 命令是最基本同时也是非常强大的进程查看命令，使用该命令可以确定有哪些进程正在运行和运行的状态、进程是否结束、进程有没有僵死、哪些进程占用了过多的资源等等，总之大部分信息都是可以通过执行该命令得到的。

## 语法

`ps 选项`

## 选项

- `a`: 显示现行终端机下的所有程序，包括其他用户的程序
- `-A/-e`: 显示所有程序
- `-f`: 显示 UID/PPIP/C/STIME
- `u`: 以用户为主的格式来显示程序状况
- `-V`: 显示指定版本
- `x`: 显示所有程序，不以终端机来区分
- `-x`: 显示扩展格式

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
