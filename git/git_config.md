# 配置

- [配置](#%E9%85%8D%E7%BD%AE)
  - [修改配置信息](#%E4%BF%AE%E6%94%B9%E9%85%8D%E7%BD%AE%E4%BF%A1%E6%81%AF)
  - [查看配置信息](#%E6%9F%A5%E7%9C%8B%E9%85%8D%E7%BD%AE%E4%BF%A1%E6%81%AF)

## 修改配置信息

- /etc/gitconfig：包含系统上每一个用户及他们仓库的通用配置, 使用`--system`会从此文件读写配置变量

```sh
# 输出中文文件名显示问题
git config --system core.quotepath false
# 开启颜色显示
git config --system color.ui true
```

- ~/.gitconfig 或 ~/.config/git/config：只针对当前用户.  使用`--global`让 git 读写此文件

```sh
# 配置全局用户名
git config --global user.name kiki
# 配置全局 email
git config --global user.email kiki@bmi.com
# 配置默认文本编辑器(默认 vim)
git config --global core.editor emacs
```

- 为 git 命令设置别名，参考[git_alias](./git_alias.md)
- rep-dir/.git/config：当前使用仓库的 Git 目录中的 config 文件, 只针对该仓库

```sh
# 配置某个项目用户名
git config user.name xueqing
# 配置某个项目 email
git config user.email haijuanchen.sun@gmail.com
```

- 每一个级别覆盖上一级别的配置, 所以 .git/config 的配置变量会覆盖 /etc/gitconfig 中的配置变量

## 查看配置信息

```sh
# 列出所有 git 当时能找到的配置
git config --list
git config -l
# git config <key> 检查 Git 的某一项配置
# 查看用户名
git config user.name
```