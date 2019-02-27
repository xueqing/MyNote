# 修改 hosts 文件

## ubuntu

公司内部添加了域名服务器，每次将域名改成 IP 地址很麻烦，所以修改本地 hosts 可以直接重定向
`sudo vim /etc/hosts`

## windows

- 搜索程序“记事本”，用管理员身份打开
- 在记事本中打开文件，路径是`C:\Windows\System32\drivers\etc`，选择`所有文件`
- 可以看到`hosts`文件，选中打开进行修改，保存就可以了