# SVN

- [SVN](#svn)
  - [1 概念](#1-%E6%A6%82%E5%BF%B5)
  - [2 安装](#2-%E5%AE%89%E8%A3%85)
  - [3 生命周期](#3-%E7%94%9F%E5%91%BD%E5%91%A8%E6%9C%9F)
  - [4 其他命令](#4-%E5%85%B6%E4%BB%96%E5%91%BD%E4%BB%A4)
  - [5 分支](#5-%E5%88%86%E6%94%AF)
  - [6 标签](#6-%E6%A0%87%E7%AD%BE)

## 1 概念

- repository(源代码库): 源代码统一存放的地方
- Checkout(提取): 当没有源代码的时候，需要从 repository checkout 一份
- Commit(提交): 已经修改了代码，需要 Commit 到 repository
- Update(更新): 已经 Checkout 了一份源代码， Update 可以和 Repository 上的源代码同步，本地的代码就会有最新的变更
- SVN 管理源代码是以行为单位的，就是说两个程序员只要不是修改了同一行程序，SVN 都会自动合并两种修改。如果是同一行，SVN 会提示文件冲突，需要手动确认

## 2 安装

```sh
# 安装
sudo apt-get install subversion
# 查看版本
svn --version
```

## 3 生命周期

- 创建版本库：create
- 检出：checkout，用来从版本库创建一个工作副本
- 更新：update，用来更新版本库。这个操作将工作副本与版本库进行同步
- 执行变更：
  - rename 可以更改文件/目录名字
  - "移动"操作用来将文件/目录从一处移动到版本库中的另一处
- 复查变化：
  - status，列出了工作副本中所进行的变动
  - diff，显示特定修改的行级详细信息
    - 不带参数，比较工作文件与缓存在`.svn`的"原始"拷贝
    - 比较工作拷贝和版本库中版本号为 3 的文件 rule.txt：`svn diff -r 3 rule.txt`
    - 比较版本库与版本库, -r(revision) 传递两个通过冒号分开的版本号：`svn diff -r 2:3 rule.txt`
- 修复错误：revert，重置对工作副本的修改
  - 对目录操作使用 `svn revert -R`
  - 撤回版本，比如当前是版本 22，要撤回版本21，执行 `svn merge -r 22:21 readme`
- 解决冲突：resolve，用来帮助用户找出冲突并告诉版本库如何处理这些冲突
- 提交更改：commit，将更改从工作副本提交到版本库
  - add，添加到版本控制
  - commit 是一个原子操作,也就是说要么完全提交成功，要么失败回滚

## 4 其他命令

- info：查看版本信息
- log：展示svn 的版本作者、日期、路径等
  - 希望查看特定的某两个版本之间的信息：`svn log -r 6:8`
  - 查看某一个文件的版本修改信息：`svn log file_path`
  - 显示限定 N 条记录的目录信息：`svn log -l N -v`
- cat：取得在特定版本的某文件显示在当前屏幕
  - 显示在指定版本号下的指定文件内容：`svn cat -r revision_num file_name`
- list：显示一个目录或某一版本存在的文件
  - 可以在不下载文件到本地目录的情况下来察看目录中的文件：`svn list pro_url`

## 5 分支

- 分支是 trunk 版(主干线)的一个 copy 版本，分支具有版本控制功能，且和主干线相互独立
- 可以通过合并功能，将分支合并到 trunk，从而最后合并为一个项目
- 在本地副本创建一个分支 `svn copy trunk branches/branch_name`
- 查看状态 `svn status`
- 提交新增的分支到版本库 `svn commit -m "message"`
- 到新增分支进行开发
  - `cd branches/my_branch/`
  - `ls`
  - 修改查看状态 `svn status`
  - 添加到版本控制 `svn add ......`
  - 提交到版本库 `svn commit -m "message"`
- 切换到 trunk `cd ../trunk`
- 更新版本 `svn update`
- 合并分支到 truck `svn merge ../branches/branch_name/`
- 将合并好的 truck 提交到版本库 `svn commit -m "message"`

## 6 标签

- 标签主要用于项目开发中的里程碑，比如开发到一定阶段可以单独一个版本作为发布等，它往往代表一个可以固定的完整的版本
- 在本地工作副本创建一个 tag `svn copy trunk tags/v1.0`
- 查看新的目录
  - `ls tags/`
  - `ls tags/v1.0/`
- 查看状态 `svn status`
- 提交 tag 内容 `svn commit -m "tags v1.0"`