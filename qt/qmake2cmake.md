# 介绍 qmake2cmake

- [介绍 qmake2cmake](#介绍-qmake2cmake)
  - [它做什么](#它做什么)
  - [它不能做什么](#它不能做什么)
  - [从哪里获取](#从哪里获取)
  - [如何使用](#如何使用)
  - [看起来什么样](#看起来什么样)
  - [贡献](#贡献)

[原文链接](https://www.qt.io/blog/introducing-qmake2cmake)。

Qt 自己的 QMake 项目文件已经使用 qtbase 目录下名为 [pro2cmake](https://code.qt.io/cgit/qt/qtbase.git/tree/util/cmake?h=6.3.0) 的 Python 脚本进行转换。该脚本专门用于转换 Qt 仓库中的项目，并且对于转换用户项目基本没有用处。

我们已经 fork 该脚本，并为你的项目将其变成一个转换器：阅读 [qmake2cmake](https://pypi.org/project/qmake2cmake/)。

## 它做什么

`qmake2cmake` 工具创建 `CMakeLists.txt`，覆盖了被转换的 `.pro` 文件的大多常见属性。生成的 CMake 项目可用作基础，且很可能需要手动调整。

QMake 结构中不能转换的在 CMake 项目中成为注释。这些注释在手动转换时有帮助。

许多项目有不止一个 `.pro` 文件。对于 QMake SUBDIRS 层次结构，有 `qmake2cmake_all` 对项目根目录进行操作，并转换它下面的所有内容。

对于 Qt 本身，转换速度是不容忽视的一个方面。这就是为什么 `qmake2cmake_all` 并行化子项目的转换。

## 它不能做什么

QMake 结构中不能被转换的部分：

- `TEMPLATE = aux` 项目
- 自定义 `.prf` 文件
- 额外的编译器
- 额外的目标

所有这些将需要手动转换。

## 从哪里获取

`qmake2cmake` 的安装非常简单：

```sh
python -m pip install qmake2cmake
```

如果想获取源码，克隆仓库：

```sh
git clone git://code.qt.io/qt/qmake2cmake.git
```

参阅 `README.md` 获取要求和进一步的安装细节。

## 如何使用

要转换整个项目树，请将项目目录传递给 `qmake2cmake_all`：

```sh
qmake2cmake_all ~/projects/myapp --min-qt-version 6.3
```

有必要指定构建项目的最低 Qt 版本。这为 QT 版本选择正确的 CMake API。

为避免每次调用传递此参数，你可以设置 `QMAKE2CMAKE_MIN_QT_VERSION` 环境变量。

以下调用将单个 QMake 项目文件转换为 CMake：

```sh
qmake2cmake ~/projects/myapp/myapp.pro
```

默认情况下，`CMakeLists.txt` 放在 .pro 文件旁边。

要在不同位置生成 `CMakeLists.txt`，请使用 `-o` 选项：

```sh
qmake2cmake ~/projects/myapp/myapp.pro -o ~/projects/myapp-converted/CMakeLists.txt
```

## 看起来什么样

以下代码片段显示了使用最低的 Qt 6.3 版本将 [gui/analogclock 示例](https://code.qt.io/cgit/qt/qtbase.git/tree/examples/gui/analogclock)转为 CMake 的结果：

```txt
cmake_minimum_required(VERSION 3.16) 
project(analogclock VERSION 1.0 LANGUAGES CXX) 

set(CMAKE_INCLUDE_CURRENT_DIR ON) 

qt_standard_project_setup() 

find_package(QT NAMES Qt5 Qt6 REQUIRED COMPONENTS Core) 
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Gui) 

qt_add_executable(analogclock WIN32 MACOSX_BUNDLE 
   ../rasterwindow/rasterwindow.cpp ../rasterwindow/rasterwindow.h 
   main.cpp 
) 
target_include_directories(analogclock PRIVATE 
   ../rasterwindow 
) 

target_link_libraries(analogclock PRIVATE 
   Qt::Core 
   Qt::Gui 
) 

install(TARGETS analogclock 
   BUNDLE DESTINATION . 
   RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR} 
) 

qt_generate_deploy_app_script( 
   TARGET analogclock 
   FILENAME_VARIABLE deploy_script 
   NO_UNSUPPORTED_PLATFORM_ERROR 
) 
install(SCRIPT ${deploy_script}
```

## 贡献

`qmake2cmake` 工具托管在 Qt 项目，并适用通常的贡献规则。

请使用“Qt(QTBUG)”项目和“build:other”组件在<https://bugreports.qt.io/>中报告错误。
