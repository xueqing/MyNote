# 常见场景

- [常见场景](#%e5%b8%b8%e8%a7%81%e5%9c%ba%e6%99%af)
  - [1 恢复之前删除的文件](#1-%e6%81%a2%e5%a4%8d%e4%b9%8b%e5%89%8d%e5%88%a0%e9%99%a4%e7%9a%84%e6%96%87%e4%bb%b6)
  - [2 将 dev 分支快速合并到 master 分支](#2-%e5%b0%86-dev-%e5%88%86%e6%94%af%e5%bf%ab%e9%80%9f%e5%90%88%e5%b9%b6%e5%88%b0-master-%e5%88%86%e6%94%af)
  - [3 将基于 server 分支的 client 分支的提交和 server 的提交快速合并到 master 分支](#3-%e5%b0%86%e5%9f%ba%e4%ba%8e-server-%e5%88%86%e6%94%af%e7%9a%84-client-%e5%88%86%e6%94%af%e7%9a%84%e6%8f%90%e4%ba%a4%e5%92%8c-server-%e7%9a%84%e6%8f%90%e4%ba%a4%e5%bf%ab%e9%80%9f%e5%90%88%e5%b9%b6%e5%88%b0-master-%e5%88%86%e6%94%af)
  - [4 从所有提交中删除某文件](#4-%e4%bb%8e%e6%89%80%e6%9c%89%e6%8f%90%e4%ba%a4%e4%b8%ad%e5%88%a0%e9%99%a4%e6%9f%90%e6%96%87%e4%bb%b6)
  - [5 将 dev 新提交的代码合并到 master 分支](#5-%e5%b0%86-dev-%e6%96%b0%e6%8f%90%e4%ba%a4%e7%9a%84%e4%bb%a3%e7%a0%81%e5%90%88%e5%b9%b6%e5%88%b0-master-%e5%88%86%e6%94%af)
  - [6 撤消操作](#6-%e6%92%a4%e6%b6%88%e6%93%8d%e4%bd%9c)
  - [7 单分支合作开发](#7-%e5%8d%95%e5%88%86%e6%94%af%e5%90%88%e4%bd%9c%e5%bc%80%e5%8f%91)

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

参考 [git filter branch](git_filter_branch.md) 命令

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

## 6 撤消操作

```sh
# 尝试重新提交
git commit --amend
# 取消暂存文件 f1
git reset HEAD f1
# 撤消之前对文件 f1 所做的修改
git checkout -- f1
# git reset [--hard | soft | mixed | merge | keep] [HEAD | <commit>]
```

## 7 单分支合作开发

假定都在 dev 分支开发：

- 第一次在 dev 分支开发

  ```sh
  # 1 克隆仓库源码，切换到仓库目录
  git clone xxx
  # 2 切换到 dev 分支，会自动跟踪远程最新的 dev
  git checkout dev
  # 3 本地修改
  git add xxx
  # 4 提交
  git commit -m "xxxxx"
  ```

- 提交本地 dev 分支的修改到远程仓库

  ```sh
  # 1 拉取最新的代码
  # 1.1 merge 合并分支代码
  git pull origin dev
  # 1.2 rebase 合并代码将提交历史直线化
  git pull --rebase origin dev
  # 3 可能需要合并冲突，合并之后使用 git add 和 git commit 进行提交
  # 4 推送代码到远程仓库
  git push origin dev
  ```
