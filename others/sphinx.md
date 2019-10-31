# Sphinx 安装和配置

```sh
# 安装 chocolatey，类似于 OS X 的 Homebrew
# 管理员打开 powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
# 测试 choco，在终端输入 choco 或 choco -?
choco -? # 查看帮助文档
# 安装 python
choco install python
# 安装 setuptools 和 pip
python -m ensurepip --default-pip
# 如果上述命令不生效，使用源码安装
## 下载 [get-pip.py](https://bootstrap.pypa.io/get-pip.py)
## 使用源码安装和升级 pip。且会确定 setuptools 和 wheel 的环境
python get-pip.py [--prefix=/usr/local/]
# 更新 pip/setuptools/wheel
python -m pip install -U pip setuptools wheel
# 查看可执行文件路径。可能需要将可执行文件路径加入系统 PATH
python -m site --user-base
## Unix：修改 ~/.profile，添加 BIN_DIR/bin，执行 source 生效
## windows：添加 BIN_DIR/../Scripts，执行 source 生效
# 创建虚拟环境 python3 -m venv <DIR>
python3 -m venv for_sphinx
# 激活虚拟环境
## Unix：source <DIR>/bin/activate
source for_sphinx/bin/activate
## windows：<DIR>\Scripts\activate
for_sphinx\Scripts\activate
# 取消激活
deactivate
# 删除一个虚拟环境，只需要删除对应目录
rm -rf for_sphinx
# 安装 pipenv，是 Python 项目的依赖管理器。方便管理多个虚拟环境
pip install --user pipenv
# 使用 pipenv 安装包 pipenv install package_name
# 运行 pipenv run python filename.py
```

[Installing Chocolatey](https://chocolatey.org/install)
[Installing Packages](https://packaging.python.org/tutorials/installing-packages/)
[Managing Application Dependencies](https://packaging.python.org/tutorials/managing-dependencies/#managing-application-dependencies)
