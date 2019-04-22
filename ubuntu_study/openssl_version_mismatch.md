# OpenSSL 版本不兼容

```sh
# git 命令失败
ssh: /usr/local/lib/libcrypto.so.1.0.0: no version information available (required by ssh)
ssh: /usr/local/lib/libcrypto.so.1.0.0: no version information available (required by ssh)
OpenSSL version mismatch. Built against 1000207f, you have 1000103f
# ssh 可执行文件链接库
ldd /usr/bin/ssh
/usr/bin/ssh: /usr/local/lib/libcrypto.so.1.0.0: no version information available (required by /usr/bin/ssh)
/usr/bin/ssh: /usr/local/lib/libcrypto.so.1.0.0: no version information available (required by /usr/bin/ssh)
        linux-vdso.so.1 =>  (0x00007fff3fdc1000)
        libselinux.so.1 => /lib/x86_64-linux-gnu/libselinux.so.1 (0x00007f30e3f81000)
        libcrypto.so.1.0.0 => /usr/local/lib/libcrypto.so.1.0.0 (0x00007f30e3b96000)# this line is differeent
        libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007f30e3992000)
        libz.so.1 => /lib/x86_64-linux-gnu/libz.so.1 (0x00007f30e3778000)
        libresolv.so.2 => /lib/x86_64-linux-gnu/libresolv.so.2 (0x00007f30e355d000)
        libgssapi_krb5.so.2 => /usr/lib/x86_64-linux-gnu/libgssapi_krb5.so.2 (0x00007f30e3313000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f30e2f49000)
        libpcre.so.3 => /lib/x86_64-linux-gnu/libpcre.so.3 (0x00007f30e2cd9000)
        /lib64/ld-linux-x86-64.so.2 (0x00007f30e4453000)
        libkrb5.so.3 => /usr/lib/x86_64-linux-gnu/libkrb5.so.3 (0x00007f30e2a07000)
        libk5crypto.so.3 => /usr/lib/x86_64-linux-gnu/libk5crypto.so.3 (0x00007f30e27d8000)
        libcom_err.so.2 => /lib/x86_64-linux-gnu/libcom_err.so.2 (0x00007f30e25d4000)
        libkrb5support.so.0 => /usr/lib/x86_64-linux-gnu/libkrb5support.so.0 (0x00007f30e23c9000)
        libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0 (0x00007f30e21ac000)
        libkeyutils.so.1 => /lib/x86_64-linux-gnu/libkeyutils.so.1 (0x00007f30e1fa8000)
# 正常情况下查看 ssh 可执行文件链接库
ldd /usr/bin/ssh
        linux-vdso.so.1 =>  (0x00007fff59ca9000)
        libselinux.so.1 => /lib/x86_64-linux-gnu/libselinux.so.1 (0x00007f324fa4d000)
        libcrypto.so.1.0.0 => /lib/x86_64-linux-gnu/libcrypto.so.1.0.0 (0x00007f324f608000)# this line is differeent
        libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007f324f404000)
        libz.so.1 => /lib/x86_64-linux-gnu/libz.so.1 (0x00007f324f1ea000)
        libresolv.so.2 => /lib/x86_64-linux-gnu/libresolv.so.2 (0x00007f324efcf000)
        libgssapi_krb5.so.2 => /usr/lib/x86_64-linux-gnu/libgssapi_krb5.so.2 (0x00007f324ed85000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f324e9bb000)
        libpcre.so.3 => /lib/x86_64-linux-gnu/libpcre.so.3 (0x00007f324e74b000)
        /lib64/ld-linux-x86-64.so.2 (0x00007f324ff1f000)
        libkrb5.so.3 => /usr/lib/x86_64-linux-gnu/libkrb5.so.3 (0x00007f324e479000)
        libk5crypto.so.3 => /usr/lib/x86_64-linux-gnu/libk5crypto.so.3 (0x00007f324e24a000)
        libcom_err.so.2 => /lib/x86_64-linux-gnu/libcom_err.so.2 (0x00007f324e046000)
        libkrb5support.so.0 => /usr/lib/x86_64-linux-gnu/libkrb5support.so.0 (0x00007f324de3b000)
        libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0 (0x00007f324dc1e000)
        libkeyutils.so.1 => /lib/x86_64-linux-gnu/libkeyutils.so.1 (0x00007f324da1a000)
```

- 原因
  - 在 ubuntu 编译了一个 OpenSSL 的源码，并执行了`sudo make install`。 Ubuntu 自带的 OpenSSL 版本带有额外的补丁，包含版本信息等，但是标准的 OpenSSL 库(1.1.0 之前)是没有版本信息的。OpenSSH 在运行时链接到源码编译的 OpenSSL 库，没有这些版本信息符号
  - OpenSSH 和 OpenSSL 的安装顺序是有一定限制的，可单独升级 OpenSSH，但升级了 OpenSSL 之后，需要重新编译 OpenSSH 或升级，否则不能使用 OpenSSH
- 解决方法
  - 删除`/usr/local/include/openssl`
  - 删除`/usr/local/lib/libcrypto.*`
  - 删除`/usr/local/lib/libssl.*`
