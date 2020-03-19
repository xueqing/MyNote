# netstat 命令

```sh
# 查看所有端口的占用情况
netstat -ano
# 查看指定端口的占用情况
netstat -aon | findstr "8080"
# 查看PID对应的进程
tasklist | findstr "10010"
# 结束该进程
taskkill /f /t /im xxx.exe
taskkill /f /pid 10010
```
