# 安装

环境：ubuntu16.04

```sh
# 安装 docker
sudo apt-get install -y docker.io
# 添加 docker 用户组
kiki@ubuntu:~$ sudo groupadd docker
[sudo] password for kiki:
groupadd: group 'docker' already exists
# 检测当前用户是否已经在 docker 用户组中
kiki@ubuntu:~$ sudo gpasswd -a kiki docker
Adding user kiki to group docker
# 更新 docker 用户组
kiki@ubuntu:~$ newgrp docker
# ok
kiki@ubuntu:~$ docker version
```
