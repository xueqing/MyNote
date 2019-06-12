# git 别名管理

- 使用`git config`为命令设置别名

```sh
输入 git cpick commit-id 就可以引用某次提交
git config --global alias.cpick cherry-pick
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
```

- 使用`git config`新建命令

```sh
# 输入 git unstage fileA 就可以取消文件暂存
git config --global alias.unstage 'reset HEAD --'
# 输入 git last 可以查看最后一次提交
git config --global alias.last 'log -1 HEAD'
```

- 使用`git config`可以执行外部命令，在命令前加`!`

```sh
# 输入 git visual 等同于执行 gitk
git config --global alias.visual '!gitk'
```
