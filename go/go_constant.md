# go 常量

- 定义`const vname [vtype] = value`
  - 显式类型定义`const vname vtype = value`
  - 隐式类型定义`const vname = value`
- 相同类型声明 `const vname1, vname2, vname3 = value1, value2, value3`
- 用于枚举

  ```go
  const {
      Unknown = 0
      Famale = 1
      Male = 2
  }
  ```

- 常量可使用 len(), cap(), unsafe.Sizeof() 函数计算表达式的值，函数必须是内置函数，否则编译错误
- iota: 特殊常量，一个可被编译器修改的常量
  - 在 const 关键字出现时被重置为 0（const 内部的第一行之前）
  - const 中每新增一行常量声明，iota 计数一次

  ```go
  const {
      a = iota //a=0
      b = iota //b=1，也可写 b
      c = iota //c=2，也可写 c
  }
  ```

  ```go
  a = "abc"
  unsafe.Sizeof(a) //16，字符串类型在 go 中是个结构，包括指向数组的指针和长度，每部分都是 8 字节，所以是 16 个字节
  ```

- 常量必须在编译时确定