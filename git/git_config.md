# 配置

- [配置](#配置)
  - [修改配置信息](#修改配置信息)
  - [查看配置信息](#查看配置信息)
  - [编辑配置文件](#编辑配置文件)
  - [指定配置文件](#指定配置文件)
  - [实战：修改远程仓库的 url 的拉取协议](#实战修改远程仓库的-url-的拉取协议)
  - [实战：git status 中文转义致乱码](#实战git-status-中文转义致乱码)

## 修改配置信息

- `/etc/gitconfig`：包含系统上每个用户及其仓库的通用配置，使用 `--system` 会读写配置此文件的变量，是系统级别的

```sh
# 输出中文文件名显示问题
git config --system core.quotepath false
# 开启颜色显示
git config --system color.ui true
```

- `~/.gitconfig` 或 `~/.config/git/config`：针对当前用户，使用 `--global` 会读写此文件，是用户级别的

```sh
# 配置全局用户名
git config --global user.name kiki
# 配置全局 email
git config --global user.email kiki@bmi.com
# 配置默认文本编辑器(默认 vim)
git config --global core.editor emacs
```

- `rep-dir/.git/config`：针对当前仓库的 Git 目录中的 config 文件，可添加 `--local`，是仓库级别的

```sh
# 配置某个项目用户名
git config user.name xueqing
# 配置某个项目 email
git config user.email haijuanchen.sun@gmail.com
```

- 配置文件优先级是`仓库>用户>系统`，默认是仓库级别(即 `--local`)，所以 `.git/config` 的配置会覆盖 `/etc/gitconfig` 中的配置

## 查看配置信息

```sh
# 列出所有 git 当时能找到的配置：依次是系统级、用户级、仓库级
git config --list
git config -l
## 查看系统配置
git config --system -l
## 查看用户配置
git config --global -l
## 查看仓库配置
git config --local -l
# git config [--get] <key> 检查某一配置：依据 system/global/local 顺序读取，最后的值覆盖前面的，多值则合并
## 比如查看用户名
git config user.name
```

## 编辑配置文件

```sh
# git config -e 编辑配置文件
## 编辑系统配置文件
git config --system -e
## 编辑用户配置文件
git config --global -e
## 编辑仓库配置文件
git config --local -e
# git config <key> 检查 Git 的某一项配置
# 查看用户名
git config user.name
```

## 指定配置文件

```sh
# git config --file 显示指定编辑的配置文件
```

## 实战：修改远程仓库的 url 的拉取协议

默认配置 ssh 公钥访问私有仓库，需要配置 git 拉取私有仓库时使用 ssh 而不是 https。

```sh
# 方法 1：使用 git 命令配置
git config --global url."git@gitlab.bmi:".insteadOf "https://gitlab.bmi/"
## 或者
git config --global url."ssh://git@gitlab.bmi/".insteadOf "https://gitlab.bmi/"
# 方法 2：修改 git 配置文件
vim ~/.gitconfig
## 加入下面的内容
[url "git@gitlab.bmi:"]
  insteadOf = https://gitlab.bmi/
## 或
[url "ssh://git@gitlab.bmi/"]
  insteadOf = https://gitlab.bmi/
```

## 实战：git status 中文转义致乱码

```sh
# core.quotepath 设为 false，就不会对 0x80 以上的字符进行 quote。中文显示正常
git config --global core.quotepath false
```
