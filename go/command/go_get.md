# go get

- [go get](#go-get)
  - [命令](#%e5%91%bd%e4%bb%a4)
  - [go get 命令支持的 VCS](#go-get-%e5%91%bd%e4%bb%a4%e6%94%af%e6%8c%81%e7%9a%84-vcs)
  - [go get 的参数](#go-get-%e7%9a%84%e5%8f%82%e6%95%b0)

## 命令

- `go get` 命令用来动态获取远程代码包，从代码版本控制系统的远程仓库中检出/更新代码包并对其进行编译和安装
- 在内部实际上分成了两步操作：第一步是下载源码包第一个工作区的 src 目录下，第二步是执行 `go install`
- 目前支持的有 BitBucket、GitHub、Google Code 和 Launchpad。下载源码包的 go 工具会自动根据不同的域名调用不同的源码工具，对应关系如下
  - BitBucket (Mercurial Git)
  - GitHub (Git)
  - Google Code Project Hosting (Git, Mercurial, Subversion)
  - Launchpad (Bazaar)
- 如 `go get github.com/hyper-carrot/go_lib/logging`
- `go get` 支持自定义域名的功能，具体参见 `go help remote`
- 除非要求强行更新代码包，否则 `go get` 命令不会进行重复下载

## go get 命令支持的 VCS

- 代码版本控制系统（Version Control System，VCS）
- 这几个版本控制系统都有一个共同点，那就是会在检出的项目目录中存放一个元数据目录，名称为 “.” 前缀加其主命令名

| 名称 | 主命令 | 说明 |
| --- | --- | --- |
| Mercurial | hg | Mercurial 是一种轻量级分布式版本控制系统，采用 Python 语言实现，易于学习和使用，扩展性强 |
| Git | git | Git 最开始是 Linux Torvalds 为了帮助管理 Linux 内核开发而开发的一个开源的分布式版本控制软件。但现在已被广泛使用。它是被用来进行有效、高速的各种规模项目的版本管理 |
| Subversion | svn | Subversion 是一个版本控制系统，也是第一个将分支概念和功能纳入到版本控制模型的系统。但相对于 Git 和 Mercurial 而言，它只算是传统版本控制系统的一员 |
| Bazaar | bzr | Bazaar 是一个开源的分布式版本控制系统。但相比而言，用它来作为 VCS 的项目并不多 |

## go get 的参数

- `go get` 命令可以接受所有可用于 `go build` 命令和 `go install` 命令的参数。这是因为 `go get` 命令的内部步骤中完全包含了编译和安装这两个动作
- `go get` 命令还有一些特有的参数

| 参数 | 描述 |
| --- | --- |
| -d | 只下载不安装 |
| -f | 只有在包含 -u 参数时才有效，不让 -u 去验证 import 中的每一个都已经获取了，这对于本地 fork 的包特别有用 |
| -fix | 在获取源码之后先运行 fix，而后再进行编译和安装 |
| -insecure | 允许使用非安全的 scheme（如HTTP）去下载指定的代码包。如果代码仓库（如公司内部的Gitlab）没有 HTTPS 支持，可以添加此标记。请在确定安全的情况下使用它 |
| -t | 下载并安装指定的代码包中的测试源码文件中依赖的代码包 |
| -u | 强制使用网络更新已有代码包及其依赖包。默认情况该命令只会从网络上下载本地不存在的代码包，而不会更新已有的代码包 |
| -v | 显示执行的命令 |
