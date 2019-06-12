# goroutine

- goroutine 是和其他函数或方法并发运行的函数或方法
- goroutine 可认为是轻量级的线程，比线程创建代价小

## goroutine 优于线程

- goroutine 更加轻量。只有几个 Kb 大小的栈，且可根据需求增长。但是线程的栈大小是固定的？？
- goroutine 被复用到更少数量的线程。一个线程可能有很多 goroutine，当该线程的一个 goroutine 阻塞时，另外一个 OS 线程被创建，并将剩余的 goroutine 移到新的 OS 线程
- goroutine 使用 channel 通信。channel 可以防止 goroutine 访问共享内存时竞争。channel 可认为是一个管道

## 创建一个 goroutine

- 使用`go`可以开始一个 goroutine
- 启动一个 goroutine 时，`go`立即返回，继续执行下一行代码，新启动的 goroutine 的返回值都会被忽略
- main goroutine 应当启动其他 goroutine。因为 main goroutine 终止时，程序就会终止，不会再有 goroutine 运行
