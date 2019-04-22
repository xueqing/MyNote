# 教程

## 命令行

```sh
# 在 vscode 打开当前目录
code .
# 在最近使用的 vscode 窗口打开当前目录
code -r .
# 新建一个窗口
code -n
# 修改语言
code --locale=es
# 打开对比编辑器
code --diff <file1> <file2>
# 打开文件跳到指定的行和列 <file:line[:column]>
code --goto package.json:10:5
# 查看帮助选项
code --help
# 停用所有扩展
code --disable-extensions .
```

## .vscode 文件夹

- 存放工作区相关文件
- `tasks.json`：Task Runner
- `launch.json`：调试器

## 个性化设置

- 忽略文件/文件夹：修改`settings.json`，添加文件或文件夹到`files.exclude`或`search.exclude`

## 参考

- [Getting Started](https://code.visualstudio.com/docs)