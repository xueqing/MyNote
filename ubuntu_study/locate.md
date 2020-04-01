# locate

## locate/slocate 命令

`locate/slocate` 命令用于查找文件和目录。

是 `find -name` 的另一种写法，但是更快。因为命令只搜索一个数据库 `/var/lib/mlocate/mlocate.db`，它包含本地所有文件信息。Linux 自动创建这个数据库，且每天自动更新一次，因此使用 `locate` 命令查不到最新变动的文件。

建议在使用 `locate` 命令之前，使用 `sudo updatedb` 手动更新数据库。

## 语法

`loate/slocate 选项 参数`

## 选项

- `-A, -all`: 只输出符合所有模式的条目
- `-b, --basename`: 只匹配路径的基本名称符合的
- `-d, --database DBPATH`: 指定数据库所在的目录
- `-e`: 只打印当前存在的文件条目
- `-i`: 匹配模式时忽略大小写
- `-u`: 更新 slocate 数据库
- `--help`: 显示帮助
- `--version`: 显示版本信息

## 参数

查找字符串：要查找的**文件名**中含有的字符串

## 实例

```sh
# 搜索 etc 目录下所有以 sh 开头的文件
locate /etc/sh
# 搜索用户主目录下，所有以 m 开头的文件
locate ~/m
# 搜索用户主目录下，所有以 m 开头的文件，并且忽略大小写
locate -i ~/m
```
