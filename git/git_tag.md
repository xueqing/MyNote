# 标签

- 标签不能像分支一样来回移动. 分为轻量标签（lightweight）与附注标签（annotated）
  - 轻量标签：很像一个不会改变的分支, 只是一个特定提交的引用. 本质上是将提交校验和存储到一个文件中 - 没有保存任何其他信息
  - 附注标签：存储在 git 数据库中的一个完整对象.  是可以被校验的；包含打标签者的名字、电子邮件地址、日期时间；还有一个标签信息；并且可以使用 GNU Privacy Guard （GPG）签名与验证

```sh
# 列出已有的标签
git tag
# 列出 1.8.5 系列的标签
git tag -l 'v1.8.5*'
# 创建一个附注标签
git tag -a v1.4 -m 'v1.4'
# 查看标签信息与对应的提交信息
git show v1.4
# 创建一个轻量标签
git tag v1.4-lw
# 不会看到额外的标签信息.  只会显示出提交信息
git show v1.4-lw
# 在 commit-id 提交上打标签
git tag -a v1.2 <commit-id>
# 把所有不在远程仓库服务器上的标签全部推送到远程仓库服务器
git push origin --tags
# 把 [tagname] 标签推送到远程仓库服务器
git push origin [tagname]
# 在标签 v2.0.0 上创建分支 v2
git checkout -b v2 v2.0.0
```