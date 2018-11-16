# go 错误处理

- go 通过内置的错误接口提供了非常简单的错误处理机制
- error 是一个接口类型，定义

```go
type error interface {
    Error() string
}
```

- 可在编码中通过实现 error 接口类型生成错误信息
- 函数通常在最后的返回值中返回错误信息，使用 errors.New 可返回一个错误信息
- 如果有错误信息，则得到一个 non-nil 的 error 对象