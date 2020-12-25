# EasyDarwin 的任务和线程

- [EasyDarwin 的任务和线程](#easydarwin-的任务和线程)
  - [任务](#任务)
    - [任务分类](#任务分类)
    - [基类 Task](#基类-task)
    - [衍生类 IdleTask](#衍生类-idletask)
    - [TimeoutTask](#timeouttask)
    - [自定义任务](#自定义任务)
  - [线程](#线程)
    - [线程分类](#线程分类)
    - [基类 OSThread](#基类-osthread)
    - [衍生类 TaskThread](#衍生类-taskthread)
    - [衍生类 EventThread](#衍生类-eventthread)
      - [EventContext 处理文件描述符事件](#eventcontext-处理文件描述符事件)
      - [衍生类 Socket](#衍生类-socket)
      - [衍生类 TCPListenerSocket](#衍生类-tcplistenersocket)
        - [HTTPListenerSocket::GetSessionTask](#httplistenersocketgetsessiontask)
        - [RTSPListenerSocket::GetSessionTask](#rtsplistenersocketgetsessiontask)
    - [衍生类 IdleTaskThread](#衍生类-idletaskthread)
    - [TimeoutTaskThread](#timeouttaskthread)
  - [线程池](#线程池)
    - [TaskThreadPool 类](#taskthreadpool-类)
  - [线程池及其他全局线程初始化](#线程池及其他全局线程初始化)

## 任务

### 任务分类

EasyDarwin 有三种任务：基类 `Task` 及其衍生类 `IdleTask`、`TimeoutTask`：

- `Task` 是一个抽象类，所有的衍生类必须实现 `virtual SInt64 Run() = 0` 方法。由 `TaskThread` 执行 `Task` 的 `Run` 函数完成一个任务
- `IdleTask` 是一个抽象类，可以设置空闲时间，由一个全局的 `IdleTaskThread` 线程管理运行，在指定空闲时间到达之后给对应的 `IdleTask` 发送一个 `Task::kIdleEvent`
- `TimeoutTask` 设置一个超时时间，由一个全局的 `TimeoutTaskThread` 线程管理运行，在达到超时时间之后给对应的 `TimeoutTask` 发送一个 `Task::kTimeoutEvent`
  - `TimeoutTask` 没有继承 `Task`，`TimeoutTaskThread` 继承 `IdleTask`，实现了 `Run` 函数，函数内部遍历处理所有的 `TimeoutTask`
  - `TimeoutTaskThread` 目前没有用到 `IdleTask` 的相关接口，**感觉**可以直接继承 `Task`

### 基类 Task

```cpp
// Task.h
class Task
{
    // kXXXEvent: 任务可以接收的事件类型

    // 返回值大于 0：返回值对应的微秒之后发送 kIdleEvent 给本任务
    // 返回 0 ：不要再调用本任务
    // 返回 -1：删除本任务
    virtual SInt64 Run() = 0;// 完成一个任务的句柄
    void Signal(EventFlags eventFlags);// 给任务发送一个事件，把任务加入任务线程的队列，等待完成
    void SetTaskName(char* name);// 设置任务的名称，主要用于日志输出
    void SetThreadPicker(unsigned int* picker);// 设置处理任务的线程类型(短线程/阻塞线程)

    EventFlags GetEvents();// 关闭除了 alive 的其他标记位
    void ForceSameThread();// 下次调用 Run 时使用当前所用的任务线程。适用于两次调用 Run 期间任务持有互斥锁的情况

    TaskThread* fUseThisThread;// 保存下次执行时使用的任务线程
    OSHeapElem  fTimerHeapElem;// 保存任务 Run 函数的返回值，放进任务线程的调度时间堆的元素
    OSQueueElem fTaskQueueElem;// 放进任务线程的任务队列的元素
};
```

```c
// Task.cpp
void Task::Signal(EventFlags events)
{
    if (!this->Valid())
        return;

    // 无锁实现。原子地更新事件掩码，任务只调度一次
    events |= kAlive;
    EventFlags oldEvents = atomic_or(&fEvents, events);
    if ((!(oldEvents & kAlive)) && (TaskThreadPool::sNumTaskThreads > 0))
    {
        if (fDefaultThread != NULL && fUseThisThread == NULL)
            fUseThisThread = fDefaultThread;

        if (fUseThisThread != NULL) // 如果指定任务线程，将任务放到其任务队列 fTaskQueue
        {
            fUseThisThread->fTaskQueue.EnQueue(&fTaskQueueElem);
        }
        else
        {
            // 找一个任务线程来执行此任务：每次加一，循环使用线程池的不同任务线程
            unsigned int theThreadIndex = atomic_add((unsigned int *)pickerToUse, 1);
            if (&Task::sShortTaskThreadPicker == pickerToUse)
            {
                theThreadIndex %= TaskThreadPool::sNumShortTaskThreads;
            }
            else if (&Task::sBlockingTaskThreadPicker == pickerToUse)
            {
                // 前 sNumShortTaskThreads 个线程是短线程
                theThreadIndex %= TaskThreadPool::sNumBlockingTaskThreads;
                theThreadIndex += TaskThreadPool::sNumShortTaskThreads;
            }
            else
            {
                return;
            }
            TaskThreadPool::sTaskThreadArray[theThreadIndex]->fTaskQueue.EnQueue(&fTaskQueueElem);// 将任务放到任务线程的任务队列 fTaskQueue
        }
    }
    else
    {
        // 
    }
}
```

### 衍生类 IdleTask

```c
// IdleTask.h
class IdleTask : public Task
{
    // msec 毫秒后发送 Task::kIdleEvent 给此空闲任务。不能覆盖上一个超时。
    // 函数内部将此空闲任务插入全局空闲任务线程的堆,由全局的空闲任务线程处理
    void SetIdleTimer(SInt64 msec); 
    
    static IdleTaskThread* sIdleThread;// 所有空闲任务由一个全局的空闲任务线程处理
}
```

### TimeoutTask

```c
// TimeoutTask.h
class TimeoutTask // TimeoutTask 不是 Task 的衍生类
{
    // 创建并启动一个全局的超时任务线程。在使用 TimeoutTask 类之前先调用此函数
    static void Initialize(); 

    // 保存需要添加超时的任务，添加当前超时任务到全局的超时任务线程的队列
    TimeoutTask(Task* inTask, SInt64 inTimeoutInMilSecs = 15);

    void SetTimeout(SInt64 inTimeoutInMilSecs);// 修改超时时间，并刷新超时
    // 超时时间段内没有调用此函数，构造函数中保存的指定任务会收到一个 Task::kTimeoutEvent
    void RefreshTimeout();
    
    static TimeoutTaskThread* sThread;// 所有超时任务由一个全局的超时任务线程处理
};
```

### 自定义任务

```c
class MyTask : public Task
{
public:
    MyTask() : Task() { this->SetTaskName("MyTask"); }
    virtual ~MyTask();

    virtual SInt64 Run();// 其他线程给 MyTask 发送 Task::kXXXEvent， 会将 MyTask 放到任务队列等待运行，可以在 Run 中处理希望接收的 Task::kXXXEvent。并根据是否需要继续执行或者周期运行决定 Run 返回值
};
```

## 线程

### 线程分类

EasyDarwin 有多种线程，并有自己的线程池；来执行上述 `Task` 及其衍生类的对象：

- `OSThread` 是一个抽象类，在 `Start` 中创建底层线程，并设置线程的回调函数 `Entry`。因此衍生类可以实现自己的 `Entry` 函数供底层线程执行
- `TaskThread` 是 `OSThread` 的衍生类，主要用于处理 `Task`。实现 `Entry` 函数：调用 `WaitForTask` 获得下一个需要处理的 `Task`，执行 `Task` 的 `Run` 函数
  - `Run` 返回负数：删除任务
  - `Run` 返回 0：不再处理
  - `Run` 返回正数：设置任务的等待调度时间，插入任务线程的 `fHeap` 等待下一次调度
- `EventThread` 是 `OSThread` 的衍生类，主要用于处理 `EventContext` 中注册的 socket 事件
  - `EventContext` 用于处理 UNIX 文件描述符事件(`EV_RE/EV_WR`)，并在事件发生时通知相关的任务
  - `Socket` 是 `EventContext` 的衍生类，提供接口创建和启动全局的 `EventThread` 处理所有的套接字事件
- `IdleTaskThread` 是 `OSThread` 的衍生类，用于处理 `IdleTask`
  - `IdleTask` 提供接口创建和启动全局的 `IdleTaskThread` 处理所有的 `IdleTask`，通知超时的 `IdleTask` (发送 `Task::kIdleEvent`)
- `TimeoutTaskThread` 是 `IdleTask` 的衍生类，用于处理 `TimeoutTask`
  - `TimeoutTask` 提供接口创建并启动全局的 `TimeoutTaskThread` 处理所有的 `TimeoutTask，TimeoutTaskThread` 没有创建新的线程，而是使用线程池已经创建好的线程运行
  - `TimeoutTaskThread` 实现 `Run` 函数：遍历超时任务队列，超时之后通知超时任务(发送 `Task::kTimeoutEvent`)

### 基类 OSThread

```c
// OSThread.h
class OSThread
{
    static void Initialize();// 在使用 OSThread 类之前先调用此函数

    virtual void Entry() = 0;// 衍生类必须实现自己的 Entry 函数
    void Start();// 创建一个底层线程，执行 Entry 函数
};
```

### 衍生类 TaskThread

```cpp
// Task.h
class TaskThread : public OSThread
{
    virtual void Entry();// OSThread 定义，底层线程运行时最终调用此函数
    Task* WaitForTask();// 获得下一个需要处理的 Task

    OSQueueElem         fTaskThreadPoolElem;
    OSHeap              fHeap;// 根据任务调度时间(Task->fTimerHeapElem)排序
    OSQueue_Blocking    fTaskQueue;// 保存等待执行的任务
};
```

```c
// Task.cpp
void TaskThread::Entry()
{
    Task* theTask = NULL;

    while (true) // 循环处理当前线程的任务队列，执行任务的 Run 函数
    {
        theTask = this->WaitForTask();// 获得下一个需要处理的 Task
        if (theTask == NULL || false == theTask->Valid())
            return;// 没有任务处理时退出线程

        Bool16 doneProcessingEvent = false;
        while (!doneProcessingEvent)
        {
            theTask->fUseThisThread = NULL;// 每次调用 Run 必须独立请求一个指定线程
            SInt64 theTimeout = 0;

            if (theTask->fWriteLock) // 任务持有写锁
            {
                OSMutexWriteLocker mutexLocker(&TaskThreadPool::sMutexRW);
                theTimeout = theTask->Run();
                theTask->fWriteLock = false;
            }
            else // 任务持有读锁
            {
                OSMutexReadLocker mutexLocker(&TaskThreadPool::sMutexRW);
                theTimeout = theTask->Run();
            }
            
            if (theTimeout < 0) // Run 返回负数，删除任务
            {
                theTask->fTaskName[0] = 'D';// 标记任务为 dead
                delete theTask;// 删除
                theTask = NULL;
                doneProcessingEvent = true;
            }
            else if (theTimeout == 0) //  Run 返回 0
            {
                // 确保当另外一个线程调用 Signal 时此任务的 Run 函数会被执行。并且如果任务从 Run (通过 Signal) 返回时有一个事件到来，Run 也会被再次调用
                doneProcessingEvent = compare_and_store(Task::kAlive, 0, &theTask->fEvents);
                if (doneProcessingEvent)
                    theTask = NULL;
            }
            else // Run 返回正数
            {
                // 更新任务的等待时间，插入任务堆 fHeap
                theTask->fTimerHeapElem.SetValue(OS::Milliseconds() + theTimeout);
                fHeap.Insert(&theTask->fTimerHeapElem);
                (void)atomic_or(&theTask->fEvents, Task::kIdleEvent);
                doneProcessingEvent = true;
            }

            this->ThreadYield();
        }
    }
}

Task* TaskThread::WaitForTask()
{
    while (true) // 循环查找可以执行的任务
    {
        SInt64 theCurrentTime = OS::Milliseconds();

        // 先从 fHeap 中查找
        if ((fHeap.PeekMin() != NULL) && (fHeap.PeekMin()->GetValue() <= theCurrentTime))
        {
            return (Task*)fHeap.ExtractMin()->GetEnclosingObject();// 找到可以立即执行的任务
        }

        // 没有任务可以立即执行，计算最近一个需要调度的任务的超时时间
        SInt64 theTimeout = 0;
        if (fHeap.PeekMin() != NULL)
            theTimeout = fHeap.PeekMin()->GetValue() - theCurrentTime;
        Assert(theTimeout >= 0);
        if (theTimeout < 10)
            theTimeout = 10;// 最小等待时间是 10 毫秒

        // 根据上面的超时时间等待，从 fTaskQueue 查找任务
        OSQueueElem* theElem = fTaskQueue.DeQueueBlocking(this, (SInt32)theTimeout);
        if (theElem != NULL)
        {
            return (Task*)theElem->GetEnclosingObject();
        }

        if (OSThread::GetCurrent()->IsStopRequested()) // 当前线程被停止
            return NULL;
    }
}
```

### 衍生类 EventThread

```c
// EventContext.h
class EventThread : public OSThread
{
    virtual void Entry();// OSThread 定义，底层线程运行时最终调用此函数
    OSRefTable fRefTable;
};
```

```c
// EventContext.cpp
void EventThread::Entry()
{
    struct eventreq theCurrentEvent;
    ::memset(&theCurrentEvent, '\0', sizeof(theCurrentEvent));

    while (true) // 循环处理 EventContext 中注册的事件
    {
        int theErrno = EINTR;
        while (theErrno == EINTR) // Interrupted system call
        {
            int theReturnValue = epoll_waitevent(&theCurrentEvent, NULL);// 监听 socket 事件
            if (theReturnValue >= 0)
                theErrno = theReturnValue;
            else
                theErrno = OSThread::GetErrno();
        }
        AssertV(theErrno == 0, theErrno);

        if (theCurrentEvent.er_data != NULL) // 处理 socket 的数据
        {
            StrPtrLen idStr((char*)&theCurrentEvent.er_data, sizeof(theCurrentEvent.er_data));
            OSRef* ref = fRefTable.Resolve(&idStr);
            if (ref != NULL)
            {
                // 找到对应的 EventContext，调用 ProcessEvent 处理 socket 事件
                EventContext* theContext = (EventContext*)ref->GetObject();
                theContext->ProcessEvent(theCurrentEvent.er_eventbits);
                fRefTable.Release(ref);
            }
        }

        this->ThreadYield();
    }
}
```

#### EventContext 处理文件描述符事件

```c
// EventContext.h
class EventContext // 用于处理 UNIX 文件描述符事件(EV_RE/EV_WR)，并通知一个任务
{
public:
    // EventThread 用于接收和处理此 EventContext 的事件，
    EventContext(int inFileDesc, EventThread* inThread);

    // 设置文件描述符是非阻塞的。一旦调用此函数，文件描述符被此 EventContext 对象拥有，并在调用
    // Cleanup 时关闭文件描述符。因此不能在外部关闭这个文件描述符。
    void InitNonBlocking(int inFileDesc);

    // 注册当前 EventThread 到 EventThread，并调用 addEpollEvent 注册想要接收的事件
    void RequestEvent(int theMask = EV_RE);
    void SetTask(Task* inTask) // 保存想要通知的任务

    // 当文件描述符有事件时，调用此函数。
    // 给上述保存的待通知的任务发送一个 Task::kReadEvent
    virtual void ProcessEvent(int /*eventBits*/);

    int             fFileDesc;// 保存相关的文件描述符
    struct eventreq fEventReq;// 保存事件的具体信息
    OSRef           fRef;// 注册 fRef 到 fEventThread->fRefTable
    EventThread*    fEventThread;// 注册的事件由 fEventThread 处理
    Task*           fTask;// 收到事件时通知任务 fTask
};
```

#### 衍生类 Socket

```c
// Socket.h
class Socket : public EventContext
{
    static void Initialize() //创建全局的 EventThread 处理 socket 事件
    static void StartThread() //启动上面创建的全局 EventThread
    static EventThread* sEventThread;// 保存全局的 EventThread
};
```

#### 衍生类 TCPListenerSocket

```c
// TCPListenerSocket.h
class TCPListenerSocket : public TCPSocket, public IdleTask
{
    OS_Error Initialize(UInt32 addr, UInt16 port);// 开始监听
    virtual Task* GetSessionTask(TCPSocket** outSocket) = 0;// 衍生类必须实现此方法返回任务和套接字
    virtual SInt64 Run();
    virtual void ProcessEvent(int eventBits);// EventContext 定义。有事件时调用此函数
};
```

```c
// TCPListenerSocket.cpp
void TCPListenerSocket::ProcessEvent(int /*eventBits*/)
{
    // 所有 socket 使用一个全局的 EventThread 处理，因此 ProcessEvent 必须迅速

    struct sockaddr_in addr;
    socklen_t size = sizeof(addr);
    Task* theTask = NULL;
    TCPSocket* theSocket = NULL;

    // 接收一个 TCP 连接
    int osSocket = accept(fFileDesc, (struct sockaddr*)&addr, &size);

    if (osSocket == -1)
    {
        int acceptError = OSThread::GetErrno();// 检查错误
        if (acceptError == EAGAIN)
        {
            this->RequestEvent(EV_RE); // EAGAIN 表示监听队列目前没有事件，注册读事件，直接返回
            return;
        }
        // 其他错误
        }
    }

    theTask = this->GetSessionTask(&theSocket);// 返回一个任务和套接字
    if (theTask == NULL)
        close(osSocket);
        if (theSocket)
            theSocket->fState &= ~kConnected; // 关闭连接
    }
    else
    {
        // 设置套接字选项

        theSocket->Set(osSocket, &addr);
        theSocket->InitNonBlocking(osSocket);
        theSocket->SetTask(theTask);// 设置套接字收到事件时要通知(kReadEvent)的任务
        theSocket->RequestEvent(EV_RE);// 注册一个读事件
        theTask->SetThreadPicker(Task::GetBlockingTaskThreadPicker()); //使用阻塞线程处理任务
    }

    if (fSleepBetweenAccepts)
    {
        // 达到最大连接数时，更新 fSleepBetweenAccepts 为 true，由此设定 TCPListenerSocket 的空闲时间，暂时不再监听事件，直到触发定时器
        this->SetIdleTimer(kTimeBetweenAcceptsInMsec);
    }
    else
    {
        this->RequestEvent(EV_RE);// 等待其他客户端连入
    }
}
```

EasyDarwin 包含两个 `TCPListenerSocket` 的衍生类：`HTTPListenerSocket` 和 `RTSPListenerSocket`，分别用于提供 HTTP 服务 和 RTSP 服务。

- 如果事件来自 HTTP 服务监听端口，`EventThread::Entry` 处理事件，调用 `TCPListenerSocket::ProcessEvent`，然后执行 `HTTPListenerSocket::GetSessionTask`，返回一个 `HTTPSession` 及其相关的 `Socket`，设置 `Socket` 的属性，注册新建的 `Socket` 读事件，等待更多数据，之后通知新建的 `HTTPSession` 任务处理读到的数据，由此实现了单个 `Task` 处理一个 HTTP 连接
- 如果事件来自 RTSP 服务监听端口，`EventThread::Entry` 处理事件，调用 `TCPListenerSocket::ProcessEvent`，然后执行 `RTSPListenerSocket::GetSessionTask`，返回一个 `RTSPSession` 及其相关的 `Socket`，设置 `Socket` 的属性，注册新建的 `Socket` 读事件，等待更多数据，之后通知新建的 `RTSPSession` 任务处理读到的数据，由此实现了单个 `Task` 处理一个 RTSP 连接

##### HTTPListenerSocket::GetSessionTask

```c
Task*   HTTPListenerSocket::GetSessionTask(TCPSocket** outSocket)
{
    Assert(outSocket != NULL);

    HTTPSession* theTask = NEW HTTPSession();
    *outSocket = theTask->GetSocket();// 将 HTTPSession 保存的 socket 和 Unix 文件描述关联

    // 达到最大连接数时，设定 TCPListenerSocket 的空闲时间，将 HTTPListenerSocket 加入空闲任务队列，暂时不再监听 HTTP 连接，直到触发定时器
    if (this->OverMaxConnections(0))
        this->SlowDown();
    else
        this->RunNormal();

    return theTask;
}
```

##### RTSPListenerSocket::GetSessionTask

```c
Task*   RTSPListenerSocket::GetSessionTask(TCPSocket** outSocket)
{
    Assert(outSocket != NULL);

    // when the server is behing a round robin DNS, the client needs to knwo the IP address ot the server
    // so that it can direct the "POST" half of the connection to the same machine when tunnelling RTSP thru HTTP
    Bool16  doReportHTTPConnectionAddress = QTSServerInterface::GetServer()->GetPrefs()->GetDoReportHTTPConnectionAddress();

    RTSPSession* theTask = NEW RTSPSession(doReportHTTPConnectionAddress);
    *outSocket = theTask->GetSocket();// 将 RTSPSession 保存的 socket 和 Unix 文件描述关联

    // 达到最大连接数时，设定 TCPListenerSocket 的空闲时间，将 RTSPListenerSocket 加入空闲任务队列，暂时不再监听 RTSP 连接，直到触发定时器
    if (this->OverMaxConnections(0))
        this->SlowDown();
    else
        this->RunNormal();

    return theTask;
}
```

### 衍生类 IdleTaskThread

```c
// IdleTask.h
class IdleTaskThread : private OSThread
{
    void SetIdleTimer(IdleTask* idleObj, SInt64 msec);// 插入一个空闲任务
    void CancelTimeout(IdleTask* idleObj);

    virtual void Entry();// OSThread 定义，底层线程运行时最终调用此函数
    OSHeap  fIdleHeap;// 保存所有的空闲任务
};
```

```c
// IdleTask.cpp
void IdleTaskThread::Entry()
{
    OSMutexLocker locker(&fHeapMutex);

    while (true)
    {
        if (fIdleHeap.CurrentHeapSize() == 0) // 没有空闲任务时阻塞
            fHeapCond.Wait(&fHeapMutex);
        SInt64 msec = OS::Milliseconds();

        // 从堆中找到超时的空闲任务
        while ((fIdleHeap.CurrentHeapSize() > 0) && (fIdleHeap.PeekMin()->GetValue() <= msec))
        {
            IdleTask* elem = (IdleTask*)fIdleHeap.ExtractMin()->GetEnclosingObject();
            Assert(elem != NULL);
            elem->Signal(Task::kIdleEvent);// 通知超时的空闲任务
        }

        if (fIdleHeap.CurrentHeapSize() > 0)
        {
            SInt64 timeoutTime = fIdleHeap.PeekMin()->GetValue();
            timeoutTime -= msec;// 计算需要最近的空闲任务的剩余时间
            Assert(timeoutTime > 0);
            UInt32 smallTime = (UInt32)timeoutTime;
            fHeapCond.Wait(&fHeapMutex, smallTime);// 等待新的空闲任务或者最近的空闲任务超时
        }
    }
}
```

### TimeoutTaskThread

```c
// TimeoutTask.h
class TimeoutTaskThread : public IdleTask
{
    virtual SInt64  Run();// 遍历处理所有超时任务

    OSQueue fQueue;// 保存需要处理的超时任务 TimeoutTask
};
```

```c
// TimeoutTask.cpp
SInt64 TimeoutTaskThread::Run()
{
    OSMutexLocker locker(&fMutex);
    SInt64 curTime = OS::Milliseconds();    
    SInt64 intervalMilli = kIntervalSeconds * 1000;// 默认 15 秒。但会调整到最小间隔，且为正数 
    SInt64 taskInterval = intervalMilli;

    for (OSQueueIter iter(&fQueue); !iter.IsDone(); iter.Next()) // 遍历超时任务队列
    {
        TimeoutTask* theTimeoutTask = (TimeoutTask*)iter.GetCurrent()->GetEnclosingObject();

        if ((theTimeoutTask->fTimeoutAtThisTime > 0) && (curTime >= theTimeoutTask->fTimeoutAtThisTime)) // 如果任务超时
        {
            theTimeoutTask->fTask->Signal(Task::kTimeoutEvent);// 通知超时任务
        }
        else
        {
            taskInterval = theTimeoutTask->fTimeoutAtThisTime - curTime;// 计算超时间隔
            if ((taskInterval > 0) && (theTimeoutTask->fTimeoutInMilSecs > 0) && (intervalMilli > taskInterval))
                intervalMilli = taskInterval + 1000;// 设置超时多一秒，再次遍历时该任务一定超时
        }
    }
    (void)this->GetEvents();// 清楚超时任务线程的事件
    OSThread::ThreadYield();
    return intervalMilli;// 指定时间之后再次调用此全局超时任务线程
}
```

## 线程池

### TaskThreadPool 类

```cpp
// Task.h
class TaskThreadPool {
public:
    //Adds some threads to the pool
    static Bool16   AddThreads(UInt32 numToAdd);// 创建线程池的线程(短线程+阻塞线程)
    static void     SwitchPersonality(char *user = NULL, char *group = NULL);
    static void     RemoveThreads();// 服务停止时移除线程池的线程
    static TaskThread* GetThread(UInt32 index);// 根据索引从线程池选择任务线程
};
// Task.cpp
TaskThread** TaskThreadPool::sTaskThreadArray = NULL;// 数组保存线程池的任务线程
```

`TaskThreadPool` 提供接口设置任务线程的数目。默认等同于处理器的数目。

## 线程池及其他全局线程初始化

EasyDarwin 在 `RunServer.cpp` 的 `StartServer` 初始化线程池及其他上述提到的全局线程：

```cpp
// RunServer.cpp: StartServer
Socket::Initialize();// 创建一个全局的 EventThread
::epollInit();// 初始化 epoll，创建 epollfd，申请 epoll 事件接收内存

// 初始化各种类型；创建 HTPP/RTSP 监听端口(TCPListenerSocket)，保存在 QTSServerInterface::fListeners 数组
sServer->Initialize(inPrefsSource, inMessagesSource, inPortOverride, createListeners, sAbsolutePath);

numThreads = numShortTaskThreads + numBlockingThreads;
TaskThreadPool::SetNumShortTaskThreads(numShortTaskThreads);// 设置短线超数目
TaskThreadPool::SetNumBlockingTaskThreads(numBlockingThreads);// 设置阻塞线程数目
TaskThreadPool::AddThreads(numThreads);// 设置线程池的任务线程，开启所有任务线程

TimeoutTask::Initialize();// 创建并启动一个全局的超时任务线程(在线程池中运行)，处理所有的超时任务
IdleTask::Initialize();// 创建并启动一个全局的空闲任务线程，处理所有的空闲线程
Socket::StartThread();// 启动上面创建的全局 EventThread，用于处理所有的文件描述符事件
sServer->StartTasks();// 开启一些全局任务(处理 RTCP 数据任务、RTP 负载统计任务)，开始监听上面创建的端口
```
