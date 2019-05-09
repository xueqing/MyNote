# 查找错误提交

- 已知 HEAD 节点是错误的，正确版本是 xxxxx 对应的提交，使用`git bisect`查找错误的提交

```sh
git bisect start
git bisect bad HEAD
git bisect good xxxxx
# git 从中间的历史记录检出一个中间状态，在此状态上测试功能
# 1 如果此状态错误
git bisect bad
# 2 如果此状态正确
git bisect good
# 迭代多次之后可以找到导致错误的提交
# 返回到原始状态
git bisect reset
```