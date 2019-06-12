# go 结构体

- 定义需要使用 type 和 struct 关键字

```go
type struct_name struct {
    //member1 defination;
    //member2 defination;
    //member3 defination;
}
```

- 声明结构体变量
  - `var_name := struct_name {var1, var2...,varn}`
  - `var_name := struct_name {key1 : var1, key2 : val2..., keyn : varn}`
- 访问结构体成员变量用`.`操作符
- 结构体作为函数参数
- 结构体指针，访问结构体成员变量也用`.`操作符，和 C++ 不一样
