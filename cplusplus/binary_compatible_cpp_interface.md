# 二进制兼容的 C++ 接口

- [二进制兼容的 C++ 接口](#%E4%BA%8C%E8%BF%9B%E5%88%B6%E5%85%BC%E5%AE%B9%E7%9A%84-C-%E6%8E%A5%E5%8F%A3)
  - [概述](#%E6%A6%82%E8%BF%B0)
  - [背景](#%E8%83%8C%E6%99%AF)
  - [概念](#%E6%A6%82%E5%BF%B5)
  - [初次尝试](#%E5%88%9D%E6%AC%A1%E5%B0%9D%E8%AF%95)
  - [第二次尝试](#%E7%AC%AC%E4%BA%8C%E6%AC%A1%E5%B0%9D%E8%AF%95)
  - [第三次修正](#%E7%AC%AC%E4%B8%89%E6%AC%A1%E4%BF%AE%E6%AD%A3)
  - [第四次修正](#%E7%AC%AC%E5%9B%9B%E6%AC%A1%E4%BF%AE%E6%AD%A3)
  - [完成润色](#%E5%AE%8C%E6%88%90%E6%B6%A6%E8%89%B2)
  - [最终实现](#%E6%9C%80%E7%BB%88%E5%AE%9E%E7%8E%B0)
  - [总结](#%E6%80%BB%E7%BB%93)
  - [参考](#%E5%8F%82%E8%80%83)

## 概述

原文参考[Binary-compatible C++ Interfaces](https://chadaustin.me/cppinterface.html)。

作者：Chad Austin, 2002.02.15

本文解释如何生成跨编译器和配置(发布/调试等)的 C++ DLL API。

## 背景

许多平台对他们偏好的编程语言有自己的 ABI。比如，BeOS 的主要语言是 C++，所以 C++ 编译器一定可以生成保持操作系统 C++ 系统调用二(还有类等)进制兼容的代码。

Windows 为 C 语言定义 API 和 ABI，因此 C++ 编译器的开发者可以自由控制 C++ ABI 的实现。但是，MS 最后为 Windows 创建面向对象的 ABI，称为 COM。为了简化 COM 的使用，他们使 C++ ABI 的虚表(vtables)映射到 COM 接口所需的虚表。由于不能使用 COM 的 Windows 编译器非常受限，其他的编译器强制执行 COM 虚表和 C++ 虚表之前的映射。

ABI 包含多个方面。这篇文章只讨论在 Windows 下使用 C++ 的问题。其他平台要求不一样。(幸运的是，因为大部分其他平台不如 Windows 流行，这些平台只有一或两个编译器，因此不是很大的问题。)

## 概念

- **ABI**(Application Binary Interface，应用程序二进制接口)：系统之间的二进制接口。如果一个二进制接口改变，接口两端(使用者和实现)必须被重新编译。
- **API**(Application Program Interface，应用程序编程接口)：系统之间的源接口。如果一个源接口改变，使用这个接口的代码必须修改。API 改变通常暗示 ABI 改变。
- **Interface**(接口)：一个所有方法都是纯虚的类，因此没有内在实现。一个接口只是对象之间通讯的协议。
- **Factory**(工厂)：用于创建对象。在这篇文章中，我们使用一个全局的函数作为我们的工厂。
- **DLL Boundary**(DLL 界限)：DLL 中被实例化的代码和调用进程的代码之间的线被称为 DLL 界限。在一些情况下，代码可以在界限两侧：一个头文件中的一个内联函数在 DLL 和可执行文件中被使用。这个函数实际上在界限两侧被实例化。因此，如果内联函数有一个静态变量，会创建两个变量，分别在可执行文件和 DLL 中，**哪个变量被使用取决于 DLL 还是可执行文件中的代码调用了这个函数**。

## 初次尝试

假设想要创建一个可移植的 windowing API，而且想要把实现放在 DLL 中。我会创建一个名为 Window 的类，这个类可以表示不同的 windowing 系统的一个窗口，Win32，MFC，wxWindows，Qt，Gtk，Aqua，X11，Swing(gasp)等。我们会多次尝试创建一个接口直到它可以在不同的实现、编译器和编译器设置上工作。

```c++
// Window.h

#include <string>

#ifdef WIN32
  #ifdef EXPORTING
    #define DLLIMPORT _declspec(dllexport)
  #endif
  #else
    #define DLLIMPORT _declspec(dllimport)
  #endif
  #define CALL __stdcall
#else
  #define DLLIMPORT
  #define CALL
#endif

class DLLIMPORT Window {
public:
  Window(std::string title);
  ~Window();

  void setTitle(std::string title);
  std::string getTitle();

  //...

private:
  HWND m_window;
};
```

我不会展示实现，因为我假定你已经知道如何实现。关于这个接口有一个明显的问题：它假定你使用基础的 Win32 API。即它持有一个 HWND 作为私有成员，因此引入了 Window 类和 WIn32 SDK 的依赖。一个可能的解决方案是使用 pImpl 语法从类的定义中移除这个私有成员。参考文档[1](http://www.gotw.ca/publications/mill04.htm)、[2](http://www.gotw.ca/publications/mill05.htm)、[3](http://www.gotw.ca/gotw/028.htm)和[4](http://wiki.c2.com/?PimplIdiom)。同时，你不能在不破坏二进制兼容的条件下向这个类增加新成员，因为这个类的大小会改变。

可能这个方法最重要的问题是成员方法不是纯虚的。因此，这些成员方法被实现为专门命名的函数，且函数使用 `this` 指针作为第一个参数。不幸的是，我不知道有哪两种编译器对方法的名称重整(name mangling)是一样的。因此不要认为你用一个编译器生成的的 DLL 可被另一个编译器编译的可执行文件使用。

## 第二次尝试

对于面向对象编程，你知道每个类可以分为两个概念：接口和工厂。工厂是创建对象的一种机制，接口支持对象之间通讯。下个版本的 Window.h 会分离这些概念。注意你不再需要导出类(你需要导出工厂函数)，因为这个是抽象类：所有的方法调用经过对象的虚表(vtables)，而不是通过一个直接的链接到 DLL。只有调用这个工厂函数会直接调用 DLL。

```c++
// Window.h

#include <string>

class Window {
public:
  virtual ~Window() {}
  virtual void setTitle(std::string title) = 0;
  virtual std::string getTitle() = 0;
};

Window* DLLIMPORT CreateWindow(std::string title);
```

这样的代码更好。使用 Window 对象的代码不关心 Window 对象实际的类型，只要实现 Window 接口的类型都可以。但是，还有一个问题：不同的编译器重整符号名称不同，因此不同编译器生成的 DLL 中的 `CreateWindow` 函数名称不同。这意味着如果你使用 Visual C++ 6 编译 windowing DLL，不能再 Bor兰 C++ 中使用，反之亦然。幸运的是，C++ 标准通过 `extern "C"` 使得禁用符号重整成特殊的名称。

一些人可能注意到代码的另一个问题。不同的编译器对 C++ 库的实现不同。在一些不明显的情况下，一些人会用其他的(如 [STLPort](http://stlport.org/))替代编译器的库实现……由此你不能依赖跨编译器的 STL 对象是二进制兼容的，你不能在 DLL 接口中安全使用它们。

如果一个 C++ ABI 曾为 Windows 创建，需要明确指定如何与标准库中的每个类交互，但是我马上就不会再看到这个事情发生了。

最后一个问题比较小。出于惯例，COM 方法和 DLL 函数使用 `__stdcall` 调用惯例。我们可以使用前面定义的 `CALL` 宏解决这个问题。(可以在工程中重命名)

## 第三次修正

```c++
// Window.h

class Window {
public:
  virtual ~Window() {}
  virtual void CALL setTitle(const char* title) = 0;
  virtual const char* CALL getTitle() = 0;
};

extern "C" Window* CALL CreateWindow(const char* title);
```

马上就完成了！这个特殊的接口可能在大多数情况下会有效。但是，虚析构函数使得事情有趣了……因为 COM 不使用虚析构函数，你不能依赖不同的编译器使用是一样的。然而，你可以使用一个虚方法取代虚析构函数。即在实现类中通过 `delete this` 实现；这个方式会在 DLL 界限同一侧实现构造和析构函数。比如，如果尝试使用 VC++6 的发布版可执行程序调试 DLL，程序会崩溃或遇到类似“Value of ESP not saved across function call”的警告。发生这个错误是因为 VC++ 运行时库的调试版本和发布版的分配器(allocator)不同。因为两个分配器不兼容，我们不能在 DLL 界限一侧申请内存然后再另一侧释放这个内存。

但是一个虚析构函数和一个虚方法是什么不同呢？虚析构函数不负责释放这个对象使用的内存：它们只是在释放对象之前简单地被调用执行必要的清理。使用 DLL 的可执行程序不会尝试释放对象本身的内存。另一方面， `destroy()` 函数负责释放内存，因此所有的 new 和 delete 调用在 DLL 界限的同一侧。

可以将接口的析构函数设为受保护的，以便使用接口的地方在析构函数中不小心删除它。

## 第四次修正

```c++
//Window.h

class Window {
protected:
  virtual ~Window() {} //use destroy()

public:
  virtual void CALL destroy() = 0;
  virtual void CALL setTitle(const char* title) = 0;
  virtual const char* CALL getTitle() = 0;
};

extern "C" Window* CALL CreateWindow(const char* title);
```

因为这段代码不使用 COM 定义的语义，它可以跨编译器和配置工作。不幸的是，它不是完美的。你必须记住使用 `object->destroy()` 删除对象，这个不如 `delete object` 直观。可能更重要的是，你不能在这个对象类型上使用 `std::auto_ptr`，`autho_ptr` 会使用 `delete object` 删除它拥有的对象。有一种方式实现 `delete object` 语法吗，实际上调用 `object->destroy()`？有的。这正使得事情有点奇怪……你可以为这个接口重载 `operator delete`，在内部调用 `destroy()`。因为运算符 delete 持有一个 void 指针，你需要记得你永远不会对任何非 Window 调用 `Window::operator delete`。这是一个相当安全的假设。下面是运算符的实现

```c++
//...
void operator delete(void *p) {
  if(p) {
    Window* w = static_cast<Window*>(p);
    w->destroy();
  }
}
//...
```

看起来相当好……你现在可以再使用 `autho_ptr`，而且你仍然有一个稳定的二进制接口。当你重新编译和测试你的新代码，你会注意到在 `WindowImpl::destroy` 有一个栈溢出！发生了什么？如果你记得 destroy 方法如何被实现，你会发现它只是简单的执行 `delete this`。由于这个接口重载了 `operator delete`，`WindowImpl::destroy` 调用 `Window::operator delete` 会调用 `WindowImpl::destroy`……无限循环。这个特别问题的解决方法是在实现类中重载运算符 delete 来调用全局的运算符 delete

```c++
//...
void operator delete(void *p) {
  ::operator delete(p);
}
//...
```

## 完成润色

如果你的系统有很多接口和实现，你会发现你想要一些方式自动化取消定义运算符 delete。幸运的是，这个也是可能的。简单地创建一个模板类叫做 DefaultDelete，然后不要从接口类 I 衍生，而是从 `class DefaultDelete<I>` 衍生实现类。下面是 DefaultDelete 的实现

```c++
template<typename T>
class DefaultDelete : public T {
public:
  void operator delete(void *p) {
    ::operator delete(p);
  }
};
```

## 最终实现

下面是最终版本的代码

```c++
//Window.h

#ifdef WIN32
  #define CALL __stdcall
#else
  #define CALL
#endif

class Window {
public:
  virtual void CALL destroy() = 0;
  virtual void CALL setTitle(const char* title) = 0;
  virtual const char* CALL getTitle() = 0;

  void operator delete(void* p) {
    if(p) {
      Window* p = static_cast<Window*>(p);
      w->destroy();
    }
  }
};

extern "C" Window* CALL CreateWindow(const char* title);
```

```c++
//DefaultDelete.h

template<typename T>
class DefaultDelete : public T {
public:
  void operator delete(void* p) {
    ::operator delete(p);
  }
}
```

```c++
//Window.cpp

#include "Window.h"
#include <string>
#include <windows.h>
#include "DefaultDelete.h"

class WindowImpl : public DefaultDelete<Window> {
public:
  WindowImpl(HWND window) {
    m_window = window;
  }

  ~WindowImpl() {
    DestroyWindow(m_window);
  }

  void CALL destroy() {
    delete this;
  }

  void CALL setTitle(const char* title) {
    SetWindowtext(m_window, title);
  }

  const char* CALL getTitle() {
    char title[512];
    GetWindowText(m_window, title, 512);
    m_title = title; //save the title past the call
    return m_title.c_str();
  }

private:
  HWND m_window;
  std::string m_title;
}

Window* CALL CreateWindow(const char* title) {
  // create Win32 window object
  HWND window = ::CreateWindow(..., title, ...);
  return (window ? new WindowImple(window) : 0);
}
```

## 总结

我会枚举一些指导方针，在创建 C++ 接口的时候需要记得。你可以回顾作为一个参考或者使用它帮助巩固你的知识。

- 所有的接口类应该是完全抽象的。每个方法应该是纯虚的(或者内联的……你可以安全地编写内联方法调用其他方法)。
- 所有的全局函数应该是 `extern "C"` 以避免不兼容的名称重整。并且，导出的函数和方法应该使用。`__stdcall` 调用惯例，因为 DLL 函数和 COM 习惯上使用这种调用惯例。这种方式，如果这个库的使用者使用默认的 `__cdecl` 编译，对 DLL 的调用仍然使用正确的惯例。
- 不要使用标准 C++ 库。
- 不要使用异常处理。
- 不要使用虚析构函数。相反地，创建一个 `destroy()` 方法和一个重载的 `operator delete` 调用 `destroy()`。
- 不要在 DLL 界限的一侧申请内存，在另一侧释放它。不同的 DLL 和 可执行文件可以使用不同的堆编译，并且使用不同的堆申请和释放内存块肯定会导致崩溃。比如，不要内联内存申请函数以便函数不会编译到不同的可执行文件和 DLL。
- 不要在接口使用重载的方法。不同的编译器在虚表中排序不同。

## 参考

- [STLPort](http://stlport.org/) 是 STL 的替代
- [SGI](http://www.sgi.com/tech/stl/) 有另外一个标准的 C++ 库实现
- [Corona](http://corona.sourceforge.net/) 图片 I/O 库使用了本文引入的技术
