# go 集合

- map 是一种无序的键值对的集合，可以通过 key 快速检索数据，使用 hash 表实现
- 定义集合
  - `var map_name[key_type]val_type`
  - 使用 make 函数`map_name := make(map[key_type]val_type)`
- 不初始化 map，得到的是一个 nil map，不能用于存放键值对
- 使用 map_name[val_name] 查看元素在集合中是否存在
  - 如果元素存在，返回的第一个元素是对应的键，第二个元素是 true
  - 元素不存在，在返回第二个元素是 false
- delete() 函数用于删除集合的元素`delete(map_name, key)`，指定元素名和对应的键