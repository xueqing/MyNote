# GOPATH 环境变量

Go 路径用于解决导入语句，它通过 go/build 包实现，并记录在 go/build 包。

GOPATH 环境变量列举了寻找 Go 代码的位置。在 Unix 上，其值是一个冒号分隔的字符串。在 Windows 上，其值是一个分号分隔的字符串。在 Plan 9 上，其值是一个列表。

如果环境变量未被设置，GOPATH 默认是用户主目录下的一个 “go” 子目录(Unix 下是 `$HOME/go`，Windows 下是 `%USERPROFILE%\go`)，除非那个目录存在一个 Go 发行版本。运行 `go env GOPATH` 查看当前的 GOPATH。

查看 [SettingGOPATH](https://golang.org/wiki/SettingGOPATH) 设置一个自定义的 GOPATH。

GOPATH 下的每个目录必须有一个规定的结构：

- src 目录持有源码。src 下的目录确定了导入路径或可执行文件名字。
- pkg 目录持有安装的包对象。在 Go 树中，每个目标操作系统和架构对有其自己的包的子目录(pkg/GOOS_ARCH).
- 如果 DIR 是GOPATH 下的一个目录，包的源码在 DIR/src/foo/bar，那么包可以导出为 “foo/bar”，且将其编译文件安装到 “DIR/pkg/GOOS_GOARCH/foo/bar.a”。
- bin 目录持有编译的命令。每个命令命名为它的源码目录，但是只有最后一个元素，而不是整个路径。也就是说，一个命令的源码在 DIR/src/foo/quux，那么它被安装到 DIR/bin/quux。这个 “foo/” 前缀被除去以便你可以增加 DIR/bin 到你的 PATH 来获取安装的命令。如果设置了 GOBIN 环境变量，命令被安装到 GOBIN 命名的目录而不是 DIR/bin。GOBIN 必须是一个绝对路径。

这里是一个目录格式示例：

```txt
GOPATH=/home/user/go

/home/user/go/
    src/
        foo/
            bar/               (包 bar 中的 go 代码)
                x.go
            quux/              (包 main 中的 go 代码)
                y.go
    bin/
        quux                   (安装的命令)
    pkg/
        linux_amd64/
            foo/
                bar.a          (安装的包对象)
```

Go 搜索 GOPATH 列举的每个目录来查找源码，但是新包总是下载到列表中的第一个目录。

查看 [How to Write Go Code](https://golang.org/doc/code.html)的例子。
