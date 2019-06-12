# ubuntu 安装 wireshark

- 命令行安装 `sudo apt-get install wireshark`
- 配置非 root 访问
  - 添加 wireshark 用户组 `sudo groupadd wireshark`
  - 将 dumpcap 更改为 wireshark 用户组 `sudo chgrp wireshark /usr/bin/dumpcap`
  - 让 wireshark 用户组有 root 权限使用 dumpcap `sudo chmod 4755 /usr/bin/dumpcap`
  - 将普通用户加入 wireshark 用户组 `sudo gpasswd -a kiki wireshark`
