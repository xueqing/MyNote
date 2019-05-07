# 教程

- [教程](#%E6%95%99%E7%A8%8B)
  - [命令行](#%E5%91%BD%E4%BB%A4%E8%A1%8C)
  - [.vscode 文件夹](#vscode-%E6%96%87%E4%BB%B6%E5%A4%B9)
  - [个性化设置](#%E4%B8%AA%E6%80%A7%E5%8C%96%E8%AE%BE%E7%BD%AE)
  - [调试](#%E8%B0%83%E8%AF%95)
  - [参考](#%E5%8F%82%E8%80%83)

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

## 参考

- [Getting Started](https://code.visualstudio.com/docs)