# (*[1 << 30]C.YourType) 在 cgo 中做了什么事情

原文 [What does (*[1 << 30]C.YourType) do exactly in CGo?](https://stackoverflow.com/questions/48756732/what-does-1-30c-yourtype-do-exactly-in-cgo)

如下代码(摘选自 [Golang wiki](https://github.com/golang/go/wiki/cgo)，“将 C 数组转化为 Go 切片”一章)从 C 数组创建一个 Go 切片：

```go
import "C"
import "unsafe"
...
        var theCArray *C.YourType = C.getTheArray()
        length := C.getTheArrayLength()
        slice := (*[1 << 30]C.YourType)(unsafe.Pointer(theCArray))[:length:length]
```

在这里，`*[1 << 30]C.YourType` 本身没有做任何事情，只是一个类型。具体来说，它是一个指向长度为 `1 << 30` 的数组，数组元素都是 `C.YourType`。

第三个表达式所做的是[类型转换](https://golang.org/ref/spec#Conversions)，将 `unsafe.Pointer` 转为 `*[1 << 30]C.YourType`。

然后，使用[完整的切片表达式](https://golang.org/ref/spec#Slice_expressions)将上面转换的数组值变成一个切片(切片表达式不需要解引用数组值，因此虽然是一个指针，但是不需要使用前缀 `*`)。

可以将上述代码展开一些：

```go
// C 数组指针转换为 unsafe.Pointer
unsafePtr := unsafe.Pointer(theCArray)

// 将 unsafePtr 转换为指向 *[1 << 30]C.YourType 类型的一个指针
arrayPtr := (*[1 << 30]C.YourType)(unsafePtr)

// 将数组转为切片，底层数组和 C 数组相同。确保指定了容量和长度
slice := arrayPtr[0:length:length]
```

使用 `[1 << 30]` 是因为编译器不支持变长数组边界。因此开发人员选取一个大数字，用来设置长度上界。在许多例子中会使用 `1 << 30`，因为对于 32 位和 64 位系统都是有效的，且比 `1<<31-1` 看起来更好。
