# C++ 未定义的行为

- UB(Undefined behavior):程序的行为没有限制。常见的未定义行为例子包括：数组访问内存越界，有符号数溢出，间接访问空指针，在一个表达式中无顺序多次修改标量，用不同类型的指针访问对象
- [UB and optimization](https://en.cppreference.com/w/cpp/language/ub)
  - 正确的 C++ 程序是没有未定义行为的，所以当编译器优化了含有 UB 的代码，程序会出现不可预料的结果
  - 有符号数溢出，下面是 C++ 代码和对应可能生成的机器语言
    - 没有溢出时返回 1，溢出时是 UB，编译器可能优化，每次都返回 1

    ```code
    int foo(int x)
    {
        return x+1 > x; // either true or UB due to signed overflow
    }
    ```

    ```code
    foo(int):
        movl    $1, %eax
        ret
    ```

  - 访问越界，下面是 C++ 代码和对应可能生成的机器语言
    - 访问下标在 0-3 时，如果存在元素 v 返回true，否则会访问越界，编译器可能优化，每次都返回 true，也不会访问越界

    ```code
    int table[4] = {};
    bool exists_in_table(int v)
    {
        // return true in one of the first 4 iterations or UB due to out-of-bounds access
        for (int i = 0; i <= 4; i++)
        {
            if (table[i] == v) return true;
        }
        return false;
    }
    ```

    ```code
    exists_in_table(int):
        movl    $1, %eax
        ret
    ```

  - 未初始化的标量，下面是 C++ 代码和对应可能生成的机器语言
    - 当 x 非 0 时，a 会被赋值 42，否则 a 未初始化，编译器可能优化，每次都将 a 赋值42，然后返回

    ```code
    std::size_t f(int x)
    {
        std::size_t a;
        if(x) // either x nonzero or UB
            a = 42;
        return a;
    }
    ```

    ```code
    f(int):
        mov     eax, 42
        ret
    ```

  - 间接访问空指针，下面是 C++ 代码和对应可能生成的机器语言
    - 函数`foo`：当 p 是空指针时，x 的赋值是间接访问空指针。否则返回 0。编译器可能优化，每次返回 0 而不会访问到空指针
      - `xorl %eax,%eax`按位异或，相当于清 0，将寄存器`%eax`设置为 0。也可以使用`movl $0,%eax`，但是前者需要 2 个字节，后者需要 5 个字节
    - 函数`bar`：直接访问空指针指向的值是 UB，编译器可能优化，每次直接执行下一行代码
      - `retq`等同于`addq $8,%rsp; jmpq -8(%rsp)`，`retq`将`%esp`指向的返回地址弹出，存入寄存器`%eip`
      - 寄存器`%eip`是程序计数器，存储了 CPU 要读取指令的地址，即 CPU 将要执行的指令的地址。每次 CPU执行完相应的汇编指令后，`%eip`的值就会增加
      - 寄存器`%esp`是栈指针指向栈顶元素。栈向低地址方向增长，可以通过增加栈指针来释放空间
      - 函数调用时会先将返回地址入栈，即程序中紧跟在调用函数后面的那条指令的地址，所以栈顶指针`%esp`指向的就是调用函数后面的那条指令的地址，`retq`会将该地址存入`%eip`，CPU 就会继续往后执行
      - 在 64-bit 时，`ret`会从栈中弹出四字节的地址保存到寄存器`%eip`
      - 在 32-bit 时，`ret`会从栈中弹出两字节的地址保存到寄存器`%eip`

    ```code
    int foo(int* p)
    {
        int x = *p;
        if(!p) return x; // Either UB above or this branch is never taken
        else return 0;
    }
    int bar()
    {
        int* p = nullptr;
        return *p;        // Unconditional UB
    }
    ```

    ```code
    foo(int*):
        xorl    %eax, %eax
        ret
    bar():
        retq
    ```