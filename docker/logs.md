# docker logs

- [docker logs](#docker-logs)
  - [语法](#语法)
  - [示例](#示例)

## 语法

docker logs 用于获取容器的日志。

`docker logs [OPTIONS] CONTAINER`

OPTIONS 说明：

- --details: 显示提供给日志的额外详细信息
- -f/--follow: 跟踪日志输出
  - --since string: 显示某个时间之后的日志，时间可以是时间戳(`yyyy-mm-ddThh:mm:ss`)或相对时间(`42m` 表示显示 42 分钟之内的日志)
  - --tail string: 仅显示从日志末尾开始的 N 条容器日志，默认(`all`)显示所有日志
- -t/--timestamps: 显示时间戳
  - --until string: 显示某个时间之前的日志，时间可以是时间戳(`yyyy-mm-ddThh:mm:ss`)或相对时间(`42m` 表示显示 42 分钟之前的日志)

## 示例

```sh
# 跟踪查看容器 mysql:5.6 的日志输出
docker logs -f mysql:5.6
# 查看容器从 2021/11/1 之后的最新 100 条日志
docker logs --since="2021-11-01" --tail=100 <container-id>
```
