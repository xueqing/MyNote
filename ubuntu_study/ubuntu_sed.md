# sed

- [sed](#sed)
  - [描述](#描述)
  - [s 命令中的分隔符](#s-命令中的分隔符)
  - [批量替换](#批量替换)
  - [按行删除](#按行删除)
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

## 参考

- [sed 命令](http://c.biancheng.net/linux/sed.html)
- [sed 基础教程](https://www.twle.cn/c/yufei/sed/sed-basic-index.html)
- [sed s Command](http://www.manpagez.com/info/sed/sed-4.2.2/sed_8.php#The-_0022s_0022-Command)
- [sed tutorial](https://www.grymoire.com/Unix/Sed.html)
