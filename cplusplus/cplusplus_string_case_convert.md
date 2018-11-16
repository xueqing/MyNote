# C++ string 转换大小写

```c++
#include <string>
#include <algorithm>

void CString::StringToUpper(std::string &str)
{
    std::transform(str.begin(), str.end(), str.begin(), ::toupper);
}

void CString::StringToLower(std::string &str)
{
    std::transform(str.begin(), str.end(), str.begin(), ::tolower);
}
```

- 提示出错`error: no matching function for call to ‘transform(__gnu_cxx::__normal_iterator<char*, std::basic_string<char, std::char_traits<char>, std::allocator<char> > >, __gnu_cxx::__normal_iterator<char*, std::basic_string<char, std::char_traits<char>, std::allocator<char> > >, __gnu_cxx::__normal_iterator<char*, std::basic_string<char, std::char_traits<char>, std::allocator<char> > >, <unknown type>)’`的解决方法：既有 C 版本的`toupper/tolower`函数，又有 STL 模板函数`toupper/tolower`，二者存在冲突，在`toupper/tolower`前加上`::`表示强制指定 C 版本的
- ::toloweer/::toupper 只用于单字节字符的替换，不适用于多字节编码（如 UTF-8）？
- 可使用 boost 库

```c++
#include <boost/algorithm/string.hpp> 
using namespace boost;
// use to_lower/to_upper function
```