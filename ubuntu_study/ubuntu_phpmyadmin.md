# ubuntu 安装 phpmyadmin

- 执行`sudo apt-get install phpmyadmin`
- 建立软链接`sudo ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin`
- 在浏览器打开网址`localhost/phpmyadmin`

## 一些错误

- 打开网页错误`the mbstring extension is missing. please check your php configuration`
  - 安装包`sudo apt-get install php-mbstring php-gettext`
  - 重启 Apache 服务`sudo service apache2 restart`
