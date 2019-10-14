# go 接口

- [go 接口](#go-%e6%8e%a5%e5%8f%a3)
  - [非侵入式设计](#%e9%9d%9e%e4%be%b5%e5%85%a5%e5%bc%8f%e8%ae%be%e8%ae%a1)
  - [接口定义](#%e6%8e%a5%e5%8f%a3%e5%ae%9a%e4%b9%89)
  - [接口实现](#%e6%8e%a5%e5%8f%a3%e5%ae%9e%e7%8e%b0)
  - [接口值](#%e6%8e%a5%e5%8f%a3%e5%80%bc)
    - [底层值为 nil 的接口值](#%e5%ba%95%e5%b1%82%e5%80%bc%e4%b8%ba-nil-%e7%9a%84%e6%8e%a5%e5%8f%a3%e5%80%bc)
    - [接口值为 nil](#%e6%8e%a5%e5%8f%a3%e5%80%bc%e4%b8%ba-nil)
    - [空接口](#%e7%a9%ba%e6%8e%a5%e5%8f%a3)
  - [类型断言(type assertion)](#%e7%b1%bb%e5%9e%8b%e6%96%ad%e8%a8%80type-assertion)
  - [类型选择(type switch)](#%e7%b1%bb%e5%9e%8b%e9%80%89%e6%8b%a9type-switch)
  - [接口和类型的关系](#%e6%8e%a5%e5%8f%a3%e5%92%8c%e7%b1%bb%e5%9e%8b%e7%9a%84%e5%85%b3%e7%b3%bb)
    - [一个类型可以实现多个接口](#%e4%b8%80%e4%b8%aa%e7%b1%bb%e5%9e%8b%e5%8f%af%e4%bb%a5%e5%ae%9e%e7%8e%b0%e5%a4%9a%e4%b8%aa%e6%8e%a5%e5%8f%a3)
    - [多个类型可以实现相同的接口](#%e5%a4%9a%e4%b8%aa%e7%b1%bb%e5%9e%8b%e5%8f%af%e4%bb%a5%e5%ae%9e%e7%8e%b0%e7%9b%b8%e5%90%8c%e7%9a%84%e6%8e%a5%e5%8f%a3)

## 非侵入式设计

- Go 语言的接口设计是非侵入式的，接口编写者无须知道接口被哪些类型实现。而接口实现者只需知道实现的是什么样子的接口，但无须指明实现哪一个接口。编译器知道最终编译时使用哪个类型实现哪个接口，或者接口应该由谁来实现
- 非侵入式设计是 Go 语言设计师经过多年的大项目经验总结出来的设计之道。只有让接口和实现者真正解耦，编译速度才能真正提高，项目之间的耦合度也会降低不少
- 传统的派生式接口及类关系构建的模式，让类型间拥有强耦合的父子关系。这种关系一般会以“类派生图”的方式进行。经常可以看到大型软件极为复杂的派生树。随着系统的功能不断增加，这棵“派生树”会变得越来越复杂。对于 Go 语言来说，非侵入式设计让实现者的所有类型均是平行的、组合的。如何组合则留到使用者编译时再确认。因此，使用 Go 语言时，不需要同时也不可能有“类派生图”，开发者唯一需要关注的就是“我需要什么”，以及“我能实现什么”

## 接口定义

- 接口是双方约定的一种合作协议。接口实现者不需要关心接口会被怎样使用，调用者也不需要关心接口的实现细节。接口是一种类型，也是一种抽象结构，不会暴露所含数据的格式、类型及结构
- 在面向对象中，接口定义了一个对象的行为
- 使用 type 和 interface 关键字定义接口

  ```go
  type interface_name interface {
    method_name1([param_list]) [return_type]
    method_name2([param_list]) [return_type]
    method_name3([param_list]) [return_type]
    ...
    method_namen([param_list]) [return_type]
  }
  ```

  - `interface_name`：接口类型名。使用 type 将接口定义为自定义的类型名。Go 语言的接口在命名时，一般会在单词后面添加 er，如有写操作的接口叫 Writer，有字符串功能的接口叫 Stringer，有关闭功能的接口叫 Closer 等
  - `method_name`：方法名。当方法名首字母是大写时，且这个接口类型名首字母也是大写时，这个方法可以被接口所在的包之外的代码访问
  - `param_list` `return_type`：参数列表和返回值列表中的参数变量名可以被忽略

## 接口实现

- 接口类型是由一组方法签名定义的集合，接口类型的变量可以保存任何实现了这些方法的值
- 接口把所有的具有共性的方法定义在一起，如果一个任意类型 T 的方法集为一个接口类型的方法集的超集，则说类型 T 实现了此接口类型。T 可以是一个非接口类型，也可以是一个接口类型
- 实现关系在 Go 语言中是隐式的。两个类型之间的实现关系不需要在代码中显式地表示出来。Go 语言中没有类似于 implements 的关键字。Go 编译器将自动在需要的时候检查两个类型之间的实现关系
- 接口定义后，需要实现接口，调用方才能正确编译通过并使用接口。接口的实现需要遵循两条规则才能让接口可用
  - 接口的方法与实现接口的类型方法格式一致
  - 接口中所有方法均被实现

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

## 接口和类型的关系

### 一个类型可以实现多个接口

- 接口间彼此独立，不知道对方的实现
- Socket 结构的 Write() 方法实现了 io.Writer 以及 io.Closer 接口

  ```go
  type Socket struct {
  }

  func (s *Socket) Write(p []byte) (n int, err error) {
      return 0, nil
  }

  func (s *Socket) Close() error {
      return nil
  }

  func usingWriter( writer io.Writer){
      writer.Write( nil ) // 使用io.Writer的代码, 并不知道Socket和io.Closer的存在
  }

  func usingCloser( closer io.Closer) {
      closer.Close() // 使用io.Closer, 并不知道Socket和io.Writer的存在
  }

  func main() {
      s := new(Socket) // 实例化Socket
      usingWriter(s)
      usingCloser(s)
  }
  ```

### 多个类型可以实现相同的接口

- 接口的方法可以通过在类型中嵌入其他类型或者结构体来实现
- 示例：
  - Service 接口定义了两个方法：一个是开启服务的方法（Start()），一个是输出日志的方法（Log()）
  - 使用 GameService 结构体来实现 Service，GameService 自己的结构只能实现 Start() 方法，而 Service 接口中的 Log() 方法已经被一个能输出日志的日志器（Logger）实现了，无须再进行 GameService 封装，或者重新实现一遍
  - 选择将 Logger 嵌入到 GameService 能最大程度地避免代码冗余，简化代码结构

  ```go
  type Service interface {
      Start()  // 开启服务
      Log(string)  // 日志输出
  }

  type Logger struct {
  }

  func (g *Logger) Log(l string) {
  }

  type GameService struct {
      Logger  // 嵌入日志器
  }

  func (g *GameService) Start() {
  }

  func main() {
      var s Service = new(GameService)
      s.Start()
      s.Log("hello")
  }
  ```
