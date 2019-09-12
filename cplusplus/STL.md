# STL

- [STL](#stl)
  - [介绍](#%e4%bb%8b%e7%bb%8d)
  - [算法](#%e7%ae%97%e6%b3%95)
    - [头文件 algorithm](#%e5%a4%b4%e6%96%87%e4%bb%b6-algorithm)
      - [排序](#%e6%8e%92%e5%ba%8f)
      - [搜索](#%e6%90%9c%e7%b4%a2)
      - [重要的 STL 算法](#%e9%87%8d%e8%a6%81%e7%9a%84-stl-%e7%ae%97%e6%b3%95)
        - [未加工算法](#%e6%9c%aa%e5%8a%a0%e5%b7%a5%e7%ae%97%e6%b3%95)
      - [有用的 Array 算法](#%e6%9c%89%e7%94%a8%e7%9a%84-array-%e7%ae%97%e6%b3%95)
      - [划分操作](#%e5%88%92%e5%88%86%e6%93%8d%e4%bd%9c)
    - [头文件 numeric](#%e5%a4%b4%e6%96%87%e4%bb%b6-numeric)
  - [容器](#%e5%ae%b9%e5%99%a8)
  - [函数](#%e5%87%bd%e6%95%b0)
  - [迭代器](#%e8%bf%ad%e4%bb%a3%e5%99%a8)
  - [参考](#%e5%8f%82%e8%80%83)

## 介绍

- STL(Standard Template Library，标准模板库)是 C++ 模板类集合，提供了统一的编程书籍结构和函数。
- STL 是容器类、算法和迭代器的库，是一个通用的库，组件都是参数化的。
- STL 有 4 个组件：算法、容器、函数和迭代器。

## 算法

- 定义了 STL 的基础性的算法(均为函数模板)，用于给定范围的元素。 C++98 中有 70 个算法模板函数，C++11 增加了 20 个算法模板函数，其中有 5 个定义在 `numeric` 头文件，其他定义在 `algorithm` 中

### 头文件 algorithm

#### 排序

- 函数原型：
  - `template <class RandomAccessIterator>  void sort (RandomAccessIterator first, RandomAccessIterator last);`
  - `template <class RandomAccessIterator, class Compare>  void sort (RandomAccessIterator first, RandomAccessIterator last, Compare comp);`
- 底层使用快排实现。
- 算法复杂度： O(N*lgN)。

```cpp
#include <iostream>
#include <algorithm>

using namespace std;

void show(int a[])
{
    for(int i=0; i<10; ++i)
        cout << a[i] << " ";
    cout << endl;
}

int main()
{
    int a[10]={1, 5, 8, 9, 6, 7, 3, 4, 2, 0};

    cout << "\n The array before sorting is : ";
    show(a);

    sort(a,a+10);

    cout << "\n The array after sorting is : ";
    show(a);

    return 0;
}
```

#### 搜索

- 广泛使用的搜索算法是二分搜索，前提是数组已经排好序。
- 函数原型：
  - `template <class ForwardIterator, class T>  bool binary_search (ForwardIterator first, ForwardIterator last, const T& val);`
  - `template <class ForwardIterator, class T, class Compare> bool binary_search (ForwardIterator first, ForwardIterator last, const T& val, Compare comp);`

```cpp
#include <algorithm>
#include <iostream>

using namespace std;

void show(int a[], int arraysize)
{
    for(int i=0; i<arraysize; ++i)
        cout << a[i] << " ";
    cout << endl;
}

int main()
{
    int a[] = { 1, 5, 8, 9, 6, 7, 3, 4, 2, 0 };
    int asize = sizeof(a) / sizeof(a[0]);
    cout << "The array is : ";
    show(a, asize);

    cout << "Let's say we want to search for 2 in the array" << endl;
    cout << "So, we first sort the array" << endl;
    sort(a, a + asize);
    cout << "The array after sorting is : ";
    show(a, asize);

    cout << "Now, we do the binary search for 2" << endl;
    if(binary_search(a, a + 10, 2))
        cout << "Element found in the array" << endl;
    else
        cout << "Element not found in the array" << endl;

    cout << "Now, say we want to search for 10" << endl;
    if(binary_search(a, a + 10, 10))
        cout << "Element found in the array" << endl;
    else
        cout << "Element not found in the array" << endl;

    return 0;
}
```

#### 重要的 STL 算法

##### 未加工算法

- 排序
  - `template <class RandomAccessIterator> void sort (RandomAccessIterator first, RandomAccessIterator last);`
  - `template <class RandomAccessIterator, class Compare> void sort (RandomAccessIterator first, RandomAccessIterator last, Compare comp);`
- 逆序
  - `template <class BidirectionalIterator> void reverse (BidirectionalIterator first, BidirectionalIterator last);`
- 返回序列中最大值的迭代器
  - `template <class ForwardIterator> ForwardIterator max_element (ForwardIterator first, ForwardIterator last);`
  - `template <class ForwardIterator, class Compare> ForwardIterator max_element (ForwardIterator first, ForwardIterator last, Compare comp);`
- 返回序列中最小值的迭代器
  - `template <class ForwardIterator> ForwardIterator min_element (ForwardIterator first, ForwardIterator last);`
  - `template <class ForwardIterator, class Compare> ForwardIterator min_element (ForwardIterator first, ForwardIterator last, Compare comp);`

#### 有用的 Array 算法

#### 划分操作

### 头文件 numeric

- valarray 类

## 容器

- 容器是一个对象，保存了其他对象或对象元素的集合
- 容器自己管理元素的存储空间，并且提供成员函数来访问元素，直接访问或通过迭代器访问
- 容器类模板
  - 顺序容器
    - array
      - 固定大小数组，顺序连续存储，可使用偏移量访问
      - 大小为 0 是有效的，但是不能间接引用，比如 front，back，data
      - 交换是按顺序交换每个元素，效率低
      - 可以当做 tuple（可以存储不同类型的元素的集合），重载了 get 接口等
      - 访问快，可使用偏移量访问，常数时间
    - vector
      - 大小可变数组，顺序连续存储，可使用偏移量访问
      - 使用动态分配数组存储元素，插入元素时可能需要重新分配数组，将所有元素移到新的数组，效率低
      - 一开始分配额外的存储空间，容量一般不等于实际大小
      - 访问快，和 array 一样，在尾部插入和删除也快
      - 在其他位置插入和删除低效，没有随机访问迭代器
    - deque
      - 双端队列，顺序存储，可在两端增加或减小大小
      - 可用随机访问迭代器直接访问单个元素
      - 存储可以是不连续的块，在容器增加或减小时内存分配效率更高
    - forward_list
      - 顺序存储，在任意位置插入和删除都是常数时间
      - 单向链表，存储位置可以是不同的没有关系的，
      - vs array/vector/deque
        - list 和 forward_list 的插入、删除更有效，对于排序算法也更快（交换更快）
        - list 和 forward_list 没有根据位置直接访问元素的方法，同时每个节点需要额外的存储存储链接的相关信息
        - list 和 forward_list 没有 size 方法，因为很耗时，可以使用 distance 算法（包含在头文件`<iterator>`）计算 begin 和 end 之间的距离，消耗时间是线性的
    - list
      - 双向链表
      - forward_list vs list： 前者只存储一个指向后面对象的链接，后者存储两个链接分别指向前一个和后一个对象，因此两个方向的迭代都比较搞笑，但同时每个节点需要额外的存储，且插入和删除也有额外的时间负载
  - 容器适配器：不完全是容器类，而是依赖某一个容器类提供特定的接口
    - stack
      - 后进先出（LIFO），使用标准的容器（vector/deque/list）类模板实现接口，如果初始化未指定容器类，则使用 deque 实现相关接口
      - 如`std::stack<int, std::vector<int> > mystack`使用 vector 实现的空的 stack
    - queue
      - 先进先出（FIFO）队列，使用标准的容器（deque/list）类模板实现接口，默认使用 deque
      - 如`std::queue<int, std::list<int> > myqueue`使用 list 实现的空的 queue
    - priority_queue
      - 依据严格的弱排序（strict weak ordering）标准第一个元素总是最大的元素
      - 使用标准的容器（vector/deque）类模板实现接口，，默认是 vector
  - 关联容器
    - set
      - 保存的值都是唯一的，不能修改，只能插入或删除，key 和 value 相同
      - 存储的元素总是依照严格的弱排序标准排序，通过内部的比较对象
      - 在通过 key 访问单个元素的时候通常比 unordered_set 慢，但是可以访问有序集合的一个子集
      - 通常实现为二分搜索树
    - multiset
      - 可以存储相同值的元素
      - 在通过 key 访问的那个元素的时候比 unordered_multiset 慢
    - map
      - 关联容器，存储的对象包括一个 key 和映射的 value
      - 通过 key 排序和标记唯一元素，存储的元素总是依照严格的弱排序标准排序，通过内部的比较对象
      - 在通过 key 访问单个元素的时候通常比 unordered_map 慢，但是可以访问有序集合的一个子集
      - 通常实现为二分搜索树
    - multimap
  - 无序关联容器
    - unordered_set
    - unordered_multiset
    - unordered_map
    - unordered_multimap

## 函数

## 迭代器

## 参考

- [C++ STL Tutorial](https://www.geeksforgeeks.org/cpp-stl-tutorial/)
- [The C++ Standard Template Library (STL)](https://www.geeksforgeeks.org/the-c-standard-template-library-stl/)
- [C++/STL/Algorithm](https://zh.wikibooks.org/wiki/C%2B%2B/STL/Algorithm)
