# go 错误处理

- go 通过内置的错误接口提供了非常简单的错误处理机制
- error 是一个接口类型，定义

```go
type error interface {
    Error() string
}
```

- 可在编码中通过实现 error 接口类型生成错误信息
- 函数通常在最后一个返回值返回错误信息，使用 errors.New 可返回一个错误信息
  - errors.new 接收一个字符串作为参数
- 如果有错误信息，则得到一个非 nil 的 error 对象，通常将返回值与 nil 比较
- 打印 error 的时候，调用的是内部的`Error() string`方法
- 使用 fmt.Errorf 函数可以给 error 增加更多信息
  - fmt.Errorf 接收参数和格式化字符串