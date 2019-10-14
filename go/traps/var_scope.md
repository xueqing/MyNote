# 作用域

- 编译器遇到一个名字的引用时，从最内层的封闭词法块到全局块寻找其声明
  - 没有找到会报 “undeclared name” 错误
  - 内层和外层都存在声明时，内层的先被找到。此时内层声明会覆盖外部声明，外部声明将不可访问
- **短变量声明**依赖一个明确的作用域。下面的代码容易覆盖全局声明的 `cwd`
  - 因为 cwd 和 err 在函数块内部都尚未声明，所以 `:=` 语句将它们视为局部变量。内存 cwd 声明使得外部声明不可见
  - 解决方法是不使用 `:=`，而是使用 `var` 声明变量

    ```go
    package main

    import (
      "fmt"
      "os"
    )

    var cwd string

    func main() {
      cwd, err := os.Getwd() //compile error: cwd declared and not used
      if err != nil {
        fmt.Printf("err=%s\n", err)
      }
    }
    ```
