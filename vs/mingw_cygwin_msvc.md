# MinGW vs Cygwin vs MSVC

- [MinGW vs Cygwin vs MSVC](#MinGW-vs-Cygwin-vs-MSVC)
  - [Mingw](#Mingw)
    - [MinGW-w64](#MinGW-w64)
    - [MSYS](#MSYS)
    - [MSYS2](#MSYS2)
  - [Cygwin](#Cygwin)
  - [MinGW vs 区别：Cygwin](#MinGW-vs-%E5%8C%BA%E5%88%ABCygwin)
  - [MSVC](#MSVC)
  - [MinGW 和 MSVC 的二进制兼容性](#MinGW-%E5%92%8C-MSVC-%E7%9A%84%E4%BA%8C%E8%BF%9B%E5%88%B6%E5%85%BC%E5%AE%B9%E6%80%A7)
    - [不同编译器生成的库的互操作性](#%E4%B8%8D%E5%90%8C%E7%BC%96%E8%AF%91%E5%99%A8%E7%94%9F%E6%88%90%E7%9A%84%E5%BA%93%E7%9A%84%E4%BA%92%E6%93%8D%E4%BD%9C%E6%80%A7)
  - [参考](#%E5%8F%82%E8%80%83)

## Mingw

- MinGW(Minimalist GNU for Windows)，用于开发原生(32 位) MS-Windows 应用的最小化的开发环境。它提供了一个完整的开源编程工具链，用于开发原生 MS-Windows 应用，且不依赖任何第三方 C-运行时 DLL
  - 它确实依赖一些 MS 提供的 DLL，比如 MSVCRT.DLL(MS 的 C 运行时库)
- MinGW 编译器支持访问 MS 的 C 和 和一些其他语言的运行时函数
- MinGW 不会尝试为 MS-Windows 上的 POSIX 应用部署提供 POSIX 运行时环境
- MinGW 能够替代 cl 用于编译不包含 MFC 的、以 WinSDK 为主的 Windows 应用，并且编译出来的应用不依赖于第三方的模拟层支持
- MinGW 包含
  - 一些 GCC(GNU Compiler Collection)，包括 C/C++/ADA/Fortran 编译器
  - 针对 Windows 的 GNU Binutils(汇编器、链接器、归档管理器)
  - 一个命令行安装工具，带有可选的 GUI 前后端(mingw-get),用于 MS-Windows 上的 MinGW 和 MSYS 部署
  - 一个 GUI 初始安装工具(mingw-get-setup)，用于安装和运行 mingw-get
- 总结：MinGW 是用于 MS-Windows 应用开发的 GNU 工具链(开发环境)，它的编译产物一般是原生 MS-Windows 应用，虽然它本身不一定非要运行在 Windows 系统下(MinGW 工具链也存在于 Linux、BSD 甚至 Cygwin 下)

### MinGW-w64

- 前面提到的 MinGW，是针对 32 位 Windows 应用开发的。而且由于版本问题，不能很好的支持较新的 Windows API。MinGW-W64 则是新一代的 MinGW，支持更多的 API，支持 64 位应用开发，甚至支持 32 位 host 编译 64 位应用以及反过来的“交叉”编译。除此之外，它本身也有 32 位和 64 位不同版本，其它与 MinGW 相同

### MSYS

- MSYS(Minimal SYStem)，是一个 Bourne Shell 命令行解释器系统。可取代 MS 的 cmd.exe，提供了统一的命令行环境，尤其适用于 MinGW
- MSYS 是 Cygwin-1.3 的一个轻量级的 fork，是用于辅助 Windows 版 MinGW 进行命令行开发的配套软件包，包含了一小部分 Unix 工具以使得 MinGW 的工具使用起来方便一些
- 由于 MinGW 本身仅代表工具链，而在 Windows 下，由于 cmd 以及配套的命令行工具不够齐全(也不舒服)，因此，MinGW 开发者从曾经比较旧的 Cygwin 创建了一个分支，也用于提供类 Unix 环境
- 与 Cygwin 的大而全不同，MSYS 是冲着小巧玲珑的目标去的，所以整套 MSYS 以及 MinGW，主要以基本的 Linux 工具为主，大小在 200M 左右，并且没有多少扩展能力

### MSYS2

- 由于 MinGW 和 MSYS 更新慢，Cygwin 的许多新功能 MSYS 没有同步过来，于是 Alex 等人建立了新一代的 MSYS 项目。仍然是 fork 了 Cygwin(较新版)，但有个更优秀的包管理器 pacman，有活跃的开发者跟用户组，有大量预编译的软件包(没有 Cygwin 多)

## Cygwin

- Cygwin 是一个运行于 Windows 平台的类 Unix 模拟环境(以 GNU 工具为代表)
- Cygwin 提供了一套抽象层 dll，用于将部分 POSIX 调用转换成 Windows 的 API 调用，实现相关功能。其中最典型、最基本的模拟层是 cygwin1.dll。除此之外，随着 Linux 系统的发展壮大，目前 Cygwin 不仅提供 POSIX 兼容，也多了更多模拟层的依赖关系
- Cygwin 的目录结构基本照搬了 Linux 的样子，但同时也兼容了 Windows 的许多功能
  - 大部分应用使用 Unix 风格的路径，Windows 的盘符通过类似挂载点的方式提供给 Cygwin 使用
  - Cygwin 中既可以运行 Cygwin 的应用(依赖模拟层)，又可以运行 Windows 应用，而传递给应用的路径会经过它的模拟层变换，以此保证程序运行不会出错
- 由于它的模拟层实现了相当良好的 POSIX 兼容，人们试着将许多重要的 Linux/BSD 应用移植到 Cygwin 下，使得 Cygwin 越来越大，功能也越来越丰富，以至于目前很多人直接把将 Linux 应用移植到 Windows 平台的任务都交给了Cygwin(这种移植并非原生)
- 总结：Cygwin 是运行于 Windows 平台的 POSIX “子系统”，提供 Windows 下的类 Unix 环境，并提供将部分 Linux 应用“移植”到 Windows 平台的开发环境的一套软件

## MinGW vs 区别：Cygwin

- 区别：Cygwin 是模拟 POSIX 系统，源码移植 Linux 应用到 Windows 下；MinGW 是用于开发 Windows 应用的开发环境。如果希望部署 POSIX 应用，考虑 Cygwin
- 联系：均提供了部分 Linux 下的应用，多跑在 Windows 上；MinGW 作为 Cygwin 下的软件包，可以在 Cygwin 上运行

## MSVC

- MSVC(Microsoft Visual C++)，是用于 C 和 C++ 编程的一个 IDE。是用于编写和调试 C/C++/C# 代码的工具，大部分代码是为了 MS-Windows/.NET 框架或 DirectX 编写的。最新的版本也支持 JavaScript 和 F#

## MinGW 和 MSVC 的二进制兼容性

- MinGW 编译的软件使用 QT 框架，也依赖 Apache 可移植运行库，即 [Apache Portable Runtime, APR](http://apr.apache.org/)。一些预编译好的 Windows 开发包(如 MySQL 客户端库)使用 MSVC 编译
- MSVC 和 MinGW 对标准调用函数(stdcall function) 使用不同的命名惯例：MSVC 导出函数为 `_name@ordinal`，但是 MinGW 导出为 `_name`。因此，MinGW 当调用来自 MSVC 库的 stdcall 函数时会报 `undefined reference` 编译错误
- 解决方案参考 [Linking MSVC Libraries With MinGW Projects](https://outofhanwell.wordpress.com/2006/05/01/linking-msvc-libraries-with-mingw-projects/) 和 [MSVC and MinGW DLLs](http://www.mingw.org/wiki/MSVC_and_MinGW_DLLs)

### 不同编译器生成的库的互操作性

- 不同编译器，甚至相同编译器的不同发布版本生成的目标文件和静态库文件，通常不能一起链接。所以尽量使用相同编译器的相同版本编译源码
- DLL 文件稍微有些不同。有时候可以在应用中链接另一个编译器生成的 DLL 文件
  - 当 DLL 使用 C 编写兼容性通常很好。比如 MinGW C++ 程序通常链接 Windows 提供的 C 运行时库
  - 使用 C++ 编写的 DLL，只要通过一个使用`extern "C"`声明的 C 接口就可以
  - 否则，会报链接错误。因为不同编译器使用不同的 C++ 名称重整(name-mangling)
- 真正的链接间通信要求一个通用的应用二进制接口(Application Binary Interface)，名称重整只是其中一个原因，而且一个编译器会提供 3200 个不同的 ABI
- 虽然 GNU g++ 可以链接 MSVC C++ 库，可以生成 MSVC++ 兼容的 库/DLL 文件，但是由于 C++ 的动态特性，在运行时并不会正常工作。可能的原因包括
  - 名称重整：可能通过显式的 .def 文件绕过去
  - 不同的结构对齐规则：需要正确的编译器选项(-mms-bitfields...)
  - 底层的异常和内存模型冲突
    - MSVC DLL 的 new/delete 或 malloc/free 和 Cygwin 的 new/delete 或 malloc/free 不一致。在一个函数中使用不同的 new/malloc 申请的内存，其它地方不能释放
    - MSVC DLL 抛出的异常不能被 Cygwin 的可执行程序捕获，反之亦然

## 参考

- [MinGW 官网](http://www.mingw.org/)
- [Cygwin 官网](https://www.cygwin.com/)
- [MSVC](https://en.wikipedia.org/wiki/Microsoft_Visual_C%2B%2B)
- [Interoperability of Libraries Created by Different Compiler Brands](http://www.mingw.org/wiki/Interoperability_of_Libraries_Created_by_Different_Compiler_Brands)
- [Binary-compatible C++ Interfaces](https://chadaustin.me/cppinterface.html)
