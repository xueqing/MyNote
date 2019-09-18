# STL

- [STL](#stl)
  - [介绍](#%e4%bb%8b%e7%bb%8d)
  - [算法](#%e7%ae%97%e6%b3%95)
    - [头文件 algorithm](#%e5%a4%b4%e6%96%87%e4%bb%b6-algorithm)
      - [排序](#%e6%8e%92%e5%ba%8f)
      - [搜索](#%e6%90%9c%e7%b4%a2)
      - [重要的 STL 算法](#%e9%87%8d%e8%a6%81%e7%9a%84-stl-%e7%ae%97%e6%b3%95)
        - [未加工算法](#%e6%9c%aa%e5%8a%a0%e5%b7%a5%e7%ae%97%e6%b3%95)
        - [加工算法](#%e5%8a%a0%e5%b7%a5%e7%ae%97%e6%b3%95)
      - [有用的 Array 算法](#%e6%9c%89%e7%94%a8%e7%9a%84-array-%e7%ae%97%e6%b3%95)
      - [划分操作](#%e5%88%92%e5%88%86%e6%93%8d%e4%bd%9c)
    - [头文件 valarray](#%e5%a4%b4%e6%96%87%e4%bb%b6-valarray)
  - [容器](#%e5%ae%b9%e5%99%a8)
    - [顺序容器](#%e9%a1%ba%e5%ba%8f%e5%ae%b9%e5%99%a8)
      - [array](#array)
      - [vector](#vector)
      - [deque](#deque)
      - [forward_list](#forwardlist)
      - [list](#list)
    - [容器适配器](#%e5%ae%b9%e5%99%a8%e9%80%82%e9%85%8d%e5%99%a8)
      - [stack](#stack)
      - [queue](#queue)
      - [priority_queue](#priorityqueue)
    - [关联容器](#%e5%85%b3%e8%81%94%e5%ae%b9%e5%99%a8)
      - [set](#set)
      - [multiset](#multiset)
      - [map](#map)
      - [multimap](#multimap)
    - [无序关联容器](#%e6%97%a0%e5%ba%8f%e5%85%b3%e8%81%94%e5%ae%b9%e5%99%a8)
      - [unordered_set](#unorderedset)
      - [unordered_multiset](#unorderedmultiset)
      - [unordered_map](#unorderedmap)
      - [unordered_multimap](#unorderedmultimap)
  - [仿函数](#%e4%bb%bf%e5%87%bd%e6%95%b0)
  - [迭代器](#%e8%bf%ad%e4%bb%a3%e5%99%a8)
  - [参考](#%e5%8f%82%e8%80%83)

## 介绍

- STL(Standard Template Library，标准模板库)是 C++ 模板类集合，提供了统一的编程书籍结构和函数。
- STL 是容器类、算法和迭代器的库，是一个通用的库，组件都是参数化的。
- STL 有 4 个组件：算法、容器、函数和迭代器。

## 算法

- 定义了 STL 的基础性的算法(均为函数模板)，用于给定范围的元素。 C++98 中有 70 个算法模板函数，C++11 增加了 20 个算法模板函数，其中有 5 个定义在 `numeric` 头文件，其他定义在 `algorithm` 中
- `numeric` 头文件包含的算法模板函数
  - accumulate：累加序列值
  - adjacent_difference：计算相邻两项的差值
  - inner_product：计算输入序列的内积
  - partial_sum：计算序列的部分累加值
  - iota：保存增加的连续值序列

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
- 计算序列元素的累加值
  - `template <class InputIterator, class T> T accumulate (InputIterator first, InputIterator last, T init);`
  - `template <class InputIterator, class T, class BinaryOperation> T accumulate (InputIterator first, InputIterator last, T init, BinaryOperation binary_op);`

```cpp
#include <algorithm>
#include <iostream>
#include <vector>
#include <numeric> //For accumulate operation

using namespace std;

int main()
{
    int arr[] = {10, 20, 5, 23 ,42 , 15};
    int n = sizeof(arr)/sizeof(arr[0]);

    vector<int> vect(arr, arr+n);
    cout << "Vector is: ";
    for(int i=0; i<n; i++) cout << vect[i] << " ";

    sort(vect.begin(), vect.end());
    cout << "\nVector after sorting is: ";
    for(int i=0; i<n; i++) cout << vect[i] << " ";

    reverse(vect.begin(), vect.end());
    cout << "\nVector after reversing is: ";
    for(int i=0; i<6; i++) cout << vect[i] << " ";

    cout << "\nMaximum element of vector is: ";
    cout << *max_element(vect.begin(), vect.end());

    cout << "\nMinimum element of vector is: ";
    cout << *min_element(vect.begin(), vect.end());

    cout << "\nThe summation of vector elements is: ";
    cout << accumulate(vect.begin(), vect.end(), 0);
    cout<< endl;

    return 0;
}
```

- 计算给定元素出现的次数
  - `template <class InputIterator, class T> typename iterator_traits<InputIterator>::difference_type count (InputIterator first, InputIterator last, const T& val);`
- 返回指向第一个等于给定元素的指针
  - `template <class InputIterator, class T> InputIterator find (InputIterator first, InputIterator last, const T& val);`

```cpp
#include <algorithm>
#include <iostream>
#include <vector>

using namespace std;

int main()
{
    int arr[] = {10, 20, 5, 23 ,42, 20, 15};
    int n = sizeof(arr)/sizeof(arr[0]);
    vector<int> vect(arr, arr+n);

    cout << "Occurrences of 20 in vector : ";
    cout << count(vect.begin(), vect.end(), 20) << endl;

    find(vect.begin(), vect.end(), 5) != vect.end()?
        cout << "Element 5 found\n" : cout << "Element 5 not found\n";

    return 0;
}
```

- 二分查找指定元素
  - `template <class ForwardIterator, class T> bool binary_search (ForwardIterator first, ForwardIterator last, const T& val);`
  - `template <class ForwardIterator, class T, class Compare> bool binary_search (ForwardIterator first, ForwardIterator last, const T& val, Compare comp);`
- 返回指向第一个不小于指定元素的迭代器(序列有序)
  - `template <class ForwardIterator, class T> ForwardIterator lower_bound (ForwardIterator first, ForwardIterator last, const T& val);`
  - `template <class ForwardIterator, class T, class Compare> ForwardIterator lower_bound (ForwardIterator first, ForwardIterator last, const T& val, Compare comp);`
- 返回指向第一个大于指定元素的迭代器(序列有序)
  - `template <class ForwardIterator, class T> ForwardIterator upper_bound (ForwardIterator first, ForwardIterator last, const T& val);`
  - `template <class ForwardIterator, class T, class Compare> ForwardIterator upper_bound (ForwardIterator first, ForwardIterator last, const T& val, Compare comp);`

```cpp
#include <algorithm>
#include <iostream>
#include <vector>

using namespace std;

int main()
{
    int arr[] = {5, 10, 15, 20, 20, 23, 42, 45};
    int n = sizeof(arr)/sizeof(arr[0]);

    vector<int> vect(arr, arr+n);
    sort(vect.begin(), vect.end());
    for_each(vect.begin(), vect.end(), [](int i) {cout << i << " ";});
    cout << endl;

    auto q = lower_bound(vect.begin(), vect.end(), 20);
    cout << "The lower bound for 20 is at position: ";
    cout << q-vect.begin() << endl;

    auto p = upper_bound(vect.begin(), vect.end(), 20);
    cout << "The upper bound for 20 is at position: ";
    cout << p-vect.begin() << endl;

    return 0;
}
```

##### 加工算法

- 过滤连续相等的元素
  - `template <class ForwardIterator> ForwardIterator unique (ForwardIterator first, ForwardIterator last);`
  - `template <class ForwardIterator, class BinaryPredicate> ForwardIterator unique (ForwardIterator first, ForwardIterator last, BinaryPredicate pred);`

```cpp
#include <algorithm>
#include <iostream>
#include <vector>

using namespace std;

int main()
{
    int arr[] = {5, 10, 15, 20, 20, 23, 42, 45};
    int n = sizeof(arr)/sizeof(arr[0]);

    vector<int> vect(arr, arr+n);
    for_each(vect.begin(), vect.end(), [](int i) {cout << i << " ";});

    vect.erase(vect.begin()+1);
    cout << "\nVector after erasing the second element: ";
    for_each(vect.begin(), vect.end(), [](int i) {cout << i << " ";});

    sort(vect.begin(), vect.end());

    cout << "\nVector before removing duplicate occurrences: ";
    for_each(vect.begin(), vect.end(), [](int i) {cout << i << " ";});

    vect.erase(unique(vect.begin(),vect.end()),vect.end());
    cout << "\nVector after deleting duplicates: ";
    for_each(vect.begin(), vect.end(), [](int i) {cout << i << " ";});

    return 0;
}
```

- 返回下一个置换
  - `template <class BidirectionalIterator> bool next_permutation (BidirectionalIterator first, BidirectionalIterator last);`
  - `template <class BidirectionalIterator, class Compare> bool next_permutation (BidirectionalIterator first, BidirectionalIterator last, Compare comp);`
- 返回前一个置换
  - `template <class BidirectionalIterator> bool prev_permutation (BidirectionalIterator first, BidirectionalIterator last );`
  - `template <class BidirectionalIterator, class Compare> bool prev_permutation (BidirectionalIterator first, BidirectionalIterator last, Compare comp);`

```cpp
#include <algorithm>
#include <iostream>
#include <vector>

using namespace std;

int main()
{
    int arr[] = {5, 10, 15, 20, 20, 23, 42, 45};
    int n = sizeof(arr)/sizeof(arr[0]);

    vector<int> vect(arr, arr+n);
    cout << "Given Vector is: ";
    for_each(vect.begin(), vect.end(), [](int i) {cout << i << " ";});

    next_permutation(vect.begin(), vect.end());
    cout << "\nVector after performing next permutation: ";
    for_each(vect.begin(), vect.end(), [](int i) {cout << i << " ";});

    prev_permutation(vect.begin(), vect.end());
    cout << "\nVector after performing prev permutation: ";
    for_each(vect.begin(), vect.end(), [](int i) {cout << i << " ";});

    return 0;
}
```

- 计算迭代器之间的距离。用于查找下标
  - 包含在头文件 `iterator`
  - `template<class InputIterator> typename iterator_traits<InputIterator>::difference_type distance (InputIterator first, InputIterator last);`

```cpp
#include <algorithm>
#include <iostream>
#include <vector>

using namespace std;

int main()
{
    int arr[] = {5, 10, 15, 20, 20, 23, 42, 45};
    int n = sizeof(arr)/sizeof(arr[0]);
    vector<int> vect(arr, arr+n);

    cout << "Given Vector is: ";
    for_each(vect.begin(), vect.end(), [](int i) {cout << i << " ";});
    cout << "\nDistance between first to max element: " << distance(vect.begin(), max_element(vect.begin(), vect.end())) << endl;
    return 0;
}
```

#### 有用的 Array 算法

- 以下算法在 C++11 开始支持
- 测试序列是否都满足某个条件
  - `template <class InputIterator, class UnaryPredicate> bool all_of (InputIterator first, InputIterator last, UnaryPredicate pred);`
- 测试序列是否存在一个元素满足某个条件
  - `template <class InputIterator, class UnaryPredicate> bool any_of (InputIterator first, InputIterator last, UnaryPredicate pred);`
- 测试序列是否都不满足某个条件
  - `template <class InputIterator, class UnaryPredicate> bool none_of (InputIterator first, InputIterator last, UnaryPredicate pred);`
- 拷贝序列元素
  - `template <class InputIterator, class Size, class OutputIterator> OutputIterator copy_n (InputIterator first, Size n, OutputIterator result);`
- 存储增加的序列
  - `template <class ForwardIterator, class T> void iota (ForwardIterator first, ForwardIterator last, T val);`

```cpp
#include <algorithm>
#include <numeric>
#include <iostream>

using namespace std;

int main()
{
    int arr1[] = {1, 2, 3, 4, 5, -6};
    all_of(arr1, arr1+6, [](int x) {return x>0;}) ?
                cout << "All are positive elments\n" : cout << "Not all are positive elments\n";
    any_of(arr1, arr1+6, [](int x) {return x<0;}) ?
                cout << "There exists a negative element\n" : cout << "All are positive elments\n";

    int arr2[] = {1, 2, 3, 4, 5, 6};
    none_of(arr2, arr2+6, [](int x) {return x<0;}) ?
                cout << "No negative elements\n" : cout << "There exists a negative element\n";

    int arrc[6];
    copy_n(arr2, 6, arrc);
    cout << "Copyed array: ";
    for_each(arrc, arrc+6, [](int i) {cout << i << " ";});
    cout << endl;

    int arr3[6] = {0};
    iota(arr3, arr3+6, 20);
    cout << "Assigned array: ";
    for_each(arr3, arr3+6, [](int i) {cout << i << " ";});
    cout << endl;

    return 0;
}
```

#### 划分操作

- 根据条件重排序列，返回第一个不满足条件的迭代器
  - `template <class ForwardIterator, class UnaryPredicate> ForwardIterator partition (ForwardIterator first, ForwardIterator last, UnaryPredicate pred);`
- 根据条件重排序列，且两组元素内部的相对顺序保持不变。一般是用临时缓冲区实现
  - `template <class BidirectionalIterator, class UnaryPredicate> BidirectionalIterator stable_partition (BidirectionalIterator first, BidirectionalIterator last, UnaryPredicate pred);`
- 判断序列是否是根据条件划分的
  - `template <class InputIterator, class UnaryPredicate> bool is_partitioned (InputIterator first, InputIterator last, UnaryPredicate pred);`
- 输入队列已经是分割过的，二分查找分界点
  - `template <class ForwardIterator, class UnaryPredicate> ForwardIterator partition_point (ForwardIterator first, ForwardIterator last, UnaryPredicate pred);`
- 输入序列中满足条件和不满足条件的分别拷贝到两个序列中
  - `template <class InputIterator, class OutputIterator1, class OutputIterator2, class UnaryPredicate pred> pair<OutputIterator1,OutputIterator2> partition_copy (InputIterator first, InputIterator last, OutputIterator1 result_true, OutputIterator2 result_false, UnaryPredicate pred);`

```cpp
#include <algorithm>
#include <vector>
#include <iostream>

using namespace std;

int main()
{
    vector<int> vect1 = { 2, 1, 5, 6, 8, 7 };

    cout << "The vector is: ";
    for_each(vect1.begin(), vect1.end(), [](int i) {cout << i << " ";});

    is_partitioned(vect1.begin(), vect1.end(), [](int i) {return i%2==0;}) ?
                cout << "\nVector is partitioned" : cout << "\nVector is not partitioned";

    partition(vect1.begin(), vect1.end(), [](int i){return i%2==0;});
    cout << "\nThe partitioned vector is: ";
    for_each(vect1.begin(), vect1.end(), [](int i) {cout << i << " ";});

    is_partitioned(vect1.begin(), vect1.end(), [](int i) {return i%2==0;}) ?
                cout << "\nNow, vector is partitioned after partition operation":
                        cout << "\nVector is still not partitioned after partition operation";

    vector<int> vect2 = { 2, 1, 5, 6, 8, 7 };
    cout << "\n\nThe vector is: ";
    for_each(vect2.begin(), vect2.end(), [](int i) {cout << i << " ";});

    stable_partition(vect2.begin(), vect2.end(), [](int i) {return i%2==0;});
    cout << "\nThe stable partitioned vector is: ";
    for_each(vect2.begin(), vect2.end(), [](int i) {cout << i << " ";});

    auto it = partition_point(vect2.begin(), vect2.end(), [](int i) {return i%2==0;});
    cout << "\nBefore the partition point: ";
    for_each(vect2.begin(), it, [](int i) {cout << i << " ";});
    cout << "\nAfter the partition point: ";
    for_each(it, vect2.end(), [](int i) {cout << i << " ";});

    vector<int> vect3 = { 2, 1, 5, 6, 8, 7 };
    cout << "\n\nThe vector is: ";
    for_each(vect3.begin(), vect3.end(), [](int i) {cout << i << " ";});

    vector<int> vecteven, vectodd;
    int n = count_if(vect3.begin(), vect3.end(), [](int i) {return i%2==0;});
    vecteven.resize(n);
    vectodd.resize(vect3.size()-n);

    partition_copy(vect3.begin(), vect3.end(), vecteven.begin(),
                   vectodd.begin(), [](int i) {return i%2==0;});

    cout << "\nThe elements that return true for condition are : ";
    for_each(vecteven.begin(), vecteven.end(), [](int i) {cout << i << " ";});
    cout << "\nThe elements that return false for condition are : ";
    for_each(vectodd.begin(), vectodd.end(), [](int i) {cout << i << " ";});
    cout << endl;

    return 0;
}
```

### 头文件 valarray

- valarray 类：C++98 引入的特殊容器，用于保存和提供对 array 的高效算术操作
- 应用操作到所有的元素，返回一个新的 valarray
  - `valarray apply (T func(T)) const;`
  - `valarray apply (T func(const T&)) const;`
- 返回所有元素的和
  - `T sum() const;`
- 返回元素的最小值
  - `T min() const;`
- 返回元素的最大值
  - `T max() const;`
- 将 valarray 的元素移位，返回新的 valarray。如果参数为正数，左移；否则右移
  - `valarray shift (int n) const;`
- 将 valarray 的元素循环移位，返回新的 valarray。如果参数为正数，循环左移；否则循环右移
  - `valarray cshift (int n) const;`
- 和另外一个 valarray 交换
  - `void swap (valarray& x) noexcept;`

```cpp
#include <valarray>
#include <iostream>

using namespace std;

int main()
{
    valarray<int> varr1 = { 10, 2, 20, 1, 30 };
    cout << "The varr1 is: ";
    for_each(begin(varr1), end(varr1), [](int i) {cout << i << " ";});
    cout << "\nThe sum of varr1 is: " << varr1.sum();
    cout << "\nThe max of varr1 is: " << varr1.max();
    cout << "\nThe min of varr1 is: " << varr1.min();

    valarray<int> varr2;
    varr2 = varr1.apply([](int i){return i=i+5;});
    cout << "\nThe varr2 (varr1 add 5 for each element) is: ";
    for_each(begin(varr2), end(varr2), [](int i) {cout << i << " ";});

    valarray<int> varr3;
    varr3 = varr1.shift(2);
    cout << "\nThe varr3 (varr1 shift 2) is: ";
    for_each(begin(varr3), end(varr3), [](int i) {cout << i << " ";});

    varr3 = varr1.shift(-2);
    cout << "\nThe varr3 (varr1 shift -2) is: ";
    for_each(begin(varr3), end(varr3), [](int i) {cout << i << " ";});

    varr3 = varr1.cshift(2);
    cout << "\nThe varr3 (varr1 cshift 2) is: ";
    for_each(begin(varr3), end(varr3), [](int i) {cout << i << " ";});

    varr3 = varr1.cshift(-2);
    cout << "\nThe varr3 (varr1 cshift -2) is: ";
    for_each(begin(varr3), end(varr3), [](int i) {cout << i << " ";});

    valarray<int> varr4 = {2, 4, 6, 8};
    cout << "\nThe varr4 is: ";
    for_each(begin(varr4), end(varr4), [](int i) {cout << i << " ";});

    varr1.swap(varr4);
    cout << "\nThe varr4 after swap with varr1 is: ";
    for_each(begin(varr4), end(varr4), [](int i) {cout << i << " ";});

    cout << "\n";
    return 0;
}
```

## 容器

- 容器是一个对象，保存了其他对象或对象元素的集合
- 容器自己管理元素的存储空间，并且提供成员函数来访问元素，直接访问或通过迭代器访问
- 容器类模板：包括顺序容器、容器适配器、关联容器和无序关联容器

### 顺序容器

- 实现的数据结构可以按顺序访问

#### array

- C++11 引入，替换 C 风格数组。相比 C 风格数组的优点包括
  - array 知道自己的大小，因此传递参数时不需要单独传递 array 的大小
  - C 风格的数组会有退化成指针的风险，但是 array 不会
  - 相比 C 风格数组，array 更加高效、轻量和可靠
- 方法
  - `at`：
  - `get`：不是 array 的类成员函数，而是重载 tuple 类的函数
  - `[]`: 类似于 C 风格的数组访问
  - `front/back`：返回第一个/最后一个元素
  - `size/max_size`：返回 array 的元素数目/可以承载的最大元素数目。二者返回值相同
  - `swap`：和另外一个 array 交换元素
  - `empty`：array 的大小是否是 0
  - `fill`：使用指定值填充正哥 array
- 固定大小数组，顺序连续存储，可使用偏移量访问
- 大小为 0 是有效的，但是不能间接引用，比如 front，back，data
- 交换是按顺序交换每个元素，效率低
- 可以当做 tuple（可以存储不同类型的元素的集合），重载了 get 接口等
- 访问快，可使用偏移量访问，常数时间

#### vector

- 大小可变数组，顺序连续存储，可使用偏移量访问
- 一开始分配额外的存储空间，容量一般不等于实际大小
- 使用动态分配数组存储元素，插入元素时可能需要重新分配数组，将所有元素移到新的数组，效率低
- 访问快，和 array 一样，在尾部插入和删除也快。删除元素是常数时间，不会重新调整大小
- 在其他位置插入和删除低效，需要线性时间。没有随机访问迭代器

#### deque

- 双端队列，顺序存储，可在两端增加或减小大小
- 可用随机访问迭代器直接访问单个元素
- vs vector
  - 存储可以是不连续的块，在容器增加或减小时内存分配效率更高

#### forward_list

- C++11 引入
- 顺序存储，在任意位置插入和删除都是常数时间
- 单向链表，存储位置可以是不同的没有关系的
- vs array/vector/deque
  - list 和 forward_list 的插入、删除更有效，对于排序算法也更快（交换更快）
  - list 和 forward_list 没有根据位置直接访问元素的方法，同时每个节点需要额外的存储存储链接的相关信息
  - list 和 forward_list 遍历较慢
  - list 和 forward_list 没有 size 方法，因为很耗时，可以使用 distance 算法（包含在头文件`<iterator>`）计算 begin 和 end 之间的距离，消耗时间是线性的

#### list

- 双向链表
- forward_list vs list： 前者只存储一个指向后面对象的链接，后者存储两个链接分别指向前一个和后一个对象，因此两个方向的迭代都比较搞笑，但同时每个节点需要额外的存储，且插入和删除也有额外的时间负载

### 容器适配器

- 不完全是容器类，而是依赖某一个容器类提供特定的接口，封装之后提供不同于顺序容器的接口

#### stack

- 后进先出（LIFO），使用标准的容器（vector/deque/list）类模板实现接口，如果初始化未指定容器类，则使用 deque 实现相关接口
- 如`std::stack<int, std::vector<int> > mystack`使用 vector 实现的空的 stack

#### queue

- 先进先出（FIFO）队列，使用标准的容器（deque/list）类模板实现接口，默认使用 deque
- 如`std::queue<int, std::list<int> > myqueue`使用 list 实现的空的 queue

#### priority_queue

- 依据严格的弱排序（strict weak ordering）标准第一个元素总是最大的元素，所有元素是非增序的
- 使用标准的容器（vector/deque）类模板实现接口，，默认是 vector
- C++ 默认为 priority_queue 创建最大堆

```cpp
#include <iostream>
#include <queue>

using namespace std;

void showpq(priority_queue<int> &gq)
{
    priority_queue<int> g = gq;
    while (!g.empty())
    {
        cout << " " << g.top();
        g.pop();
    }
    cout << endl;
}

int main ()
{
    priority_queue<int> gquiz;
    gquiz.push(10);
    gquiz.push(30);
    gquiz.push(20);
    gquiz.push(5);
    gquiz.push(1);

    cout << "The priority queue gquiz is: ";
    showpq(gquiz);

    cout << "gquiz.size(): " << gquiz.size() << endl;
    cout << "gquiz.top(): " << gquiz.top() << endl;

    gquiz.pop();
    cout << "after gquiz.pop(): ";
    showpq(gquiz);

    return 0;
}
```

- 为 priority_queue 创建最小堆 `priority_queue<int, vector<int>, greater<int>> g=gq;`
  - 下面的语法难记，因此对于数字的值，可以给每个元素乘以 -1，然后使用最大值堆达到最小值堆的效果

```cpp
#include <iostream>
#include <queue>

using namespace std;

void showpq(priority_queue<int, vector<int>, greater<int>> &gq)
{
    priority_queue<int, vector<int>, greater<int>> g = gq;
    while(!g.empty())
    {
        cout << " " << g.top();
        g.pop();
    }
    cout << endl;
}

int main ()
{
    priority_queue<int, vector<int>, greater<int>> gquiz;
    gquiz.push(10);
    gquiz.push(30);
    gquiz.push(20);
    gquiz.push(5);
    gquiz.push(1);

    cout << "The priority queue gquiz is: ";
    showpq(gquiz);

    cout << "gquiz.size(): " << gquiz.size() << endl;
    cout << "gquiz.top(): " << gquiz.top() << endl;

    gquiz.pop();
    cout << "after gquiz.pop(): ";
    showpq(gquiz);

    return 0;
}
```

### 关联容器

- 实现排好序的数据结构，可以达到快速查询的时间复杂度 O(logn)

#### set

- 保存的值都是唯一的，不能修改，只能插入或删除，key 和 value 相同
- 存储的元素总是依照严格的弱排序标准排序，通过内部的比较对象
- 在通过 key 访问单个元素的时候通常比 unordered_set 慢，但是可以访问有序集合的一个子集
- 通常实现为二分搜索树

#### multiset

- 可以存储相同值的元素
- 在通过 key 访问的那个元素的时候比 unordered_multiset 慢

#### map

- 关联容器，存储的对象包括一个 key 和映射的 value
- 通过 key 排序和标记唯一元素，存储的元素总是依照严格的弱排序标准排序，通过内部的比较对象
- 在通过 key 访问单个元素的时候通常比 unordered_map 慢，但是可以访问有序集合的一个子集
- 通常实现为二分搜索树

#### multimap

### 无序关联容器

- 实现无序数据结构，可以快速查询

#### unordered_set

#### unordered_multiset

#### unordered_map

#### unordered_multimap

## 仿函数

## 迭代器

## 参考

- [C++ STL Tutorial](https://www.geeksforgeeks.org/cpp-stl-tutorial/)
- [The C++ Standard Template Library (STL)](https://www.geeksforgeeks.org/the-c-standard-template-library-stl/)
- [C++/STL/Algorithm](https://zh.wikibooks.org/wiki/C%2B%2B/STL/Algorithm)
- [C++/Numeric](https://zh.wikibooks.org/wiki/C%2B%2B/Numeric)
