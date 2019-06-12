# 关于 boost 库

- 使用对应功能需要的库
  - `apt-get install mpi-default-dev`安装 mpi 库
  - `apt-get install libicu-dev`支持正则表达式的 UNICODE 字符集
  - `apt-get install python-dev`需要 python 的话
  - `apt-get install libbz2-dev`如果编译出现错误`bzlib.h: No such file or directory`
- 解压源代码安装包，切换到对应文件夹：`./bootstrap.sh`
  - 生成 bjam，上述命令可以带有各种选项，具体可参考帮助文档：`./bootstrap.sh --help`
  - `--prefix`参数，可以指定安装路径，如果不带`--prefix`参数的话（推荐），默认路径是`/usr/local/include`和`/usr/local/lib`，分别存放头文件和各种库。
  - 当前目录下，生成两个文件 bjam 和 b2，这两个是一样的，所以接下来的步骤，可以用这两个中的任意一个来执行
  - `using mpi`如果需要 MPI 功能，需要在 /tools/build/v2/user-config.jam 文件的末尾添加
- 利用生成的 bjam 脚本编译源代码
  - `./b2 -a -sHAVE_ICU=1`，`-a`参数，代表重新编译，`-sHAVE_ICU=1`代表支持 Unicode/ICU
- 编译完成后，进行安装，也就是将头文件和生成的库，放到指定的路径（--prefix）下
  - `./b2 install`
