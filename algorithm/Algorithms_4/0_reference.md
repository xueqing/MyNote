# 参考

- [在线](https://introcs.cs.princeton.edu/java/data/)

- 1 FUNDAMENTALS
  - `Writing correct programs` by J. Bentley. Communications of the ACM, Vol. 26, No. 12, pp. 1040-1045 (December 1983).
    - Even binary search is hard to program correctly.
  - `Big Omicron and big Omega and big Theta` by D. Knuth. SIGACT News, 1976.
    - A note on big-Oh and related notations.
  - `On a class of O(n^2) problems in computational geometry` by A. Gajentaan and M. H. Overmars. Computational Geometry, Vol. 5, pp. 165-185 (1995).
    - 3SUM-hard problems.
  - `Set merging algorithms` by J. E. Hopcroft and J. D. Ullman. SIAM Journal on Computing, Vol. 2, No. 4, 294-303 (April 1973).
    - Iterated log analysis of weighted quick union with path compression.
  - `Efficiency of a good but not linear set union algorithm` by R. E. Tarjan. Journal of the ACM, Vol. 22, No. 2, 215-225 (April 1975).
    - Inverse Ackermann analysis of weighted quick union with path compression.
  - `The cell probe complexity of dynamic data structures` by M. L. Fredman and M. E. Saks. In Proceeding of STOC 1989, pp. 345-354.
    - Ackermann lower bound for union-find.

- 2 SORTING
  - `A high-speed sorting procedure` by D. L. Shell. Communications of the ACM, Vol. 2, No. 7 (July 1959).
    - Shellsort algorithm.
  - `Analysis of Shellsort and related algorithms` by R. Sedgewick. Proceedings of ESA 1996, pp. 25-27.
    - Survey of the analysis of Shellsort.
  - `Optimal stable merging` by A. Symvonis. The Computer Journal, Vol. 38, No. 8 (1995).
    - In-place and stable mergesort.
  - `Quicksort` by C. A. R. Hoare. The Computer Journal, Vol. 5, No. 1, pp. 10-16 (1962).
    - Quicksort algorithm.
  - `Implementing quicksort programs` by R. Sedgewick. Communications of the ACM, Vol. 21, No. 10, pp. 847-857 (October 1978).
    - Practical study of how to implement quicksort.
  - `The analysis of quicksort programs` by R. Sedgewick. Act Informatica, Vol. 7, pp. 327-355 (1977).
    - Theoretical analysis of quicksort variants.
  - `Engineering a system sort` by J. L. Bentley and M. D. McIlroy. Software: Practice and Experience, Vol. 23, No. 11, pp. 1249-1265 (November 1993).
    - Bentley-McIlroy 3-way partioning algorithm.
  - `A killer adversary for quicksort` by M. D. McIlroy. Software: Practice and Experience, Vol. 29, No. 4, pp. 1-4 (April 1999).
    - Worst-case inputs for deterministic quicksorts.
  - `Three beautiful quicksorts` by J. L. Bentley. Googl Tech Talks, August 9, 2007.
    - Three implementations of quicksort along with historic context.
  - `Average case analysis of Java 7's dual pivot quicksort` by S. Wild and M. E. Nebel. In Proceedings of the 20th European Symposium on Algorithms, 2012.
    - Analysis of Yaroslavskiy's dual-pivot quicksort used in Java 7.
  - `An analysis of algorithms for the Dutch national flag problem` by C. L. McMaster. Communications of the ACM, Vol. 21, No. 10, pp. 842-847 (October 1978).
    - Various 3-way partitioning algorithms.
  - `Algorithm 232: Heapsort` by J. W. J. Williams. Communications of the ACM, Vol. 7, No. 6, pp. 347-348 (June 1964).
    - Heapsort algorithm.
  - `Algorithm 245: Treesort` by R. W. Floyd. Communications of the ACM, Vol. 7, No. 12, p. 701 (December 1964).
    - Floyd's variant of heapsort.
  - `The analysis of heapsort` by R. Schaffer and R. Sedgewick. Journal of Algorithms, Vol. 15, No, 1, pp. 76-100 (July 1993).
    - Linearithmic best and average case analysis of heapsort.
  - `Time bounds for selection` by M. Blum, R. W. Floyd, V. R. Pratt, R. L. Rivest, and R. E. Tarjan. Journal of Computer and System Sciences, Vol. 7, No. 4, pp. 448-461 (August 1973).
    - Expected linear-time selection algorithm.
  - `Samplesort: a sampling approach to minimal storage tree sorting` by W. D. Frazer and A. C. McKellar. Journal of the ACM, Vol. 17, No. 3, pp. 496-507 (July 1970).
    - Samplesort algorithm.
  - `An efficient algorithm for determining the convex hull of a finite point set` by R. L. Graham. Information Processing Letters, Vol. 1, pp. 132-133 (1972).
    - Graham scan algorithm for convex hull.
  - `A lower bound for finding convex hulls` by A. C. Yao. Journal of the ACM, Vol. 28, No. 4, pp. 780-787 (October 1981).
    - Linearithmic lower bound for convex hull in quadratic decision tree model.
  - `Lower bounds for algebraic computation trees` by M. Ben-Or. In Proceeding of STOC 1983, pp. 80-86.
    - Linearithmic lower bounds for sorting and related problems in algebraic decision tree model.

- 3 SEARCHING
  - `A dichromatic framework for balanced trees` by L. J. Guibas and R. Sedgewick. In Proceedings of FOCS 1978, pp. 8-21.
    - Red-black BSTs.
  - `Randomized binary search trees` by C. Martinez and S. Roura. Journal of the ACM, Vol. 45, No. 2, pp. 288-323 (March 1998).
    - Randomized BSTs.
  - `Self-adjusting binary search trees` by D. D. Sleator and R. E. Tarjan. Journal of the ACM, Vol. 32, No. 3, pp. 652-686 (July 1985).
    - Splay trees.
  - `How tall is a tree` by B. Reed. In proceeding of STOC 2000, pp. 479-483.
    - Asymptotics of height of a randomized BST.
  - `Analysis of the standard deletion algorithms in exact fit domain binary search trees` by J. Culberson and J. I. Munro. Algorithmica, Vol. 5, pp. 295-311 (1990).
    - sqrt(n) analysis for BST with Hibbard deletions.
  - `Exact distribution of individual displacements in linear probing hashing` by A. Viola. ACM Transactions on Algorithms, Vol. 1, No. 2, pp. 214-242 (October 2005).
    - Analysis of Knuth's parking problem.
  - `Multidimensional binary search trees used for associative searching` by J. L. Bentley. Communications of the ACM, Vol. 18, No. 9, pp. 509-517 (September 1975).
    - Kd-tree data structure.

- 4 GRAPHS
  - `Depth-first search and linear graph algorithms` by R. E. Tarjan. SIAM Journal of Computing, Vol. 1, No. 2, pp. 146-160 (June 1972).
    - Linear-time algorithms for strong components and biconnected components.
  - `Finding dominators in directed graphs` by R. E. Tarjan. SIAM Journal of Computing, Vol. 3, No. 1, pp. 62-89 (March 1974).
    - DFS-based topological sorting.
  - `A strong-connectivity algorithm and its applications in data flow analysis` by M. Sharir. Computers and Mathematics with Applications, Vol. 7, pp. 67-72 (1981).
    - Kosaraju's strong components algorithm.
  - `A linear-time algorithm for testing the truth of certain quantified boolean formulas` by B. Aspvall, M. F. Plass, and R. E. Tarjan. Information Processing Letters, Vol. 8, No. 3, pp. 121-123 (1979).
    - Linear-time algorithm for 2SAT using strong components.
  - `On a certain minimal problem` by O. Boruvka.
    - Boruvka's MST algorithm.
  - `A note on two problems in connexion with graphs` by E. W. Dijkstra. Numerische Mathematik, Vol. 1, pp. 269-271 (1959).
    - Dijkstra's shortest paths algorithm.
  - `Shortest connection networks and some generalizations` by R. C. Prim. Bell System Technology Journal, Vol. 36, pp. 1389-1401 (1957).
    - Prim's MST algorithm.
  - `On the shortest spanning subtree of a graph and the traveling salesman problem` by J. B. Kruskal, Jr. Proceedings of the American Mathematical Society, Vol. 7, No. 1, pp. 48-50 (February 1956).
    - Kruskal's MST algorithm.
  - `On a routing problem` by R. Bellman. Quarterly of Applied Mathematics, Vol. 16, pp. 87-90 (1958).
    - Bellman-Ford shortest paths algorithm.
  - `Network flow theory` by L. R. Ford, Jr. Technical Report P-923, The Rand Corporation (August 1956).
    - Bellman-Ford shortest paths algorithm.
  - `Negative-cycle detection algorithms` by B. V. Cherkassky and A. V. Goldberg. Mathematical Programming, Vol. 85, pp. 349-363 (1996).
    - A survey of negative-cycle detection algorithms.
  - `On the history of the minimum spanning tree problem` by R. L. Graham and P. Hell. Annals of the History of Computing, Vol. 7, No. 1, pp. 43-57 (January 1985).
    - An authoritative history of the MST problem.
  - `On the history of combinatorial optimization (till 1960)` by A. Schrijver. Handbook in Operations Research and Management Science, Vol. 12, pp. 1-68 (2005).
    - An authoritative history of several combinatorial optimization problems.

- 5 STRINGS
  - `Engineering Radix Sorts` by P. M. McIlroy, K. Bostic, and M. D. McIlroy. Computing Systems, Vol. 6, No. 1, pp. 5-27 (Winter 1993).
    - Implementations of MSD radix sort.
  - `Data-Specific Analysis of String Sorting` by R. Seidel. SODA 2010.
    - Analysis of string sorting algorithms in the random string model.
  - `Fast pattern matching in strings` by D. E. Knuth, J. H. Morris, and V. R. Pratt. SIAM Journal on Computing, Vol. 6, No. 2, pp. 323-350 (June 1977).
    - Knuth-Morris-Pratt substring search algorithm.
  - `A fast string searching algorithm` by R. S. Boyer and J. S. Boore. Communications of the ACM, Vol. 20, No. 10, pp. 762-772 (October 1977).
    - Boyer-Moore substring search algorithm.
  - `Practical fast searching in strings` by R. N. Horspool. Software: Practice and Experience, VOl. 10, pp. 501-506 (1980).
    - Simpler variant of Boyer-Moore.
  - `Efficient randomized pattern-matching algorithms` by R. M. Karp and M. O. Rabin. IBM Journal of Research and Development, Vol. 31, No. 2, pp. 249-260 (March 1987).
    - Karp-Rabin fingerprint string search.
  - `Fast algorithms for sorting and searching strings` by J. L. Bentley and R. Sedgewick. In Proceedings of SODA 1997.
    - 3-way radix sort and ternary search tries.
  - `A universal algorithm for sequential data compression` by J. Ziv and A. Lempel. IEEE Transactions on Information Theory, Vol. 23, No. 3, pp. 337-343 (May 1977).
    - LZ77 data compression.
  - `Compression of individual sequences via variable-rate coding` by J. Ziv and A. Lempel. IEEE Transactions on Information Theory, Vol. 24, No. 5, pp. 530-536 (September 1978).
    - LZ78 data compression.
  - `A method for the construction of minimum-redundancy codes` by D. Huffman. Institute of Radio Engineers, Vol. 40, No. 9, pp. 1098-1101 (September 1952).
    - Huffman data compression.
  - `A block-sorting lossless data compression algorithm` by M. Burrows and D. J. Wheeler. Technical report 124, Digital Equipment Corporation (May 1994).
    - Burrows-Wheeler data compression.
  - `A locally adaptive data compression scheme` by J.L. Bentley, D. D. Sleator, R. E. Tarjan, and V. K. Wei. Communications of the ACM, Vol. 29, No. 4, pp. 320-330 (April 1986).
    - Move-to-front coding.
  - `PATRICIA—Practical Algorithm To Retrieve Information Coded in Alphanumeric` by D. R. Morrison. Journal of the ACM, Vol. 15, No. 4, pp. 514-534 (October 1968).
    - Patricia tries.

- 6 CONTEXT
  - `Organization and maintenance of large ordered indexes` by R. Bayer and E. McCreight. Acta Informatica, Vol. 1, No. 3, pp. 173-189 (1972).
    - B-tree data structure.
  - `Maximal flow through a network` by L. R. Ford, Jr. and D. R. Fulkerson. Canadian Journal of Mathematics, pp. 399-404 (1956).
    - Ford-Fulkerson algorithm for the maxflow problem.
  - `A note on the maximum flow through a network` by P. Elias, A. Feinstein, and C. E. Shannon. IRE Transactions on Information Theory, Vol. 2, No. 4, pp. 117-119 (December 1956).
    - A proof of the max-flow min-cut theorem, independent, but subsequent to Ford-Fulkerson.
  - `Theoretical improvements in algorithmic efficiency for network flow problems` by J. Edmonds and R. M. Karp. Journal of the ACM, Vol. 19, No. 2, pp. 258-264 (1972).
    - The shortest and highest capacity augmenting path heuristics for the Ford-Fulkerson algorithm.
  - `On implementing push-relabel method for the maximum flow problem` by Boris V. Cherkassky and Andrew V. Goldberg. Integer Programming and Combinatorial Optimization, Vol. 920, pp. 157-171 (1995).
    - Efficient implementations of the push-relabel method for the maximum flow problem.
  - `Computational investigations of maximum flow algorithms` by Ravindra K. Ahuja, Murali Kodialam, Ajay K. Mishra, and James B. Orlin. European Journal of Operations Research, Vol. 97, pp. 509-542 (1997).
    - Comparison of several maximum flow algorithms in practice.
  - `Efficient Maximum Flow Algorithms` by A. V. Goldberg and R. E. Tarjan. Communications of the ACM, pp. 82-89 (2014).
    - Overview of efficient algorithms for the maxflow problem.
  - `Network flow algorithms` by A. V. Goldberg, E. Tardos, and R. E. Tarjan. In Algorithms and Combinatorics edited by B. Korte, L. Lovasz, H. J. Promel, and A. Schrijver.
    - Survey of network flow algorithm.
  - `Notes on suffix sorting` by N. J. Larsson. Tech report LU-CD-TR:98-204, Lund University.
    - Linearithmic analysis of Sadakane's suffix sorting algorithm.
  - `Simple linear work suffix array construction` by J. Karkkainen and P. Sanders.
    - Suffix sorting in linear time.
  - `Paths, trees, and flowers` by J. Edmonds. Canadian Journal of Mathematics, Vol. 17, pp. 449-467 (February 1965).
    - Association of polynomial-time algorithm with efficient algorithm.
  - `The complexity of theorem proving` by S. A. Cook. In Proceedings of STOC 1971, pp. 151-158.
    - Satisfiability is NP-complete.
  - `Reducibility among combinatorial problems` by R. M. Karp. In Complexity of Computer Computations, pp. 85-103.
    - 21 diverse combinatorial problems are NP-complete.