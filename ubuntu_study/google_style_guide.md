# [Google 开源项目风格指南](https://zh-google-styleguide.readthedocs.io/en/latest/contents/)

- [Google 开源项目风格指南](#google-%E5%BC%80%E6%BA%90%E9%A1%B9%E7%9B%AE%E9%A3%8E%E6%A0%BC%E6%8C%87%E5%8D%97)
  - [shell 风格指南](#shell-%E9%A3%8E%E6%A0%BC%E6%8C%87%E5%8D%97)
    - [背景](#%E8%83%8C%E6%99%AF)
    - [shell 文件和解释器调用](#shell-%E6%96%87%E4%BB%B6%E5%92%8C%E8%A7%A3%E9%87%8A%E5%99%A8%E8%B0%83%E7%94%A8)
    - [环境](#%E7%8E%AF%E5%A2%83)
    - [注释](#%E6%B3%A8%E9%87%8A)
    - [格式](#%E6%A0%BC%E5%BC%8F)
      - [缩进](#%E7%BC%A9%E8%BF%9B)
      - [行的长度和长字符串](#%E8%A1%8C%E7%9A%84%E9%95%BF%E5%BA%A6%E5%92%8C%E9%95%BF%E5%AD%97%E7%AC%A6%E4%B8%B2)
      - [管道](#%E7%AE%A1%E9%81%93)
      - [循环](#%E5%BE%AA%E7%8E%AF)
      - [case 语句](#case-%E8%AF%AD%E5%8F%A5)
      - [变量扩展](#%E5%8F%98%E9%87%8F%E6%89%A9%E5%B1%95)
      - [引用](#%E5%BC%95%E7%94%A8)
    - [特性及错误](#%E7%89%B9%E6%80%A7%E5%8F%8A%E9%94%99%E8%AF%AF)
      - [命令替换](#%E5%91%BD%E4%BB%A4%E6%9B%BF%E6%8D%A2)
      - [`test`,`[`和`[[`](#test%E5%92%8C)
      - [测试字符串](#%E6%B5%8B%E8%AF%95%E5%AD%97%E7%AC%A6%E4%B8%B2)
      - [文件名的通配符扩展](#%E6%96%87%E4%BB%B6%E5%90%8D%E7%9A%84%E9%80%9A%E9%85%8D%E7%AC%A6%E6%89%A9%E5%B1%95)
      - [eval](#eval)
      - [管道导向 while 循环](#%E7%AE%A1%E9%81%93%E5%AF%BC%E5%90%91-while-%E5%BE%AA%E7%8E%AF)
    - [命名约定](#%E5%91%BD%E5%90%8D%E7%BA%A6%E5%AE%9A)
      - [函数名](#%E5%87%BD%E6%95%B0%E5%90%8D)
      - [变量名](#%E5%8F%98%E9%87%8F%E5%90%8D)
      - [常量和环境变量名](#%E5%B8%B8%E9%87%8F%E5%92%8C%E7%8E%AF%E5%A2%83%E5%8F%98%E9%87%8F%E5%90%8D)
      - [源文件名](#%E6%BA%90%E6%96%87%E4%BB%B6%E5%90%8D)
      - [只读变量](#%E5%8F%AA%E8%AF%BB%E5%8F%98%E9%87%8F)
      - [使用本地变量](#%E4%BD%BF%E7%94%A8%E6%9C%AC%E5%9C%B0%E5%8F%98%E9%87%8F)
      - [函数位置](#%E5%87%BD%E6%95%B0%E4%BD%8D%E7%BD%AE)
      - [主函数 main](#%E4%B8%BB%E5%87%BD%E6%95%B0-main)
    - [调用命令](#%E8%B0%83%E7%94%A8%E5%91%BD%E4%BB%A4)
  - [C++ 风格指南](#c-%E9%A3%8E%E6%A0%BC%E6%8C%87%E5%8D%97)
  - [Python 风格指南](#python-%E9%A3%8E%E6%A0%BC%E6%8C%87%E5%8D%97)

- [shell 风格指南](./shell-风格指南)
- [C++ 风格指南](./C++-风格指南)
- [Python 风格指南](./Python-风格指南)

## [shell 风格指南](https://zh-google-styleguide.readthedocs.io/en/latest/google-shell-styleguide/contents/)

### 背景

- 使用哪一种 shell
  - bash 是唯一被允许执行的 shell 脚本语言
  - 可执行文件以`#!/bin/bash`开始
  - 使用`set`设置 shell 的选项
- 什么时候使用 shell
  - 仅被用于小功能或简单的包装脚本
  - 如果在乎性能，不使用 shell
  - 需要使用数据而不是变量赋值，如`${PHPESTATUS}`，使用 Python 脚本
  - 脚本超过 100 行，尽可能使用 Python，以免之后花更多时间重写脚本

### shell 文件和解释器调用

- 文件扩展名
  - 可执行文件应该没有扩展名（强烈建议）或使用`.sh`扩展名
  - 库文件使用`.sh`扩展名，且不可执行
- SUID/SGID
  - 禁止在脚本中使用 SUID(Set User ID) 和 SGID(Set Group ID)
  - 如果需要较高权限使用`sudo`

### 环境

- STDOUT vs STDERR
  - 所有错误信息应导向 STDERR
  - 便于从实际问题中分离出正常状态
  - 推荐使用如下函数，打印错误信息和其他状态信息

  ```shell
  err() {
      echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@" >&2
  }

  if ! do_sth; then
      err "Unable to do_sth"
      exit "${E_DID_NOTHING}"
  fi
  ```

### 注释

- 文件头
  - 文件必须包含一个顶层注释，简要概述内容。版权声明和作者信息可选
  - 例如

  ```shell
  #!/bin/bash
  #
  # Perform hot bakeups of Oracle databases.
  ```

- 功能注释
  - 除了明显简短的函数必须被注释
  - 库函数都必须注释
  - 注释包括
    - 函数的描述
    - 全局变量的使用和修改
    - 使用的参数说明
    - 返回值，而不是上一条命令运行后默认的退出状态
  - 例如

  ```shell
  #!/bin/bash
  #
  # Perform hot bakeups of Oracle databases.

  export PATH='/usr/xpg4/bin:/usr/bin:/opt/csw/bin:/opt/goog/bin'

  #######################################
  # Cleanup files from the backup dir
  # Globals:
  #   BACKUP_DIR
  #   ORACLE_SID
  # Arguments:
  #   None
  # Returns:
  #   None
  #######################################
  cleanup() {
    #...
  }
  ```

- 实现部分的注释
  - 注释代码中有技巧、不明显、有趣或重要的部分
  - 不要注释所有代码，简单注释
- TODO 注释
  - 使用 TODO 注释临时的、短期解决方案的、或足够好但不完美的代码
  - 应包含全部大写的字符串 TODO + 用户名，冒号可选，最好在后面加上 bug 或 ticket 的序号
  - 例如`# TODO(kiki): Handle the unlikely edge cases (bug ####)`

### 格式

#### 缩进

- 缩进两个空格，没有制表符
- 代码块直接使用空行提升可读性
- 对于已有文件，保持已有的缩进风格

#### 行的长度和长字符串

- 行的最大长度为 80 个字符
- 使用 here document 或嵌入的换行符
- 例如

```shell
# DO use 'here document's
cat <<END;
I am an exceptionally long
string.
END

# Embedded newlines are ok too
long_string="I am an exceptionally
long string."
```

#### 管道

- 如果一行容不下一个管道，将正哥管道操作分割成梅钢一个管道
- 管道操作的下一部分应放在新行且缩进两个空格
- 例如

```shell
# All fits on one line
command1 | command2

# Long commands
command1 \
| command2 \
| command3 \
| command4
```

#### 循环

- 将`; do`，`; then`和`while`，`for`，`if`放在同一行
- `else`单独成一行
- 结束语句单独一行并与开始语句垂直对齐
- 例如

```shell
for dir in ${dirs_to_cleanup}; do
if [[ -d "${dir}/${ORACLE_SID}" ]]; then
    log_date "Cleaning up old files in ${dir}/${ORACLE_SID}"
    rm "${dir}/${ORACLE_SID}/"*
    if [[ "$?" -ne 0 ]]; then
    error_message
    fi
else
    mkdir -p "${dir}/${ORACLE_SID}"
    if [[ "$?" -ne 0 ]]; then
    error_message
    fi
fi
done
```

#### case 语句

- 通过 2 个空格缩进可选项
- 同一行可选项的模式右圆括号知乎和结束符`;;`之前各一个空格
- 长可选项或多命令可选项应被拆成多行，模式、操作和结束符`;;`在不同的行

```shell
# multi-lines
case "${expression}" in
a)
    variable="..."
    some_command "${variable}" "${other_expr}" ...
    ;;
absolute)
    actions="relative"
    another_command "${actions}" "${other_expr}" ...
    ;;
*)
    error "Unexpected expression '${expression}'"
    ;;
esac

# one-line
verbose='false'
aflag=''
bflag=''
files=''
while getopts 'abf:v' flag; do
case "${flag}" in
    a) aflag='true' ;;
    b) bflag='true' ;;
    f) files="${OPTARG}" ;;
    v) verbose='true' ;;
    *) error "Unexpected option ${flag}" ;;
esac
done
```

#### 变量扩展

- 按照优先级顺序
  - 与现存代码发现的保持一致
  - 阅读[引用变量](#引用)
  - 推荐使用`${var}`而不是`$var`
- 例如

```shell
# Section of recommended cases.

# Preferred style for 'special' variables:
echo "Positional: $1" "$5" "$3"
echo "Specials: !=$!, -=$-, _=$_. ?=$?, #=$# *=$* @=$@ \$=$$ ..."

# Braces necessary:
echo "many parameters: ${10}"

# Braces avoiding confusion:
# Output is "a0b0c0"
set -- a b c
echo "${1}0${2}0${3}0"

# Preferred style for other variables:
echo "PATH=${PATH}, PWD=${PWD}, mine=${some_var}"
while read f; do
  echo "file=${f}"
done < <(ls -l /tmp)

# Section of discouraged cases

# Unquoted vars, unbraced vars, brace-quoted single letter
# shell specials.
echo a=$avar "b=$bvar" "PID=${$}" "${1}"

# Confusing use: this is expanded as "${1}0${2}0${3}0",
# not "${10}${20}${30}
set -- a b c
echo "$10$20$30"
```

#### 引用

- 除非需要小心不带引用的扩展，否则总是引用包含变量、命令替换符、空格或 shell 元字符的字符串
- 推荐引用是单词的字符串(而不是命令选项或者路径名)
- 不要引用整数
- 注意`[[`中模式匹配的引用规则
- 请使用`$@`除非有特殊原因需要使用`S*`

```shell
# 'Single' quotes indicate that no substitution is desired.
# "Double" quotes indicate that substitution is required/tolerated.

# Simple examples
# "quote command substitutions"
flag="$(some_command and its args "$@" 'quoted separately')"

# "quote variables"
echo "${flag}"

# "never quote literal integers"
value=32
# "quote command substitutions", even when you expect integers
number="$(generate_number)"

# "prefer quoting words", not compulsory
readonly USE_INTEGER='true'

# "quote shell meta characters"
echo 'Hello stranger, and well met. Earn lots of $$$'
echo "Process $$: Done making \$\$\$."

# "command options or path names"
# ($1 is assumed to contain a value here)
grep -li Hugo /dev/null "$1"

# Less simple examples
# "quote variables, unless proven false": ccs might be empty
git send-email --to "${reviewers}" ${ccs:+"--cc" "${ccs}"}

# Positional parameter precautions: $1 might be unset
# Single quotes leave regex as-is.
grep -cP '([Ss]pecial|\|?characters*)$' ${1:+"$1"}

# For passing on arguments,
# "$@" is right almost everytime, and
# $* is wrong almost everytime:
#
# * $* and $@ will split on spaces, clobbering up arguments
#   that contain spaces and dropping empty strings;
# * "$@" will retain arguments as-is, so no args
#   provided will result in no args being passed on;
#   This is in most cases what you want to use for passing
#   on arguments.
# * "$*" expands to one argument, with all args joined
#   by (usually) spaces,
#   so no args provided will result in one empty string
#   being passed on.
# (Consult 'man bash' for the nit-grits ;-)

set -- 1 "2 two" "3 three tres"; echo $# ; set -- "$*"; echo "$#, $@")
set -- 1 "2 two" "3 three tres"; echo $# ; set -- "$@"; echo "$#, $@")
```

### 特性及错误

#### 命令替换

- 使用`${command}`而不是反引号
- 嵌套的反引号要求用反斜杠转义内部的反引号，而`${command}`形式嵌套时不需要改变，易于阅读
- 例如

```shell
# This is preferred:
var="$(command "$(command1)")"

# This is not:
var="`command \`command1\``"
```

#### `test`,`[`和`[[`

- 推荐使用`[[ ... ]]`，而不是`[`，`test`和`/usr/bin [`
- 在`[[ ... ]]`之间不会有路径名称扩展或单词分割发生，且允许正则表达式匹配
- 例如

```shell
# This ensures the string on the left is made up of characters in the
# alnum character class followed by the string name.
# Note that the RHS should not be quoted here.
# For the gory details, see
# E14 at http://tiswww.case.edu/php/chet/bash/FAQ
if [[ "filename" =~ ^[[:alnum:]]+name ]]; then
echo "Match"
fi

# This matches the exact pattern "f*" (Does not match in this case)
if [[ "filename" == "f*" ]]; then
echo "Match"
fi

# This gives a "too many arguments" error as f* is expanded to the
# contents of the current directory
if [ "filename" == f* ]; then
echo "Match"
fi
```

#### 测试字符串

- 尽可能使用引用，而不是过滤字符串
- 使用空`-z`或非空`-n`字符串测试，而不是过滤字符串
- 例如

```shell
# Do this:
if [[ "${my_var}" = "some_string" ]]; then
do_something
fi

# -z (string length is zero) and -n (string length is not zero) are
# preferred over testing for an empty string
if [[ -z "${my_var}" ]]; then
do_something
fi

# This is OK (ensure quotes on the empty side), but not preferred:
if [[ "${my_var}" = "" ]]; then
do_something
fi

# Not this:
if [[ "${my_var}X" = "some_stringX" ]]; then
do_something
fi

# Use this
if [[ -n "${my_var}" ]]; then
do_something
fi

# Instead of this as errors can occur if ${my_var} expands to a test
# flag
if [[ "${my_var}" ]]; then
do_something
fi
```

#### 文件名的通配符扩展

- 使用明确的路径
- 文件名可能以`-`开头，使用扩展通配符`./*`比`*`更安全
- 例如

```shell
# Here's the contents of the directory:
# -f  -r  somedir  somefile

# This deletes almost everything in the directory by force
rm -v *
#removed directory: `somedir'
#removed `somefile'

# As opposed to:
rm -v ./*
#removed `./-f'
#removed `./-r'
#rm: cannot remove `./somedir': Is a directory
#removed `./somefile'
```

#### eval

- 避免使用 eval
- 当用于给变量赋值时，eval 解析输入，并能够设置变量，但无法检查变量是什么
- 例如

```shell
# What does this set?
# Did it succeed? In part or whole?
eval $(set_my_variables)

# What happens if one of the returned values has a space in it?
variable="$(eval some_function)"
```

#### 管道导向 while 循环

- 使用过程替换或 for 虚幻，而不是管道导向 while 循环
- 在 while 循环中被修改的变量不能传递给父 shell，因为循环命令是在一个子 shell 中运行的

```shell
last_line='NULL'
your_command | while read line; do
  last_line="${line}"
done

# This will output 'NULL'
echo "${last_line}"
```

- 如果确定输入中不包含空格或特殊符号，可使用一个 for 循环

```shell
total=0
# Only do this if there are no spaces in return values.
for value in $(command); do
  total+="${value}"
done
```

- 使用过程替换允许重定向输出，但是请将命令放入一个显式的子 shell 中，而不是 bash 为 while 循环创建的隐式子 shell

```shell
total=0
last_file=
while read count filename; do
  total+="${count}"
  last_file="${filename}"
done < <(your_command | uniq -c)

# This will output the second field of the last line of output from
# the command.
echo "Total = ${total}"
echo "Last one = ${last_file}"
```

- 当不需要传递复杂的结果给父 shell 时可使用 while 循环，当不希望改变父 shell 的范围变量时也是有用的

```shell
# Trivial implementation of awk expression:
#   awk '$3 == "nfs" { print $2 " maps to " $1 }' /proc/mounts
cat /proc/mounts | while read src dest type opts rest; do
  if [[ ${type} == "nfs" ]]; then
    echo "NFS ${dest} maps to ${src}"
  fi
done
```

### 命名约定

#### 函数名

- 使用小写字符，用下划线分割单词，使用双冒号`::`分割库
- 函数名之后必须有圆括号。关键词`function`可选，但必须在一个项目中保持一致
  - 函数名之后有括号时，关键词`function`是多余的，但是促进了函数的快速辨识
- 大括号和函数名位于同一行，且函数名和圆括号之间没有空格
- 例如

```shell
# Single function
my_func() {
  #...
}

# Part of a package
mypackage::my_func() {
  #...
}
```

#### 变量名

- 如[函数名](#函数名)
- 循环的变量名应该和循环的任何变量同样命名
- 例如

```shell
for zone in ${zones}; do
  something_with "${zone}"
done
```

#### 常量和环境变量名

- 全部大写，用下划线分割，声明在文件的顶部
- 有的第一次设置就变成了常量(如通过 getopts)，所以可以在 getopts 或基于条件来设定常量，但之后应立即设置为只读
- 在函数中`declare`不会对全局变量进行操作，所以推荐使用`readonly`和`export`

```shell
# Constant
readonly PATH_TO_FILES='/some/path'

# Both constant and environment
declare -xr ORACLE_SID='PROD'

VERBOSE='false'
while getopts 'v' flag; do
  case "${flag}" in
    v) VERBOSE='true' ;;
  esac
done
readonly VERBOSE
```

#### 源文件名

- 小写，可使用下划线分割单词

#### 只读变量

- 使用`readonly`或`declare -r`确保变量只读
- 因为全局变量在 shell 中广泛使用，所以在使用过程中捕获错误很重要。明确只读变量

```shell
zip_version="$(dpkg --status zip | grep Version: | cut -d ' ' -f 2)"
if [[ -z "${zip_version}" ]]; then
  error_message
else
  readonly zip_version
fi
```

#### 使用本地变量

- 使用`local`声明特定功能的变量，可以确保只在函数内部和子函数中可见，避免了污染全局命名空间
- 当赋值的值由命令替换提供时，声明和赋值需分开。因为内建的`local`命令不会从命令替换中传递退出码
- 例如

```shell
my_func2() {
  local name="$1"

  # Separate lines for declaration and assignment:
  local my_var
  my_var="$(my_func)" || return

  # DO NOT do this: $? contains the exit code of 'local', not my_func
  local my_var="$(my_func)"
  [[ $? -eq 0 ]] || return
}
```

#### 函数位置

- 将文件中所有函数一起放在常量下面，不要在函数直接隐藏可执行代码
- 只有`includes`，`set`声明和常量设置可能在函数声明之前完成

#### 主函数 main

- 对于包含至少一个其他函数的足够长的脚本，需要称为`main`的函数
- 便于查找程序的开始，同时允许定义更多变量为局部变量
- 文件中最后的非注释行应该是对`main`函数的调用`main "$@"`

### 调用命令

- 检查返回值
  - 总是检查返回值，并给出信息返回值
  - 对于非管道命令，使用`$?`或直接通过一个`if`语句来检查以保持简洁
  - 例如

  ```shell
  if ! mv "${file_list}" "${dest_dir}/" ; then
    echo "Unable to move ${file_list} to ${dest_dir}" >&2
    exit "${E_BAD_MOVE}"
  fi
  
  # Or
  mv "${file_list}" "${dest_dir}/"
  if [[ "$?" -ne 0 ]]; then
    echo "Unable to move ${file_list} to ${dest_dir}" >&2
    exit "${E_BAD_MOVE}"
  fi
  ```

  - bash 也有`PIPESTATUS`变量，允许检查从管道所有部分返回的代码
  - 如果仅仅检查整个管道成功还是失败，可用下面的方法

  ```shell
  tar -cf - ./* | ( cd "${dir}" && tar -xf - )
  if [[ "${PIPESTATUS[0]}" -ne 0 || "${PIPESTATUS[1]}" -ne 0 ]]; then
    echo "Unable to tar files to ${dir}" >&2
  fi
  ```

  - 只要运用任何其他命令，`PIPESTATUS`会被覆盖。如果需要机遇管道中发生的错误执行不同的操作，需要在运行命令后立即将`PIPESTATUS`赋值给另一个变量，`[`是一个会将`PIPESTATUS`擦出的命令
  - 例如

  ```shell
  tar -cf - ./* | ( cd "${DIR}" && tar -xf - )
  return_codes=(${PIPESTATUS[*]})
  if [[ "${return_codes[0]}" -ne 0 ]]; then
    do_something
  fi
  if [[ "${return_codes[1]}" -ne 0 ]]; then
    do_something_else
  fi
  ```

- 内建命令和外部命令
  - 在调用 shell 内建命令和调用另外的程序之间选择，选择内建命令
  - 例如在`bash(1)`中参数扩展函数，内建函数更强健和便携，尤其是跟`sed`这样的命令比较
  - 例如

  ```shell
  # Prefer this:
  addition=$((${X} + ${Y}))
  substitution="${string/#foo/bar}"
  
  # Instead of this:
  addition="$(expr ${X} + ${Y})"
  substitution="$(echo "${string}" | sed -e 's/^foo/bar/')"
  ```

## [C++ 风格指南](https://zh-google-styleguide.readthedocs.io/en/latest/google-cpp-styleguide/contents/)

## [Python 风格指南](https://zh-google-styleguide.readthedocs.io/en/latest/google-python-styleguide/contents/)
