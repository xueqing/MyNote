# mysql命令

- 导出数据库`mysqldump -uroot -p bmi_nvr > bmi_nvr.sql`
- 导出数据库表`mysqldump -uroot -p bmi_nvr sip_info> bmi_nvr_sipinfo.sql`
- 导入数据表:进入 mysql 命令行后`use bmi_nvr;source /home/kiki/bmi_nvr.sql`
- mysql source 防止乱码
  - 备份`mysqldump -uroot -p --default-character-set=utf8 bmi_nvr > bmi_nvr.sql`
  - 导入`mysqldump -uroot -p --default-character-set=utf8 bmi_nvr sip_info> bmi_nvr_sipinfo.sql`
  - 进入 mysql 命令行`use bmi_nvr;source /home/kiki/bmi_nvr.sql`
