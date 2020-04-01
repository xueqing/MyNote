# ldconfig

- [ldconfig](#ldconfig)
  - [ldconfig 与 /etc/ld.so.conf](#ldconfig-%e4%b8%8e-etcldsoconf)
    - [添加动态库路径](#%e6%b7%bb%e5%8a%a0%e5%8a%a8%e6%80%81%e5%ba%93%e8%b7%af%e5%be%84)
  - [ldd](#ldd)

## ldconfig 与 /etc/ld.so.conf

- `ldconfig` 默认查找的路径包括 `lib`, `/usr/lib`, `/etc/ld.so.conf` 列举的目录和 `LD_LIBRARY_PATH`
- 如何将动态函数库加载到高速缓存
  - 在 `/etc/ld.so.conf` 写入想要读入告诉缓存中的动态函数库所在的目录
  - 利用 `ldconfig` 可执行文件将 `/etc/ld.so.conf` 的数据读入缓存
  - 同时将数据记录一份在 `/etc/ld.so.cache` 文件

### 添加动态库路径

库文件在链接(静态库和共享库)和运行(仅限于使用共享库的程序)时被使用，其搜索路径是在系统中进行设置的。一般 Linux 系统把 `/lib` 和 `/usr/lib` 两个目录作为默认的库搜索路径，所以使用这两个目录中的库是不需要进行设置搜索路径即可直接使用。

- 查找库路径 `sudo find / -iname *library_name*.so*`
- 方法 1
  - 追加路径到 `LD_LIBRARY_PATH`
    - 当前终端生效: 在终端执行 `export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/path/to/library`
    - 在 `~/.bashrc` 或 `~/.bash_profile` 中追加 `export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/path/to/library`
  - 执行 `source ~/.bashrc` 或 `source ~/.bash_profile`
  - 执行 `sudo ldconfig` 更新缓存
- 方法 2
  - 在 `/etc/ld.so.conf.d/` 中创建一个新文件 `your_lib.conf`
  - 在 `/etc/ld.so.conf.d/your_lib.conf` 中写入想要添加的路径
  - 执行 `sudo ldconfig` 更新缓存
- 方法 3
  - 将库移动到 `/usr/lib`
  - 执行 `sudo ldconfig` 更新缓存

## ldd

- `ldd filename` 可以显示可执行文件 filename 所依赖的动态函数库
