# dpkg 安装和卸载程序

- [dpkg 安装和卸载程序](#dpkg-%e5%ae%89%e8%a3%85%e5%92%8c%e5%8d%b8%e8%bd%bd%e7%a8%8b%e5%ba%8f)
  - [dpkg 命令](#dpkg-%e5%91%bd%e4%bb%a4)
  - [语法](#%e8%af%ad%e6%b3%95)
  - [选项](#%e9%80%89%e9%a1%b9)
  - [参数](#%e5%8f%82%e6%95%b0)
  - [实例](#%e5%ae%9e%e4%be%8b)
- [列出 deb 包的内容](#%e5%88%97%e5%87%ba-deb-%e5%8c%85%e7%9a%84%e5%86%85%e5%ae%b9)
- [配置包](#%e9%85%8d%e7%bd%ae%e5%8c%85)
- [安装包](#%e5%ae%89%e8%a3%85%e5%8c%85)
- [列出当前已安装的包](#%e5%88%97%e5%87%ba%e5%bd%93%e5%89%8d%e5%b7%b2%e5%ae%89%e8%a3%85%e7%9a%84%e5%8c%85)
- [查看包是否正确安装。第一列的 `ii` 指的是 `installed ok installed`](#%e6%9f%a5%e7%9c%8b%e5%8c%85%e6%98%af%e5%90%a6%e6%ad%a3%e7%a1%ae%e5%ae%89%e8%a3%85%e7%ac%ac%e4%b8%80%e5%88%97%e7%9a%84-ii-%e6%8c%87%e7%9a%84%e6%98%af-installed-ok-installed)
  - [使用 `-r` 移除，可以看到第一列的的状态是 `rc`](#%e4%bd%bf%e7%94%a8--r-%e7%a7%bb%e9%99%a4%e5%8f%af%e4%bb%a5%e7%9c%8b%e5%88%b0%e7%ac%ac%e4%b8%80%e5%88%97%e7%9a%84%e7%9a%84%e7%8a%b6%e6%80%81%e6%98%af-rc)
  - [使用 `-P` 移除，输出为空，找不到对应条目](#%e4%bd%bf%e7%94%a8--p-%e7%a7%bb%e9%99%a4%e8%be%93%e5%87%ba%e4%b8%ba%e7%a9%ba%e6%89%be%e4%b8%8d%e5%88%b0%e5%af%b9%e5%ba%94%e6%9d%a1%e7%9b%ae)
- [显示该包的版本](#%e6%98%be%e7%a4%ba%e8%af%a5%e5%8c%85%e7%9a%84%e7%89%88%e6%9c%ac)
- [列出与该包关联的文件](#%e5%88%97%e5%87%ba%e4%b8%8e%e8%af%a5%e5%8c%85%e5%85%b3%e8%81%94%e7%9a%84%e6%96%87%e4%bb%b6)
- [删除包（包括配置文件）](#%e5%88%a0%e9%99%a4%e5%8c%85%e5%8c%85%e6%8b%ac%e9%85%8d%e7%bd%ae%e6%96%87%e4%bb%b6)
- [删除包](#%e5%88%a0%e9%99%a4%e5%8c%85)
- [搜索所属的包内容](#%e6%90%9c%e7%b4%a2%e6%89%80%e5%b1%9e%e7%9a%84%e5%8c%85%e5%86%85%e5%ae%b9)
- [解开 deb 包的内容](#%e8%a7%a3%e5%bc%80-deb-%e5%8c%85%e7%9a%84%e5%86%85%e5%ae%b9)

## dpkg 命令

dpkg 是 Debian 的包管理器。用于安装、构建、移除和管理 Debian 包。

## 语法

`dpkg 选项 参数`

## 选项

- `--configure`: 配置软件包(已经解开但是未配置的包)
- `-i, --install`: 安装软件包。在指定文件夹时可使用 `-R, --recursive`。包括下面的步骤
  - 提取新包的文件
  - 如果之前安装过相同包的其他版本，执行旧包的 `prerm` 脚本
  - 如果包提供了 `preinst` 脚本，运行
  - 解包新文件，同时备份旧文件，以便发生错误时可以恢复
  - 如果之前安装过相同包的另外一个版本，执行旧包的 `postrm` 脚本。注意此脚本在新包执行 `preinst` 命令之后，因为写入新文件的同时会删除旧文件
  - 配置包
- `-l`: 显示已经安装的软件包
- `-L`: 显示软件包关联的文件
- `-P, --purge`: 清理安装或已经删除的软件包。会删除所有文件，包括配置文件
- `-r, --remove`: 删除安装的软件包，但是不会删除配置文件。包括下面的步骤
  - 执行 `prerm` 脚本
  - 删除安装的文件
  - 执行 `postrm` 脚本
- `--unpack`: 解开软件包，但是不配置
- `dpkg-deb` 的行为：
  - `-c`: 显示软件包内文件列表
  - `-I, --info`: 显示一个包的信息
- `dpkg-query` 的行为：
  - `-l, --list`: 显示匹配给定模式的软件包
  - `-L, --listfiles`: 显示软件包安装到系统关联的文件
  - `-s, --status`: 打印指定包的状态
  - `-S, --search`: 从安装包中查找一个文件名

## 参数

deb 软件包: 要操作的 .deb 软件包名

## 实例

```sh
# 列出 deb 包的内容
dpkg -c package.deb
# 配置包
dpkg --configure package
# 安装包
dpkg -i package.deb
# 列出当前已安装的包
dpkg -l
# 查看包是否正确安装。第一列的 `ii` 指的是 `installed ok installed`
## 使用 `-r` 移除，可以看到第一列的的状态是 `rc`
## 使用 `-P` 移除，输出为空，找不到对应条目
dpkg -l | grep xxx
# 显示该包的版本
dpkg -l package
# 列出与该包关联的文件
dpkg -L package
# 删除包（包括配置文件）
dpkg -P package
# 删除包
dpkg -r package
# 搜索所属的包内容
dpkg -S keyword
# 解开 deb 包的内容
dpkg --unpack package.deb
```
