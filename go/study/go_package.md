# go 包

- [go 包](#go-%e5%8c%85)
  - [package](#package)
  - [默认导入](#%e9%bb%98%e8%ae%a4%e5%af%bc%e5%85%a5)
  - [导出包内标识符](#%e5%af%bc%e5%87%ba%e5%8c%85%e5%86%85%e6%a0%87%e8%af%86%e7%ac%a6)
  - [导入包的重命名](#%e5%af%bc%e5%85%a5%e5%8c%85%e7%9a%84%e9%87%8d%e5%91%bd%e5%90%8d)
    - [Go 编译速度快](#go-%e7%bc%96%e8%af%91%e9%80%9f%e5%ba%a6%e5%bf%ab)
  - [导入匿名包](#%e5%af%bc%e5%85%a5%e5%8c%bf%e5%90%8d%e5%8c%85)
  - [包的初始化入口 init](#%e5%8c%85%e7%9a%84%e5%88%9d%e5%a7%8b%e5%8c%96%e5%85%a5%e5%8f%a3-init)
  - [内部包](#%e5%86%85%e9%83%a8%e5%8c%85)
  - [包的文档化](#%e5%8c%85%e7%9a%84%e6%96%87%e6%a1%a3%e5%8c%96)

## package

- `package pkg_name`定义程序属于哪个包，每个 go 文件第一行
- package 用于组织 go 的源码改善可用性和易读性，提供代码的模块化
- 代码包的导入路径是相对于 Go 语言自身的源码目录（即 `$GOROOT/src`）或在环境变量 `GOPATH` 中指定的某个目录的 `src` 子目录下的子路径，使用 `/` 分隔路径
- 导入的包名使用双引号包围，习惯上将文件夹的最后一个元素命名与包名一致。例外的情况
  - 如果某包定义一条命令(可执行的 Go 程序)，那么总是使用 `main`。这是告诉 `go build` 必须调用链接器生成可执行文件
  - 目录中一些文件以 `test.go` 结尾，包名会以 `_test` 结尾，这是外部测试包。其他的文件是普通包。`_test` 后缀告诉 `go test` 两个包都需要构建，并指明文件属于哪个包
    - 外部测试包用于避免测试所依赖的导入图中的循环依赖
  - 一些依赖管理工具会在包导入路径末尾追加版本号，包名仍然不包含版本号后缀

## 默认导入

- 单行导入：`import pkg_name` 导入包
- 多行导入：导入多个包时，建议使用 `()` 将导入的包放在一起，即分组导入
- 包分组：导入的包之间通过添加空行分组。通常将来自不同组织的包独立分组。包的导入顺序无关紧要，但是在每个分组中一般会根据字符串顺序排列

## 导出包内标识符

- 导出名：首字母大写的名字是导出的名字，首字母小写只能包内使用。导入包之后只能使用包导出的名字

## 导入包的重命名

- 导入包后可以自定义引用的包名
- 导入包的重命名：如果同时导入两个名字相同的包，那么导入声明必须至少为一个同名包指定一个新的包名避免冲突

  ```go
  import (
    "crypto/rand"
    mrand "math/rand"
  )
  ```

- 导入包的重命名只影响当前源文件。其它的源文件如果导入了相同的包，可以用导入包原本默认的名字或重命名为另一个完全不同的名字
- 导入包重命名不仅仅只是为了解决名字冲突。如果导入的一个包名很笨重，特别是在一些自动生成的代码中，这时候用一个简短名称会更方便
  - 选择用简短名称重命名导入包时候最好统一，以避免包名混乱
  - 选择另一个包名称还可以帮助避免和本地普通变量名产生冲突
- 每个导入声明语句都明确指定了当前包和被导入包之间的依赖关系。如果遇到包循环导入的情况，Go语言的构建工具将报告错误

### Go 编译速度快

- 有三个主要原因
  - 所有的导入必须在每一个源文件的开头进行显示列出，这样编译器不需要读取和处理整个文件来确定依赖性
  - 包的依赖性形成有向无环图，因为没有环，包可以独立甚至并行编译
  - Go 包编译输出的目标文件不仅记录它自己的导出信息，也记录所依赖包的导出信息。当编译一个包时，编译器对于每一个导入必须读取一个目标文件，但是不需要超出这些文件

## 导入匿名包

- go 导入一个包之后不在代码中使用是不合法的
  - 导入包，只需要调用包中的 init 函数：在包名之前加下划线和空格`import _  pkg_name`
  - 暂时导入包，之后才会需要，建议在 import 之后紧跟语句`var _ = pkg_name.SomeFunc // error silencer`，此语句可避免编译错误
    - 在真正使用包中的代码之后就删掉此语句

## 包的初始化入口 init

- init 函数用于执行初始化任务，或者在执行之前验证程序的正确性
- init 函数的特性
  - 每个源码可以使用 1 个 init 函数
  - init 函数会在程序执行前(main 函数执行前)被自动调用
  - 调用顺序为 main 中引用的包，以深度优先顺序初始化
    - 假设包的引用关系 `main->A->B->C`，那么这些包的 init 函数调用顺序为 `C.init->B.init->A.init->main`
  - 同一个包中的多个 init 函数的调用顺序不可预期
  - init 函数不应有返回值，不应包括任何参数，不能在源码中显式调用
- 包的初始化顺序
  - 初始化包级别的变量
  - 调用 init 函数，如果有多个 init 函数（在一个或多个文件中），按照编译器接收顺序调用：go 会从 main 包开始检查其引用的所有包，每个包也可能包含其他的包。编译器由此构建出一个树状的包引用关系，再根据引用顺序决定编译顺序，依次编译这些包的代码。在运行时，被最后导入的包会最先初始化并调用 init 函数
  - 导入的包先初始化
- 每个包只初始化一次

- geometry.go

  ```go
  package main

  import (
    "fmt"
    "geometry/rectangle"
    "log"
  )

  var recLen, recWidth float64 = 3, -4

  func init() {
    fmt.Println("Geometry init func")
    if recLen < 0 {
      log.Fatal("length is less than zero")
    }

    if recWidth < 0 {
      log.Fatal("width is less than zero")
    }
  }

  func main() {
    fmt.Println("Geometry main func")
    fmt.Println("rectangle area: %.2f", rectangle.Area(recLen, recWidth))
    fmt.Println("rectangle diagonal: %.2f", rectangle.Diagonal(recLen, recWidth))
  }
  ```

- rectangle.go

  ```go
  package rectangle

  import (
    "fmt"
    "math"
  )

  func init() {
    fmt.Println("Rectangle init func")
  }

  func Area(len, width float64) float64 {
    area := len * width
    return area
  }

  func Diagonal(len, width float64) float64 {
    diagonal := math.Sqrt(len*len + width*width)
    return diagonal
  }
  ```

## 内部包

- 内部包只能被另一个包导入。这个包位于以 internal 目录的父目录为根目录的树中
- 内部包可以不需要导出标识符就可以被满足条件的包访问
- 例如有下面的文件夹 `net/http` `net/http/internal/chunked` `net/http/httputil` `net/url`
  - `net/http/httputil` 和 `net/http` 可以导入 `net/http/internal/chunked`
  - `net/url` 不可以导入 `net/http/internal/chunked`
  - `net/url` 可以导入 `net/http/httputil`

## 包的文档化

- 文档注释是完整的语句，使用声明的包名作为开头的第一句注释通常是总结
  - 可以出现在任何文件，但是必须只有一个
  - 文件名通常是 `doc.go`
- 函数参数和其他的标识符不用括号或特别标注
