# 备忘录

- [在线](https://algs4.cs.princeton.edu/cheatsheet/)

## 排序

- 表格总结比较了不同的排序算法(以 java 源码为准)。它包含了常数系数但是忽视了低阶元素
- † n lg n if all keys are distinct

| ALGORITHM | CODE | IN PLACE | STABLE | BEST | AVERAGE | WORST | REMARKS |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 选择排序(selection sort) | [Selection.java](https://algs4.cs.princeton.edu/21elementary/Selection.java.html) | ✔ |  | ½ n 2 | ½ n 2 | ½ n 2 | n exchanges; quadratic in best case |
| 插入排序(insertion sort) | [Insertion.java](https://algs4.cs.princeton.edu/21elementary/Insertion.java.html) | ✔ | ✔ | n | ¼ n 2 | ½ n 2 | use for small or partially-sorted arrays |
| 冒泡排序(bubble sort) | [Bubble.java](https://algs4.cs.princeton.edu/21elementary/Bubble.java.html) | ✔ | ✔ | n | ½ n 2 | ½ n 2 | rarely useful; use insertion sort instead |
| 希尔排序(shell's sort) | [Shell.java](https://algs4.cs.princeton.edu/21elementary/Shell.java.html) | ✔ |  | n log3 n | unknown | c n 3/2 | tight code; subquadratic |
| 归并排序(merge sort) | [Merge.java](https://algs4.cs.princeton.edu/22mergesort/Merge.java.html) |  | ✔ | ½ nlgn | n lg n | n lg n | n log n guarantee; stable |
| 快速排序(quick sort) | [Quick.java](https://algs4.cs.princeton.edu/23quicksort/Quick.java.html) | ✔ |  | n lg n | 2 n ln n | ½ n 2 | n log n probabilistic guarantee; fastest in practice |
| 堆排序(heap sort) | [Heap.java](https://algs4.cs.princeton.edu/24pq/Heap.java.html) | ✔ |  | n | 2 n lg n | 2 nlgn | n log n guarantee; in place |

## 优先队列

- 表格总结比较了不同优先队列操作的运行时间的增长阶(以 java 源码为准)。它忽视了常数系数和低阶元素。但是所有的运行时间都是按照最差情况得到的
- The table below summarizes the order of growth of the running time of operations for a variety of priority queues, as implemented in this textbook. It ignores leading constants and lower-order terms. Except as noted, all running times are worst-case running times.
- † amortized guarantee

| DATA STRUCTURE | CODE | INSERT | DEL-MIN | MIN | DEC-KEY | DELETE | MERGE |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 数组(array) | [BruteIndexMinPQ.java](https://algs4.cs.princeton.edu/24pq/BruteIndexMinPQ.java.html) | 1 | n | n | 1 | 1 | n |
| 二叉堆(binary heap) | [IndexMinPQ.java](https://algs4.cs.princeton.edu/24pq/IndexMinPQ.java.html) | log n | log n | 1 | log n | log n | n |
| 多叉堆(d-way/d-ary heap) | [IndexMultiwayMinPQ.java](https://algs4.cs.princeton.edu/99misc/IndexMultiwayMinPQ.java.html) | logd n | d logd n | 1 | logd n | d logd n | n |
| 二项堆(binomial heap) | [IndexBinomialMinPQ.java](https://algs4.cs.princeton.edu/99misc/IndexBinomialMinPQ.java.html) | 1 | log n | 1 | log n | log n | log n |
| 斐波那契堆(Fibonacci heap) | [IndexFibonacciMinPQ.java](https://algs4.cs.princeton.edu/99misc/IndexFibonacciMinPQ.java.html) | 1 | log n † | 1 | 1 † | log n † | 1 |
