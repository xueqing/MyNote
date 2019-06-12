# go 切片

- 切片是对数组的抽象，是一种“动态数组”，长度不固定，可以追加元素
- 定义`var slice_name []type`
- 可使用 make 函数创建切片`var slice_name []type = make([]type, len)`或`slice_name := make([]type, len)`
  - make 函数`make([]T, length, capacity)`，创建一个数组，然后返回一个引用数组的切片
  - length 是数组的长度也是切片的初始长度
- 初始化
  - 直接初始化`slice_name := [] int {var1, var2..., varn}`
  - 引用数组初始化`slice_name := arr_name[:]`
  - 引用部分数组初始化
    - `slice_name := arr_name[startIndex:endIndex]`，引用下标 startIndex 到 endIndex-1 下的元素创建为一个新的切片
    - `slice_name := arr_name[startIndex:]`，引用下标 startIndex 到最后一个元素创建为一个新的切片
    - `slice_name := arr_name[startIndex:]`，引用第一个元素到 endIndex-1 下的元素创建为一个新的切片
  - 通过切片初始化`slice_name := origina_slice[startIndex:endIndex]`
  - 通过内置 make 函数初始化`slice_name := make([]type, len, cap)`
- 使用 len() 方法获取切片长度，指的是 slice 中元素的数目
- 使用 cap() 方法获取切片容量，即最长可以达到多少，指的是底层数组的元素数目，起始下标是创建切片时的起始下标
- 空切片 nil，即未初始化的切片，长度为 0，容量为 0
- 切片截取`slice_name[lower_bound : upper_bound]`
  - 下限默认为 0
  - 上限默认为 len(slice_name)
- 增加切片容量：创建一个更大的数组并把原数组的内容拷贝到新数组，新切片的容量增加一倍
  - 使用 append(slice_name, [param_list]) 函数往切片追加新元素
    - `[param_list]`也可以是一个切片，用`...`，如`newslice := append(slice1, slice2...)`
  - 使用 copy(dst_slice, ori_slice) 函数拷贝切片
- slice 其实是对已有数组的引用，本身不存储数据，对 slice 的修改会修改底层的数组
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

## 内存优化

- slice 是对底层数组的引用，因此只要 slice 在内存中，数组就不能被回收。当切片只引用了一小部分数组的数据来处理，可以使用`func copy(dst, src []T) int`来赋值切片，然后使用新切片就可以回收原始的数组
