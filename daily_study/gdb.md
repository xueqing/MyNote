# GDB 学习

## g++ 编译

- 添加编译参数`-std=c++11 -fpermissive`
- 指定编译生成的可执行文件名字`-o gdb-sample`
- 添加调试编译，将源代码信息编译到可执行文件中`-g`
- 不用 -g，看不到程序的函数名、变量名，代替的是运行时的内存地址
- 没有源代码，调试和跟踪时只能是汇编代码级别的

## 启动 GDB 调试

- 先启动 gdb，再加载被调试的可执行程序文件：
  - `gdb`
  - `file gdb-sample`
- 也可在启动调试时载入被调试程序名字`gdb gdb-sample`
- 同时调试一个运行程序和 core 文件，core 是程序非法执行后 core dump 后产生的文件`gdb gdb-sample core`
- 指定程序运行的进程 ID：`gdb gdb-sample 2048`，主要用于服务程序
- 退出 GDB 调试环境`q(quit)`

## 设置断点

- b + 行号`b 8`
- b + 函数名称`b main`
- b + \*函数名称，将断点设置在由编译器生成的 prolg 代码处`b *main`
- b + \*代码地址`b *004835c`
- 删除断点，不指定编号则删除所有断点`d(delete breakpoints) N`
- 禁用某个断点`disable breakpoints N`
- 允许使用某个断点`enable breakpoints N`
- 清除源文件某一行代码的所有断点`clean number`

## 查看各类信息

- 查看当前的所有断点信息`i(info) breakpoints`
- 查看程序是否在运行，进程号，被暂停的原因
- 显示指定变量（临时变量或全局变量）的值`p(print)`
- 查看程序运行路径`show paths`
- 设置环境变量`set env(environment) varname[=value]`
- 查看环境变量`show environment [varname]`
- 显示当前所在目录`pwd`
- 查看函数堆栈`bt`
- 指定运行时参数`set args 参数`
- 查看设置好的参数`show args`

## 运行被调试的程序

- 运行`r(run)`，如果没有断点则执行完，否则暂停在第一个可用断点处
- 继续执行被调试程序`c(continue)`，直至下一个断点或程序结束
- 执行一行源程序代码：
  - 如果该行有程序调用，则进入该函数`s(step into)`，单步跟踪进入
  - 一并执行该行代码中的函数调用`n(step over)`，单步跟踪
- 执行一行汇编指令`si/ni`，类似于 s/n 命令

## 设置程序中断后欲显示的数据及格式

- 例如`display /i $pc`，每次程序中断后可以看到即将被执行的下一条汇编指令，`$pc`代表当前汇编指令，`/i`表示以十六进制显示
- 取消先前的 display 设置`undisplay N`，编号从 1 递增

## 帮助命令

- help，提供对 GDB 各种命令的解释说明
  - 指定了命令名称参数，则显示该命令的详细说明`help display`
  - 没有指定参数，则分类显示所有 GDB 命令
- 直接回车，表示重复上一次命令
