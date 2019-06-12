# git 分支

- [git 分支](#git-%E5%88%86%E6%94%AF)
  - [HEAD](#head)
  - [git branch](#git-branch)
  - [git checkout](#git-checkout)
  - [合并分支](#%E5%90%88%E5%B9%B6%E5%88%86%E6%94%AF)
  - [拉取分支](#%E6%8B%89%E5%8F%96%E5%88%86%E6%94%AF)
  - [删除远程仓库分支](#%E5%88%A0%E9%99%A4%E8%BF%9C%E7%A8%8B%E4%BB%93%E5%BA%93%E5%88%86%E6%94%AF)
  - [分支引用](#%E5%88%86%E6%94%AF%E5%BC%95%E7%94%A8)

## HEAD

- HEAD：一个指针, 指向当前所在的本地分支
  - HEAD 分支随着提交操作自动向前移动
  - 检出时 HEAD 随之移动

## git branch

```sh
# 查看当前所有分支列表, 星号表示 HEAD 指向的分支
git branch
# 创建新分支 dev
git branch dev
# 以7次前的提交创建新的 master 分支
git branch master HEAD~7
# 在 commit-id 创建分支 dev
git branch dev [commit-id]
# 删除 dev 分支
git branch -d dev
# 强制删除 dev 分支
git branch -D dev
# 查看每个分支的最后一次提交
git branch -v
# 查看哪些分支已经合并到当前分支
git branch --merged
# 查看所有包含未合并工作的分支
git branch --no-merged
# 设置已有的本地分支正在跟踪的上游分支,--set-upstream-to
git branch -u origin/dev
# 重命名 master 分支为 fix
git branch -m master fix
# 列举所有本地分支并显示具体信息
git branch -vv
```

## git checkout

```sh
# 切换至 dev 分支
git checkout dev
# 创建并切换至分支 dev，等同于 git branch + git checkout
git checkout -b dev
# 在 commit-id 创建并切换至分支 dev
git checkout -b dev [commit-id]
# 从远程 dev 分支创建本地分支 deve, 本地 deve 分支会自动从 origin/dev 分支拉取
git checkout -b deve origin/dev
# 以7次前的提交创建并切换到新的 master 分支
git checkout HEAD~7 -b master
# 从远程 dev 分支创建本地分支 dev, 本地 dev 分支会自动从 origin/dev 分支拉取
git checkout --track origin/dev
```

## 合并分支

```sh
# 合并 dev 分支至当前分支
# 当设置好跟踪分支后, 可以通过 @{upstream} 或 @{u} 快捷方式来引用它
# 所以在 master 分支且它正在跟踪 origin/master 时, 可以使用 git merge @{u} 来取代 git merge origin/master
git merge dev
```

## 拉取分支

```sh
# 抓取所有的远程仓库
git fetch --all
```

## 删除远程仓库分支

```sh
# 删除远程 dev 分支, git v1.7.0
git push origin --delete dev
# git v1.5.0
git push origin :dev
# git v2.8.0
git push origin -d dev
```

## 分支引用

```sh
# 查看某个分支指向的SHA-1
git rev-parse branch_name
```
