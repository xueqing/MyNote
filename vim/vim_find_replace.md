# vim 查找替换

使用`:s`替换字符串，常用的四个

- `:s/qwe/asd/`替换当前行第一个 qwe 为 asd
- `:s/qwe/asd/g`替换当前行所有 qwe 为 asd
- `:n,$s/qwe/asd/`替换第 n 行到最后一行每行第一个 qwe 为 asd
- `:n,$s/qwe/asd/g`替换第 n 行到最后一行每行所有 qwe 为 asd
