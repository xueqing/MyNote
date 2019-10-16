# testing 包

- [testing 包](#testing-%e5%8c%85)
  - [概述](#%e6%a6%82%e8%bf%b0)
    - [基准测试](#%e5%9f%ba%e5%87%86%e6%b5%8b%e8%af%95)
    - [示例函数](#%e7%a4%ba%e4%be%8b%e5%87%bd%e6%95%b0)
    - [跳过测试](#%e8%b7%b3%e8%bf%87%e6%b5%8b%e8%af%95)
    - [子测试项目和子基准测试](#%e5%ad%90%e6%b5%8b%e8%af%95%e9%a1%b9%e7%9b%ae%e5%92%8c%e5%ad%90%e5%9f%ba%e5%87%86%e6%b5%8b%e8%af%95)
    - [Main](#main)
  - [索引](#%e7%b4%a2%e5%bc%95)
  - [例子](#%e4%be%8b%e5%ad%90)
  - [子目录](#%e5%ad%90%e7%9b%ae%e5%bd%95)

参考 [Golang 官网文档](https://golang.org/pkg/testing/) 学习。

导入语句：`import "testing"`

## 概述

testing 包提供对 Go 包的自动测试。它适用于和 `go test` 命令协作，自动执行下面格式的函数

```go
func TestXxx(*testing.T)
```

其中，Xxx 不是小写字母开头。这个函数名用于识别测试代码。

在这些函数中，使用 Error、Fail 或相关的方法来标记失败。

要写一个新的测试集，新建一个文件以 _test.go 结尾，其中包含上述的 TestXxx 函数。将此文件放在将要测试的同一包中。这个文件不会被正常的包编译包含，但是在运行 `go test` 命令时会包含。查看更多细节，运行 `go help test` 和 `go help testflag`。

一个简单的测试函数看起来像这样：

```go
func TestAbs(t testing.T) {
  got := Abs(-1)
  if got != 1 {
    t.Errorf("Abs(-1) = %d; want 1", got)
  }
}
```

### 基准测试

下面格式的函数被当做基准测试，并且当 `go test` 命令提供 -bench 标记时会执行此函数。基准测试是顺序执行的。

```go
func BenchmarkXxxx(*testing.B)
```

对 testing 标记的描述，查看 [Testing flags](https://golang.org/cmd/go/#hdr-Testing_flags)。

一个简单的基准测试函数看起来像这样：

```go
func BenchmarkHello(b *testing.B) {
    for i := 0; i < b.N; i++ {
        fmt.Sprintf("hello")
    }
}
```

基准测试函数必须运行目标代码 b.N 次。在执行基准测试期间，会调整 b.N 直到基准测试函数持续时间足够长，认为是时间可靠的。输出 `BenchmarkHello    10000000    282 ns/op` 意味着这个循环以每次循环 282 纳秒的速度运行了 10000000 次。

如果一个基准测试在运行之前需要一些耗时的设置，可重置定时器：

```go
func BenchmarkBigLen(b *testing.B) {
    big := NewBig()
    b.ResetTimer()
    for i := 0; i < b.N; i++ {
        big.Len()
    }
}
```

如果一个基准测试需要并行测试性能，可以使用 RunParallel 辅助函数；这样的基准测试适用于和 go test -cpu 标识一起使用：

```go
func BenchmarkTemplateParallel(b *testing.B) {
    templ := template.Must(template.New("test").Parse("Hello, {{.}}!"))
    b.RunParallel(func(pb *testing.PB) {
        var buf bytes.Buffer
        for pb.Next() {
            buf.Reset()
            templ.Execute(&buf, "World")
        }
    })
}
```

### 示例函数

testing 包也会运行和验证示例代码。示例函数可以包含一个总结性的行注释，以 “Output:” 开头，并且运行测试的是和这个函数的标准输出比较。(这个比较忽视开始和末尾的空格)。下面是一个示例代码的例子：

```go
func ExampleHello() {
    fmt.Println("hello")
    // Output: hello
}

func ExampleSalutations() {
    fmt.Println("hello, and")
    fmt.Println("goodbye")
    // Output:
    // hello, and
    // goodbye
}
```

- 注释前缀 “Unordered output:” 类似于 “Output:”，但是匹配任意的行顺序：

```go
func ExamplePerm() {
    for _, value := range Perm(4) {
        fmt.Println(value)
    }
    // Unordered output: 4
    // 2
    // 1
    // 3
    // 0
}
```

没有输出注释的示例函数被编译但是不会被执行。

声明包、函数 F、类型 T 和作用于类型 T 的方法 M 的示例函数的命名如下：

```go
func Example() { ... }
func ExampleF() { ... }
func ExampleT() { ... }
func ExampleT_M() { ... }
```

可通过增加一个不同的后缀到函数名字后面以支持对于一个包/类型/函数/方法的多个示例函数。后缀必须以小写字母开始。

```go
func Example_suffix() { ... }
func ExampleF_suffix() { ... }
func ExampleT_suffix() { ... }
func ExampleT_M_suffix() { ... }
```

当文件包含一个单独的示例函数，及至少一个其他的函数、类型、变量或常数声明，且没有测试函数或者基准测试函数时，整个测试文件作为例子显示。

### 跳过测试

可在运行时调用 *T 或 *B 的 Skip 方法跳过测试或基准测试：

```go
func TestTimeConsuming(t *testing.T) {
    if testing.Short() {
        t.Skip("skipping test in short mode.")
    }
    // ...
}
```

### 子测试项目和子基准测试

T 和 B 的 Run 方法允许定义子测试项目和子基准测试，而不需要为每个子测试项目和子基准测试定义另外的函数。这使能使用类似表驱动的基准测试和创建分级测试。它也提供了一种方式来共享共用的设置和终止代码：

```go
func TestFoo(t *testing.T) {
    // <setup code>
    t.Run("A=1", func(t *testing.T) { ... })
    t.Run("A=2", func(t *testing.T) { ... })
    t.Run("B=1", func(t *testing.T) { ... })
    // <tear-down code>
}
```

每个子测试项目和子基准测试有一个唯一的名字：结合顶层测试的名字以及传递给 Run 的名字的顺序，由斜线分隔，以及一个可选的尾随的序号以消除歧义。

传递给 -run 和 -bench 命令行标识符的参数是一个不固定的正则表达式，匹配了测试的名字。参数是多个斜线分隔的元素时，比如子测试，参数是自身(斜线分隔)；表达式匹配每个名字元素。因为是不固定的，一个空的表达式匹配任意字符串。比如，使用 “matching” 表达 “谁的名字包含”：

```sh
go test -run ''      # Run all tests.
go test -run Foo     # Run top-level tests matching "Foo", such as "TestFooBar".
go test -run Foo/A=  # For top-level tests matching "Foo", run subtests matching "A=".
go test -run /A=1    # For all top-level tests, run subtests matching "A=1".
```

子测试也可用于控制并行度。一个父测试只有在其子测试完成时才会完成。在这个例子中，所有测试去其他测试并行运行，且只与其他测试并行，而与可能定义的其他顶层测试无关。

```go
func TestGroupedParallel(t *testing.T) {
    for _, tc := range tests {
        tc := tc // capture range variable
        t.Run(tc.Name, func(t *testing.T) {
            t.Parallel()
            // ...
        })
    }
}
```

当程序超过 8192 个并行 goroutine 时，竞争检测器会杀掉程序，因此当运行并行测试且设置了 -race 标识时需要注意。

Run 只有在并行子测试结束才会返回，为一组并行测试之后的资源清理提供了一种方式。

```go
func TestTeardownParallel(t *testing.T) {
    // This Run will not return until the parallel tests finish.
    t.Run("group", func(t *testing.T) {
        t.Run("Test1", parallelTest1)
        t.Run("Test2", parallelTest2)
        t.Run("Test3", parallelTest3)
    })
    // <tear-down code>
}
```

### Main

测试程序有时需要在测试之前或之后做一些额外的设置和清理。并且，测试程序有时需要控制哪些代码运行在主线程。为了满足这些需求和其他的场景，一个测试文件可以包含一个函数：

```go
func TestMain(m *testing.M)
```

然后，生成的测试会调用 TestMain(m) 而不是直接运行测试。TestMain 在主的 goroutine 运行，且可以做调用 m.Run 前后所需的所有设置和清理。然后，它应该使用 m.Run 的结果调用 OS.Exit。当调用 TestMain 时，flag.Parse 还没有运行。如果 TestMain(包括这些测试包) 依赖命令行标识，应该显式调用 flag.Parse。

一个简单的 TestMain 的实现：

```go
func TestMain(m *testing.M) {
    // call flag.Parse() here if TestMain uses flags
    os.Exit(m.Run())
}
```

## 索引

[参考](https://golang.org/pkg/testing/#pkg-index)

## 例子

[参考](https://golang.org/pkg/testing/#pkg-examples)

## 子目录

| 名字 | 概述 |
| --- | --- |
| [iotest](iotest.md) | 实现了主要用于 testing 的 Reader 和 Writer |
| [quick](quick.md) | 实现了帮助黑盒测试的工具函数 |
