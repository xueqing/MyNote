# module 不要在 vscode 工作区打开工程

## 旧行为 vs 基于模块的行为

- 模块在 Go1.11 开始，因此按照设计旧行为会默认保留。因此需要注意什么时候是旧的 1.10 状态行为，什么时候是新的基于模块的行为
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
$ cd $HOME
$ git clone https://github.com/upspin/upspin
$ cd upspin
# vgo 从 导入注释推测模块名字是 upsin.io，并且从 Gopkg.loc 推测需要的依赖版本
$ vgo test -short ./...
```

## 相关链接

- [Go module wiki](https://github.com/golang/go/wiki/Modules)
- [When do I get old behavior vs. new module-based behavior](https://github.com/golang/go/wiki/Modules#when-do-i-get-old-behavior-vs-new-module-based-behavior)
- [Versioned Go Commands](https://research.swtch.com/vgo-cmd)
- [Working outside GOPATH](https://research.swtch.com/vgo-cmd#working_outside_gopath)
