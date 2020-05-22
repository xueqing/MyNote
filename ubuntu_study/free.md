# free 命令

- [free 命令](#free-%e5%91%bd%e4%bb%a4)
  - [语法](#%e8%af%ad%e6%b3%95)
  - [选项](#%e9%80%89%e9%a1%b9)
  - [示例](#%e7%a4%ba%e4%be%8b)

free 命令可以显示当前系统未使用的和已使用的内存数目，还可以显示被内核使用的内存缓冲区。信息通過分析 `/proc/meminfo` 得到

## 语法

`free 选项`

## 选项

- `-b`: 以 Byte 为单位显示内存使用情况
- `-h`: 以合适的单位显示内存使用情况，最大为三位数，自动计算对应的单位值。单位有：
  - B = bytes
  - K = kilos
  - M = megas
  - G = gigas
  - T = teras
- `-k`: 以 KB 为单位显示内存使用情况
- `-m`: 以 MB 为单位显示内存使用情况
- `-o`: 不显示缓冲区调节列
- `-s 间隔秒数`: 持续观察内存使用状况
- `-t`: 显示内存总和列
- `-V`: 显示版本信息

## 示例

```sh
kiki@ubuntu:~/qt-workspace/ffmpeg-3.4.1$ free -m
              total        used        free      shared  buff/cache   available
Mem:           7953        2453        1348          56        4151        5016
Swap:          4092         281        3811
```

| 列 | 含义 |
| --- | --- |
| total | 内存总数(对应 MemTotal 和 SwapTotal) |
| used | 已经使用的内存，total-free-buffers-cache |
| free | 空闲的内存(对应 MemFree 和 SwapFree) |
| shared | (主要是) tmpfs 使用的内存(对应 Shmem，内核 2.6.32 支持，不支持显示为 0) |
| buffers | 内核缓存使用的内存(对应 Buffers) |
| cache | 页缓存和 slab 使用的内存(对应 Cached 和 Slab) |
| buff/cache | buffers+cache |
| available | 估算得到的用于启动一个新应用而不需要交换出可用的内存 |
