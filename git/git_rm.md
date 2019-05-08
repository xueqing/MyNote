# 移除文件

```sh
# 从工作目录中删除指定的文件并存入暂存区
git rm file1
# 删除之前修改过并且已经放到暂存区域的文件, --forced, 用于防止误删还没有添加到快照的数据
git rm -f file1
# 从 git 仓库中删除文件, 即从暂存区域移除, 但仍然保留在当前工作目录
git rm --cached file1
# 可以使用 glob 模式
# 删除 log/ 目录下扩展名为 .log 的所有文件
git rm log/\*.log
```