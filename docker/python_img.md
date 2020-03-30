# 制作 Python 运行环境镜像

- [制作 Python 运行环境镜像](#%e5%88%b6%e4%bd%9c-python-%e8%bf%90%e8%a1%8c%e7%8e%af%e5%a2%83%e9%95%9c%e5%83%8f)
  - [拉取基础镜像](#%e6%8b%89%e5%8f%96%e5%9f%ba%e7%a1%80%e9%95%9c%e5%83%8f)
  - [编写 Dockerfile](#%e7%bc%96%e5%86%99-dockerfile)
  - [制作镜像](#%e5%88%b6%e4%bd%9c%e9%95%9c%e5%83%8f)
  - [更新镜像](#%e6%9b%b4%e6%96%b0%e9%95%9c%e5%83%8f)
    - [安装 Sphinx + ReadTheDocs 支持](#%e5%ae%89%e8%a3%85-sphinx--readthedocs-%e6%94%af%e6%8c%81)
      - [方法 1：进入镜像内部更新镜像](#%e6%96%b9%e6%b3%95-1%e8%bf%9b%e5%85%a5%e9%95%9c%e5%83%8f%e5%86%85%e9%83%a8%e6%9b%b4%e6%96%b0%e9%95%9c%e5%83%8f)
      - [方法 2：编写新的 Dockerfile](#%e6%96%b9%e6%b3%95-2%e7%bc%96%e5%86%99%e6%96%b0%e7%9a%84-dockerfile)
  - [推送镜像](#%e6%8e%a8%e9%80%81%e9%95%9c%e5%83%8f)
    - [推送到官方仓库 Docker Hub](#%e6%8e%a8%e9%80%81%e5%88%b0%e5%ae%98%e6%96%b9%e4%bb%93%e5%ba%93-docker-hub)
    - [推送到私有仓库 xxx](#%e6%8e%a8%e9%80%81%e5%88%b0%e7%a7%81%e6%9c%89%e4%bb%93%e5%ba%93-xxx)

## 拉取基础镜像

```sh
docker pull ubuntu:16.04
```

## 编写 Dockerfile

```sh
# 创建目录
mkdir docker-image/python && cd docker-image/python
# 编写 Dockerfile
```

```Dockerfile
FROM ubuntu:16.04
MAINTAINER kiki
# 更新 apt
RUN  apt-get update && apt-get install -y
# 安装依赖
RUN  apt-get install gcc -y \
  && apt-get install make -y \
  && apt-get install vim -y \
  && apt-get install openssl -y \
  && apt-get install libssl-dev -y \
  && apt-get install python3.5 -y \
  && apt-get install python3-pip -y
CMD ["pip3"]
CMD ["python3"]
```

安装出现警告信息 `debconf: delaying package configuration, since apt-utils is not installed`。解决方法：

```sh
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
```

安装出现错误信息 `E: Unable to fetch some archives, maybe run apt-get update or try with --fix-missing?`。解决方法：

```sh
sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list
```

## 制作镜像

```sh
docker build -t python3 .
# 查看镜像
docker images
# 运行容器
docker run -i -t python3 /bin/bash
# 进入 docker 之后，运行 python3 和 pip3
python3
pip3
```

## 更新镜像

### 安装 Sphinx + ReadTheDocs 支持

#### 方法 1：进入镜像内部更新镜像

```sh
# 在 docker 内部安装相关依赖
pip3 install sphinx sphinx-autobuild sphinx_rtd_theme recommonmark pypandoc
# 提交更新
docker commit -m="add Sphinx + ReadTheDocs support" -a="kiki" CONTAINER-ID sphinx-rtd
# 查看新镜像
docker images
# 启动新镜像
docker run -i -t -v sphinx-rtd /bin/bash
# 给镜像设置标签
docker tag CONTAINER-ID compile-blog
```

安装 Python 包遇到错误：`requests.packages.urllib3.exceptions.ReadTimeoutError: HTTPSConnectionPool(host='files.pythonhosted.org', port=443): Read timed out`。解决方法：

```sh
# 在 Dockerfile 中增加下面的参数
pip3 --default-timeout=1000 install sphinx sphinx-autobuild sphinx_rtd_theme recommonmark pypandoc
```

#### 方法 2：编写新的 Dockerfile

```Dockerfile
FROM python3
MAINTAINER kiki
# 安装依赖
RUN pip3 --default-timeout=1000 install sphinx sphinx-autobuild sphinx_rtd_theme recommonmark pypandoc
CMD ["pip3"]
CMD ["python3"]
```

```sh
docker build -t sphinx-rtd .
# 查看镜像
docker images
# 运行容器
docker run -i -t sphinx-rtd /bin/bash
# 进入 docker 之后，运行 python3 和 pip3
python3
pip3
```

## 推送镜像

### 推送到官方仓库 Docker Hub

```sh
docker login -u username -p password
docker push sphinx-rtd
docker logout
```

### 推送到私有仓库 xxx

```sh
# 参考 https://github.com/docker/docker.github.io/blob/master/registry/insecure.md 设置 http 连接
# 给镜像添加标签
docker tag sphinx-rtd xxx:sphinx-rtd
# 推送镜像
docker push xxx:sphinx-rtd
```
