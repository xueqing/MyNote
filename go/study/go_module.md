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
    - [10.1 为什么 go mod tidy 记录 go.mod 的间接和测试依赖](#101-%e4%b8%ba%e4%bb%80%e4%b9%88-go-mod-tidy-%e8%ae%b0%e5%bd%95-gomod-%e7%9a%84%e9%97%b4%e6%8e%a5%e5%92%8c%e6%b5%8b%e8%af%95%e4%be%9d%e8%b5%96)
    - [10.2 go.sum 是否是锁文件？为什么 go.sum 包含不再使用的模块版本信息](#102-gosum-%e6%98%af%e5%90%a6%e6%98%af%e9%94%81%e6%96%87%e4%bb%b6%e4%b8%ba%e4%bb%80%e4%b9%88-gosum-%e5%8c%85%e5%90%ab%e4%b8%8d%e5%86%8d%e4%bd%bf%e7%94%a8%e7%9a%84%e6%a8%a1%e5%9d%97%e7%89%88%e6%9c%ac%e4%bf%a1%e6%81%af)
    - [10.3 是否应该提交 go.sum 和 go.mod 文件](#103-%e6%98%af%e5%90%a6%e5%ba%94%e8%af%a5%e6%8f%90%e4%ba%a4-gosum-%e5%92%8c-gomod-%e6%96%87%e4%bb%b6)
    - [10.4 如果没有任何依赖是否仍应该增加一个 go.mod 文件](#104-%e5%a6%82%e6%9e%9c%e6%b2%a1%e6%9c%89%e4%bb%bb%e4%bd%95%e4%be%9d%e8%b5%96%e6%98%af%e5%90%a6%e4%bb%8d%e5%ba%94%e8%af%a5%e5%a2%9e%e5%8a%a0%e4%b8%80%e4%b8%aa-gomod-%e6%96%87%e4%bb%b6)
  - [11 FAQs-语义导入版本控制](#11-faqs-%e8%af%ad%e4%b9%89%e5%af%bc%e5%85%a5%e7%89%88%e6%9c%ac%e6%8e%a7%e5%88%b6)
    - [11.1 为什么主版本号必须出现在导入路径](#111-%e4%b8%ba%e4%bb%80%e4%b9%88%e4%b8%bb%e7%89%88%e6%9c%ac%e5%8f%b7%e5%bf%85%e9%a1%bb%e5%87%ba%e7%8e%b0%e5%9c%a8%e5%af%bc%e5%85%a5%e8%b7%af%e5%be%84)
    - [11.2 为什么主版本号 v0/v1 被导入路径忽视](#112-%e4%b8%ba%e4%bb%80%e4%b9%88%e4%b8%bb%e7%89%88%e6%9c%ac%e5%8f%b7-v0v1-%e8%a2%ab%e5%af%bc%e5%85%a5%e8%b7%af%e5%be%84%e5%bf%bd%e8%a7%86)
    - [11.3 使用主版本号 v0/v1 给项目打标签或使用 v2+ 标记破坏性的变化的影响是什么](#113-%e4%bd%bf%e7%94%a8%e4%b8%bb%e7%89%88%e6%9c%ac%e5%8f%b7-v0v1-%e7%bb%99%e9%a1%b9%e7%9b%ae%e6%89%93%e6%a0%87%e7%ad%be%e6%88%96%e4%bd%bf%e7%94%a8-v2-%e6%a0%87%e8%ae%b0%e7%a0%b4%e5%9d%8f%e6%80%a7%e7%9a%84%e5%8f%98%e5%8c%96%e7%9a%84%e5%bd%b1%e5%93%8d%e6%98%af%e4%bb%80%e4%b9%88)
    - [11.4 模块能否使用没有选择加入模块的包](#114-%e6%a8%a1%e5%9d%97%e8%83%bd%e5%90%a6%e4%bd%bf%e7%94%a8%e6%b2%a1%e6%9c%89%e9%80%89%e6%8b%a9%e5%8a%a0%e5%85%a5%e6%a8%a1%e5%9d%97%e7%9a%84%e5%8c%85)
    - [11.5 模块能否使用没有加入模块的 v2+ 包？ +incompatible 意味着什么](#115-%e6%a8%a1%e5%9d%97%e8%83%bd%e5%90%a6%e4%bd%bf%e7%94%a8%e6%b2%a1%e6%9c%89%e5%8a%a0%e5%85%a5%e6%a8%a1%e5%9d%97%e7%9a%84-v2-%e5%8c%85-incompatible-%e6%84%8f%e5%91%b3%e7%9d%80%e4%bb%80%e4%b9%88)
    - [11.6 禁用模块支持时在编译中如何对待 v2+ 模块？最小模块兼容性在 Go1.9.7+/Go1.10.3+/Go1.11 中如何工作](#116-%e7%a6%81%e7%94%a8%e6%a8%a1%e5%9d%97%e6%94%af%e6%8c%81%e6%97%b6%e5%9c%a8%e7%bc%96%e8%af%91%e4%b8%ad%e5%a6%82%e4%bd%95%e5%af%b9%e5%be%85-v2-%e6%a8%a1%e5%9d%97%e6%9c%80%e5%b0%8f%e6%a8%a1%e5%9d%97%e5%85%bc%e5%ae%b9%e6%80%a7%e5%9c%a8-go197go1103go111-%e4%b8%ad%e5%a6%82%e4%bd%95%e5%b7%a5%e4%bd%9c)
    - [11.7 如果创建一个 go.mod 但是仓库不使用 semver 标签会发生什么](#117-%e5%a6%82%e6%9e%9c%e5%88%9b%e5%bb%ba%e4%b8%80%e4%b8%aa-gomod-%e4%bd%86%e6%98%af%e4%bb%93%e5%ba%93%e4%b8%8d%e4%bd%bf%e7%94%a8-semver-%e6%a0%87%e7%ad%be%e4%bc%9a%e5%8f%91%e7%94%9f%e4%bb%80%e4%b9%88)
    - [11.8 一个模块能否依赖自身不同的版本](#118-%e4%b8%80%e4%b8%aa%e6%a8%a1%e5%9d%97%e8%83%bd%e5%90%a6%e4%be%9d%e8%b5%96%e8%87%aa%e8%ba%ab%e4%b8%8d%e5%90%8c%e7%9a%84%e7%89%88%e6%9c%ac)
  - [12 FAQs-多模块仓库](#12-faqs-%e5%a4%9a%e6%a8%a1%e5%9d%97%e4%bb%93%e5%ba%93)
    - [12.1 什么是多模块仓库](#121-%e4%bb%80%e4%b9%88%e6%98%af%e5%a4%9a%e6%a8%a1%e5%9d%97%e4%bb%93%e5%ba%93)
    - [12.2 是否应该在一个仓库包含多个模块](#122-%e6%98%af%e5%90%a6%e5%ba%94%e8%af%a5%e5%9c%a8%e4%b8%80%e4%b8%aa%e4%bb%93%e5%ba%93%e5%8c%85%e5%90%ab%e5%a4%9a%e4%b8%aa%e6%a8%a1%e5%9d%97)
    - [12.3 能否给多模块仓库增加一个模块](#123-%e8%83%bd%e5%90%a6%e7%bb%99%e5%a4%9a%e6%a8%a1%e5%9d%97%e4%bb%93%e5%ba%93%e5%a2%9e%e5%8a%a0%e4%b8%80%e4%b8%aa%e6%a8%a1%e5%9d%97)
    - [12.4 能否从多模块仓库删除一个模块](#124-%e8%83%bd%e5%90%a6%e4%bb%8e%e5%a4%9a%e6%a8%a1%e5%9d%97%e4%bb%93%e5%ba%93%e5%88%a0%e9%99%a4%e4%b8%80%e4%b8%aa%e6%a8%a1%e5%9d%97)
    - [12.5 模块能否依赖另一个模块的 internal/](#125-%e6%a8%a1%e5%9d%97%e8%83%bd%e5%90%a6%e4%be%9d%e8%b5%96%e5%8f%a6%e4%b8%80%e4%b8%aa%e6%a8%a1%e5%9d%97%e7%9a%84-internal)
    - [12.6 能否增加一个 go.mod 文件排除不需要的内容？模块是否有等价的 .gitignore 文件](#126-%e8%83%bd%e5%90%a6%e5%a2%9e%e5%8a%a0%e4%b8%80%e4%b8%aa-gomod-%e6%96%87%e4%bb%b6%e6%8e%92%e9%99%a4%e4%b8%8d%e9%9c%80%e8%a6%81%e7%9a%84%e5%86%85%e5%ae%b9%e6%a8%a1%e5%9d%97%e6%98%af%e5%90%a6%e6%9c%89%e7%ad%89%e4%bb%b7%e7%9a%84-gitignore-%e6%96%87%e4%bb%b6)
  - [13 FAQs-最小版本选择](#13-faqs-%e6%9c%80%e5%b0%8f%e7%89%88%e6%9c%ac%e9%80%89%e6%8b%a9)
    - [13.1 最小版本选择是否会使开发者得到重要的更新](#131-%e6%9c%80%e5%b0%8f%e7%89%88%e6%9c%ac%e9%80%89%e6%8b%a9%e6%98%af%e5%90%a6%e4%bc%9a%e4%bd%bf%e5%bc%80%e5%8f%91%e8%80%85%e5%be%97%e5%88%b0%e9%87%8d%e8%a6%81%e7%9a%84%e6%9b%b4%e6%96%b0)
  - [14 FAQs-可能的问题](#14-faqs-%e5%8f%af%e8%83%bd%e7%9a%84%e9%97%ae%e9%a2%98)
    - [14.1 如果发现问题，有哪些通用的东西可以定位检查](#141-%e5%a6%82%e6%9e%9c%e5%8f%91%e7%8e%b0%e9%97%ae%e9%a2%98%e6%9c%89%e5%93%aa%e4%ba%9b%e9%80%9a%e7%94%a8%e7%9a%84%e4%b8%9c%e8%a5%bf%e5%8f%af%e4%bb%a5%e5%ae%9a%e4%bd%8d%e6%a3%80%e6%9f%a5)
    - [14.2 如果没有看到预期的依赖版本，可以检查什么](#142-%e5%a6%82%e6%9e%9c%e6%b2%a1%e6%9c%89%e7%9c%8b%e5%88%b0%e9%a2%84%e6%9c%9f%e7%9a%84%e4%be%9d%e8%b5%96%e7%89%88%e6%9c%ac%e5%8f%af%e4%bb%a5%e6%a3%80%e6%9f%a5%e4%bb%80%e4%b9%88)
    - [14.3 为什么得到错误 cannot find module providing package foo](#143-%e4%b8%ba%e4%bb%80%e4%b9%88%e5%be%97%e5%88%b0%e9%94%99%e8%af%af-cannot-find-module-providing-package-foo)
    - [14.4 为什么 go mod init 报错 cannot determine module path for source directory](#144-%e4%b8%ba%e4%bb%80%e4%b9%88-go-mod-init-%e6%8a%a5%e9%94%99-cannot-determine-module-path-for-source-directory)
    - [14.5 有一个复杂的且没有加入模块的依赖出现问题。能否使用它目前的依赖管理器的信息](#145-%e6%9c%89%e4%b8%80%e4%b8%aa%e5%a4%8d%e6%9d%82%e7%9a%84%e4%b8%94%e6%b2%a1%e6%9c%89%e5%8a%a0%e5%85%a5%e6%a8%a1%e5%9d%97%e7%9a%84%e4%be%9d%e8%b5%96%e5%87%ba%e7%8e%b0%e9%97%ae%e9%a2%98%e8%83%bd%e5%90%a6%e4%bd%bf%e7%94%a8%e5%ae%83%e7%9b%ae%e5%89%8d%e7%9a%84%e4%be%9d%e8%b5%96%e7%ae%a1%e7%90%86%e5%99%a8%e7%9a%84%e4%bf%a1%e6%81%af)
    - [14.6 如何解决由于导入路径和声明模块身份不匹配导致的 parsing go.mod: unexpected module path 和 error loading module requirements 错误](#146-%e5%a6%82%e4%bd%95%e8%a7%a3%e5%86%b3%e7%94%b1%e4%ba%8e%e5%af%bc%e5%85%a5%e8%b7%af%e5%be%84%e5%92%8c%e5%a3%b0%e6%98%8e%e6%a8%a1%e5%9d%97%e8%ba%ab%e4%bb%bd%e4%b8%8d%e5%8c%b9%e9%85%8d%e5%af%bc%e8%87%b4%e7%9a%84-parsing-gomod-unexpected-module-path-%e5%92%8c-error-loading-module-requirements-%e9%94%99%e8%af%af)
      - [14.6.1 出现问题的原因](#1461-%e5%87%ba%e7%8e%b0%e9%97%ae%e9%a2%98%e7%9a%84%e5%8e%9f%e5%9b%a0)
      - [14.6.2 场景示例](#1462-%e5%9c%ba%e6%99%af%e7%a4%ba%e4%be%8b)
      - [14.6.3 解决方法](#1463-%e8%a7%a3%e5%86%b3%e6%96%b9%e6%b3%95)
    - [14.7 为什么 go build 要求 gcc？为什么预编译包(如 net/http) 不用](#147-%e4%b8%ba%e4%bb%80%e4%b9%88-go-build-%e8%a6%81%e6%b1%82-gcc%e4%b8%ba%e4%bb%80%e4%b9%88%e9%a2%84%e7%bc%96%e8%af%91%e5%8c%85%e5%a6%82-nethttp-%e4%b8%8d%e7%94%a8)
    - [14.8 模块能否在相对导入路径(如 import "./subdir")正常工作](#148-%e6%a8%a1%e5%9d%97%e8%83%bd%e5%90%a6%e5%9c%a8%e7%9b%b8%e5%af%b9%e5%af%bc%e5%85%a5%e8%b7%af%e5%be%84%e5%a6%82-import-%22subdir%22%e6%ad%a3%e5%b8%b8%e5%b7%a5%e4%bd%9c)
    - [14.9 某些需要的文件可能不在定位的 vendor 目录](#149-%e6%9f%90%e4%ba%9b%e9%9c%80%e8%a6%81%e7%9a%84%e6%96%87%e4%bb%b6%e5%8f%af%e8%83%bd%e4%b8%8d%e5%9c%a8%e5%ae%9a%e4%bd%8d%e7%9a%84-vendor-%e7%9b%ae%e5%bd%95)
  - [15 相关链接](#15-%e7%9b%b8%e5%85%b3%e9%93%be%e6%8e%a5)

## 1 快速入门

### 1.1 新建工程

```sh
# 1 在 GPOPATH 之外创建工程
mkdir -p /tmp/mygopro/repo
# 2 切换到工程目录
cd /tmp/mygopro/repo
# 3 初始化工程
git init
# 4 添加远程仓库路径
git remote add origin https://github.com/my/repo
# 5 初始化一个新模块, 会创建一个 go.mod 文件
go mod init github.com/my/repo
# 6 写 go 源码
cat <<EOF > hello.go
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
go build -o hello
./hello
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
  cd <project path outside $GOPATH/src>
  ## 1.1 对于在 $GOPATH/src 目录之内的工程，需要手动激活
  export GO111MODULE=on
  cd $GOPATH/src/<project path>
  # 2 创建初始模块定义，并从 dep 或其他依赖管理器转化依赖信息，增加 require 声明到 go.mod 以匹配现有配置
  go mod init
  ## 2.1 可以指定模块路径(命令不能自动确定模块路径，或需要覆盖该路径)
  go mod init github.com/my/repo
  # 3 编译模块。在模块根路径执行，互编译当前模块的所有包。go build 会自动添加缺失或未转化的依赖
  go build ./...
  # 4 按照配置测试模块，确认对于选中的版本是正常的
  go test ./...
  # 5 可选。运行模块和所有直接或间接依赖的测试，检查兼容性
  go test all
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
- 对于所有的模块，go 命令会根据已知的校验值检查下载，检测未预料的变化。检查先查询当前模块的 `go.sum` 文件，失败时检查 Go 的校验值数据库，后者由 `GOSUMDB` 和 `GONOSUMDB` 控制

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

### 10.1 为什么 go mod tidy 记录 go.mod 的间接和测试依赖

- 模块系统在 `go.mod` 记录精确的依赖需求
- `go mod tidy` 更新当前的 `go.mod` 以包含模块中测试所需的依赖——如果一个测试失败，必须知道使用的依赖以重复该失败
- `go mod tidy` 同时确保当前的 `go.mod` 反映了对所有的操作系统、架构和编译标签的组合的依赖需求。相反的，其他的命令(如 `go build`/`go test`)只更新 `go.mod` 以提供当前的 `GOOS`，`GOARCH` 和编译标签被请求的包导入的包(这也是 `go mod tidy` 可能增加其他 go 命令没有增加的需求的原因之一)
- 如果你的模块的依赖本身没有一个 `go.mod`(比如因为依赖还没有选择加入模块)，或依赖的 `go.mod` 缺少一些依赖(比如因为模块的作者没有运行 `go mod tidy`)，那么缺失的依赖会加入到你的模块的需求，并带有一个 `// indirect` 注释表明依赖不是从你的模块直接导入的
- **注意：**这也意味着你的模块的直接或间接依赖缺失的测试依赖也会被记录在当前的 `go.mod`。比如，`go test all` 运行你的模块所有的直接或间接依赖的测试，这是验证当前版本组合有效的一种方式。如果允许时某个依赖的一个测试失败，记录完整的测试依赖信息是很重要的，以便可以重复 `go test all` 行为
- `go.mod` 有 `// indirect` 依赖的另外一个原因：当升级或降级一个间接依赖且超出直接依赖的需求时(比如运行 `go get -u`/`go get foo@1.2.3`)，go 工具需要在某个地方记录新版本信息，并且记录在 `go.mod` 文件(并且不会去更改依赖的 `go.mod` 文件)
- 一般的，上述是模块通过记录精确的依赖信息提供 100% 可重复编译和测试的一部分行为
- 相关命令
  - `go mod why -m <module>` 显示 `go.mod` 中指定模块出现的原因
  - `go mod graph`/`go list -m all` 检查需要的模块及其版本

### 10.2 go.sum 是否是锁文件？为什么 go.sum 包含不再使用的模块版本信息

- 不是。`go.sum` 在一次编译中提供足够的信息支持 100% 可重复的编译
- 出于验证的目的，`go.sum` 包含预期的对指定模块版本内容的加密校验值
- 在某种程度上，因为 `go.sum` 不是锁文件，它在停止使用一个模块或者模块的某个版本之后仍然为模块版本保留加密校验值。这允许在之后重新使用一些模块时提供校验，也提供了额外的安全性
- `go.sum` 记录一次编译所有的直接或间接依赖的校验值(因此 `go.sum` 经常会比 `go.mod` 有更多的模块)

### 10.3 是否应该提交 go.sum 和 go.mod 文件

- 通常应该一起提交 `go.sum` 和 `go.mod` 文件
  - `go.sum` 包含预期的对指定模块版本内容的加密校验值
  - 如果某人克隆仓库并使用 go 命令下载依赖，当他们下载的依赖拷贝和 `go.sum` 对应的条目不匹配时会报错
  - `go mod verify` 检查模块的磁盘缓存备份仍然和 `go.sum` 的条目匹配
  - 注意，`go.sum` 不是一个锁文件(一些可选的依赖管理系统使用的锁文件)。`go.mod` 提供足够的信息支持可重复的编译

### 10.4 如果没有任何依赖是否仍应该增加一个 go.mod 文件

- 是的。
  - 支持在 GOPATH 之外工作
  - 有助于和模块生态圈沟通
  - 其中的 `module` 指令可作为代码身份的明确声明

## 11 FAQs-语义导入版本控制

### 11.1 为什么主版本号必须出现在导入路径

- 为了遵循最小兼容原则，简化了系统其它部分

### 11.2 为什么主版本号 v0/v1 被导入路径忽视

- 忽视 v1 有两个原因
  - 许多开发人员会创建一个包，该包在发布 v1 之后永远不会有破坏性的变化，这也是一开始鼓励的。当开发人员没有计划发布 v2 时，不应该强迫他们有显式的 v1。那样只会是干扰。当最终创建 v2 时，才需要加 v2 以便区分默认的 v1
  - 大量已有的代码建议忽视 v1，而不是在每个地方都加上 v1
- 忽视 v0
  - 根据 semver 规定，对于 v0 没有任何兼容性保证。因此要求显式的 v0 对于兼容性没有什么帮助；必须指明完全精确的类似 v0.1.2，而每次库更新时需要更新所有的导入路径。这是过犹不及的。相反的，我们希望开发人员会简单地查看依赖的模块列表，并适当地谨慎任何 v0.x.y 版本
- 忽视 v0/v1 的影响：将没办法从区分路径区分它们，但是 v0 通常是通向 v1 的一系列破坏性变化，因此将 v1 视为破坏性变化的最后阶段是有意义的
  >>> 通过使用 v0.x，你正在接受 v0.(x+1) 可能迫使你修改代码。那么为什么 v0.(x+1) 叫做 v1.0 是一个问题呢？
- 忽视 v0/v1 是强制性而非可选的，因此这是包的一个规范导入路径

### 11.3 使用主版本号 v0/v1 给项目打标签或使用 v2+ 标记破坏性的变化的影响是什么

- 和 API 兼容性相关

### 11.4 模块能否使用没有选择加入模块的包

- 可以。对于没有加入模块的仓库
  - 但是具有有效的 semver 标签(包括要求的前导 `v`)：可使用 `go get` 获取这些标签，并记录对应 semver 版本到导入模块的 `go.mod`
  - 没有有效的 semver 标签：使用伪版本(如 `v0.0.0-20171006230638-a6e239ea1c69`，包含时间戳，commit-id，如此设计以允许给版本排序)记录

### 11.5 模块能否使用没有加入模块的 v2+ 包？ +incompatible 意味着什么

- 可以。如果导入的 v2+ 包具有有效的 semver 标签，将会在记录时添加 `+incompatible` 后缀
- 当 go 工具在模块模式(如 `GO111MODULE=on`)操作时，下面的核心原则总为真
  - 1 包的导入路径定义了包的身份
    - 导入路径不同的包视为不同的包
    - 导入路径相同的包视为相同的包(即使 VCS 标签表明二者主版本号不同)
  - 2 没有 `/vN` 的导入路径视为 v0/v1 模块(即使导入包没有加入模块，且 VCS 标签表明主版本号大于 1)
  - 3 模块的 `go.mod` 开始声明的模块路径(如 `module foo/v2`)是
    - 该模块身份的确定性声明
    - 该模块必须被使用代码如何导入的确定性声明
- `+incompatible` 后缀表明上述原则 2 实际上在下面情况下为真
  - 导入的包没有加入模块
  - 且其 VCS 标签表明主版本号大于 1
  - 且原则 2 会覆盖 VCS 标签——没有 `/vN` 的导入路径视为 v0/v1 模块(即使 VCS 标签主版本号大于 1)
- 即，当在模块模式操作时，go 工具将认为非模块的 v2+ 包不知道语义导入版本控制，并将其视作包 v1 版本系列的(非兼容的)扩展( `+incompatible` 后缀指示 go 工具这样做)

### 11.6 禁用模块支持时在编译中如何对待 v2+ 模块？最小模块兼容性在 Go1.9.7+/Go1.10.3+/Go1.11 中如何工作

- 主子目录方式：v2+ 模块会创建子目录(如`mymodule/v2`/`mymodule/v3`)，并将合适的包移动或拷贝到子目录，这种方式的包是可以被不支持或禁用模块的 Go 使用
- 主分支方式：通过 `go.mod` 和提交 semver 标签确定模块版本信息(经常在 `master` 分支)。由此引入了最小模块兼容性。主要目的是
  - 允许旧版本 Go(1.9.7+/1.10.3+) 更容易编译使用语义导入版本控制的模块，并提供和 Go1.11 禁用模块时相同的行为
  - 允许旧代码使用 v2+ 模块，而不用旧代码修改导入路径添加 `/vN`
  - 不用依赖模块作者创建 `/vN` 子目录而实现上述两种行为

### 11.7 如果创建一个 go.mod 但是仓库不使用 semver 标签会发生什么

### 11.8 一个模块能否依赖自身不同的版本

- 可以。但是两个包不能循环依赖

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

### 13.1 最小版本选择是否会使开发者得到重要的更新

## 14 FAQs-可能的问题

### 14.1 如果发现问题，有哪些通用的东西可以定位检查

- 检查启用了模块：运行 `go env` 查看 `GOMOD` 不为空
  - `GOMOD` 不能设置，是 `go env` 的输出
  - 如果设置 `GO111MODULE=on` 以启用模块，检查不要是复数形式 `GO111MODULES=on`
- 如果预期使用 vendor，检查 `-mod=vendor` 被传递给相关的 go 命令，或者设置了 `GOFLAGS=-mod=vendor`
  - 模块默认忽视 `vendor` 除非要求 go 工具使用
- `go list -m all` 检查编译实际选择的版本列表
  - 相比查看 `go.mod` 会给出更多详细信息
- 如果允许 `go get foo` 失败，或者 `go build` 在 `foo` 包失败。可使用 `go get -v foo`/`go get -v -x foo` 查看输出
  - 一般的，`go get` 比 `go build` 提供更多详细的错误信息
  - `-v` 标识请求打印更多冗长细节，不过注意一些错误(比如 404)可能基于远程仓库的配置
  - `go get -v -x foo` 也会显示调用的 git 或其他 VCS 命令(如有必要，可以经常在 go 工具上下文之外执行相同的命令用于故障排除)
- 检查是否使用了旧的 git 版本
  - 对于 vgo 原型和 Go1.11beta，使用旧的 git 是常见的错误源，但是在 GA1.11 中较少出现
- Go1.11 的模块缓存有时候会导致错误，尤其是先前有网络错误或者同时执行多个 go 命令时。可以将 `$GOPATH/pkg/mod` 到一个备份目录，运行 `go clean -modcache`，然后检查之前的问题是否出现
- 如果使用 Docker，检查是否可以可以在 Docker 之外复制行为(且如果行为只出现在 Docker，上述条目可用于比较 Docker 内外的结果)

### 14.2 如果没有看到预期的依赖版本，可以检查什么

1. 执行 `go mod tidy`。如果 `go mod tidy` 改变了没有预期的依赖版本，先查看[go mod tidy 记录 go.mod 的间接和测试依赖](#101-%e4%b8%ba%e4%bb%80%e4%b9%88-go-mod-tidy-%e8%ae%b0%e5%bd%95-gomod-%e7%9a%84%e9%97%b4%e6%8e%a5%e5%92%8c%e6%b5%8b%e8%af%95%e4%be%9d%e8%b5%96)。如果没有解释，可以尝试重置 `go.mod`，然后运行 `go list -mod=readonly all`，可以就要求修改版本给出更多信息
2. 执行 `go list -m all`，查看编译实际选择的版本列表。`go list -m all` 显示最终选择的版本，包括间接依赖和解决共享依赖的版本。并显示了任何 `replace` 和 `exclude` 指令的结果
3. 执行 `go mod graph`/`go mod graph | grep <module-of-interest>`
4. 其他有用的命令包括 `go mod why -m <module>`/`go list`/`go list -deps -f '{{with .Module}}{{.Path}} {{.Version}}{{end}}' ./... | sort -u`(显示编译使用的精确版本，不包括只用于测试的依赖)

### 14.3 为什么得到错误 cannot find module providing package foo

1. 可能是路径不对。首先可以检查错误信息中列举的路径
2. 尝试 `go get -v foo`/`go get -v -x foo`。通常，`go get` 比 `get build` 提供更多的错误信息
3. 其他可能原因
   1. 当前目录没有 go 源码文件，但是运行了 `go build`/`go build .`。可以尝试运行 `go build ./...`(`./...` 通配符匹配当前模块的所有包)
   2. Go1.11 的模块缓存在遇到网络问题或者同时允许多个 go 命令时会导致这个错误。在 Go1.12 已经接近。参考[上面的问题](#141-%e5%a6%82%e6%9e%9c%e5%8f%91%e7%8e%b0%e9%97%ae%e9%a2%98%e6%9c%89%e5%93%aa%e4%ba%9b%e9%80%9a%e7%94%a8%e7%9a%84%e4%b8%9c%e8%a5%bf%e5%8f%af%e4%bb%a5%e5%ae%9a%e4%bd%8d%e6%a3%80%e6%9f%a5)

### 14.4 为什么 go mod init 报错 cannot determine module path for source directory

- `go mod init` 不带参数是会基于不同的暗示(VCS 元数据等)尝试猜测合适的模块路。但是，命令不能总是猜测的预期的合适路径
- 如果 `go mod init` 报这类错，必须自己提供模块路径(`go mod init module_path`)

### 14.5 有一个复杂的且没有加入模块的依赖出现问题。能否使用它目前的依赖管理器的信息

- 可以。这需要一些手动步骤，但是在一些复杂场景是有用的
- 当运行 `go mod init` 初始化模块时，命令会从先前的依赖管理器通过翻译配置文件(如 `Gopkg.lock/glide.lock/vendor.json`)自动转换到 `go.mod` 文件，该文件包含了对应的 `require` 指令。先前的一些文件信息通畅描述了所有直接或间接依赖的版本信息
- 然而，当添加一个还没有加入模块的新依赖，新依赖不会有上述类似的自动转换过程。如果该新依赖本身有一些非模块依赖，且这些依赖有破坏性的变化，那么在某些场景下，会导致不兼容问题。换句话说，不会自动使用先前对于新依赖的依赖管理器，而这会在某些场景导致非间接依赖的问题
- 一个方法是在有问题的非模块直接依赖运行 `go mod init` 转化当前依赖管理器，然后使用生成的临时 `go.mod` 的 `require` 指令定位或更新你的模块的 `go.mod`
  - 临时 `go.mod` 生成的 `require` 信息可手动移动到你的模块实际的 `go.mod`，或考虑使用 [gomodmerge](https://github.com/rogpeppe/gomodmerge) 工具。除此之外，可能会增加 `require github.com/some/nonmodule v1.2.3` 到你的模块实际的 `go.mod` 以匹配手动克隆的版本

  ```sh
  git clone -b v1.2.3 https://github.com/some/nonmodule /tmp/scratchpad/nonmodule
  cd /tmp/scratchpad/nonmodule
  go mod init
  cat go.mod
  ```

### 14.6 如何解决由于导入路径和声明模块身份不匹配导致的 parsing go.mod: unexpected module path 和 error loading module requirements 错误

#### 14.6.1 出现问题的原因

- 一般的，一个模块在 `go.mod` 中通过 `module` 指令声明它的身份。这个该模块的“模块路径”，并且 go 工具强制声明的模块路径和使用者的导入路径的一致性。如果一个模块的 `go.mod` 文件读到 `module example.com/m`，那么使用者必须使用导入语句从该模块导入包，且必须以模块路径开头(如 `import "example.com/m"` 或`import "example.com/m/sub/pkg"`)
- 如果使用者的导入路径和对应的声明模块路径出现不匹配，go 命令会报错 `parsing go.mod: unexpected module path`。此外，在某些场景下，go 命令会之后再报一个更一般的错误 `error loading module requirements`
- 这个错误最常见的原因是如果有一个名字变化(如 `github.com/Sirupsen/logrus` 到 `github.com/sirupsen/logrus`)，或者如果一个模块有时通过两个不同于先前模块的名字(如 `github.com/golang/sync` 和建议的 `golang.org/x/sync`)
- 如果有一个仍然使用旧的名字或不规范的名字导入的依赖，而该依赖之后采用模块并在 `go.mod` 声明规范的名字，就会出现问题。这个错误可以在一次升级时触发，当此模块的升级版本声明了一个规范的模块路径，但是该路径不匹配旧的导入路径

#### 14.6.2 场景示例

- 当前有一个间接依赖 `github.com/Quasilyte/go-consistent`
- 此工程采用模块，然后将名字改成 `github.com/quasilyte/go-consistent`，这是一个破坏性的变化。GitHub 从旧名字导向新的名字
- 运行 `go get -u`，尝试升级所有的直接或间接依赖
- `github.com/Quasilyte/go-consistent` 尝试升级，但是最新的 `go.mod` 发现现在读到的是 `module github.com/quasilyte/go-consistent`
- 整个升级操作会失败，错误是：
  > go: github.com/Quasilyte/go-consistent@v0.0.0-20190521200055-c6f3937de18c: parsing go.mod: unexpected module path "github.com/quasilyte/go-consistent" go get: error loading module requirements

#### 14.6.3 解决方法

- 整个错误最常见的形式是
  > go: example.com/some/OLD/name@vX.Y.Z: parsing go.mod: unexpected module path "example.com/some/NEW/name"
- 如果浏览 `example.com/some/NEW/name` 仓库，可以检查最新发布版或 `master` 查看 `go.mod` 文件，是否在第一行声明 `module example.com/some/NEW/name`。如果是，示意看到的 `old module name` 和 `new module name` 问题
- 解决步骤
  - 1 检查自己的代码是否使用 `example.com/some/OLD/name`。如果是，更新代码使用 `module example.com/some/NEW/name`
  - 2 如果再升级时遇到这个错误，应该尝试 Go 的 tip 版本。此版本有更多针对性的的升级逻辑，通常可以绕过这个问题，且经常对于这种情况有更好的错误信息。**注意：**tip/1.13 和 1.12 的 `go get` 参数不同。比如获取 tip 并使用 tip 更新依赖的命令如下。因为这个有问题的旧的导入经常是在间接依赖，使用 tip 升级然后运行 `go mod tidy` 经常会升级过去有问题的版本，并且从 `go.mod` 移除有问题的版本，然后可以使用 Go1.12/1.11 进入正常状态

    ```sh
    go get golang.org/dl/gotip && gotip download
    gotip get -u all
    gotip mod tidy
    ```

  - 3 如果在执行 `go get -u foo`/`go get -u foo@latest` 时遇到这个错误，尝试移除 `-u`。`go get -u foo` 不仅仅只更新 `foo` 到最新版本，也会更新 `foo` 的所有直接或间接依赖到最新版本。但是 `foo` 的一些直接或间接依赖可能没有使用 semver 或模块
  - 4 如果上述步骤没有解决问题，下一个方法可能会比较复杂，但是大多数情况可以解决这类问题。这个方法只是有错误信息，以及简单浏览 VCS 历史
    - 4.1 进入 `example.com/some/NEW/name` 仓库
    - 4.2 确定何时引入 `go.mod` 文件(比如使用 [git blame](https://www.git-scm.com/docs/git-blame) 或 [git log](https://www.git-scm.com/docs/git-log) 命令查看 `go.mod` 的修改历史)
    - 4.3 选中 `go.mod` 被引入的前一次提交或发布
    - 4.4 在你的 `go.mod` 增加一个 `replace` 语句，`reolace` 两边都使用旧名字：`replace example.com/some/OLD/name => example.com/some/OLD/name <version-just-before-go.mod>`。
      - 在前述的场景示例中，旧名字是 `github.com/Quasilyte/go-consistent`，新名字是 `github.com/quasilyte/go-consistent`，可以看到 `go.mod` 在 [00c5b0cf371a](https://github.com/quasilyte/go-consistent/tree/00c5b0cf371a96059852487731370694d75ffacf) 被引入
      - 该仓库没有使用 semver 标签，因此我们必须选取前一次提交 [00dd7fb039e](https://github.com/quasilyte/go-consistent/tree/00dd7fb039e1eff09e7c0bfac209934254409360)，并且使用旧的大写 Quasilyte 到 `replace` 两侧：`replace github.com/Quasilyte/go-consistent => github.com/Quasilyte/go-consistent 00dd7fb039e`
    - 这个 `replace` 语句使我们可以通过有效地阻止旧名字升级到 `go.mod` 出现的新名字而越过新旧名字不匹配的问题实现升级。通常，现在通过 `go get -u` 或类似命令升级可以避免这样的错误。如果完成升级，可以检查是否仍有代码使用旧名字导入(如 `go mod graph | grep github.com/Quasilyte/go-consistent`)，如果没有，可以移除 `repalce` 指令。
      - 这样经常生效的原因是如果使用有问题的旧导入路径，升级本身会失败。即使升级完成最后也不会使用这个路径
  - 5 如果上述路径没有解决问题，可能因为某些当前依赖的最新版本中仍在使用有问题的旧导入路径。这种情况下，需要识别出谁仍在使用旧的路径，并且找出或者打开一个 issue 请求这个有问题的导入者修改代码使用规范路径。使用前述的 `gotip` 可能识别出有问题的导入者，但是并不是所有场景有用，尤其是升级的情况。如果不确定谁在使用旧路径导入，通常可以通过创建一个干净的模块缓存找出来，执行出问题的操作，然后在模块缓存中 grep 有问题的导入路径。比如

    ```sh
    export GOPATH=$(mktemp -d)
    go get -u foo               # peform operation that generates the error of interest
    cd $GOPATH/pkg/mod
    grep -R --include="*.go" github.com/Quasilyte/go-consistent
    ```

  - 6 如果这些步骤不足以解决问题，或者你是一个项目的维护者，且似乎因为循环引用不能移除旧路径的引用，可以[参考](https://github.com/golang/go/wiki/Resolving-Problems-From-Modified-Module-Path)
- 最后，上述步骤致力于如果解决一个底层的新旧名字问题。然而，如果 `go.mod` 被放置在错误的位置或简单的是因为错误的模块路径，这会出现相同的问题。在这种情况下，导入该模块总会失败。如果你正在导入你刚刚新建的模块，且之前从未成功导入过，你应当检查 `go.mod` 被正确放置且有对应的合适的模块路径。
  - 最常见的方法是一个仓库一个 `go.mod`，且是在仓库根目录放置单一的 `go.mod` 文件。并且使用仓库名字作为文件中声明的 `module` 指令的模块路径

### 14.7 为什么 go build 要求 gcc？为什么预编译包(如 net/http) 不用

- 因为预编译包是非模块的(对 GOPATH 有效)，因此不能被重复使用。即在模块模式时需要重新编译标准库的包
- 这个问题只在加入模块时出现，对于 Go1.11 可以禁用 `cgo`(如 `GO111MODULE=on CGO_ENABLED=0 go build`) 或者安装 gcc

### 14.8 模块能否在相对导入路径(如 import "./subdir")正常工作

- 不能。在模块中，子目录最终会有一个名字。如果当前目录是 `module m`，那么导入的子目录就是 `m/subdir`，不再是 `./subdir`

### 14.9 某些需要的文件可能不在定位的 vendor 目录

- `go mod vendor` 不会拷贝没有 `.go` 文件的目录到 `vendor`。设计如此
- 对于传统的 vendor：检查模块缓存

## 15 相关链接

- [Go module wiki](https://github.com/golang/go/wiki/Modules)
- [Modules and vendoring](https://tip.golang.org/cmd/go/#hdr-Modules_and_vendoring)
- [List of go module knobs for controlling CI, vendoring, and when go commands access the network](https://github.com/thepudds/go-module-knobs/blob/master/README.md)
- [module 工具](https://golang.org/doc/go1.13#modules)
