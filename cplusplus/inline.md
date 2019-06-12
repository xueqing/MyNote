# 内联

- [内联](#%E5%86%85%E8%81%94)
  - [描述](#%E6%8F%8F%E8%BF%B0)
  - [术语和定义](#%E6%9C%AF%E8%AF%AD%E5%92%8C%E5%AE%9A%E4%B9%89)
    - [编译单元](#%E7%BC%96%E8%AF%91%E5%8D%95%E5%85%83)
    - [单定义规则](#%E5%8D%95%E5%AE%9A%E4%B9%89%E8%A7%84%E5%88%99)
  - [内联声明](#%E5%86%85%E8%81%94%E5%A3%B0%E6%98%8E)
    - [非成员函数](#%E9%9D%9E%E6%88%90%E5%91%98%E5%87%BD%E6%95%B0)
    - [成员函数](#%E6%88%90%E5%91%98%E5%87%BD%E6%95%B0)
  - [不适合内联替换的用法](#%E4%B8%8D%E9%80%82%E5%90%88%E5%86%85%E8%81%94%E6%9B%BF%E6%8D%A2%E7%9A%84%E7%94%A8%E6%B3%95)
  - [C/C++ static/extern + inline](#cc-staticextern--inline)
    - [C89/90 inline](#c8990-inline)
    - [C99 inline](#c99-inline)
    - [C++ inline](#c-inline)
  - [GCC 编译选项](#gcc-%E7%BC%96%E8%AF%91%E9%80%89%E9%A1%B9)
  - [内联函数对安全性和速度的取舍](#%E5%86%85%E8%81%94%E5%87%BD%E6%95%B0%E5%AF%B9%E5%AE%89%E5%85%A8%E6%80%A7%E5%92%8C%E9%80%9F%E5%BA%A6%E7%9A%84%E5%8F%96%E8%88%8D)
  - [inline vs micro](#inline-vs-micro)
  - [问题](#%E9%97%AE%E9%A2%98)
    - [问题：C99 inline without static or extern](#%E9%97%AE%E9%A2%98c99-inline-without-static-or-extern)
  - [参考](#%E5%8F%82%E8%80%83)

## 描述

- C++ 提出，C99 引入支持，C89 支持内联扩展
- `inline`用于需要某个函数的定义对调用者可见的程序优化
  - 可见性：函数需要有内部链接，或者外部链接且和调用者在同一个编译单元。此时，函数声明或定义中的`inline`只用于指示对这个函数的调用可被展开优化
  - 当调用者和被调用的函数定义位于不同的编译单元时，`inline`支持包含调用者的编译单元也包含一个局部(内联)的函数的定义
- `inline`用于声明一个内联函数，可使 GCC 直接更快地调用此函数
  - GCC 可以将内联函数代码展开插入到调用者代码内部，因此减少了函数调用(寄存器状态的修改保存)的负载
  - 如果实参的值是常量，可在编译时计算简化，因此不是所有内联函数代码都会被包含
- 可使用`-finline-functions`选项指定 GCC 将所有“足够简单”的函数展开插入到调用者内部
- `inline`用于多个编译单元调用某个函数，但是只想暴露该函数的定义在一个头文件
- 在关闭优化时，GCC 不会内联任何函数，必须在某处定义符号，`inline`声明定义的函数才是可见的

## 术语和定义

### 编译单元

- [What is a “translation unit” in C++](https://stackoverflow.com/questions/1106149/what-is-a-translation-unit-in-c)
- 编译单元(compilation/translation unit): C++ 编译的基础单元。包括一个单独的源文件，以及直接或间接包含的头文件的内容，减去条件预处理忽视的内容
- 一个编译单元可被编译成一个目标文件、库或可执行程序

### 单定义规则

- [What exactly is One Definition Rule in C++](https://stackoverflow.com/questions/4192170/what-exactly-is-one-definition-rule-in-c)
- 单定义规则(one-definition rule)：每个程序对于其使用的每个非内联函数或对象应该只包含一个定义。定义可以显式出现在该程序中，可在标准库或用户定义的库中查找，或者隐式定义。内联函数应在每个使用的编译单元中定义
- 每个编译单元对于所有的变量、函数、类的类型、枚举类型或模板不超过一个定义

## 内联声明

### 非成员函数

- GCC 实现三种语法来声明内联函数
  - 使用`-finline-functions`，同时指定参数`-std=gnu89/fgnu89-inline`，或所有内联函数声明处有`gnu-inline`属性
  - 指定参数`-std=c99/-std=gnu99`，或者使用更新的 C 版本
  - 编译 C++ 代码
- 使用`inline`关键字

```c
static inline int inc(int *a)
{
  return (*a)++;
}
```

- 如果在 ISO C90 程序的头文件中声明内联，使用`__inline__`
- 上述三种类型的内联行为再两种情况下是行为是类似的
  - 用于`static`函数
  - 第一次声明时未使用`inline`关键字，定义时使用`inline`关键字
- 除了速度，上述两种方式和不使用`inline`关键字行为相同

```c
extern int inc(int *a);
inline int inc(int *a)
{
  return (*a)++;
}
```

- 当一个函数是`static inline`时，如果所有调用函数的地方展开插入了此函数的代码，而且函数的地址从未被使用，那么函数自己的汇编代码从未被引用。这种情况下，除非使用`-fkeep-inline-functions`，GCC 实际上不会为此函数生成汇编代码。如果有一处调用未展开插入代码，那么正常生成汇编代码；如果程序引用了该地址，函数必须正常编译，因为此处不能被内联
- **注意**：除非是在一个`.cpp`文件使用，必须将内联函数定义放在一个头文件，然后从其他`.cpp`调用，否则会有链接错误`unresolved external`

### 成员函数

- GCC 将定义在类内的成员函数视作内联函数(可没有`inline`)。可使用`-fno-default-inline`覆盖

```cpp
class Fred {
public:
  void f(int i, char c)
    {
      // ...
    }
};
```

- 类似声明非成员函数：声明时不带`inline`，定义时使用`inline`，在类外部定义
  - **建议使用此方式，以隐藏类的实现**

```cpp
class Foo {
public:
  void method();  // Best practice: Don't put the inline keyword here
  // ...
};

inline void Foo::method()  // Best practice: Put the inline keyword here
{
  // ...
}
```

- **注意**：必须将内联函数定义放在一个头文件，然后从其他`.cpp`调用，否则会有链接错误`unresolved external`

## 不适合内联替换的用法

- 函数定义包含下面用法的不适合内联替换
  - 可变参数函数
  - 使用`alloca`函数
  - 使用计算的`goto`
  - 使用非本地的`goto`
  - 使用嵌入函数
  - 使用`setjmp`
  - 使用`__builtin_longjmp`/`__builtin_return`/`__built_apply_args`

## C/C++ static/extern + inline

### C89/90 inline

- inline：可能会被内联展开。总会生成非内联版本且对外部可见。只在一个编译单元定义，其他编译单元可见且视为非内联函数
  - 每个编译单元只会拥有该函数的拷贝，每个拷贝只对编译单元内部可见，且拷贝之间不会有冲突。缺点包括两部分
    - 大型工程中，可能包含很多相同函数的拷贝，导致目标代码增大
    - 不太可能比较函数指针，因为不确定是哪份拷贝版本
  - C89 编译器支持内联扩展
    - MVC++：`__forceinline`
    - GCC/Clang：在不优化时，除非指定`always_inline`属性，GCC 不会内联任何函数
      - `__attribute__((always_inline))`
      - `__attribute__((__always_inline__))`：可避免与用户定义的宏`always_inline`冲突
    - 编译器在某些情况下不能内联替换，此时会有编译警告
    - 建议使用下面的可移植代码

    ```c
    #ifdef _MSC_VER
      #define forceinline __forceinline
    #elif defined(__GNUC__)
        #define forceinline inline __attribute__((__always_inline__))
    #elif defined(__CLANG__)
        #if __has_attribute(__always_inline__)
            #define forceinline inline __attribute__((__always_inline__))
        #else
            #define forceinline inline
        #endif
    #else
        #define forceinline inline
    #endif
    ```

- extern inline：不会生成非内联版本对外部可见，但是可以调用(必须在其他编译单元定义，且调用的代码和内联代码相同)，`one-definition`的原则适用
  - 原因：C89 中定义为`extern`的存储不会被保留，而不带`extern`的存储一定会保留；C99 的`extern inline`会生成非内联函数
  - 类似宏。使用方式是将函数定义(同时指定`inline`和`extern`关键字)放在一个头文件中，把另一个定义的拷贝(不指定`inline`和`extern`关键字)放在一个库文件中。头文件的定义使得大部分函数调用都是内联展开的。如果存在其他编译单元的函数调用，引用这个库文件的唯一拷贝
- static inline：不会生成外部可见的非内联版本，但是可能会生成一个局部可见的函数，`one-definition`的原则不适用

### C99 inline

- inline：类似 C89/90的`extern inline`，不会生成外部可见代码，但是可以调用(必须在其他编译单元定义，且调用的代码和内联代码相同)
  - 在头文件(.h)中使用`inline`定义，在一个编译单元的源文件(.c)中使用`extern`和`inline`

  ```c
  //.h
  inline double dabs(double x) {return x < 0.0 ? -x : x;}
  //.c
  extern inline double dabs(double x);
  ```

- extern inline：类似 C89/90的`inline`，不会生成外部可见代码，至多一个编译单元可以使用此函数
  - 定义为`inline`的函数要求：程序的其他地方有且只有一处需要声明该函数为`extern inline`或没有修饰符
    - 如果有多处声明，链接器会报重复的符号错误
    - 其他地方没有声明，链接器不会报错
  - 建议：在头文件定义`inline`函数，为每个函数创建一个`.c`文件，包含该函数的`extern inline`声明以及对应的头文件：声明和包含头文件的语句先后无关
- static inline：类似 C89/90，二者之间相同

### C++ inline

- inline：一处内联其他所有地方都会内联。编译器/链接器会排序该符号的多个实例
  - 在头文件定义，对整个工程可见；且如果不能展开替换，只会生成一个外部符号
  - 在所有地方有相同的定义，必须有`inline`关键字
  - 类内定义的函数会自动添加`inline`修饰符
- extern inline：没有此定义，支持的编译器行为类似 C89/90
- static inline：没有此定义，支持的编译器行为类似 C89/90

## GCC 编译选项

- GCC 版本大于等于 4.2：使用 C89 的`inline`语法，即使显式指定了`-std=c99`
- GCC 版本是 5：GCC 使用 gnu11 的语法，默认使用 C99 的`inline`语法
  - 显式指定`-std=gnu89`：使用 C89 语法
  - 指定`-fgnu89-inline`或在所有`inline`声明处增加`gnu_inline`属性：使用 C89 语法，只会影响内联
  - 指定`-std=c99`或`-std=c11`或`-std=gnu99`(不带`-fgnu89-inline`)：确定使用 C99 语法
- 使用`-winline`：当标记为`inline`的函数不可替换时，编译警告

## 内联函数对安全性和速度的取舍

- C 语言中，可以通过在结构体中放一个`void*`实现对结构体的封装，即结构体的使用者不知道`void*`指向的真正的数据，但可以通过调用函数将`void*`转成合适的隐藏类型。这个做法会破坏类型的安全性，也会包括对结构体其他字段的访问(如果允许直接访问结构体的域，需要知道如何解释`void*`的使用者就可以直接访问结构体，使得很难修改底层的数据结构)
- 包含内联函数的目标代码的大小和执行速度的影响是不可预测的
  - 时间性能：以空间换时间
    - 可使程序变快
      - 减少函数调用的代价
        - 可移除函数调用所需的指令：栈和寄存器的使用
        - 不需要寄存器传递参数
        - 在引用调用、地址调用或共享调用时，不需要引用和解引用
      - 支持高级优化和调度
    - 可使程序变慢：内联展开会增加代码大小，在内存页有限的情况下，可能增加内存页的置换和磁盘的读写
  - 目标代码大小
    - 可使程序变大：通常状况下展开代码类似于拷贝代码
    - 可使程序变小：展开函数时，编译器可能会优化代码，移除不必要的代码
  - 内存性能
    - 系统抖动(内存页置换)
      - 调用的内联函数和当前函数可能位于不同的页，内联展开可能使其位于同一个页，可避免系统抖动
      - 可能增大二进制可执行文件大小，导致系统抖动
    - 缓存未命中
      - 内联通常改善了二进制代码内部引用的局部性，可减少使用缓存行来存储内部循环，使得 CPU 受限的应用运行更快
      - 可能导致对多个缓存行的循环处理，导致缓存抖动
  - 可能和运行速度无关：大部分系统不是 CPU 受限的，而是 I/O、数据库或网络受限的，即系统整个性能的瓶颈在于文件系统、数据库或网络。因此，除非 CPU 固定在 100%，内联函数不会使得程序运行更快

## inline vs micro

- 展开时间不同
  - 内联展开发生在编译时，不会修改源码(text)
  - 宏展开发生在编译之前，生成不同的 text 再给编译器处理，会污染命名空间和代码，不利于调试
- 类型检查：C 语言中宏调用没有类型检查；内联函数会检查参数类型，必须正确执行类型转换
- C 语言中，宏不能像函数一样调用`return`关键字，不能终止调用者
- 编译错误：宏内的编译错误很难理解，因为指向的是展开的代码，而不是源代码
- 递归：很多编译器可以内联递归函数，但是递归宏是不允许的
  - 有的编译器可控制递归展开的深度
- 代码的可维护性：随着函数改进，函数的内联属性可能会变化，一个函数内联与否比宏的修改要简单
- 宏的其他问题
  - 含[`if`](https://isocpp.org/wiki/faq/misc-technical-issues#macros-with-if)
  - 含[多个语句](https://isocpp.org/wiki/faq/misc-technical-issues#macros-with-multi-stmts)
  - 含[令牌黏贴](https://isocpp.org/wiki/faq/misc-technical-issues#macros-with-token-pasting)
- 内联函数避免上述问题：内联函数检查每个参数一次，类似于调用普通函数，但是更快

```c
// A macro that returns the absolute value of i
#define unsafe(i) ( (i) >= 0 ? (i) : -(i) )

// An inline function that returns the absolute value of i
inline int safe(int i) { return i >= 0 ? i : -i; }

int f();

void userCode(int x)
{
  int ans;

  ans = unsafe(x++);   // Error! x is incremented twice
  ans = unsafe(f());   // Danger! f() is called twice

  ans = safe(x++);     // Correct! x is incremented once
  ans = safe(f());     // Correct! f() is called once
}
```

## 问题

- 编译器不一定会内联程序员指定的函数
  - 模板方法/函数不是总被内联展开
- 内联函数的代码暴露给调用者
- 传统的 C 编译系统会增加内联编译时间，因为会拷贝函数体到调用者
- C99 的要求
  - 如果在别处使用某内联函数，只能有一个`extern`声明。当关掉优化禁止内联时，如果没有会有链接错误
  - 如果增加声明，放到一个库进行链接，使用链接时优化或`static inline`，可能导致不能到达的代码
- C++中，普通函数只需要在一个模块中定义，但是需要在每个模块中定义使用的内联函数，否则不能编译某个单独的模块(依赖其他模块)。视编译器而定，可能会导致不能内联替换的模块的对象文件包含函数的拷贝
- 在嵌入式软件中，可能通过类似`pragma`编译指令将一些函数放到代码段。如果一个内存段的代码调用另一个内存段的代码，如果被调用函数内部有内联，那么可能会停到一个不应该的段。比如高性能的内存段代码空间有限，如果内部函数调用另一个高性能内存之外的函数，且被调用函数较大，内部有内联的话，可能会超出高性能内存的空间
- C++ 编译时链接，因此如果修改了内联函数，必须重新编译使用此函数的所有代码

### 问题：C99 inline without static or extern

- [C, inline function and GCC [duplicate]](https://stackoverflow.com/questions/26503235/c-inline-function-and-gcc)
- [Is “inline” without “static” or “extern” ever useful in C99](https://stackoverflow.com/questions/6312597/is-inline-without-static-or-extern-ever-useful-in-c99)
- [C99 inline function in .c file](https://stackoverflow.com/questions/16245521/c99-inline-function-in-c-file/16245669#16245669)

```cpp
// main.cpp
inline int foo() {return 10 + 3;}

int main() {foo(); return 0;}
// g++ -std=c99 -x c main.cpp
// gcc -std=c99 -o a main.cpp
```

- GCC 链接错误`undefined reference to foo`
- 问题：`inline`只是声明内联函数，不会生成实际的代码，但是`extern`和`static`用于告诉编译器将函数放在哪个对象文件，用于编译生成对应的代码(可能是拷贝)
- 解决方案：
  - 增加`extern inline int foo();`
  - 增加`static`修饰符，告诉编译器`有且只在这里`，以便生成对应代码
  - 或使用`-O`优化代码，编译器将标记为`inline`的代码内联展开，在这里会忽略这部分代码

## 参考

- [Inline function](https://en.wikipedia.org/wiki/Inline_function)
- [An Inline Function is As Fast As a Macro](https://gcc.gnu.org/onlinedocs/gcc/Inline.html)
- [inline functions](https://isocpp.org/wiki/faq/inline-functions)
- [Myth and reality about inline in C99](https://gustedt.wordpress.com/2010/11/29/myth-and-reality-about-inline-in-c99/)
