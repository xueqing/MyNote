# go list

- [go list](#go-list)
  - [用法](#%e7%94%a8%e6%b3%95)
  - [-f](#f)
  - [-m](#m)

## 用法

- 列举命名包，每行一个。不带参数时判断一个包是否存在工作空间，存在则输出包的导入路径
- 命令 `go list [-f format] [-json] [-m] [list flags] [build flags] [packages]`
  - 常用的参数是 `-f` 和 `-json`，用于控制输出格式
- `go list cnet hash`
- `...` 通配符用于匹配包的导入路径中的任意子串
  - `go list ...` 枚举工作空间的所有包
  - `go list ch3/...` 指定子树中的所有包
  - `go list ...xml..` 指定具体主题
- `go list` 获取每个包的完整元数据，提供各种用于对用户或其他工具可访问的格式

| 标志 | 描述 |
| --- | --- |
| -e | 以容错模式加载和分析指定的代码包，这样讲不会打印错误信息 |
| -json | 把代码包的结构实体用 JSON 样式打印，所有值为对应类型的空值的字段会被忽略 |
| -compiled | - |
| -deps | - |
| -export | - |
| -find | - |
| -test | - |
| -m | 列举模块而不是包。使用 -f 指定的是模块模板 |

## -f

- 使用包模板语法指定可选格式。默认输出等价于 `-f '{{ImportPath}}'`。`-f` 的值需要满足 `text/template` 中定义的语法
  - `{{.S}}` 代表根结构体的 `S` 字段的值。`go list` 对应的跟结构体就是指定的代码包所对应的的结构体
    - `go list -f {{.GoFiles}} cnet/ctcp`
    - `go list -e -f {{.Error.Err}} cnet`
    - `go list -e -f 'The package {{.ImportPath}} is {{if .Incomplete}}incomplete!{{else}}complete.{{end}}' cnet`
- 模板结构如下

  ```go
  type Package struct {
      Dir           string   // directory containing package sources
      ImportPath    string   // import path of package in dir
      ImportComment string   // path in import comment on package statement
      Name          string   // package name
      Doc           string   // package documentation string
      Target        string   // install path
      Shlib         string   // the shared library that contains this package (only set when -linkshared)
      Goroot        bool     // is this package in the Go root?
      Standard      bool     // is this package part of the standard Go library?
      Stale         bool     // would 'go install' do anything for this package?
      StaleReason   string   // explanation for Stale==true
      Root          string   // Go root or Go path dir containing this package
      ConflictDir   string   // this directory shadows Dir in $GOPATH
      BinaryOnly    bool     // binary-only package (no longer supported)
      ForTest       string   // package is only for use in named test
      Export        string   // file containing export data (when using -export)
      Module        *Module  // info about package's containing module, if any (can be nil)
      Match         []string // command-line patterns matching this package
      DepOnly       bool     // package is only a dependency, not explicitly listed

      // Source files
      GoFiles         []string // .go source files (excluding CgoFiles, TestGoFiles, XTestGoFiles)
      CgoFiles        []string // .go source files that import "C"
      CompiledGoFiles []string // .go files presented to compiler (when using -compiled)
      IgnoredGoFiles  []string // .go source files ignored due to build constraints
      CFiles          []string // .c source files
      CXXFiles        []string // .cc, .cxx and .cpp source files
      MFiles          []string // .m source files
      HFiles          []string // .h, .hh, .hpp and .hxx source files
      FFiles          []string // .f, .F, .for and .f90 Fortran source files
      SFiles          []string // .s source files
      SwigFiles       []string // .swig files
      SwigCXXFiles    []string // .swigcxx files
      SysoFiles       []string // .syso object files to add to archive
      TestGoFiles     []string // _test.go files in package
      XTestGoFiles    []string // _test.go files outside package

      // Cgo directives
      CgoCFLAGS    []string // cgo: flags for C compiler
      CgoCPPFLAGS  []string // cgo: flags for C preprocessor
      CgoCXXFLAGS  []string // cgo: flags for C++ compiler
      CgoFFLAGS    []string // cgo: flags for Fortran compiler
      CgoLDFLAGS   []string // cgo: flags for linker
      CgoPkgConfig []string // cgo: pkg-config names

      // Dependency information
      Imports      []string          // import paths used by this package
      ImportMap    map[string]string // map from source import to ImportPath (identity entries omitted)
      Deps         []string          // all (recursively) imported dependencies
      TestImports  []string          // imports from TestGoFiles
      XTestImports []string          // imports from XTestGoFiles

      // Error information
      Incomplete bool            // this package or a dependency has an error
      Error      *PackageError   // error loading package
      DepsErrors []*PackageError // errors loading dependencies
  }

  type PackageError struct {
      ImportStack   []string // shortest path from package named on command line to this one
      Pos           string   // position of error (if present, file:line:col)
      Err           string   // the error itself
  }
  ```

- 模板函数 `join` 调用 `strings.Join`
  - `go list -f '{{join .Deps " "}}' strconv` 输出 strconv 包的依赖过渡关系记录，空格分隔
  - `go list -f '{{.ImportPath}} -> {{join .Imports " "}}' compress/...` 输出标准库的 compress 子树中每个包的直接导入记录
- 模板函数 `context` 返回构建上下文，定义如下

  ```go
  type Context struct {
      GOARCH        string   // target architecture
      GOOS          string   // target operating system
      GOROOT        string   // Go root
      GOPATH        string   // Go path
      CgoEnabled    bool     // whether cgo can be used
      UseAllFiles   bool     // use files regardless of +build lines, file names
      Compiler      string   // compiler to assume when computing target paths
      BuildTags     []string // build constraints to match in +build lines
      ReleaseTags   []string // releases the current release is compatible with
      InstallSuffix string   // suffix to use in the name of the install dir
  }
  ```

## -m

- 默认输出模块路径、版本信息，如果有替换，输出替换信息
  - 如果有替换，即 `Replace` 不为 nil 时，下面的 `Dir` 设置的是 `Replace.Dir`
- 主模块是包含当前目录的模块。活动模块是主模块及其依赖模块。默认显示主模块
  - `all` 指定所有活动模块
- 和 `-f` 一起使用，指定模块模板
- 结构体 Module 有一个 String 方法，用于格式化输出行，因此默认输出等价于 `-f {{.String}}`

  ```go
  type Module struct {
      Path      string       // module path
      Version   string       // module version
      Versions  []string     // available module versions (with -versions)
      Replace   *Module      // replaced by this module
      Time      *time.Time   // time version was created
      Update    *Module      // available update, if any (with -u)
      Main      bool         // is this the main module?
      Indirect  bool         // is this module only an indirect dependency of main module?
      Dir       string       // directory holding files for this module, if any
      GoMod     string       // path to go.mod file for this module, if any
      GoVersion string       // go version used in module
      Error     *ModuleError // error loading module
  }

  type ModuleError struct {
      Err string // the error itself
  }
  ```

- `-u` 增加了关于可以升级的信息：`go list -m -u -json all`
- `-version` 设置 `Module.Version` 域为模块已知的版本
- 模板函数 `module` 接收一个字符串参数(必须是一个模块路径或查询)，返回指定的模块对应的 Module 结构体
