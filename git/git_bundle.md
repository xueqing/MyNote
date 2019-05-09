# git bundle

- 打包整个仓库

```sh
# 发送者使用仓库创建一个文件包
git bundle create somefile HEAD
# 接收者使用 somefile 文件获取提交
git pull somefile
```

- 打包部分提交：假设 xxxx 是发送者和接收者共享的最近提交

```sh
# 发送者打包增加的变更
git bundle create somefile HEAD ^xxxx
# 使用标签记录最近一次打包的节点
git tag -f lastbundle HEAD
# 一段时间后创建新文件包
git bundle create newbundle HEAD ^lastbundle
```