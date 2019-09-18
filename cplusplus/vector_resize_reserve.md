# vector 的 resize 和 reserve

## resize

- 原型
  - `void resize (size_type n);`
  - `void resize (size_type n, const value_type& val);`
- resize 方法(传递参数来构造是一样的)调整容器大小使得包含 n 个元素
  - 如果当前大小大于 n，会从尾部删除多余的元素
  - 如果当前大小小于 n，会在尾部插入适量的元素到 vector 达到指定的大小(有第二个可选参数指定元素的值)。如果指定值，新元素初始化为 val 的拷贝，否则使用默认构造函数初始化
  - 如果当前容量(capacity) 小于 n，需要重新分配内存
- 它会影响 `size()`，如果不需要重新分配内存，则 `capacity()` 也不会改变

## reserver

- 原型
  - `void reserve (size_type n);`
- reserve 方法请求修改容量(capacity)，即容量需要足够包含 n 个元素
  - 如果当前容量小于 n，需要重新分配内存，使得容量**不小于** n
  - 如果当前容量不小于 n，不会重新分配内存，也不会影响容量
- 它只会影响 `capacity()`，`size()` 不会改变，也不会修改元素。只分配内存，但是没有初始化。容器中没有添加任何元素。如果之后插入元素，容器不会发生重新分配内存。

## 取舍

- 如果需要初始化内存，使用 resize
- 如果知道需要保存元素的大小，只是为了避免多次分配，使用 reserve

```cpp
#include <vector>
#include <iostream>

using namespace std;

class MoreThanOneParam
{
    int m_i;
    string m_s;
public:
    MoreThanOneParam() : m_i(-1) { cout << "MoreThanOneParam::default::" << m_i << endl; }
    MoreThanOneParam(int ii, string s) : m_i(ii), m_s(s) { cout << "MoreThanOneParam::" << m_i << endl; }
    MoreThanOneParam(const MoreThanOneParam &copy) : m_i(copy.m_i), m_s(copy.m_s) { cout << "MoreThanOneParam::copy::" << m_i << endl; }
    ~MoreThanOneParam( ) { cout << "~MoreThanOneParam::" << m_i << endl; }

    int getInt() const { return m_i; }
    string getString() const { return m_s; }
};

int main( )
{
    vector<MoreThanOneParam> vec2={ {1,"s1"} , MoreThanOneParam{2 , "s2"} }; //对于每个元素，构造一次，拷贝一次，析构一次
    cout << "=============at first, size=" << vec2.size() << "; cap=" << vec2.capacity() << endl;
    vec2.reserve(6);
    cout << "=============after reserve(6), size=" << vec2.size() << "; cap=" << vec2.capacity() << endl;
    vec2.push_back( MoreThanOneParam(3 , "s3" ) ); //构造一次，拷贝一次，析构一次【底层可能会对 vector 重新分配内存，导致对之前元素的拷贝和析构】
    vec2.emplace_back( MoreThanOneParam(4 , "s4" )); //构造一次，拷贝一次，析构一次【底层可能会对 vector 重新分配内存，导致对之前元素的拷贝和析构】
    vec2.emplace_back( 5 , "s5" ); //构造一次
    cout << "=============after push_back/emplace_back 3 elements, size=" << vec2.size() << "; cap=" << vec2.capacity() << endl;
    vec2.emplace_back( 6 , "s6" ); //构造一次
    cout << "=============after push_back/emplace_back 1 elements, size=" << vec2.size() << "; cap=" << vec2.capacity() << endl;
    vec2.emplace_back( 7 , "s7" ); //构造一次
    cout << "=============after push_back/emplace_back 1 elements, size=" << vec2.size() << "; cap=" << vec2.capacity() << endl;
    vec2.reserve(6);
    cout << "=============after reserve(6), size=" << vec2.size() << "; cap=" << vec2.capacity() << endl;
    vec2.resize(14);
    cout << "=============after resize(14), size=" << vec2.size() << "; cap=" << vec2.capacity() << endl;
    vec2.resize(6);
    cout << "=============after resize(6), size=" << vec2.size() << "; cap=" << vec2.capacity() << endl;
    cout << endl;

    return 0;
}
```

## 参考

- [Choice between vector::resize() and vector::reserve()](https://stackoverflow.com/questions/7397768/choice-between-vectorresize-and-vectorreserve)
