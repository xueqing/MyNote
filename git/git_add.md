# 添加文件

- git add: 添加内容到下一次提交中. 当使用 git commit 时, git 将依据暂存区域的内容来进行文件的提交
- 可以用它开始跟踪新文件, 或者把已跟踪的文件放到暂存区, 还能用于合并时把有冲突的文件标记为已解决状态等

```sh
# 把 path 添加到索引库, path 可以是文件或目录
git add path
# 添加所有文件
git add .
# 添加指定文件
git add file1 file2
# 不处理未跟踪(untracked)的文件
git add -u [<path>]
# 添加所有
git add -A [<path>]
# 查看所有修改过或已删除文件但是未提交的文件
git add -i [<path>]
# 交互式添加修改内容到本次提交，或者 `git add --interactive`
git add -i
# 交互式选择当前的修改添加到本次提交，只需输入 y/n
git add -p
```

## 提交空文件

- 方法 1：在空文件夹创建一个空文件 `.gitkeep`，提交该文件
- 方法 2：在空文件夹创建一个空文件 `.gitignore`，文件内容如下。提交文件

  ```text
  # 忽视目录所有内容
  *
  # 不忽视 .gitignore 文件
  !.gitignore
  ```
