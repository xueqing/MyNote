# C 语言位字段

- [C 语言位字段](#c-语言位字段)
  - [定义](#定义)
  - [示例](#示例)
  - [注意](#注意)
  - [使用](#使用)
  - [练习](#练习)
  - [参考](#参考)

## 定义

使用显式的位数声明一个类数据成员。相邻的位字段成员可以被打包成一个字节使用。这使得存储更加紧凑。此外，位字段支持使用名称来处理位。

声明格式：`identifier attr : size`

- identifier: 声明的位字段的名称。名字可选；匿名的位字段指定了用于填充的位数
- attr: C++11 支持
- size: 不小于 0 的整数常量表达式。大于 0 时，表示位字段占用的位数。等于 0 只适用于匿名位字段且有特殊的含义：它指定类定义的下个位字段起始于内存分配单元的对齐边界。

## 示例

位字段的位数限制了可以表达的值范围：

```cpp
struct S {
  unsigned int b : 3;//3-bit unsigned field allows values are [0-7]
};

int main() {
  S s={6};
  ++s.b;
  std::cout << s.b << std::endl;// 7
  ++s.b;// the value 8 does not fit in this bit field
  std::cout << s.b << std::endl;// 0
  return 0;
}
```

多个相邻的位字段通常被打包到一起(这个行为是实现定义的)：

```cpp
struct S {
  // S occupy 8 bytes:
  // b1 5 bits; unused 4 bits; unused 23 bits(padding)
  // b2 8 bits; unused 24 bits(padding)
  unsigned int b1 : 5, : 4, b2 : 8;
};

int main() {
  std::cout << sizeof(S) << std::endl;// 4
  return 0;
}
```

特殊的 0 长度的匿名位字段可强制打破填充，它指定接下来的位字段从分配单元起始位置开始。

```cpp
struct S {
  // S occupy 8 bytes:
  // b1 5 bits; unused 27 bits(padding)
  // b2 8 bits; unused 24 bits(padding)
  unsigned int b1 : 5, : 0, b2 : 8;
};

int main() {
  std::cout << sizeof(S) << std::endl;// 8
  return 0;
}
```

如果位字段指定的长度大于类型长度，值范围受限于类型：多余的位成为无用的填充位。

```cpp
struct S {
  uint8_t b : 12;// warning: width of ‘S::b’ exceeds its type
};

int main() {
  std::cout << sizeof(S) << std::endl;// 2
  S s={255};
  std::cout << s.b << std::endl;// 8
  s.b++;
  std::cout << s.b << std::endl;// 8
  return 0;
}
```

```cpp
struct S {
    unsigned int x, y : 33, z;
};

int main()
{
    std::cout << sizeof(S) << std::endl;// 16
    return 0;
}
```

## 注意

因为位字段不需要从字节起始位置开始，不能对一个位字段取地址。不能对一个位字段做指针和非 const 引用。

**补充**：位字段成员(通常)比指针支持的粒度小，通常是 `char` 的粒度(通过 `char` 定义，即至少 8 位)。此外，指针不能确定一个位字段成员的类型，即编译器不知道位字段成员的位置。而且，位字段用于紧密地存储信息或者构造一组标志位，很少需要一个指针指向单独的一个字段。

```cpp
struct date2 {
  // d: [1, 31]
  // m: [1, 12]
  unsigned int d : 5, m : 4, y;
};

int main() {
  date2 d;
  // error: attempt to take address of bit-field structure member ‘date2::d’
  std::cout << &d.d << std::endl;
  std::cout << &d.y << std::endl;
  return 0;
}
```

当从位字段初始化一个 const 引用时，创建一个临时值(类型和位字段相同)，拷贝位字段的值，引用受限于该临时值。

位字段的类型只能是整数或枚举。

位字段不能作为静态数据成员。

```cpp
struct S {
  static int b : 12;// error: static member ‘b’ cannot be a bit-field
};

int main() {
  std::cout << sizeof(S) << std::endl;
  return 0;
}
```

不支持位字段数组。

```cpp
struct S {
  int b[10] : 12;// error: function definition does not declare parameters
};

int main() {
  std::cout << sizeof(S) << std::endl;
  return 0;
}
```

## 使用

当我们知道一个域或者一组域不会超过一个限制或者在一个小范围时，可以使用位字段更有效地使用内存。

```cpp
struct date1 {
  // d: [1, 31]
  // m: [1, 12]
  unsigned int d, m, y;
};

struct date2 {
  // d: [1, 31]
  // m: [1, 12]
  unsigned int d : 5, m : 4, y;
};

int main() {
  std::cout << sizeof(date1) << "; " << sizeof(date2) << std::endl;// 12; 8
  return 0;
}
```

## 练习

```cpp
struct S {
    unsigned int x;
    long int y : 33;
    unsigned int z;
};

int main()
{
    S s;
    unsigned int* ptr1 = &s.x;
    unsigned int* ptr2 = &s.z;
    std::cout << (ptr2 - ptr1) << std::endl;// 4
    std::cout << sizeof(unsigned int) << "; " << sizeof(long int) << std::endl;// 4; 8
    std::cout << offsetof(S, x) << "; " << offsetof(S, z) << std::endl;// 0; 16
    return 0;
}
```

```cpp
union S {
    unsigned int x : 3;
    unsigned int y : 3;
    int z;
};
int main()
{
    union S s;
    s.x = 5;
    s.y = 4;
    s.z = 1;
    std::cout << sizeof(s) << std::endl;// 4
    printf("s.x = %d, s.y = %d, s.z = %d\n", s.x, s.y, s.z);// 1 1 1
    return 0;
}
```

## 参考

- [Bit field](https://en.cppreference.com/w/cpp/language/bit_field)
- [Bit Fields in C](https://www.geeksforgeeks.org/bit-fields-c/)
- [c - cannot take address of bit-field](https://stackoverflow.com/questions/13547352/c-cannot-take-address-of-bit-field)
