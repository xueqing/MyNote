# 提交更新

```sh
# 将提交信息与命令放在同一行
git commit -m "add README"
# 自动把所有已经跟踪过的文件暂存起来一并提交, 跳过 git add 步骤
git commit -a -m "add README"
# 在日志信息之后添加提交者的信息，--signoff
git commit -s
# git commit <file>...
git commit -p
git commit –allow-empty
# 改变上一次提交
git commit --amend
# 把本地的修改包含在上一次提交
git commit --amend -a
```
