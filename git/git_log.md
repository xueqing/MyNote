# git log

- [git log](#git-log)
  - [语法](#语法)
  - [常用命令](#常用命令)
  - [引用日志 reflog](#引用日志-reflog)
  - [查看文件修改历史](#查看文件修改历史)
  - [参考](#参考)

## 语法

`git log [<options>] [<revision range>] [[--] <path>…​]`

- options

| 参数 | 含义 |
| --- | --- |
| `-L <start>,<end>:<file>` | 查看指定文件的开始行到结束行的提交历史 |
| `-L :<funcname>:<file>` | 查看指定文件的函数的提交历史 |

## 常用命令

- git log --pretty              # 使用其他格式显示历史提交信息. 可用 oneline/short/full/fuller/format

```sh
# 按行显示每次提交
git log --pretty=oneline
# 定制要显示的记录格式
git log --pretty=format
```

- git log --stat                # 显示每次更新的文件修改统计信息
- git log --graph               # 显示 ASCII 图形表示的分支合并历史
- git log -p                    # 按补丁格式显示每个更新之间的差异

```sh
# 比较本地 master 分支和 origin/master 分支的差别
git log -p master..origin/master
# 显示最近两次提交的差别
git log -p -2
```

- git log --decorate            # 查看各个分支当前所指的对象

```sh
# 输出提交历史、各个分支的指向以及项目的分支分叉情况
git log --oneline --decorate --graph --all
# 显示简短且唯一的 SHA-1 值
git log --abbrev-commit
```

- git log -(n)                  # 仅显示最近的 n 条提交
- git log --since, --after      # 仅显示指定时间之后的提交
- git log --until, --before     # 仅显示指定时间之前的提交
- git log --author              # 仅显示指定作者相关的提交
- git log --committer           # 仅显示指定提交者相关的提交
- git log --grep                # 仅显示含指定关键字的提交
- git log -S                    # 仅显示添加或移除了某个关键字的提交
- git log -g                    # 查看类似于 git log 输出格式的引用日志信息

## 引用日志 reflog

- 工作时,  git 会在后台保存一个引用日志(reflog), 引用日志记录了最近几个月你的 HEAD 和分支引用所指向的历史
- 每当 HEAD 指向的位置发生了变化, git 就会将这个信息存储到引用日志
- 引用日志只存在于本地仓库, 一个记录你在你自己的仓库里做过什么的日志

```sh
# 查看引用日志
git reflog
# 使用`@{n}`引用 reflog 中输出的提交记录
git show HEAD@{5}
# 查看 master 分支在昨天的时候指向了哪个提交
git show master@{yesterday}
```

- 祖先引用是另一种指明一个提交的方式. 如果在引用的尾部加上一个`^`,  git 会将其解析为该引用的上一个提交

```sh
# 查看上一个提交, 也就是 “HEAD 的父提交”
git show HEAD^
# d921970^2 代表 “d921970 的第二父提交” 这个语法只适用于合并(merge)的提交
git show d921970^2
# HEAD^^^, 也是第一父提交的第一父提交的第一父提交
git show HEAD~3
# HEAD^^^, 也是第一父提交的第一父提交的第一父提交的第二父提交
git show HEAD~3^2
```

## 查看文件修改历史

`git log -L <start>,<end>:<file>` 查看 `<file>` 文件 `<start>,<end>` 范围的修改历史。

- `<start>` 和 `<end>` 可以是 `number`。表示文件的绝对行编号，从 1 开始
- `<start>` 和 `<end>` 可以是 `/regex/`
  - 如果 `<start>` 是 `/regex/`，则从上一个 `-L` 范围的末尾开始搜，找不到的话从文件开头开始搜
  - 如果 `<start>` 是 `^/regex/`，则从文件开头开始搜
  - 如果 `<end>` 是 `/regex/`，则从 `<start>` 指定的行开始搜
- `<end>` 可以是 `+offset` 或 `-offset`，`<start>` 不支持此格式。表示 `<start>` 指定的行之前或之后的行范围

`git log -L :<funcname>:<file>` 查看 `<file>` 文件由 `<funcname>` 正则表达式给定的范围的修改历史。

- 这是一个正则表达式，表示匹配 `<funcname>` 的第一个行开始，到下一个匹配的行
- `:<funcname>` 从上一个 `-L` 范围的末尾开始搜，找不到的话从文件开头开始搜索
- `^:<funcname>` 从文件开头开始搜索

## 参考

- [git log](https://www.git-scm.com/docs/git-log)
