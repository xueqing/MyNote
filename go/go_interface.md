# go 接口

- [go 接口](#go-%e6%8e%a5%e5%8f%a3)
  - [接口定义](#%e6%8e%a5%e5%8f%a3%e5%ae%9a%e4%b9%89)
  - [接口值](#%e6%8e%a5%e5%8f%a3%e5%80%bc)
    - [底层值为 nil 的接口值](#%e5%ba%95%e5%b1%82%e5%80%bc%e4%b8%ba-nil-%e7%9a%84%e6%8e%a5%e5%8f%a3%e5%80%bc)
    - [接口值为 nil](#%e6%8e%a5%e5%8f%a3%e5%80%bc%e4%b8%ba-nil)
    - [空接口](#%e7%a9%ba%e6%8e%a5%e5%8f%a3)
  - [类型断言(type assertion)](#%e7%b1%bb%e5%9e%8b%e6%96%ad%e8%a8%80type-assertion)
  - [类型选择(type switch)](#%e7%b1%bb%e5%9e%8b%e9%80%89%e6%8b%a9type-switch)

## 接口定义

- 接口类型是由一组方法签名定义的集合，接口类型的变量可以保存任何实现了这些方法的值
- 接口把所有的具有共性的方法定义在一起，任何其他类型只要实现了这些方法就实现了这个接口
- 使用 type 和 interface 关键字定义接口
- 在面向对象中，接口定义了一个对象的行为

```go
package main

import (
    "fmt"
    "math"
)

type abser interface {
    Abs() float64
}

func main() {
    var a abser
    f := myFloat(-math.Sqrt2)
    v := vertex{3, 4}

    a = f // a myFloat 实现了 abser
    fmt.Println(a.Abs())

    a = &v // a *vertex 实现了 abser
    fmt.Println(a.Abs())

    // a = v // error: v 是一个 vertex(而不是 *vertex), 所以没有实现 abser
}

type myFloat float64

func (f myFloat) Abs() float64 {
    if f < 0 {
        return float64(-f)
    }
    return float64(f)
}

type vertex struct {
    X, Y float64
}

func (v *vertex) Abs() float64 {
    return math.Sqrt(v.X*v.X + v.Y*v.Y)
}
```

## 接口值

- 接口也是值
  - 接口值可用作函数的参数或返回值
  - 在内部，接口值可看做包含值和具体类型的元组 `(value, type)`
    - 通过 `%v` 和 `%T` 可以访问接口的值和类型
- 接口值保存了一个具体底层类型的具体值
- 接口值调用方法时会执行其底层类型的同名方法

```go
package main

import (
    "fmt"
    "math"
)

type myInterface interface {
    M()
}

type st struct {
    S string
}

func (t *st) M() {
    fmt.Println(t.S)
}

type myFloat float64

func (f myFloat) M() {
    fmt.Println(f)
}

func main() {
    var i myInterface

    i = &st{"Hello"}
    describe(i)
    i.M()

    i = myFloat(math.Pi)
    describe(i)
    i.M()
}

func describe(i myInterface) {
    fmt.Printf("(%v, %T)\n", i, i)
}
```

### 底层值为 nil 的接口值

- 接口内的具体值为 nil，方法仍然会被 nil 接收者调用。**保存了 nil 具体值的接口本身并不为 nil**

```go
package main

import (
    "fmt"
    "math"
)

type myInterface interface {
    M()
}

type st struct {
    S string
}

func (t *st) M() {
    if t == nil {
        fmt.Println("<nil>")
        return
    }
    fmt.Println(t.S)
}

func main() {
    var i myInterface

    i = &st{"Hello"}
    describe(i)
    i.M()

    var stp *st
    i = stp
    describe(i)
    i.M()
}

func describe(i myInterface) {
    fmt.Printf("(%v, %T)\n", i, i)
}
```

### 接口值为 nil

- nil 接口值既不保存值也不保存具体类型
- 为 nil 接口调用方法会报运行时错误，因为接口的元组内并未包含可以指明该调用哪个具体方法的类型

```go
package main

import (
    "fmt"
)

type myInterface interface {
    M()
}

func main() {
    var i myInterface
    describe(i)
    i.M() // panic: runtime error: invalid memory address or nil pointer dereference
}

func describe(i myInterface) {
    fmt.Printf("(%v, %T)\n", i, i)
}
```

### 空接口

- 指定了零个方法的接口值称为 “空接口” `interface{}`
- 空接口可保存任何类型的值(因为每个类型都至少实现了零个方法)
- 空接口用于处理未知类型的值。如 `fmt.Print` 可接受类型为 `interface{}` 的任意数量的参数

```go
package main

import "fmt"

func main() {
    var i interface{}
    describe(i)

    i = 42
    describe(i)

    i = "hello"
    describe(i)
}

func describe(i interface{}) {
    fmt.Printf("(%v, %T)\n", i, i)
}
```

## 类型断言(type assertion)

- 类型断言提供了访问接口值底层具体值的方式 `t := i.(T)`
  - 断言接口值 i 保存了具体类型 T，并将其底层类型为 T 的值赋予变量 t
  - 若 i 未保存 T 类型的值，会触发一个 panic
- 类型断言可返回两个值：其底层值，一个布尔值判断断言是否成功 `t, ok := i.(T)`

```go
package main

import "fmt"

func main() {
    var i interface{} = "hello"

    s := i.(string)
    fmt.Println(s)

    s, ok := i.(string)
    fmt.Println(s, ok)

    f, ok := i.(float64)
    fmt.Println(f, ok)

    f = i.(float64) // 报错(panic)
    fmt.Println(f)
}
```

## 类型选择(type switch)

- 类型选择语句用于判断某个 interface 变量中实际存储的变量类型

```go
package main

import "fmt"

func do(i interface{}) {
    switch v := i.(type) {
    case int:
        fmt.Printf("Twice %v is %v\n", v, v*2)
    case string:
        fmt.Printf("%q is %v bytes long\n", v, len(v))
    default:
        fmt.Printf("I don't know about type %T!\n", v)
    }
}

func main() {
    do(21)
    do("hello")
    do(true)
}
```
