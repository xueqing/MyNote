# WaitGroup 和 worker pool

- [WaitGroup 和 worker pool](#waitgroup-%e5%92%8c-worker-pool)
  - [WaitGroup](#waitgroup)
  - [worker pool](#worker-pool)

## WaitGroup

- WaitGroup 用于等待一个集合的 goroutine 执行完毕。
- WaitGroup 是一个结构体，内部使用了一个计数器，使用 Add 可以增加计数，使用 Done 可以减少计数。当计数为 0 的时候，Wait 返回
  - WaitGroup 不能使用值传递，否则会复制拷贝，将不能通知 Wait 函数

```go
func goroutineProccess(index int, wg *sync.WaitGroup) {
    fmt.Println("start goroutineProcess ", index)
    time.Sleep(2 * time.Second)
    fmt.Printf("Ended goroutineProcess %d\n", index)
    wg.Done()
}

func WaitgroupTest() {
    routineNumber := 3
    var wg sync.WaitGroup
    for i := 0; i < routineNumber; i++ {
        wg.Add(1)
        go goroutineProccess(i, &wg)
    }
    wg.Wait()
    fmt.Println("All goroutine exit...")
}
```

## worker pool

- worker pool 是一个线程的集合，等待分配任务执行。任务完成之后，立刻准备下一个任务
- 使用 buffered channel 实现 worker pool

```go
type Job struct {
    id       int
    randomno int
}

type Result struct {
    job         Job
    sumofdigits int
}

var jobs = make(chan Job, 10)
var results = make(chan Result, 10)

func digits(number int) int {
    sum := 0
    no := number
    for no != 0 {
        sum += no % 10
        no /= 10
    }
    time.Sleep(2 * time.Second)
    return sum
}

func dowork(wg *sync.WaitGroup) {
    for job := range jobs {
        sum := Result{job, digits(job.randomno)}
        results <- sum
    }
    wg.Done()
}

func createWorkerPool(noOfWorkers int) {
    var wg sync.WaitGroup
    for i := 0; i < noOfWorkers; i++ {
        wg.Add(1)
        go dowork(&wg)
    }
    wg.Wait()
    close(results)
}

func createJobs(noOfJobs int) {
    for i := 0; i < noOfJobs; i++ {
        randomno := rand.Intn(999)
        job := Job{i, randomno}
        jobs <- job
    }
    close(jobs)
}

func getResult(done chan bool) {
    for result := range results {
        fmt.Printf("Job id = %2d, randomno = %3d, result = %d\n", result.job.id, result.job.randomno, result.sumofdigits)
    }
    done <- true
}

func WokerPoolTest() {
    startTime := time.Now()
    noOfJobs := 100
    go createJobs(noOfJobs)
    noOfWorkers := 10
    go createWorkerPool(noOfWorkers)
    done := make(chan bool)
    go getResult(done)
    <-done
    endTime := time.Now()
    diff := endTime.Sub(startTime)
    fmt.Println("Cost ", diff.Seconds(), " seconds")
}
```
