# go 互斥锁

- [go 互斥锁](#go-%e4%ba%92%e6%96%a5%e9%94%81)
  - [sync.Mutex](#syncmutex)

## sync.Mutex

- 互斥：保证每次只有一个 goroutine 可以访问一个共享的变量
- go 标准库提供 `sync.Mutex` 互斥锁类型及两个方法： `Lock` 和 `Unlock`
  - 在代码前调用 `Lock`，在代码后调用 `Unlock` 保证这段代码的互斥执行
  - 可用 `defer` 语句保证互斥锁一定会被解锁

```go
package main

import (
    "fmt"
    "sync"
    "time"
)

// SafeCounter is safe to use concurrently.
type SafeCounter struct {
    v   map[string]int
    mux sync.Mutex
}

// Inc increments the counter for the given key.
func (c *SafeCounter) Inc(key string) {
    c.mux.Lock()
    // Lock so only one goroutine at a time can access the map c.v.
    c.v[key]++
    c.mux.Unlock()
}

// Value returns the current value of the counter for the given key.
func (c *SafeCounter) Value(key string) int {
    c.mux.Lock()
    // Lock so only one goroutine at a time can access the map c.v.
    defer c.mux.Unlock()
    return c.v[key]
}

func main() {
    c := SafeCounter{v: make(map[string]int)}
    for i := 0; i < 1000; i++ {
        go c.Inc("somekey")
    }

    time.Sleep(time.Second)
    fmt.Println(c.Value("somekey"))
}
```
