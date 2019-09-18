# 安装 go

- [安装 go](#%e5%ae%89%e8%a3%85-go)
  - [Linux 安装和使用 go](#linux-%e5%ae%89%e8%a3%85%e5%92%8c%e4%bd%bf%e7%94%a8-go)
    - [安装](#%e5%ae%89%e8%a3%85)
    - [设置工作目录 GOPATH](#%e8%ae%be%e7%bd%ae%e5%b7%a5%e4%bd%9c%e7%9b%ae%e5%bd%95-gopath)
    - [测试安装](#%e6%b5%8b%e8%af%95%e5%ae%89%e8%a3%85)
    - [安装其他版本](#%e5%ae%89%e8%a3%85%e5%85%b6%e4%bb%96%e7%89%88%e6%9c%ac)
  - [MacOS 安装和使用 go](#macos-%e5%ae%89%e8%a3%85%e5%92%8c%e4%bd%bf%e7%94%a8-go)
  - [卸载旧版本](#%e5%8d%b8%e8%bd%bd%e6%97%a7%e7%89%88%e6%9c%ac)
  - [命令](#%e5%91%bd%e4%bb%a4)
  - [vscode 使用 go](#vscode-%e4%bd%bf%e7%94%a8-go)

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
  - 修改 `~/.bash_profile`，添加 `export GOPATH=$HOME/go`
  - 执行 `source ~/.bash_profile` 使脚本生效
  
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
    - "Go: Goroot": "/usr/local/go"
- 打开 go 的工作目录，第一次打开 go 后缀结尾的文件时，会提示安装 gopkgs，选择 `Install All`，等待安装结束
- 安装过程中，有的包可能会安装失败
- vscode 自动安装失败，执行手动安装
  - 1 在 `%GOPATH%/src/golang.org/x` 目录下，执行 `git clone git@github.com:golang/tools.git`
  - 2 进入 `%GOPATH%/src/golang.org/x/tools/cmd/gorename` 目录，执行 `go install`
  - 3 进入 `%GOPATH%/src/golang.org/x/tools/cmd/guru` 目录，执行 `go install`
  - 4 重启 vscode，打开 go 后缀结尾的文件，点击 `Analysis Tools Missing`，继续之前安装失败的 go 包
  - 根据提示到对应 github 网站下载 zip 包并解压，解压的文件放到 `%GOPATH%/src/github.com/xxx/xx` 目录
  - 执行 `go install github.com/mdempsky/gocode`
