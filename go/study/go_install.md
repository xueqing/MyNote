# 安装 go

- [安装 go](#%e5%ae%89%e8%a3%85-go)
  - [Linux 安装和使用 go](#linux-%e5%ae%89%e8%a3%85%e5%92%8c%e4%bd%bf%e7%94%a8-go)
    - [安装](#%e5%ae%89%e8%a3%85)
    - [设置工作目录 GOPATH](#%e8%ae%be%e7%bd%ae%e5%b7%a5%e4%bd%9c%e7%9b%ae%e5%bd%95-gopath)
    - [测试安装](#%e6%b5%8b%e8%af%95%e5%ae%89%e8%a3%85)
    - [安装其他版本](#%e5%ae%89%e8%a3%85%e5%85%b6%e4%bb%96%e7%89%88%e6%9c%ac)
  - [Windows 安装和使用 go](#windows-%e5%ae%89%e8%a3%85%e5%92%8c%e4%bd%bf%e7%94%a8-go)
  - [MacOS 安装和使用 go](#macos-%e5%ae%89%e8%a3%85%e5%92%8c%e4%bd%bf%e7%94%a8-go)
  - [卸载旧版本](#%e5%8d%b8%e8%bd%bd%e6%97%a7%e7%89%88%e6%9c%ac)
  - [命令](#%e5%91%bd%e4%bb%a4)
  - [vscode 使用 go](#vscode-%e4%bd%bf%e7%94%a8-go)
  - [配置代理](#%e9%85%8d%e7%bd%ae%e4%bb%a3%e7%90%86)

## Linux 安装和使用 go

### 安装

- 下载[安装包](https://golang.org/dl/)
  - 选择最新的 [Linux 版本](https://dl.google.com/go/go1.11.2.linux-amd64.tar.gz)
  - 下载`wget https://dl.google.com/go/go1.11.2.linux-amd64.tar.gz`
- [安装](https://golang.org/doc/install)
  - 解压：`tar -C /usr/local -zxf go1.11.2.linux-amd64.tar.gz`
- 配置环境变量
  - 修改`/etc/profile`或`~/.profile`
    - 追加`export PATH=$PATH:/usr/local/go/bin`
    - 执行`source`命令更新配置文件立即生效

### 设置工作目录 GOPATH

- 工作目录下面有三个文件夹
  - src：存放源码的目录，新建项目都在该目录下
  - pkg：编译生成的包文件存放目录
  - bin：编译生成的可执行文件和 go 相关的工具
- 默认工作目录是 `$HOME/go`
- 如果需要自定义工作目录：
  - **建议：**不要和 go 的安装目录相同
  - 修改 `~/.bashrc`，添加 `export GOPATH=$HOME/go`
  - 执行 `source ~/.bashrc` 使脚本生效
  - 修改`/etc/profile`或`~/.profile`，添加 `export GOROOT=$HOME/go`，将 `$HOME/go/bin` 加入系统环境变量 `PATH`
  - 执行`source`命令更新配置文件立即生效
  
### 测试安装

- 创建并进入默认工作目录 `~/go`
- 创建并进入目录 `src/hello`
- 创建文件 `hello.go`

  ```go
  package main

  import "fmt"

  func main() {
    fmt.Printf("Hello, world\n")
  }
  ```

- 编译：`go build`，生成可执行文件 `hello`
- 运行：`./hello`
- 安装二进制文件到工作目录的 `bin` 目录：`go install`
- 删除工作目录的二进制文件：`go clean -i`

### 安装其他版本

- 安装版本 1.10.7
  - `go get golang.org/dl/go1.10.7`
  - `go1.10.7 download`
- 使用版本 1.10.7
  - `go1.10.7 version`

## Windows 安装和使用 go

- 下载 Windows [安装包](https://golang.org/dl/) msi 文件
- 安装到 `c:\Go` 目录
- 将 `c:\Go\bin` 加入系统环境变量 `PATH`
- 测试安装
  - 创建 go 的工作目录，比如 `g:\gopro`
  - 设置工作目录路径：在用户变量中加入 `GOPATH`
  - 将 `g:\gopro\bin` 加入系统环境变量 `PATH`
  - 创建 `g:\gopro\src\hello` 目录，创建 `hello.go` 文件
  - 打开 Windows 终端，切换到 `g:\gopro\src\hello` 目录
    - 编译：`go build`，生成可执行文件 `hello.exe`
    - 运行：`hello`
    - 安装二进制文件到工作目录的 `bin` 目录：`go install`
    - 删除工作目录的二进制文件：`go clean -i`

## MacOS 安装和使用 go

- 执行 `brew install go`
- 配置环境变量
  - 修改 `~/.profile`
    - 追加`export GOROOT=/usr/local/go`
    - 追加`export PATH=$PATH:$GOROOT/bin`
    - 执行`source ~/.profile`命令更新配置文件立即生效
- 验证配置：执行 `go version`
- 写测试程序
  - 写 `hello.go`

    ```go
    package main

    import "fmt"

    func main() {
      fmt.println("Hello World!")
    }
    ```

  - 执行 `go run hello.go`

## 卸载旧版本

- 删除 go 目录
  - Linux/MacOS/FreeBSD `/usr/local/go`
  - Windows `c:\go`
- 从环境变量 `PATH` 中删除 go 的 bin 目录
  - Linux/FreeBSD 编辑 `/etc/profile` 或 `~/.profile`
  - MacOS 删除 `/etc/paths.d/go`

## 命令

- 查看 golang 环境变量 `go env`

## vscode 使用 go

- 安装插件 `Go`
- 配置 vscode
  - 选择 `File` -> `Preferences` -> `Settings`，搜索 go
    - "Go: Build On Save": "workspace"
    - "Go: Gopath": "/home/kiki/go"
      - Linux 配置: "/home/kiki/go"
      - Windows 配置: "G:\\gopro"
    - "Go: Goroot"
      - Linux 配置: "/usr/local/go"
      - Windows 配置："C:\\Go"
- 打开 go 的工作目录，第一次打开 go 后缀结尾的文件时，会提示安装 gopkgs，选择 `Install All`，等待安装结束
- vscode 自动安装失败，执行手动安装
  - 1 在 `%GOPATH%/src/golang.org/x` 目录下，执行 `git clone git@github.com:golang/tools.git`
  - 2 进入 `%GOPATH%/src/golang.org/x/tools/cmd/gorename` 目录，执行 `go install`
  - 3 进入 `%GOPATH%/src/golang.org/x/tools/cmd/guru` 目录，执行 `go install`
  - 4 重启 vscode，打开 go 后缀结尾的文件，点击 `Analysis Tools Missing`，继续之前安装失败的 go 包
- 安装过程中，有的包可能会安装失败
  - 1 使用 tools 下载
    - 进入 `%GOPATH%/src/golang.org/x` 目录，使用命令 `git clone https://github.com/golang/tools.git` 下载插件依赖工具的源码，所需工具源码就都保存在 tools 目录中
    - 进入 `%GOPATH%` 目录，根据之前的安装失败提示信息安装对应的依赖工具：比如 `go install github.com/mdempsky/gocode`
  - 2 使用 lint 下载
    - `go install golang.org/x/lint/golint` 报错

      ```sh
      can't load package: package golang.org/x/lint/golint: cannot find package "golang.org/x/lint/golint" in any of:
      /usr/local/go/src/golang.org/x/lint/golint (from $GOROOT)
      /home/kiki/go/src/golang.org/x/lint/golint (from $GOPATH)
      ```
  
    - 因为 golint 的源码在 lint 下，而不是 tools，需要单独拉取 golint 源码
    - 进入 `%GOPATH%\src\golang.org\x` 目录，执行命令 `git clone https://github.com/golang/lint` 拉取 golint 源码
    - 进入 `%GOPATH%` 目录，通过 `go install` 安装 golint：`go install golang.org/x/lint/golint`
- 重启 vscode 后，插件就可以正常使用了

## 配置代理

- 执行 `go mod init` 生成默认 module 文件
- 配置环境变量 `export GOPROXY=https://goproxy.io`
- 重启 vscode，安装插件
  - `Ctrl+Shift+P`，输入 `go`
  - 选择 `Install/Update Tools`
  - 全选，安装。重启 vscode 即可
