# go 范围

- range 关键字用于 for 循环中迭代数组 array、切片 slice、通道 channel 或 集合 map 的元素
- 在数组和切片中返回元素的索引和索引对应的值的拷贝，在集合中返回 key-value 对的 key 值

  ```go
  package main

  import (
      "fmt"
  )

  func main() {
      var pow = []int{1, 2, 4, 8, 16, 32, 64, 128}
      for i, v := range pow {
          fmt.Printf("2**%d = %d\n", i, v)
      }
  }
  ```

- 可以赋值给 `_` 跳过索引或值
  - `for i, _ := range pow`。如果只想要索引，可以忽视第二个参数 `for i := range pow`
  - `for _, val := range pow`

  ```go
  package main

  import (
      "fmt"
  )

  func main() {
      pow := make([]int, 10)

      for i := range pow {
          pow[i] = 1 << uint(i) //2**i
      }

      for _, val := range pow {
          fmt.Printf("%d\n", val)
      }
  }
  ```
