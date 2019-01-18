# find 命令

- 递归删除文件夹下某个文件或文件夹
- find 指定`-name`查找类型默认包括文件和文件夹
  - `find ./ -name .git | xargs rm -rf`递归删除当前路径下的`.git`文件和文件夹
  - `find ./ -name .git -type f | xargs rm -rf`递归删除当前路径下的`.git`文件
  - `find ./ -name .git -type d | xargs rm -rf`递归删除当前路径下的`.git`文件夹
  - `find ./ -name .git -print -exec rm -rf {} \;`
    - `-print`输出查找的文件或文件夹名
    - `-exec`后边跟着要执行的命令，表示将 find 查找的文件或目录执行该命令
      - 选项后面跟着要执行的命令和脚本，然后是一对`{}`，一个空格和一个`\`，然后是一个分号
- `xargs- build and execute command lines from standard input`