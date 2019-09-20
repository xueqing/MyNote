# go 函数

- [go 函数](#go-%e5%87%bd%e6%95%b0)
  - [函数 function](#%e5%87%bd%e6%95%b0-function)
  - [函数用法](#%e5%87%bd%e6%95%b0%e7%94%a8%e6%b3%95)
  - [函数值](#%e5%87%bd%e6%95%b0%e5%80%bc)
    - [匿名函数](#%e5%8c%bf%e5%90%8d%e5%87%bd%e6%95%b0)
    - [可变函数 variadic function](#%e5%8f%af%e5%8f%98%e5%87%bd%e6%95%b0-variadic-function)
  - [方法 vs 函数](#%e6%96%b9%e6%b3%95-vs-%e5%87%bd%e6%95%b0)
    - [方法的值接收者 vs 函数的值参数](#%e6%96%b9%e6%b3%95%e7%9a%84%e5%80%bc%e6%8e%a5%e6%94%b6%e8%80%85-vs-%e5%87%bd%e6%95%b0%e7%9a%84%e5%80%bc%e5%8f%82%e6%95%b0)
    - [方法的指针接收者和函数的指针参数](#%e6%96%b9%e6%b3%95%e7%9a%84%e6%8c%87%e9%92%88%e6%8e%a5%e6%94%b6%e8%80%85%e5%92%8c%e5%87%bd%e6%95%b0%e7%9a%84%e6%8c%87%e9%92%88%e5%8f%82%e6%95%b0)

## 函数 function

- 函数是基本的代码块，用于执行一个任务
- 最少有一个 main 函数，且 main 函数必须在 main 包中
- 可通过函数划分不同功能，逻辑上每个函数执行指定的任务
- 函数声明包含名称、返回类型和参数
  - 参数可选，类似于占位符，是函数的形参。当连续两个或多个已命名形参类型相同时，除最后一个类型外，其它都可以忽略
    - 值传递：调用函数时将实际参数复制一份传递给函数，函数内修改参数不会影响实际参数
    - 引用传递：调用函数时传递参数的地址，函数内修改参数会影响到实际的值
    - 默认使用值传递
  - 返回类型可选
    - 多值返回：函数可以返回任意数量的返回值
    - 命名返回值：返回值可以是命名的，可以当做是定义在函数顶部的变量
      - 这些名字应当具有一定的意义，可作为文档使用用于记录返回值的含义
      - 一个不带参数的 `return` 语句返回命名返回值，也就是直接返回。直接返回语句应只用于短函数，否则会破坏函数的可读性

```go
func func_name( [param_list] ) [return_types] {
    // func_body
}

func swap(x, y string) (string, string) {
    return y, x
}

// 命名返回值
func split(sum int) (x, y int) {
    sx = sum * 4 / 9
    sy = sum - x
    sreturn
}
```

## 函数用法

## 函数值

- 函数作为值，即定义后作为值使用
- 函数值可以像其他值一样传递，可以用作函数的参数或返回值

```go
package main

import (
    "fmt"
    "math"
)

func compute(fn func(float64, float64) float64) float64 {
    return fn(3, 4)
}

func main() {
    hypot := func(x, y float64) float64 {
        return math.Sqrt(x*x + y*y)
    }
    fmt.Println(hypot(5, 12))

    fmt.Println(compute(hypot))
    fmt.Println(compute(math.Pow))
}
```

### 匿名函数

- 闭包，即匿名函数，在动态编程中使用
- 闭包是一个函数值，它引用了其函数体外的变量。该函数可以访问并赋予其引用的变量的值，即该函数被这些变量“绑定”在一起
- 匿名函数是一个“内联”语句或表达式，其优越性在于可以直接使用函数内的变量，不必声明

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

```go
package main

import "fmt"

func fibonacci() func() int {
    before := 0
    val := 1
    return func() int {
        ret := before
        before = val
        val = ret + val
        return ret
    }
}

func main() {
    f := fibonacci()
    for i := 0; i < 10; i++ {
        fmt.Println(f())
    }
}
```

### 可变函数 variadic function

- 可变函数的参数数目是可变的，当最后一个参数用`...T`表示时，函数就可以接受任意数目的类型 T 作为最后一个参数
- 可变函数实际是将传递的可变数目的参数转成一个新建的切片作为参数
- 不能直接传递一个切片作为参数给可变函数，还需要在切片后面加上`...`，才可以将切片作为可变函数的参数，而且不用创建新切片，而是直接传递原始的切片

## 方法 vs 函数

- 方法是包含了接收者的函数
- 可以把接收者作为函数的参数来实现方法
- 为什么使用方法
  - go 不是一个纯粹的面向对象的变成语言，可以使用方法来实现和类类似的行为
  - 可以定义类型不同的同名方法，但是不能定义同名函数

### 方法的值接收者 vs 函数的值参数

- 具有值参数的函数，只能接受值作为参数
- 具有值接收者的方法，可以接受指针和值接收者

```go
type rectangle struct {
    len float64
    width float64
}

func area(rec rectangle) {
    fmt.Println("area: %f * %f = %f", rec.len, rec.width, (rec.len * rec.width))
}

func (rec rectangle) area() {
    fmt.Println("area: %f * %f = %f", rec.len, rec.width, (rec.len * rec.width))
}

func caller() {
    r := rectangle(
        len: 3,
        width: 4,
    )

    area(r)
    r.area()

    p := &r
    //area(p),编译错误
    p.area() //go 会解释成(*p).area()
}
```

### 方法的指针接收者和函数的指针参数

- 具有指针参数的函数，只能接受指针作为参数
- 具有指针接收者的方法，可以接受指针和值接收者

```go
type rectangle struct {
    len float64
    width float64
}

func area(rec *rectangle) {
    fmt.Println("area: %f * %f = %f", rec.len, rec.width, (rec.len * rec.width))
}

func (rec *rectangle) area() {
    fmt.Println("area: %f * %f = %f", rec.len, rec.width, (rec.len * rec.width))
}

func caller() {
    r := rectangle(
        len: 3,
        width: 4,
    )

    p := &r
    area(p)
    p.area()

    //area(r),编译错误
    r.area() //go 会解释成(&p).area()
}
```
