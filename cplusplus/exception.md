# 异常

- [异常](#%e5%bc%82%e5%b8%b8)
  - [为什么使用异常](#%e4%b8%ba%e4%bb%80%e4%b9%88%e4%bd%bf%e7%94%a8%e5%bc%82%e5%b8%b8)
  - [C++ 使用异常](#c-%e4%bd%bf%e7%94%a8%e5%bc%82%e5%b8%b8)
    - [使用异常的反对观点](#%e4%bd%bf%e7%94%a8%e5%bc%82%e5%b8%b8%e7%9a%84%e5%8f%8d%e5%af%b9%e8%a7%82%e7%82%b9)
    - [替代方案：通过判断或函数返回值检查错误](#%e6%9b%bf%e4%bb%a3%e6%96%b9%e6%a1%88%e9%80%9a%e8%bf%87%e5%88%a4%e6%96%ad%e6%88%96%e5%87%bd%e6%95%b0%e8%bf%94%e5%9b%9e%e5%80%bc%e6%a3%80%e6%9f%a5%e9%94%99%e8%af%af)
    - [使用 try/catch/throw 而不是条件判断和返回错误码来改善软件质量](#%e4%bd%bf%e7%94%a8-trycatchthrow-%e8%80%8c%e4%b8%8d%e6%98%af%e6%9d%a1%e4%bb%b6%e5%88%a4%e6%96%ad%e5%92%8c%e8%bf%94%e5%9b%9e%e9%94%99%e8%af%af%e7%a0%81%e6%9d%a5%e6%94%b9%e5%96%84%e8%bd%af%e4%bb%b6%e8%b4%a8%e9%87%8f)
      - [异常便于传递错误信息](#%e5%bc%82%e5%b8%b8%e4%be%bf%e4%ba%8e%e4%bc%a0%e9%80%92%e9%94%99%e8%af%af%e4%bf%a1%e6%81%af)
      - [异常使得代码更简洁](#%e5%bc%82%e5%b8%b8%e4%bd%bf%e5%be%97%e4%bb%a3%e7%a0%81%e6%9b%b4%e7%ae%80%e6%b4%81)
      - [异常更易区分正常执行的代码](#%e5%bc%82%e5%b8%b8%e6%9b%b4%e6%98%93%e5%8c%ba%e5%88%86%e6%ad%a3%e5%b8%b8%e6%89%a7%e8%a1%8c%e7%9a%84%e4%bb%a3%e7%a0%81)
    - [使用异常处理错误是值得的](#%e4%bd%bf%e7%94%a8%e5%bc%82%e5%b8%b8%e5%a4%84%e7%90%86%e9%94%99%e8%af%af%e6%98%af%e5%80%bc%e5%be%97%e7%9a%84)
    - [构造函数可以抛异常](#%e6%9e%84%e9%80%a0%e5%87%bd%e6%95%b0%e5%8f%af%e4%bb%a5%e6%8a%9b%e5%bc%82%e5%b8%b8)
    - [析构函数不抛异常](#%e6%9e%90%e6%9e%84%e5%87%bd%e6%95%b0%e4%b8%8d%e6%8a%9b%e5%bc%82%e5%b8%b8)
    - [抛出什么异常](#%e6%8a%9b%e5%87%ba%e4%bb%80%e4%b9%88%e5%bc%82%e5%b8%b8)
    - [捕获什么异常](#%e6%8d%95%e8%8e%b7%e4%bb%80%e4%b9%88%e5%bc%82%e5%b8%b8)
    - [throw 再次抛异常](#throw-%e5%86%8d%e6%ac%a1%e6%8a%9b%e5%bc%82%e5%b8%b8)
    - [注解](#%e6%b3%a8%e8%a7%a3)
  - [参考](#%e5%8f%82%e8%80%83)

## 为什么使用异常

- 使用异常处理错误使得代码更简单、更干净，并且更不可能错过错误。使用 `errno` 和 `if` 语句使得错误处理和普通代码紧密缠绕，因此代码更加凌乱，也更难确保已经处理了所有的错误。
- 构造函数的工作是创建类的不变性(创建成员函数运行的环境)，这经常需要获取如内存、锁、文件、套接字等资源，即 [RAII](https://zh.cppreference.com/w/cpp/language/raii)(Resource Acquisition Is Initialization)。
- 报告一个构造函数检查到的错误需要抛异常实现。

## C++ 使用异常

- C++ 中，异常用于指示内部不能处理的错误，比如构造函数内部获取资源失败。
- 不要使用异常作为函数的返回值。
- C++ 使用异常来支持错误处理：
  - 使用 `throw` 指示错误(函数不能处理错误，或者暴露错误的后置条件)。
  - 在知道可以处理错误的时候使用 `catch` 指定错误处理行为(可以翻译成另一种类型并且重新抛出)。
  - 不要使用 `throw` 指示调用函数的代码错误。而是使用 `assert` 或其他机制，或者发送进程给调试器，或者使得进程崩溃并收集崩溃日志以便程序员调试。
  - 当发现对组件不变式的意外违反时，不要使用 `throw`，使用 `throw` 或其他机制来终止程序。抛出异常不能解决内存崩溃甚至会导致后续使用数据的错误。

### 使用异常的反对观点

- 异常是昂贵的：和没有错误处理相比，现代 C++ 实现已经将异常的负载降到 3% 左右。正常情况不抛异常，比使用返回值和检查代码运行更快。只有出现错误才会有负载。
- JSF++ 禁止异常：JSF++ 是[硬实时](https://stackoverflow.com/questions/17308956/differences-between-hard-real-time-soft-real-time-and-firm-real-time)和严格安全性的应用(飞机控制系统)。我们必须保证响应时间，所以我们不能使用异常，甚至禁止使用释放分配的存储。
- 使用 new 调用构造函数抛异常会导致内存泄漏：这是旧编译器的 bug，现在早已经解决了。

```cpp
T *p= new T;//将被编译器转换给类似下面的代码
void  allocate_and_construct()
{
    // 第一步，分配原始内存，若失败则抛出bad_alloc异常
    try
    {
        // 第二步，调用构造函数构造对象
        new (p)T;       // placement new: 只调用T的构造函数
    }
    catch(...)
    {
        delete p;     // 释放第一步分配的内存
        throw;          // 重抛异常，通知应用程序
    }
}
```

### 替代方案：通过判断或函数返回值检查错误

```cpp
ofstream os("myfile");//需要打开一个文件
if(os.bad()) { /*打开失败需要处理错误*/ }
```

- 可以通过函数返回一个错误码或设置一个局部变量(如 errno)。
  - 不使用全局变量：全局变量需要立即检查，因为其他函数可能会重置它；多线程也会有问题。
  - 这就需要测试每个对象。当类由许多对象组成，尤其是这些子对象互相依赖时，会导致代码一团糟。
- 但是检查返回值要求智慧甚至不可能达到目的。比如下面的代码
  - 对于 my_negate 函数，每一个 int 返回值都是正确的，但是当使用二进制补码表示的时候，是没有最大负数的，可参考[C语言中INT_MIN的一些问题](http://blog.sina.com.cn/s/blog_624e65810100xm3m.html)。这种情况下，就需要返回值对，分别表示错误码和运算结果。

```cpp
double d = my_sqrt(-1);//错误返回 -1
if(d == -1) { /*处理错误*/ }
int x = my_negate(INT_MIN);//额。。。
```

### 使用 try/catch/throw 而不是条件判断和返回错误码来改善软件质量

- 条件语句更易犯错
- 延迟发布时间：白盒测试需要覆盖所有条件分支
- 增加开发花费：非必须的条件控制增加了发现 bug、解决 bug 和测试的复杂度
- 检测到错误的代码通常需要传递错误信息，这可能是多层函数调用，这种情况下每一层调用函数都需要添加判断代码和返回值；而异常可以更简洁、干净地传递错误信息到可以处理错误的调用者

#### 异常便于传递错误信息

- 使用异常

```cpp
void f1()
{
  try {
    // ...
    f2();
    // ...
  } catch (some_exception& e) {
    // ...code that handles the error...
  }
}

void f2() { ...; f3(); ...; }
// f3 到 f9 逐层调用，f9 调用 f10

void f10()
{
  // ...
  if ( /*...some error condition...*/ )
    throw some_exception();
  // ...
}
```

- 不使用异常

```cpp
int f1()
{
  // ...
  int rc = f2();
  if (rc == 0) {
    // ...
  } else {
    // ...code that handles the error...
  }
}

int f2()
{
  // ...
  int rc = f3();
  if (rc != 0)
    return rc;
  // ...
  return 0;
}

// f3 到 f9 都需要增加判断代码

int f10()
{
  // ...
  if (...some error condition...)
    return some_nonzero_error_code;
  // ...
  return 0;
}
```

#### 异常使得代码更简洁

Number 类支持加减乘除 4 种基本运算，但是加会溢出，除会导致除 0 错误或向下溢出等等

- 使用异常

```cpp
void f(Number x, Number y)
{
  try {
    // ...
    Number sum  = x + y;
    Number diff = x - y;
    Number prod = x * y;
    Number quot = x / y;
    // ...
  }
  catch (Number::Overflow& exception) {
    // ...code that handles overflow...
  }
  catch (Number::Underflow& exception) {
    // ...code that handles underflow...
  }
  catch (Number::DivideByZero& exception) {
    // ...code that handles divide-by-zero...
  }
}
```

- 不使用异常

```cpp
int f(Number x, Number y)
{
  // ...

  Number::ReturnCode rc;
  Number sum = x.add(y, rc);
  if (rc == Number::Overflow) {
    // ...code that handles overflow...
    return -1;
  } else if (rc == Number::Underflow) {
    // ...code that handles underflow...
    return -1;
  } else if (rc == Number::DivideByZero) {
    // ...code that handles divide-by-zero...
    return -1;
  }

  Number diff = x.sub(y, rc);
  if (rc == Number::Overflow) {
    // ...code that handles overflow...
    return -1;
  } else if (rc == Number::Underflow) {
    // ...code that handles underflow...
    return -1;
  } else if (rc == Number::DivideByZero) {
    // ...code that handles divide-by-zero...
    return -1;
  }

  Number prod = x.mul(y, rc);
  if (rc == Number::Overflow) {
    // ...code that handles overflow...
    return -1;
  } else if (rc == Number::Underflow) {
    // ...code that handles underflow...
    return -1;
  } else if (rc == Number::DivideByZero) {
    // ...code that handles divide-by-zero...
    return -1;
  }

  Number quot = x.div(y, rc);
  if (rc == Number::Overflow) {
    // ...code that handles overflow...
    return -1;
  } else if (rc == Number::Underflow) {
    // ...code that handles underflow...
    return -1;
  } else if (rc == Number::DivideByZero) {
    // ...code that handles divide-by-zero...
    return -1;
  }

  // ...
}
```

#### 异常更易区分正常执行的代码

- 使用异常

```cpp
void f()  // Using exceptions
{
  try {
    GResult gg = g();
    HResult hh = h();
    IResult ii = i();
    JResult jj = j();
    // ...
  }
  catch (FooError& e) {
    // ...code that handles "foo" errors...
  }
  catch (BarError& e) {
    // ...code that handles "bar" errors...
  }
}
```

- 不使用异常

```cpp
int f()  // Using return-codes
{
  int rc;  // "rc" stands for "return code"

  GResult gg = g(rc);
  if (rc == FooError) {
    // ...code that handles "foo" errors...
  } else if (rc == BarError) {
    // ...code that handles "bar" errors...
  } else if (rc != Success) {
    return rc;
  }

  HResult hh = h(rc);
  if (rc == FooError) {
    // ...code that handles "foo" errors...
  } else if (rc == BarError) {
    // ...code that handles "bar" errors...
  } else if (rc != Success) {
    return rc;
  }

  IResult ii = i(rc);
  if (rc == FooError) {
    // ...code that handles "foo" errors...
  } else if (rc == BarError) {
    // ...code that handles "bar" errors...
  } else if (rc != Success) {
    return rc;
  }

  JResult jj = j(rc);
  if (rc == FooError) {
    // ...code that handles "foo" errors...
  } else if (rc == BarError) {
    // ...code that handles "bar" errors...
  } else if (rc != Success) {
    return rc;
  }

  // ...

  return Success;
}
```

### 使用异常处理错误是值得的

- 使用异常处理错误需要付出
  - 异常处理要求原则和严谨：需要学习；
  - 异常处理不是万能药：如果团队是草率没有纪律的，那么使用异常和返回值都会有问题
  - 异常处理不是通用的：应当知道什么条件应该使用返回值，什么条件使用异常
  - 异常处理会鞭策学习新技术

### 构造函数可以抛异常

- 当不能正确初始化或构造一个对象时，**应该**在构造函数内部抛出异常
  - 构造函数没有返回值，所以不能使用返回错误码的方式
  - 最差的方式是使用一个内部状态码来判断是否构造成功，但是需要在每次调用构造函数的时候使用 `if` 检查状态码，或者在成员函数内部增加 `if` 检查
- 构造函数抛异常也不会有内存泄漏
  - 构造函数抛异常时，对象的析构函数不会运行。因为对象的生命周期是构造函数成功完成或返回，抛异常表示构造失败，生命周期没有开始。因此需要将 undone 的东西保存在对象的数据成员
  - 比如使用智能指针保存分配的成员对象，而不是保存到原始的 Fred* 数据成员

  ```cpp
  // Fred.h
  #include <memory>

  class Fred {
  public:
    //typedef 简化了使用 Fred 对象的语法，可以使用Fred::Ptr 取代 std::unique_ptr<Fred>
    typedef std::unique_ptr<Fred> Ptr;
    // ...
  };

  //调用者 cpp
  #include "Fred.h"

  void f(std::unique_ptr<Fred> p);  // explicit but verbose
  void f(Fred::Ptr             p);  // simpler

  void g()
  {
    std::unique_ptr<Fred> p1( new Fred() );  // explicit but verbose
    Fred::Ptr             p2( new Fred() );  // simpler
    // ...
  }
  ```

### 析构函数不抛异常

- 析构函数抛异常会导致异常点之后的代码不能指向，可能造成内存泄漏问题
- 可以在析构函数抛异常，但是该异常不能出析构函数，即需要在析构函数内部使用 `catch` 捕获异常。否则会破坏标准库和语言的规则。
- 处理方式是：
  - 可以写信息到日志文件，终止进程。
  - 提供一个普通函数执行可能抛异常的操作，给客户处理错误。
- C++ 规则是异常的 “栈展开(stack unwinding)” 进程中调用的析构函数不能抛异常：
  - “stack unwinding”：当抛出一个异常时，栈是 “unwound” 的，因此在 `throw` 和 `catch` 之间的[栈帧](https://www.techopedia.com/definition/22304/stack-frame)会被弹出。
  - 在 “stack unwinding” 过程中，这些栈帧中的所有局部变量会被析构。如果其中一个析构函数抛出异常，C++ 运行时系统将进入 “no-win” 状态：两个异常只能处理一个，忽视任何一个都会丢失信息。
  - 此时 C++ 会调用 `terminate()` 终止进程。即在发生异常的情况下调用析构函数抛出异常会导致程序崩溃。因此避免的方法就是永远不要在析构函数抛异常。

### 抛出什么异常

- 抛出对象。如果可以，写子类继承自 `std::exception` 类，可以提供更多关于异常的信息

### 捕获什么异常

- 可以的话，捕获异常的引用：拷贝可能会有不同的行为；指针则不确定是否需要删除指向异常的指针

### throw 再次抛异常

- 可用于实现简单的 “stack-trace”，即堆栈跟踪，在程序重要函数内部增加 `catch` 语句

```cpp
class MyException {
public:
  // ...
  void addInfo(const std::string& info);
  // ...
};

void f()
{
  try {
    // ...
  }
  catch (MyException& e) {
    e.addInfo("f() failed");
    throw;//再次抛出当前异常
  }
}
```

- 也可用于 “exception dispatcher”，即异常分发

```cpp
void handleException()
{
  try {
    throw;
  }
  catch (MyException& e) {
    // ...code to handle MyException...
  }
  catch (YourException& e) {
    // ...code to handle YourException...
  }
}

void f()
{
  try {
    // ...something that might throw...
  }
  catch (...) {
    handleException();
  }
}
```

### 注解

- 不是所有编译器支持异常捕获(exception-try-block)，只有 GCC 和大多数新版本的 MSVC 支持。
- 初始化的异常不能被隐藏：构造函数内的异常处理部分必须抛出一个异常，或重新抛出捕获的异常。下面两个版本的代码是等价的

```cpp
// Version 1
struct A
{
    Buf b_;

    A(int n)
    try
        : b_(n)
    {
        cout << "A initialized" << endl;
    }
    catch(BufError& )
    {
        cout << "BufError caught" << endl;
    }
};

// Version 2
struct A
{
    Buf b_;

    A(int n)
    try
        : b_(n)
    {
        cout << "A initialized" << endl;
    }
    catch(BufError& be)
    {
        cout << "BufError caught" << endl;
        throw;
    }
};
```

## 参考

- [Throwing Catch](http://www.cs.technion.ac.il/~imaman/programs/throwingctor.html)
- [Throwing exceptions from constructors](https://stackoverflow.com/questions/810839/throwing-exceptions-from-constructors)
- [Exception in constructor](http://writeulearn.com/exception-constructor/)
- [exceptions](https://isocpp.org/wiki/faq/exceptions#ctors-can-throw)
- [Can a constructor throw an exception in Java?](https://www.tutorialspoint.com/can-a-constructor-throw-an-exception-in-java#)
- [Can constructors throw exceptions in Java?](https://stackoverflow.com/questions/1371369/can-constructors-throw-exceptions-in-java)
- [C++构造函数、析构函数与抛出异常](https://www.cnblogs.com/hellogiser/p/constructor-destructor-exceptions.html)
