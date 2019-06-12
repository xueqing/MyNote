# Effective C++, Third Edition

- [Effective C++, Third Edition](#effective-c-third-edition)
  - [1.让自己习惯 C++](#1%E8%AE%A9%E8%87%AA%E5%B7%B1%E4%B9%A0%E6%83%AF-c)
    - [01.视 C++ 为一个语言联邦](#01%E8%A7%86-c-%E4%B8%BA%E4%B8%80%E4%B8%AA%E8%AF%AD%E8%A8%80%E8%81%94%E9%82%A6)
    - [02.常量，枚举和内联优于宏定义](#02%E5%B8%B8%E9%87%8F%E6%9E%9A%E4%B8%BE%E5%92%8C%E5%86%85%E8%81%94%E4%BC%98%E4%BA%8E%E5%AE%8F%E5%AE%9A%E4%B9%89)
    - [03.尽可能使用常量](#03%E5%B0%BD%E5%8F%AF%E8%83%BD%E4%BD%BF%E7%94%A8%E5%B8%B8%E9%87%8F)
    - [04.确定对象被使用前已先被初始化](#04%E7%A1%AE%E5%AE%9A%E5%AF%B9%E8%B1%A1%E8%A2%AB%E4%BD%BF%E7%94%A8%E5%89%8D%E5%B7%B2%E5%85%88%E8%A2%AB%E5%88%9D%E5%A7%8B%E5%8C%96)
  - [2.构造/析构/赋值运算](#2%E6%9E%84%E9%80%A0%E6%9E%90%E6%9E%84%E8%B5%8B%E5%80%BC%E8%BF%90%E7%AE%97)
    - [05.了解 C++ 默默编写并调用哪些函数](#05%E4%BA%86%E8%A7%A3-c-%E9%BB%98%E9%BB%98%E7%BC%96%E5%86%99%E5%B9%B6%E8%B0%83%E7%94%A8%E5%93%AA%E4%BA%9B%E5%87%BD%E6%95%B0)
    - [06.明确拒绝不想用的编译器自动生成的函数](#06%E6%98%8E%E7%A1%AE%E6%8B%92%E7%BB%9D%E4%B8%8D%E6%83%B3%E7%94%A8%E7%9A%84%E7%BC%96%E8%AF%91%E5%99%A8%E8%87%AA%E5%8A%A8%E7%94%9F%E6%88%90%E7%9A%84%E5%87%BD%E6%95%B0)
    - [07.声明多态基类析构函数为虚函数](#07%E5%A3%B0%E6%98%8E%E5%A4%9A%E6%80%81%E5%9F%BA%E7%B1%BB%E6%9E%90%E6%9E%84%E5%87%BD%E6%95%B0%E4%B8%BA%E8%99%9A%E5%87%BD%E6%95%B0)
    - [08.别让异常逃离析构函数](#08%E5%88%AB%E8%AE%A9%E5%BC%82%E5%B8%B8%E9%80%83%E7%A6%BB%E6%9E%90%E6%9E%84%E5%87%BD%E6%95%B0)
    - [09.绝不在构造和析构过程中调用虚函数](#09%E7%BB%9D%E4%B8%8D%E5%9C%A8%E6%9E%84%E9%80%A0%E5%92%8C%E6%9E%90%E6%9E%84%E8%BF%87%E7%A8%8B%E4%B8%AD%E8%B0%83%E7%94%A8%E8%99%9A%E5%87%BD%E6%95%B0)
    - [10.使 operator= 返回一个 *this 的引用](#10%E4%BD%BF-operator-%E8%BF%94%E5%9B%9E%E4%B8%80%E4%B8%AA-this-%E7%9A%84%E5%BC%95%E7%94%A8)
    - [11.在 operator= 中处理“自我赋值”](#11%E5%9C%A8-operator-%E4%B8%AD%E5%A4%84%E7%90%86%E8%87%AA%E6%88%91%E8%B5%8B%E5%80%BC)
    - [12.复制对象的所有部分](#12%E5%A4%8D%E5%88%B6%E5%AF%B9%E8%B1%A1%E7%9A%84%E6%89%80%E6%9C%89%E9%83%A8%E5%88%86)
  - [3.资源管理](#3%E8%B5%84%E6%BA%90%E7%AE%A1%E7%90%86)
    - [13.以对象管理资源](#13%E4%BB%A5%E5%AF%B9%E8%B1%A1%E7%AE%A1%E7%90%86%E8%B5%84%E6%BA%90)
    - [14.在资源管理类中小心复制行为](#14%E5%9C%A8%E8%B5%84%E6%BA%90%E7%AE%A1%E7%90%86%E7%B1%BB%E4%B8%AD%E5%B0%8F%E5%BF%83%E5%A4%8D%E5%88%B6%E8%A1%8C%E4%B8%BA)
    - [15.在资源管理类中提供对原始资源的访问](#15%E5%9C%A8%E8%B5%84%E6%BA%90%E7%AE%A1%E7%90%86%E7%B1%BB%E4%B8%AD%E6%8F%90%E4%BE%9B%E5%AF%B9%E5%8E%9F%E5%A7%8B%E8%B5%84%E6%BA%90%E7%9A%84%E8%AE%BF%E9%97%AE)
    - [16.在对应的 new 和 delete 采用相同形式](#16%E5%9C%A8%E5%AF%B9%E5%BA%94%E7%9A%84-new-%E5%92%8C-delete-%E9%87%87%E7%94%A8%E7%9B%B8%E5%90%8C%E5%BD%A2%E5%BC%8F)
    - [17. 以独立语句将 newed 对象保存到智能指针](#17-%E4%BB%A5%E7%8B%AC%E7%AB%8B%E8%AF%AD%E5%8F%A5%E5%B0%86-newed-%E5%AF%B9%E8%B1%A1%E4%BF%9D%E5%AD%98%E5%88%B0%E6%99%BA%E8%83%BD%E6%8C%87%E9%92%88)
  - [4.设计与声明](#4%E8%AE%BE%E8%AE%A1%E4%B8%8E%E5%A3%B0%E6%98%8E)
    - [18.让接口易被正常使用，不易被误用](#18%E8%AE%A9%E6%8E%A5%E5%8F%A3%E6%98%93%E8%A2%AB%E6%AD%A3%E5%B8%B8%E4%BD%BF%E7%94%A8%E4%B8%8D%E6%98%93%E8%A2%AB%E8%AF%AF%E7%94%A8)
    - [19.把类设计看作类型设计](#19%E6%8A%8A%E7%B1%BB%E8%AE%BE%E8%AE%A1%E7%9C%8B%E4%BD%9C%E7%B1%BB%E5%9E%8B%E8%AE%BE%E8%AE%A1)
    - [20.常量引用传递优于值传递](#20%E5%B8%B8%E9%87%8F%E5%BC%95%E7%94%A8%E4%BC%A0%E9%80%92%E4%BC%98%E4%BA%8E%E5%80%BC%E4%BC%A0%E9%80%92)
    - [21.必须返回对象时，不要返回引用](#21%E5%BF%85%E9%A1%BB%E8%BF%94%E5%9B%9E%E5%AF%B9%E8%B1%A1%E6%97%B6%E4%B8%8D%E8%A6%81%E8%BF%94%E5%9B%9E%E5%BC%95%E7%94%A8)
    - [22.声明数据成员为私有的](#22%E5%A3%B0%E6%98%8E%E6%95%B0%E6%8D%AE%E6%88%90%E5%91%98%E4%B8%BA%E7%A7%81%E6%9C%89%E7%9A%84)
    - [23.成员函数优于非成员、非友元函数](#23%E6%88%90%E5%91%98%E5%87%BD%E6%95%B0%E4%BC%98%E4%BA%8E%E9%9D%9E%E6%88%90%E5%91%98%E9%9D%9E%E5%8F%8B%E5%85%83%E5%87%BD%E6%95%B0)
    - [24.当类型转换需应用到所有参数，声明为非成员函数](#24%E5%BD%93%E7%B1%BB%E5%9E%8B%E8%BD%AC%E6%8D%A2%E9%9C%80%E5%BA%94%E7%94%A8%E5%88%B0%E6%89%80%E6%9C%89%E5%8F%82%E6%95%B0%E5%A3%B0%E6%98%8E%E4%B8%BA%E9%9D%9E%E6%88%90%E5%91%98%E5%87%BD%E6%95%B0)
    - [25.考虑支持不抛异常的 swap 函数](#25%E8%80%83%E8%99%91%E6%94%AF%E6%8C%81%E4%B8%8D%E6%8A%9B%E5%BC%82%E5%B8%B8%E7%9A%84-swap-%E5%87%BD%E6%95%B0)
  - [5.实现](#5%E5%AE%9E%E7%8E%B0)
    - [26.尽可能推迟变量定义](#26%E5%B0%BD%E5%8F%AF%E8%83%BD%E6%8E%A8%E8%BF%9F%E5%8F%98%E9%87%8F%E5%AE%9A%E4%B9%89)
    - [27.最小化 cast 操作](#27%E6%9C%80%E5%B0%8F%E5%8C%96-cast-%E6%93%8D%E4%BD%9C)
    - [28.避免返回指向对象内部的句柄](#28%E9%81%BF%E5%85%8D%E8%BF%94%E5%9B%9E%E6%8C%87%E5%90%91%E5%AF%B9%E8%B1%A1%E5%86%85%E9%83%A8%E7%9A%84%E5%8F%A5%E6%9F%84)
    - [29.努力写异常安全的代码](#29%E5%8A%AA%E5%8A%9B%E5%86%99%E5%BC%82%E5%B8%B8%E5%AE%89%E5%85%A8%E7%9A%84%E4%BB%A3%E7%A0%81)
    - [30.了解内联的细节](#30%E4%BA%86%E8%A7%A3%E5%86%85%E8%81%94%E7%9A%84%E7%BB%86%E8%8A%82)
    - [31.最小化文件编译依赖](#31%E6%9C%80%E5%B0%8F%E5%8C%96%E6%96%87%E4%BB%B6%E7%BC%96%E8%AF%91%E4%BE%9D%E8%B5%96)
  - [6.继承与面向对象设计](#6%E7%BB%A7%E6%89%BF%E4%B8%8E%E9%9D%A2%E5%90%91%E5%AF%B9%E8%B1%A1%E8%AE%BE%E8%AE%A1)
    - [32.确保公有继承是"is-a"关系](#32%E7%A1%AE%E4%BF%9D%E5%85%AC%E6%9C%89%E7%BB%A7%E6%89%BF%E6%98%AF%22is-a%22%E5%85%B3%E7%B3%BB)
    - [33.避免隐藏继承的名字](#33%E9%81%BF%E5%85%8D%E9%9A%90%E8%97%8F%E7%BB%A7%E6%89%BF%E7%9A%84%E5%90%8D%E5%AD%97)
    - [34.区分接口继承和实现继承](#34%E5%8C%BA%E5%88%86%E6%8E%A5%E5%8F%A3%E7%BB%A7%E6%89%BF%E5%92%8C%E5%AE%9E%E7%8E%B0%E7%BB%A7%E6%89%BF)
    - [35.考虑虚函数的替代](#35%E8%80%83%E8%99%91%E8%99%9A%E5%87%BD%E6%95%B0%E7%9A%84%E6%9B%BF%E4%BB%A3)
    - [36.绝不重定义继承的非虚函数](#36%E7%BB%9D%E4%B8%8D%E9%87%8D%E5%AE%9A%E4%B9%89%E7%BB%A7%E6%89%BF%E7%9A%84%E9%9D%9E%E8%99%9A%E5%87%BD%E6%95%B0)
    - [37.绝不重定义函数继承的默认参数值](#37%E7%BB%9D%E4%B8%8D%E9%87%8D%E5%AE%9A%E4%B9%89%E5%87%BD%E6%95%B0%E7%BB%A7%E6%89%BF%E7%9A%84%E9%BB%98%E8%AE%A4%E5%8F%82%E6%95%B0%E5%80%BC)
    - [38.通过组合对"has-a"或"is-implemented-in-terms-of"建模](#38%E9%80%9A%E8%BF%87%E7%BB%84%E5%90%88%E5%AF%B9%22has-a%22%E6%88%96%22is-implemented-in-terms-of%22%E5%BB%BA%E6%A8%A1)
    - [39.慎重使用私有继承](#39%E6%85%8E%E9%87%8D%E4%BD%BF%E7%94%A8%E7%A7%81%E6%9C%89%E7%BB%A7%E6%89%BF)
    - [40.慎重使用多重继承](#40%E6%85%8E%E9%87%8D%E4%BD%BF%E7%94%A8%E5%A4%9A%E9%87%8D%E7%BB%A7%E6%89%BF)
  - [7.模板与泛型编程](#7%E6%A8%A1%E6%9D%BF%E4%B8%8E%E6%B3%9B%E5%9E%8B%E7%BC%96%E7%A8%8B)
    - [41.理解隐式接口和编译期多态](#41%E7%90%86%E8%A7%A3%E9%9A%90%E5%BC%8F%E6%8E%A5%E5%8F%A3%E5%92%8C%E7%BC%96%E8%AF%91%E6%9C%9F%E5%A4%9A%E6%80%81)
    - [42.理解 typename 的双重定义](#42%E7%90%86%E8%A7%A3-typename-%E7%9A%84%E5%8F%8C%E9%87%8D%E5%AE%9A%E4%B9%89)
    - [43.了解如何访问模板化基类内的名称](#43%E4%BA%86%E8%A7%A3%E5%A6%82%E4%BD%95%E8%AE%BF%E9%97%AE%E6%A8%A1%E6%9D%BF%E5%8C%96%E5%9F%BA%E7%B1%BB%E5%86%85%E7%9A%84%E5%90%8D%E7%A7%B0)
    - [44.把参数无关的代码分离出模板](#44%E6%8A%8A%E5%8F%82%E6%95%B0%E6%97%A0%E5%85%B3%E7%9A%84%E4%BB%A3%E7%A0%81%E5%88%86%E7%A6%BB%E5%87%BA%E6%A8%A1%E6%9D%BF)
    - [45.使用成员函数模板来接受“所有兼容类型”](#45%E4%BD%BF%E7%94%A8%E6%88%90%E5%91%98%E5%87%BD%E6%95%B0%E6%A8%A1%E6%9D%BF%E6%9D%A5%E6%8E%A5%E5%8F%97%E6%89%80%E6%9C%89%E5%85%BC%E5%AE%B9%E7%B1%BB%E5%9E%8B)
    - [46.需要类型转化时在模板内定义非成员函数](#46%E9%9C%80%E8%A6%81%E7%B1%BB%E5%9E%8B%E8%BD%AC%E5%8C%96%E6%97%B6%E5%9C%A8%E6%A8%A1%E6%9D%BF%E5%86%85%E5%AE%9A%E4%B9%89%E9%9D%9E%E6%88%90%E5%91%98%E5%87%BD%E6%95%B0)
    - [47.使用 traits class 表现类型信息](#47%E4%BD%BF%E7%94%A8-traits-class-%E8%A1%A8%E7%8E%B0%E7%B1%BB%E5%9E%8B%E4%BF%A1%E6%81%AF)
    - [48. 认识模板元编程](#48-%E8%AE%A4%E8%AF%86%E6%A8%A1%E6%9D%BF%E5%85%83%E7%BC%96%E7%A8%8B)
  - [8.定制 new 和 delete](#8%E5%AE%9A%E5%88%B6-new-%E5%92%8C-delete)
    - [49.理解 new-handler 的行为](#49%E7%90%86%E8%A7%A3-new-handler-%E7%9A%84%E8%A1%8C%E4%B8%BA)
    - [50.理解何时替换 new 和 delete 有意义](#50%E7%90%86%E8%A7%A3%E4%BD%95%E6%97%B6%E6%9B%BF%E6%8D%A2-new-%E5%92%8C-delete-%E6%9C%89%E6%84%8F%E4%B9%89)
    - [51.写 new 和 delete 时遵循惯例](#51%E5%86%99-new-%E5%92%8C-delete-%E6%97%B6%E9%81%B5%E5%BE%AA%E6%83%AF%E4%BE%8B)
    - [52.写了 placement new 也要写 placement delete](#52%E5%86%99%E4%BA%86-placement-new-%E4%B9%9F%E8%A6%81%E5%86%99-placement-delete)
  - [9.杂项讨论](#9%E6%9D%82%E9%A1%B9%E8%AE%A8%E8%AE%BA)
    - [53.注意编译器警告](#53%E6%B3%A8%E6%84%8F%E7%BC%96%E8%AF%91%E5%99%A8%E8%AD%A6%E5%91%8A)
    - [54.熟悉包括 TR1 在内的标准库](#54%E7%86%9F%E6%82%89%E5%8C%85%E6%8B%AC-tr1-%E5%9C%A8%E5%86%85%E7%9A%84%E6%A0%87%E5%87%86%E5%BA%93)
    - [55.熟悉 Boost](#55%E7%86%9F%E6%82%89-boost)

## 1.让自己习惯 C++

>>> Accustoming yourself to C++

### 01.视 C++ 为一个语言联邦

>>> View C++ as a federation of languages

- C
- 面向对象的 C++：类、封装、继承、多态
- 模板 C++：泛型编程
- STL：模板库

### 02.常量，枚举和内联优于宏定义

>>> Prefer consts, enums, inlines to #defines

- 对于单纯常量，以 const 对象或枚举
- 对于形似函数的宏，用内联函数替换
  - 常量、枚举和内联更具封装性，可以限定作用域
  - 枚举比常量约束更多，不能为该常量创建指针或引用

### 03.尽可能使用常量

>>> Use const whenever possible

- 指定语义约束，即“不该被改动”的对象
  - 可帮助编译器侦测错误用法
- const 在 * 左边，表示被指物是常量
  - 也可将 const 放在类型之前
  - 例如`const widget *pw`等同于`widget const *pw`
  - 指针所指东西不可被改动
- const 在 * 右边，表示指针自身是常量
  - 指针不得指向不同的东西，但所指东西的值可以改动
- const 在 * 两侧，表示被指物和指针自身都是常量
- const 成员函数
  - 可作用于 const 对象，不可更改对象内任何非静态成员变量
  - 成员变量前加`mutable`，也可在 const 成员函数内部修改该成员变量
  - 当 const 和 non-const 成员函数有着实质等价的实现时，另 non-const 版本调用 const 版本避免代码重复

### 04.确定对象被使用前已先被初始化

>>> Make sure that objects are initialized before they're used

- 对于内置类型手动初始化
- 对于类，在构造函数中初始化成员变量
  - 赋值不等于初始化
  - 使用成员初始化列表列替换赋值动作，前者效率更高，后者先设初值再赋值
  - 可使用无参数构造函数来初始化
  - 对于多个构造函数，可添加私有成员函数，接收初始化参数，在函数内部使用赋值操作给成员变量“初始化”
  - 初始化顺序
    - 先基类再衍生类
    - 类内部，按照声明的顺序初始化，与成员初始化列表列操作顺序无关
    - 最好按照声明顺序初始化
    - 不同编译单元内的 non-local static 对象的初始化顺序未定义
      - static 对象包括全局对象、定义于命名空间作用域内的对象、类内、函数内，以及在文件作用域内被声明为 static 的对象
      - 函数内的 static 对象称为 local-static 对象，其他的则是 non-local static 对象
      - 程序结束时 static 对象会被自动销毁，即在 main 函数结束时调用他们的析构函数
      - 编译单元是产出单一目标文件的源码
      - 将每个 non-local static 对象移到自己的专属函数内，改函数返回对该对象的引用，保证该函数被调用期间，首次遇到该对象的定义时被初始化，即以函数调用替换直接访问 non-local static 对象

## 2.构造/析构/赋值运算

>>> Contructors, destructors, and assignments operators

### 05.了解 C++ 默默编写并调用哪些函数

>>> Know what functions C++ silently writes and calls

- 编译器自动为类创建默认构造函数、拷贝构造函数、拷贝赋值操作和析构函数

### 06.明确拒绝不想用的编译器自动生成的函数

>>> Explicitly disallow the use of complier-generated functions you do not want

- 如果不想用编译器自动生成的函数，可将相应的成员函数声明为 private 并且不予实现
- 可以继承 Uncopyable 这样的基类，但是可能会多重继承

```c++
class Uncopyable {
 protected: // allow constructor and destructor for derived object
    Uncopyable() {}
    ~Uncopyable() {}
 private:
    Uncopyable(const Uncopyable&); //avoid copying
    Uncopyable& operator=(const Uncopyable&);
};
```

### 07.声明多态基类析构函数为虚函数

>>> Declare destructors virtual in polymorphic base classes

- 包含虚函数的类需要额外的信息来实现虚函数：vptr(virtual table pointer)指向一个由函数指针构成的数组，称为 vtbl(virtual table)，每个有虚函数的类都有一个相应的 vtbl
- 析构顺序：先父类再子类，构造函数的调用顺序相反
- 带有多态性质的基类应声明一个虚析构函数
- 如果一个类带有任何虚函数，就声明一个虚析构函数
- 类的设计目的不是作为基类使用，或者不是为了多态性，不应该声明虚析构函数

### 08.别让异常逃离析构函数

>>> Prevent exceptions from leaving destructors

- 如果析构函数内可能抛出异常，应该在析构函数内捕获异常，然后不传播或结束程序
- 如果需要客户自定义异常的反应，类应该提供接口执行该操作

### 09.绝不在构造和析构过程中调用虚函数

>>> Never call virtual functions during construction or destruction

- 在构造和析构中不要调用虚函数没因为这类调用不会下降到衍生类，即调用的仍然是基类的实现

### 10.使 operator= 返回一个 *this 的引用

>>> Having assignment operators return a reference to *this

- 赋值相关运算(包括 operator=/+=、-=、*=)操作符返回一个 *this 的引用

### 11.在 operator= 中处理“自我赋值”

>>> Handle assignment to self in operator=

- 确保对象自我赋值时，operator= 行为良好，包括比较源对象和目标对象的地址、精心周到的语句顺序(先复制源对象，再执行删除)，以及icopy-and-swap
- 确定任何函数如果操作一个以上的对象，而其中多个对象时同一个对象时，行为仍然正确

### 12.复制对象的所有部分

>>> Copy all parts of an object

- 拷贝构造函数和拷贝赋值操作符都是 copying 函数
- copying 函数应该确保复制“对象内的所有成员变量”和“所有基类成分”
- 不要尝试以某个 copying 函数实现另一个 copying 函数，应该将相同的东西抽象成一个函数，二者都调用这个函数

## 3.资源管理

>>> Resource management

### 13.以对象管理资源

>>> Use objects to manage resources

- 为防止内存泄漏，建议使用 RAII(Resource Acquisition Is Initialization，资源取得时机就是初始化时机) 对象，它们在构造函数中获得资源并在析构函数中释放资源
- 常用的 RAII 类是 shared_ptr 和 auto_ptr。前者的拷贝行为比较直观，后者的复制动作会转移资源的所有权：shared_ptr 有引用计数，但是无法打破环装引用
- 参考[智能指针](./smart_ptr.md)一文

### 14.在资源管理类中小心复制行为

>>> Think carefully about copying behavior in resource-managing classes

- 复制 RAII 对象必须一并复制它锁管理的资源，所以资源的 copying 行为决定 RAII 对象的 copying 行为
- 一般情况下，RAII 类的 copying 行为是：阻止 copying、实行引用计数法

### 15.在资源管理类中提供对原始资源的访问

>>> Provide access to raw resources in resource-managing classes

- APIs 往往要求访问原始资源，所以每一个 RAII 类应该提供一个接口可以获得其管理的资源
- 对原始资源的访问可以是显示转换或隐式转换：一般显示转换比较安全，隐式转换对客户比较方便

### 16.在对应的 new 和 delete 采用相同形式

>>> Use the same form in corresponding uses of new and delete

- 调用 new 时使用`[]`，那么对应调用 delete 时也调用`[]`
- 调用 new 时没有使用`[]`，那么也不该在调用 delete 时使用`[]`

### 17. 以独立语句将 newed 对象保存到智能指针

>>> Store newed onjects in smart pointers in standalone statements

- 以独立语句将 newed 对象保存在智能指针内。否则，抛出异常的时候，可能会导致内存泄漏

## 4.设计与声明

>>> Designs and declarations

### 18.让接口易被正常使用，不易被误用

>>> Make interfaces easy to use correctly and hard to use incorrectly

- “促进正确使用”的办法包括接口的一致性，以及与内置类型的行为兼容
- “阻止误用”的办法包括建立新类型、限制类型上的操作、束缚对象值，以及消除客户的资源管理责任
- shared_ptr 支持自定义删除器，可以防止 DLL 问题，可被用来自动解除互斥锁

### 19.把类设计看作类型设计

>>> Treat class design as type design

在设计一个类之前，考虑以下问题

- 新类型的对象如何被创建和销毁
- 对象的初始化和对象的赋值该有什么样的差别：区分构造函数和赋值操作符的行为
- 新类型的对象如果以值传递，意味着什么：取决于拷贝构造函数
- 什么是新类型的“合法值”：确定需要做的错误检查工作
- 新类型需要配合某个继承图系吗：受继承类的约束，如果允许被继承，析构函数是否为虚函数
- 新类型需要什么样的转换：显示类型转换和隐式类型转换
- 什么样的操作符和函数对此新类型是合理的：确定需要声明的函数，哪些是成员函数，哪些不是成员函数
- 谁该调用新类型的成员：确定成员的属性(public/protected/private)，也确定类之间的关系(所属，友元)
- 什么是新类型的未声明接口
- 新类型有多一般化：是否需要定义一个模板类
- 真的需要一个新类型吗：是否可以为已有类添加非成员函数或模板来实现

### 20.常量引用传递优于值传递

>>> Prefer pass-by-reference-to-const to pass-by-value

- 值传递效率低，而且可能造成对象切割(slicing)：值传递一个衍生类对象时，如果函数声明的是基类，那么调用的是基类的拷贝构造函数
- C++ 编译器底层使用指针实现，不同情形使用不同的方式
  - 内置类型(如 int)采用值传递
  - STL 的迭代器和函数对象使用值传递
  - 其他的采用常量引用传递

### 21.必须返回对象时，不要返回引用

>>> Don't try to return a reference when you must return an object

- 绝不要返回指针或引用指向一个 local stack 对象
- 绝不要返回引用指向一个 heap-allocated 对象
- 绝不要返回指针或引用指向一个 local static 对象而有可能同时需要多个这样的对象

### 22.声明数据成员为私有的

>>> Declare data memebers private

- 语法一致性：public 接口内的所有东西都是函数
- 可细微划分访问控制、允诺约束条件获得保证
- protected 并不比 public 更具封装性

### 23.成员函数优于非成员、非友元函数

>>> Prefer non-member non-friend functions to member function

- 将所有功能函数放在多个头文件内但隶属同一命名空间，使用者可以轻松扩展这一组功能函数
  - 在命名空间添加非成员非友元函数，以便为使用者提供方便的接口
- 优先考虑非成员、非友元函数替换成员函数，可以增加封装性、包裹弹性和机能扩充性

### 24.当类型转换需应用到所有参数，声明为非成员函数

>>> Declare non-member functions when type conversions should apply to all parameters

- 如果需要为某个函数的所有参数(包括被 this 指针所指的隐喻参数)进行类型转换，那么这个函数必须是非成员函数
  - 编译器可对每一个实参执行隐式类型转换

### 25.考虑支持不抛异常的 swap 函数

>>> Consider support for a non-throwing swap

- 如果 std::swap 缺省实现对自定义的类或类模板的效率不足，试着做
  - 提供一个 public swap 成员函数，在函数内高效地置换两个对象值
  - 在类或模板所在的命名空间提供一个非成员的 swap 函数，在函数内调用上述 swap 函数
  - 如果正在编写一个类或类模板，让该类特化 std::swap，另其调用上述的 swap 函数
- 如果调用 swap，确定包含`using std::swap`，然后不加任何 namespace 修饰符，直接调用 swap，编译器就会查找适当的 swap 函数并调用
- 警告：成员函数 swap 不可抛出异常

## 5.实现

>>> Implementations

### 26.尽可能推迟变量定义

>>> Postpone variable definitions as long as possible

- 尽可能延后变量定义式的出现，最好是延后到可以用有意义的参数进行始化
- 对于循环，如果构造和析构的代码大于赋值操作，则将定义放在循环外

### 27.最小化 cast 操作

>>> Minimize casting

- C 风格的转换操作，将 expression 转换为 T：`(T)expression`和`T(expression)`
- C++ 另外提供 4 种转换操作
  - `const_cast<T>( expression )`用来移除对象的常量性，唯一可以实现这个目的的 C++ 风格的转换操作符
  - `dynamic_cast<T>( expression )`用于执行“安全向下转换”，用于确定某对象是否归属继承体系中的某个类型，可能耗费重大运行成本，唯一一个 C 风格无法实现的转换操作
  - `reinterpret_cast<T>( expression )`意图执行低级转换，实际动作和结果可能取决于编译器，即不可移植
  - `static_cast<T>( expression )`用于强迫隐式转换，例如 non-const 转换为 const，或者 int 转 double 等
- 倾向使用 C++ 风格的转换操作，不要使用 C 风格的转换
  - 易被辨识，因而得以简化查找类型被破坏的过程
  - 各转换工作有各自的局限，便于编译器诊断错误的运用
- 如果可以，尽量避免转换操作，特别是在注重效率的代码中避免 dynamic_cast，如果有需要，尝试改成无需转换的设计
  - 使用类型安全容器，确定是哪种衍生类或基类
  - 将虚函数放在父类，然后添加空实现
- 如果必须转换，试着用函数封装，可以调用函数，而无需将转换操作引入代码

### 28.避免返回指向对象内部的句柄

>>> Avoid returning "handles" to object internals

- 避免返回 handles(包括引用、指针、迭代器)指向对象内部。一遍增加封装性，帮助 const 成员函数的行为像个 const，并将发生 dangling handles 的可能性降至最低

### 29.努力写异常安全的代码

>>> Strive for exception-safe code

- 异常安全函数即使发生议程也不会内存泄漏或破坏任何数据结构。这样的函数分为三种可能的保证：基本型、强烈型、不抛异常型
- “强烈保证”往往以 copy-and-swap 实现，但“强烈保证”并非对所有函数都可实现或具备现实意义
- 函数提供的“异常安全保证”通常最高只等于其调用的各个函数的“异常安全保证”中的最弱者

### 30.了解内联的细节

>>> Understand the ins and outs of inlining

- 将大多数内联限制在小型、被频繁调用的函数。可使日后的调试过程和二进制升级更容易，也可最小化潜在的代码膨胀问题，最大化提升程序的速度
  - 内联函数无法随着程序库的升级而升级：内联函数修改，用到该函数的程序必须重新编译
  - 大部分调试器不支持内联函数调试
- 隐式内联：函数定义在类定义内
- 显式内联：添加关键字 inline
  - 没有要求每个函数都是内联，就避免声明一个模板是内联
- 大多数编译拒绝复杂的函数内联：比如虚函数，带有循环或递归的函数。此时会有警告信息
- 编译器通常不对“通过函数指针进行的调用”执行内联
- 不要只因为函数模板出现在头文件，就将其声明为内联

### 31.最小化文件编译依赖

>>> Minimize compilation dependencies between files

- pimply idiom(pointer to implementation)：将一个类分为两个，一个提供接口，一个负责实现接口，前者在类内包含一个后者的 shared_ptr，做到“接口与实现分离”
- 使用接口类、衍生类和工厂模式进行实现
- 分离的关键在于“声明的依存性”替换“定义的依存性”：让头文件尽可能自我满足，万一做不到，则使用前置声明
- 设计策略
  - 尽量使用对象引用或对象指针，而不是对象：可以在头文件中使用前置声明
  - 尽量使用 class 声明式而不是 class 定义式
  - 为声明式和定义式提供不同的头文件
- 程序头文件应该以“完全且仅有声明式”的形式存在

## 6.继承与面向对象设计

>>> Inheritance and object-oriented design

### 32.确保公有继承是"is-a"关系

>>> Make sure public inheritance models "is-a"

- public 继承意味着 is-a。适用于基类的每一件事情一定适用于衍生类，每一个衍生类对象也都是一个基类对象

### 33.避免隐藏继承的名字

>>> Avoid hiding inherited names

- 衍生类内的名称会隐藏基类内的名称
  - 如果继承基类并加上重载函数，又希望重新定义或覆盖其中一部分，必须为那些原本会被隐藏的名称引入一个 using 声明式，否则继承的名称会被隐藏
- 为了让隐藏的名称仍然可见，可使用 using 声明式或 forwarding 函数
  - 内置的 forwarding 函数的另一个用途是为那些不支持 using 声明式的编译器而用

### 34.区分接口继承和实现继承

>>> Differentiate between inheritance of interface and inhertance of implementation

- 接口继承和实现继承不同。在 public 继承时，衍生类会继承基类的接口，即成员函数
- 声明纯虚函数的目的是让衍生类只继承函数接口
- 声明非纯虚函数的目的是让衍生类继承该函数的接口和缺省实现
- 声明非虚函数的目的是让衍生类继承函数的接口和一份强制性实现

### 35.考虑虚函数的替代

>>> Condider alternatives to virtual functions

- 虚函数的替代方案包括 NVI 手法及 Strategy 设计模式的多种形式
  - 使用 non-virtual interface(NVI)手法，是 Template Method 设计模式的一种特殊形式。以 public non-virtual 成员函数包裹较低访问性的虚函数
  - 将虚函数替换为“函数指针成员变量”。是 Strategy 设计模式的一种分解表现形式
  - 以 function 成员变量替换虚函数，因而允许使用任何可调用实体(callable entities)搭配一个兼容与需求的签名式。这也是 Strategy 设计模式的某种形式
  - 将继承体系内的虚函数替换为另一继承体系的虚函数。这是 Strategy 设计模式的传统实现手法
- 将功能从成员函数移到类外部，缺点是非成员函数无法访问类的 non-public 成员
- function 对象的行为就像一般函数指针。这样的对象可接纳“与给定的目标签名式兼容”的所有可调用实体

### 36.绝不重定义继承的非虚函数

>>> Never redefine an inherited non-virtual function

- 非虚函数是静态绑定的，虚函数是动态绑定的
- 任何情况下都不该重新定义一个继承而来的非虚函数，否则调用的函数取决于对象最开始的声明类型，跟实际所指类型无关

### 37.绝不重定义函数继承的默认参数值

>>> Never redefine a function's inherited default parameter value

- 虚函数是动态绑定，但是缺省参数是静态绑定
  - 调用虚函数时，默认参数可能是基类的默认参数，而不是实际指向的父类的默认参数
- 静态类型是声明的类型，动态类型是“目前所指对象的类型”
  - 动态类型可以表现出一个对象将会有什么行为
  - 动态类型可在程序执行过程中改变
- 可以使用 NVI 手法：另基类内的一个 public 非虚函数调用 private 虚函数，后者可被衍生类重新定义。让非虚函数知道缺省参数，虚函数负责真正的工作

### 38.通过组合对"has-a"或"is-implemented-in-terms-of"建模

>>> Model "has-a" or "is-implemented-in-terms-of" through composition

- 复合是类型间的一种关系，当某种类型的对象内包含其他类型的对象，就是复合关系
- 在应用域，复合意味着 has-a(有一个)。在实现域，复合以为着 is-implemented-in-terms-of(根据某物实现出)

### 39.慎重使用私有继承

>>> Use private inheritance judiciously

- private 继承意味着 is-implemented-in-terms-of。通常比复合的级别低，但是当衍生类需要访问基类的 protected 成员，或需要重新定义继承而来的虚函数时，private 继承是合理的
  - private 继承时，编译器不会自动将一个衍生类对象转换为一个基类对象
  - 由 private 继承而来的所有成员，在衍生类中都是 private 属性
  - private 继承是一种实现技术，意味着只有实现部分被继承，接口部分应忽略
- 与复合相比，private 继承可以使得空白基类最优化(EBO, empty base optimization)。对致力于“对象尺寸最小化”的程序库开发者比较重要
- 尽可能使用复合，必要时采用 private 继承
  - 当想要访问一个类的 protected 成员，或需要重新定义该类的一个或多个虚函数
  - 当空间更加重要，衍生类的基类可以不包含任何 non-static 成员变量
    - “独立(非附属)”对象的大小一定不为零，不适用于单一继承(多重继承不可以)衍生类对象的基类

### 40.慎重使用多重继承

>>> Use multiple inheritance judiciously

- 多重继承是继承一个以上的基类，但这些基类并不常在继承体系中又有基类
  - 虚继承：防止多重继承时，基类之间又有基类，从而上层的基类的成员变量被父类复制
    - 虚继承的类产生的对象体积更大，访问虚基类的成员变量速度慢，增加初始化(及赋值)的复杂度
    - 如果虚基类不带任何数据，是具有使用价值的情况
- 多重继承比单一继承复杂，可能导致新的歧义性，以及对虚继承的需要
- 多重继承的用途：涉及“public 继承某个接口类”和“private 继承某个协助实现的类”

## 7.模板与泛型编程

>>> Templates and generic programming

### 41.理解隐式接口和编译期多态

>>> Understand implicit interfaces and compile-time polymorphism

- 类和模板都支持接口和多态
- 对类而言接口是显式的，以函数签名为中心。多态则是通过虚函数发生于运行期
- 对模板参数而言，接口是隐式的，基于有效表达式。多态则是通过模板具体化和函数重载解析，发生于编译期

### 42.理解 typename 的双重定义

>>> Understand the two meanings of typename

- 声明模板类型参数的两种方式：
  - `template<class T> class widget;`
  - `template<typename T> class widget;`
- 从属名称：模板内的名称依赖于某个模板参数
  - 非从属名称：模板内不依赖模板参数的名称
- 嵌套从属名称：从属名称在类内呈嵌套状
- 嵌套从属类型名称：嵌套从属名称且指向某类型
  - 想在模板中指定一个嵌套从属类型名称，就必须在紧邻它的前一个位置加上关键字 typename
  - typename 不可出现在基类列表类的嵌套从属类型名称前，也不可在成员初始化列表中作为基类的修饰符

### 43.了解如何访问模板化基类内的名称

>>> Know how to access names in templatized base classes

- 当基类从模板中被具体化时，它假设对基类的内容一无所知，即衍生类基类继承一个基类模板，不能再衍生类的实现中直接调用基类的成员(变量和函数)
  - 可在衍生类模板内添加`this->`指向基类模板的成员(变量和函数)
  - 使用 using 声明式，假设已经存在这个成员(变量和函数)
  - 明确指出被调用的函数位于基类内，使用`基类::`，如果是一个虚函数，会关闭虚函数的动态绑定行为

### 44.把参数无关的代码分离出模板

>>> Factor parameter-independent code out of templates

- 模板生成多个类和多个函数，所以任何模板代码都不该与某个造成膨胀的模板参数产生依赖关系
- 因非类型模板参数造成的代码膨胀，往往可以消除，做法是以函数参数或类成员变量替换模板参数
- 因类型参数造成的代码膨胀，往往可以降低，做法是让带有完全相同二进制表示的具体类型实现共享代码

### 45.使用成员函数模板来接受“所有兼容类型”

>>> Use member function templates to accept "all compatible types"

- 具有基类-衍生类关系的两个类型分别具体化某个模板，生成的两个结构并不带有基类-衍生类关系
- 使用成员函数模板生成“可接受所有兼容类型”的函数
- 如果声明成员模板用于“泛化拷贝构造”或“泛化赋值操作”，必须声明正常的拷贝构造函数和拷贝赋值操作符
  - 声明泛化拷贝构造函数和拷贝赋值操作符，不会阻止编译器生成默认的拷贝构造函数和拷贝赋值操作符

### 46.需要类型转化时在模板内定义非成员函数

>>> Define non-member functions inside templates when type conversions are desired

- 模板实参推导过程中不会考虑隐式类型转换函数
- 写类模板时，当它提供的“与此模板相关的”函数支持“所有参数的隐式类型转换”时，将那些函数定义为类模板内部的友元函数
  - 在类内部声明非成员函数作为友元函数，成为内联函数
  - 为了将内联声明的影响最小化，在类外定义一个辅助函数模板，在友元函数内只调用辅助函数

### 47.使用 traits class 表现类型信息

>>> Use traits classes for information about types

- STL 有 5 种迭代器
  - input 迭代器：只能向前移动，一次异步，只可读取(不能修改)所指的东西，且只能读取一次。模仿了指向输入文件的读指针。如 C++ 的 istream_iterator
  - output 迭代器：只能向前移动，一次一步，只可修改所指的东西，且只能修改一次。模仿了指向输出文件的写指针。如 C++ 的 ostream_iterator
    - input 和 output 迭代器都只适合“单步操作算法(one-pass algorithms)”
  - forward 迭代器：既能完成上述两种迭代器的工作，且可以读或写所指对象一次以上。使得可以实施“多步操作算法(multi-pass algorithms)”。如单向链表的迭代器
  - bidirectional 迭代器：既能完成 forward 迭代器的工作，还支持向后移动。STL 的 list/set/multiset/map/multimap 迭代器就属于这一分类
  - random access 迭代器：可以执行“迭代器运算”，即可以在常量时间内向前或向后跳跃任意距离。如 array/vector/deque/string 提供的都是随机访问迭代器
- 如何设计一个 traits 类
  - 确认若干希望将来可取得的类型相关信息。例如迭代器希望取得分类(category)
  - 为该信息选择一个名词。如迭代器是 iterator_category
  - 提供一个模板和一组特化版本，其中包含希望支持的类型相关信息
  - traits 类的名称常以"traits"结束
- 如何使用一个 traits 类
  - 建立一组重载函数(类似劳工)或函数模板，彼此间的差异只在于各自的 traits 参数。令每个函数实现与其接受的 traits 信息相对应
  - 建立一个控制函数(类似工头)或函数模板，调用上述的函数并传递 traits 类所提供的信息
- traits 类使得“类型相关信息”在编译期可用。它们以模板和一组“模板特化”完成实现
- 整合重载技术后，traits 类可在编译期对类型执行 if...else 测试

### 48. 认识模板元编程

>>> Be aware of template metaprogramming

- 模板元编程(TMP, template metaprogramming)是编写基于模板的 C++ 程序并在编译期执行的过程
  - 即以 C++ 写成、在 C++ 编译期内执行的程序
  - TMP 程序结束执行，输出的 C++ 源码可以像往常一样编译
  - 优点：
    - 让某些事情更容易
    - 可将工作从运行期转移到编译期。使得原本在运行期才可以侦测的错误在编译期被找到
    - TMP 的 C++ 程序在每一方面可能更加高效：较小的可执行文件、较短的运行期、较少的内存需求
  - 缺点：导致编译时间变长
- TMP 主要是函数式语言，可以达到的目的
  - 确保度量单位正确：在编译期确保程序所有度量单位的组合是正确的
  - 优化矩阵运算：使用 expression template，可能会消除中间计算生成的临时对象并合并循环
  - 可生成用户自定义设计模式的实现品。设计模式如 Strategy/Observer/Visitor 等都可以多种方式实现
- 问题：
  - 语法不直观
  - 支持工具不充分，如没有调试器

## 8.定制 new 和 delete

>>> Customizing new and delete

- `new`和`delete`只适合分配单一对象；`new []`和`delete []`用来分配数组
- STL 容器所使用的 heap 内存是由容器所拥有的分配器对象(allocator objects)管理，而不是 new 和 delete 管理

### 49.理解 new-handler 的行为

>>> Understand the behavior of the new-handler

- 当 new 操作抛出异常以反映一个未获满足的内存需求之前，会先调研一个客户指定的错误处理函数，即 new-handler
  - 可以用是`set_new_handler`设置该函数
    - 参数是个指针，指向 new 无法分配足够内存时该调用的函数
    - 返回值是个指针，指向`set_new_handler`被调用之前正在执行的 new_handler 函数
  - new_handler 是个 typedef，定义一个指针指向函数，函数没有参数也没有返回值
- 设计良好的 new-handler 函数
  - 让更多内存可被使用：程序一开始执行就分配一大块内存，而后第一次调用 new-handler，将该内存释放给程序使用
  - 设置另一个 new-handler：如果已知哪个 new-handler 可以获得更多可用内存，调用时设置该 new-handler 替换自己。比如令 new-handler 修改“会影响 new-handler 行为”的静态数据、命名空间数据或全局数据
  - 取消设置 new-handler：即将 null 指针传给`set_new_handler`，内存分配不成功时就会抛异常
  - 抛出 bad_alloc 或派生自 bad_alloc 的异常：该异常不会被 new 操作捕获，但会传播给请求内存的代码
  - 不返回：通常调用 abort 或 exit
- `nothrow new`是一个有局限性的工具，因为它只适用于内存分配；后续的构造函数调用还是可能抛出异常

### 50.理解何时替换 new 和 delete 有意义

>>> Understand when it makes sense to replace new and delete

- 三个替换编译器提供的 new 和 delete 理由：
  - 检测运用上的错误：自定义 new 操作，可超额分配内存，以额外空间放置特定的 byte patterns(即签名，signature)。对应的 delete 操作可以检查上述签名是否原封不动，若否表示在分配区的某个声生命时间点发生了 overrun(写入点在分配区块尾端之后) 或 underrun(写入点在分配区块起点之前)。此时 delete 可以日志记录该时间和发生错误的指针
  - 强化效能：编译器的 new 和 delete 无法解决碎片问题，导致程序可能无法申请大区块内存。通常来说这种自定制的性能更好
  - 收集使用上的统计数据：先收集软件如何使用动态内存，包括分配区块的大小分布、寿命分布、分配和释放的次序(FIFO/LIFO/随机)、任何时刻内存分配上限
  - 增加分配和释放的速度：当定制型分配器专门针对某特定类型的对象设计时，往往比泛用型分配器更快
  - 降低缺省内存管理器带来的空间额外开销：泛用型内存管理器往往使用更多内存
  - 弥补缺省分配器中的非最佳对齐：缺省的分配器一般是 4 字节对齐，但是对于 x86 最好是 8 字节对齐
  - 将相关对象成簇集中：将往往被一起使用某个数据结构放在一起创建，可以减少 page fault 的错误
  - 获得非传统的行为：比如添加数据初始化工作

### 51.写 new 和 delete 时遵循惯例

>>> Adhere to convention when writing new and delete

- new 操作
  - 应该包含一个无穷循环，并在其中尝试分配内存
  - 如果无法满足需求，调用 new-handler
  - 也应该可以处理 0 字节申请
  - 类的自定义版本还应该处理“比正确大小更大的(错误)申请”
- delete 操作
  - 收到 null 指针不做任何事
  - 类的自定义版本还应该处理“比正确大小更大的(错误)申请”

### 52.写了 placement new 也要写 placement delete

>>> Write placement delete if you write placement new

- 如果自己实现一个 placement operator new，也要写出对应的 placement operator delete。否则会发生隐蔽时断时续的内存泄漏
- 当声明 placement new 和 placement delete，确定不要无意识地遮掩它们的正常版本

## 9.杂项讨论

>>> Miscellany

### 53.注意编译器警告

>>> Pay attention to compiler warnings

- 严肃对待编译器发出的警告信息。努力在编译器的最高(最严苛)警告级别下争取“无任何警告”
- 不要过度依赖编译器的报警能力，因为不同的编译器对待事情的态度不相同。一旦移植到另一个编译器上，原本依赖的警告信息有可能消失

### 54.熟悉包括 TR1 在内的标准库

>>> Familiarize yourself with the standard library, including TR1

### 55.熟悉 Boost

>>> Familiarize yourself with Boost
