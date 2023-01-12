# pmap 命令

- [pmap 命令](#pmap-命令)
  - [语法](#语法)
  - [选项](#选项)
  - [参数](#参数)
  - [示例](#示例)

pmap 命令用于报告进程的内存映射关系，是 Linux 调试及运维一个很好的工具。

## 语法

`pmap 选项 参数`

## 选项

- `-d`: 显示设备格式
- `-q`: 不显示头尾行
- `-V`: 显示指定版本
- `-x`: 显示扩展格式

## 参数

- `进程号`: 指定需要显示内存映射关系的进程号，可以是多个进程号

## 示例

```sh
kiki@ubuntu:~/qt-workspace/ffmpeg-3.4.1$ pmap -d 76031
76031:   ./ffplay -v 32 -rtsp_transport udp rtsp://admin:admin@192.168.5.180:554
Address           Kbytes Mode  Offset           Device    Mapping
0000000000400000   17416 r-x-- 0000000000000000 008:00001 ffplay
0000000001701000       4 r---- 0000000001101000 008:00001 ffplay
0000000001702000     304 rw--- 0000000001102000 008:00001 ffplay
... ...
kiki@ubuntu:~/qt-workspace/ffmpeg-3.4.1$ pmap -x 76031
76031:   ./ffplay -v 32 -rtsp_transport udp rtsp://admin:admin@192.168.5.180:554
Address           Kbytes     RSS   Dirty Mode  Mapping
0000000000400000   17416    7488       0 r-x-- ffplay
0000000000400000       0       0       0 r-x-- ffplay
0000000001701000       4       4       4 r---- ffplay
0000000001701000       0       0       0 r---- ffplay
0000000001702000     304     304     304 rw--- ffplay
0000000001702000       0       0       0 rw--- ffplay
... ...
```
