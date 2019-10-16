# go 命令学习

参考 [Go 命令官网](https://golang.org/cmd/go/) 学习。

## 用法

Go 是一个用于管理 Go 源码的工具。

用法：`go <command> [arguments]`

命令有:

| 命令 | 描述 |
| --- | --- |
| [bug](bug.md) | 开启一个缺陷报告 |
| [build](build.md) | 编译包及其依赖 |
| [clean](clean.md) | 删除目标文件和缓存文件 |
| [doc](doc.md) | 查看包或者符号的文档 |
| [env](env.md) | 打印 Go 环境变量信息 |
| [fix](fix.md) | 更新包以使用新的 API |
| [fmt](fmt.md) | gofmt(reformat) 包的源文件 |
| [generate](generate.md) | 通过处理源生成 Go 文件 |
| [get](get.md) | 为当前模块添加依赖并且安装依赖 |
| [install](install.md) | 编译和安装包及其依赖 |
| [list](list.md) | 列举包或模块 |
| [mod](mod.md) | 模块维护 |
| [run](run.md) | 编译和运行 Go 程序 |
| [test](test_package.md) | 测试包 |
| tool | 运行指定的 go 工具 |
| version | 打印 Go 版本 |
| vet | 打印包中可能的错误 |

使用 `go help <command>` 查看命令的更多信息。

其他的帮助话题：

| 帮助 | 描述 |
| --- | --- |
| buildmode | 编译模式 |
| c | 在 Go 和 C 直接调用 |
| cache | 编译和测试缓存 |
| environment | 环境变量 |
| filetype | 文件类型 |
| go.mod | go.mod 文件 |
| gopath | GOPATH 环境变量 |
| gopath-get | 传统 GOPATH 的 go get |
| goproxy | 模块 proxy 协议 |
| importpath | 模块路径语法 |
| modules | 模块，模块版本等 |
| module-get | 明白模块的 go get |
| module-auth | 使用 go.sum 的模块认证 |
| module-private | 对于非公共模块的模块配置 |
| packages | 包列表和模式 |
| testflag | 测试标识 |
| testfunc | 测试函数 |

使用 `go help <topic>` 查看话题的更多信息。
