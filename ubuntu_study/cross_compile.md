# 交叉编译

- [交叉编译](#交叉编译)
  - [在 Ubuntu 上交叉编译 ARM 架构的 GO 程序](#在-ubuntu-上交叉编译-arm-架构的-go-程序)
    - [编译 32 位 arm](#编译-32-位-arm)
    - [编译 64 位 arm](#编译-64-位-arm)
  - [交叉编译的 rpath 链接问题](#交叉编译的-rpath-链接问题)

## 在 Ubuntu 上交叉编译 ARM 架构的 GO 程序

[参考](https://programmer.group/how-to-cross-compile-the-go-program-with-arm-architecture-on-ubuntu.html)。

在不涉及 CGO 时，Go 的交叉编译非常简单，只需要设置对应的 GOOS 和 GOARCH 即可，但是涉及到 CGO 时，问题就变得有点复杂了，因为需要指定一个具体的 GCC。
比如在 Ubuntu 上用 CGO 交叉编译一个动态库，目标 CPU 架构是 arm：

### 编译 32 位 arm

首先安装 `gcc-arm-linux-gnueabihf`，或者将本地交叉工具链路径加入 `PATH` 环境变量。

```sh
sudo apt-get update
sudo apt-get install -y gcc-arm-linux-gnueabihf
echo 'export PATH="$PATH:cross_toolchain_path/bin"' >> ~/.bashrc
source ~/.bashrc
```

使用下面的命令设置 `CGO_ENABLED=1`，并需要指定 `CC`:

```sh
CGO_ENABLED=1 GOOS=linux GOARCH=arm CC=arm-linux-gnueabihf-gcc go build -buildmode=c-shared -o share.so
```

编译之后可以使用 `file` 命令查看文件属性。

### 编译 64 位 arm

交叉编译的时候不仅需要选择平台的 GCC，还要选择操作系统的位数。因此，64 位 GCC 编译命令有一些区别。

首先使用 `gcc-linaro-5.3-2016.02-x86_64_aarch64-linux-gnu.tar.xz`，或者将本地交叉工具链路径加入 `PATH` 环境变量。

```sh
wget https://releases.linaro.org/components/toolchain/binaries/5.3-2016.02/aarch64-linux-gnu/gcc-linaro-5.3-2016.02-x86_64_aarch64-linux-gnu.tar.xz 
tar xvf gcc-linaro-5.3-2016.02-x86_64_aarch64-linux-gnu.tar.xz -C /usr/lib/
echo 'export PATH="$PATH:/usr/lib/gcc-linaro-5.3-2016.02-x86_64_aarch64-linux-gnu/bin"' >> ~/.bashrc
source ~/.bashrc
```

使用下面的命令设置 `CGO_ENABLED=1`，并需要指定 `CC` 和 `GOARCH`:

```sh
CGO_ENABLED=1 GOOS=linux GOARCH=arm64 CC=aarch64-linux-gnu-gcc-5.3.1 go build -buildmode=c-shared -o share.so
```

编译之后可以使用 `file` 命令查看文件属性。

## 交叉编译的 rpath 链接问题

[参考](https://sysprogs.com/w/fixing-rpath-link-issues-with-cross-compilers/)。

使用交叉编译构建较大的 Linux 项目时，在链接二进制文件时可能遇到类似 `ld.exe: xxx not foune(try using -rpath or -rpath-link)` 的问题。

这是因为 Makefile 中链接的库依赖其他的库，而这些库没有在 Makefile 文件中显式列举。例如，构建一个 Qt 项目并且引用 libQtGui(-lQtGui)，但是没有链接其所需的 libz(-lz)，可能就会出现这种报错。

一种解决方法是添加类似下面的 GCC 命令行参数：`-Wl,-rpath-link,some_path`。

另外还有一种更通用的解决方法。出现这个问题的根本原因是 GCC调用的 LD 开始解析依赖库发生的。GCC 和 LD 都知道包含库的 sysroot，但是 LD 可能缺少一个关键组件，即 `/etc/ld.so.conf` 文件。通过拷贝 LD 配置文件到交叉工具链 LD 可以找到的位置，可以轻松解决问题。但是有一个陷阱：如果交叉工具链使用 MinGW 构建(大部分都是)，它可能无法访问 `glob()` 函数，因此它将无法解析支持通配符的 `include` 语句，例如 `*.conf`。解决方法是手动组合 `/etc/ld.so.conf.d` 中所有 `.conf` 文件的内容并将它们粘贴到 `<toolchain sysroot directory>\etc\ld.so.conf` 中。在正确的文件夹中创建 `ld.so.conf` 文件后，工具链将能够自动解析所有共享库引用。
