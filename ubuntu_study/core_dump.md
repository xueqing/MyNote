# core dump

- [core dump](#core-dump)
  - [前言](#前言)
  - [使用](#使用)
  - [禁用自动核心转储](#禁用自动核心转储)
    - [使用 sysctl](#使用-sysctl)
    - [使用 systemd](#使用-systemd)
    - [使用 PAM 限制](#使用-pam-限制)
    - [使用 ulimit](#使用-ulimit)
  - [生成一个核心转储](#生成一个核心转储)
  - [核心转储文件的位置](#核心转储文件的位置)
  - [分析核心转储文件](#分析核心转储文件)
    - [核心转储文件格式](#核心转储文件格式)
    - [gdb 调试](#gdb-调试)
  - [清理核心转储文件](#清理核心转储文件)
  - [参考](#参考)

## 前言

核心转储是一个文件，其中包含一个进程意外终止时的的地址空间(内存)。core dump 可以按需生成(比如通过调试器)，或者终止时自动生成。核心转储由内核触发以响应程序崩溃，且可以传递给辅助程序(如 systemd-coredump) 以便进一步处理。核心转储通常不由普通用户使用，而是可以应要求传递给开发人员，在崩溃时作为程序的事后快照，这是非常有价值的，尤其是在难以可靠地重现故障时。

## 使用

核心转储可在多种情况下座位有用的调试辅助工具。在早起的独立或批处理系统上，核心转储允许用户调试程序，而不会独占(非常昂贵的)计算工具用于调试。和使用前端面板切换和指示灯相比，打印输出也可能更方便调试。

在共享计算机上，无论是分时、批处理或服务器系统，核心转储允许操作系统离线调试，以便系统可以立即恢复运行。

核心转储允许用户保存崩溃以供之后或离线分析，或者与其他崩溃比较。对于嵌入式计算机，在计算机本身支持调试可能是不切实际的，因此分析转储可能发生在另一台计算机上。一些操作系统，比如 Unix 的早期版本，不支持将调试器附加到正在运行的进程，因此核心转储必须在进程的内存内容上运行调试器。

核心转储可用于捕获在动态内存分配期间释放的数据，因此可用于从不再运行的程序中恢复信息。在缺少交互式调试器时，勤奋的程序媛可使用核心转储直接检查确定错误。

## 禁用自动核心转储

用户可能处于一些原因希望禁用自动核心转储：

- 性能：为内存密集型程序生成核心转储会浪费系统资源及延迟内存清理。
- 磁盘空间：如果不压缩，内存密集型程序的核心转储可能消耗的磁盘空间等于(如果不大于)程序的内存占用量。
- 安全性：核心转储，虽然通常只由 root 读取，可能包含敏感数据(比如密码或加密密钥)，这些数据在崩溃后会写入磁盘。

### 使用 sysctl

可使用 `sysctl` 设置 `kernel.core_pattern` 为空，以禁用核心转储处理。创建此文件：

```txt
/etc/sysctl.d/50-coredump.conf
kernel.core_pattern=|/bin/false
```

要使设置立即生效，使用 `sysctl`：

```sh
sysctl -p /etc/sysctl.d/50-coredump.conf
```

### 使用 systemd

`systemd` 的默认行为是为所有进程在 `/var/lib/systemd/coredump` 生成核心转储文件。这个行为可通过在 `/etc/systemd/coredump.conf.d/` 目录创建下面的配置片段覆盖：

```txt
/etc/systemd/coredump.conf.d/custom.conf
[Coredump]
Storage=none
```

注意：不要忘记包含 `[coredump]` 章节名，否则这个选项会被忽视：`systemd-coredump[1728]: [/etc/systemd/coredump.conf.d/custom.conf:1] Assignment outside of section. Ignoring.`

然后加载 `systemd` 的配置：

```sh
systemctl daemon-reload
```

只要系统中没有其他程序启用自动核心转储，这一个方法通常足够用来禁用用户空间的核心转储，但是核心转储仍然在内存中生成且 systemd-coredump 运行。

### 使用 PAM 限制

通过 [PAM](https://wiki.archlinux.org/index.php/PAM) 登录的用户的核心转储最大值受限于 `limits.conf`。设置其为零完全禁用核心转储。

```txt
/etc/security/limits.conf
* hard core 0
```

### 使用 ulimit

命令行 shell 如 bash 或 zsh 提供一个内置的 `ulimit` 命令，可用于报告或设置 shell 以及由 shell 启动的进程的资源限制。参见 [bash(1) § SHELL BUILTIN COMMANDS](https://jlk.fjfi.cvut.cz/arch/manpages/man/bash.1#SHELL_BUILTIN_COMMANDS) 或 [zshbuiltins(1)](https://jlk.fjfi.cvut.cz/arch/manpages/man/zshbuiltins.1)。

要在当前 shell 禁用核心转储：

```sh
ulimit -c 0
# ulimit -c unlimited 可开启核心转储，且不限制核心转储文件大小。只对当前终端有效
# 要永久生效，在文件 `/etc/security/limits.conf` 添加一行 `* soft core unlimited`
```

## 生成一个核心转储

要创建一个任意进程的核心转储，首先安装 `gdb` 包。然后查看运行进程的 PID。比如使用 `pgrep`：

```sh
$ pgrep -f firefox
11644
11788
11945
11991
12041
12954
```

绑定进程：

```sh
gdb -p 11644
```

然后在 `(gdb)` 提示符：

```sh
(gdb) generate-core-file
Saved corefile core.18332
(gdb) q
```

现在就有一个 `core.18332` 的 coredump 文件。

## 核心转储文件的位置

- 默认生成的文件保存在可执行文件所在目录，文件名为 `core`
- 通过修改 `/pro/sys/kernel/core_uses_pid` 可让生成的文件名自动加上 PID。例如 `echo 1 > /pro/sys/kernel/core_uses_pid`，生成的文件名会变成 `core.pid`
- 通过修改 `/proc/sys/kernel/core_pattern` 控制生成文件的保存位置和文件名格式。例如 `echo "/tmp/core-file-%e-%p-%t" > /proc/sys/kernel/core_pattern` 设置生成的文件保存在 `/tmp/core-file` 目录，文件名格式为 `core-command-pid-timestamp`

## 分析核心转储文件

核心转储表示转储进程地址空间中转储区域的完整内容。根据操作系统的不同，转储可能包含少量或者没有数据结构来帮助解释内存区域。在这些系统中，成功的解释要求试图解释转储的程序或用户理解程序的内存使用结构。

调试器可以使用符号表(如果存在的话)来帮助程序猿解释转储，以符号方式识别变量并显示源代码；如果符号表不可用，则对转储的解释可能较少，但是仍可能足够用来确定问题的原因。也有称为转储分析器的专用工具来分析转储。GNU binutils 的 objdump 是一个可在许多操作系统使用的流行工具。

在类似 Unix 的现代操作系统上，管理员和程序员可以使用 GNU Binutils 的二进制文件描述符(BFD)库以及使用该库的 GNU 调试器(gdb) 和 objdump 来读取核心转储文件。该库会从核心转储的内存区域提供指定地址的原始数据；它对该内存区域中的变量或数据结构一无所知，因此使用该库读取核心转储的应用程序需要确定变量的地址，并确定数据结构本身的布局，比如通过使用符号表用于正在调试的程序。

来自 Linux 系统的崩溃转储的分析人员可以使用 kdump 或 Linux 内核崩溃转储(LKCD)。

核心转储和保存进程给定状态的上细纹(状态)，以便稍后返回到该状态。通过在处理器之间转移内核，有事通过内核转储文件本身，可以使系统具有高可用性。

核心也可以通过网络(存在安全风险)转储到远程主机上。

### 核心转储文件格式

在较早和较简单的操作系统，每个进程都有一个连续的地址空间，因此核心转储文件有时只是一个具有字节、数字、字符或字的序列的文件。在其他早期机器上，转储文件包含离散的记录，每个记录包含一个存储地址和相关内容。在早期的机器上，转储通常是由单独的转储程序而不是应用程序或操作系统写的。

在现代操作系统中，一个进程地址空间可能存在间隙，并与其他进程或文件共享内存页，因此使用了更为详尽的表示形式；它们还可能包含有关转储时程序状态的其他信息。

### gdb 调试

生成核心转储文件之后，使用命令 `gdb exe_file coredump` 查看文件。

当 `gdb` 开启后，使用 `bt` 命令打印堆栈跟踪：

```sh
(gdb) bt
```

## 清理核心转储文件

保存在 `/var/lib/systemd/coredump` 的核心转储文件可通过 `systemd-tmpfiles --clean` 自动清理，带 `systemd-tmpfiles-clean.timer` 参数可每日触发。可配置保存核心转储至少 3 天，查看 `systemd-tmpfiles --cat-config`。

## 参考

- [Core dump](https://wiki.archlinux.org/index.php/Core_dump)
- [linux下core dump【总结】](https://www.cnblogs.com/Anker/p/6079580.html)
- [Core dump](https://en.wikipedia.org/wiki/Core_dump)
