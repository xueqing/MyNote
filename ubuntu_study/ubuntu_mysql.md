# mysql

- [mysql](#mysql)
  - [1 ubuntu 安装和配置 mysql](#1-ubuntu-安装和配置-mysql)
  - [2 mysql命令](#2-mysql命令)

## 1 ubuntu 安装和配置 mysql

- 执行`sudo apt-get install mysql-server mysql-client`
- 修改配置运行远程连接
  - `sudo vim /etc/mysql/mysql.conf.d/mysqld.cnf`
  - 注释或删除`bind-address           = 127.0.0.1`
  - 修改数据库的授权
    - `mysql -uroot -p`输入密码
    - `use mysql`
    - `GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'password' WITH GRANT OPTION;`
      - 替换 `password` 为需要设置的密码
    - `flush privileges;`
    - `exit` 退出终端
    - 重启数据库服务`sudo service mysql restart`

## 2 mysql命令

- 导出数据库`mysqldump -uroot -p bmi_nvr > bmi_nvr.sql`
- 导出数据库表`mysqldump -uroot -p bmi_nvr sip_info> bmi_nvr_sipinfo.sql`
- 导入数据表:进入 mysql 命令行后`use bmi_nvr;source /home/kiki/bmi_nvr.sql`
- mysql source 防止乱码
  - 备份`mysqldump -uroot -p --default-character-set=utf8 bmi_nvr > bmi_nvr.sql`
  - 导入`mysqldump -uroot -p --default-character-set=utf8 bmi_nvr sip_info> bmi_nvr_sipinfo.sql`
  - 进入 mysql 命令行`use bmi_nvr;source /home/kiki/bmi_nvr.sql`
