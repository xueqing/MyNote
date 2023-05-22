# rust 学习遇到的问题

- [rust 学习遇到的问题](#rust-学习遇到的问题)
  - [在 mac 上安装 rust 之后编译报错](#在-mac-上安装-rust-之后编译报错)
  - [执行 cargo search 报错 You're using an RSA key with SHA-1, which is no longer allowed](#执行-cargo-search-报错-youre-using-an-rsa-key-with-sha-1-which-is-no-longer-allowed)

## 在 mac 上安装 rust 之后编译报错

## 执行 cargo search 报错 You're using an RSA key with SHA-1, which is no longer allowed

`rust search structopt` 报错：

```txt
Updating crates.io index
error: failed to update registry `crates-io`

Caused by:
  failed to fetch `https://github.com/rust-lang/crates.io-index`

Caused by:
  failed to authenticate when downloading repository: git@github.com:rust-lang/crates.io-index

  * attempted ssh-agent authentication, but no usernames succeeded: `git`

  if the git CLI succeeds then `net.git-fetch-with-cli` may help here
  https://doc.rust-lang.org/cargo/reference/config.html#netgit-fetch-with-cli

Caused by:
  ERROR: You're using an RSA key with SHA-1, which is no longer allowed. Please use a newer client or a different key type.
  Please see https://github.blog/2021-09-01-improving-git-protocol-security-github/ for more information.

  ; class=Ssh (23); code=Eof (-20)
```

- 方法 1：按照提示，先在命令行使用 `git clone git@github.com:rust-lang/crates.io-index`，如果没有报错，配置 `net.git-fetch-with-cli` 环境变量

```sh
# 编辑 $HOME/.cargo/config.toml，不存在则新建。添加下面的代码：
[net]
git-fetch-with-cli = true   # use the `git` executable for git operations
```

- 方法 2：[参考](https://www.howtogeek.com/devops/how-to-use-a-different-private-ssh-key-for-git-shell-commands/)。使用新的算法生成 ssh 密钥。

```sh
# 使用 ECDSA 方式生成新的密钥对
ssh-keygen -t ecdsa -b 521 -C "your_email@example.com"
# 在 github 的个人设置中添加一个 ssh-key
# 编辑 ~/.ssh/config 文件，不存在则新建。添加下面的代码：
Host rustgithub
   HostName github.com
   IdentityFile ~/.ssh/id_ecdsa
   IdentitiesOnly yes
# 编辑 ~/.gitconfig 文件，修改 rust 仓库的路径
[url "git@rustgithub:rust-lang"]
  insteadof = git@github.com:rust-lang
```
