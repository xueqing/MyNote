# docker inspect

- [docker inspect](#docker-inspect)
  - [语法](#语法)
  - [示例](#示例)

## 语法

docker inspect 是 docker 客户端的原生命令，用于查看 docker 对象的底层基础信息。包括容器的 id、创建时间、运行状态、启动参数、目录挂载、网路配置等等。另外，该命令也可以用来查看 docker 镜像的信息。

`docker inspect [OPTIONS] NAME|ID [NAME|ID...]`

OPTIONS 说明：

- -f: 指定返回值的 go 模板文件
- -s: 显示总的文件大小
- --type: 为指定类型返回 JSON。用于指定 docker 对象类型，如：container、image。在容器与镜像同名时可以使用。默认返回容器信息

## 示例

```sh
# 获取镜像 mysql:5.6 的元信息
docker inspect mysql:5.6
[
    {
        "Id": "sha256:2c0964ec182ae9a045f866bbc2553087f6e42bfc16074a74fb820af235f070ec",
        "RepoTags": [
            "mysql:5.6"
        ],
        "RepoDigests": [],
        "Parent": "",
        "Comment": "",
        "Created": "2016-05-24T04:01:41.168371815Z",
        "Container": "e0924bc460ff97787f34610115e9363e6363b30b8efa406e28eb495ab199ca54",
        "ContainerConfig": {
            "Hostname": "b0cf605c7757",
            "Domainname": "",
            "User": "",
            "AttachStdin": false,
            "AttachStdout": false,
            "AttachStderr": false,
            "ExposedPorts": {
                "3306/tcp": {}
            },
...
# 查看目录挂载信息
docker inspect --format="{{json .Mounts}}" <container-id>
## 使用 python 的 json 模块美化
docker inspect --format="{{json .Mounts}}" <container-id> | python -m json.tool
## 使用 jq 美化
docker inspect --format="{{json .Mounts}}" <container-id> | jq
# 查看网络信息
## 查看完整网络信息
docker inspect --format="{{json .NetworkSettings}}" <container-id> | jq
## 查看网络端口映射
docker inspect --format="{{json .NetworkSettings.Ports}}" <container-id> | jq
## 查看容器的网络 ip、网关等信息
docker inspect --format="{{json .NetworkSettings.Networks}}" <container-id> | jq
## 查看镜像配置的环境变量
docker inspect xxx --format="{{json .Config.Env}}" | jq
```
