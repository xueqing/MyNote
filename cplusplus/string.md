# string

## find vs find_first_of

- find 函数原型

```cpp
// c++11
string (1)    size_t find (const string& str, size_t pos = 0) const noexcept;
c-string (2)  size_t find (const char* s, size_t pos = 0) const;
buffer (3)    size_t find (const char* s, size_t pos, size_type n) const;
character (4) size_t find (char c, size_t pos = 0) const noexcept;
```

- find_first_of 函数原型

```cpp
// c++11
string (1)    size_t find_first_of (const string& str, size_t pos = 0) const noexcept;
c-string (2)  size_t find_first_of (const char* s, size_t pos = 0) const;
buffer (3)    size_t find_first_of (const char* s, size_t pos, size_t n) const;
character (4) size_t find_first_of (char c, size_t pos = 0) const noexcept;
```

- 对比
  - find：匹配查找整个字符串
  - find_first_of：匹配查找指定参数的**任意一个**字符
