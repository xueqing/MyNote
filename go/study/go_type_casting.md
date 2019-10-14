# go 类型转换

- 类型转换用于将一种数据类型的变量转换为另一种类型的变量，go 不支持隐式类型转换

  ```go
  package main

  import (
    "fmt"
    "math"
  )

  func main() {
    var x, y int = 3, 4
    var f float64 = math.Sqrt(float64(x*x + y*y))
    var z uint = f //error: cannot use f (type float64) as type uint in assignment
    fmt.Println(x, y, z)
  }
  ```

- 格式`type_name(expression)`
  - type_name 是类型
  - expression 是表达式
