# 在 windows 平台编译 ffmpeg

- [在 windows 平台编译 ffmpeg](#在-windows-平台编译-ffmpeg)
  - [安装 msys2](#安装-msys2)
    - [修改中文字符](#修改中文字符)
  - [配置 pacman](#配置-pacman)
    - [pacman 基本命令](#pacman-基本命令)
  - [安装 make 编译器](#安装-make-编译器)
  - [安装 gcc、g++ 编译器](#安装-gccg-编译器)
  - [测试](#测试)
  - [安装 Clion 编译工具链](#安装-clion-编译工具链)
  - [编译 ffmpeg](#编译-ffmpeg)
  - [参考](#参考)

## 安装 msys2

msys2 可以在 windows 下搭建一个完美的类 linux 环境，包括 bash、vim、gcc、make 等工具都可以通过包管理器来添加和卸载。

请访问镜像目录下的 `distrib/` 目录（[x86_64](https://mirrors.tuna.tsinghua.edu.cn/msys2/distrib/x86_64/) 、[i686](https://mirrors.tuna.tsinghua.edu.cn/msys2/distrib/i686/)），找到名为 `msys2-<架构>-<日期>.exe` 的文件（如 `msys2-x86_64-20141113.exe`），下载安装即可。

### 修改中文字符

msys2 下面绝大多数软件均使用 utf-8 编码，所以建议使用 utf-8 字符编码。这样就会造成使用 windows 自带的软件(如 ping、ipconfig 等)显示乱码。可以使用 `iconv` 进行实时转换编码，例如：

```sh
ping www.cnblogs.com | iconv -f gbk -t utf-8
```

也可以修改中文字符编码：打开安装目录下的 `msys2_shell.cmd` 文件，在弹窗的标题栏上，右击选择 `Options...`，选择 `Text`，选择 `Locale` 为 `zh_CN`，更改显示中文的 `Character set` 为 `GBK`，保存之后退出终端，重新打开 `msys2_shell.cmd`。

## 配置 pacman

msys2 的包管理器是使用的 pacman。msys2 的官网为 <http://msys2.github.io/>，但是其下载速度太慢，先配置 pacman 的源，使用国内的源进行下载。

编辑 `/etc/pacman.d/mirrorlist.mingw32` ，在文件开头添加：

```txt
Server = https://mirrors.tuna.tsinghua.edu.cn/msys2/mingw/i686
```

编辑 `/etc/pacman.d/mirrorlist.mingw64` ，在文件开头添加：

```txt
Server = https://mirrors.tuna.tsinghua.edu.cn/msys2/mingw/x86_64
```

编辑 `/etc/pacman.d/mirrorlist.msys` ，在文件开头添加：

```txt
Server = https://mirrors.tuna.tsinghua.edu.cn/msys2/msys/$arch
```

然后执行 `pacman -Sy` 刷新软件包数据即可。

### pacman 基本命令

```sh
# 更新软件包数据
pacman -Sy
# 更新所有
pacman -Syu
# 查询软件 xx 的信息
pacman -Ss xx
# 安装软件 xx
pacman -S xx
# 删除软件xx
pacman -R xx
```

## 安装 make 编译器

```sh
# 查询并找到 msys/make
pacman -Ss make
# 默认安装 msys/make
pacman -S make
```

## 安装 gcc、g++ 编译器

```sh
# 查询并找到 msys/gcc
pacman -Ss gcc
# 默认安装 msys/gcc
pacman -S gcc
```

## 测试

```sh
# 测试 make
make -v
# 出现下面的类似内容说明安装成功
GNU Make 4.3
为 x86_64-pc-msys 编译
Copyright (C) 1988-2020 Free Software Foundation, Inc.
许可证：GPLv3+：GNU 通用公共许可证第 3 版或更新版本<http://gnu.org/licenses/gpl.html>。
本软件是自由软件：您可以自由修改和重新发布它。
在法律允许的范围内没有其他保证。
# 测试 gcc
gcc -v
使用内建 specs。
COLLECT_GCC=gcc
COLLECT_LTO_WRAPPER=/usr/lib/gcc/x86_64-pc-msys/9.3.0/lto-wrapper.exe
目标：x86_64-pc-msys
配置为：/msysdev/gcc/src/gcc-9.3.0/configure --build=x86_64-pc-msys --prefix=/usr --libexecdir=/usr/lib --enable-bootstrap --enable-shared --enable-shared-libgcc --enable-static --enable-version-specific-runtime-libs --with-arch=x86-64 --with-tune=generic --disable-multilib --enable-__cxa_atexit --with-dwarf2 --enable-languages=c,c++,fortran,lto --enable-graphite --enable-threads=posix --enable-libatomic --enable-libgomp --disable-libitm --enable-libquadmath --enable-libquadmath-support --disable-libssp --disable-win32-registry --disable-symvers --with-gnu-ld --with-gnu-as --disable-isl-version-check --enable-checking=release --without-libiconv-prefix --without-libintl-prefix --with-system-zlib --enable-linker-build-id --with-default-libstdcxx-abi=gcc4-compatible --enable-libstdcxx-filesystem-ts
线程模型：posix
gcc 版本 9.3.0 (GCC)
```

## 安装 Clion 编译工具链

```sh
pacman-key --init
pacman -Syu
pacman -S mingw-w64-x86_64-cmake mingw-w64-x86_64-extra-cmake-modules
pacman -S mingw-w64-x86_64-make
pacman -S mingw-w64-x86_64-gdb
pacman -S mingw-w64-x86_64-toolchain
```

## 编译 ffmpeg

下载源码不再赘述。只介绍编译的步骤。打开 msys2 安装目录的 `mingw32.exe`，切换到 ffmpeg 源码目录：

```sh
./configure --prefix=/e/ffmpeg4.1 --enable-shared --disable-cuvid --disable-nvdec --disable-nvenc
make -j6
make install
```

## 参考

<https://mirrors.tuna.tsinghua.edu.cn/help/msys2/>

<https://blog.csdn.net/Lazybones_3/article/details/88633738>
