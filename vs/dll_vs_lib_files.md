# Windows 下的 DLL 和 LIB 文件

- [Windows 下的 DLL 和 LIB 文件](#Windows-%E4%B8%8B%E7%9A%84-DLL-%E5%92%8C-LIB-%E6%96%87%E4%BB%B6)
  - [LIB](#LIB)
  - [DLL](#DLL)
  - [总结](#%E6%80%BB%E7%BB%93)
  - [参考](#%E5%8F%82%E8%80%83)

## LIB

- LIB 是静态库，在应用程序编译时 LIB 的函数和程序可被替换和调用。链接器从 LIB 获取所有被引用函数，编译时直接将静态库代码加入程序，运行时会将这部分代码加载到内存，多个程序同时运行使用的是同一份拷贝，可以节省内存
- LIB 文件可能是静态库文件(包含对象文件)或导入库文件(包含链接器链接到 DLL 的符号)
  - 如果有 DLL 文件，那么 LIB 一般是一些索引信息，记录了 DLL 中函数的入口和位置，DLL 中是函数的具体内容。LIB 文件不是 obj 文件的集合，即里面不会有实际的实现
  - 如果只有 LIB 文件，那么这个 LIB 文件是静态编译出来的，索引和实现都在文件中。使用静态编译的 LIB 文件，在运行程序时不需要再挂载动态库，缺点是导致应用程序比较大，失去了动态库的灵活性，发布新库时要发布新的应用程序。一个 LIB 文件实际是任意 obj 文件的集合，obj 文件时 cpp 文件编译生成的

## DLL

- DLL(Dynamic Link Library)，动态链接库，真正的可执行文件，即应用程序可以在运行时而不是编译时调用这些库。这相对使用 LIB 有一些优点
- LIB 包含了函数所在 DLL 文件和文件中函数位置的信息(入口)，代码由运行时加载到进程空间中的 DLL 提供。允许可执行模块(DLL 或可执行文件)。仅包含在运行时定位 DLL 函数的可执行代码所需的信息
  - 动态链接包含两个文件：LIB 文件包含被 DLL 导出的函数名称和位置，DLL 包含实际的函数和数据。应用程序使用 LIB 文件链接到 DLL 文件
  - 在应用程序的可执行文件，存放的不是被调用的函数代码，而是 DLL 中相应函数代码的地址，从而节省了内存资源
  - DLL 和 LIB 文件必须随应用程序一起发布，否则应用程序会报错
  - 如果不想用 LIB 文件或没有 LIB 文件，可以用 Win32 API 函数 LoadLibrary/GetProcAddress 加载库
- 使用 DLL 编写的程序体积小，但是需要 DLL 和可执行文件同时发布

## 总结

- LIB 是静态库，编译时使用；DLL(Dynamic Link Library)，动态链接库，运行时使用
- LIB 文件通常是一个较大的文件；DLL 通常是多个小文件
- 当编写新版本或完全新的应用时，DLL 的复用性比 LIB
- DLL 文件可被其他程序使用，但是 LIB 文件不能
- DLL 比 LIB 容易遇到版本方面的问题
- 使用 DLL 开发软件时，因为 DLL 只包含应用需要调用 DLL 代码的存根，仍然需要 LIB 文件，后者包含了函数和代码

## 参考

- [DLL and LIB files - what and why?](https://stackoverflow.com/questions/913691/dll-and-lib-files-what-and-why)
- [Difference Between LIB and DLL](http://www.differencebetween.net/technology/difference-between-lib-and-dll/)
- [Windows 环境下 LIB 和 DLL 的区别和联系](https://blog.csdn.net/ghevinn/article/details/43759655)
