# auto_ptr, unique_ptr, shared_ptr and weak_ptr

- [auto_ptr, unique_ptr, shared_ptr and weak_ptr](#autoptr-uniqueptr-sharedptr-and-weakptr)
  - [auto_ptr](#autoptr)
  - [unique_ptr](#uniqueptr)
  - [shared_ptr](#sharedptr)
  - [weak_ptr](#weakptr)
  - [reference](#reference)

## auto_ptr

- C++11 已经弃用。`unique_ptr`是新的具有相似功能的智能指针，但是安全性更高。
- `auto_ptr`是管理对象的指针，通过`new`的操作创建，当`auto_ptr`销毁的时候会删除该对象。
- 一个用`auto_ptr`存储了一个指针指向一个被分配的对象，确保当代码运行到指针的范围之外时，指针指向的对象会自动销毁。
- `auto_ptr`基于独有的所有权模型（exclusive ownership model），也就是说，两个相同类型的指针不能同时指向同一个资源。复制或者赋值给指针会改变所有权，即源指针会把所有权移交给目的指针。
- 下面的代码可以看出复制指针的时候所有权的转移

    ```code
    // C++ program to illustrate the use of auto_ptr
    #include<iostream>
    #include<memory>
    using namespace std;

    class A
    {
    public:
        void show() { cout << "A::show()" << endl; }
    };

    int main()
    {
        // p1 is an auto_ptr of type A
        auto_ptr<A> p1(new A);
        p1 -> show();

        // returns the memory address of p1
        cout << p1.get() << endl;

        // copy constructor called, this makes p1 empty.
        auto_ptr <A> p2(p1);
        p2 -> show();

        // p1 is empty now
        cout << p1.get() << endl;

        // p1 gets copied in p2
        cout<< p2.get() << endl;

        return 0;
    }
    ```

- 输出结果如下

    ```code
    A::show()
    0x1b42c20
    A::show()
    0           // NULL
    0x1b42c20
    ```

- `auto_ptr`的拷贝构造函数和赋值运算符实际上不会拷贝存储的指针，而是转移指针，从而使得源指针为空。`auto_ptr`实现了严格的所有权管理，使得同一时刻只有一个`auto_ptr`对象可以拥有该指针。
- 丢弃`auto_ptr`的原因：`auto_ptr`的赋值运算转移所有权，并且重置右值的`auto_ptr`为空指针。因此，`auto_ptr`不能用于 STL 容器。

## unique_ptr

- `unique_ptr`是 C++11 开发用于替换`std::auto_ptr`的。
- `unique_ptr`具有更好的安全性（没有“虚假”的拷贝赋值），增加了特性（删除器），支持数组。它是一个保存原始指针的容器。`unique_ptr`显式地避免持有的指针拷贝赋值，它只允许指针有一个持有者。所以对于一个资源，至多只有一个`unique_ptr`指向，当`unique_ptr`销毁时，资源会自动释放。
- 对`unique_ptr`拷贝赋值会导致编译错误。比如下面的代码：

    ```code
    unique_ptr<A> ptr1 (new A);
    unique_ptr<A> ptr2 = ptr1; // Error: can't copy unique_ptr
    ```

- 可以使用`std::move()`语法转移持有指针的所有权给另外一个`unique_ptr`。`unique_ptr<A> ptr2 = move(ptr1);`
- 下面的代码阐述了`unique_ptr`的使用

    ```code
    #include<iostream>
    #include<memory>
    using namespace std;
    class A
    {
    public:
        void show()
        {
            cout<<"A::show()"<<endl;
        }
    };

    int main()
    {
        unique_ptr<A> p1 (new A);
        p1 -> show();

        // returns the memory address of p1
        cout << p1.get() << endl;

        // transfers ownership to p2
        unique_ptr<A> p2 = move(p1);
        p2 -> show();
        cout << p1.get() << endl;
        cout << p2.get() << endl;

        // transfers ownership to p3
        unique_ptr<A> p3 = move (p2);
        p3->show();
        cout << p1.get() << endl;
        cout << p2.get() << endl;
        cout << p3.get() << endl;

        return 0;
    }
    ```

  - 输出结果如下：

    ```code
    A::show()
    0x1c4ac20
    A::show()
    0          // NULL
    0x1c4ac20
    A::show()
    0          // NULL
    0          // NULL
    0x1c4ac20
    ```

- 下面的代码返回一个资源，如果我们不显式的接收返回值，资源会被清理。反之，我们会得到对该资源的唯一所有权。因此，可以认为`unique_ptr`比`auto_ptr`更安全。

    ```code
    unique_ptr<A> fun()
    {
        unique_ptr<A> ptr(new A);
        // do something
        return ptr;
    }
    ```

## shared_ptr

- `shared_ptr`是一个保存原始指针的容器。它是引用计数所有权模型（`reference counting ownership model`）。`shared_ptr`维护了持有指针的引用计数以及所有对`shared_ptr`的拷贝。因此，当一个新的指针指向资源的时候计数增加，当指针析构的时候计数减少。
- 引用计数(`reference counting`)：是一种存储对于一个资源（比如对象，内存块，磁盘空间或者其他资源）的引用、指针或者句柄的数目的技术。
- 当代码执行到指向资源的所有`shared_ptr`的范围之外，资源才会销毁释放。
- 下面的代码阐述了`shared_ptr`的使用

    ```code
    #include<iostream>
    #include<memory>
    using namespace std;  
    class A
    {
    public:
        void show()
        {
            cout<<"A::show()"<<endl;
        }
    };

    int main()
    {
        shared_ptr<A> p1 (new A);
        cout << p1.get() << endl;
        p1->show();
        shared_ptr<A> p2 (p1);
        p2->show();
        cout << p1.get() << endl;
        cout << p2.get() << endl;

        // Returns the number of shared_ptr objects referring to the same managed object.
        cout << p1.use_count() << endl;
        cout << p2.use_count() << endl;

        // Relinquishes ownership of p1 on the object and pointer becomes NULL
        p1.reset();
        cout << p1.get() << endl;
        cout << p2.use_count() << endl;
        cout << p2.get() << endl;

        return 0;
    }
    ```

  - 输出结果如下：

    ```code
    0x1c41c20
    A::show()
    A::show()
    0x1c41c20
    0x1c41c20
    2
    2
    0          // NULL
    1
    0x1c41c20
    ```

## weak_ptr

- `weak_ptr`是`shared_ptr`的拷贝。它可以访问被一个或多个`shared_ptr`实例持有的对象，但是不参与引用计数。`weak_ptr`的存在或销毁对`shared_ptr`及其拷贝没有影响。`weak_ptr`对于打破`shared_ptr`实例之间的循环引用必不可少。
- 相互依赖（`Cyclic Dependency`,`shared_ptr`存在的问题）：考虑一个场景，类 A 和类 B，二者都有指针指向另外一个类。因此，如果有两个`shared_ptr`的指针`ptr_A`和`ptr_B`分别指向 A 和 B的某个对象，总是`ptr_A`持有 B 的对象而且`ptr_B`持有 A 的对象。A 和 B 的对象引用计数一直不会变成 0，A 和 B 的对象都不会被删除。
- 现在把`ptr_A`换成`weak_ptr`，`ptr_A`可以访问 B 的对象但是不会持有该对象。B 对象的引用计数就是 0，可以先释放，之后 A 对象的引用计数变成 0 就可以释放内存。
- 使用`ptr_A`之前需要检查 B 对象的有效性，因为 B 对象可能销毁。
- 什么时候需要用`weak_ptr`？当希望从不同的地方访问对象，且不关心这些引用的删除。但是尝试间接引用该对象的时候需要注意检查对象的有效性。

## reference

- [auto_ptr, unique_ptr, shared_ptr and weak_ptr](https://www.geeksforgeeks.org/auto_ptr-unique_ptr-shared_ptr-weak_ptr-2/)
- [std::auto_ptr to std::unique_ptr](https://stackoverflow.com/questions/3451099/stdauto-ptr-to-stdunique-ptr)
