# Docker registry V2 命令

```sh
# 推送镜像
docker push registry_ip:registry_port/image_name:image_tag
# 拉取镜像
docker pull registry_ip:registry_port/image_name:image_tag
# 搜索镜像：registry v2 不支持 search 命令，会报错 Error response from daemon: Unexpected status code 404”
##  需要通过 REST API 查询
### 1. 列出所有镜像仓库
curl http://registry_ip:registry_port/v2/_catalog
curl -X GET http://registry_ip:registry_port/v2/_catalog
### 2. 列出指定镜像的所有标签
curl http://registry_ip:registry_port/v2/image_name/tags/list
curl -X GET http://registry_ip:registry_port/v2/image_name/tags/list
# 删除镜像：需要先查到指定标签镜像的 digest(sha256 校验和)，再根据 digest 删除镜像
### 3. 获取指定标签镜像的 digest(sha256 校验和)，查看 Docker-Content-Digest 字段内容
curl -H "Accept: application/vnd.docker.distribution.manifest.v2+json" -I http://registry_ip:registry_port/v2/image_name/manifests/<tag>
curl -H "Accept: application/vnd.docker.distribution.manifest.v2+json" -I -X GET http://registry_ip:registry_port/v2/image_name/manifests/<tag>
### 4. 根据 digest 删除镜像
curl -X DELETE http://registry_ip:registry_port/v2/image_name/manifests/digest_hash
# 如果报错 {"errors":[{"code":"UNSUPPORTED","message":"The operation is unsupported."}]}，
# 需要更改 registry 容器内的 / etc/docker/registry/config.yml 文件，修改 storage.delete.enabled 为 true
## 修改方法：docker cp registry:/etc/docker/registry/config.yml .
## 修改之后拷贝回镜像：docker cp config.yml registry:/etc/docker/registry/config.yml
## 然后重启：docker restart registry
## 再次执行命令 4
# 垃圾回收
docker exec registry bin/registry garbage-collect /etc/docker/registry/config.yml
```
