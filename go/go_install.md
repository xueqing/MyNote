# 安装 go

- 下载[安装包](https://golang.org/dl/)
  - 选择最新的 [Linux 版本](https://dl.google.com/go/go1.11.2.linux-amd64.tar.gz)
  - 下载`wget https://dl.google.com/go/go1.11.2.linux-amd64.tar.gz`
- [安装](https://golang.org/doc/install)
  - 解压：`tar -C /usr/local -zxf go1.11.2.linux-amd64.tar.gz`
- 配置环境变量
  - 修改`/etc/profile`或`$HOME/.profile`
    - 追加`export PATH=$PATH:/usr/local/go/bin`
    - 执行`source`命令更新配置文件立即生效
