# go generate

- [go generate](#go-generate)
  - [命令](#%e5%91%bd%e4%bb%a4)

## 命令

- `go generate` 用于在编译前自动化生成某类代码
- `go generate` 通过分析源码中特殊的注释，然后执行相应的命令。注意
  - 此特殊注释必须在 `.go` 源码文件
  - 每个源码文件可包含多个 generate 注释
  - 显示运行 `go generate` 命令时，才会执行特殊注释后面的命令
  - 命令串执行时，如果出错则终止后面的执行
- `//go:generate go tool yacc -o gopher.go -p parser gopher.y`
  - `//go:generate` 没有空格，这是一个固定的格式，在扫描源码文件的时候是根据这个来判断的
  - 使用 `yacc` 来生成代码：`-o` 指定输出文件名，`-p` 指定 package 名称
  - 这是一个单独的命令。如果想让 `go generate` 来触发这个命令，那么就可以在当然目录的任意一个 xxx.go 文件里面的任意位置增加此注释
