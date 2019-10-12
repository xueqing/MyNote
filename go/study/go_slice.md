# go 切片

- [go 切片](#go-%e5%88%87%e7%89%87)
  - [slice](#slice)
  - [slice 长度和容量](#slice-%e9%95%bf%e5%ba%a6%e5%92%8c%e5%ae%b9%e9%87%8f)
    - [append 追加到 slice](#append-%e8%bf%bd%e5%8a%a0%e5%88%b0-slice)
  - [copy 对 slice 拷贝](#copy-%e5%af%b9-slice-%e6%8b%b7%e8%b4%9d)
  - [对 slice 切片](#%e5%af%b9-slice-%e5%88%87%e7%89%87)
  - [slice vs array](#slice-vs-array)
    - [创建 array 和 slice](#%e5%88%9b%e5%bb%ba-array-%e5%92%8c-slice)
    - [切片底层是数组](#%e5%88%87%e7%89%87%e5%ba%95%e5%b1%82%e6%98%af%e6%95%b0%e7%bb%84)
  - [使用 make 函数创建 slice](#%e4%bd%bf%e7%94%a8-make-%e5%87%bd%e6%95%b0%e5%88%9b%e5%bb%ba-slice)
  - [slice 内存储 slice](#slice-%e5%86%85%e5%ad%98%e5%82%a8-slice)
  - [内存优化](#%e5%86%85%e5%ad%98%e4%bc%98%e5%8c%96)

## slice

- 切片是对数组的抽象，是一种“动态数组”，长度不固定，可以追加元素
- 定义 `var slice_name []type`
- 初始化
  - 直接初始化`slice_name := [] int {var1, var2..., varn}`
  - 引用数组初始化`slice_name := arr_name[:]`
  - 引用部分数组初始化
    - `slice_name := arr_name[startIndex:endIndex]`，引用下标 startIndex 到 endIndex-1 下的元素创建为一个新的切片
    - `slice_name := arr_name[startIndex:]`，引用下标 startIndex 到最后一个元素创建为一个新的切片
    - `slice_name := arr_name[startIndex:]`，引用第一个元素到 endIndex-1 下的元素创建为一个新的切片
  - 通过切片初始化`slice_name := origina_slice[startIndex:endIndex]`

## slice 长度和容量

- 使用 `len(slice_name)` 方法获取切片长度，指的是 slice 中元素的数目
- 使用 `cap(slice_name)` 方法获取切片容量，即最长可以达到多少，指的是底层数组的元素数目，起始下标是创建切片时的起始下标
- 空切片 nil，即未初始化的切片，长度为 0，容量为 0，没有底层数组
- 切片截取`slice_name[lower_bound : upper_bound]`
  - 下限默认为 0
  - 上限默认为 len(slice_name)
- 增加切片容量：创建一个更大的数组并把原数组的内容拷贝到新数组，新切片的容量增加一倍
  - 使用 `append(slice_name, [param_list])` 函数往切片追加新元素
    - `[param_list]`也可以是一个切片，用`...`，如`newslice := append(slice1, slice2...)`
  - 使用 `copy(dst_slice, ori_slice) int` 函数拷贝切片

### append 追加到 slice

- 使用 `func append(slice_name []T, [param_list]) []T` 函数往切片追加新元素
  - slice 的类型是 T
  - `[param_list]`是要追加到 slice 的 T 类型的值，也可以是一个切片，用 `...`，如 `newslice := append(slice1, slice2...)`
  - 返回值是一个 slice，包含了 slice_name 的所有元素以及追加的所有元素
    - 如果 slice_name 不能包含所有追加的元素，会分配一个更大的数组，返回的 slice 指向新分配的数组

```go
package main

import (
    "fmt"
)

func main() {
    var s []int
    printSlice(s) //len=0 cap=0 []

    s = append(s, 0)
    printSlice(s) //len=1 cap=1 [0]

    s = append(s, 1)
    printSlice(s) //len=2 cap=2 [0 1]

    s = append(s, 2, 3, 4)
    printSlice(s) //len=5 cap=6 [0 1 2 3 4]

    a := []int{7, 8, 9}
    s = append(s, a...) //使用 ... 语法将参数展开为参数列表
    printSlice(s)       //len=8 cap=12 [0 1 2 3 4 7 8 9]
}

func printSlice(s []int) {
    fmt.Printf("len=%d cap=%d %v\n", len(s), cap(s), s)
}
```

## copy 对 slice 拷贝

- 使用 `copy(dst_slice, ori_slice) int` 函数拷贝切片
  - 将 ori_slice 的元素复制到 dst_slice
  - 返回复制元素的数目

## 对 slice 切片

- 当 slice 容量足够大，可以对一个 slice 进行再切片

```go
package main

import "fmt"

func main() {
    s := []int{2, 3, 5, 7, 11, 13}
    printSlice(s) //len=6 cap=6 [2 3 5 7 11 13]

    s = s[:0]     //分割 slice 长度为 0
    printSlice(s) //len=0 cap=6 []

    s = s[:4]     //扩展 slice 长度
    printSlice(s) //len=4 cap=6 [2 3 5 7]

    s = s[2:]     //丢弃前两个值
    printSlice(s) //len=2 cap=4 [5 7]

    s = s[:4]     //扩展 slice
    printSlice(s) //len=4 cap=4 [5 7 11 13]

    // s = s[:6] //error: slice bounds out of range [:6] with capacity 4
}

func printSlice(s []int) {
    fmt.Printf("len=%d cap=%d %v\n", len(s), cap(s), s)
}
```

## slice vs array

- 参考 [Go 切片：用法和本质](https://blog.go-zh.org/go-slices-usage-and-internals)

### 创建 array 和 slice

- 创建一个数组 `[3] bool {true, true, false}`
- 创建一个相同的数组，并且创建数组的一个 slice 引用 `[] bool {true, true, false}`
- **切片没有指定元素的数目**

```go
package main

import "fmt"

func main() {
    slice1 := []int{2, 3, 5, 7, 11, 13}
    fmt.Println(slice1)

    slice2 := []bool{true, false, true, true, false, true}
    fmt.Println(slice2)

    st := []struct{
        i int
        b bool
    } {
        {2, true},
        {3, false},
        {5, true},
        {7, true},
        {11, false},
        {13, true},
    }
    fmt.Println(st)
}
```

### 切片底层是数组

- slice 是一个数组片段的描述。它包含了指向数组的指针、片段的长度和容量(片段的最大长度)
  - 长度是 slice 引用的元素数目
  - 容量是底层数组的元素数目(从切片指针开始计数)
  - 切片增长不能超出其容量，否则会导致运行时异常。也不能使用小于零的索引访问切片之前的元素
- slice 其实是对底层数组的引用，本身不存储数据，对 slice 的修改会修改底层的数组，其他共享底层数据的 slice 也会看到底层数组的修改
  - slice 操作不会复制底层指向的元素。它创建一个新的 slice 并复用之前 slice 的底层数组
  - slice 操作和数组索引一样高效
- slice 作为函数变量，函数内对 slice 的修改也会影响调用者底层数组的元素

```go
func sliceTest() {
  arr := [...]int{1, 2, 3, 4, 5, 6, 7}
  sli := arr[1:4]
  fmt.Printf("slice len=%d, cap=%d", len(sli), cap(sli)) //1,2,3,4,5,6,7
  fmt.Println("original array ", arr) //1,2,3,4,5,6,7
  for i := range sli {
    sli[i]++
  }
  fmt.Println("modifiled array ", arr) //1,3,4,5,5,6,7
}
```

## 使用 make 函数创建 slice

- 可使用内置 `make` 函数创建切片`var slice_name []type = make([]type, len, cap)`或`slice_name := make([]type, len, cap)`
  - `make` 函数创建一个数组，然后返回一个引用数组的切片
  - `len` 是数组的长度也是切片的初始长度
  - `cap` 容量参数可选，默认为指定的长度大小
  - 通过 `make` 函数初始化`slice_name := make([]type, len, cap)`

```go
package main

import "fmt"

func main() {
    s := make([]int, 5) //长度和容量为 5，初始值都为 0
    printSlice("s", s)  //s len=5 cap=5 [0 0 0 0 0]

    a := make([]int, 0, 5) //长度为 0，容量为 5，初始为空
    printSlice("a", a)     //a len=0 cap=5 []

    b := a[:2]         //长度为 2，容量为 5，初始值为 0
    printSlice("b", b) //b len=2 cap=5 [0 0]

    c := b[2:5]        //长度为 3，容量为 3，初始值为 0
    printSlice("c", c) //c len=3 cap=3 [0 0 0]
}

func printSlice(str string, s []int) {
    fmt.Printf("%s len=%d cap=%d %v\n", str, len(s), cap(s), s)
}
```

## slice 内存储 slice

- slice 可以存储任何类型，包含其他 slice

```go
package main

import (
    "fmt"
    "strings"
)

func main() {
    board := [][]string{
        []string{"_", "_", "_"},
        []string{"_", "_", "_"},
        []string{"_", "_", "_"},
    }

    board[0][0] = "X"
    board[0][2] = "X"
    board[1][0] = "O"
    board[1][2] = "X"
    board[2][2] = "O"

    for i := 0; i < len(board); i++ {
        fmt.Printf("%s\n", strings.Join(board[i], " "))
    }
}
```

## 内存优化

- slice 是对底层数组的引用，因此只要 slice 在内存中，数组就不能被回收
- 当切片只引用了一小部分数组的数据来处理，可以使用`func copy(dst, src []T) int`来赋值切片，然后使用新切片就可以回收原始的较大的数组
