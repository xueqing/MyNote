# sed

- [sed](#sed)
  - [描述](#描述)
  - [s 命令中的分隔符](#s-命令中的分隔符)
  - [批量替换](#批量替换)
  - [按行删除](#按行删除)
  - [正则表达式元字符](#正则表达式元字符)
    - [正则表达式转义字符](#正则表达式转义字符)
    - [POSIX 正则表达式](#posix-正则表达式)
    - [分组](#分组)
  - [参考](#参考)

## 描述

sed(stream editor)是流编辑器。是一个面向行处理的工具，处理单位是行，处理后的结果会输出到标准输出，而不会修改读取的文件。

## s 命令中的分隔符

s(substitute) 命令表示替换，语法为 `s/regexp/replacement/flags`。s 命令内的 `/` 字符可被统一替换成任何其他单字符。`/` 字符(或者使用的其他字符)只有使用 `\` 字符转义之后才可以出现在 `regexp` 或 `replacement`。

比如，`sed -i "s/regexp/replacement/g" filename` 或者 `sed -i "s|regexp|replacement|g" filename` 或 `sed -i "s@regexp@replacement@g" filename` 都是有效的。当 `regexp` 或 `replacement` 中出现 `/` 时，比如表示文件路径，建议使用其他单字符可使表达式更加清晰。即使用 `regexp` 或 `replacement` 中不存在的单字符当做分隔符。

如果 `regexp` 或 `replacement` 中存在使用的分隔符，但是没有使用 `\` 进行转移，比如使用 `$` 引用的变量，会报错 ```sed fails with "unknown option to `s'" error```。

## 批量替换

- 在一个文件中替换字符串
  - `sed -i "s/original_str/replace_str/g" filename`可查找`filename`中的`original_str`替换成`replace_str`
    - `filename`可用通配符
    - 示例：`sed -i "s/\/usr\/local/\/home\/ubuntu\/nfs\/10.116\/ffmpeg\/lib/g" *.pc` `sed -i "s/local/ffmpeg/g" t.pc`
- 在一个文件夹中替换字符串
  - 批量查找文件夹中的文件`grep "original_str" -rl dirname`
  - 批量替换文件```sed -i s/original_str/replace_str/g `grep "original_str" -rl dirname` ```
  - 遍历当前文件夹所有文件`find ./ -type f`
  - 批量替换当前文件夹下所有文件的字符串```sed -i s/original_str/replace_str/g `find ./ type f` ```
- 批量替换文件、文件夹名字
  - 查找文件名`find ./ -name original_str*`
    - 替换输出`find ./ -name original_str* | sed 's/\(.*\)\(original_str\)\(.*\)/mv \1\2\3 \replace_str\3/' | sh`
      - 文件夹查找文件，将文件名转换为`mv orifile newfile`模式，最后应用管道命令
  - 查找文件夹`find ./ -name original_str* -type d`
    - 替换输出`find ./ -name original_str* -type d | sed 's/\(.*\)\(original_str\)\(.*\)/mv \1\2\3 \replace_str\3/' | sh`
      - 文件夹查找文件，将文件夹名转换为`mv orifile newfile`模式，最后应用管道命令
  
## 按行删除

- 不加`-i`打印删除之后的文本内容，并没有真正删除文件文本内容；加`-i`不打印，但是会真正删除对应内容
  - `sed nd filename`删除第`n`行
  - `sed n~md filename`从第`n`行开始，每隔`m-1`行删除
  - `sed m,nd filename`删除第`m`行到第`n`行
    - `sed 'm,n'd filename`
    - `sed 'm,nd' filename`
  - `sed '$'d filename`删除最后一行
    - `sed '$d' filename`
  - `sed /pattern/d filename`删除匹配`pattern`所在行
    - `sed '/pattern/d' filename`
    - `sed '/pattern/'d filename`
  - `sed '/pattern/,+2d' filename`删除匹配`pattern`所在行和之后`m`行
    - `sed '/pattern/,+2'd filename`
  - `sed '/^[[:space:]]*$/d' filename` 或者 `sed '/^\s*$/d' filename`删除空行，`\s` 用于匹配任何空白字符，包括空格、制表符和换页符等。为了符合 POSIX，使用字符类 `[[:space:]]` 代替 `\s`，因为后者是 GNU sed 扩展
  - `sed -e 's/\s\{3,\}/  /g' filename`把三个以上的连续空格字符(制表符和空格)替换为两个空格

## 正则表达式元字符

- `^` 匹配行首
- `$` 匹配行尾
- `.` 匹配任意单个非换行符
- `[]` 表示字符集，匹配任意单个位于其中的字符
- `[^]` 表示字符集，匹配任意单个没有位于其中的字符
- `[-]` 表示连续范围的字符集，匹配任意单个位于其中的字符
- `\?` 表示出现 0 或 1 次
- `\+` 表示出现至少 1 次
- `*` 表示出现任意次数(0 或 1 次或更多次)
- `{n}` 表示出现 n 次，需要使用 `\` 转义，即使用 `\{n\}`
- `{n,}` 表示出现至少 n 次，需要使用 `\` 转义，即使用 `\{n,\}`
- `{m, n}` 表示出现至少 m 次，至多 n 次，需要使用 `\` 转义，即使用 `\{m, n\}`
- `|` 表示或，需要使用 `\` 转义，比如 `[1|3]` 表示匹配字符 1 或 3

### 正则表达式转义字符

- `\n` 表示换行
- `\r` 表示回车

### POSIX 正则表达式

sed 支持 POSIX 规范的正则表达式。POSIX 类是一类有特殊含义的保留词。常见的包括

- `[:alnum:]` 表示任意单个大小写字母或数字，即 `[a-zA-Z0-9]`
- `[:alpha:]` 表示任意单个大小写字母，即 `[a-zA-Z]`
- `[:blank:]` 表示任意单个空格或制表符`\t`
- `[:digit:]` 表示任意单个数字，即 `[0-9]`
- `[:lower:]` 表示任意单个小写字母，即 `[a-z]`
- `[:upper:]` 表示任意单个大写字母，即 `[A-Z]`
- `[:punct:]` 表示任意单个标点符号
- `[:space:]` 表示任意单个空白符。ASCII 编码中，空白符包含空格、制表符`\t`、回车符`\r`、换行符`\n`、垂直制表符`\v`和换页符`\F`

### 分组

- 加 `()`，即小括号，表示分组：例如 `id\(.*\)`
- 每个分组有一个组号：从左向右，以分组的左括号为标识，第一个出现的分组的组号是 1，第二个是 2，以此类推
- `\n` 表示引用第 n 个分组，例如 `sed -i 's@json:"id\(.*\)"@json:"id\1" bson:"_id"@g' filename` 会将 `json:"id..."` 后追加 `bson:"_id"`，中间用空格分隔

## 参考

- [sed 命令](http://c.biancheng.net/linux/sed.html)
- [sed 基础教程](https://www.twle.cn/c/yufei/sed/sed-basic-index.html)
- [sed s Command](http://www.manpagez.com/info/sed/sed-4.2.2/sed_8.php#The-_0022s_0022-Command)
- [sed tutorial](https://www.grymoire.com/Unix/Sed.html)
