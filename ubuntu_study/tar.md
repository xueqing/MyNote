# tar 命令

- [tar 命令](#tar-命令)
  - [常用的 tar 命令](#常用的-tar-命令)
  - [参考](#参考)

## 常用的 tar 命令

```sh
# 压缩
tar -zcvpf filename.tar.gz dir1 dir2 ...
# 查看压缩包，不解压
tar -tvf filename.tar.gz
# 解压缩
tar -xvf filename.tar.gz
# 合并多个 tar.gz 文件
cat f1.tar.gz f2.tar.gz f3.tar.gz > merged.tar.gz
# 查看合并的 tar.gz 文件(必须指定 -i/--ignore-zeros)
tar -tvif merged.tar.gz
# 解压缩合并的 tar.gz 文件(必须指定 -i/--ignore-zeros)
tar -xvif merged.tar.gz
```

## 参考

- [Optimal way to combine tar.gz files quickly](https://superuser.com/questions/1122438/optimal-way-to-combine-tar-gz-files-quickly)
