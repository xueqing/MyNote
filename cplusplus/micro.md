# 宏

## 概述

宏是一个已命名的代码段。无论何时使用该名称，都会将其替换为宏的内容。有两种宏，它们的主要区别在于使用时的外观。类对象的宏在使用时类似使用数据对象，类函数的宏类似于函数调用。

可以将任何有效的标识符定义为宏，甚至是一个 C 关键字。预处理器不了解关键字。如果希望对不理解某个关键字(比如 `const`)的旧版本编译器隐藏该关键字，这是有用的。但是，定义的预处理器运算符 `defined` 永远不能定义为宏，并且编译 C++ 时，C++ 的命名运算符不能是宏。

## 类对象的宏

类对象的宏是一个简单的标识符，它将被替换为代码片段。将其称为类对象的，是因为它在使用的代码中看起来像一个数据对象。它们最常用于为数字常量提供符号名称。

可以使用 `#define` 指令创建宏。`#define` 其后跟宏的名称，然后是缩写的标记序列，它被称为宏的主体、扩展或替换表。比如

```c
#define BUFFER_SIZE 1024
```

定义一个名为 `BUFFER_SIZE` 的宏作为标记 `1024` 的缩写。如果在此 `#define` 指令的某个地方有类似下面格式的 C 代码：

```c
foo = (char *) malloc (BUFFER_SIZE);
```

那么 C 预处理器会识别并扩展宏 `BUFFER_SIZE`。C 编译器会将其视为下面的代码

```c
foo = (char *) malloc (1024);
```

按照惯例，宏名称使用大写字母书写。当可以一眼看出哪些名称是宏时，程序更易于阅读。

宏的主体在 `#define` 行的末尾结束。如果需要，可以使用反斜线换行符将定义持续多行。但是，当展开宏时，它会全部出现在一行中。例如：

```c
#define NUMBERS 1, \
                2, \
                3
int x[] = { NUMBERS };
     → int x[] = { 1, 2, 3 };
```

最常见的可见结果是错误消息中令人惊讶的行号。

只要宏的主体可以分解为有效的预处理标记，则对宏的主体可以包含的内容没有限制，括号不需要平衡，且正文不需要类似于有效的 C 代码。(否则，在使用宏时可能收到 C 编译器报的错误消息。)

C 预处理器按顺序扫描程序。宏定义在书写它们的地方生效。因此，C 处理器将下面的输入

```c
foo = X;
#define X 4
bar = X;
```

输出

```c
foo = X;
bar = 4;
```

当预处理器扩展宏名称时，宏的扩展会替换宏调用，然后检查扩展以获取更多要扩展的宏。例如

```c
#define TABLESIZE BUFSIZE
#define BUFSIZE 1024
TABLESIZE
     → BUFSIZE
     → 1024
```

首先扩展 `TABLESIZE` 得到 `BUFSIZE`，然后扩展 `BUFSIZE` 宏得到最后的结果 1024。

注意在定义 `TABLESIZE` 时没有定义 `BUFSIZE`。`TABLESIZE` 的 `#define` 使用指定的宏——这里是 `BUFSIZE`——并且不检查 `BUFSIZE` 是否也包含宏名称。只有当使用 `TABLESIZE` 时，才会扫描其扩展的结果以获取更多宏名称。

如果在源文件的某处更改 `BUFSIZE` 的定义，这会有不同的结果。如图所示定义的 `TABLESIZE` 将始终使用当前有效的 `BUFSIZE` 定义：

```c
#define BUFSIZE 1020
#define TABLESIZE BUFSIZE
#undef BUFSIZE
#define BUFSIZE 37
```

现在 `TABLESIZE` 扩展(两个阶段)为 37。

如果宏的扩展直接或通过间接的宏包含自身，当检查扩展获取更多宏时不再扩展。这会避免无限递归。查看[自引用的宏](https://gcc.gnu.org/onlinedocs/cpp/Self-Referential-Macros.html#Self-Referential-Macros)，获取更多细节。

## 类函数的宏

可以定义看起来像函数调用的宏。这些称为类函数的宏。要定义类函数的宏，使用相同的 `#define` 指令，但是在宏名称之后立刻放一对括号。例如

```c
#define lang_init()  c_init()
lang_init()
     → c_init()
```

类函数的宏只有在其名称后有一对括号时才会扩展。如果只书写名称，则编译器会置之不理。当有一个同名的函数和宏，且有时希望使用该函数时，这比较有用。

```c
extern void foo(void);
#define foo() /* optimized inline version */
…
  foo();
  funcptr = foo;
```

这里调用 `foo()` 会使用宏，但是函数指针会得到实际函数的地址。如果要扩展宏，则会导致语法错误。

如果在宏定义中的宏名称和括号之间放置空格，将不能定义类函数的宏。它定义了类对象的宏，其扩展恰好以一对括号开头。

```c
#define lang_init ()    c_init()
lang_init()
     → () c_init()()
```

这个扩展中的前两对括号来自宏。第三个是宏调用之后的括号对。由于 `lang_init` 是一个类对象的宏，它不使用这些括号。

## 参考

- [micro](https://gcc.gnu.org/onlinedocs/cpp/Macros.html)
