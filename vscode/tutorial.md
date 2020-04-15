# 教程

- [教程](#%e6%95%99%e7%a8%8b)
  - [命令行](#%e5%91%bd%e4%bb%a4%e8%a1%8c)
  - [.vscode 文件夹](#vscode-%e6%96%87%e4%bb%b6%e5%a4%b9)
  - [个性化设置](#%e4%b8%aa%e6%80%a7%e5%8c%96%e8%ae%be%e7%bd%ae)
  - [调试](#%e8%b0%83%e8%af%95)
  - [正则表达式](#%e6%ad%a3%e5%88%99%e8%a1%a8%e8%be%be%e5%bc%8f)
  - [参考](#%e5%8f%82%e8%80%83)

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

## 调试

- Node.js 调试
  - <https://github.com/Microsoft/vscode-recipes/tree/master/nodemon>
- Chrome 调试
  - <https://marketplace.visualstudio.com/items?itemName=msjsdiag.debugger-for-chrome>
- C++ 调试
  - <https://github.com/xueqing/vscode-debug/tree/master/cppdebug/helloworld>

## 正则表达式

- 分组使用 `$` + 分组编号

## 参考

- [Getting Started](https://code.visualstudio.com/docs)
