# apt cache

使用 `apt-cache` 命令搜索包

```sh
# 搜索包名称及其简短描述，并根据该结果显示结果
apt-cache search <search term>
# 搜索具有特定包名称的包
apt-cache pattern <search_term>
# 获取指定包的更多信息，例如版本，依赖关系
apt-cache showpkg <package_name>
```
