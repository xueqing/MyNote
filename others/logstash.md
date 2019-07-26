# logstash 配置文件学习

## 配置文件举例

- 默认位置是 `/usr/local/logstash/config/logstash-sample.conf`

### 匹配需求描述

- 先需要统计后台服务的日志, 主要有下面 4 类

| 日志类型 | 格式 | 举例 |
| --- | --- | --- |
| 服务器日志 | `[localtime][log_level][module_name] {event_info}` | `[2019-07-25 09:26:57.315][debug ][EasyRedis] {Connect Redis success}` |
| 设备认证日志 | `[localtime][log_level][module_name][dev_name][dev_id][dev_ip] {event_info}` | `[2019-07-25 09:26:07.317][warn  ][GbsipServerService][cam1][34020000001320000001][192.168.10.199] {ON}` |
| 用户认证日志 | `[localtime][log_level][module_name][user_id][user_ip] {event_info}` | `[2019-07-25 09:26:14.049][warn  ][GbsipClientService][34020000001110000001][192.168.1.160] {online}` |
| 用户操作日志 | `[localtime][log_level][module_name][user_id][user_ip][dev_id] {event_info}` | `[2019-07-25 09:38:31.630][trace ][GbsipClientService][34020000001110000001][192.168.1.160][34020000001320000001] {Bye}` |

- 现在的需求包括
  - 1 过滤掉不符合上述 4 类格式的日志
  - 2 可以一键搜索上述 4 种日志, 即查看所有满足要求的日志
  - 3 可以一键搜索上述任意一种日志
- 实现方法
  - 统一日志格式 `[type][localtime][log_level][module_name][user_id][user_ip][dev_name][dev_id][dev_ip] {event_info}`
  - 缺少的字段为空
  - filter 的正则匹配表达式为 `\[%{DATA:localtime}\]\[%{DATA:log_level}\]\[%{DATA:module_name}\]\[%{NUMBER:type}\]\[%{DATA:user_id}\]\[%{DATA:user_ip}\]\[%{DATA:dev_name}\]\[%{DATA:dev_id}\]\[%{DATA:dev_ip}\]\ \{%{DATA:event_info}\}`, 可用于分割日志
- 统一后日志举例

```txt
[2019-07-25 09:26:57.315][debug ][EasyRedis][1][][][][][] {Connect Redis success}
[2019-07-25 09:26:07.317][warn  ][GbsipServerService][2][][][cam1][34020000001320000001][192.168.10.199] {ON}
[2019-07-25 09:26:14.049][warn  ][GbsipClientService][3][34020000001110000001][192.168.1.160][][][] {online}
[2019-07-25 09:38:31.630][trace ][GbsipClientService][4][34020000001110000001][192.168.1.160][][34020000001320000001][] {Bye}
```

### 日志收集架构

- [filebeat](https://www.elastic.co/products/beats/filebeat)
  - 轻量级日志收集工具, 用于搜集文件数据, 比 logstash 占用资源更少
  - 在 `filebeat.yml` 中会配置指定的监听文件
- [logstash](https://www.elastic.co/products/logstash)
  - 用于日志收集, 具有 filter 功能, 可以过滤分析日志, 然后发送到消息队列
- [kibana](https://www.elastic.co/products/kibana)
  - 供前端的页面再进行搜索和图表可视化, 调用Elasticsearch的接口返回的数据进行可视化
  - 用 Kibana 来搜索、查看, 并和存储在 ElasticSearch 索引中的数据进行交互
- [ElasticSearch](https://www.elastic.co/)
  - 搜索服务器, 提供了一个分布式多用户能力的全文搜索引擎, 基于 RESTful web 接口

### 完整配置文件

```conf
# Sample Logstash configuration for creating a simple
# Beats -> Logstash -> Elasticsearch pipeline.

input {
  # 从日志文件中获取信息, 使用 filebeat 推送日志到 logstash
  beats {
    port => 5044
  }
}

filter {
  # 如果搜索不到 "] {" 关键字, 丢弃该消息
  # 其他日志内容均保证不含 "] {" 关键字
  if "] {" not in [message] {
    # drop 可以跳过某些不想统计的日志信息, 当某条日志信息符合 if 规则时
    # 该条信息则不会在 out 中出现, logstash 将直接进行下一条日志的解析
    drop { }
  } else {
    grok {
      # 自定义正则匹配
      match => {"message" => "\[%{DATA:localtime}\]\[%{DATA:log_level}\]%{DATA:c1}\[%{DATA:c2}\[%{DATA:module_name}\]\[%{NUMBER:type}\]\[%{DATA:user_id}\]\[%{DATA:user_ip}\]\[%{DATA:dev_name}\]\[%{DATA:dev_id}\]\[%{DATA:dev_ip}\]\ \{%{DATA:event_info}\}"}
    }

    # 匹配服务器日志成功
    if "[1]" in [message] {
      # mutate 是做转换用的
      mutate {
          # 添加字段 _log_info_, 便于搜索所有日志
          add_field => {
            "_log_info_" => "%{event_info}"
          }
          # 添加字段 _serv_log_, 便于搜索服务器日志
          add_field => {
            "_serv_log_" => "%{event_info}"
          }
      }
    }
    # 匹配设备认证日志成功
    if "[2]" in [message] {
      mutate {
          add_field => {
            "_log_info_" => "[%{dev_name}] [%{dev_id}] [%{dev_ip}] %{event_info}"
          }
          # 添加字段 _dev_log_, 便于搜索服务器日志
          add_field => {
            "_dev_log_" => "[%{dev_name}] [%{dev_id}] [%{dev_ip}] %{event_info}"
          }
      }
    }
    # 匹配用户认证日志成功
    if "[3]" in [message] {
      mutate {
          add_field => {
            "_log_info_" => "[%{user_id}] [%{user_ip}] %{event_info}"
          }
          # 添加字段 _user_log_, 便于搜索服务器日志
          add_field => {
            "_user_log_" => "[%{user_id}] [%{user_ip}] %{event_info}"
          }
      }
    }
    # 匹配用户操作日志成功
    if "[4]" in [message] {
      mutate {
          add_field => {
            "_log_info_" => "[%{user_id}] [%{user_ip}] [%{dev_id}] %{event_info}"
          }
          # 添加字段 _user_dev_log_, 便于搜索服务器日志
          add_field => {
            "_user_dev_log_" => "[%{user_id}] [%{user_ip}] [%{dev_id}] %{event_info}"
          }
      }
    }
  }
}

output {
  # 将输出保存到 elasticsearch
  elasticsearch {
    hosts => ["http://192.168.1.240:9200"]
    index => "%{[@metadata][beat]}-%{[@metadata][version]}-%{+YYYY.MM.dd}"
  }
}
```
