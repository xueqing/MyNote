# go 模块

- [go 模块](#go-%e6%a8%a1%e5%9d%97)
  - [快速入门](#%e5%bf%ab%e9%80%9f%e5%85%a5%e9%97%a8)
    - [新建工程](#%e6%96%b0%e5%bb%ba%e5%b7%a5%e7%a8%8b)
    - [每日工作流](#%e6%af%8f%e6%97%a5%e5%b7%a5%e4%bd%9c%e6%b5%81)
  - [新概念](#%e6%96%b0%e6%a6%82%e5%bf%b5)
    - [module 模块](#module-%e6%a8%a1%e5%9d%97)
    - [go.mod](#gomod)
    - [版本选择](#%e7%89%88%e6%9c%ac%e9%80%89%e6%8b%a9)
    - [语义导入版本控制](#%e8%af%ad%e4%b9%89%e5%af%bc%e5%85%a5%e7%89%88%e6%9c%ac%e6%8e%a7%e5%88%b6)
  - [升级和降级依赖](#%e5%8d%87%e7%ba%a7%e5%92%8c%e9%99%8d%e7%ba%a7%e4%be%9d%e8%b5%96)
  - [定义一个模块](#%e5%ae%9a%e4%b9%89%e4%b8%80%e4%b8%aa%e6%a8%a1%e5%9d%97)
  - [准备发布模块](#%e5%87%86%e5%a4%87%e5%8f%91%e5%b8%83%e6%a8%a1%e5%9d%97)
    - [release 所有版本模块](#release-%e6%89%80%e6%9c%89%e7%89%88%e6%9c%ac%e6%a8%a1%e5%9d%97)
    - [release v2 或更高版本模块](#release-v2-%e6%88%96%e6%9b%b4%e9%ab%98%e7%89%88%e6%9c%ac%e6%a8%a1%e5%9d%97)
    - [发布一个 release](#%e5%8f%91%e5%b8%83%e4%b8%80%e4%b8%aa-release)
  - [FAQs-多模块仓库](#faqs-%e5%a4%9a%e6%a8%a1%e5%9d%97%e4%bb%93%e5%ba%93)
    - [什么是多模块仓库](#%e4%bb%80%e4%b9%88%e6%98%af%e5%a4%9a%e6%a8%a1%e5%9d%97%e4%bb%93%e5%ba%93)
    - [是否应该在一个仓库包含多个模块](#%e6%98%af%e5%90%a6%e5%ba%94%e8%af%a5%e5%9c%a8%e4%b8%80%e4%b8%aa%e4%bb%93%e5%ba%93%e5%8c%85%e5%90%ab%e5%a4%9a%e4%b8%aa%e6%a8%a1%e5%9d%97)
    - [是否可以给多模块仓库增加一个模块](#%e6%98%af%e5%90%a6%e5%8f%af%e4%bb%a5%e7%bb%99%e5%a4%9a%e6%a8%a1%e5%9d%97%e4%bb%93%e5%ba%93%e5%a2%9e%e5%8a%a0%e4%b8%80%e4%b8%aa%e6%a8%a1%e5%9d%97)
    - [是否可以从多模块仓库删除一个模块](#%e6%98%af%e5%90%a6%e5%8f%af%e4%bb%a5%e4%bb%8e%e5%a4%9a%e6%a8%a1%e5%9d%97%e4%bb%93%e5%ba%93%e5%88%a0%e9%99%a4%e4%b8%80%e4%b8%aa%e6%a8%a1%e5%9d%97)
    - [模块是否可以依赖另一个模块的 internal/](#%e6%a8%a1%e5%9d%97%e6%98%af%e5%90%a6%e5%8f%af%e4%bb%a5%e4%be%9d%e8%b5%96%e5%8f%a6%e4%b8%80%e4%b8%aa%e6%a8%a1%e5%9d%97%e7%9a%84-internal)
    - [是否可以增加一个 go.mod 文件排除不需要的内容？模块是否有等价的 .gitignore 文件](#%e6%98%af%e5%90%a6%e5%8f%af%e4%bb%a5%e5%a2%9e%e5%8a%a0%e4%b8%80%e4%b8%aa-gomod-%e6%96%87%e4%bb%b6%e6%8e%92%e9%99%a4%e4%b8%8d%e9%9c%80%e8%a6%81%e7%9a%84%e5%86%85%e5%ae%b9%e6%a8%a1%e5%9d%97%e6%98%af%e5%90%a6%e6%9c%89%e7%ad%89%e4%bb%b7%e7%9a%84-gitignore-%e6%96%87%e4%bb%b6)
  - [FAQs-其他控制](#faqs-%e5%85%b6%e4%bb%96%e6%8e%a7%e5%88%b6)
    - [在模块上工作时可用的社区工具](#%e5%9c%a8%e6%a8%a1%e5%9d%97%e4%b8%8a%e5%b7%a5%e4%bd%9c%e6%97%b6%e5%8f%af%e7%94%a8%e7%9a%84%e7%a4%be%e5%8c%ba%e5%b7%a5%e5%85%b7)
    - [什么时候使用 replace 指令](#%e4%bb%80%e4%b9%88%e6%97%b6%e5%80%99%e4%bd%bf%e7%94%a8-replace-%e6%8c%87%e4%bb%a4)
    - [是否有 always on 的模块仓库和企业代理](#%e6%98%af%e5%90%a6%e6%9c%89-always-on-%e7%9a%84%e6%a8%a1%e5%9d%97%e4%bb%93%e5%ba%93%e5%92%8c%e4%bc%81%e4%b8%9a%e4%bb%a3%e7%90%86)
  - [module 和 vendor](#module-%e5%92%8c-vendor)
    - [模块下载和验证](#%e6%a8%a1%e5%9d%97%e4%b8%8b%e8%bd%bd%e5%92%8c%e9%aa%8c%e8%af%81)
    - [模块和目录](#%e6%a8%a1%e5%9d%97%e5%92%8c%e7%9b%ae%e5%bd%95)
  - [相关链接](#%e7%9b%b8%e5%85%b3%e9%93%be%e6%8e%a5)

## 快速入门

### 新建工程

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

### 每日工作流

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

## 新概念

### module 模块

- 模块是相关的 Go 包的集合，它们作为一个单一的单元被打上版本号
- 模块记录精确的依赖需求，创建可再复制的构建
- 最常见的是，一个版本控制仓库包含确切的一个模块，在仓库的根目录定义。(可在一个仓库支持多模块，但是通常导致在持续进行的基础上比一个仓库一个模块工作更多)
- 仓库、模块和包的关系：
  - 一个仓库包含一个或多个 Go 模块
  - 每个模块包含一个或多个 Go 包
  - 每个包由一个单一的目录内的一个或多个 Go 源文件组成
- 模块必须根据 semver 打上版本号，通常是 `v(major).(minor).(patch)`，如 `v0.1.0`/`v1.2.3`/`v1.5.0-rc.1`

### go.mod

- 有 4 个指令 `module/require/replace/exclude`
  - module: 声明模块身份，提供了模块路径。包的导入路径由模块路径和包目录与 `go.mod` 的相对路径决定
  - require:
  - replace: 只作用于当前(主)模块
  - exclude: 只作用于当前(主)模块

### 版本选择

### 语义导入版本控制

## 升级和降级依赖

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

## 定义一个模块

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

## 准备发布模块

### release 所有版本模块

1. 去掉多余依赖，增加依赖 `go mod tidy`。`go build` 和 `go test` 不会从 `go.mod` 删除不需要的依赖
2. 测试模块 `go test all`，包括测试直接或间接依赖，验证当前选择包版本的兼容性
3. 确保 `go.sum` 文件和 `go.mod` 文件一起提交了

### release  v2 或更高版本模块

- 将一个工程改成模块时，升级主版本号：使用的时候直接在导入路径添加新的主版本号更简单；也便于在旧版本上修改和完善
- 有两个可选机制 release v2 或更高版本的模块。当推送新的标签时，消费者可以知道新模块的发布。比如创建一个 `v3.0.0` release
  - 主分支：更新 `go.mod` 文件在 `module` 命令的模块路径末尾添加 `/v3`;更新模块内的 import 语句；给本次 release 添加标签 `v3.0.0`
  - 主子目录：创建一个 `v3` 子目录；放一个新的 `go.mod` 文件在 `v3` 目录；更新模块内的 import 语句；给本次 release 添加标签 `v3.0.0`
    - 这个可以提供更好的向后兼容性

### 发布一个 release

- 通过推送一个标签到苍鹭发布新模块版本。标签包括两个字符串：前缀和版本号
  - 前缀指明模块在仓库内定义的位置：如果定义在仓库根目录，前缀为空。标签就是版本号
  - 在多模块仓库中，前缀区分不同模块的版本。前缀是仓库内定义模块的目录。如果仓库是主子目录形式，前缀不包含主版本号后缀
- 比如，有一个模块 `example.com/repo/sub/v2`，需要发布 `v2.1.6`，仓库主目录是 `example.com/repo`，模块在仓库内的 `sub/v2/go.mod` 定义，则模块的前缀是 `sub/`，这次发布完整的标签是 `sub/v2.1.6`

## FAQs-多模块仓库

### 什么是多模块仓库

- 多模块仓库是指一个仓库包含多个模块，每个模块有自己的 `go.mod` 文件
- 每个模块起始于包含它自己的 `go.mod` 的目录，并且包含此目录及其子目录下的所有包，不包含包含另外的 `go.mod` 文件的子树
- 每个模块有自己的版本信息。位于仓库跟木库下的模块的版本标签必须包含相关目录作为前缀
  - 有一个文件 `my-repo/foo/rop/go.mod`，那么模块 `my-repo/foo/rop` 的 1.2.3 版本的标签是 `foo/rop/v1.2.3`
- 一个顶层模块的路径时另外一个模块路径的前缀

### 是否应该在一个仓库包含多个模块

- 相比一个仓库包含多个模块，一个仓库一个模块在增加模块、删除模块、给模块打版本号方面更简单
  - 在仓库根路径执行 `go test ./...` 不会再测试仓库所有代码
  - 需要用 `replace` 指令管理模块之间的关系
- 一个仓库包含多个模块的应用场景
  - 有一个用法例子，且例子有复杂的依赖关系。这种情况可以创建一个 `examples`/`_examples` 目录包含自己的 `go.mod`
  - 某个仓库有复杂的依赖集合，但是有一个客户端 API 只有少数依赖。在某些场景下，创建一个 `api`/`clientapi` 或类似的目录持有自己的 `go.mod`，或者将 `clientapi` 单独分出一个仓库比较好
- 上述两种场景，如果只是为了一个大量间接依赖的性能或者下载大小，建议首先尝试 `GOPOROXY`

### 是否可以给多模块仓库增加一个模块

- 可以。但是有两类问题
  - 新增模块的包不在版本控制中。需要做的事情包括：增加包和 `go.mod` 在同一提交，给提交打标签，推送标签
  - 增加的模块在版本控制，并且包含已有的一个或多个包。这种情况需要

### 是否可以从多模块仓库删除一个模块

- 可以。问题同上

### 模块是否可以依赖另一个模块的 internal/

- 可以。因为路径前缀是共享的

### 是否可以增加一个 go.mod 文件排除不需要的内容？模块是否有等价的 .gitignore 文件

- 一个目录中空的 `go.mod` 文件会导致该目录及其子目录不被顶层的 Go 模块包含
- 如果不想包含的目录不包含任何 `.go` 文件，只需要放一个空的 `go.mod` 文件

## FAQs-其他控制

### 在模块上工作时可用的社区工具

- [github.com/rogpeppe/gohack](https://github.com/rogpeppe/gohack)
- [github.com/marwan-at-work/mod](https://github.com/marwan-at-work/mod)
- [github.com/akyoto/mgit](https://github.com/akyoto/mgit)
- [github.com/goware/modvendor](https://github.com/goware/modvendor)
- [github.com/psampaz/go-mod-outdated](https://github.com/psampaz/go-mod-outdated)

### 什么时候使用 replace 指令

### 是否有 always on 的模块仓库和企业代理

- [proxy.golang.org](https://proxy.golang.org/)
- [gocenter.io](https://gocenter.io/)
- [mirrors.aliyun.com/goproxy](https://mirrors.aliyun.com/goproxy)
- [goproxy.cn](https://goproxy.cn/)
- [goproxy.io](https://goproxy.io/)
- [Athens](https://github.com/gomods/athens)
- [athens.azurefd.net](https://athens.azurefd.net/)
- [Goproxy](https://github.com/goproxy/goproxy)
- [THUMBAI](https://thumbai.app/)

## module 和 vendor

### 模块下载和验证

- 根据 `GOPROXY`，go 命令可以从一个代理或直连到源码控制服务拉取代码
- `GOPROXY` 默认设置是 `https://proxy.golang.org,direct`，即尝试 Google 运行的 Go 模块代理，如果代理报告没有模块(HTTP 错误码 404 或 410)，会尝试直连
- `GOPROXY` 为 `off` 时，不允许从任何源码下载模块。否则，`GOPROXY` 是逗号分隔的模块代理的 URL，go 命令会从这些代理拉取模块
  - 对于每个请求，go 命令按顺序尝试代理，当代理返回 404 或 410 HTTP 状态码时，会继续尝试下个代理
  - **`direct` 之后的代理都不会尝试**
- `GOPRIVATE` 和 `GONOPPROXY` 允许对指定的模块绕过代理
- 对于所有的模块，go 命令会根据已知的 checksum 检查下载，检测未预料的变化。检查先查询当前模块的 `go.sum` 文件，失败时检查 Go 的checksum 数据库，后者由 `GOSUMDB` 和 `GONOSUMDB` 控制

### 模块和目录

- **使用模块时，go 命令会完全忽视 `vendor` 目录**
- 默认的，go 命令通过从源码下载模块和使用这些下载的备份(在验证之后)
- 为了和旧版本的 Go 交互，或者保证编译使用的所有文件被存储在一个单独的目录树，`go mod vendor` 在当前主模块的根目录创建一个 `vendor` 目录，用于存储编译和测试主模块所需的依赖模块的所有包
- `go build -mod=vendor`: 使用模块的顶层的 `vendor` 目录来编译以满足依赖(不使用通常的网络源码和本地缓存)。**注意**只有主模块的顶层 `vendor` 目录会使用，其他位置的 `vendor` 目录仍然忽略

## 相关链接

- [Go module wiki](https://github.com/golang/go/wiki/Modules)
- [Modules and vendoring](https://tip.golang.org/cmd/go/#hdr-Modules_and_vendoring)
