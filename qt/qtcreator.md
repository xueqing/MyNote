# QtCreator 一些基本的配置参数说明

- [QtCreator 一些基本的配置参数说明](#qtcreator-一些基本的配置参数说明)
  - [QtCreator pro 文件参数](#qtcreator-pro-文件参数)
  - [QtCreator 帮助文档](#qtcreator-帮助文档)
  - [QtCreator 使用](#qtcreator-使用)

## QtCreator pro 文件参数

| 参数 | 含义 |
| --- | --- |
| TARGET        | 应用程序名.默认是跟工程文件名一样 (根据不同的平台后缀名会自动添加) |
| TEMPLATE      | 模板变量指定生成 makefile (app: 应用程序; lib:库) |
| QT            | 使用到的 Qt 定义的类 (core/gui/widgets...) |
| CONFIG        | 指定项目配置和编译器选项 |
| DESTDIR       | 指定位置放目标文件 |
| DEFINES       | 程序编译时候需要的预定义的宏列表 |
| HEADERS       | 程序中需要编译的头文件列表 |
| SOURCES       | 程序中需要编译的源文件列表 |
| FORMS         | 由 Qt Designer 为程序创建的 ui 文件列表 |
| RESOURCES     | 工程中包含的资源文件 |
| INCLUDEPATH   | 程序需要的头文件的目录列表 |
| LIBS          | 引入的其他的库, `-L`: 引入路径 |
| QMAKE_CFLAGS  | 设置 c 编译器 flag 参数 |
| QMAKE_CXXFLAGS | 设置 c++ 编译器 flag 参数 |
| QMAKE_LFLAGS | 设置链接器 flag 参数 |
| VERSION       | 在 pro 文件添加 `VERSION=x.x.x` 可指定生成版本的名称，不会自动删除旧版本 |

备注

- 路径不要有空格和中文

## QtCreator 帮助文档

- `qmake Manual > Variables`

## QtCreator 使用

- Manage Kits
- build/run
- qml
- environment
- 添加文件到工程
- 新建类
- find/replace
- compile output
