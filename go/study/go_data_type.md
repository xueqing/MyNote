# go 数据类型

- [go 数据类型](#go-%e6%95%b0%e6%8d%ae%e7%b1%bb%e5%9e%8b)
  - [数据类型](#%e6%95%b0%e6%8d%ae%e7%b1%bb%e5%9e%8b)
  - [数据类型默认初始化值](#%e6%95%b0%e6%8d%ae%e7%b1%bb%e5%9e%8b%e9%bb%98%e8%ae%a4%e5%88%9d%e5%a7%8b%e5%8c%96%e5%80%bc)
  - [类型推导](#%e7%b1%bb%e5%9e%8b%e6%8e%a8%e5%af%bc)

## 数据类型

- 数据类型把数据分成所需内存大小不同的数据
  - 布尔型：true 或 false
  - 数字类型：
    - 整型
      - 有符号 int(int, int8, int16, int32, int64)，默认是 int
        - int 是 32 或 64 位，取决于底层平台。建议使用 int 来表示整数，除非需要指定大小
        - 32 位系统就是 32 位，64 位 系统就是 64 位
      - 无符号 uint(uint, uint8, uint16, uint32, unit64)
        - uint 32 或 64 位，同上
    - 浮点型 float(float32, float64)，默认是 float64
    - 复数 complex(complex64, complex128)
      - complex64 32 位实数和虚数
      - complex128 64 位实数和虚数
      - 使用内置函数 complex 构造一个复数`func complex(r, i FloatType) ComplexType`
        - 实部 r 和虚部 i 应该是同一类型，float32 或 float64，返回的复数类型是 complex64 或 complex128
      - 也可直接生成复数`c := 6 + 7i`
    - byte 是 uint8 的别名
    - rune 是 int32 的别名，表示 Unicode code point
    - uintptr 无符号整型，用于存放一个指针
  - 字符串类型：字节使用 UTF-8 编码标识 Unicode 文本，是字节的集合
  - 派生类型：
    - 指针类型 pointer
    - 数组类型
    - 结构化类型 struct
    - Channel 类型
    - 函数类型
    - 切片类型
    - 接口类型 interface
    - map 类型
- 可以使用 `%T` 格式化打印变量的类型，使用 `%v` 打印变量的值

## 数据类型默认初始化值

- 变量默认值，即默认初始化的值，对应各自的 “零” 值
  - int 默认值 0
  - boolean 默认值 false
  - string 默认值 ""
  - float32 默认值 0
  - pointer 默认值 nil

## 类型推导

- 当声明变量使用隐形类型(使用不带类型的 `:=` 或 `var =`)，需要通过右值推导变量的类型
- 当右值的类型是声明过的，则新变量与其类型相同
- 当右值是一个没有类型的数值常量时，根据常量精度推导变量类型(int/float64/complex128)

  ```go
  i := 42           // int
  f := 3.142        // float64
  g := 0.867 + 0.5i // complex128
  ```
