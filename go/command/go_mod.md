# go mod

- [go mod](#go-mod)
  - [用法](#%e7%94%a8%e6%b3%95)
  - [download](#download)
  - [edit](#edit)
  - [graph](#graph)
  - [init](#init)
  - [tidy](#tidy)
  - [vendor](#vendor)
  - [verify](#verify)
  - [why](#why)

## 用法

- 用于操作模块。**注意：所有的 go 命令支持模块**
- 用法：`go mod <command> [arguments]`

| 命令 | 功能 |
| --- | --- |
| download | 下载模块到本地缓存 |
| edit | 使用工具或脚本更新 go.mod |
| graph | 打印模块需求图 |
| init | 在当前目录初始化一个新模块 |
| tidy | 添加缺失模块，删除无用模块 |
| vendor | 创建依赖的 vendor 拷贝 |
| verify | 验证依赖拥有预期的内容 |
| why | 解释为什么需要一个包或者模块 |

## download

- 用法： `go mod download [-json] [modules]`
- 不带模块参数时，默认下载主模块的所有依赖
- 其他 go 命令会自动下载所需模块，`go mod download` 主要用于预先填充本地缓存或用户计算 Go 模块代理
- 默认将错误发生给标准错误。`-json` 会打印 JSON 对象到标准输出，描述每个下载的模块(或失败)

```go
type Module struct {
    Path     string // module path
    Version  string // module version
    Error    string // error loading module
    Info     string // absolute path to cached .info file
    GoMod    string // absolute path to cached .mod file
    Zip      string // absolute path to cached .zip file
    Dir      string // absolute path to cached source root directory
    Sum      string // checksum for path, version (as in go.sum)
    GoModSum string // checksum for go.mod (as in go.sum)
    Latest   bool   // would @latest resolve to this version?
}
```

## edit

- 用法：`go mod edit [edit flags] [go.mod]`
- 命令只会读写主模块 `go.mod` 文件，可在编辑参数指定另外需要编辑的文件
- 编辑标识包括
  - `-fmt`: 只格式化文件。其他参数默认会格式化。只有在没有其他编辑参数时需要指定 `-fmt`
  - `-module`: 修改模块路径(`module` 行)
  - `-require=path@version`/`-droprequire=path`: 
  - `-exclude=path@version`/`-dropexclude=path@version`:
  - `-replace=old[@v]=new[@v]`/`-dropreplace=old[@v]`:
  - `-go=version`:
  - `-print`:
  - `-json`: 以 JSON 格式打印最终的 `go.mod` 而不是写到 `go.mod`。JSON 输出符合下面的 Go 类型
    - 命令只会描述 `go.mod` 文件，间接引用的模块不会包含。需要查看编译所需的所有模块使用 `go list -m -json all`

  ```go
  type Module struct {
    Path string
    Version string
  }

  type GoMod struct {
    Module  Module
    Go      string
    Require []Require
    Exclude []Module
    Replace []Replace
  }

  type Require struct {
    Path string
    Version string
    Indirect bool
  }

  type Replace struct {
    Old Module
    New Module
  }
  ```

- 工具可以通过解析 `go mod edit -json` 的输出获取 `go.mod` 数据结构，然后通过 `go mod edit` 修改

## graph

- 用法：`go mod graph`
- 功能：以文本格式打印模块需求图(使用 replaced 模块)。每一行输出包含模块及其一个依赖

## init

- 用法：`go mod init [module]`
- 功能：在当前目录初始化并写一个新的 `go.mod`，实际上是以当前目录为根创建一个新模块。`go.mod` 一定不能已经存在。可能的话，命令会从导入注释或版本控制配置(git 等)猜测模块路径。要 覆盖猜测，可以提供模块路径参数

## tidy

- 用法：`go mod tidy [-v]`
- 功能：确保 `go.mod` 和模块的源码匹配。拉取需要的缺失模块，删除无用模块。同时修改 `go.sum`
- `-v` 会输出删除模块信息到标准错误

## vendor

- 用法：`go mod vendor [-v]`
- 功能：重置主模块的 `vendor` 目录一包含编译和测试主模块所有包所需的包。目录不包含 vendored 包的测试代码
- `-v` 打印 vendored 模块和包的名称到标准错误

## verify

- 用法：`go mod verify`
- 功能：检查当前模块的依赖在下载之后不曾被修改，该依赖存储在一个本地下载的源码缓存。如果所有模块未被修改，输出 `all modules verified.`。否则打印被修改的模块，并导致 `go mod` 以非 0 状态码返回

## why

- 用法：`go mod why [-m] [-vendor] packages...`
- 功能：显示主模块到每个列举包的最短导入路径
- `-m` 将参数视为一系列模块，并为模块的每个包找到一个路径
