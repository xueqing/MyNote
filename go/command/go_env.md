# go env

- [go env](#go-env)
  - [命令](#%e5%91%bd%e4%bb%a4)
  - [go env 命令可打印出的 Go 语言通用环境信息](#go-env-%e5%91%bd%e4%bb%a4%e5%8f%af%e6%89%93%e5%8d%b0%e5%87%ba%e7%9a%84-go-%e8%af%ad%e8%a8%80%e9%80%9a%e7%94%a8%e7%8e%af%e5%a2%83%e4%bf%a1%e6%81%af)
  - [go env 的参数](#go-env-%e7%9a%84%e5%8f%82%e6%95%b0)

## 命令

- `go env` 用于打印 Go 语言的环境信息：`go env GOARCH` 或 `go env GOARCH GOCHAR`
- `go env -w` 重写 Go 语言的环境信息：`go env -w GOPRIVATE="*.bmi"`

## go env 命令可打印出的 Go 语言通用环境信息

| 名称 | 描述 |
| CGO_ENABLED | 指明 cgo 工具是否可用的标识 |
| GOARCH | 程序构建环境的目标计算架构 |
| GOBIN | 存放可执行文件的目录的绝对路径 |
| GOCHAR | 程序构建环境的目标计算架构的单字符标识 |
| GOEXE | 可执行文件的后缀 |
| GOHOSTARCH | 程序运行环境的目标计算架构 |
| GOOS | 程序构建环境的目标操作系统 |
| GOHOSTOS | 程序运行环境的目标操作系统 |
| GOPATH | 工作区目录的绝对路径 |
| GORACE | 用于数据竞争检测的相关选项 |
| GOROOT | Go 语言的安装目录的绝对路径 |
| GOTOOLDIR | Go 工具目录的绝对路径 |

## go env 的参数

| 参数 | 描述 |
| --- | --- |
