# 常见场景

- [常见场景](#%E5%B8%B8%E8%A7%81%E5%9C%BA%E6%99%AF)
  - [1 恢复之前删除的文件](#1-%E6%81%A2%E5%A4%8D%E4%B9%8B%E5%89%8D%E5%88%A0%E9%99%A4%E7%9A%84%E6%96%87%E4%BB%B6)
  - [2 将 dev 分支快速合并到 master 分支](#2-%E5%B0%86-dev-%E5%88%86%E6%94%AF%E5%BF%AB%E9%80%9F%E5%90%88%E5%B9%B6%E5%88%B0-master-%E5%88%86%E6%94%AF)
  - [3 将基于 server 分支的 client 分支的提交和 server 的提交快速合并到 master 分支](#3-%E5%B0%86%E5%9F%BA%E4%BA%8E-server-%E5%88%86%E6%94%AF%E7%9A%84-client-%E5%88%86%E6%94%AF%E7%9A%84%E6%8F%90%E4%BA%A4%E5%92%8C-server-%E7%9A%84%E6%8F%90%E4%BA%A4%E5%BF%AB%E9%80%9F%E5%90%88%E5%B9%B6%E5%88%B0-master-%E5%88%86%E6%94%AF)
  - [4 从所有提交中删除某文件](#4-%E4%BB%8E%E6%89%80%E6%9C%89%E6%8F%90%E4%BA%A4%E4%B8%AD%E5%88%A0%E9%99%A4%E6%9F%90%E6%96%87%E4%BB%B6)
  - [5 将 dev 新提交的代码合并到 master 分支](#5-%E5%B0%86-dev-%E6%96%B0%E6%8F%90%E4%BA%A4%E7%9A%84%E4%BB%A3%E7%A0%81%E5%90%88%E5%B9%B6%E5%88%B0-master-%E5%88%86%E6%94%AF)
    - [6 撤消操作](#6-%E6%92%A4%E6%B6%88%E6%93%8D%E4%BD%9C)

## 1 恢复之前删除的文件

比方 A，B，C，D 是四个连续的提交，其中 B 基于 A 删除了一些文件。现在需要把这些删除的文件加回 D。假设现在位于 D

```sh
# 方法1：A与B的差别是那些删除的文件。可以创建一个补丁代表这些差别，然后打补丁
git diff B A | git apply
# 方法2：从 A 中把文件拿出来
git checkout A foo.c bar.h
# 方法3：把从 A 到 B 的变化视为可撤销的变更
git revert B
```

## 2 将 dev 分支快速合并到 master 分支

```sh
# 找到 dev 和 master 分支最近共同祖先, 提取 dev 分支相对于最近共同祖先所做的所有提交修改并存为临时文件,
# 然后将 dev 分支 指向 master 分支, 最后将之前另存的临时文件的修改依次应用
# 等同于 git checkout dev && git rebase master
git rebase master dev
# 切回 master 分支, 进行一次快速合并
git checkout master && git merge dev
```

## 3 将基于 server 分支的 client 分支的提交和 server 的提交快速合并到 master 分支

```sh
# 取出 client 分支, 找出处于 client 和 server 分支的共同祖先之后的修改, 然后把它们在 master 分支上重放一遍
git rebase --onto master server client
# 切回 master 分支, 进行一次快速合并
git checkout master && git merge client
# 将 server 分支变基到目标分支 master
# 等同于 git checkout server && git rebase master
git rebase master server
# 切回 master 分支, 进行一次快速合并
git checkout master && git merge server
# 删除两个分支
git branch -d client server
```

## 4 从所有提交中删除某文件

```sh
```

## 5 将 dev 新提交的代码合并到 master 分支

- 合并分支分两种
  - 刻意制造分支，使得版本迭代历史更加清晰
    - `--no-off` 即执行正常合并，在当前分支上生成一个合并节点
    - 不加 `--no-off`，git 默认执行“快速合并（fast-forward merge）”，如果 dev 分支本来是基于最新的 master 分支开发的，合并之后 master 分支会指向当前的 dev 分支
  - 将提交历史直线化，使得 master 分支的提交历史没有分叉

```sh
# 1 切换到 dev 分支
git checkout dev
# 2 提交修改 git commit -a -m "xxx"
# 3 切换到 master 分支
git checkout master
# 4 拉取最新的代码
git pull --rebase origin master
# 5 合并分支
# 5.1 刻意制造分支：合并 dev 分支代码到 master 分支
git merge --no-off dev
# 5.2 将提交历史直线化
# 5.2.1 切换到要合并的分支
git checkout dev
# 5.2.2 将需要提交的代码变基到最新的 master 分支
git rebase master
# 5.2.3 切换到 master 分支
git checkout master
# 5.2.4 快速合并 dev 分支
git merge dev
# 6 推送代码到远程仓库
git push origin master
```

### 6 撤消操作

```sh
# 尝试重新提交
git commit --amend
# 取消暂存文件 f1
git reset HEAD f1
# 撤消之前对文件 f1 所做的修改
git checkout -- f1
# git reset [--hard | soft | mixed | merge | keep] [HEAD | <commit>]
```
