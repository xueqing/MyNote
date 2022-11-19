# 推送数据

```sh
# 将本地的 master 分支推送至 origin 服务器的 dev 分支
git push origin master:dev
git push url master
# 将已有项目直接推送到新的地址时，报错 " ! [remote rejected] master -> master (shallow update not allowed)"
# 是因为之前拉源码时加了 "depth=1"，解决方法
git fetch --unshallow old_rep_url
git push new_rep_url master
```
