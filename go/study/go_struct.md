# go 结构体

- [go 结构体](#go-%e7%bb%93%e6%9e%84%e4%bd%93)
  - [定义结构体](#%e5%ae%9a%e4%b9%89%e7%bb%93%e6%9e%84%e4%bd%93)
  - [访问结构体成员变量](#%e8%ae%bf%e9%97%ae%e7%bb%93%e6%9e%84%e4%bd%93%e6%88%90%e5%91%98%e5%8f%98%e9%87%8f)

## 定义结构体

- `struct` 是域的集合
- 定义结构体需要使用 type 和 struct 关键字

  ```go
  package main

  import "fmt"

  type vertex struct {
      X int
      Y int
  }

  func main() {
      fmt.Println(vertex{1, 2})
  }
  ```

- 声明结构体变量：结构体字面量代表使用列举的域给新分配的结构体赋值
  - `var_name := struct_name {var1, var2...,varn}`
  - `var_name := struct_name {key1 : var1, key2 : val2..., keyn : varn}`
    - 使用 `key:` 可以仅列出部分字段，与字段名顺序无关

  ```go
  package main

  import "fmt"

  type vertex struct {
      X, Y int
  }

  var (
      v1 = vertex{1, 2}
      v2 = vertex{X : 1}
      v3 = vertex{}
      p = &vertex{2, 3}
  )

  func main() {
      fmt.Println(v1, v2, v3, p) //{1 2} {1 0} {0 0} &{2 3}
  }
  ```

## 访问结构体成员变量

- 访问结构体成员变量用 `.` 操作符
- 和 C++ 不一样，结构体指针访问结构体成员变量也用 `.` 操作符

  ```go
  package main

  import "fmt"

  type vertex struct {
      X int
      Y int
  }

  func main() {
      v := vertex{1, 2}
      fmt.Println(v)
      p := &v
      p.X = 1e9
      fmt.Println(v)
  }
  ```

- 结构体作为函数参数
