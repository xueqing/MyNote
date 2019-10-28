# 命令行创建文件

- [命令行创建文件](#%e5%91%bd%e4%bb%a4%e8%a1%8c%e5%88%9b%e5%bb%ba%e6%96%87%e4%bb%b6)
  - [cat](#cat)
  - [touch](#touch)
  - [标准重定向符号 >](#%e6%a0%87%e5%87%86%e9%87%8d%e5%ae%9a%e5%90%91%e7%ac%a6%e5%8f%b7)
  - [echo/printf](#echoprintf)
  - [nano](#nano)
  - [vi/vim](#vivim)

## cat

`cat` 可用于创建文件。输入回车后，光标移到到下一行，可以开始输入文本。完成之后使用 Ctrl+D 退出，并返回到提示符

```sh
cat > file_name
```

`cat` 也可以查看文件内容。

```sh
cat file_name
```

## touch

`touch` 支持一条命令创建多个文件，且不支持立刻输入文本。

```sh
touch file1 file2
```

## 标准重定向符号 >

标准重定向符号通常用于重定向一个命令的输出到一个新文件。如果没有前置的命令，命令只创建一个新文件。类似于 `touch`。

与 `touch` 不同，`>` 只能一次创建一个文件。

```sh
> file_name
```

## echo/printf

使用 `echo/printf` 命令输入文本到指定文件，文件不存在则会被创建。

```sh
echo 'hello' > file1
printf "world\nI'm kiki" > file2
```

## nano

`nano` 是 GNU 项目的文本编辑器。输入回车之后可以开始输入文本。按照命令提示退出编辑界面。

```sh
nano file_name
```

## vi/vim

使用 `vi/vim` 文本编辑器。

```sh
vi file_name
```
