# hash map

```cpp
class hash_map {
  hash_map() {set_load(); v.reserve(max_load*b.size());}
  // 表“太满”(如 75% 满)时性能会恶化
  void set_load(float m=0.7, float g=1.6) {max_load=m; grow=g;}

  // 查找
  mapped_type& operator[] (const key_type& k) {
    // 先计算散列值，查找表索引
    size_type i = hash(k) % b.size();
    // 找到之后遍历散列链匹配
    for(Entry* p=b[i]; p; p=p->next) {
      if(eq(k, p->key)) { // 找到则插入表
        if(p->erased) {
          p->erased = false;
          no_of_erased--;
          return p->val = default_value;
        }
        return p->val;
      }
    }
    // 找不到则插入散列表
    // 若表已经“满”了，增大存储
    if(size_tye(b.size() * max_load) <= v.size()) {
      resize(b.size() * grow);
      return operator[](k);
    }
    // 插入元素
    v.push_back(Entry(k, default_value, b[i]));
    b[i] = &v.back();
    return b[i]->val;
  }

  // 调整散列表大小
  void resize(size_type s) {
    // 计算 erased 元素数目，同时从存储中删除对应元素
    size_type i = v.size()
    while(no_of_erased) {
      if(v[--i].erased) {
        v.erase(&v[i]);
        --no_of_erased;
      }
    }
    // 如果 b.size() >= s，返回
    if(s <= b.size()) return;
    // 如果 b.size() < s，增大 b，b 全部清 0，重新计算
    b.resize(s);
    fill(b.begin(), b.end(), 0);
    // 重新分配底层存储
    v.reserve(s * max_load);
    // 重新计算元素散列值
    for(size_type i=0; i<v.size(); i++) {
      size_type ii = hash(v[i].key) % b.size();
      v[i].next = b[ii];
      b[ii] = &v[i];
    }
  }

private:
  struct Entry {
    key_type key;
    mapped_type val;
    bool erased;
    Entry* next;          // 散列链
  };
  vector<Entry> v;        // 实际存储
  vector<Entry*> b;       // 散列表，保存实际存储的指针

  float max_load;         // 保持 v.size() <= b.size()*max_load
  float grow;             // 接近太满时自动改变大小 resize(bucket_count() * grow)
  size_type no_of_erased; // erased 元素项的数目
  Hasher hash;            // 散列函数
  key_equal eq;           // 相等判断

  const T default_value;  // entry 默认值
};
```
