# linux 下其他命令

- 添加可执行权限`chmod a+x filename`
- 修改本机 IP 地址`ifconfig eth0 192.168.1.110`
- 列举目录`ls -lt`按时间顺序显示
- 查看所有用户`cat /etc/passwd`
- 查看所有用户组`cat /etc/group`
- 添加用户到已存在的组：
  - `sudo adduser user-name user-group`
  - `sudo gpasswd -a user-name group-name`
- 从用户组删除删除`：`sudo gpasswd -d user-name user-group`
- 安装 deb 文件缺少依赖库时继续执行`sudo apt-get install -f`即可自动安装依赖库并安装 deb 包

## 文件格式

- `/bin/sh^M: bad interpreter: No such file or directory`脚本异常，转换为 UNIX 格式
  - windows：UE 或 EditPlus 转换编码为UNIX
  - Linux：
    - 可执行权限`chmod a+x filename`
    - 改文件格式`vi filename`
      - 查看文件格式
        - `:set ff`或`:set fileformat`
        - `Fileformat=dos`或`fileformat=unix`
      - 修改文件格式`:set ff=unix或:set fieformat=unix`
      - 保存退出`:wq`
    - 执行文件`./filename`