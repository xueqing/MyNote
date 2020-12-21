# 正则表达式

- [正则表达式](#正则表达式)
  - [匹配次数](#匹配次数)
    - [贪婪与懒惰](#贪婪与懒惰)
  - [匹配符](#匹配符)
  - [集合](#集合)
  - [分组](#分组)
    - [后向引用](#后向引用)
    - [零宽断言](#零宽断言)
    - [注释](#注释)
  - [实战](#实战)
    - [查找](#查找)
    - [查找并替换](#查找并替换)

## 匹配次数

| 字符 | 描述 |
| --- | --- |
| `*` | 前面的内容连续出现次数 >= 0 |
| `+` | 前面的内容连续出现次数 >= 1 |
| `?` | 前面的内容连续出现次数 = 0/1 |
| `{n}` | 前面的内容连续出现次数 = n |
| `{n,}` | 前面的内容连续出现次数 >= n |
| `{m, n}` | m <= 前面的内容连续出现次数 <=n |

### 贪婪与懒惰

- 贪婪匹配表示匹配尽可能多的字符：`a.*b` 会匹配最长的以 a 开始以 b 结束的字符串
- 懒惰匹配表示匹配尽可能少的字符：`a.*?b` 会匹配最短的以 a 开始以 b 结束的字符串。懒惰限定符包括如下

| 字符 | 描述 |
| --- | --- |
| `*?` | 重复次数 >= 0，且尽可能少重复 |
| `+?` | 重复次数 >= 1，且尽可能少重复 |
| `??` | 重复次数 = 0/1，且尽可能少重复 |
| `{m, n}?` | m <= 重复次数 <= n，且尽可能少重复 |
| `{n,}?` | 重复次数 >= n，且尽可能少重复 |

给定字符串 `ooooo`，`o+` 匹配所有 o，而 `o+?` 匹配单个 o。

**注意**：最先开始的匹配优先级最高。因此，给定字符串 `aabab` 和正则表达式 `a.?b`，会匹配到 `aab` 和 `ab`，而不是 `ab` 和 `ab`。

## 匹配符

| 字符 | 描述 |
| --- | --- |
| `^` | 匹配开始位置。放在 `[]` 中表示非 |
| `$` | 匹配结束位置 |
| `.` | 匹配任何非换行符 |
| `\b` | 匹配单词的开头或结尾，即单词的分界处。表示前一个字符和后一个字符不全是(只有一个是或不存在) `\w`|
| `\B` | 匹配非单词边界 |
| `\cx` | 匹配由 x 指定的控制字符。`\cM` 匹配一个 Control-M 或回车符。x 必须是 a-z 或 A-Z 之一。 |
| `\d` | 匹配一个数字字符。等价于 `[0-9]` |
| `\D` | 匹配一个非数字字符。等价于 `[^0-9]` |
| `\f` | 匹配一个换页符 |
| `\n` | 匹配一个换行符 |
| `\r` | 匹配一个回车符 |
| `\s` | 匹配任何空白字符，包括空格、制表符、换页符等等。等价于 `[ \f\n\r\t\v]` |
| `\S` | 匹配任何非空白字符。等价于 `[^ \f\n\r\t\v]` |
| `\t` | 匹配一个制表符。等价于 `\x09` 和 `\cI` |
| `\v` | 匹配一个垂直制表符。等价于 `\x0b` 和 `\cK` |
| `\w` | 匹配字母、数字、下划线。等价于 `[A-Za-z0-9_]` |
| `\W` | 匹配非字母、数字、下划线。等价于 `[^A-Za-z0-9_]` |
| `\num` | 匹配 num，num 是一个正整数。表示对捕获的匹配的引用。比如 `(.)\1` 匹配两个连续的相同字符 |

## 集合

- 加 `[]`，即方括号，表示一个集合
- `[aeiou]` 匹配任何一个英文元音字母
- `[^aeiou]` 匹配任何除了 aeiou 之外的字符
- `[.?!]` 匹配标点符号(.或?或!)
- `[0-9]` 等同于 `\d`
- `[a-z0-9A-Z]` 等同于 `\w`

## 分组

- 加 `()`，即小括号，表示分组：例如 `m_([a|b|c])`
- 每个分组有一个组号：从左向右，以分组的左括号为标识，第一个出现的分组的组号是 1，第二个是 2，以此类推
- `\U` 加分组将捕获的分组转为大写
- `\L` 加分组将捕获的分组转为大写
- `\E` 终止转换

### 后向引用

用于重复搜索前面某个分组匹配的文本：例如，`\1`代表分组 1 匹配的文本

| 表达式 | 描述 |
| --- | --- |
| `(exp)` | 匹配 exp，并捕获文本到自动命名的组里 |
| `(?<name>exp)` | 匹配 exp，并捕获文本到名称为 name 的组里，也可以写成 `(?'name'exp)` |
| `(?:exp)` | 匹配 exp，不捕获匹配的文本，也不给此分组分配组号 |

比如 `m_(?<Word>[a|b|c])` 或者 `m_(?'Word'[a|b|c])`，可以把 `[a|b|c]` 的组名指定为 `Word`，后面可以使用 `\k<Word>` 来反向引用该分组捕获的内容

### 零宽断言

用于指定一个位置，即该位置应该满足一定的条件(即断言)，因此也称为 `零宽断言`。

| 表达式 | 描述 |
| --- | --- |
| `(?=exp)` | 匹配 exp 前面的位置，断言此位置后面能匹配表达式 exp |
| `(?!exp)` | 匹配后面不是 exp 的位置，断言此位置后面不能匹配表达式 exp |
| `(?<=exp)` | 匹配 exp 后面的位置，断言此位置前面能匹配表达式 exp |
| `(?<!exp)` | 匹配前面不是 exp 的位置，断言此位置前面不能匹配表达式 exp |

### 注释

用于包含注释。

| 表达式 | 描述 |
| --- | --- |
| `(?#comment)` | 这种类型的分组不对正则表达式的处理产生任何影响，用于提供注释让人阅读 |

## 实战

### 查找

| 要求 | 正则表达式 |
| --- | --- |
| 精确查找单词 hi | `\bhi\b` |
| 以字母 a 开头的单词 | `\ba\w*\b` |
| 匹配 IP 地址 | `((2[0-4]\d|25[0-5]|[01]?\d\d?)\.){3}(2[0-4]\d|25[0-5]|[01]?\d\d?)` |
| 匹配非法字符如:< > & / ' \ | `[^<>&/']+` |
| 匹配前面不是小写字母的七位数字 | `(?<![a-z])\d{7}` |
| 匹配身份证为 15 或 18 位，15 位的全为数字，18 位的前 17 位为数字，最后一位为数字或者大写字母 X | `(^\d{15}$)|(^\d{17}[0-9|X]$)` |

### 查找并替换

VSCode 中使用 `$n` 表示捕获第 n 个分组。

| 要求 | 查找 | 替换 |
| --- | --- | --- |
| 将 test this sentence 转为大写 | `^(.*)$` | `\U$1` |
| 将 TEST THIS SENTENCE 转为小写 | `^(.*)$` | `\L$1` |
| 将 test this sentence 首字母 t 转为大写 | `^(.)` | `\U$1` |
| 将 test this sentence 每个单词首字母转为大写 | `\b(\w)(\w*)\b` | `\U$1\E$2` |