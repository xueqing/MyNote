# git log

- [git log](#git-log)
  - [语法](#%E8%AF%AD%E6%B3%95)
  - [常用命令](#%E5%B8%B8%E7%94%A8%E5%91%BD%E4%BB%A4)
  - [参考](#%E5%8F%82%E8%80%83)

## 语法

`git log [<options>] [<revision range>] [[--] <path>…​]`

- options

| 参数 | 含义 |
| --- | --- |
| `-L <start>,<end>:<file>` | 查看指定文件的开始行到结束行的提交历史 |
| `-L :<funcname>:<file>` | 查看指定文件的函数的提交历史 |

## 常用命令

- git log --pretty              # 使用其他格式显示历史提交信息. 可用 oneline/short/full/fuller/format- [git log](#git-log)
  - [语法](#%E8%AF%AD%E6%B3%95)
  - [常用命令](#%E5%B8%B8%E7%94%A8%E5%91%BD%E4%BB%A4)
  - [参考](#%E5%8F%82%E8%80%83)(后跟指定格式)
  - `git log --pretty=oneline`  # 按行显示每次提交
  - git log --pretty=format     # 定制要显示的记录格式
- git log --stat                # 显示每次更新的文件修改统计信息
- git log --graph               # 显示 ASCII 图形表示的分支合并历史
- git log -p                    # 按补丁格式显示每个更新之间的差异
  - `git log -p master..origin/master`          # 比较本地 master 分支和 origin/master 分支的差别
  - `git log -p -2`             # 显示最近两次提交的差别
- git log --decorate            # 查看各个分支当前所指的对象
  - git log --oneline --decorate --graph --all  # 输出提交历史、各个分支的指向以及项目的分支分叉情况
  - git log --abbrev-commit     # 显示简短且唯一的 SHA-1 值
- git log -(n)                  # 仅显示最近的 n 条提交
- git log --since, --after      # 仅显示指定时间之后的提交
- git log --until, --before     # 仅显示指定时间之前的提交
- git log --author              # 仅显示指定作者相关的提交
- git log --committer           # 仅显示指定提交者相关的提交
- git log --grep                # 仅显示含指定关键字的提交
- git log -S                    # 仅显示添加或移除了某个关键字的提交
- git log -g                    # 查看类似于 git log 输出格式的引用日志信息

## 参考

- [git log](https://www.git-scm.com/docs/git-log)