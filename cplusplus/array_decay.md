# 数组退化问题

## 数组退化

- 类型和纬度丢失就是数组退化。通常发生在通过值或指针传递数组。这种情况下，数组发送的是它的首地址，因此数组的大小不是原始大小，而是首地址在内存中占用的大小。
- 下面的代码中，实际数组有 7 个 int 元素，因此大小是 28。但是调用时传递值和指针，数组退化成指针，打印的是 1 个指针的大小

```cpp
#include <iostream>

using namespace std;

void decayByPassVal(int *p)
{
    cout << "Modified size of array by passing by value: " << sizeof(p) << endl;
}

void decayByPassPointer(int (*p)[7])
{
    cout << "Modified size of array by passing by pointer: " << sizeof(p) << endl;
}

int main()
{
    int a[7] = {1, 2, 3, 4, 5, 6, 7,};
    cout << "Actual size of array is: " << sizeof(a) <<endl;
    decayByPassVal(a);
    decayByPassPointer(&a);

    return 0;
}
```

## 如何避免数组退化

- 典型的方法避免数组退化是传递数组的大小作为单独的参数，而不是使用 `sizeof`
- 另外一个方法避免数组退化是传递引用，这个可以避免数组转化为指针，因此避免了退化

```cpp
#include <iostream>

using namespace std;

void avoidByPassReference(int (&p)[7])
{
    cout << "Modified size of array by passing by reference: " << sizeof(p) << endl;
}

int main()
{
    int a[7] = {1, 2, 3, 4, 5, 6, 7,};
    cout << "Actual size of array is: " << sizeof(a) <<endl;
    avoidByPassReference(a);
    return 0;
}
```

## 参考

- [What is Array Decay in C++? How can it be prevented?](https://www.geeksforgeeks.org/what-is-array-decay-in-c-how-can-it-be-prevented/)
