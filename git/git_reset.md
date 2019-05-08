# 重设分支

- 将当前的分支重设(reset)到指定的 commit 或 HEAD(默认), mixed 是默认模式
  -`git reset [--hard | soft | mixed | merge | keep] [HEAD | <commit>]`

```sh
# 重设暂存区和工作区, 丢弃所有改变, 把 HEAD 指向 commit
git reset --hard
# 暂存区和工作区内容不做任何改变, 仅把 HEAD 指向 commit, 可用于删除提交历史记录, 只生成一次提交
git reset --soft
# 仅重设暂存区, 不改变工作区
git reset --mixed
```