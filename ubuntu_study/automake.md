# configure、make、make install

- [configure、make、make install](#configuremakemake-install)
  - [总结](#总结)
  - [configure](#configure)
  - [make](#make)
  - [make install](#make-install)

## 总结

在 Linux 使用源码编译安装应用程序时，一般包括三个步骤：

- `./configure`：运行当前目录名为 `configure` 的 shell 脚本，生成 `Makefile` 文件。。用于检测安装平台的目标特征比如检测是不是有 `CC/GCC`，并不依赖 `CC/GCC`
- `make`：编译。从 `Makefile` 文件中读取指令，编译源程序
- `make install`：安装。从 `Makefile` 中读取指令，安装程序到指定位置

安装结束后或重新编译前可以执行 `make clean` 删除编译生成的临时文件(可执行文件、目标文件等)。

执行 `make distclean` 除了删除 `make clean` 的文件，还会删除 `./configure` 生成的 `Makefile`。

## configure

执行 `./configure` 会生成 `Makefile`，为后面的编译做准备。可以通过在 `configure` 命令后添加参数控制编译安装。常用的控制参数 `-prefix=xxx` 指定软件安装位置。ffmpeg 还可以添加 `--enable-xxx` `--disable-xxx` 等参数。可以通过 `./configure --help` 查看支持的参数。

`configure` 可以自动设定源程序以符合不同平台上 Unix 系统的特性，并根据系统参数及环境生成对应的 `Makefile` 文件。方便跨平台编译。

## make

执行 `make` 编译源代码，为安装做准备。可以添加 `-jN` 指定多线程编译，比如 `make -j4`。

## make install

执行 `make install` 安装编译好的软件包。如果是安装到系统目录，可能需要 root 权限。
