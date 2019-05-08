# git 教程

  题目：Markdown规范
  作者：kiki
  日期：2017/9/26

- [git 教程](#git-%E6%95%99%E7%A8%8B)
  - [git 安装](#git-%E5%AE%89%E8%A3%85)
  - [git 配置](#git-%E9%85%8D%E7%BD%AE)
  - [git 帮助](#git-%E5%B8%AE%E5%8A%A9)
  - [git 基础](#git-%E5%9F%BA%E7%A1%80)
    - [git 仓库、工作目录、暂存区域、文件状态](#git-%E4%BB%93%E5%BA%93%E5%B7%A5%E4%BD%9C%E7%9B%AE%E5%BD%95%E6%9A%82%E5%AD%98%E5%8C%BA%E5%9F%9F%E6%96%87%E4%BB%B6%E7%8A%B6%E6%80%81)
    - [初始化版本库](#%E5%88%9D%E5%A7%8B%E5%8C%96%E7%89%88%E6%9C%AC%E5%BA%93)
    - [常用 git 命令](#%E5%B8%B8%E7%94%A8-git-%E5%91%BD%E4%BB%A4)
  - [git 服务器](#git-%E6%9C%8D%E5%8A%A1%E5%99%A8)
  - [参考网站](#%E5%8F%82%E8%80%83%E7%BD%91%E7%AB%99)
  - [好玩的网站](#%E5%A5%BD%E7%8E%A9%E7%9A%84%E7%BD%91%E7%AB%99)

## git 安装

- [Linux](https://git-scm.com/download/linux)

```sh
# Fedora
sudo yum install git
# Debian
sudo apt-get install git
sudo apt-get install gitk git-gui
# 源码安装,[下载地址](http://git-scm.com/download)
sudo apt-get install libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev
export GIT_VER=2.0.0
wget https://www.kernel.org/pub/software/scm/git/git-$GIT_VER.tar.gz
tar -zxf git-$GIT_VER.tar.gz
pushd git-$GIT_VER
make prefix=/usr/local all
sudo make prefix=/usr/local install
popd
```

- Windows
  - [msysgit](http://git-scm.com/download/win)
  - Git 图形化操作程序, [TortoiseGit](https://tortoisegit.org/)
  - [GitHub for Windows](http://windows.github.com/)
- Mac
  - 安装 Xcode 后自动装上 Git
  - [使用图形化的Git 安装工具Git OS X](https://sourceforge.net/projects/git-osx-installer/)

## git 配置

- 参考[git_config](git_config.md)

## git 帮助

- 有三种命令可以找到 git 命令的使用手册
  - `git help <verb>`
  - `git <verb> --help`
  - `man git-<verb>`
    - `git help config`            # 查看 config 命令的手册

## git 基础

### git 仓库、工作目录、暂存区域、文件状态

- git仓库：git 用来保存项目的元数据和对象数据库的地方
- 工作目录：对项目的某个版本独立提取出来的内容.  是从 git 仓库的压缩数据库中提取出来的文件, 放在磁盘上使用或修改
- 暂存区域(索引)：一个文件, 保存了下次将提交的文件列表信息, 一般在 Git 仓库目录中
- 基本的 Git 工作流程如下：
  - 在工作目录中修改文件
  - 暂存文件, 将文件的快照放入暂存区域
  - 提交更新, 找到暂存区域的文件, 将快照永久性存储到 git 仓库目录
- 文件状态：![git-文件的状态变化周期](gitfilestatus.png "git-文件的状态变化周期")
  - 已提交状态(commited)：git 目录中保存着的特定版本文件
  - 已暂存状态(staged)：作了修改并已放入暂存区域
  - 工作目录下的每一个文件都属于已跟踪(tracked)或未跟踪(untracked),已跟踪的文件状态可处于未修改(unmodified)、已修改(modified)或已放入暂存区(staged)

### 初始化版本库

- 新建版本库

```sh
# 确定版本库目录
mkdir dirname
pushd dirname
# 生成 .git 目录以及其下的版本历史记录文件, push 时易出现冲突
git init
# 创建一个裸仓库, 只保存git历史提交的版本信息, 不允许用户在上面进行各种 git 操作
git init --bare
```

- 克隆版本库
  - 自动将其添加为远程仓库并默认以 “origin” 为简写
  - 自动设置本地 master 分支跟踪克隆的远程仓库的 master 分支

```sh
# 1 使用 ssh 协议克隆
# 1.1 默认本地仓库名字和远程仓库相同
git clone git@github.com:tensorflow/tensorflow.git
# 在当前目录下创建 tensorflow 目录, 并在这个目录下初始化一个 .git 文件夹,
# 从远程仓库拉取下所有数据放入 .git 文件夹, 然后从中读取最新版本的文件的拷贝
# 1.2 自定义本地仓库的名字克隆
git clone git@github.com:tensorflow/tensorflow.git MyTensorflow
# 2 使用 HTTPS 协议克隆
git clone https://github.com/tensorflow/tensorflow.git
```

- 版本库目录 .git

| 文件(夹)名 | 描述 |
| --- | --- |
| HEAD | git项目当前所处分支 |
| config | 项目的配置信息, git config 命令会改动它 |
| description | 项目的描述信息 |
| hooks | 系统默认钩子脚本目录 |
| index | 索引文件 |
| logs | 各个 refs 的历史信息 |
| objects | git 本地仓库的所有对象(commits, trees, blobs, tags) |
| refs | 标识项目里的每个分支指向了哪个提交(commit) |

### 常用 git 命令

- 添加文件参考[git_add](./git_add.md)
- 防止文件误添加
  - 修改 .gitignore
  - 修改 .git/info/exclude
  - 格式规范参考[git_ignore](./git_ignore.md)
- 提交更新参考[git_commit](./git_commit.md)
- 跟踪状态参考[git_status](./git_status.md)
- 提交日志参考[git_log](./git_log.md)
- 移除文件参考[git_rm](./git_rm.md)
- 移动文件参考[git_mv](./git_mv.md)
- 远程仓库参考[git_remote](./git_remote.md)
- 推送数据参考[git_push](./git_push.md)
- 标签参考[git_tag](./git_tag.md)
- 分支参考[git_branch](./git_branch.md)
- 变基参考[git_rebase](./git_rebase.md)
- 版本比较参考[git_diff](./git_diff.md)
- 撤消操作
  - `git commit --amend`  # 尝试重新提交
  - `git reset HEAD f1`   # 取消暂存文件 f1
  - `git checkout -- f1`  # 撤消之前对文件 f1 所做的修改
  - 参考[git_reset](./git_reset.md)

## git 服务器

- 协议
  - 本地协议: 远程版本库就是硬盘内的另一个目录. 常见于团队每一个成员都对一个共享的文件系统(例如一个挂载的 NFS)拥有访问权, 或者比较少见的多人共用同一台电脑的情况
    - `git clone /opt/git/project.git`      # Git 会尝试使用硬链接（hard link）或直接复制所需要的文件
    - `git clone file:///opt/git/project.git`

## 参考网站

- [Git Magic](http://www-cs-students.stanford.edu/~blynn//gitmagic/)
- [git-scm](https://git-scm.com/book/en/v2)

## 好玩的网站

- [github blog](https://github.blog/)