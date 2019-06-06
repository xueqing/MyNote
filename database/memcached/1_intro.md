# 1 Memcached 简介

- [1 Memcached 简介](#1-memcached-%E7%AE%80%E4%BB%8B)
  - [1.1 前言](#11-%E5%89%8D%E8%A8%80)
  - [1.2 特点](#12-%E7%89%B9%E7%82%B9)
  - [1.3 支持的语言](#13-%E6%94%AF%E6%8C%81%E7%9A%84%E8%AF%AD%E8%A8%80)
  - [1.4 Memcached 用户](#14-memcached-%E7%94%A8%E6%88%B7)

## 1.1 前言

- Memcached 是一个自由开源、高性能、分布式内存对象缓存系统
- 基于内存的 key-value 存储，用于存储小块的任意数据(字符串、对象)。这些数据可以是数据库调用、API 调用或页面渲染的结果
- 设计简洁：便于快速开发，减轻开发难度，解决了大数据量缓存的问题。API 兼容大部分流行的开发语言
- 本质上是一个简洁的 key-value 存储系统
- 一般的使用目的：通过缓存数据库查询结果，减少数据库访问次数，以提高动态 web 应用的速度，提高可扩展性

## 1.2 特点

- 协议简单
- 基于 libevent 的事件处理
  - libevent 是一个基于事件触发的网络库
  - libevent API 提供一种机制：当一个文件描述符的特定时间发生(可读、可写、出错)，或一个定时时间发生，libevent 自动执行用户指定的回调函数，来处理事件
  - libevent 也支持信号或常规超时的回调
  - libevent 用于取代网络服务器中的事件循环检查框架
- 内置内存存储方式
- 分布式不互相通信

## 1.3 支持的语言

- 许多语言实现了连接 Memcached 的客户端，以 Perl、PHP 为主
- 其他语言包括：Python/Ruby/C#/C/C++/Lua

## 1.4 Memcached 用户

LiveJournal/Wikipedia/Flickr/Bebo/Twitter/Typepad/Yellowbot/Youtube/WordPress.com/Craigslist/Mixi
