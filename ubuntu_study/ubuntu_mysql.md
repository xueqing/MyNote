# mysql

- [mysql](#mysql)
  - [1 ubuntu 安装和配置 mysql](#1-ubuntu-安装和配置-mysql)
    - [1.1 mysql 升级之后上述修改数据库授权的方法会报错](#11-mysql-升级之后上述修改数据库授权的方法会报错)
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

### 1.1 mysql 升级之后上述修改数据库授权的方法会报错

如果在 ubuntu20.04，mysql 服务默认版本是 8.0.28-0ubuntu0.20.04.3。执行上述命令会报错 `ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'IDENTIFIED BY 'password' WITH GRANT OPTION' at line 1`。原因是 MySQL 8 之后，不能使用 `GRANT` 命令隐式创建用户。需要使用 `CREATE USER` 命令，再使用 `GRANT` 语句。可以[参考](https://stackoverflow.com/questions/50177216/how-to-grant-all-privileges-to-root-user-in-mysql-8-0#:~:text=Starting%20with%20MySQL%208%20you%20no%20longer%20can,PRIVILEGES%20ON%20%2A.%2A%20TO%20%27root%27%40%27%25%27%20WITH%20GRANT%20OPTION%3B)。

```sh
mysql> CREATE USER 'root'@'%' IDENTIFIED BY 'password';
mysql> GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
mysql> FLUSH PRIVILEGES;
```

## 2 mysql命令

- 导出数据库`mysqldump -uroot -p bmi_nvr > bmi_nvr.sql`
- 导出数据库表`mysqldump -uroot -p bmi_nvr sip_info> bmi_nvr_sipinfo.sql`
- 导入数据表:进入 mysql 命令行后`use bmi_nvr;source /home/kiki/bmi_nvr.sql`
- mysql source 防止乱码
  - 备份`mysqldump -uroot -p --default-character-set=utf8 bmi_nvr > bmi_nvr.sql`
  - 导入`mysqldump -uroot -p --default-character-set=utf8 bmi_nvr sip_info> bmi_nvr_sipinfo.sql`
  - 进入 mysql 命令行`use bmi_nvr;source /home/kiki/bmi_nvr.sql`
