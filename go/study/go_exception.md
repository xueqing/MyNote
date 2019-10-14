# 异常处理

- [异常处理](#%e5%bc%82%e5%b8%b8%e5%a4%84%e7%90%86)
  - [defer 使用](#defer-%e4%bd%bf%e7%94%a8)
    - [defer 栈](#defer-%e6%a0%88)
  - [panic 使用](#panic-%e4%bd%bf%e7%94%a8)
  - [recover 使用](#recover-%e4%bd%bf%e7%94%a8)

- Go 不支持 try..catch..finally 这种异常。使用多值返回来返回错误
- 在极端情况下才用异常（如除数为 0），异常处理使用了 defer，panic，recover
- go 可以抛出一个 panic 的异常，在 defer 中通过 recover 捕获异常，然后处理

## defer 使用

- defer 的参数值是在执行 defer 语句的地方立即计算的，而不是在调用实际函数的时候计算，但是会在对应环境返回时调用函数
- 应用场景：与代码流无关必须执行的函数或方法调用
  - 等待并发结束
  - 打开一些资源的时候，遇到错误需要提前返回，在返回前需要关闭对应的资源

    ```go
    func readWritFile() bool {
        file.open("file")
        defer file.close()

        if faiure1 {
            return false
        }

        if failure2 {
            return false
        }

        return true
    }
    ```

### defer 栈

- 可以在函数中添加多个 defer 语句。当函数执行到最后，返回之前，会逆序执行这些语句，类似一个 defer 栈

  ```go
  package main

  import (
      "fmt"
  )

  func main() {
      fmt.Println("counting")

      for i := 0; i < 10; i++ {
          defer fmt.Println(i)
      }

      fmt.Println("done")
  }
  ```

## panic 使用

- panic 用来表示非常严重的不可恢复的错误。是一个内置函数
- 函数执行到 panic，不会继续执行，但是会执行 defer 的代码，之后将控制转移给调用者，向上传递，直至遇到打印 panic 消息，打印堆栈，然后终止
- 场景 1：一个不可恢复的错误,程序不能继续执行。如 web 服务不能绑定端口
- 场景 2：编程错误，如空指针访问

## recover 使用

- 在 panic 之后，执行 defer 的时候可以将 panic 捕获，阻止 panic 向上传递。
- 在 defer 的地方调用 recover 函数，如果有 panic，被捕获的 panic 就不会向上传递，defer 处理完之后返回
  - recover 只在 defer 中调用才有用
  - 只有在相同的 goroutine 中调用 recover 才有效
  - 运行时的 panic 也可用 recover 捕获恢复
  - 在 recover 之后会丢失堆栈，可在 recover 中获取和打印堆栈，使用`debug.PrintStack()`打印堆栈

```go
package main

import "fmt"

func caller() {
    fmt.Println("Enter caller")
    defer func() { //先声明 defer
        fmt.Println("Enter func")
        if err := recover(); err != nil {
            fmt.Println(err) //打印 panic 传入的内容
        }
        fmt.Println("Leave func")
    }()
    callee()
    fmt.Println("Leave caller")
}

func callee() {
    fmt.Println("Enter callee")
    panic(-1)
    fmt.Println("Leave callee")
}

func main() {
    caller()
}
```

输出结果是

```txt
Enter caller
Enter callee
Enter func
-1
Leave func
```
