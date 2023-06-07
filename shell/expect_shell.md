# expect 脚本

- expect 是用来进行自动化控制和测试的工具，可以执行交互式的脚本
- 在执行脚本过程中，一些交互式的过程可能需要用户输入等信息，这种情况下课使用 expect 脚本
- 基本命令
  - send：向进程发送字符串，用于模拟用户的输入，一定要加 \r 回车
  - expect：从进程接收字符串
  - spawn：启动进程，spawn 启动的进程的输出可被 expect 捕获
  - interact：用户交互
- 下面的脚本可将文件 scp 远程拷贝到某台机器

```shell
#!/usr/bin/expect
set timeout 100                 ## 设置超时时间， -1 可无限等待
set filename [lindex $argv 0]   ## 接收输入参数，保存文件名
set machineURL [lindex $argv 1] ## 接收输入参数，保存远程机器的上传的 URL，包括用户名，IP 地址和路径
set machinePWD [lindex $argv 2] ## 接收输入参数，保存远程机器的密码
spawn scp $filename $machineURL ## 执行 scp 命令
expect {
    "yes/no" { send "yes\n";exp_continue }  ## 如果出现"yes/no"，则输入"yes"，然后继续这个循环
    "password: " { send "$machinePWD\n" }   ## 如果出现"password:"，则输入保存的密码，然后退出这个循环，继续往下
}
expect 100%       ## 出现 100% 表明上传成功
set timeout 3
expect eof        ## 等待结束标记，由 spawn 启动的命令在结束时回产生一个 eof 标记
```

**注意：** expect 不能正确解释 shell 的 glob 模式，所以执行类似 `spawn scp -r /home/user/dir1/ cluster_server:` 的命令会出错。解决方法：

```sh
spawn bash -c "scp -r /home/user/dir1/* cluster_server:"
```
