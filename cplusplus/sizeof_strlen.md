# sizeof vs strlen

- [sizeof vs strlen](#sizeof-vs-strlen)
  - [sizeof](#sizeof)
  - [strlen](#strlen)
  - [总结](#%E6%80%BB%E7%BB%93)
  - [参考](#%E5%8F%82%E8%80%83)

## sizeof

- sizeof 是编译时一元运算符，可用于计算运算元的大小
- sizeof 作用于 unsigned int 时，结果一般表示为 size_t
- sizeof 可用于任何数据类型，包括基本类型(比如整型、浮点型、指针类型)或符合数据类型(比如结构体、联合体等)
- sizeof 计算结构体的大小时，并不一定等于结构体每个成员 sizeof 计算结果之和
  - 原因：编译器因为对齐问题会给结构体增加填充。不同编译器的对齐约束可能不同，所以填充大小也不确定。当结构体的一个成员之和有一个更大的成员，或者在结构体最后时，前者可能会被填充
  - C 编译器不允许编译器重排结构体的成员来减小填充。为了最下滑填充，结构体的成员必须按照从大到小的顺序排列

```c
#include <stdio.h>

int main()
{
    struct A {
        int x;      //sizeof(int)=4, Padding of 4 bytes
        double z;   //sizeof(double)=8
        short int y;//sizeof(short int)=2, Padding of 6 bytes
    };
    printf("Size of struct: %d", sizeof(struct A));//24

    struct B {
        double z;   //sizeof(double)=8
        int x;      //sizeof(int)=4
        short int y;//sizeof(short int)=2, Padding of 2 bytes
    };
    printf("Size of struct: %d", sizeof(struct B));//16

    struct C {
        double z;   //sizeof(double)=8
        short int y;//sizeof(short int)=2, Padding of 2 bytes
        int x;      //sizeof(int)=4
    };
    printf("Size of struct: %d", sizeof(struct C));//16

    return 0;
}
```

## strlen

- strlen 是 C 语言预定义的函数，包含在头文件 `string.h` 中
- strlen 接受指向数组的指针作为参数，并在运行时从该地址开始遍历查找 `NULL` 字符，然后计算在找到 `NULL` 字符钱经过的内存大小
- strlen 的主要用于计算一个数组或字符串的长度

```c
#include <stdio.h>
#include <string.h>
  
int main()
{
    char ch[]={'g', 'e', 'e', 'k', 's', '\0'};
    printf("Length of string is: %d", strlen(ch));//5

    char str[]= "geeks";
    printf("Length of string is: %d", strlen(str));//5

    char *str1 = "geeks";
    printf("Length of string is: %d", strlen(str1));//5
  
 return 0;
}
```

## 总结

| 差异 | sizeof | strlen |
| --- | --- | --- |
| 原型 | - | `size_t strlen(const char * str);` |
| 类型 | 一元运算符 | C 预定义的函数 |
| 支持的数据类型 | 返回任何数据(分配的)的实际大小，单位是 Byte，包含 null 值 | 返回字符串或字符数组的长度 |
| 计算大小 | sizeof 是编译时表达式，返回一个类型或变量的大小，并不关心变量的值 | strlen 是运行时计算，返回一个 C 风格的以 NULL 结尾的字符串的长度 |
| C++ 中 | sizeof 常用作 `malloc/memcpy/memset` 的参数，C++ 可用 `new/std::copy/std::fill` 或构造函数替换 | C 风格的字符串使用 `char_traits::length` 获取长度，也可用 `std::string` 类型保存计算 |

```c
#include <stdio.h>
#include <string.h>

int main()
{
    char str[] = "November";
    printf("Length of String is %d\n", strlen(str));//8
    printf("Size of String is %d\n", sizeof(str));//9
}

// 字符串以 NULL 字符，即 '\0' 结束，strlen 计算找到 NULL 字符经过的内存大小，不会计算 NULL。而 sizeof 返回为运算元实际分配的内存，也会计算 NULL
```

```cpp
#include <iostream>
#include <string.h>
using namespace std;
  
int main()
{
    char a[] = {"Geeks for"};
    char b[] = {'G','e','e','k','s',' ','f','o','r'};
    cout << "sizeof(a) = " << sizeof(a);//10
    cout << "\nstrlen(a) = "<< strlen(a);//9
    cout<<  "\nsizeof(b) = " << sizeof(b);//9
    cout<<  "\nstrlen(b) = " << strlen(b);//18，不确定

    return 0;
}
// strlen 找不到 NULL 字符，返回结果是不确定的
```

## 参考

- [Difference between strlen() and sizeof() for string in C](https://www.geeksforgeeks.org/difference-strlen-sizeof-string-c-reviewed/)
- [Sizeof vs Strlen](https://stackoverflow.com/questions/9937181/sizeof-vs-strlen)
