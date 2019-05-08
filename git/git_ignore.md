# 关于 gitignore 文件

- [关于 gitignore 文件](#%E5%85%B3%E4%BA%8E-gitignore-%E6%96%87%E4%BB%B6)
  - [通配符](#%E9%80%9A%E9%85%8D%E7%AC%A6)
  - [斜线](#%E6%96%9C%E7%BA%BF)
  - [两个星号](#%E4%B8%A4%E4%B8%AA%E6%98%9F%E5%8F%B7)
  - ["!" 取消忽视](#%22%22-%E5%8F%96%E6%B6%88%E5%BF%BD%E8%A7%86)
  - [ignore 模板](#ignore-%E6%A8%A1%E6%9D%BF)

## 通配符

- `*` 匹配除了 `/` 的所有字符
- `?` 匹配除了 `/` 的所有单字符
- `[]` 匹配给定范围的一个字符

## 斜线

- 行首第一个 `/` 匹配路径的开始, 以 `.gitignore` 当前所在路径计算相对路径
- 如 `/*.txt` 匹配与 `.gitignore` 同一路径下的 txt 文件, 不包含 `.gitignore` 当前路径下子文件内的 txt 文件
  - `test/*.txt` 路径的开始是 `t` 而不是 `/`

## 两个星号

- `**/` 匹配所目录
- `/**` 匹配包含的所有内容, 包括文件和文件夹, 以及子文件和子文件下的文件
- `/**/` 匹配 0 个或多个目录

## "!" 取消忽视

- `!pattern` 否认 pattern, 即前一个 pattern 匹配的文件会再被包含
- 注意: 如果一个文件的父文件夹被忽略, 那么 git 不能再包含该文件
- 忽视除了 /build/debug 下 除了 snap 的文件和文件夹

```ignore
## 前两句可互换顺序
build/debug/*
!build/debug
!build/debug/snap
## 如果包含下面的语句则不能再包含 snap 文件和文件夹
# build
# build/
# build/**
```

## ignore 模板

- [参考](https://github.com/github/gitignore)