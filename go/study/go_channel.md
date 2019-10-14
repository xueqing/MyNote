# 信道

- [信道](#%e4%bf%a1%e9%81%93)
  - [channel](#channel)
  - [单向 channel](#%e5%8d%95%e5%90%91-channel)
  - [close 关闭信道](#close-%e5%85%b3%e9%97%ad%e4%bf%a1%e9%81%93)
  - [有缓冲的 channel](#%e6%9c%89%e7%bc%93%e5%86%b2%e7%9a%84-channel)

## channel

- channel 可认为是带有类型的 pipe，goroutine 通过 channel 通信
- 每个 channel 有一个关联的类型，这个类型是 channel 允许传输的数据类型
  - `chan T` 是一个 T 类型的通道
- channel 的初始化值是 nil，使用 make 定义`chan_name := make(chan chan_type)`
- 使用信道操作符 `<-` 发送或接收值，箭头是数据流的方向
  - `data := <- chan_name`从 chan_name 读数据，当不需要保存读的数据时是`<- chan_name`
  - `chan_name <- data`往 chan_name 写数据
  - 发送和接收模式是阻塞的，通过 channel 发送数据的时候，控制会阻塞在发送语句直到其他的 goroutine 从 channel 读数据，读数据亦然
  - 避免死锁：如果等待从 channel 读或写的 goroutine 没有对应的写或读，将会阻塞

```go
func calcSquares(number int, squareop chan int) {
    sum := 0
    for number != 0 {
        digit := number % 10
        sum += digit * digit
        number /= 10
    }
    squareop <- sum
}

func calcCubes(number int, cubeop chan int) {
    sum := 0
    for number != 0 {
        digit := number % 10
        sum += digit * digit * digit
        number /= 10
    }
    cubeop <- sum
}

func ChannelTest() {
    number := 54
    squarech := make(chan int)
    cubech := make(chan int)
    go calcSquares(number, squarech)
    go calcCubes(number, cubech)
    squareop, cubeop := <-squarech, <-cubech
    fmt.Printf("squares = %d, cubes = %d\n", squareop, cubeop)
}
```

## 单向 channel

- 可以创建单向的 channel，只用来发送或接受数据，然而没有什么意义
  - `chan<- chan_type`创建只发送/写 channel

    ```go
    func unidirectionalChannel(unich chan<- int) {
        unich <- 1
    }

    func unidirectionalChannelTest() {
        unich := make(chan<- int)
        go unidirectionalChannel(unich)
        // fmt.Println(<-unich) //invalid operation xx(received from send-only type)
    }
    ```

## close 关闭信道

- 发送者可以通过`close chan_name`关闭 channel，通知接收者没有数据了，接收者通过`var, ok := <- chan_name`接受数据，如果是已经关闭的 channel，ok 会赋值 false，主要在用 `for range` 循环从 channel 不断接受数据时使用
- **只有发送者才能关闭信道**。向一个已经关闭的信道发送数据会引发程序 panic
- **信道与文件不同，通常情况下无需关闭**。只有在必须告诉接收者不再有需要发送的值时才有必要关系，例如终止一个 `for range` 循环

  ```go
  func chanSender(chanop chan int) {
      for i := 0; i < 10; i++ {
          chanop <- i
      }
      close(chanop)
  }

  func chanReceiver() {
      chanop := make(chan int)
      go chanSender(chanop)
      // for {
      //     data, ok := <-chanop
      //     if ok == false {
      //         break
      //     }
      //     fmt.Println("Received ", data, ok)
      // }

      for data := range chanop {
          fmt.Println("Received ", data)
      }
  }
  ```

  ```go
  func getDigits(number int, digitch chan int) {
      for number != 0 {
          digit := number % 10
          digitch <- digit
          number /= 10
      }
      close(digitch)
  }

  func calcSquares(number int, squareop chan int) {
      sum := 0
      digitch := make(chan int)
      go getDigits(number, digitch)
      for digit := range digitch {
          sum += digit * digit
      }
      squareop <- sum
  }

  func calcCubes(number int, cubeop chan int) {
      sum := 0
      digitch := make(chan int)
      go getDigits(number, digitch)
      for digit := range digitch {
          sum += digit * digit * digit
      }
      cubeop <- sum
  }

  func ChannelTest() {
      number := 54
      squarech := make(chan int)
      cubech := make(chan int)
      go calcSquares(number, squarech)
      go calcCubes(number, cubech)
      squareop, cubeop := <-squarech, <-cubech
      fmt.Printf("squares = %d, cubes = %d\n", squareop, cubeop)
  }
  ```

## 有缓冲的 channel

- channel 默认没有缓冲，发送和接收都会阻塞
- `make(chan type, capacity)`可以创建 buffered channel，只有缓冲满的时候发送会阻塞，只有缓冲空的时候接收会阻塞
  - channel 容量默认为 0，即没有缓冲，会阻塞
  - 长度是 channel 缓冲现有的元素数目，容量是 channel 缓冲最多可以容纳的数目
