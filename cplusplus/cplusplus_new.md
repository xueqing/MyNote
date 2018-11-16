# C++ new

## 关于 new int() 和 new int[]

```C++
    #define LEN 100
    int *arr1 = new int(LEN);
    int *arr2 = new int[LEN];
```

- 第一行的代码`arr1`指向内存中`int = 100`的一个数的地址
- 第二行的代码`arr2`指向长度为 100 的数组的内存块
- 圆括号是对象赋值的意思；方括号是声明数组大小的意思