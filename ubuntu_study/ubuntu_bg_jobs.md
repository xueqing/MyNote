# 5 个管理 Unix 后台 job 的示例——bg, fg, &, ctrl-z

- [5 个管理 Unix 后台 job 的示例——bg, fg, &, ctrl-z](#5-%e4%b8%aa%e7%ae%a1%e7%90%86-unix-%e5%90%8e%e5%8f%b0-job-%e7%9a%84%e7%a4%ba%e4%be%8bbg-fg--ctrl-z)
  - [1. 执行一个后台 job](#1-%e6%89%a7%e8%a1%8c%e4%b8%80%e4%b8%aa%e5%90%8e%e5%8f%b0-job)
  - [2. 使用 ctrl-z 和 bg 命令发送当前的前台 job 到后台](#2-%e4%bd%bf%e7%94%a8-ctrl-z-%e5%92%8c-bg-%e5%91%bd%e4%bb%a4%e5%8f%91%e9%80%81%e5%bd%93%e5%89%8d%e7%9a%84%e5%89%8d%e5%8f%b0-job-%e5%88%b0%e5%90%8e%e5%8f%b0)
  - [3. 使用 jobs 命令查看所有后台 job](#3-%e4%bd%bf%e7%94%a8-jobs-%e5%91%bd%e4%bb%a4%e6%9f%a5%e7%9c%8b%e6%89%80%e6%9c%89%e5%90%8e%e5%8f%b0-job)
  - [4. 使用 fg 命令将 job 从后台移到前台](#4-%e4%bd%bf%e7%94%a8-fg-%e5%91%bd%e4%bb%a4%e5%b0%86-job-%e4%bb%8e%e5%90%8e%e5%8f%b0%e7%a7%bb%e5%88%b0%e5%89%8d%e5%8f%b0)
  - [5. 使用 `kill %` 杀死一个指定的后台 job](#5-%e4%bd%bf%e7%94%a8-kill--%e6%9d%80%e6%ad%bb%e4%b8%80%e4%b8%aa%e6%8c%87%e5%ae%9a%e7%9a%84%e5%90%8e%e5%8f%b0-job)

翻译 [原文](https://www.thegeekstuff.com/2010/05/unix-background-job/)。

当你执行一个耗时长的 shell 脚本或命令时，你可以将它作为后台 job 运行。

在这篇文章中，让我们复习如何在后台执行一个 job、将一个 job 放到前台、查看所有后台 job 以及杀掉一个后台 job。

## 1. 执行一个后台 job

追加 `&` 到命令，将在后运行 job。

比如，当你执行一个可能需要花费许多时间的查找命令，你可以像下面把它放在后台。下面的例子查找根文件系统下载过去 24 小时变化的所有文件：

```sh
# find / -ctime -1 > /tmp/changed-file-list.txt &
```

## 2. 使用 ctrl-z 和 bg 命令发送当前的前台 job 到后台

你可以按照下面解释发送一个已经在前台运行的 job 到后台：

- 输入 “ctrl+z” 会挂起当前的前台 job
- 执行 `bg` 使命令在后台运行

比如，如果你忘记在后台执行一个 job，吧不必杀掉单签 job 并开启一个新的后台 job。反之，按照下面显示的挂起当前 job 并把它放到后台：

```sh
# find / -ctime -1 > /tmp/changed-file-list.txt

# [CTRL-Z]
[2]+  Stopped                 find / -ctime -1 > /tmp/changed-file-list.txt

# bg
```

## 3. 使用 jobs 命令查看所有后台 job

你可以使用命令 `jobs` 列举后台 job。`jobs` 命令的示例输出：

```sh
# jobs
[1]   Running                 bash download-file.sh &
[2]-  Running                 evolution &
[3]+  Done                    nautilus .
```

## 4. 使用 fg 命令将 job 从后台移到前台

你可以使用 `fg` 命令将一个后台 job 移到前台。当执行 `fg` 不带参数时，它会将最近的后台 job 移到前台：

```sh
# fg
```

如果你有多个后台 job，而且想要把一些 job 放到前台，执行 jobs 命令。jobs 命令会显示 job id 和命令。

在下面的示例中，`fg %1` 会将 job#1 (比如 download-file.sh) 移到前台。

```sh
# jobs
[1]   Running                 bash download-file.sh &
[2]-  Running                 evolution &
[3]+  Done                    nautilus .

# fg %1
```

## 5. 使用 `kill %` 杀死一个指定的后台 job

如果你想要杀掉一个指定的后台 job，使用 `kill %job-number`。比如，要杀掉 job 2，使用

```sh
# kill %2
```

要杀掉一个前台 job，使用之前的文章 [4 中杀掉进程的方式——kill/killall/pkill/xkill](https://www.thegeekstuff.com/2009/12/4-ways-to-kill-a-process-kill-killall-pkill-xkill/) 其中的一种方式。
