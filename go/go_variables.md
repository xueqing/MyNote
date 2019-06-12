# go 变量

- 变量声明使用关键字 var
- 变量声明
  - 指定类型不赋值，使用默认值
    - `var vname vtype = value`
  - 根据初始化值自行判定变量类型
    - `var vname = value`
  - 省略 var，注意`:=`左侧的变量不应该是已经声明过的，否则会导致编译错误
    - `vname := value`
    - 只能用于函数体内，建议使用

  ```go
  var a int = 10
  var b = 10
  c := 10
  ```

- 多变量声明
  - 类型相同，非全局变量
    - `var vname1 vname2 vname3 vtype = v1, v2, v3`
  - 不声明类型，自动推断
    - `var vname1, vname2, vname3 = v1, v2, v3`
  - 使用`:=`，左侧的变量是未声明过的
    - `vname1, vname2, vname3 := v1, v2, v3`
    - 只能在函数体中使用，建议使用
    - 必须一次初始化所有的变量
    - 左边至少有一个变量是未声明过的，否则编译错误`no new variables on left side of :=`
  - 因式分解关键字，一般用于声明全局变量，在一个语句中声明不同类型的变量

    ```go
    var (
      vname1 vtype1
      vname2 vtype2
    )
    ```

- 注意
  - 已声明的变量不能再使用`:=`赋值
  - 定义变量之前使用会是编译错误`undefined`
  - 在代码块定义局部变量未使用是编译错误`declared but not used`
  - 全局变量运行只定义不使用
- 可以并行赋值/同时赋值`a, b, c = 5, 7, "abc"`
- 交换变量值，必须类型相同`a, b = b, a`
- 空白标识符`_`用于抛弃值
  - 一个只写变量，不能得到值
  - 可以接收函数返回值，但是只使用部分返回值
- 支持给变量赋值，该值在运行时计算
  - `c := math.Min(a, b)`
- go 是强类型语言，不支持隐式类型转换

  ```go
  age := 20
  age = "kiki" //error: cannot use "kiki" (type string) as type int in assignment
  ```
