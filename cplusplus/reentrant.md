# 可重入性

常见的线程不安全函数和对应的 unix 下的线程安全函数

- 保持跨越多个调用状态的函数
  - rand，对应 rand_r
  - strtok，对应 strtok_r
- 返回指向静态变量的指针的函数
  - asctime，对应 asctime_r
  - ctime，对应 ctime_r
  - gethostbyaddr，对应 gethostbyaddr_r
  - gethostbyname，对应 gethostbyname_r
  - inet_ntoa，
  - localtime，对应 localtime_r
  - gmtime，对应 gmtime_r
- 可重入性
  - 可重入函数（reentrant function）：当被多个线程调用时，不会引入任何共享数据
  - 可重入函数是线程安全函数的一个真子集
  - 显式可重入（explicitly reentrant）：函数都是传值传递的（即没有指针），并且所有的数据引用都是本地的自动栈变量（即没有引用静态或全局变量）
  - 隐式可重入（implicitly reentrant）：函数的一些参数是引用传递的（允许传递指针），传递的是非共享数据的指针