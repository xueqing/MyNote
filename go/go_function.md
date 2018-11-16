# go 函数

- 函数是基本的代码块，用于执行一个任务
- 最少有一个 main 函数
- 可通过函数划分不同功能，逻辑上每个函数执行指定的任务
- 函数声明包含名称、返回类型和参数
- 定义
  - 参数可选，类似于占位符，是函数的形参
    - 值传递：调用函数时将实际参数复制一份传递给函数，函数内修改参数不会影响实际参数
    - 引用传递：调用函数时传递参数的地址，函数内修改参数会影响到实际的值
    - 默认使用值传递
  - 返回类型可选

```go
func func_name( [param_list] ) [return_types] {
    // func_body
}
```

- 函数用法
  - 函数作为值，即定义后作为值使用

    ```go
    getSquareRoot := func(x float64) float64 {
        return math.Sqrt(x)
    }
    fmt.Println(getSquareRoot(9))
    ```

  - 闭包，即匿名函数，在动态编程中使用
    - 匿名函数是一个“内联”语句或表达式，其优越性在于可以直接使用函数内的变量，不比声明

    ```go
    func getSequence() func() int {
        i := 0
        return func() int {
            i += 1
            return i
        }
    }

    nextNum := getSequence() //i=0
    fmt.Println(nextNum()) //i=1
    fmt.Println(nextNum()) //i=2
    fmt.Println(nextNum()) //i=3

    nextNum1 := getSequence() //i=0
    fmt.Println(nextNum1()) //i=1
    fmt.Println(nextNum1()) //i=2

    ```

  - 方法，是一个包含了接收者的函数，接收者可以是命名类型或者结构体类型的一个值或一个指针。所有给定类型的方法属于该类型的方法集
    - 语法格式

    ```go
    func (v_name v_type) func_name() [return_type] {
        //func body
    }
    ```

    - 示例

    ```go
    type Circle struct {
        radius float64
    }

    func (c Circle) getArea() float64 {
        return 3.14 * c.radius * c.radius
    }

    var c1 Circle
    c1.radius = 10.00
    fmt.Println(c1.getArea())
    ```