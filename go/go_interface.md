# go 接口

- 接口把所有的具有共性的方法定义在一起，任何其他类型只要实现了这些方法就实现了这个接口
- 使用 type 和 interface 关键字定义接口

```go
//定义接口
type interface_name interface {
    //method_name1 [return_type1]
    //method_name2 [return_type2]
    //...
    //method_namen [return_typen]
}

//定义结构体
type struct_name struct {
    //variables
}

//实现接口方法
func (struct_var struct_name) method_name1() [return_type1] {
    //实现方法
}

//...

//实现方法
func (struct_val struct_name) method_namen() [return_typen] {
    //方法实现
}

//一般的方法
func func_name( [param_list] ) [return_types] {
    // func_body
}
```