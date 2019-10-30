# 安装和配置 Apache 服务

- [安装和配置 Apache 服务](#%e5%ae%89%e8%a3%85%e5%92%8c%e9%85%8d%e7%bd%ae-apache-%e6%9c%8d%e5%8a%a1)
  - [安装 Apache](#%e5%ae%89%e8%a3%85-apache)
  - [创建自己的网站](#%e5%88%9b%e5%bb%ba%e8%87%aa%e5%b7%b1%e7%9a%84%e7%bd%91%e7%ab%99)
  - [设置 VirtualHost 配置文件](#%e8%ae%be%e7%bd%ae-virtualhost-%e9%85%8d%e7%bd%ae%e6%96%87%e4%bb%b6)
  - [激活 VirtualHost 文件](#%e6%bf%80%e6%b4%bb-virtualhost-%e6%96%87%e4%bb%b6)
  - [其他 VirtualHost 例子](#%e5%85%b6%e4%bb%96-virtualhost-%e4%be%8b%e5%ad%90)
    - [在一个 IP 地址上运行多个不同主机名的网站](#%e5%9c%a8%e4%b8%80%e4%b8%aa-ip-%e5%9c%b0%e5%9d%80%e4%b8%8a%e8%bf%90%e8%a1%8c%e5%a4%9a%e4%b8%aa%e4%b8%8d%e5%90%8c%e4%b8%bb%e6%9c%ba%e5%90%8d%e7%9a%84%e7%bd%91%e7%ab%99)
    - [在不同端口上运行不同网站](#%e5%9c%a8%e4%b8%8d%e5%90%8c%e7%ab%af%e5%8f%a3%e4%b8%8a%e8%bf%90%e8%a1%8c%e4%b8%8d%e5%90%8c%e7%bd%91%e7%ab%99)
  - [参考](#%e5%8f%82%e8%80%83)

## 安装 Apache

环境：ubuntu 16.04

```sh
sudo apt-get install update
# 安装
sudo apt-get install apache2
# 可在浏览器输入本机 ip，看到 Apache2 的欢迎页面说明服务正常
# 修改显示内容：修改 `/var/www/html` 文件夹
# 或修改配置文件，修改 /var/www/html 为 html 文件所在目录
vim /etc/apache2/sites-enabled/000-default.conf
```

## 创建自己的网站

```sh
# 新建文件夹
sudo mkdir /var/www/mysite && cd /var/www/mysite
# 创建 html 文件
vim index.html
# 在浏览器输入本机 ip，看到新的内容
```

## 设置 VirtualHost 配置文件

```sh
# 切换到配置文件目录，创建配置文件
cd /etc/apache2/sites-available && sudo cp 000-default.conf mysite.conf
# 修改配置文件，修改 ServerAdmin 为自己的邮箱
# 修改 DocumentRoot 为 /var/www/mysite，
# 修改 ServerName 为 mysite.example.com
sudo vim mysite.conf
```

## 激活 VirtualHost 文件

```sh
cd /etc/apache2/sites-available && sudo a2ensite mysite.conf
# 重新加载网页
sudo service apache2 reload
```

## 其他 VirtualHost 例子

### 在一个 IP 地址上运行多个不同主机名的网站

```conf
# Ensure that Apache listens on port 80
Listen 80
<VirtualHost *:80>
    DocumentRoot "/www/example1"
    ServerName www.example.com

    # Other directives here
</VirtualHost>

<VirtualHost *:80>
    DocumentRoot "/www/example2"
    ServerName www.example.org

    # Other directives here
</VirtualHost>
```

### 在不同端口上运行不同网站

```conf
Listen 80
Listen 8080

<VirtualHost 172.20.30.40:80>
    ServerName www.example.com
    DocumentRoot "/www/domain-80"
</VirtualHost>

<VirtualHost 172.20.30.40:8080>
    ServerName www.example.com
    DocumentRoot "/www/domain-8080"
</VirtualHost>

<VirtualHost 172.20.30.40:80>
    ServerName www.example.org
    DocumentRoot "/www/otherdomain-80"
</VirtualHost>

<VirtualHost 172.20.30.40:8080>
    ServerName www.example.org
    DocumentRoot "/www/otherdomain-8080"
</VirtualHost>
```

## 参考

- [Install and Configure Apache](https://tutorials.ubuntu.com/tutorial/install-and-configure-apache#0)
- [VirtualHost Examples](https://httpd.apache.org/docs/2.4/vhosts/examples.html)
