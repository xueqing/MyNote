# 如何写 Go 代码

- [如何写 Go 代码](#%e5%a6%82%e4%bd%95%e5%86%99-go-%e4%bb%a3%e7%a0%81)
  - [介绍](#%e4%bb%8b%e7%bb%8d)
  - [代码组织](#%e4%bb%a3%e7%a0%81%e7%bb%84%e7%bb%87)
    - [概览](#%e6%a6%82%e8%a7%88)
    - [工作区](#%e5%b7%a5%e4%bd%9c%e5%8c%ba)
    - [GOPATH 环境变量](#gopath-%e7%8e%af%e5%a2%83%e5%8f%98%e9%87%8f)
    - [导入路径](#%e5%af%bc%e5%85%a5%e8%b7%af%e5%be%84)
    - [第一个程序](#%e7%ac%ac%e4%b8%80%e4%b8%aa%e7%a8%8b%e5%ba%8f)
    - [第一个库](#%e7%ac%ac%e4%b8%80%e4%b8%aa%e5%ba%93)
    - [包名](#%e5%8c%85%e5%90%8d)
  - [测试](#%e6%b5%8b%e8%af%95)
  - [远程包](#%e8%bf%9c%e7%a8%8b%e5%8c%85)
  - [下一步](#%e4%b8%8b%e4%b8%80%e6%ad%a5)
  - [获取帮助](#%e8%8e%b7%e5%8f%96%e5%b8%ae%e5%8a%a9)

参考 [Golang 官网文档](https://golang.org/doc/code.html) 学习。

## 介绍

此文档演示一个简单的 Go 包 的发展，并介绍 [`go 工具`](../command/README.md)。go 工具是拉取、编译和安装 Go 包 和目录的标准方式。

go 工具要求你按照指定方式组织你的代码。请仔细阅读此文档。它解释了使用 Go 安装组织和运行的最简单的方式。

一个类似的解释可参考 [编写、编译、安装和测试 Go 代码](https://www.youtube.com/watch?v=XCsL89YtqCs)。

## 代码组织

### 概览

- Go 开发人员通常保存他们所有的 Go 代码在一个单一的工作区。
- 一个工作区包含很多版本控制仓库(比如使用 Git 管理)。
- 每个仓库包含一个或多个包。
- 每个包由同一目录的一个或多个 Go 源文件组成。
- 包目录的路径确定了导入路径。

注意这个其他编程环境不同。其他编程环境的每个工程有一个单独的工作区，且工作去和版本控制仓库紧密相关。

### 工作区

一个工作区是一个目录层次架构，在其根有两个目录：

- src 包含 Go 源文件，且
- bin 包含可执行命令。

go 工具编译和安装二进制到 bin 目录。

src 子目录通常包含多个版本控制仓库(比如 Git 或 Mercurial)，跟踪了一个或多个源包的发展。

为了让你理解一个工作区实际上的组织，这里有一个例子：

```txt
bin/
  hello                      # command executable
  outyet                     # command executable
src/
  github.com/golang/example/
    .git/                    # Git repository metadata
    hello/
      hello.go               # command source
    outyet/
      main.go                # command source
      main_test.go           # test source
    stringutil/
      reverse.go             # package source
      reverse_test.go        # test source
  golang.org/x/image/
    .git/                    # Git repository metadata
    bmp/
      reader.go              # package source
      writer.go              # package source
  ... (many more repositories and packages omitted) ...
```

上述树显示一个工作区有两个仓库(example 和 image)。example 仓库包含两个命令(hello 和 outyet)和一个库(stringutil)。image 仓库包含 bmp 包和[其他的包](https://godoc.org/golang.org/x/image)。

一个普通的工作区包含许多源仓库，这些仓库包含一些包和命令。大多数 Go 开发人员保存他们所有的 Go 源代码和依赖在一个单一的工作区。

注意符号链接不应当用于链接文件或目录到你的工作区。

命令和库由不同的源包编译。我们之后会讨论[区别](#包名)。

### GOPATH 环境变量

GOPATH 环境变量指定你的工作区位置。默认是你的主目录下名字为 go 的目录，因此在 Unix 上是 $HOME/go，Plan9 上是 $home/go，Windows 上是 %USERPROFILE%\go (通常是 C:\Users\YourName\go)。

如果你想要在不同的位置工作，你需要[设置 GOPATH](../setgopath.md) 到那个目录。(另外一个常用的设置是设置 GOPATH=$HOME)。注意 GOPATH 一定不能和你的 Go 安装路径相同。

命令 `go env GOPATH` 打印实际的当前的 GOPATH；如果该环境变量没有设置，它会打印默认的位置。

方便起见，增加工作区的 bin 子目录到你的 PATH：

```sh
export PATH=$PATH:$(go env GOPATH)/bin
```

简洁起见，这个脚本在文档的其他部分使用 $GOPATH 而不是 $(go env GOPATH)。如果你还未设置 GOPATH，为了使得所写的脚本可允许，可以使用 $HOME/go 替换这些命令或者运行

```sh
export GOPATH=$(go env GOPATH)
```

要了解更多关于 GOPATH 环境变量，参考 [`go help gopath`](../command/gopath_env_var.md)。

要使用自定义的工作区位置，[设置 GOPATH 环境变量](../setgopath.md)。

### 导入路径

导入路径是一个唯一的标识一个包的字符串。一个包的导入路径对应它在工作区或远程仓库内的位置(下面会解释)。

标准库的包使用短的导入路径类似 “fmt” 和 “net/http”。对于你自己的包，你必须选择一个基础路径，该路径不太可能与将来增加的标准库或其他外部库冲突。

如果你将代码保存在其他地方的源仓库，那么你应该使用该源码库的根作为你的基础路径。比如，如果你有一个 Github 账户位于 github.com/user，那么 github.com/user 应该是你的基础路径。

注意在你可以编译代码之前，你不需要发布你的代码到一个远程仓库。这只是一个组织代码的好习惯以便某天你会发布它。实际上你可以选择任意的路径名字，只要它对于标准库和更大的 Go 生态系统是唯一的。

我们将会使用 github.com/user 作为我们的基础路径。在你的工作区内新建一个目录来保存源码：

```sh
mkdir -p $GOPATH/src/github.com/user
```

### 第一个程序

为了编译和运行一个简单的程序，首先选择一个包路径(我们将会使用 github.com/user/hello)，并且在你的工作区内创建一个对应的包目录：

```sh
mkdir $GOPATH/src/github.com/user/hello
```

接下来，在目录内部创建一个名为 hello.go 的文件，包含下面的 Go 代码。

```go
package main

import "fmt"

func main() {
  fmt.Println("Hello, world.")
}
```

现在你可以使用 go 工具编译和安装这个程序：

```sh
go install github.com/user/hello
```

注意你可以在你的系统任何地方运行这个命令。go 工具通过在 GOPATH 指定的工作区内查找 github.com/user/hello 包找到源码。

如果你从包目录运行 `go install`，你也可以忽视包路径：

```sh
cd $GOPATH/src/github.com/user/hello
go install
```

这个命令编译 hello 命令，生成可执行的二进制文件。它接着安装该二进制文件到工作区的 bin 目录，安装的文件名字是 hello(或者在 Windows 上是 hello.exe)。在我们的例子中，该文件将会是 $GOPATH/bin/hello，也就是 $HOME/go/bin/hello。

发生错误时，go 工具只会打印输出。因此如果这些命令没有生成输出，那么这些命令已经被正确执行。

你现在可以通过在命令行输入程序的完整路径来运行它：

```sh
$ $GOPATH/bin/hello
Hello, world.
```

或者，因为你已经添加 $GOPATH/bin 到你的 PATH，只需要输入二进制文件的名字：

```sh
$ hello
Hello, world.
```

如果你在使用一个源码控制系统，现在将是一个好的时机来初始化一个仓库，增加这些文件，并提交你的第一次修改。重申一次，这一步是可选的：你不必使用源码控制来写 Go 代码。

```sh
cd $GOPATH/src/github.com/user/hello
git init
git add hello.go
git commit -m "initial commit"
```

推送代码到远程仓库留作读者的一个练习。

### 第一个库

让我们编写一个库，并在 hello 程序使用它。

重申一次，第一步是选择一个包路径(我们将会使用 github.com/user/stringutil)并创建一个包目录：

```sh
mkdir $GOPATH/src/github.com/user/stringutil
```

接下来，在该目录创建一个名为 reverse.go 的文件，包含下面的内容。

```go
// Package stringutil contains utility functions for working with strings.
package stringutil

// Reverse returns its argument string reversed rune-wise left to right.
func Reverse(s string) string {
  r := []rune(s)
  for i, j := 0, len(r)-1; i < len(r)/2; i, j = i+1, j-1 {
    r[i], r[j] = r[j], r[i]
  }
  return string(r)
}
```

现在，使用 `go build` 编译测试这个包：

```sh
go build github.com/user/stringutil
```

或者，如果你正在包的源目录，只需要：

```sh
go build
```

这不会生成一个输出文件。反之，它将编译的包保存在本地的编译缓存。

在确认编译 stringutil 包之后，修改你原始的 hello.go(在 $GOPATH/src/github.com/user/hello)，使用下面的内容：

```go
package main

import (
  "fmt"

  "github.com/user/stringutil"
)

func main() {
  fmt.Println(stringutil.Reverse("!oG ,olleH"))
}
```

安装 hello 程序：

```sh
go install github.com/user/hello
```

运行这个程序的新版本，你应该看到一个新的、翻转的消息：

```sh
$ hello
Hello, Go!
```

上述步骤之后，你的工作区应该看起来是下面的结构：

```txt
bin/
  hello                 # command executable
src/
  github.com/user/
    hello/
      hello.go      # command source
    stringutil/
      reverse.go    # package source
```

### 包名

Go 源文件的第一个语句必须是

```go
package name
```

其中，name 是用于导入包的默认名字。(包内的所有文件必须使用这个名字。)

Go 的管理是包名是导入路径的最后一个元素：按照 “crypto/rot13” 导入的包名应该命名为 rot13。

可执行的命令必须总使用 `package main`。

不需要包名在链接所有包成一个单一的二进制文件时是唯一的，只要它的导入路径(完整的文件名)是唯一的。

查看[实效 Go 编程](effective_go.md#名字)了解更多关于 Go 的命名惯例。

## 测试

Go 有一个轻量级的测试矿机，由 `go test` 命令和 testing 包组成。

你通过新建一个以 _test.go 结尾的文件编写测试，文件包含名字为 TestXXX，签名为 `func (t *testing.T)` 的函数。测试跨更加运行每个这样的函数；如果函数调用一个失败函数，如 t.Error 或 t.Fail，认为该测试失败。

向 stringutil 包增加一个测试，新建文件 $GOPATH/src/github.com/user/stringutil/reverse_test.go，包含下面的代码

```go
package stringutil

import "testing"

func TestReverse(t *testing.T) {
  cases := []struct {
    in, want string
  }{
    {"Hello, world", "dlrow ,olleH"},
    {"Hello, 世界", "界世 ,olleH"},
    {"", ""},
  }
  for _, c := range cases {
    got := Reverse(c.in)
    if got != c.want {
      t.Errorf("Reverse(%q) == %q, want %q", c.in, got, c.want)
    }
  }
}
```

然后使用 `go test` 运行测试：

```sh
$ go test github.com/user/stringutil
ok    github.com/user/stringutil 0.165s
```

和平时一样，如果你在包目录运行 go 工具，可以忽视包路径

```sh
$ go test
ok    github.com/user/stringutil 0.165s
```

运行 [`go help test`]((../command/test_package.md)) 并查看 [testing 包文档](../golangpkg/testing.md) 获取更多信息。

## 远程包

导入路径可以描述如何使用版本控制系统(如 Git 或 Mercurial)获取包源码。go 工具使用这个属性从远程仓库自动拉取代码。比如，文档中描述的例子也保存在 [Github](https://github.com/golang/example) 托管的 Git 仓库。如果你在包的导入路径包含这个仓库的 URL，`go get` 会自动拉取、编译和运行它：

```sh
go get github.com/golang/example/hello
$GOPATH/bin/hello
# Hello, Go examples!
```

如果指定的包没有出现在工作区，`go get` 会放置在 GOPATH 指定的第一个工作区。(如果包以及存在，`go get` 会跳过远程拉取，行为类似于 `go install`。)

在执行上述 `go get` 命令只会，工作区目录树应该看起来是下面的结构：

```txt
bin/
    hello                     # command executable
src/
  github.com/golang/example/
    .git/                     # Git repository metadata
    hello/
      hello.go                # command source
    stringutil/
      reverse.go              # package source
      reverse_test.go         # test source
  github.com/user/
    hello/
      hello.go                # command source
    stringutil/
      reverse.go              # package source
      reverse_test.go         # test source
```

Github 托管的 hello 命令依赖相同仓库的 stringutil 包。hello.go 文件中的导入使用相同的导入路径惯例，因此 `go get` 命令也可以定位和安装依赖依赖包。

```go
import "github.com/golang/example/stringutil"
```

此惯例是使得你的 Go 包被其他人可用的最简单的方式。[Go 维基](https://github.com/golang/go/wiki/Projects) 和 [go 官方文档](https://godoc.org/) 提供了外部 Go 过程的列表。

要获取更多关于借助 go 工具使用远程仓库的信息，查看[远程导入路径](../command/remote_import_path.md)。

## 下一步

订阅 [golang 宣传](https://groups.google.com/group/golang-announce) 邮件列表，接受发行新的稳定版本 Go 的通知。

查看[实效 Go 编程](effective_go.md)了解更多关于编写清楚、惯用的 Go 代码的建议。

访问 [Go 语言之旅](https://tour.golang.org/) 学习语言规则。

访问[官方文档](README.md#文章)查看关于 Go 语言及其库和工具的全面深入的文章。

## 获取帮助

需要实时帮助，询问有帮助的 gopher ，它位于 [FreeNode](https://freenode.net/) IRC 服务的 #go-nuts。

关于 Go 语言讨论的官方邮件列表在 [Go Nuts](https://groups.google.com/group/golang-nuts) 群组。

使用 [Go issue 跟踪](https://github.com/golang/go/issues)报告错误。
