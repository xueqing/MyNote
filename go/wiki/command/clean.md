# go clean

- [go clean](#go-clean)
  - [命令](#%e5%91%bd%e4%bb%a4)
  - [go clean 的参数](#go-clean-%e7%9a%84%e5%8f%82%e6%95%b0)

## 命令

- `go clean` 命令会删除掉执行其它命令时产生的一些文件和目录，包括
  - 有一些目录和文件是在编译 Go 或 C 源码文件时留在相应目录中的
    - 目录 `_obj/`：旧的 object 目录，由 Makefiles 遗留
    - 目录 `_test/`：旧的 test 目录，由 Makefiles 遗留
    - 文件 `_testmain.go`：旧的 gotest 文件，由 Makefiles 遗留
    - 文件 `test.out`：旧的 test 记录，由 Makefiles 遗留
    - 文件 `build.out`：旧的 test 记录，由 Makefiles 遗留
    - 文件 `a.out`
    - 文件 `DIR(.exe)`： 由 `go build` 在当前代码包下生成的与包名同名或者与 Go 源码文件同名的可执行文件(Windows 带有 `.exe` 后缀)
    - 文件 `DIR.test(.exe)`： 由 `go test -c` 在当前代码包下生成(Windows 带有 `.test.exe` 后缀)
    - 文件 `MAINFILE(.exe)`： 由 `go build MAINFILE.go` 产生
    - 文件 `*.so`：由 SWIG 遗留
  - 执行 `go clean` 命令时带有标记 `-i`，则会同时删除安装当前代码包时所产生的结果文件。如果当前代码包中只包含库源码文件，则结果文件指的就是在工作区的 pkg 目录的相应目录下的归档文件。如果当前代码包中只包含一个命令源码文件，则结果文件指的就是在工作区的 bin 目录下的可执行文件。这些目录和文件是在执行 `go build` 命令时生成在临时目录中的。临时目录的名称以 go-build 为前缀
  - 执行 `go clean` 命令时带有标记 `-r`，则还包括当前代码包的所有依赖包的上述目录和文件

## go clean 的参数

| 参数 | 描述 |
| --- | --- |
| -i | 清除关联的安装的包和可运行文件 |
| -n | 打印执行命令期间所用到的其它命令，但是并不真正执行它们 |
| -r | 循环的清除在 import 中引入的包 |
| -x | 打印执行命令期间所用到的其它命令。注意它与 `-n` 标记的区别 |
