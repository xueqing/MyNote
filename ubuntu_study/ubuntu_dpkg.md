# dpkg 安装和卸载程序

- `sudo dpkg -i *.deb`安装服务
- 卸载服务
  - `dpkg -l | grep xxx`查看包是否正确安装
    - 第一列的`ii`指的是`installed ok installed`
  - `dpkg -r xxx`移除安装包，但是保留配置文件
  - `dpkg -P/--purge xxx`完全移除安装包，包括配置文件
  - 再用`dpkg -l | grep xxx`查看安装状态
    - 使用`-r`移除，可以看到第一列的的状态是`rc`
    - 使用`-P`移除，输出为空，找不到对应条目