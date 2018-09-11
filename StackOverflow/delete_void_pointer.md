# 删除 void 指针

- [Is it safe to delete a void pointer?](https://stackoverflow.com/questions/941832/is-it-safe-to-delete-a-void-pointer)
- 代码如下：

```code
void* my_alloc (size_t size)
{
   return new char [size];
}

void my_free (void* ptr)
{
   delete [] ptr;
}
```

- 对于内建类型，`delete void*`不会造成内存泄漏，系统在分配内存的时候记录了分配内存的大小，指针的分配信息和指针放在一起，释放的时候会返回到对应的位置。
  - 分配对象的时候，除了分配所需内存大小存放对象信息，会先分配一个内存控制块，标记该内存块的大小及是否可用。调用`delete`的时候会将该内存块标记为空闲，释放内存
  - 内存控制块结构如下：

  ```code
  struct mem_control_block
  {
      int is_available;
      int size;
  };
  ```

  - 对于类，析构的时候会调用析构函数（在其中释放指针变量申请的内存）。但是调用`void*`丢失了指针的类型，将不会调用类的析构函数，当类中存在指针类型时，该指针类型指向的内存将无法释放。
- 对于自定义类型的分配和释放，`delete void*`可能会造成内存泄漏，这是未定义的行为（undefined behavior），建议用模板实现。或者生成分配池，对于特定的类型会更有效。
