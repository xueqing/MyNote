# go 指针

- 指针变量指向一个值的内存地址
- 先声明指针才可以使用指针
- 声明`var ptr_name *ptr_type`
  - `ptr_type`是指针类型
  - `ptr_name`是指针变量名
  - `*`用于指定变量是作为一个指针
- `*ptr`在指针类型前加`*`获取指针所指向的内容
- 空指针 nil：指针定义后未分配到变量时值为 nil，类似其他语言的 null/None/nil/NULL
- 指针变量通常缩写为 ptr
- 指针数组，来存储地址，声明`var ptr_name [len]*ptr_type`
- 指向指针的指针，声明`var pptr_name **pptr_type`
  - `**pptr`在指针的指针类型前加`**`获取指针所指向的内容
- 指针作为函数参数，通过引用或地址传参可在函数内部改变变量值
