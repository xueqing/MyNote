# [wget 命令](http://man.linuxde.net/wget)

- wget 用来从指定的 URL 下载文件
- wget 非常稳定，在网络原因下载失败时会不断重试知道下载完毕；如果是服务器影响下载，会再次连到服务器从断掉的地方继续下载
- `wget URL`下载单个文件
- `wget -O filename URL`下载并保存成不同的文件名
- `wget -c URL`使用断点续传
