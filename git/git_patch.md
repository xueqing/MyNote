# 补丁

- [补丁](#%e8%a1%a5%e4%b8%81)
  - [普通补丁](#%e6%99%ae%e9%80%9a%e8%a1%a5%e4%b8%81)
  - [正式补丁 git format-patch](#%e6%ad%a3%e5%bc%8f%e8%a1%a5%e4%b8%81-git-format-patch)
    - [参数](#%e5%8f%82%e6%95%b0)
    - [用于邮件发送](#%e7%94%a8%e4%ba%8e%e9%82%ae%e4%bb%b6%e5%8f%91%e9%80%81)
    - [应用 patch](#%e5%ba%94%e7%94%a8-patch)
  - [参考](#%e5%8f%82%e8%80%83)

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
# 从 commit (包含该提交)开始往前的 n 个提交生成补丁
git format-patch commit -n
# 为某一个提交范围生成补丁
git format-patch commit1..commit2
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

### 应用 patch

```sh
# 检查 patch 是否能正常应用
git apply --check path_to_patch_file.patch
# 应用 patch，不提交
git apply path_to_patch_file.patch
# git 和需要打 patch 的文件不在一个目录
git apply --check --directory=patch_dest_dir/ path_to_patch_file.patch
git apply --directory=patch_dest_dir/ path_to_patch_file.patch
```

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
