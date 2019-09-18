# lambda 表达式

- [lambda 表达式](#lambda-%e8%a1%a8%e8%be%be%e5%bc%8f)
  - [问题](#%e9%97%ae%e9%a2%98)
  - [解决方法](#%e8%a7%a3%e5%86%b3%e6%96%b9%e6%b3%95)
  - [返回类型](#%e8%bf%94%e5%9b%9e%e7%b1%bb%e5%9e%8b)
  - ["捕获"变量](#%22%e6%8d%95%e8%8e%b7%22%e5%8f%98%e9%87%8f)
  - [使用 lambda 作为变量](#%e4%bd%bf%e7%94%a8-lambda-%e4%bd%9c%e4%b8%ba%e5%8f%98%e9%87%8f)
  - [参考](#%e5%8f%82%e8%80%83)

## 问题

- C++ 包含一些有用的通用函数，比如 `std::for_each` 和 `std::transform`，用起来很方便。但是使用比较复杂，尤其是使用的仿函数(functor)是唯一的。

```cpp
#include <algorithm>
#include <vector>
#include <iostream>

namespace {
    struct f {
        void operator()(int i) {
            std::cout << i << std::endl;
        }
    };
}

void func(std::vector<int>& v) {
    f f;
    std::for_each(v.begin(), v.end(), f);
}

int main()
{
    int arr[] = {1,10,9};
    std::vector<int> v(arr,arr+3);
    func(v);
    return 0;
}
```

- 如果只使用上述 `f` 一次，看起来写一个完整的类来完成一些微小的事情是过犹不及的。

## 解决方法

- C++11 介绍了 lambda，支持写一个内联、匿名仿函数来替换 `struct f`。对于简单的例子代码会更易读，且易于维护
- 形式定义 `[]() {}`

```cpp
#include <algorithm>
#include <vector>
#include <iostream>

void func(std::vector<int>& v) {
    std::for_each(v.begin(), v.end(), [](int i) {std::cout << i << std::endl;});
}

int main()
{
    int arr[] = {1,10,9};
    std::vector<int> v(arr,arr+3);
    func(v);
    return 0;
}
```

## 返回类型

- 简单的例子中，lambda 的返回类型是编译器推断出来的

```cpp
#include <algorithm>
#include <vector>
#include <iostream>

void func(std::vector<double> &v) {
    std::transform(v.begin(), v.end(), v.begin(),
                   [](double d) {return d < 0.00001 ? 0 : d;}
    );
    std::for_each(v.begin(), v.end(), [](double d) {std::cout << d << std::endl;});
}

int main()
{
    double arr[] = {0.000001,1.0,0.000009};
    std::vector<double> v(arr,arr+3);
    func(v);
    return 0;
}
```

- 但是当实现更加复杂的 lambda 时，会遇到一些情况，编译器不能推断返回类型。此时可以显式地指明lambda 函数的返回值，使用 `-> T`

```cpp
#include <algorithm>
#include <vector>
#include <iostream>

void func(std::vector<double> &v) {
    std::transform(v.begin(), v.end(), v.begin(),
                   [](double d) -> double {
                        if(d < 0.00001)
                            return 0;
                        else
                            return d;
                    }
    );
    std::for_each(v.begin(), v.end(), [](double d) {std::cout << d << std::endl;});
}

int main()
{
    double arr[] = {0.000001,1.0,0.000009};
    std::vector<double> v(arr,arr+3);
    func(v);
    return 0;
}
```

## "捕获"变量

- 也可以使用 lambda 内部的变量。如果想要是有其他变量可以使用捕获语句 `[]`

```cpp
#include <algorithm>
#include <vector>
#include <iostream>

void func(std::vector<double> &v, const double &val) {
    std::transform(v.begin(), v.end(), v.begin(),
                   [val](double d) -> double {
                        if(d < val)
                            return 0;
                        else
                            return d;
                    }
    );
    std::for_each(v.begin(), v.end(), [](double d) {std::cout << d << std::endl;});
}

int main()
{
    double arr[] = {0.000001,1.0,0.000009};
    std::vector<double> v(arr,arr+3);
    double val = 0.000005;
    func(v, val);
    return 0;
}
```

- 可以捕获引用和值，分别使用 `&` 和 `=`
  - `[&val]` 捕获引用
  - `[&]` 捕获当前范围使用的所有变量的引用
  - `[=]` 捕获当前范围使用的所有变量的值
  - `[&, val]` 类似于 `[&]`，但是 val 捕获值
  - `[=, &val]` 类似于 `[=]`，但是 val 捕获引用
- 生成的操作符 `()` 默认是 `const`，捕获默认也是 `const`，使得每次相同的输入产生相同的结果
  - 使用 `[]() mutable -> T {}`，允许改变以值捕获的值

## 使用 lambda 作为变量

- 可以使用 `functional` 头文件
  - `std::function<double(int, bool)> f = [](int a, bool b) -> double {//...}`
  - 通常可让编译器推断类型 `auto f = [](int a, bool b) -> double {//...}`

## 参考

- [What is a lambda expression in C++11?](https://stackoverflow.com/questions/7627098/what-is-a-lambda-expression-in-c11)
