# ubuntu 安装和配置 mysql

- 执行`sudo apt-get insall mysql-server mysql-client`
- 修改配置运行远程连接
  - `sudo vim /etc/mysql/mysql.conf.d/mysqld.cnf`
  - 注释或删除`bind-address           = 127.0.0.1`
  - 修改数据库的授权
    - `mysql -uroot -p`输入密码
    - `use mysql`
    - `GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'password' WITH GRANT OPTION;`
    - `flush privileges;`
    - 重启数据库服务`sudo service mysql restart`