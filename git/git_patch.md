# 补丁

- [补丁](#%E8%A1%A5%E4%B8%81)
  - [普通补丁](#%E6%99%AE%E9%80%9A%E8%A1%A5%E4%B8%81)
  - [正式补丁 git format-patch](#%E6%AD%A3%E5%BC%8F%E8%A1%A5%E4%B8%81-git-format-patch)
    - [参数](#%E5%8F%82%E6%95%B0)
    - [用于邮件发送](#%E7%94%A8%E4%BA%8E%E9%82%AE%E4%BB%B6%E5%8F%91%E9%80%81)
    - [直接用于 git am](#%E7%9B%B4%E6%8E%A5%E7%94%A8%E4%BA%8E-git-am)
  - [参考](#%E5%8F%82%E8%80%83)

## 普通补丁

```sh
# 发送者生成一个补丁
git diff xxx > my.patch
# 接收者在其他地方使用这个补丁
git apply < my.patch
```

## 正式补丁 git format-patch

- `git format-patch`生成补丁用于 email 发送，格式是类似 UNIX mailbox
- 命令的输出用于 email 发送或者`git am`直接使用
- 是更正式的设置，记录作者名字或签名

### 参数

- `--root`从提交历史开始的所有提交
- `-M`检测重命名
- `-B`分割完整的重写信息为删除和创建对，即把提交当做删除旧文件，创建新文件
  - `-M -B`可将一个完全重写的文件当做重命名
- `--stdout`将所有提交以 mbox 格式打印到标准输出，而不是为每个提交创建一个文件
  - 不使用时，在当前文件夹为每次提交生成一个单独的文件，并打印文件的名字

```sh
# 为某一时刻生成补丁
git format-patch xxxx
# 为某一个提交范围生成补丁
git format-patch xxxx..HEAD^^
# 提取在当前分支但是不在 origin 分支的提交
git format-patch origin
# 提取工程开始到 <commit> 的所有的提交
git format-patch --root <commit>
# 等同于
git format-patch -M -B origin
# 提取当前分支最上面的 3 次提交，生成补丁
git format-patch -3
```

### 用于邮件发送

```sh
# 发送者可使用 git-send-email 发送 git format-patch 的结果给接收者
# 接收者保存邮件到文件 email.txt，然后应用补丁创建一个提交，会自动包含作者的信息
git am < email.txt
```

### 直接用于 git am

- `git am` 将 mailbox 的邮件信息分割成提交日志信息、作者信息和补丁，应用它们至当前分支

```sh
# 提取 R1 和 R2 之间的提交，使用 git am 来 cherry-pick 提交应用到当前分支
git format-patch -k --stdout R1..R2 | git am -3 -k
```

## 参考

- [git format-patch doc](https://git-scm.com/docs/git-format-patch)
- [gitrevisions doc](https://git-scm.com/docs/gitrevisions)
- [git am doc](https://git-scm.com/docs/git-am)
- [git send-email doc](https://git-scm.com/docs/git-send-email)
- [git apply doc](https://git-scm.com/docs/git-apply)