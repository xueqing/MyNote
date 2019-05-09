# git 变基

- [git 变基](#git-%E5%8F%98%E5%9F%BA)
  - [变基](#%E5%8F%98%E5%9F%BA)
  - [git rebase](#git-rebase)
    - [git rebase -i](#git-rebase--i)
  - [参考](#%E5%8F%82%E8%80%83)

## 变基

- 变基和三方合并整合的最终结果指向的快照始终是一样的, 只是提交历史不同
- 变基是将一系列提交按照原有次序依次应用到另一分支上, 而三方合并是把最终结果合在一起
- 变基使得提交历史更加简洁
- **注意**：不要对在你的仓库外有副本的分支执行变基

## git rebase

```sh
# 将当前分支变基到 base_branch
git rebase base_branch
# 将 topic_branch 变基到 base_branch
# 等同于 git checkout topic_branch && git rebase base_branch
git rebase base_branch topic_branch
```

### git rebase -i

- 交互式变基的命令
  - pick/p：使用提交
  - reword/r：使用提交，但是修改日志信息
  - edit/e：标记一个提交需要修改
  - squash/s：将当前提交与前一个提交合并
  - fixup/f：将当前提交与前一个提交合并，并丢弃日志信息
  - exec/x：使用 shell 运行剩下的命令行
  - drop/d：删除提交

```sh
# 放弃修改
git rebase --abort
# 重写从初次提交到达 commit 的所有历史
git rebase -i --root <commit>
```

## 参考

- [git rebase](https://git-scm.com/docs/git-rebase)