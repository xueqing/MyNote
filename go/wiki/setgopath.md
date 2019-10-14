# 设置 GOPATH

- [设置 GOPATH](#%e8%ae%be%e7%bd%ae-gopath)
  - [Unix 系统](#unix-%e7%b3%bb%e7%bb%9f)
    - [Go 1.13](#go-113)
    - [Bash](#bash)
    - [Zsh](#zsh)
    - [fish](#fish)
  - [Windows](#windows)
    - [Go 1.13 (命令行)](#go-113-%e5%91%bd%e4%bb%a4%e8%a1%8c)
    - [Windows 10 (图形用户界面)](#windows-10-%e5%9b%be%e5%bd%a2%e7%94%a8%e6%88%b7%e7%95%8c%e9%9d%a2)
    - [Windows 10 (命令行)](#windows-10-%e5%91%bd%e4%bb%a4%e8%a1%8c)

参考 [设置 GOPATH 维基](https://github.com/golang/go/wiki/SettingGOPATH) 学习。

原网页由 Bryan C. Mills 在 2019/9/27 编辑。[第 55 次修订](https://github.com/golang/go/wiki/SettingGOPATH/_history)。

`GOPATH` 环境变量指定你的工作区的位置。如果没有设置 `GOPATH`，则认为 Unix 系统上是 `$HOME/go` 且 Windows 上是 `%USERPROFILE%\go`。如果你想要使用自定义位置作为你的工作区，你可以设置 `GOPATH` 环境变量。此页解释如何在不同的平台上设置这个变量。

## Unix 系统

`GOPATH` 可以是你系统上的任一目录。在 Unix 系统上，我们将设置其为 `$HOME/go` (从 Go 1.8 其的默认值)。注意 `GOPATH` 一定不能和 Go 安装路径相同。另外一个常见的设置是设置 `GOPATH=$HOME`

### Go 1.13

`go env -w GOPATH=$HOME/go`

### Bash

编辑 `~/.bash_profile`，添加下面的行：

```sh
export GOPATH=$HOME/go
```

保存并退出编辑器。然后使 `~/.bash_profile` 修改生效：

```sh
source ~/.bash_profile
```

### Zsh

编辑 `~/.zshrc`，添加下面的行：

```sh
export GOPATH=$HOME/go
```

保存并退出编辑器。然后使 `~/.zshrc` 修改生效：

```sh
source ~/.zshrc
```

### fish

```sh
set -x -U GOPATH $HOME/go
```

`-x` 用于指定这个变量应被导出，且 `-U` 使其成为一个全局变量，对所有会话可用且是持久的。

## Windows

你的工作区可位于任何你喜欢的地方，但是我们在这个例子中使用 `C:\go-work`。

**注意**：`GOPATH` 一定不能和 Go 安装路径相同。

- 在 `C:\go-work` 新建文件夹。
- 右击“开始”，并点击“控制面板”。选择“系统和安全”，然后点击“系统”。
- 从左边的菜单栏，选中“高级系统设置”。
- 点击底部的“环境变量”按钮。
- 从“用户变量”区域点击“新建”。
- 在“变量名”输入 `GOPATH`。
- 在“变量值”输入 `C:\go-work`。
- 点击“确定”。

### Go 1.13 (命令行)

- 打开一个命令提示符(`Win`+`r` 然后输入 `cmd`) 或者 powershell 窗口(`Win`+`i`)。
- 输入 `go env -w GOPATH=c:\go-work`。

### Windows 10 (图形用户界面)

有一个通过搜索编辑 `环境变量` 的快速方式：

- 左击“搜索”并输入 `env` 或 `environment`。
- 选择 `编辑账户的环境变量`。
- 和上述步骤相同。

### Windows 10 (命令行)

- 打开一个命令提示符(`Win`+`r` 然后输入 `cmd`) 或者 powershell 窗口(`Win`+`i`)。
- 输入 `setx GOPATH %USERPROFILE%\go`。(这将会设置 `GOPATH` 为你的 `[home folder]\go`，比如 `C:\Users\yourusername\go`。)
- 关闭命令提示符或 powershell 窗口。(环境变量只对新的命令提示符或 powershell 窗口生效，当前窗口不生效。)
