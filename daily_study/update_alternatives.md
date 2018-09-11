# update-alternatives

- `update-alternatives`命令用于增加、删除、维护和显示`/etc/alternatives`下的软链接，用于切换相同或相似功能的应用程序（如浏览器、编辑器等）
  - `generic name`一系列功能相似的程序的公用名字
  - `alternative`一个可选的程序所在的路径
  - `link`一个`alternative`在`/etc/alternatives`中的名字
  - `priority`一个`alternative`的优先级，优先级越高，数字越大
- `ls -l /etc/alternatives`可以看到所有的软链接
- 显示所有可选命令：`update-alternatives --display editor`
- 选择配置命令程序：`update-alternatives --config editor`
- 安装命令程序：`update-alternatives --install link generic_name path priority`
  - `update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 100`
- 删除命令程序：`update-alternatives --remove name path`