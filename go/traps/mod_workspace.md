# module 不要在 vscode 工作区打开工程

- [module 不要在 vscode 工作区打开工程](#module-%e4%b8%8d%e8%a6%81%e5%9c%a8-vscode-%e5%b7%a5%e4%bd%9c%e5%8c%ba%e6%89%93%e5%bc%80%e5%b7%a5%e7%a8%8b)
  - [旧行为 vs 基于模块的行为](#%e6%97%a7%e8%a1%8c%e4%b8%ba-vs-%e5%9f%ba%e4%ba%8e%e6%a8%a1%e5%9d%97%e7%9a%84%e8%a1%8c%e4%b8%ba)
  - [在 GOPATH 之外工作](#%e5%9c%a8-gopath-%e4%b9%8b%e5%a4%96%e5%b7%a5%e4%bd%9c)
  - [VSCode 对模块的支持](#vscode-%e5%af%b9%e6%a8%a1%e5%9d%97%e7%9a%84%e6%94%af%e6%8c%81)
    - [保存文件时不再自动导入](#%e4%bf%9d%e5%ad%98%e6%96%87%e4%bb%b6%e6%97%b6%e4%b8%8d%e5%86%8d%e8%87%aa%e5%8a%a8%e5%af%bc%e5%85%a5)
  - [相关链接](#%e7%9b%b8%e5%85%b3%e9%93%be%e6%8e%a5)

## 旧行为 vs 基于模块的行为

- 模块在 Go1.11 开始，因此按照设计旧行为会默认保留。因此需要注意什么时候是旧的 1.10 状态行为(查找 `vendor` 目录和 GOPATH 来寻找依赖)，什么时候是新的基于模块的行为
  - 在 `GOPATH` 之内: 默认是旧的 1.10 行为，会忽视模块
  - 在 `GOPATH` 之外且在文件树之内有一个 `go.mod` 文件: 默认是模块行为
  - `GO111MODULE` 环境变量
    - 不设置或 `auto`: 上述默认行为
    - `on`: 强制支持模块，与目录位置无关
    - `off`: 强制不支持模块，与目录位置无关

## 在 GOPATH 之外工作

- 如果对于一个给定的导入路径，有多个包的版本，那么要求包的开发版本放在一个指定的位置是没有意义的。如果需要同时在 v1.3 和 v1.4 版本上修改 bug，显然需要在不同的位置切换模块。实际上，这种情况下，没有必要在 GOPATH 目录工作
- GOPATH 做了三件事
  - 定义依赖的版本(现在在 `go.mod`)
  - 保存这些依赖的源码(现在在分别的 cache)
  - 提供一种方式来推测特定目录(去掉先导的 `$GOPATH/src`)代码内的导入路径(现在有机制来确定当前目录代码的导入路径，可以停止要求程序猿在 GOPATH 工作)
    - 此机制位于 `go.mod` 文件的 `module` 命令。比如当前目录是 `buggy`，且 `../go.mod` 包含 `module "rsc.io/quote"`，那么当前目录的导入路径就是 `rsc.io/quote/buggy`
- `vgo` 原型支持在 GOPATH 之外工作。比如下面的例子，即使 Upspin 没有引入 `go.mod` 文件也可以工作

  ```sh
  cd $HOME
  git clone https://github.com/upspin/upspin
  cd upspin
  # vgo 从 导入注释推测模块名字是 upsin.io，并且从 Gopkg.loc 推测需要的依赖版本
  vgo test -short ./...
  ```

## VSCode 对模块的支持

- 新的语言服务 gopls 支持模块，设置 `"go.useLanguageServer": true`

### 保存文件时不再自动导入

- 如果不使用语言服务，插件默认使用 `goreturns` 工具格式化文件，并自动导入缺失的包。但是 `goreturns` 工具不支持模块，因此存文件时自动导入的特性不生效
- 增加设置 `"go.formatTool": "goimports"`，然后使用 `Go: Install/Update Tools` 安装或更新 `goimports`，因为 `goimports` 已经增加对模块的支持

## 相关链接

- [Go module wiki](https://github.com/golang/go/wiki/Modules)
- [When do I get old behavior vs. new module-based behavior](https://github.com/golang/go/wiki/Modules#when-do-i-get-old-behavior-vs-new-module-based-behavior)
- [Versioned Go Commands](https://research.swtch.com/vgo-cmd)
- [Working outside GOPATH](https://research.swtch.com/vgo-cmd#working_outside_gopath)
- [Go modules support in Visual Studio Code](https://github.com/Microsoft/vscode-go/wiki/Go-modules-support-in-Visual-Studio-Code)
