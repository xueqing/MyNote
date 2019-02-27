# ldconfig

- [ldconfig](#ldconfig)
  - [ldconfig 与 /etc/ld.so.conf](#ldconfig-%E4%B8%8E-etcldsoconf)
    - [添加动态库路径](#%E6%B7%BB%E5%8A%A0%E5%8A%A8%E6%80%81%E5%BA%93%E8%B7%AF%E5%BE%84)
  - [ldd](#ldd)

## ldconfig 与 /etc/ld.so.conf

- `ldconfig` 默认查找的路径包括 `lib`, `/usr/lib`, `/etc/ld.so.conf` 列举的目录和 `LD_LIBRARY_PATH`
- 如何将动态函数库加载到高速缓存
  - 在 `/etc/ld.so.conf` 写入想要读入告诉缓存中的动态函数库所在的目录
  - 利用 `ldconfig` 可执行文件将 `/etc/ld.so.conf` 的数据读入缓存
  - 同时将数据记录一份在 `/etc/ld.so.cache` 文件

### 添加动态库路径

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