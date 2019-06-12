# 远程仓库

```sh
# 查看指定的每一个远程服务器的简写
git remote
# 查看需要读写远程仓库使用的 git 保存的简写与其对应的 URL
git remote -v
# 查看某一个远程仓库信息
git remote show [remote-name]
# 添加一个新的远程 git 仓库, 同时指定一个简写
git remote add <shortname> <url>
# 移除一个远程仓库
git remote rm lvlin
# 修改一个远程仓库的简写名, 这同样也会修改远程分支名字
git remote rename temp lvlin
# 列出远端分支
git remote -r
```
