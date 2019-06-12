# go 条件语句

- if 语句
- if...else 语句
- if 嵌套语句
- switch 语句，每个 case 分支都是唯一的，从上到下测试直到匹配，匹配项后面不用加 break，和 C++ 不同
  - Type...switch语句用于判断某个 interface 变量中实际存储的变量类型
- select 语句，类似于 switch 语句，会随机执行一个可允许的 case，如果没有 case 可以允许则阻塞到有 case 可以运行
  - case 必须是一个通信
  - 所有 channel 表达式会被求值
  - 所有发送的表达式会被求值
  - 任意某个 channel 可以进行，就会执行，其他的被忽略
  - 如果多个 case 可以执行，会随机公平选择一个执行，忽略其他
  - 没有可以执行的 case 语句
    - 如果有 default，则执行 default
    - 否则阻塞至某个通信可以运行，go 不会重新对 channel 或值进行求值

```go
if {
    //...
}

if {
    //...
} else {
    //...
}

if {
    //...
    if {
        //...
    }
}

switch var1 { //case 的值必须是相同类型
    case var1[, var11, var111]://可同时测试多个条件，用逗号分隔
        //...
    case var2:
        //...
    default:
        //...
}

switch x.(type) {
    case type1:
        //...
    case type2:
        //...
    default://可选
        //...
}

select {
    case condition1:
        //...
    case condition2:
        //...
    default:
        //...
}
```
