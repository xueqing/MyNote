# ubuntu 的日志文件

- 日志文件存在`/var/log`即其子目录
  - `message`: 
  - `auth.log`: 鉴权日志
  - `kern.log`: 内核日志
  - `mysql/`: mysql 数据库服务日志文件
  - `utmp`或`wtmp`: 
- 查看日志文件的命令
  - less:`less /var/log/messages`
  - more:`more -f /var/log/messages`
  - cat:`cat /var/log/messages`
  - grep:`grep -i error /var/log/message`
  - tail:`tail -f /var/log/messages`
  - zcat
  - zgrep
  - zmore
- 上面的日志都有使用 rsyslogd 服务生成的。这是一个系统工具。
  - 配置文件在`vim /etc/rsyslog.conf`
  - 日志目录`ls /etc/rsyslog.d/`
