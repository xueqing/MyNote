# apt-get

## apt-get 命令

`apt-get` 命令是 Debian Linux 发行版中的 APT(高级软件包工具) 软件包管理工具。所有基于 Debian 的发行都使用这个包管理系统。

## 语法

`apt-get 选项 参数`

## 选项

- `-c`: 指定配置文件

## 参数

- 管理指令: 对 APT 软件包的管理操作
- 软件包: 指定要操作的软件包

## 实例

第一步是引入必需的软件库，Debian 的软件库也就是所有 Debian 软件包的集合，存在互联网上的一些公共站点上。把它们的地址加入，`apt-get` 就能搜索到想要的软件。`/etc/apt/sources.list` 是存放这些地址列表的配置文件，其格式如下：

```txt
deb [web或ftp地址] [发行版名字] [main/contrib/non-free]
```

```sh
# 修改 /etc/apt/sources.list 或者 /etc/apt/preferences 之后运行。运行命令更新包的数据库
## hit:包版本没有变化;ign:包被忽略了;get:有一个新版本可用
apt-get update
# 安装一个新软件包
apt-get install package_name
# 卸载一个已安装的软件包(只删除二进制文件)
apt-get remove package_name
# 卸载一个已安装的软件包所有相关文件(包括配置文件)
apt-get purge package_name
# 删除检索到的软件包的本地存储备份
apt-get clean
# 定期运行命令来清除那些已经卸载的软件包的 .deb 文件
apt-get autoclean
# 删除为了满足安装软件包的依赖关系而自动安装的 lib 和软件包，删除了安装软件，使用此命令安装这些自动安装的 lib 和软件包
apt-get autoremove
# 更新所有已安装的软件包
apt-get upgrade <package_name>
# 提供完整的升级: 会查找正在安装的较新版本软件包的依赖项，并尝试安装新软件包或自行删除现有软件包
apt-get dist-upgrade
# 在apt-get update之后进行apt-get升级
apt-get update && sudo apt-get upgrade -y
```

## 在已安装的软件包上运行 install

实际上会查看数据库，如果找到更新的版本，它会将已安装的软件包升级到更新的软件包。

## 在不升级的情况下安装包

想要安装一个软件包但是如果已经安装了它就不想升级它

```sh
sudo apt-get install <package_name> --no-upgrade
```

## 只升级包，而不是安装

只想升级包但不想安装(如果尚未安装)

```sh
sudo apt-get install <package_name> --only-upgrade
```

## 安装特定版本的应用程序

```sh
sudo apt-get install <package_name>=<version_number>
```
