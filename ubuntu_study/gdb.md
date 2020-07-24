# GDB 学习

- [GDB 学习](#gdb-学习)
  - [g++ 编译](#g-编译)
  - [启动 GDB 调试](#启动-gdb-调试)
  - [设置断点](#设置断点)
    - [根据行号设置断点](#根据行号设置断点)
    - [根据函数名设置断点](#根据函数名设置断点)
    - [根据代码地址设置断点](#根据代码地址设置断点)
    - [根据条件设置断点](#根据条件设置断点)
    - [根据规则设置断点](#根据规则设置断点)
    - [设置临时断点](#设置临时断点)
    - [跳过多次设置断点](#跳过多次设置断点)
    - [根据表达式值变化产生断点](#根据表达式值变化产生断点)
    - [禁用或启动断点](#禁用或启动断点)
    - [清除断点](#清除断点)
  - [查看各类信息](#查看各类信息)
    - [查看源代码](#查看源代码)
    - [查看变量](#查看变量)
      - [指定打印变量的格式](#指定打印变量的格式)
    - [查看内存](#查看内存)
    - [设置程序中断后欲显示的数据及格式](#设置程序中断后欲显示的数据及格式)
    - [查看寄存器内容](#查看寄存器内容)
  - [运行被调试的程序](#运行被调试的程序)
  - [帮助命令](#帮助命令)
  - [gdb 调试 Golang 的可执行程序](#gdb-调试-golang-的可执行程序)
  - [参考](#参考)

## g++ 编译

- 添加编译参数 `-std=c++11 -fpermissive`
- 指定编译生成的可执行文件名字 `-o program_name`
- 添加调试编译，将源代码信息编译到可执行文件中 `-g`
- 不用 `-g`，看不到程序的函数名、变量名，代替的是运行时的内存地址
- 没有源代码，调试和跟踪时只能是汇编代码级别的

## 启动 GDB 调试

- 先启动 gdb，再加载被调试的可执行程序文件：
  - `gdb`
  - `file program_name`
- 也可在启动调试时载入被调试程序名字 `gdb program_name`
- 同时调试一个运行程序和 core 文件，core 是程序非法执行后 core dump 后产生的文件 `gdb program_name core`
- 指定程序运行的进程 ID `gdb program_name process_id`，主要用于服务程序
- 调试一个正在运行的程序 `gdb -p process_id`，`-p` 可用于忽略程序名
- 退出 GDB 调试环境 `q(quit)`

## 设置断点

### 根据行号设置断点

- b + 行号 `b [file:]line_num`

### 根据函数名设置断点

- b + 函数名称 `b [file:]func_name`
- b + \*函数名称，将断点设置在由编译器生成的 prolg 代码处 `b *main`

### 根据代码地址设置断点

- b + \*代码地址 `b *004835c`

### 根据条件设置断点

- `break file:line_num if expression` 当 `expression` 满足时，程序会在文件 `file` 的第 `line_num` 停下来
- `condition breakpoint_num expression` 当 `expression` 满足时，程序会在第 `breakpoint_num` 个断点处停下来  ，可用来修改断点产生的条件

### 根据规则设置断点

- `rbreak regex` 对所有调用了 `regex` 包含的函数设置断点
- `rbreak file:regex` 对某个文件中的满足 `regex` 的函数设置断点

### 设置临时断点

- `tbreak file:line_num`
- `u(until)`

### 跳过多次设置断点

- `ignore breakpoint_num N` 跳过第 `breakpoint_num` 个断点 `N` 次，当某个地方之前多少次不会出错，之后可能出错时使用

### 根据表达式值变化产生断点

- `watch expression` 当 `expression` 变化时会打印相关内容
  - 注意：程序必须运行起来，否则可能会提示当前上下文没有符号的错误
- `rwatch` 设置变量被读时停止
- `awatch` 设置变量被读或被写时停止

### 禁用或启动断点

- `disable (breakpoint_num)` 禁用断点，不指定编号则禁用所有断点
- `enable (breakpoint_num)` 启用断点，不指定编号则启用所有断点
- `enable delete breakpoint_num` 启用断点，并在此之后删除断点

### 清除断点

- `d (breakpoint_num)` 删除断点，不指定编号则删除所有断点
- `clear` 删除当前行的所有断点
- `clear func_name` 删除函数名为 `func_name` 的断点
- `clear line_num` 删除行号是 `line_num` 的断点
- `clear file:func_name` 删除文件 `file` 中函数名为 `func_name` 的断点
- `clear file:line_num` 删除文件 `file` 中行号是 `line_num` 的断点

## 查看各类信息

- 查看当前的所有断点信息 `i(info) breakpoints`
- 查看程序是否在运行，进程号，被暂停的原因
- 查看程序运行路径 `show paths`
- 设置环境变量 `set env(environment) varname[=value]`
- 查看环境变量 `show environment [varname]`
- 显示当前所在目录 `pwd`
- 查看函数堆栈 `bt(backtrace)`
- 指定运行时参数 `set args 参数`
- 查看设置好的参数 `show args`

### 查看源代码

- `l(list)` 从第一行开始显示源码，继续输入 `l` 列出后面的源码
  - `l+` 和 `l-` 分别列出上一次列出源码的后面或者前面部分
  - `l line_num` 跟行号则列出附近的源码
  - `l start_line_num,end_line_num` 列出指定行之间的源码
    - 不指定开始行，则列出到结束行的指定行数
    - 不指定结束行，则列出从开始行的指定行数
  - `l func_name` 跟函数名列出函数附近的源码
  - `l file` 列出指定文件的源码
  - `l file:func_name` 列出指定文件指定函数的源码
  - `l file:line_num` 列出指定文件指定行附近的源码
  - `l file:start_line_num,file:end_line_num` 列出指定文件指定行范围的源码
- `set listsize num` 设置源码一次列出行数：设置为 0 或者 unlimited 时没有限制
- `show listsize` 查看源码一次列出行数
- 当依赖的源码文件位置移动时
  - 使用 `dir path` 指定源码文件路径
  - 或者使用 `substitute-path` 替换路径字符串
    - 查看源码路径使用 `readelf file -p .debug_str`
    - 替换原路径 `set substitute-path path_from path_to`
    - 查看设置结果 `show substitute-path`
    - 取消设置 `unset substitute-path path_from`

### 查看变量

- 显示指定变量（临时变量或全局变量）的值 `p(print)` `p a` `p 'file':a`
  - 变量名相同时，可以在前面加上函数名或文件名以便区分
- `p var_name` 打印基本类型
- `p pointer_name` 打印指针地址
- `p *pointer_name` 打印指针指向的内容
- `p *pointer_name@N` 打印指针的前 N 个元素

#### 指定打印变量的格式

| 格式控制字符 | 含义 |
| --- | --- |
| x | 16 进制 |
| d | 10 进制 |
| u | 16 进制无符号整型 |
| o | 8 进制 |
| t | 2 进制 |
| a | 16 进制 |
| c | 字符格式 |
| f | 浮点数格式 |

示例： `p/x var_name` `p/t var_name`

### 查看内存

`x(examine)` 用于查看内存地址中的值，语法 `x/[n][f][u] addr`

- `n` 表示要显示的内存单元数，默认为 1
- `f` 表示打印格式，即上述的格式控制字符
- `u` 表示要打印的单元长度
- `addr` 表示内存地址

| 单元类型控制字符 | 含义 |
| --- | --- |
| b | 字节 |
| h | 半字，2 字节 |
| w | 字，4 字节 |
| g | 8 字节 |

示例：`x/4tb &var_name` 以二进制方式打印变量 `var_name`，打印单位是字节，显示变量的 4 个字节

### 设置程序中断后欲显示的数据及格式

- `display var_name` 在程序停止时，会显示变量 `var_name` 的值
  - 例如 `display /i $pc`，每次程序中断后可以看到即将被执行的下一条汇编指令，`$pc` 代表当前汇编指令，`/i` 表示以十六进制显示
- `info display` 查看哪些变量设置了 display
- `delete display (display_num)` 删除 display，不指定编号则删除所有 display
- `disable display (display_num)` 禁用 display，不指定编号则禁用所有 display
- `undisplay N` 取消先前的 display 设置，编号从 1 递增

### 查看寄存器内容

- `info register`

## 运行被调试的程序

- 运行 `r(run) [arglist]`，如果没有断点则执行完，否则暂停在第一个可用断点处
- 继续执行被调试程序 `c(continue) (num)`，直至下一个断点或程序结束
  - 后面跟上数字表示执行该命令的次数
- 执行一行源程序代码：
  - 如果该行有程序调用，则进入该函数 `s(step into)`，单步进入
    - 要求进入的函数由调试信息且有源码信息
    - 使用 `finish` 跳过函数的执行
  - 一并执行该行代码中的函数调用 `n(step over) (num)`，单步执行
    - 后面跟上数字表示执行该命令的次数
- 执行一行汇编指令 `si/ni`，类似于 s/n 命令

## 帮助命令

- help，提供对 GDB 各种命令的解释说明
  - 指定了命令名称参数，则显示该命令的详细说明`help display`
  - 没有指定参数，则分类显示所有 GDB 命令
- 直接回车，表示重复上一次命令

## gdb 调试 Golang 的可执行程序

执行 `sudo gdb golang_binary_file`。比如有一个 Golang 的可执行程序 rtspserver，依赖 ffmpeg 库。调试的流程：

```sh
# 开始调试
gdb
# 进入 gdb 之后先设置 ffmpeg 库路径
set environment LD_LIBRARY_PATH=/home/kiki/Documents/ffmpeg/ffmpeg-4.1/lib
# 开始调试
file rtspserver
# 运行程序
r
# 程序崩溃，查看堆栈
where
# ... ...
```

## 参考

- `man gdb`
- [GDB调试入门指南](https://zhuanlan.zhihu.com/p/74897601)
