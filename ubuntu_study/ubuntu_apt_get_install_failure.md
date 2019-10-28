# ubuntu 下安装包失败

- 错误 1：Could not get lock /var/lib/dpkg/lock - open (11: Resource temporarily unavailable)
  - 可能原因：有另外一个程序正在运行，导致资源锁不可用。导致资源被锁的原因，可能是上次安装没正常完成。
  - 解决方法：执行下面两个命令行
    - `sudo rm /var/cache/apt/archives/lock`
    - `sudo rm /var/lib/dpkg/lock`
- 错误 2：Unable to fetch some archives, maybe run apt-get update or try with --fix-missing?
  - 可能原因：未更新源
  - 在 `System Settings` -> `Software & Updates` -> `Download from`: 选择 China 中，比如 `mirrors.aliyun.com`
