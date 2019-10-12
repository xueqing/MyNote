# go 循环语句

- [go 循环语句](#go-%e5%be%aa%e7%8e%af%e8%af%ad%e5%8f%a5)
  - [for 循环](#for-%e5%be%aa%e7%8e%af)
  - ["while" 循环](#%22while%22-%e5%be%aa%e7%8e%af)
  - [循环嵌套](#%e5%be%aa%e7%8e%af%e5%b5%8c%e5%a5%97)
  - [循环控制语句](#%e5%be%aa%e7%8e%af%e6%8e%a7%e5%88%b6%e8%af%ad%e5%8f%a5)
  - [无限循环](#%e6%97%a0%e9%99%90%e5%be%aa%e7%8e%af)

## for 循环

- go 循环只有 for 结构。包含 3 个组件
  - 初始化语句：通常是短变量声明，声明的变量只对 for 循环可见
  - 条件语句：条件为 false 时退出循环
  - 后置语句
- 上述三个组件不需要小括号，但是需要大括号

```go
package main

import "fmt"

func main() {
  sum := 0
  for i := 0; i < 10; i++ {
    sum += i
  }
  fmt.Println(sum)
}
```

## "while" 循环

- 初始化语句和后置语句是可选的，此时可以去掉两个分号，相当于 C 的 `while`

```go
package main

import "fmt"

func main() {
  sum := 1
  for sum < 1000 { //或 "for ; sum < 1000; {"
    sum += sum
  }
  fmt.Println(sum)
}
```

## 循环嵌套

for 循环嵌套 for 循环

## 循环控制语句

- break
- continue
- goto

## 无限循环

- 省略条件语句，或设置循环条件为永真，就是无限循环

```go
for { //或 "for true {"
    //...
}
```
