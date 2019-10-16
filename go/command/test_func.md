# 测试函数

`go test` 命令预期查找对应测试包的 “*_test.go” 文件中的测试函数、基准测试函数和示例函数。

测试函数命名为 TestXxx(Xxx 不以小写字母开始)，且应当有签名

```go
func TestXxx(t *testing.T) { ... }
```

一个基准测试函数命名为 BenchmarkXxx，且应该有签名

```go
func BenchmarkXxx(b *testing.B) { ... }
```

一个示例函数，类似于测试函数，但不使用 *testing.T 报告成功或失败，而是打印输出到 os.Stdout。如果函数内最后的注释以 “Output:” 开头，那么输出与注释精确比较(看下面的例子)。如果最后的注释以 “Unordered output:” 开始，那么输出和注释做比较，但是忽视行的顺序。一个不带这样的注释的示例被编译但是不执行。一个在 “Output:” 之后没有文本的示例会被编译、执行并预期不会生成输出。

Godoc 显示 ExampleXxx 的消息体来演示函数、常量或变量 Xxx 的使用。一个接收类型是 T 或 *T 的方法 M 的示例函数命名为 ExampleT_M。对于一个给定的函数、常数或变量可能有多个示例，通过后缀 _xxx 区分，xxx 是一个不以大写字母开始的后缀。

有一个示例函数的例子：

```go
func ExamplePrintln() {
  Println("The output of\nthis example.")
  // Output: The output of
  // this example.
}
```

另外一个忽视输出顺序的例子：

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

当文件包含一个单独的示例函数，及至少一个其他的函数、类型、变量或常数声明，且没有测试函数或者基准测试函数时，整个测试文件作为例子显示。

查看 [testing 包的文档](../wiki/golangpkg/testing.md)查看更多信息。
