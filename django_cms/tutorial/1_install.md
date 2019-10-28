# 1 安装

- [1 安装](#1-%e5%ae%89%e8%a3%85)
  - [1.1 环境要求](#11-%e7%8e%af%e5%a2%83%e8%a6%81%e6%b1%82)
  - [1.2 配置 Python 环境](#12-%e9%85%8d%e7%bd%ae-python-%e7%8e%af%e5%a2%83)
    - [1.2.1 配置 Python](#121-%e9%85%8d%e7%bd%ae-python)
    - [1.2.2 配置 pip](#122-%e9%85%8d%e7%bd%ae-pip)
    - [1.2.3 配置 python3-venv](#123-%e9%85%8d%e7%bd%ae-python3-venv)
  - [1.2 创建和激活虚拟环境](#12-%e5%88%9b%e5%bb%ba%e5%92%8c%e6%bf%80%e6%b4%bb%e8%99%9a%e6%8b%9f%e7%8e%af%e5%a2%83)
  - [1.3 使用 django CMS installer](#13-%e4%bd%bf%e7%94%a8-django-cms-installer)
  - [1.4 启动 runserver](#14-%e5%90%af%e5%8a%a8-runserver)

## 1.1 环境要求

django CMS 要求 Django >=1.11，Python 2.7/>=3.3。下面使用 Python3。

## 1.2 配置 Python 环境

### 1.2.1 配置 Python

本地环境是 ubuntu 16.04。

```sh
# 查看本地的 Python 版本
python
# python      python2     python2.7   python3     python3.5   python3.5m  python3m
# 配置 python2.7 和 python3
sudo update-alternatives --install /usr/bin/python python /usr/bin/python2.7 100
# update-alternatives: using /usr/bin/python2.7 to provide /usr/bin/python (python) in auto mode
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 2
# 配置使用 python3，选择 2，即 /usr/bin/python3
sudo update-alternatives --config python
```

### 1.2.2 配置 pip

pip 是 Python 包管理工具。

```sh
sudo apt-get install python-pip python3-pip
# 可能会有 warning: not replacing /usr/bin/pip with a link 错误， ll /usr/bin/pip* 查看可知道 /usr/bin/pip 不是一个软链接，可以删除 /usr/bin/pip，再重新执行 --install 命令
sudo update-alternatives --install /usr/bin/pip pip /usr/bin/pip2 100
sudo update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 2
# 配置使用 pip3，选择 2，即 /usr/bin/pip3
sudo update-alternatives --config pip
```

### 1.2.3 配置 python3-venv

在 Debian/Ubuntu系统，需要使用 `apt-get install python3-venv` 命令安装 python3-venv 包。

## 1.2 创建和激活虚拟环境

```sh
# 创建虚拟环境，遇到 The virtual environment was not created successfully because ensurepip is not availabl ... 错误，参考上述教程安装 python3-venv
python -m venv env
# 激活虚拟环境
source env/bin/activate
# 升级虚拟环境的 pip
pip install --upgrade pip
```

## 1.3 使用 django CMS installer

django CMS installer 是一个帮助设置一个新项目的脚本。

```sh
# 安装 django CMS installer，安装之后可使用 djangocms 命令
(env) kiki@ubuntu:~$ pip install djangocms-installer
# 新建目录并切换到该目录
(env) kiki@ubuntu:~$ mkdir mydjango && cd mydjango
# 新建一个 django 项目
(env) kiki@ubuntu:~/mydjango$ djangocms -f -p . mysite
```

关于 `djangocms -f -p . mysite` 命令：

- `djangocms` 表示运行 django CMS installer
- `-f` 表示安装 django Filer，是用于 django 的一个文件管理应用
- `-p .` 表示使用当前目录作为新项目目录的父目录
- `mysite` 指定新项目目录的名字

installer 会创建一个管理员用户，用户名/密码 是 `admin`/`admin`。

## 1.4 启动 runserver

```sh
(env) kiki@ubuntu:~/mydjango$ python manage.py runserver
```

在浏览器打开 `http://localhost:8000/` 或 `http://127.0.0.1:8000/`，可以看到登录页面，然后可以新建页面。

当需要登录时，在 URL 后面添加 `?edit`，会启动工具栏，可以输入用户名和密码重新登录并管理网站。

当前的 Django 版本是 1.11.25，django CMS 版本是 3.6.0。
