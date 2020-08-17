# pkgconfig

- [pkgconfig](#pkgconfig)
  - [configure](#configure)
  - [pkg-config 命令](#pkg-config-命令)
    - [链接界面不统一问题](#链接界面不统一问题)
    - [pkg-config 功能](#pkg-config-功能)
    - [pkg-config 路径](#pkg-config-路径)
    - [pkg-config 使用](#pkg-config-使用)
    - [/usr/local/lib/pkgconfig](#usrlocallibpkgconfig)
  - [环境变量 PKG_CONFIG_PATH](#环境变量-pkg_config_path)
  - [实战遇到的坑](#实战遇到的坑)
    - [移动时更新 pc 文件](#移动时更新-pc-文件)

## configure

`configure` 会根据传入的配置项目检查程序编译时所依赖的环境以及对程序编译安装进行配置，最终生成编译所需的 `Makefile` 文件供程序 `Make` 读入使用进而调用相关编译程序(通常都是 `gcc`)来编译最终的二进制程序。而 `configure` 脚本在检查相应依赖环境时(如所依赖软件的版本、相应库版本等)，通常会通过 `pkg-config` 的工具来检测相应依赖环境。

## pkg-config 命令

`pkg-config` 从特殊的元数据文件(`.pc` 后缀)查找安装库文件的信息。一般用作库的编译和链接

在大多数系统，`pkg-config` 会查找 `/usr/lib/pkgconfig`, `/usr/share/pkgconfig`, `/usr/local/lib/pkgconfig` 和 `/usr/local/share/pkgconfig`。

### 链接界面不统一问题

pkg-config 用来解决编译链接界面不统一问题的一个工具。

关于编译链接界面不统一的问题：一般来说，如果库的头文件不在 `/usr/include`，那么编译时需要用 `-I` 指定路径。由于同一个库在不同系统上可能位于不同目录，用户安装库时也可将库安装在不同目录，所以同一个库由于库路径不同，使得用 `-I` 参数指定的头文件路径和在链接时使用 `-L` 参数指定 lib 库的路径都可能不同，其结果就是造成了编译命令界面的不统一。由于编译链接的不一致，造成同一份程序从一台机器复制到另一台机器时可能会出现问题。

pkg-config 通过库提供的一个 `.pc` 文件获得库的各种必要信息的，包括头文件的位置、版本信息、编译和链接需要的参数等。需要的时候可以通过 `pkg-config` 提供的参数(`–cflags`, `–libs`)，将所需信息提取出来供编译和链接使用。这样，不管库文件安装在哪，通过库对应的 `.pc` 文件就可以定位，可以使用相同的编译和链接命令，使得编译和链接界面统一。

### pkg-config 功能

pkg-config 提供的主要功能有:

- 检查库的版本号。如果所需库的版本不满足要求，打印错误信息，避免链接错误版本的库文件
- 获得编译预处理参数，如宏定义、头文件的路径
- 获得编译参数，如库及其依赖的其他库的位置、文件名及其他一些链接参数
- 自动加入所依赖的其他库的设置

在默认情况下，每个支持 `pkg-config` 的库对应的 `.pc` 文件在安装后都位于安装目录中的 `lib/pkgconfig` 目录。新软件一般都会安装 `.pc` 文件，没有可以自己创建，并且设置环境变量 `PKG_CONFIG_PATH` 寻找 `.pc` 文件路径。使用 `pkg-config` 工具提取库的编译和连接参数有两个基本的前提：

- 库本身在安装的时候必须提供一个相应的 `.pc` 文件。否则说明不支持 `pkg-config` 工具的使用
- `pkg-config` 必须知道到哪里寻找此 `.pc` 文件

实例：

```sh
cat /usr/lib/pkgconfig/x264.pc
prefix=/usr
exec_prefix=${prefix}
libdir=${exec_prefix}/lib
includedir=${prefix}/include

Name: x264
Description: H.264 (MPEG4 AVC) encoder library
Version: 0.152.x
Libs: -L${exec_prefix}/lib -lx264
Libs.private: -lpthread -lm -ldl
Cflags: -I${prefix}/include
```

### pkg-config 路径

```sh
# 显示默认搜索路径
pkg-config --variable pc_path pkg-config
/usr/local/lib/x86_64-linux-gnu/pkgconfig:/usr/local/lib/pkgconfig:/usr/local/share/pkgconfig:/usr/lib/x86_64-linux-gnu/pkgconfig:/usr/lib/pkgconfig:/usr/share/pkgconfig
```

### pkg-config 使用

```sh
# 查看头文件位置
pkg-config --cflags x264
# 查看 lib 库的位置
pkg-config --libs x264
# 编译链接使用
g++ -o demo $(pkg-config --cflags --libs opencv) demo.cpp
```

### /usr/local/lib/pkgconfig

`/usr/local/lib/pkgconfig/libname.pc` 文件，新软件一般都会安装 `.pc` 文件，没有可以自己创建，并且设置环境变量 `PKG_CONFIG_PATH` 寻找 `.pc` 文件路径。

## 环境变量 PKG_CONFIG_PATH

环境变量 `PKG_CONFIG_PATH` 是用来设置 `.pc` 文件的搜索路径。`pkg-config` 按照设置路径的先后顺序进行搜索，直到找到指定的 `.pc` 文件为止。这样，库的头文件的搜索路径的设置实际上就变成了对 `.pc` 文件搜索路径的设置。

在安装完一个需要使用的库后，一是将相应的 `.pc` 文件拷贝到 `/usr/lib/pkgconfig` 目录下，二是通过设置环境变量 `PKG_CONFIG_PATH` 添加 `.pc` 文件的搜索路径。

```sh
# 查询 PKG_CONFIG_PATH 变量信息
echo $PKG_CONFIG_PATH
```

## 实战遇到的坑

### 移动时更新 pc 文件

在一台宿主机上编译好的库，在移动到另一个位置或者另一台宿主机上，要更新对应 `.pc` 文件的路径。
