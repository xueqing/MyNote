# 安装

环境：ubuntu16.04

```sh
# 安装 docker
sudo apt-get install docker.io
# 启动 docker
sudo /etc/init.d/docker start
# 创建 docker 用户组
sudo groupadd docker
# 应用用户 kiki 加入 docker 用户组
sudo usermod -aG docker kiki
# 重启 docker 服务
sudo /etc/init.d/docker restart
# 切换或者退出当前账户再从新登入
su root     # 切换到root用户
su kiki  # 再切换到原来的应用用户以上配置才生效
```
