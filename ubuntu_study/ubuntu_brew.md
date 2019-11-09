# 安装 Linuxbrew

参考 [Linuxbrew](https://docs.brew.sh/Homebrew-on-Linux#install)。

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
```

安装脚本将 Homebrew 安装到 `/home/linuxbrew/.linuxbrew`(sudo) 或者 `~/.linuxbrew`。安装之后不需要 `sudo` 使用 Homebrew。使用 `/home/linuxbrew/.linuxbrew` 弄马壮加密和搭配和人的主目录支持使用更多二进制包。

遵循下面的步骤指导增加 Homebrew 到 `PATH` 和 bash shell 配置脚本，即 Debian/Ubuntu 下是 `~/.profile`， CentOS/Fedora/RedHat 下是 `~/bash_profile`。

```sh
test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile
```

下面尝试安装一个包：

```sh
brew install hello
```

重启
