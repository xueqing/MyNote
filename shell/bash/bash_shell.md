# bash

- [bash](#bash)
  - [description](#description)
  - [synopsis](#synopsis)
  - [options](#options)
    - [single character options](#single-character-options)
    - [multi character options](#multi-character-options)
  - [arguments](#arguments)
  - [invocation](#invocation)
  - [definitions](#definitions)
  - [reserverd_words](#reserverd_words)
  - [shell grammar](#shell-grammar)
    - [simple commands](#simple-commands)
    - [pipelines](#pipelines)
    - [lists](#lists)
    - [compound commands](#compound-commands)
    - [coprocesses](#coprocesses)
    - [函数定义](#函数定义)
  - [comments](#comments)
  - [quoting](#quoting)
  - [parameters](#parameters)
    - [positional  parameters](#positional--parameters)
    - [special parameters](#special-parameters)
    - [shell variables](#shell-variables)
    - [array](#array)
  - [expansion](#expansion)
    - [brace expansion](#brace-expansion)
    - [tilde expansion](#tilde-expansion)
    - [parameter expansion](#parameter-expansion)
    - [command substitution](#command-substitution)
    - [arithmetic expansion](#arithmetic-expansion)
    - [process substitution](#process-substitution)
    - [word splitting](#word-splitting)
    - [pathname expansion](#pathname-expansion)
    - [quote removal](#quote-removal)
  - [redirection](#redirection)
    - [input](#input)
    - [output](#output)
    - [appending redirected output](#appending-redirected-output)
    - [redirecting standard output and standard error](#redirecting-standard-output-and-standard-error)
    - [appending standard output and standard error](#appending-standard-output-and-standard-error)
    - [here documents](#here-documents)
    - [here strings](#here-strings)
    - [duplicating file descriptors](#duplicating-file-descriptors)
    - [moving file descriptors](#moving-file-descriptors)
    - [opening file descriptors for reading and writing](#opening-file-descriptors-for-reading-and-writing)
  - [aliases](#aliases)
  - [functions](#functions)
  - [arithmetic evaluation](#arithmetic-evaluation)
  - [conditional expressions](#conditional-expressions)
  - [simple command expansion](#simple-command-expansion)
  - [command execution](#command-execution)
  - [command execution environment](#command-execution-environment)
  - [environment](#environment)
  - [exit status](#exit-status)
  - [signals](#signals)
  - [job control](#job-control)
  - [prompting](#prompting)
  - [readline](#readline)
    - [readline notation](#readline-notation)
    - [readline initialization](#readline-initialization)
    - [readline key bindings](#readline-key-bindings)
    - [readline variables](#readline-variables)
    - [readline conditional constructs](#readline-conditional-constructs)
    - [searching](#searching)
    - [readline command names](#readline-command-names)
    - [commands for moving](#commands-for-moving)
    - [commands for manipulating the history](#commands-for-manipulating-the-history)
    - [commands for changing text](#commands-for-changing-text)
    - [killing and yanking](#killing-and-yanking)
    - [numeric arguments](#numeric-arguments)
    - [completing](#completing)
    - [keyboard macros](#keyboard-macros)
    - [miscellaneous](#miscellaneous)
    - [programmable completion](#programmable-completion)
  - [history](#history)
  - [history expansion](#history-expansion)
    - [event designators](#event-designators)
    - [word designators](#word-designators)
    - [modifiers](#modifiers)
  - [shell builtin commands](#shell-builtin-commands)
  - [restricted shell](#restricted-shell)
  - [files](#files)

## description

- bash(Bourne-Again SHell)，是一种 sh-兼容的命令语言解释器，执行从标准输入或文件读取的命令
- bash 也吸收了 knor 和 C shell(ksh 和 csh)的一些有用的特点

## synopsis

总览`bash [options] [command_string | file]`

## options

### single character options

- `-c`表示从第一个非选项的`command_string`读命令。如果`command_string`之后有参数，赋值给对应位置的参数，从`$0`开始
- `-i`表示 shell 是交互式的
- `-r`表示 shell 是[受限的](#restricted-shell)
- `-s`或者选项后面没有参数，表示从标准输入读命令。这个选项允许在启动交互式 shell 时设置位置参数
- `O [shopt option]`shopt option 是由内置的[shopt](#shell-builtin-commands)接收的参数
  - 如果有`shopt option`，`-O`设置该选项的值；`+O`取消设置
  - 如果没有`shopt option`，选项的名字和值被输出到标准输出
  - 如果调用选项是`+O`，输出按一定格式展示可当做输入
- `--`标记选择的终止，不再处理选项。后面的参数都当做文件名或参数

### multi character options

- `--rcfile file`在交互式 shell 中，执行`file`的命令，而不是系统范围的初始化文件`/etc/bash.bashrc`或标准的个人初始化文件`~/.bashrc`
- `--noprofile`在启动一个交互式 shell 的时候，选项会根据几个默认的文件配置环境。此选项表示不要读这些文件
  - 系统范围的开始文件`/etc/profile`
  - 所有的个人初始化文件`~/.bash_profile`，`~/.bash_login`和`~/.profile`
- `--norc`在交互式 shell 中，不要读系统范围的初始化文件`/etc/bash.bashrc`和标准的个人初始化文件`~/.bashrc`

## arguments

- 如果处理的选项之后还要参数，且没有`-c`和`-s`，第一个参数被认为是包含 shell 命令的文件。`$0`设置成这个文件名，其他的位置参数设置为剩下的参数
- bash 从这个文件读并执行命令，然后退出
- bash 的退出状态是最后执行的命令的状态，没有执行命令则退出状态是 0
- bash 先尝试从当前目录查找文件，如果没有，则从`PATH`中查找这个脚本文件

## invocation

- 当 bash 作为一个交互式的登录 shell，或非交互式的带有`--login`的 shell
  - 如果`/etc/profile`存在则读并执行命令
  - 按照`~/.bash_profile`，`~/.bash_login`和`~/.profile`的顺序查找文件，存在的话就读和执行命令
- 如果是一个登录 shell，如果`~/.bash_logout`文件存在，则读和执行命令
- 如果是一个交互式的非登录 shell如果`/etc/bash.bashrc`和`~/.bashrc`文件存在，则读和执行命令
- 如果是非交互式 shell，比如运行一个 shell 脚本，查找环境的`BASH_ENV`，如果存在则展开它的值

## definitions

- blank 一个空格或制表符
- word shell 认为是一个整体的字符序列，也叫 token
- name 一个只包含字母和下划线的 word，而且以字母或下划线开头，也叫 identifier
- metacharacter 当未加引号时，用来分离 word 的字符，包括`| & ; ( ) < >`、空格和制表符
- control operator 执行一个控制函数的 token，包括`|| & && ; ;; ( ) | |&`和换行

## reserverd_words

保留字是对 shell 有特殊含义的单词。包括`! case coproc do done elif else esac fi for function if in select then until while { } time [[ ]]`

## shell grammar

### simple commands

- 简单命令的格式第一个 word 是要执行的命令，作为参数 0，即`$0`，剩余的 word 作为命令的参数
- 简单命令的返回值就是它的退出状态；如果是被信号`n`终止的，则返回`128+n`

### pipelines

- 一个 pipeline 是一个或多个命令，使用控制操作符`|`或`|&`分割
- 格式`[time [-p]] [ ! ] command [ [|或|&] command2 ... ]`
  - 管道的连接在重定向之前执行
  - 使用`|&`，前一个命令的标准错误和标准输出通过管道连接到下一个命令的标准输入，是`2>&1 |`的简写
  - 返回值
    - 管道的返回值是最后一个目录的返回状态，除非开启了`pipefail`
    - 允许`pipefail`，返回状态是最后一个最正确(rightmost)命令，退出一个非 0 状态，或者都正常退出的话返回 0
    - 管道之前有`!`，则返回的是上述返回值的逻辑否定值
    - shell 等待管道中的所有命令终止才会返回
  - 包括字`time`使得管道终止的时候，报告所有花费的时间，包括用户和系统时间
    - `-p`使用 POSIX 指定的输出格式
- 管道中的每个命令都是一个单独的进程(比如，在一个子 shell 执行)

### lists

- list 是值一个 pipeline 或由符号`; & && ||`分隔的多个 pipeline，以`; &`或换行终止
- 优先级：`&& = || > ; = &`
- 以`&`控制符结尾表示 shell 将在一个子 shell 中执行该命令，且在后台运行，不会等待该命令结束，返回状态是 0
- 以`;`分隔的命令按顺序执行，返回状态是最后执行的命令的返回状态
- `command1 && command2`只有 command1 返回状态是 0 时才会执行 command2
- `command1 || command2`只有 command1 返回状态非 0 时才会执行 command2

### compound commands

- `(list)`在子 shell 中执行 list，返回状态是 list 的返回状态
- `{ list; }`在当前 shell 中执行 list，是`group command`，返回状态是 list 的返回状态
- `((expression))`以[算术求值](#arithmetic-evaluation)规则计算表达式，如果值非 0 则返回 0，否则返回 1，等同于`let "expression"`
- `[[ expression ]]`根据[条件表达式](#conditional-expressions)的值确定返回状态是 0 还是 1
  - 表达式中不会执行[word splitting](#word-splitting)和[pathname expansion](#pathname-expansion)
- 当使用`== !=`时，操作符右边的字符串被认为是模式，根据模式匹配规则
  - `=`等同于`==`
  - 如果 shell 选项`nocasematch`设置的话，可以忽略大小写
  - 匹配返回 0，否则返回 1
- 二元操作符`=~`和`== !=`优先级相同，操作符右边的被视为扩展的正则表达式
  - 如果正则表达式语法错误返回 2
  - 匹配的子串保存在`BASH_REMATCH`中，下标为 0 表示匹配整个子串，下标为 n 表示匹配第 n 个圆括号的子表达式
- 表达式的形式包括
  - `( expression )`返回表达式的值，可用于修改操作符的优先级
  - `! expression`
  - `expression1 && expression2`
  - `expression1 || expression2`
  - `for name [ [ in [ word ... ] ] ; ] do list ; done`
    - `in`后面的内容被扩展，生成一个元素列表
    - `name`每次循环设置成列表中的元素
    - 如果没有`in`，`for`对每个位置参数执行一次
    - 返回状态是最后一个执行命令的返回值
    - 如果`in`生成的元素集合为空，则返回 0，不执行任何命令
  - `for (( expr1 ; expr2 ;  expr3 )) ; do list ; done`
    - 以[算术求值](#arithmetic-evaluation)规则计算`expr1`
    - 重复计算算术表达式`expr2`直到值是 0：每次得到一个非 0 值，执行`list`，然后计算算术表达式`expr3`
    - 如果对应位置的表达式没有，则认为值为 1
    - 返回值是`list`最后一个执行的命令的返回状态；如果所有表达式都是无效的返回 false
  - `select name [ in word ] ; do list ; done`
    - `in`后面的内容被扩展，生成一个元素列表
    - 扩展的单词背打印到标准错误，每个前面一个数字
    - 如果没有`in`，则打印位置参数
    - 每次选择之后执行`list`，知道遇到`break`命令
    - 返回值是`list`最后一个执行的命令的返回状态；如果没有执行命令则返回 0
  - `case word in [ [(] pattern [ | pattern ] ... ) list ;; ] ... esac`
    - 找到匹配，执行对应的`list`
      - 如果使用了`;;`，则不会再继续
      - 如果使用了`;&`，则继续执行后面的`list`
      - 如果使用了`;;&`，则继续尝试匹配后面的模式，如果匹配则执行对应的`list`
    - 如果没有匹配的模式返回 0，否则返回`list`中最后执行的命令的状态
  - `if list; then list; [ elif list; then list; ] ... [ else list; ] fi`
  - `while list-1; do list-2; done`
    - 当`list-1`的最后一个命令的返回状态为 0 时执行`list-2`
    - 返回`list-2`中最后执行的命令的返回状态，什么都没有执行则返回 0
  - `until list-1; do list-2; done`
    - 当`list-1`的最后一个命令的返回状态非 0 时执行`list-2`
    - 返回`list-2`中最后执行的命令的返回状态，什么都没有执行则返回 0

### coprocesses

- 语法`coproc [NAME] command [redirections]`
- 创建一个叫做`NAME`的协同进程，如果不指定则是`COPROC`
- 如果是[简单命令](#simple-commands)则不能知道名字，名字就是简单命令的第一个单词
- 协同进程在一个子 shell 中异步执行，类似于在后台执行命令，在执行的 shell 和协同进程之间建立了一个双向的 pipeline
- 执行协同进程的时候，shell 在执行 shell 的上下文创建一个叫`NAME`的[数组](#array)变量
  - `command`的标准输出通过管道连接到一个文件描述符，值为`NAME[0]`
  - `command`的标准输入通过管道连接到一个文件描述符，值为`NAME[1]`
  - 管道的建立在重定向之前完成
  - 文件描述符可以被 shell 命令和重定向用作参数，子 shell 中不能访问这个文件描述符
  - 执行协同进程的子 shell 的进程 ID可以通过变量`NAME_PID`访问
  - 内置的`wait`命令可用来等待协同进程终止
- `coproc`命令总是返回成功，coprocess 的返回状态是`command`的退出状态

### 函数定义

- 语法支持两种
  - `name () compound-command [redirection]`
  - `function name [()] compound-command [redirection]`
- 定义了一个叫做`name`的函数，关键字`function`可选
- 如果使用了关键字`function`，则圆括号是可选的

## comments

- 在非交互式的 shell 和开启了 interactive_comments 的交互式 shell 中，以`#`开头到行末的内容视为注释

## quoting

- 引用用于移除单词或字符对于 shell 具有的特殊含义，也可用于防止参数扩展
- metacharacter(包括`| & ; ( ) < >`)在加引号时可用来代表自身，而不是分离单词的字符
- 一共有三种引用机制：反斜线、单引号和双引号
  - 反斜线：保留它后面紧跟字符的含义，除了新行(此时代表一行的继续，在输入流中会忽视此反斜线)
  - 单引号：保留单引号

## parameters

### positional  parameters

### special parameters

### shell variables

### array

## expansion

### brace expansion

### tilde expansion

### parameter expansion

### command substitution

### arithmetic expansion

算术扩展支持对算术表达式求值并替换结果。算术扩展的格式为：

```txt
$(( expression ))
```

`expression` 被视为在双引号内，但括号内的双引号不会被特殊处理。对 `expression` 中的所有符号进行参数和变量扩展、命令替换和引号删除。结果被视为要计算的算术表达式。算术扩展可以嵌套。

根据下面列出的[规则]进行求值。如果表达式无效，Bash 会向标准错误打印一条消息指示错误，并且不会发生替换。

### process substitution

### word splitting

### pathname expansion

### quote removal

## redirection

### input

### output

### appending redirected output

### redirecting standard output and standard error

### appending standard output and standard error

### here documents

### here strings

### duplicating file descriptors

### moving file descriptors

### opening file descriptors for reading and writing

## aliases

## functions

## arithmetic evaluation

## conditional expressions

## simple command expansion

## command execution

## command execution environment

## environment

## exit status

## signals

## job control

## prompting

## readline

### readline notation

### readline initialization

### readline key bindings

### readline variables

### readline conditional constructs

### searching

### readline command names

### commands for moving

### commands for manipulating the history

### commands for changing text

### killing and yanking

### numeric arguments

### completing

### keyboard macros

### miscellaneous

### programmable completion

## history

## history expansion

### event designators

### word designators

### modifiers

## shell builtin commands

## restricted shell

## files
