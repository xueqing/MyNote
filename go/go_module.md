# go 模块

- [go 模块](#go-%e6%a8%a1%e5%9d%97)
  - [1 快速入门](#1-%e5%bf%ab%e9%80%9f%e5%85%a5%e9%97%a8)
    - [1.1 新建工程](#11-%e6%96%b0%e5%bb%ba%e5%b7%a5%e7%a8%8b)
    - [1.2 每日工作流](#12-%e6%af%8f%e6%97%a5%e5%b7%a5%e4%bd%9c%e6%b5%81)
  - [2 新概念](#2-%e6%96%b0%e6%a6%82%e5%bf%b5)
    - [2.1 module 模块](#21-module-%e6%a8%a1%e5%9d%97)
    - [2.2 go.mod](#22-gomod)
    - [2.3 版本选择](#23-%e7%89%88%e6%9c%ac%e9%80%89%e6%8b%a9)
    - [2.4 语义导入版本控制](#24-%e8%af%ad%e4%b9%89%e5%af%bc%e5%85%a5%e7%89%88%e6%9c%ac%e6%8e%a7%e5%88%b6)
  - [3 如何使用模块](#3-%e5%a6%82%e4%bd%95%e4%bd%bf%e7%94%a8%e6%a8%a1%e5%9d%97)
    - [3.1 如何安装和激活模块支持](#31-%e5%a6%82%e4%bd%95%e5%ae%89%e8%a3%85%e5%92%8c%e6%bf%80%e6%b4%bb%e6%a8%a1%e5%9d%97%e6%94%af%e6%8c%81)
    - [3.2 定义一个模块](#32-%e5%ae%9a%e4%b9%89%e4%b8%80%e4%b8%aa%e6%a8%a1%e5%9d%97)
    - [3.3 升级和降级依赖](#33-%e5%8d%87%e7%ba%a7%e5%92%8c%e9%99%8d%e7%ba%a7%e4%be%9d%e8%b5%96)
    - [3.4 准备发布模块](#34-%e5%87%86%e5%a4%87%e5%8f%91%e5%b8%83%e6%a8%a1%e5%9d%97)
      - [3.4.1 发行(release)所有版本模块](#341-%e5%8f%91%e8%a1%8crelease%e6%89%80%e6%9c%89%e7%89%88%e6%9c%ac%e6%a8%a1%e5%9d%97)
      - [3.4.2 发行 v2+ 版本模块](#342-%e5%8f%91%e8%a1%8c-v2-%e7%89%88%e6%9c%ac%e6%a8%a1%e5%9d%97)
      - [3.4.3 发布一个发行版本](#343-%e5%8f%91%e5%b8%83%e4%b8%80%e4%b8%aa%e5%8f%91%e8%a1%8c%e7%89%88%e6%9c%ac)
  - [4 迁移到模块](#4-%e8%bf%81%e7%a7%bb%e5%88%b0%e6%a8%a1%e5%9d%97)
    - [4.1 迁移总结](#41-%e8%bf%81%e7%a7%bb%e6%80%bb%e7%bb%93)
    - [4.2 迁移相关的话题](#42-%e8%bf%81%e7%a7%bb%e7%9b%b8%e5%85%b3%e7%9a%84%e8%af%9d%e9%a2%98)
      - [4.2.1 使用较早的依赖管理器自动迁移](#421-%e4%bd%bf%e7%94%a8%e8%be%83%e6%97%a9%e7%9a%84%e4%be%9d%e8%b5%96%e7%ae%a1%e7%90%86%e5%99%a8%e8%87%aa%e5%8a%a8%e8%bf%81%e7%a7%bb)
      - [4.2.2 提供依赖信息给旧版本的 Go 和非模块使用者](#422-%e6%8f%90%e4%be%9b%e4%be%9d%e8%b5%96%e4%bf%a1%e6%81%af%e7%bb%99%e6%97%a7%e7%89%88%e6%9c%ac%e7%9a%84-go-%e5%92%8c%e9%9d%9e%e6%a8%a1%e5%9d%97%e4%bd%bf%e7%94%a8%e8%80%85)
      - [4.2.3 更新预先已有的安装指导](#423-%e6%9b%b4%e6%96%b0%e9%a2%84%e5%85%88%e5%b7%b2%e6%9c%89%e7%9a%84%e5%ae%89%e8%a3%85%e6%8c%87%e5%af%bc)
      - [4.2.4 避免破坏已有的导入路径](#424-%e9%81%bf%e5%85%8d%e7%a0%b4%e5%9d%8f%e5%b7%b2%e6%9c%89%e7%9a%84%e5%af%bc%e5%85%a5%e8%b7%af%e5%be%84)
      - [4.2.5 当第一次采用模块且模块有 v2+ 的包时升级主版本号](#425-%e5%bd%93%e7%ac%ac%e4%b8%80%e6%ac%a1%e9%87%87%e7%94%a8%e6%a8%a1%e5%9d%97%e4%b8%94%e6%a8%a1%e5%9d%97%e6%9c%89-v2-%e7%9a%84%e5%8c%85%e6%97%b6%e5%8d%87%e7%ba%a7%e4%b8%bb%e7%89%88%e6%9c%ac%e5%8f%b7)
      - [4.2.6 v2+ 模块允许一次编译中有多个主版本号](#426-v2-%e6%a8%a1%e5%9d%97%e5%85%81%e8%ae%b8%e4%b8%80%e6%ac%a1%e7%bc%96%e8%af%91%e4%b8%ad%e6%9c%89%e5%a4%9a%e4%b8%aa%e4%b8%bb%e7%89%88%e6%9c%ac%e5%8f%b7)
      - [4.2.7 非模块代码使用模块](#427-%e9%9d%9e%e6%a8%a1%e5%9d%97%e4%bb%a3%e7%a0%81%e4%bd%bf%e7%94%a8%e6%a8%a1%e5%9d%97)
        - [4.2.7.1 非模块代码使用 v0/v1 模块](#4271-%e9%9d%9e%e6%a8%a1%e5%9d%97%e4%bb%a3%e7%a0%81%e4%bd%bf%e7%94%a8-v0v1-%e6%a8%a1%e5%9d%97)
        - [4.2.7.2 非模块代码使用 v2+ 模块](#4272-%e9%9d%9e%e6%a8%a1%e5%9d%97%e4%bb%a3%e7%a0%81%e4%bd%bf%e7%94%a8-v2-%e6%a8%a1%e5%9d%97)
      - [4.2.8 给预先已有的 v2+ 包作者使用的策略](#428-%e7%bb%99%e9%a2%84%e5%85%88%e5%b7%b2%e6%9c%89%e7%9a%84-v2-%e5%8c%85%e4%bd%9c%e8%80%85%e4%bd%bf%e7%94%a8%e7%9a%84%e7%ad%96%e7%95%a5)
        - [4.2.8.1 要求客户使用 1.9.7+/1.10.3/1.11+ 版本的 Go](#4281-%e8%a6%81%e6%b1%82%e5%ae%a2%e6%88%b7%e4%bd%bf%e7%94%a8-1971103111-%e7%89%88%e6%9c%ac%e7%9a%84-go)
        - [4.2.8.2 允许客户使用更旧版本的 Go，如 Go1.8](#4282-%e5%85%81%e8%ae%b8%e5%ae%a2%e6%88%b7%e4%bd%bf%e7%94%a8%e6%9b%b4%e6%97%a7%e7%89%88%e6%9c%ac%e7%9a%84-go%e5%a6%82-go18)
        - [4.2.8.3 等待选择模块](#4283-%e7%ad%89%e5%be%85%e9%80%89%e6%8b%a9%e6%a8%a1%e5%9d%97)
  - [5 其他资源](#5-%e5%85%b6%e4%bb%96%e8%b5%84%e6%ba%90)
  - [6 初始 Vgo 建议之后的改变](#6-%e5%88%9d%e5%a7%8b-vgo-%e5%bb%ba%e8%ae%ae%e4%b9%8b%e5%90%8e%e7%9a%84%e6%94%b9%e5%8f%98)
  - [7 Github issues](#7-github-issues)
  - [8 FAQs](#8-faqs)
    - [8.1 如何标记版本是不兼容的](#81-%e5%a6%82%e4%bd%95%e6%a0%87%e8%ae%b0%e7%89%88%e6%9c%ac%e6%98%af%e4%b8%8d%e5%85%bc%e5%ae%b9%e7%9a%84)
    - [8.2 何时是旧行为 vs 新的基于模块的行为](#82-%e4%bd%95%e6%97%b6%e6%98%af%e6%97%a7%e8%a1%8c%e4%b8%ba-vs-%e6%96%b0%e7%9a%84%e5%9f%ba%e4%ba%8e%e6%a8%a1%e5%9d%97%e7%9a%84%e8%a1%8c%e4%b8%ba)
    - [8.3 为什么通过 `go get` 安装一个工具报错 `cannot find main module`](#83-%e4%b8%ba%e4%bb%80%e4%b9%88%e9%80%9a%e8%bf%87-go-get-%e5%ae%89%e8%a3%85%e4%b8%80%e4%b8%aa%e5%b7%a5%e5%85%b7%e6%8a%a5%e9%94%99-cannot-find-main-module)
    - [8.4 如何为一个模块跟踪工具依赖](#84-%e5%a6%82%e4%bd%95%e4%b8%ba%e4%b8%80%e4%b8%aa%e6%a8%a1%e5%9d%97%e8%b7%9f%e8%b8%aa%e5%b7%a5%e5%85%b7%e4%be%9d%e8%b5%96)
    - [8.5 模块支持的状态在 IDE，编辑器和标准工具(比如 goimport，gorename等) 是什么样的](#85-%e6%a8%a1%e5%9d%97%e6%94%af%e6%8c%81%e7%9a%84%e7%8a%b6%e6%80%81%e5%9c%a8-ide%e7%bc%96%e8%be%91%e5%99%a8%e5%92%8c%e6%a0%87%e5%87%86%e5%b7%a5%e5%85%b7%e6%af%94%e5%a6%82-goimportgorename%e7%ad%89-%e6%98%af%e4%bb%80%e4%b9%88%e6%a0%b7%e7%9a%84)
  - [9 FAQs-其他控制](#9-faqs-%e5%85%b6%e4%bb%96%e6%8e%a7%e5%88%b6)
    - [9.1 在模块上工作时可用的社区工具](#91-%e5%9c%a8%e6%a8%a1%e5%9d%97%e4%b8%8a%e5%b7%a5%e4%bd%9c%e6%97%b6%e5%8f%af%e7%94%a8%e7%9a%84%e7%a4%be%e5%8c%ba%e5%b7%a5%e5%85%b7)
    - [9.2 什么时候使用 replace 指令](#92-%e4%bb%80%e4%b9%88%e6%97%b6%e5%80%99%e4%bd%bf%e7%94%a8-replace-%e6%8c%87%e4%bb%a4)
    - [9.3 能否完全在本地文件系统但在 VCS 之外工作](#93-%e8%83%bd%e5%90%a6%e5%ae%8c%e5%85%a8%e5%9c%a8%e6%9c%ac%e5%9c%b0%e6%96%87%e4%bb%b6%e7%b3%bb%e7%bb%9f%e4%bd%86%e5%9c%a8-vcs-%e4%b9%8b%e5%a4%96%e5%b7%a5%e4%bd%9c)
    - [9.4 模块如何使用 vendor？是否不再需要 vendor](#94-%e6%a8%a1%e5%9d%97%e5%a6%82%e4%bd%95%e4%bd%bf%e7%94%a8-vendor%e6%98%af%e5%90%a6%e4%b8%8d%e5%86%8d%e9%9c%80%e8%a6%81-vendor)
      - [9.4.1 模块下载和验证](#941-%e6%a8%a1%e5%9d%97%e4%b8%8b%e8%bd%bd%e5%92%8c%e9%aa%8c%e8%af%81)
      - [9.4.2 模块和目录](#942-%e6%a8%a1%e5%9d%97%e5%92%8c%e7%9b%ae%e5%bd%95)
    - [9.5 是否有 always on 的模块仓库和企业代理](#95-%e6%98%af%e5%90%a6%e6%9c%89-always-on-%e7%9a%84%e6%a8%a1%e5%9d%97%e4%bb%93%e5%ba%93%e5%92%8c%e4%bc%81%e4%b8%9a%e4%bb%a3%e7%90%86)
    - [9.6 能否控制何时更新 go.mod，go 工具何时使用网络满足依赖](#96-%e8%83%bd%e5%90%a6%e6%8e%a7%e5%88%b6%e4%bd%95%e6%97%b6%e6%9b%b4%e6%96%b0-gomodgo-%e5%b7%a5%e5%85%b7%e4%bd%95%e6%97%b6%e4%bd%bf%e7%94%a8%e7%bd%91%e7%bb%9c%e6%bb%a1%e8%b6%b3%e4%be%9d%e8%b5%96)
      - [9.6.1 GOFLAGS 环境变量](#961-goflags-%e7%8e%af%e5%a2%83%e5%8f%98%e9%87%8f)
      - [9.6.2 -mod=readonly 标识(如 `go build -mod=readonly`)](#962--modreadonly-%e6%a0%87%e8%af%86%e5%a6%82-go-build--modreadonly)
      - [9.6.3 go mod vendor 命令](#963-go-mod-vendor-%e5%91%bd%e4%bb%a4)
      - [9.6.4 -mod=vendor 标识(如 `go build -mod=vendor`)](#964--modvendor-%e6%a0%87%e8%af%86%e5%a6%82-go-build--modvendor)
      - [9.6.5 GO111MODULE=off 环境变量](#965-go111moduleoff-%e7%8e%af%e5%a2%83%e5%8f%98%e9%87%8f)
      - [9.6.6 GOPROXY=off 环境变量](#966-goproxyoff-%e7%8e%af%e5%a2%83%e5%8f%98%e9%87%8f)
      - [9.6.7 GOPROXY=file:///filesystem/path 环境变量](#967-goproxyfilefilesystempath-%e7%8e%af%e5%a2%83%e5%8f%98%e9%87%8f)
      - [9.6.8 开源的分布式模块仓库，如 Athens 工程](#968-%e5%bc%80%e6%ba%90%e7%9a%84%e5%88%86%e5%b8%83%e5%bc%8f%e6%a8%a1%e5%9d%97%e4%bb%93%e5%ba%93%e5%a6%82-athens-%e5%b7%a5%e7%a8%8b)
      - [9.6.9 go mod download 命令](#969-go-mod-download-%e5%91%bd%e4%bb%a4)
      - [9.6.10 go.mod 中的 replace 指令](#9610-gomod-%e4%b8%ad%e7%9a%84-replace-%e6%8c%87%e4%bb%a4)
    - [9.7 在 CI 系统(如 Travis 或 CircleCI) 中如何使用模块](#97-%e5%9c%a8-ci-%e7%b3%bb%e7%bb%9f%e5%a6%82-travis-%e6%88%96-circleci-%e4%b8%ad%e5%a6%82%e4%bd%95%e4%bd%bf%e7%94%a8%e6%a8%a1%e5%9d%97)
  - [10 FAQs-go.mod 和 go.sum](#10-faqs-gomod-%e5%92%8c-gosum)
  - [11 FAQs-语义导入版本控制](#11-faqs-%e8%af%ad%e4%b9%89%e5%af%bc%e5%85%a5%e7%89%88%e6%9c%ac%e6%8e%a7%e5%88%b6)
  - [12 FAQs-多模块仓库](#12-faqs-%e5%a4%9a%e6%a8%a1%e5%9d%97%e4%bb%93%e5%ba%93)
    - [12.1 什么是多模块仓库](#121-%e4%bb%80%e4%b9%88%e6%98%af%e5%a4%9a%e6%a8%a1%e5%9d%97%e4%bb%93%e5%ba%93)
    - [12.2 是否应该在一个仓库包含多个模块](#122-%e6%98%af%e5%90%a6%e5%ba%94%e8%af%a5%e5%9c%a8%e4%b8%80%e4%b8%aa%e4%bb%93%e5%ba%93%e5%8c%85%e5%90%ab%e5%a4%9a%e4%b8%aa%e6%a8%a1%e5%9d%97)
    - [12.3 能否给多模块仓库增加一个模块](#123-%e8%83%bd%e5%90%a6%e7%bb%99%e5%a4%9a%e6%a8%a1%e5%9d%97%e4%bb%93%e5%ba%93%e5%a2%9e%e5%8a%a0%e4%b8%80%e4%b8%aa%e6%a8%a1%e5%9d%97)
    - [12.4 能否从多模块仓库删除一个模块](#124-%e8%83%bd%e5%90%a6%e4%bb%8e%e5%a4%9a%e6%a8%a1%e5%9d%97%e4%bb%93%e5%ba%93%e5%88%a0%e9%99%a4%e4%b8%80%e4%b8%aa%e6%a8%a1%e5%9d%97)
    - [12.5 模块能否依赖另一个模块的 internal/](#125-%e6%a8%a1%e5%9d%97%e8%83%bd%e5%90%a6%e4%be%9d%e8%b5%96%e5%8f%a6%e4%b8%80%e4%b8%aa%e6%a8%a1%e5%9d%97%e7%9a%84-internal)
    - [12.6 能否增加一个 go.mod 文件排除不需要的内容？模块是否有等价的 .gitignore 文件](#126-%e8%83%bd%e5%90%a6%e5%a2%9e%e5%8a%a0%e4%b8%80%e4%b8%aa-gomod-%e6%96%87%e4%bb%b6%e6%8e%92%e9%99%a4%e4%b8%8d%e9%9c%80%e8%a6%81%e7%9a%84%e5%86%85%e5%ae%b9%e6%a8%a1%e5%9d%97%e6%98%af%e5%90%a6%e6%9c%89%e7%ad%89%e4%bb%b7%e7%9a%84-gitignore-%e6%96%87%e4%bb%b6)
  - [13 FAQs-最小版本选择](#13-faqs-%e6%9c%80%e5%b0%8f%e7%89%88%e6%9c%ac%e9%80%89%e6%8b%a9)
  - [14 FAQs-可能的问题](#14-faqs-%e5%8f%af%e8%83%bd%e7%9a%84%e9%97%ae%e9%a2%98)
  - [15 相关链接](#15-%e7%9b%b8%e5%85%b3%e9%93%be%e6%8e%a5)

## 1 快速入门

### 1.1 新建工程

```sh
# 1 在 GPOPATH 之外创建工程
$ mkdir -p /tmp/mygopro/repo
# 2 切换到工程目录
$ cd /tmp/mygopro/repo
# 3 初始化工程
$ git init
# 4 添加远程仓库路径
$ git remote add origin https://github.com/my/repo
# 5 初始化一个新模块, 会创建一个 go.mod 文件
$ go mod init github.com/my/repo
# 6 写 go 源码
$ cat <<EOF > hello.go
> package main
>
> import (
>     "fmt"
>     "rsc.io/quote"
> )
>
> func main() {
>     fmt.Println(quote.Hello())
> }
> EOF
# 7 编译和运行
$ go build -o hello
$ ./hello
```

### 1.2 每日工作流

- 添加 `import` 语句到 `.go` 代码
- 标准命令(`go build` 或 `go test`) 会自动增加新依赖的最高版本以满足导入(更新 `go.mod` 的 `require` 命令，并下载新的依赖)
- 需要时，可以使用命令(`go get foo@v1.2.3` 或 `go get foo@master` 或 `go get foo@commitid` 或 `go get foo@master`)或直接编辑 `go.mod` 选择依赖的具体版本
- 其他有用的命令
  - `go list -m all`: 查看编译会使用的所有的直接或间接依赖的最终版本
  - `go list -u -m all`: 查看可用的所有的直接或间接依赖的次级和补丁升级版本
  - `go list -u ./...` 或 `go list -u=patch ./...` (从模块根路径): 升级所有直接或间接依赖到最新的次级或补丁升级(忽视 pre-release)
  - `go build ./...` 或 `go test ./...` (从模块根路径):编译或测试模块内的所有包
  - `go mod tidy`: 从 `go.mod` 删除不再需要的依赖，增加新依赖
  - `replace` `gohack`: 使用依赖的一个 fork 或本地拷贝或精确版本
  - `go mod vendor`: 可选的步骤，创建一个 `vendor` 目录

## 2 新概念

### 2.1 module 模块

- 模块是相关的 Go 包的集合，它们作为一个单一的单元被打上版本号
- 模块记录精确的依赖需求，创建可再复制的构建
- 最常见的是，一个版本控制仓库包含确切的一个模块，在仓库的根目录定义。(可在一个仓库支持多模块，但是通常导致在持续进行的基础上比一个仓库一个模块工作更多)
- 仓库、模块和包的关系：
  - 一个仓库包含一个或多个 Go 模块
  - 每个模块包含一个或多个 Go 包
  - 每个包由一个单一的目录内的一个或多个 Go 源文件组成
- 模块必须根据 semver 打上版本号，通常是 `v(major).(minor).(patch)`，如 `v0.1.0`/`v1.2.3`/`v1.5.0-rc.1`

### 2.2 go.mod

- 有 4 个指令 `module/require/replace/exclude`
  - module: 声明模块身份，提供了模块路径。包的导入路径由模块路径和包目录与 `go.mod` 的相对路径决定
  - require:
  - replace: 只作用于当前(主)模块
  - exclude: 只作用于当前(主)模块

### 2.3 版本选择

- 源码增加新的导入语句，且在 `go.mod` 的 `require` 指令未覆盖时，大多数命令会自动查找合适的模块，增加最高版本到 `go.mod` 的 `require` 指令
- 编译时使用最小版本选择算法

### 2.4 语义导入版本控制

- 导入兼容性规则(import compatibility rule)：如果一个旧包和新包又相同的导入路径，那么新包必须向后兼容旧包
- semver 要求当向后不兼容时需要修改主版本号
- 语义导入版本控制(Semantic Import Versioning) 就是同时遵循导入兼容性规则和 semver的结果，即在导入路径添加主版本号——确保当主版本号因为兼容性破坏增加时导入路径也会改变
  - 遵循 semver
  - 对于 v0 或者 v1 版本，不要增加主版本号在模块路径或者导入路径
  - 如果模块版本是 v2+，模块路径和包导入路径必须增加 `/vN`
- 上面适用于已经使用模块或者导入其他模块。下面是未使用模块的三个过渡异常
  - gopkg.in
  - 当导入非模块的 v2+ 包时使用 `+incompatible`
  - 当未启用模块模式时使用最小模块兼容性(Minimal module compatibility)

## 3 如何使用模块

### 3.1 如何安装和激活模块支持

- 安装方法
  - [安装最新的 Go1.11 发行版](https://golang.org/dl/)
  - [用 master 分支源码安装 Go 工具链](https://golang.org/doc/install/source)
- 激活支持方法
  - 在 `$GOPATH/src` 之外调用 go 命令，且在当前目录或任意父目录存在有效的 `go.mod` 文件且环境变量 `GO111MODULE` 未设置(或显式设置成 `auto`)
  - 调用 go 命令设置 `GO111MODULE=on`

### 3.2 定义一个模块

- 为已有工程创建一个 `go.mod`

```sh
# 1 切换到模块源码树的根路径($GOPATH 之外，可以不设置 GO111MODULE 来激活模块模式)
$ cd <project path outside $GOPATH/src>
## 1.1 对于在 $GOPATH/src 目录之内的工程，需要手动激活
$ export GO111MODULE=on
$ cd $GOPATH/src/<project path>
# 2 创建初始模块定义，并从 dep 或其他依赖管理器转化依赖信息，增加 require 声明到 go.mod 以匹配现有配置
$ go mod init
## 2.1 可以指定模块路径(命令不能自动确定模块路径，或需要覆盖该路径)
$ go mod init github.com/my/repo
# 3 编译模块。在模块根路径执行，互编译当前模块的所有包。go build 会自动添加缺失或未转化的依赖
$ go build ./...
# 4 按照配置测试模块，确认对于选中的版本是正常的
$ go test ./...
# 5 可选。运行模块和所有直接或间接依赖的测试，检查兼容性
$ go test all
```

- **注意**：当依赖包含 v2+ 版本，或者正在初始化一个 v2+ 模块，需要在运行 `go mod init` 之后，编辑 `go.mod` 和 `.go` 代码，添加 `/vN` 到导入路径。参考 [Semantic Import Versioning](https://github.com/golang/go/wiki/Modules#semantic-import-versioning)
- **注意**：执行 `go build ./...` 或类似命令成功之后才可以允许 `go mod tidy`

### 3.3 升级和降级依赖

- 直接编辑 `go.mod` 文件
- `go get`: 对依赖升级或降级，此命令会自动更新 `go.mod`
- `go build`/`go test`/`go list`: 会自动增加新依赖以满足导入(更新 `go.mod` 的 `require` 命令，并下载新的依赖)
- `go list -u -m all`: 查看可用的所有的直接或间接依赖的次级和补丁升级版本
- 将当前模块的所有直接或间接依赖升级到最新版本，可在模块根目录执行下面的命令
  - `go get -u ./...`: 使用最新的次级或补丁发布(增加 `-t` 也会升级测试依赖)
  - `go get -u=patch ./...`: 使用最新的补丁发布(增加 `-t` 也会升级测试依赖)
- `go get foo`/`go get foo@latest`: 升级 `foo` 到最新版本
- `go get -u foo`/`go get -u foo@latest`: 升级 `foo` 及其直接或间接依赖到最新版本
- `go get foo@v1.6.2`/`go get foo@e3702bed2`/`go get foo@'<v1.6.2'`: 升级或降级到具体版本，可以添加版本后缀或 [module query](https://golang.org/cmd/go/#hdr-Module_queries)
  - module query 不能得到一个 [semver 标签](https://semver.org/)，会在 `go.mod` 记录一个[伪版本](https://tip.golang.org/cmd/go/#hdr-Pseudo_versions)
- `go get foo@master`: 使用分支名，获取分支的最新版本，不需要有 semver 标签
- 模块可以使用没有转成模块的包，包括记录可用的 semver 标签和使用这些标签升级或降级。模块也可以使用没有合适的 semver 标签的包，此时记录的是伪版本
- `go test all`: 升级或降级所有依赖后，可以为所有包运行测试以检查兼容性

### 3.4 准备发布模块

#### 3.4.1 发行(release)所有版本模块

1. 去掉多余依赖，增加依赖 `go mod tidy`。`go build` 和 `go test` 不会从 `go.mod` 删除不需要的依赖
2. 测试模块 `go test all`，包括测试直接或间接依赖，验证当前选择包版本的兼容性
3. 确保 `go.sum` 文件和 `go.mod` 文件一起提交了

#### 3.4.2 发行 v2+ 版本模块

- 将一个工程改成模块时，升级主版本号：使用的时候直接在导入路径添加新的主版本号更简单；也便于在旧版本上修改和完善
- 有两个可选机制发行 v2+ 版本的模块。当推送新的标签时，使用者可以知道新模块的发布。比如创建一个 `v3.0.0` 发行
  - 主分支：更新 `go.mod` 文件在 `module` 命令的模块路径末尾添加 `/v3`;更新模块内的 import 语句；给本次发行添加标签 `v3.0.0`
  - 主子目录：创建一个 `v3` 子目录；放一个新的 `go.mod` 文件在 `v3` 目录；更新模块内的 import 语句；给本次发行添加标签 `v3.0.0`
    - 这个可以提供更好的向后兼容性

#### 3.4.3 发布一个发行版本

- 通过推送一个标签到苍鹭发布新模块版本。标签包括两个字符串：前缀和版本号
  - 前缀指明模块在仓库内定义的位置：如果定义在仓库根目录，前缀为空。标签就是版本号
  - 在多模块仓库中，前缀区分不同模块的版本。前缀是仓库内定义模块的目录。如果仓库是主子目录形式，前缀不包含主版本号后缀
- 比如，有一个模块 `example.com/repo/sub/v2`，需要发布 `v2.1.6`，仓库主目录是 `example.com/repo`，模块在仓库内的 `sub/v2/go.mod` 定义，则模块的前缀是 `sub/`，这次发布完整的标签是 `sub/v2.1.6`

## 4 迁移到模块

### 4.1 迁移总结

- 设计模块系统是为了允许整个 Go 生态系统的不同包按不同比率选择性加入
- v2+ 版本的包在迁移时因为 [语义导入版本控制](#24-%e8%af%ad%e4%b9%89%e5%af%bc%e5%85%a5%e7%89%88%e6%9c%ac%e6%8e%a7%e5%88%b6)需要考虑更多
- 新包以及 v0/v1 的包在选择模块时考虑较少
- Go1.11 定义的模块可被旧版本的 Go 使用(但是 Go 版本依靠主模块及其依赖使用的策略)

### 4.2 迁移相关的话题

#### 4.2.1 使用较早的依赖管理器自动迁移

- `go mod init` 自动将需要的信息翻译到 `go.mod`
- 如果创建 v2+ 的模块，确保 `go.mod` 中的 `module` 指令增加了 `/vN`
- 如果导入 v2+ 的模块，可能需要手动调整 `go.mod` 中的 `require` 指令增加了 `/vN`
- `go mod init` 不会修改源码文件的导入声明

#### 4.2.2 提供依赖信息给旧版本的 Go 和非模块使用者

- 使用 `vendor` 目录
- 旧版本的 Go 以及禁用模块模式的 Go1.11/Go1.12+ 都可以使用 `go mod vendor` 生成的 `vendor` 目录

#### 4.2.3 更新预先已有的安装指导

- 先前的模块，通常使用 `go get -u` 安装。如果是发布模块，基于模块的使用者考虑使用 `go get`
  - `-u` 指示 go 工具升级模块的所有直接或间接依赖
  - 模块使用者之后可以选择使用 `go get -u`，但是一开始安装使用 `go get` 可以有更多好处。参考[高保真的构建](https://github.com/golang/proposal/blob/master/design/24301-versioned-go.md#update-timing--high-fidelity-builds)
  - `go get -u` 仍然有效，且对安装指令是有效选择
- `go get` 对于基于模块的使用者不是严格必须的
  - 简单的增加导入语句，后续的 `go build`/`go test` 会根据需求自动下载模块并更新 `go.mod`
- 基于模块的消费者默认不使用 `vendor` 目录

#### 4.2.4 避免破坏已有的导入路径

- 当模块导入路径和对应模块的声明路径不匹配时会报 `unexpected module path` 错误。破坏的情况包括
  - 模块导入路径发生变化：比如不再使用 `gopkg.in`
  - 改变路径大小写：导入路径和对应模块路径是大小写敏感的
  - 选择模块之后，修改模块路径

#### 4.2.5 当第一次采用模块且模块有 v2+ 的包时升级主版本号

- 如果有 v2+ 包，在第一此采用模块时，建议升级主版本号

#### 4.2.6 v2+ 模块允许一次编译中有多个主版本号

- 因为规则说明——“不同的导入路径包是不同的包”
- 此时，包级别状态会有多个拷贝，且每个主版本会运行自己的 `init` 函数

#### 4.2.7 非模块代码使用模块

##### 4.2.7.1 非模块代码使用 v0/v1 模块

##### 4.2.7.2 非模块代码使用 v2+ 模块

#### 4.2.8 给预先已有的 v2+ 包作者使用的策略

##### 4.2.8.1 要求客户使用 1.9.7+/1.10.3/1.11+ 版本的 Go

##### 4.2.8.2 允许客户使用更旧版本的 Go，如 Go1.8

##### 4.2.8.3 等待选择模块

## 5 其他资源

## 6 初始 Vgo 建议之后的改变

## 7 Github issues

## 8 FAQs

### 8.1 如何标记版本是不兼容的

### 8.2 何时是旧行为 vs 新的基于模块的行为

- 模块在 Go1.11 开始，因此按照设计旧行为会默认保留
- 什么时候是旧的 1.10 状态行为(查找 `vendor` 目录和 GOPATH 来寻找依赖)，什么时候是新的基于模块的行为
  - 在 `GOPATH` 之内: 默认是旧的 1.10 行为，会忽视模块
  - 在 `GOPATH` 之外且在文件树之内有一个 `go.mod` 文件: 默认是模块行为
  - `GO111MODULE` 环境变量
    - 不设置或 `auto`: 上述默认行为
    - `on`: 强制支持模块，与目录位置无关
    - `off`: 强制不支持模块，与目录位置无关

### 8.3 为什么通过 `go get` 安装一个工具报错 `cannot find main module`

- 因为设置了 `GO111MODULE=on`，但是所在文件树没有 `go.mod`
- 主要原因是 `go.mod` 记录了依赖信息，但是设置了 `GO111MODULE=on`，而 `go get` 不能获取依赖信息
- 方法
  - 最简单的方法设置 `GO111MODULE=auto`，或者不设置
  - 临时使用 Go1.10 行为 `GO111MODULE=off go get`
  - 创建一个临时的 `go.mod` 文件然后丢弃，这样可以避免报错 `cannot use path@version syntax in GOPATH mode`
  - 使用 [`gobin`](https://github.com/myitcv/gobin#usage)：`gobin` 默认会安装/运行主包而不用先手动创建一个模块。也可以使用 `-m` 使用现有的模块解决依赖(由环境变量 GOMOD 指定)
  - 为全局安装的工具创建 `go.mod`，比如 `~/global-tools/go.mod`，然后切换到那个目录，再运行 `go get`/`go install` 安装全局工具
  - 为每个工具在单独的目录创建 `go.mod`，比如 `~/tools/gorename/go.mod`/`~/tools/goimports/go.mod`，然后切换到合适的目录，再运行 `go get`/`go install` 安装工具

### 8.4 如何为一个模块跟踪工具依赖

- 如果：
  - 在模块中想要是有一个基于 go 的工具(比如 `stringer`)
  - 想要在自己模块的 `go.mod` 中跟踪工具的版本，并确保每个人使用相同版本的工具
- 建议在模块添加一个 `tools.go` 文件，添加感兴趣的工具的导入语句(比如 `import _ "golang.org/x/tools/cmd/stringer"`)，并增加 `// +build tools` 编译限制。[例子参考](https://github.com/go-modules-by-example/index/blob/master/010_tools/README.md)
  - 导入语句允许 go 命令精确记录工具的版本信息到 `go.mod`
  - 编译限制阻止正常的编译导入工具

### 8.5 模块支持的状态在 IDE，编辑器和标准工具(比如 goimport，gorename等) 是什么样的

## 9 FAQs-其他控制

### 9.1 在模块上工作时可用的社区工具

- [github.com/rogpeppe/gohack](https://github.com/rogpeppe/gohack)
- [github.com/marwan-at-work/mod](https://github.com/marwan-at-work/mod)
- [github.com/akyoto/mgit](https://github.com/akyoto/mgit)
- [github.com/goware/modvendor](https://github.com/goware/modvendor)
- [github.com/psampaz/go-mod-outdated](https://github.com/psampaz/go-mod-outdated)

### 9.2 什么时候使用 replace 指令

- `replace` 允许提供另外一个导入路径，控制实际使用的依赖，而不用更新源码中的导入路径
- `replace` 允许顶层模块控制依赖的实际版本：`replace example.com/some/dependency => example.com/some/dependency v1.2.3`
- `replace` 允许使用一个 fork 依赖：`replace example.com/original/import/path => /your/forked/import/path`，当需要修改一些依赖时，可以有一个本地 fork，并修改顶层模块的 `go.mod`
- `replace` 可用于多模块项目中，告诉 go 工具一个模块在磁盘上的的相对和绝对路径：`replace example.com/project/foo => ../foo`

### 9.3 能否完全在本地文件系统但在 VCS 之外工作

- 可以。VCS 不需要。如果再 VCS 之外，可以在 `require` 指令中使用版本号 `v0.0.0`
  - Go1.11 中必须手动在 `require` 指令中增加版本号 `v0.0.0`，Go1.12 之后不再需要手动添加

### 9.4 模块如何使用 vendor？是否不再需要 vendor

- `vgo` 的初始系统建议完全丢掉 vendor。但是社区返回导致保留对 vendor 的支持
- 简单来说，模块使用 vendor
  - `go mod vendor`： 重置主模块的 `vendor` 目录一包含编译和测试主模块所有包所需的包(根据 `go.mod` 状态和 Go 源码)。目录不包含 vendored 包的测试代码
  - 默认的，`go build` 等 go 命令在模块模式时会忽视 `vendor` 目录
  - `-mod=vendor` 标识指示 go 命令使用主模块顶层的 vendor 目录来满足依赖
  - `GOFLAGS=-mod=vendor` 可以设置使用 vendor 目录
- 当模块模式禁用时，旧版本的 Go 可以使用 vendor 目录。因此，vendor 是使得模块提供依赖给旧版本 Go 的模块使用

#### 9.4.1 模块下载和验证

- 根据 `GOPROXY`，go 命令可以从一个代理或直连到源码控制服务拉取代码
- `GOPROXY` 默认设置是 `https://proxy.golang.org,direct`，即尝试 Google 运行的 Go 模块代理，如果代理报告没有模块(HTTP 错误码 404 或 410)，会尝试直连
- `GOPROXY` 为 `off` 时，不允许从任何源码下载模块。否则，`GOPROXY` 是逗号分隔的模块代理的 URL，go 命令会从这些代理拉取模块
  - 对于每个请求，go 命令按顺序尝试代理，当代理返回 404 或 410 HTTP 状态码时，会继续尝试下个代理
  - **`direct` 之后的代理都不会尝试**
- `GOPRIVATE` 和 `GONOPPROXY` 允许对指定的模块绕过代理
- 对于所有的模块，go 命令会根据已知的 checksum 检查下载，检测未预料的变化。检查先查询当前模块的 `go.sum` 文件，失败时检查 Go 的checksum 数据库，后者由 `GOSUMDB` 和 `GONOSUMDB` 控制

#### 9.4.2 模块和目录

- **使用模块时，go 命令会完全忽视 `vendor` 目录**
- 默认的，go 命令通过从源码下载模块和使用这些下载的备份(在验证之后)
- 为了和旧版本的 Go 交互，或者保证编译使用的所有文件被存储在一个单独的目录树，`go mod vendor` 在当前主模块的根目录创建一个 `vendor` 目录，用于存储编译和测试主模块所需的依赖模块的所有包
- `go build -mod=vendor`: 使用模块的顶层的 `vendor` 目录来编译以满足依赖(不使用通常的网络源码和本地缓存)。**注意**只有主模块的顶层 `vendor` 目录会使用，其他位置的 `vendor` 目录仍然忽略

### 9.5 是否有 always on 的模块仓库和企业代理

- [proxy.golang.org](https://proxy.golang.org/)
- [gocenter.io](https://gocenter.io/)
- [mirrors.aliyun.com/goproxy](https://mirrors.aliyun.com/goproxy)
- [goproxy.cn](https://goproxy.cn/)
- [goproxy.io](https://goproxy.io/)
- [Athens](https://github.com/gomods/athens)
- [athens.azurefd.net](https://athens.azurefd.net/)
- [Goproxy](https://github.com/goproxy/goproxy)
- [THUMBAI](https://thumbai.app/)

### 9.6 能否控制何时更新 go.mod，go 工具何时使用网络满足依赖

- 默认的，类似于 `go build` 目录会忽视 `vendor` 目录，在需要的时候访问网络满足导入
- go 工具提供了一些参数来支持一些行为 `-mod=readonly`/`-mod=vendor`/`GOFLAGS`/`GOPROXY=off`/`GOPROXY=file:///filesystem/path`/`go mod vendor`/`go mod download`

#### 9.6.1 GOFLAGS 环境变量

- 允许设置特殊 go 命令的默认标识
- 对于 CI 和测试工作流有用，可用于定义每天开发的默认标识或行为，比如设置 `GOFLAGS=-mod=vendor`

#### 9.6.2 -mod=readonly 标识(如 `go build -mod=readonly`)

- 禁止大多数 go 命令(除了`go get`/`go mod`)修改 `go.mod`，导致想要隐式更新 `go.mod` 的命令失败
- 用于检查 `go.mod` 不需要更新，比如集成或测试时

#### 9.6.3 go mod vendor 命令

- 重置主模块的 `vendor` 目录一包含编译和测试主模块所有包所需的包(根据 `go.mod` 状态和 Go 源码)
- 不同团队对于 vendor 的哲学观点不同。vendor 可用于记录依赖到源码的版本控制，同事在外部源码出问题(宕机、消失或移动)时提供弹性
- 可为使用旧版本 Go 的用户提供相同的依赖
- 支持 CI 过程旧版本 Go(比如 Go1.9/Go1.10) 的测试

#### 9.6.4 -mod=vendor 标识(如 `go build -mod=vendor`)

- 默认的，`go build` 等 go 命令在模块模式时会忽视 `vendor` 目录
- `-mod=vendor` 标识指示 go 命令使用主模块顶层的 `vendor` 目录来满足依赖(j禁用网络资源和本地缓存)
- 想要一直使用设置 `GOFLAGS=-mod=vendor`

#### 9.6.5 GO111MODULE=off 环境变量

- go 命令不会支持新的模块。而是查找 `vendor` 目录和 GOPATH 来寻找依赖(遵循 pre-1.11 行为)

#### 9.6.6 GOPROXY=off 环境变量

- 模块模式的 go 命令不允许使用网络依赖

#### 9.6.7 GOPROXY=file:///filesystem/path 环境变量

- go 命令会使用文件系统(本地或远程)解决依赖，不再有实际运行的代理进程
- go 命令存储下载的依赖在本地缓存(`$GOPATH/pkg/mod`)，而且缓存格式和代理的需求相同，因此缓存可当做内容被基于文件系统的 GOPROXY 或简单的用作 GOPROXY 的 web 服务使用
- `go mod download` 定位到 `$GOPATH/pkg/mod/cache/download`，意味着这个命令可用于预先定位或更新 GOPROXY 的内容

#### 9.6.8 开源的分布式模块仓库，如 Athens 工程

- 一个目标是提供 “always on” 的模块仓库
- 一个不同的目标是单独的代理服务器，可被一个组织部署和控制可用的模块

#### 9.6.9 go mod download 命令

- 大多数每日工作不需要这个命令(因为通常 go命令会自动下载需要的模块)
- 主要用于在一些 CI 中，用于 docker 编译的缓存预热(pre-warming caches)
- 也可能被代理事宜作为缓存缺失时获取模块的一种方式

#### 9.6.10 go.mod 中的 replace 指令

- 可以控制顶层的 `go.mod` 以满足 Go 源码或 go.mod 文件实际使用的依赖
- 一个用例：如果需要修改一个依赖的内容，可以有本地 fork，在顶层的 `go.mod` 使用 `replace example.com/original/import/path => your/forked/import/path`，而不用更新代码中的导入路径。`replace` 指令允许提供另外一个导入路径(可能在 VCS 的另外一个模块，或者在本地文件系统)
- `replace` 也允许顶层模块实际使用依赖的具体版本，如 `replace example.com/some/dependency => example.com/some/dependency@v1.2.3`

### 9.7 在 CI 系统(如 Travis 或 CircleCI) 中如何使用模块

- 最简单的方法就是设置 `GO111MODULE=off`，大部分 CI 系统都可以使用
- 对于 Go1.11 的 CI，无论模块启用还是禁用，假设用户还没有适用模块，可以考虑使用 vendor
- 参考
  - [Using Go modules with vendor support on Travis CI](https://arslan.io/2018/08/26/using-go-modules-with-vendor-support-on-travis-ci/) by Fatih Arslan
  - [Go Modules and CircleCI](https://medium.com/@toddkeech/go-modules-and-circleci-c0d6fac0b000) by Todd Keech

## 10 FAQs-go.mod 和 go.sum

## 11 FAQs-语义导入版本控制

## 12 FAQs-多模块仓库

### 12.1 什么是多模块仓库

- 多模块仓库是指一个仓库包含多个模块，每个模块有自己的 `go.mod` 文件
- 每个模块起始于包含它自己的 `go.mod` 的目录，并且包含此目录及其子目录下的所有包，不包含包含另外的 `go.mod` 文件的子树
- 每个模块有自己的版本信息。位于仓库跟木库下的模块的版本标签必须包含相关目录作为前缀
  - 有一个文件 `my-repo/foo/rop/go.mod`，那么模块 `my-repo/foo/rop` 的 1.2.3 版本的标签是 `foo/rop/v1.2.3`
- 一个顶层模块的路径时另外一个模块路径的前缀

### 12.2 是否应该在一个仓库包含多个模块

- 相比一个仓库包含多个模块，一个仓库一个模块在增加模块、删除模块、给模块打版本号方面更简单
  - 在仓库根路径执行 `go test ./...` 不会再测试仓库所有代码
  - 需要用 `replace` 指令管理模块之间的关系
- 一个仓库包含多个模块的应用场景
  - 有一个用法例子，且例子有复杂的依赖关系。这种情况可以创建一个 `examples`/`_examples` 目录包含自己的 `go.mod`
  - 某个仓库有复杂的依赖集合，但是有一个客户端 API 只有少数依赖。在某些场景下，创建一个 `api`/`clientapi` 或类似的目录持有自己的 `go.mod`，或者将 `clientapi` 单独分出一个仓库比较好
- 上述两种场景，如果只是为了一个大量间接依赖的性能或者下载大小，建议首先尝试 `GOPOROXY`

### 12.3 能否给多模块仓库增加一个模块

- 可以。但是有两类问题
  - 新增模块的包不在版本控制中。需要做的事情包括：增加包和 `go.mod` 在同一提交，给提交打标签，推送标签
  - 增加的模块在版本控制，并且包含已有的一个或多个包。这种情况需要

### 12.4 能否从多模块仓库删除一个模块

- 可以。问题同上

### 12.5 模块能否依赖另一个模块的 internal/

- 可以。因为路径前缀是共享的

### 12.6 能否增加一个 go.mod 文件排除不需要的内容？模块是否有等价的 .gitignore 文件

- 一个目录中空的 `go.mod` 文件会导致该目录及其子目录不被顶层的 Go 模块包含
- 如果不想包含的目录不包含任何 `.go` 文件，只需要放一个空的 `go.mod` 文件

## 13 FAQs-最小版本选择

## 14 FAQs-可能的问题

## 15 相关链接

- [Go module wiki](https://github.com/golang/go/wiki/Modules)
- [Modules and vendoring](https://tip.golang.org/cmd/go/#hdr-Modules_and_vendoring)
- [List of go module knobs for controlling CI, vendoring, and when go commands access the network](https://github.com/thepudds/go-module-knobs/blob/master/README.md)
