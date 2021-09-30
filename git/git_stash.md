# git stash

## 常用命令

- `git stash`/`git stash save` 将当前修改暂存
- `git stash list` 列举暂存的修改
- `git stash pop` 恢复最近一次暂存的修改
- `git stash apply` 恢复指定的暂存的修改，一般用于恢复比较早的修改(非最近一次)时使用

## 恢复 git stash drop 删除的暂存区

参考 [git stash drop 误用恢复](https://blog.csdn.net/u014213012/article/details/104640094) 进行整理。

- 使用 `git stash drop stash@{num}` 删除暂存区时在终端会输出类似 `Dropped stash@{num} (commit-id)` 的信息
- 使用 `git show commit-id` 查看该提交修改的内容
- 使用 `git stash apply commit-id` 可恢复删除暂存区内容

如果没有记录 `git stash drop stash@{num}` 输出的 `commit-id`，可使用 `git fsck --lost-found` 查看最近删除的一些提交。

- 使用 `git fsck --lost-found` 会输出类似 `dangling commit commit-id` 的信息
- 使用 `git show commit-id` 查看指定提交修改的内容

可以创建脚本输出删除的内容，保存到文件方便查看代码。

- 使用 `git fsck --lost-found >> lost.txt` 保存输出
- 或使用 `git fsck --unreachable >> unreach.txt` 保存输出
- 创建脚本，从上述保存的文件中读取最近删除的 `commit-id`,并使用 `git show commit-id` 将指定提交修改的内容保存到文件

```txt
#!/bin/sh
INFILE="lost.txt"    # lost.txt 对应 dangling commit, unreach.txt 对应 unreachable commit
OUTFILE="modify.txt" # 保存修改的代码

while read -r line
do
  COMMIT=`echo $line | awk '/dangling commit/ {print $3}'`
  if [ $COMMIT ];then
    git show $COMMIT >> $OUTFILE
    echo "=================================\n" >> $OUTFILE
  fi
done < $INFILE
```
