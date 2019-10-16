# 测试标识

`go test` 命令使用只适用于 `go test` 的标识以及适用于生成二进制测试的标识。

一些标识控制概要并且写适用于 `go tool pprof` 的执行概要；运行 `go tool pprof -h` 查看更多信息。pprof 的 --alloc_space、--alloc_objects 和 --show_bytes 选项控制如何显示这些信息。

下面的标识被 `go test` 命令识别，并且控制测试的执行：

- -bench regexp
  只允许匹配了正则表达式的基准测试。
  默认不会运行任何基准测试。
  要运行所有基准测试，使用 “-bench .” 或 “-bench=.”。
  正则表达式使用斜线分隔为一个正则表达式序列，且如果有的话，基准测试标识符的每个部分必须匹配序列中对应元素。匹配可能的父节点使用 b.N=1 允许以识别子基准测试。例如，指定 -bench=X/Y，顶层匹配 X 的基准测试使用 b.N=1 运行来查找所有匹配 Y 的子基准测试，然后运行全部基准测试。
- -benchtime t
  每个基准测试运行足够多的迭代以达到耗时 t，t 指定为 time.Duration (比如 -benchtime 1h30s)。
  默认是 1 秒(1s)。
  特殊语法 Nx 是指运行基准测试 N 次(比如 -benchtime 100x)。
- -count n
  每个测试和基准测试运行 n 次(默认 1)。
  如果设置了 -cpu，为每个 GOMAXPROCS 值运行 n 次。
  示例总是运行一次。
- -cover
  启用覆盖分析。
  注意因为覆盖通过在编译之前给源码做注解来工作，开启了覆盖的编译和测试失败可能会报告哪些和初始的代码不一致的行编号。
- -covermode set,count,atomic
  指定测试包的覆盖分析模式，默认是 “set”，除非开启了 -race(此时覆盖模式是 “atomic”)。值包括

  - set：bool 类型，这个语句运行吗？
  - count：int 类型，这个语句允许多少次？
  - atomic：int 类型，count，但是在多线程测试是正确的。显然更昂贵。
  
  设置了 -cover。
- -coverpkg pattern1,pattern2,pattern3
  每次测试时应用覆盖分析到匹配模式的包。
  默认是每次测试时只分析正在测试的包。
  查看 `go help packages` 查看包模式的描述信息。
  设置了 -cover。
- -cpu 1,2,4：
  指定测试或基准测试应当执行的 GOMAXPROCS 值。默认是 GOMAXPROCS 的当前值。
- -failfast
  第一个测试失败之后不要开始新的测试。
- -list regexp
  列举匹配正则表达式的测试、基准测试或示例。
  不会允许任何测试、基准测试或示例。这只会列举顶层的测试。子测试项目和子基准测试不会显示。
- -parallel n
  允许并行执行调用了 t.Parallel 的测试函数。
  这个标识的值是将要同时运行的测试的最大数；默认被设置为 GOMAXPROCS。
  注意 -parallel 值在一个二进制测试内部适用。
  `go test` 命令也可能并行测试不同包，这由 -p 标识设置而定(查看 `go help build`)。
- -run regexp
  只允许匹配正则表达式的测试和示例。
  对于测试，正则表达式由斜线分隔为正则表达式序列，并且如果有的话，一个测试标识符的每个部分必须和序列的对应元素匹配。注意匹配的父测试也会运行，因此 -run=X/Y 匹配、运行和报告所有匹配 X 的测试的结果，即使这些测试没有子测试与 Y 匹配。因为它必须运行以查找这些子测试。
- -short
  告诉长时间运行的测试缩短它们的运行时间。
  默认是关闭的，但是在 all.bash 期间设置，以便 Go 树的安装会运行一个正常的检查但是不会花时间运行耗时的测试。
- -timeout d
  如果一个二进制测试运行时间超过 d，终止它。
  如果 d 为 0，禁用超时。
  默认是 10 分钟(10m)。
- -v
  错误输出：测试运行时记录打印测试日志。并且，即使测试成功，也打印所有来自 Log 和 Logf 调用的文本。
- -vet list
  配置 `go test` 期间的 `go vet` 调用，使用逗号分隔 vet 检查的列表。
  如果列表为空，`go test` 运行配置的列表，该列表被认为总是值得处理的。
  如果列表是 “off”，`go test` 不会允许 `go vet`。

下面的标识被 `go test` 命令识别，且可用于概述执行期间的测试：

```txt
-benchmem
    Print memory allocation statistics for benchmarks.

-blockprofile block.out
    Write a goroutine blocking profile to the specified file
    when all tests are complete.
    Writes test binary as -c would.

-blockprofilerate n
    Control the detail provided in goroutine blocking profiles by
    calling runtime.SetBlockProfileRate with n.
    See 'go doc runtime.SetBlockProfileRate'.
    The profiler aims to sample, on average, one blocking event every
    n nanoseconds the program spends blocked. By default,
    if -test.blockprofile is set without this flag, all blocking events
    are recorded, equivalent to -test.blockprofilerate=1.

-coverprofile cover.out
    Write a coverage profile to the file after all tests have passed.
    Sets -cover.

-cpuprofile cpu.out
    Write a CPU profile to the specified file before exiting.
    Writes test binary as -c would.

-memprofile mem.out
    Write an allocation profile to the file after all tests have passed.
    Writes test binary as -c would.

-memprofilerate n
    Enable more precise (and expensive) memory allocation profiles by
    setting runtime.MemProfileRate. See 'go doc runtime.MemProfileRate'.
    To profile all memory allocations, use -test.memprofilerate=1.

-mutexprofile mutex.out
    Write a mutex contention profile to the specified file
    when all tests are complete.
    Writes test binary as -c would.

-mutexprofilefraction n
    Sample 1 in n stack traces of goroutines holding a
    contended mutex.

-outputdir directory
    Place output files from profiling in the specified directory,
    by default the directory in which "go test" is running.

-trace trace.out
    Write an execution trace to the specified file before exiting.
```

所有这些标识也有一个可选的 “test.” 前缀被识别(如 -test.v)。但是当直接调用生成的二进制测试时(`go test -c` 生成)，这个前缀是强制的。

`go test` 命令在调用二进制测试之前，适当地重写或移除在可选的包列表之前或之后识别的标识。

比如，命令 `go test -v -myflag testdata -cpuprofile=prof.out -x` 将会编译二进制测试然后运行 `pkg.test -test.v -myflag testdata -test.cpuprofile=prof.out`。(-x 标识被移除，因为它只适用于go 命令的执行，而不是`go test`)

生成概述(除了用于覆盖)的测试标识也会将二进制测试留在 pkg.test 以便用于分析概述。

当 `go test` 运行一个二进制测试时，它从对应包源码目录内部运行。视测试而定，可能需要在直接调用一个生成的二进制测试时也这样做。

命令行的包列表，如果有的话，必须出现在所有 `go test` 命令不知道的标识之前。继续上面的例子，包列表需要出现在 -myflag 之前，但是可以出现在 -v 两侧。

当 `go test` 在列表模式运行时，`go test` 缓存成功的包测试结果以避免不必要的重复运行测试。要禁用测试缓存，使用除了可缓存的标识以外的任意的测试标识或参数。惯用的显式禁用测试缓存的方法是使用 -count=1。

要保持二进制测试的一个参数不被翻译成一个已知的标识或者包名，使用 -args (查看 `got help test`) 换地命令行的剩余部分给二进制测试，该部分不会被解释或修改。

例如，命令 `go test -v -args -x -v` 会编译二进制测试然后运行 `pkg.test -test.v -x -v`。类似的，`go test -args math` 会编译二进制测试然后运行 `pkg.test math`。

在第一个例子中，-x 和第二个 -v 被传递给二进制测试且未被修改，且对 go 命令本身没有影响。在第二个例子中，参数 math 被传递给二进制测试，而不是解释成包列表。
