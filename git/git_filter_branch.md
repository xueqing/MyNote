# 重写分支

- [重写分支](#%e9%87%8d%e5%86%99%e5%88%86%e6%94%af)
  - [git filter-branch](#git-filter-branch)
  - [git 永久删除某个文件](#git-%e6%b0%b8%e4%b9%85%e5%88%a0%e9%99%a4%e6%9f%90%e4%b8%aa%e6%96%87%e4%bb%b6)
  - [参考](#%e5%8f%82%e8%80%83)

## git filter-branch

```sh
# 从所有提交中删除文件 filename
# 当提交中不包含此文件时，`rm filename`会失败提交，可使用`rm -f filename`
git filter-branch --tree-filter 'rm filename' HEAD
# 比 --tree-filter 更快
git filter-branch --index-filter 'git rm --cached --ignore-unmatch filename' HEAD
```

## git 永久删除某个文件

**注意：**使用 `git stash` 保存的修改，在运行 `git filter-branch` 之后，不能再使用 `git stash` 命令追溯保存的修改。因此，**建议**在运行 `git filter-branch` 之前，不要使用 `git stash` 保存修改。另外，可使用 `git stash show -p | git apply -R` 应用保存的最后一次修改。

- 执行下面的命令，替换 `PATH-TO-YOUR-FILE-WITH-SENSITIVE-DATA` 为想要删除的文件相对路径(相对于 git 仓库的根目录)

  ```sh
  git filter-branch --force --index-filter \
    "git rm --cached --ignore-unmatch PATH-TO-YOUR-FILE-WITH-SENSITIVE-DATA" \
    --prune-empty --tag-name-filter cat -- --all
  ```

  - `filter-branch`: git 会重写每一个分支
  - `--force`: 遇到冲突强制执行
  - `--index-filter`: 指定重写的时候应该执行的命令，其后紧跟的是要执行的命令，即 `git rm --cached --ignore-unmatch PATH-TO-YOUR-FILE-WITH-SENSITIVE-DATA`，git 会删除匹配的缓存文件
    - 如果要删除的是文件夹，在 `git rm --cached` 之后添加 `-r`，表示递归删除
    - 如果删除的文件较多，可以写脚本文件执行命令，或使用通配符 `*`
  - `--prune-empty`: 如果重写导致某次提交为空，则忽略该提交
  - `--tag-name-filter`: 表示对每个 tag 命名方法，其后紧跟重命名的命令，用 cat 表示保持 tag 名称不变
  - `--`: 分隔符
  - `--all`: 表示考虑所有文件
- 如果打印 `Rewrite xxxx ... Ref 'xxxx' was rewritten` 表示删除成功。`xxxx unchanged` 表示仓库没有找到该文件
- 将文件添加到 `.gitignore`，确保下次不会提交
- 检查提交历史，确保所有分支都删除该文件
- 强制推送本地修改重写远程仓库: `git push origin --force --all`
- 强制推送 tag，确保发布的版本也删除了文件: `git push origin --force --tags`
- 通知其他合作开发者 `rebase` 所有基于修改之前的仓库创建的分支
- 一段时间之后，当确保 `git filter-branch` 没有负面影响，可以强制接触对本地仓库的所有对象的引用和垃圾回收。执行下面的命令(git 1.8.5 或更新的版本才会支持)

  ```sh
  git for-each-ref --format="delete %(refname)" refs/original | git update-ref --stdin
  git reflog expire --expire=now --all
  git gc --prune=now
  ```

## 参考

- [git filter-branch doc](https://git-scm.com/docs/git-filter-branch)
- [Removing sensitive data from a repository](https://help.github.com/en/github/authenticating-to-github/removing-sensitive-data-from-a-repository)
