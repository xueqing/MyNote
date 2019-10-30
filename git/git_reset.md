# 重设状态

- 将当前分支的 HEAD 重设到指定的状态

## 语法

- `git reset [<mode>] [-q] [<commit>]`
  - mode 包括`--soft | --mixed [N] | --hard | --merge | --keep`
  - 设置当前分支的 HEAD 到 `<commit>`
  - mixed 是默认模式
- `reset` 之前，git 会保存原本的 `HEAD` 到 `ORIG_HEAD`
  - `git reset <commit>` 之后可通过 `git reset ORIG_HEAD` 回到原来的地方

```sh
# 重设暂存区和工作区, 丢弃所有改变, 把 HEAD 指向 commit
git reset --hard
# 暂存区和工作区内容不做任何改变, 仅把 HEAD 指向 commit, 可用于删除提交历史记录, 只生成一次提交
git reset --soft
# 仅重设暂存区, 不改变工作区
git reset --mixed
```

## git reset --soft 合并提交

```sh
# 合并最近 3 次提交
git reset --soft HEAD~3
# 使用这 3 次提交的信息
git commit --edit -m"$(git log --format=%B --reverse HEAD..HEAD@{1})"
# 重新编写提交信息
git add . && git commit -m "new commit message"
```
