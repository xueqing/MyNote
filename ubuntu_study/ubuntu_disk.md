# ubuntu 查看磁盘空间

- `df -hl`显示目前所有文件系统的可用空间及使用情形
  - `-h`表示使用`human readable`的输出，即使用 GB，MB 等易读的格式
  - `Filesystem`表示文件系统
  - `Mounted on`表示挂载点
  - `Size``Used``Avail``Use`分别表示分割区的容量、已使用的大小、剩下的大小及使用的百分比
- `du -sh *`显示当前目录下各个文件及目录占用空间大小
  - `du`查询文件或文件夹的磁盘使用空间，可以添加`--max-depth=`限制目录深度
