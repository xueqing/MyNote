# sed

## 批量替换

- 在一个文件中替换字符串
  - `sed -i "s/original_str/replace_str/g" filename`可查找`filename`中的`original_str`替换成`replace_str`
    - `filename`可用通配符
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
  - `sed '/^$/d' filename`删除空行
