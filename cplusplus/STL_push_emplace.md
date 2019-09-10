# STL 的 push 和 emplace

## 前言

- 下面的说明以 STL 的 queue 为实例，其他 STL 还有 push_back/emplace_back 等，各自的影响不尽相同
  - [deque](http://www.cplusplus.com/reference/deque/deque/): emplace/emplace_back/emplace_front/push_back/push_front
  - [forward_list](http://www.cplusplus.com/reference/forward_list/forward_list/): emplace_after/emplace_front/push_front
  - [list](http://www.cplusplus.com/reference/list/list/): emplace/emplace_back/emplace_front/push_back/push_front
  - [map](http://www.cplusplus.com/reference/map/map/): emplace/emplace_hint
  - [queue](http://www.cplusplus.com/reference/queue/queue/): emplace/push
  - [set](http://www.cplusplus.com/reference/set/set/): emplace/emplace_hint
  - [stack](http://www.cplusplus.com/reference/stack/stack/): emplace/push
  - [vector](http://www.cplusplus.com/reference/vector/vector/): emplace/emplace_back/push_back

## std::queue::emplace

- 参考 [std::queue::emplace](http://www.cplusplus.com/reference/queue/queue/emplace/)
- **函数原型**： `template <class... Args> void emplace (Args&&... args);`
  - args：被传递作为新元素构造函数的参数
- **功能**：构造并插入一个元素。增加新元素到 queue 的末尾，即当前最后一个元素之后。将传入的参数作为新元素的构造函数的参数。
- 底层容器对象调用 [emplace_back](http://www.cplusplus.com/reference/deque/deque/emplace_back/)，并传递参数。

### std::deque::emplace_back

- 参考 [std::deque::emplace_back](http://www.cplusplus.com/reference/deque/deque/emplace_back/)
- **函数原型**：`template <class... Args> void emplace_back (Args&&... args);`
  - args：被传递作为新元素构造函数的参数
- **功能**：构造并在末尾插入一个元素。增加新元素到 deque 的末尾，即当前最后一个元素之后。将传入的参数作为新元素的构造函数的参数。
- 这个操作将容器大小高效增加 1
- 元素通过调用 [std::allocator_traits::construct](http://www.cplusplus.com/reference/memory/allocator_traits/construct/) 和参数构造。
  - 新元素的存储通过 `allocator_traits<allocator_type>::construct()` 分配，失败时可能会抛异常(对于默认的 [std::allocator](http://www.cplusplus.com/reference/memory/allocator/)，分配失败会抛 bad_alloc 异常)。
- **迭代器有效性**：容器相关的所有迭代器无效，但是指针和引用是有效的，和调用函数之前指向的元素相同。
- **异常安全性**：强保证。如果抛出异常，则容器没有改变。如果 `std::allocator_traits::construct` 对于传递的参数不支持，会导致未定义的行为。

#### std::allocator_traits::construct

- 参考 [std::allocator_traits::construct](http://www.cplusplus.com/reference/memory/allocator_traits/construct/)
- 静态成员函数
- **函数原型**：`template <class T, class... Args> static void construct (allocator_type alloc, T* p, Args&&... args );`
- **功能**：构造一个元素。在指针 p 指向的位置传递参数给构造函数构造一个元素对象。
- **注意**：对象被 in-place 构造，而不用为元素分配存储。如果不可行，则调用 `::new (static_cast<void*>(p)) T (forward<Args>(args)...)`

#### std::allocator

- 参考 [std::allocator](http://www.cplusplus.com/reference/memory/allocator/)
- **函数原型**：`template <class T> class allocator;`
  - T：对象分配的元素类型
- **功能**：默认分配器。
  - 分配器：定义内存模型的类，被标准库的一些部分使用，大多数情况是被 STL 容器使用。
  - allocator 是默认分配器模板，这是所有标准容器未指定最后一个(可选的)模板参数时会使用的分配器，也是标准库中唯一一个预定义的分配器。

#### std::deque::allocator

- 参考[std::deque::get_allocator](http://www.cplusplus.com/reference/deque/deque/get_allocator/)
- **函数原型**：`allocator_type get_allocator() const noexcept;`
  - allocator_type：是容器使用的分配器的类型
- **功能**：返回和 deque 对象相关的分配器对象的拷贝。
- **异常安全性**：保证没有异常。拷贝默认分配器的任何实例也保存不会抛异常

## std::queue::push

- 参考 [std::queue::push](http://www.cplusplus.com/reference/queue/queue/push/)
- **函数原型**：`void push (const value_type& val);`或`void push (value_type&& val);`
  - val：经过初始化的新插入元素的值
  - value_type：是容器元素的类型
- **功能**：插入一个新元素到 queue 末尾，即当前最后一个元素之后。新元素的内容被初始化为 `val`。
- 底层容器对象调用 [push_back](http://www.cplusplus.com/reference/deque/deque/push_back/)

### std::deque::push_back

- 参考 [std::deque::push_back](http://www.cplusplus.com/reference/deque/deque/push_back/)
- **函数原型**：`void push_back (const value_type& val);`或`void push_back (value_type&& val);`
  - val：将要拷贝或移动给新对象的值
  - value_type：是容器元素的类型
- 新元素的存储通过容器的 [allocator](http://www.cplusplus.com/reference/deque/deque/get_allocator/) 分配，失败时可能会抛异常(对于默认的[std::allocator](http://www.cplusplus.com/reference/memory/allocator/)，分配失败会抛 bad_alloc 异常)
- **迭代器有效性**：容器相关的所有迭代器无效，但是指针和引用是有效的，和调用函数之前指向的元素相同。
- **异常安全性**：强保证。如果抛出异常，则容器没有改变。如果 `std::allocator_traits::construct` 对于传递的参数不支持，会导致未定义的行为。

## vector 的 emplace_back 和 push_back

### 产生时间

- push_back 是标准 C++ 创建之初就有的；emplace_back 是在 C++11 特性前提下增加的

### 类型的构造函数不止 1 个

- 当类型的构造函数不止 1 个时：push_back 只接收类型的对象，emplace_back 接收类型构造函数的参数
- C++ 11 支持从参数构造对象，因此当类型的构造函数参数只有一个时，push_back 可以传入构造函数参数，C++ 11 会构造对象，并传递对象给容器

```cpp
class OneParam
{
    int i;
public:
    OneParam(int ii):i(ii) { } //constructor
    ~OneParam( ) { }

    int get() const { return i; }
};

class MoreThanOneParam
{
    int i;
    string st;
public:
    MoreThanOneParam(int ii, string s):i(ii) , st(s) { }
    ~MoreThanOneParam( ) { }

    int getInt() const { return i; }
    string getString() const { return st; }
};

int main2( )
{
    vector<OneParam> vec1={ 21 , 45 };
    vec1.push_back( OneParam(34) ); //Appending OneParam object by passing OneParam object
    vec1.push_back( 901 ); //Appending OneParam object but int data is passed,work fine
    vec1.emplace_back( OneParam(7889) ); //work fine
    vec1.emplace_back( 4156 ); //work fine
    //21; 45; 34; 901; 7889; 4156;
    for( auto elem:vec1 ) { cout << elem.get() << "; "; } //21; 45; 34; 901; 7889; 4156;
    cout << endl;

    vector<MoreThanOneParam> vec2={ {21,"String"} , MoreThanOneParam{45 , "tinger"} };
    vec2.push_back( MoreThanOneParam(34 , "Happy" ) ); //Appending MoreThanOneParam object
//    vec2.push_back( 901 , "Doer" ); //Error!!
    vec2.emplace_back( MoreThanOneParam(78 , "Gomu gomu" )); //work fine
    vec2.emplace_back( 41 , "Shanks" ); //work fine
    //21 String; 45 tinger; 34 Happy; 78 Gomu gomu; 41 Shanks;
    for( auto elem:vec2 ) { cout << elem.getInt( ) << " " << elem.getString( ) << "; "; }
    cout << endl;

    cin.get( );
    return 0;
}
```

### 效率

- 这里的效率指的是：代码工作更快，生成的负载更小
- 当 vector 的类型是内置类型时，push_back 和 emplace_back 没有区别
- 当 vector 的类型是用户自定义类型时，emplace_back 比 push_back 更高效
  - 当尝试直接添加对象 (在对象被创建之前) 到 vector，使用 push_back 的流程是：先创建一个临时对象
    - 调用构造函数创建临时对象
    - 在 vector 中创建临时对象的拷贝
    - 拷贝对象完成之后，调用析构函数销毁临时对象
  - 使用 emplace_back 将不会创建临时对象，而是直接在 vector 中创建对象。因此提高了性能

## 其他参考

- [C++ difference between emplace_back and push_back function](http://candcplusplus.com/c-difference-between-emplace_back-and-push_back-function)
- [https://stackoverflow.com/questions/4303513/push-back-vs-emplace-back](https://stackoverflow.com/questions/4303513/push-back-vs-emplace-back)
- [vector::emplace_back in C++ STL](https://www.geeksforgeeks.org/vectoremplace_back-c-stl/)
- [C++11 中的 emplace](http://blog.guorongfei.com/2016/03/16/cppx-stdlib-empalce/)
