# shell 脚本

- [在 shell 脚本中调用另一个脚本](#在-shell-脚本中调用另一个脚本)
- [shell 命令行选项解析](#shell-命令行选项解析)
- [shell 获取脚本的进程 ID](#shell-获取脚本的进程-ID)
- [shell 脚本获取当前时间](#shell-脚本获取当前时间)
- [shell 执行多个命令的方法](#shell-执行多个命令的方法)
- [shell test 命令](#shell-test-命令)
  - [数值测试](#数值测试)
  - [字符串测试](#字符串测试)
  - [文件测试](#文件测试)
  - [连接测试条件](#连接测试条件)
- [shell 变量](#shell-变量)
- [shell 脚本上传 ftp](#shell-脚本上传-ftp)
  - [上传单个文件脚本](#上传单个文件脚本)
- [shell if](#shell-if)
- [shell 操作符](#shell-操作符)
  - [算术操作符](#算术操作符)
  - [关系操作符](#关系操作符)
  - [布尔操作符](#布尔操作符)
  - [string 操作符](#string-操作符)
  - [文件测试运算符](#文件测试运算符)
  - [C Shell 操作符](#C-Shell-操作符)
  - [Korn Shell 操作符](#Korn-Shell-操作符)

## 在 shell 脚本中调用另一个脚本

- fork：直接调用`script_path/filename.sh`(有可执行权限)或者`sh script_path/filename.sh`(没有可执行权限)
  - 运行时终端会新开一个子 shell 执行脚本，子 shell 执行的时候，父 shell 仍在。子 shell 执行完毕返回父 shell，但是父 shell 不能继承子 shell 的环境变量。
- exec：`exec script_path/filename.sh`
  - exec 不需要新开一个子 shell 来执行被调用的脚本，而是在同一个 shell 执行。但是父脚本中`exec`行之后的内容不会被执行。
- source：`source script_path/filename.sh`
  - source 不需要新开一个子 shell 来执行被调用的脚本，而是在同一个 shell 执行。即父脚本可以获取和使用子脚本中声明的变量和环境变量。

    ```sh parent.sh
    #!/bin/bash
    A=1

    echo "before exec/source/fork: PID for parent.sh = $$"

    export A
    echo "In parent.sh: var A=$A"

    case $1 in
        --exec)
            echo -e "==> using exec..\n"
            exec ./child.sh
            ;;
        --source)
            echo -e "==> using source...\n"
            source ./child.sh
            ;;
        *)
            echo -e "==> using fork by default...\n"
            ./child.sh
            ;;
    esac

    echo "after exec/source/fork: PID for parent.sh = $$"
    echo -e "In parent.sh: var A=$A"
    ```

    ```sh child.sh
    #!/bin/bash

    echo "PID for child.sh = $$"
    echo "In child.sh: get var A=$A from parent.sh"

    A=2
    export A
    echo -e "In child.sh: var A=$A\n"
    ```

## shell 命令行选项解析

- `getopts`是 shell 内建命令，`getopt`是一个独立外部工具
- `getopts`语法简单，`getopt`语法较复杂
- `getopts`不支持长参数(如 -dir, --dir)，`getopt`支持
- `getopts`不会重排所有参数顺序，`getopt`会重排参数顺序
- `getopts`是为了代替`getopt`较快捷的执行参数分析工作

### getopts

- 语法`getopts optstring name [args]`
  - `optstring`代表可使用的选项列表，每个字母代码一个选项
    - 带`:`意味着除了定义之外，还会带一个参数作为选项的值
    - 不带`:`是一个开关型选项，不需要指定参数的值
    - 命令行中包含了没有在`getopts`列表中的选项会有警告，在`optstring`前加上`:`可以消除警告
  - `getopts`中有个相对固定的常量`OPTARG`和`OPTIND`
    - `OPTARG`代表当前选项的值
    - `OPTIND`代表当前选项在参数列表中的位置
    - 出现不认识的选项参数为`?`，`case`中最后一个`?`用于处理这种情况，因此选项中不应包含`?`和`,`
  - `getopts`解析完参数后，可以使用`shift`把选项参数进行移位操作，左边的参数就丢失了
    - `shift $(($OPTIND-1))`，参数从 1 开始编号，处理一个开关型选项`OPTIND`加 1，处理一个带值的选项参数`OPTIND`加 2
  - 选项参数的格式是`-d val`，中间需要一个空格
  - 选项参数必须放在其他参数前面，因为遇到非`-`开头的参数或者选项参数结束标记`--`就终止了
  - 中间遇到非选项的命令行参数，后面的选项参数取不到

    ```sh getopts.sh
    #!/bin/bash

    # echo "usage: ./`basename $0` [-d dir_name] [-f file_name] [-c commit_id] [-s service_name] [-N]"
    # echo "initial index $OPTIND"
    while getopts 'd:f:c:s:N' opt;
    do
        case ${opt} in
            d)
                echo "directory name: $OPTARG"
                ;;
            f)
                echo "file name: $OPTARG"
                ;;
            c)
                echo "commit id: $OPTARG"
                ;;
            s)
                echo "service name: $OPTARG"
                ;;
            N)
                echo "use new rep url"
                ;;
            ?)
                echo "usage: ./`basename $0` [-d dir_name] [-f file_name] [-c commit_id] [-s service_name] [-N]"
                exit 1;
                ;;
        esac
        echo "opt is $opt, arg is $OPTARG, index is $OPTIND"
    done

    echo "After process arguments: OPTIND=$OPTIND"
    echo "Remove processed arguments: number=$(($OPTIND-1))"
    shift $(($OPTIND-1))
    echo "Arguments index: OPTIND=$OPTIND"
    echo "Remaing arguments: $@"
    ```

### getopt

- 语法支持三种
  - `getopt optstring parameters`
  - `getopt [options] [--] optstring parameters`
  - `getopt [options] -o|--options optstring [options] [--] parameters`
  - `-o`表示短选项，两个冒号表示该选项有一个可选参数，可选参数必须紧贴选项，中间没有空格
  - `-l|--longoptions`表示长选项
  - `"$@"`将命令行参数展开分别的单词
  - `-n`出错时打印的信息

## shell 获取脚本的进程 ID

- 参数`$$`获取进程 ID
- 参数`$PID`获取父 shell 的进程 ID
- 参数`$UID`获取执行当前的当前用户 ID

## shell 脚本获取当前时间

- 获取当前时间`date +%Y%m%d`或`date +%F`或`date +%y%m%d`
  - Y 年，如 2018
  - y 年的最后两位，如 2018 显示 18
  - m 月(01..12)
  - d 每个月第几天(01..31)
  - F 完整的日志(%Y-%m-%d)
- 输出另外一个时区的时间`env TZ=timezone date`或`env TZ=timezone date  +%Y%m%d`
  - timezone 是指定的时区，比如`America/Los_Angeles`或`Asia/Shanghai`

```shell
starttime=`date +%s`
sleep 10 #sleep 10 sec
endtime=`date +%s`
difftime=$(( endtime - starttime ))
```

## shell 执行多个命令的方法

- 命令之间用`;`隔开：各命令执行结果不影响，即各个命令都会执行
- 命令之间用`&&`隔开：只有前面的命令执行成功，才会执行后面的命令，保证执行过程都是成功的
- 命令之间用`||`隔开：只有前面的命令执行失败，才会执行后面的命令，直到执行成功
  - 可用于捕获子 shell 的错误码，比如`output="$( (cd "$FOLDER"; eval "$@") 2>&1 )" || errcode="$?"`
  - 重要的命令失败时退出自定义错误码，比如`output="$( (cd "$FOLDER"; eval "$@") 2>&1 )" || exit 12`
  - 可以定义函数在`||`之后调用

  ```sh
    handle_error() { #do staff }
    output="$( (cd "$FOLDER"; eval "$@") 2>&1 )" || handle_error
  ```

## shell test 命令

- test 命令用于检查某个条件是否成立，可以进行数值、字符和文件三个方面的测试

### 数值测试

- 运算符：-eq，-ne，-gt，-ge，-lt，-le

```sh
n1=1
n2=2
test $[n1] -eq $[n2] && echo '两个数相等！'
test $[n1] -eq $[n2] || echo '两个数不相等！'
```

- `[]`内执行基本的算术运算

```sh
n1=1
n2=2
n3=$[n1+n2]
```

### 字符串测试

- 运算符： =，!=， -z(字符串长度是否为0)， -n(字符串长度是否不为0)

```sh
s1="s1"
s2="s2"
test $s1 = $s2 && echo '两个字符串相等！'
test $s1 = $s2 || echo '两个字符串不相等！'
```

### 文件测试

- 运算符：-e，-r，-w，-x，-s，-d，-f，-c，-b
  - `-r/w/x`：如果文件存在且可读/可写/可执行
  - `-s`：如果文件存在且至少有一个字符
  - `-f/c/b`：如果文件存在且是普通文件/字符型特殊文件/块特殊文件

```sh
test -e filename && echo "文件已存在！"
test -e filename || echo "文件不存在！"
```

### 连接测试条件

- 可用逻辑操作符将测试条件连接起来：与(-a)，huo(-o)，非(!)

```sh
test -e filename -o -e anotherfile && echo "至少存在一个文件！"
test -e filename -o -e anotherfile || echo "两个文件都不存在！"
```

## shell 变量

- 定义变量是变量名和等号之间不能有空格
- 使用时在前面加上`$`即可
- 删除变量：`unset $VAR`
- 设置变量只读：`readonly $VAR`
- 测试变量是否定义
  - `if (set -u; : $VAR) ; then echo "set" ; else echo "unset" ; fi`
    - `set -u`用于设置 shell 选项，u 是 nounset， 表示当使用未定义的变量时，输出错误并强制退出
    - `:` 是不做任何事只是展开参数，单不会试图去执行
    - 没有`:`则将变量解释成 shell 命令，并试图去执行
  - 使用`-z`或`-n`判断
    - `-z`：字符串长度是否为0
    - `-n`：字符串长度是否不为0

```sh
echo "********************************set KK"
export KK="kiki"
echo KK=$KK
if [ -z $KK ] ; then echo "unset" ; else echo "set" ; fi
if ( set -u; : $KK ) ; then echo "set" ; else echo "unset" ; fi
echo KK=$KK

echo "********************************unset KK"
unset KK
echo KK=$KK
if [ -z $KK ] ; then echo "unset" ; else echo "set" ; fi
if ( set -u; : $KK ) ; then echo "set" ; else echo "unset" ; fi
echo KK=$KK
```

## shell 脚本上传 ftp

### 上传单个文件脚本

```sh
#!/bin/bash
FILENAME=$1
ftp -n -p<<!
## ftp server ip
open ftpIp
## ftp username and password
user ftpUser ftpPwd
## transfer type
binary
## upload path
cd /VDMSSoftware/cppci
## interactive mode
prompt
## upload filename
put $FILENAME
close
## close connection
bye
!
```

- 传输文件类型包括：
  - ascii：默认值。网络 ASCII
  - binary：二进制映像，需要使用二进制方式的文件类型包括 ISO 文件、可执行文件、压缩文件、图片等。此方式比 ascii 更有效
  - ebcdic：
  - image：
  - local M：本地类型。M 参数定义每个计算机字位的十进制数
  - tenex：
- 交互式提示：使用 mget 或 mput 时，`prompt`命令让 ftp 在文件传输前进行提示，防止覆盖已有的文件。若发出 prompt 命令时已经启动了提示，ftp 将关掉提示，此时再传输所有的文件则不会有任何提示

## shell if

- shell 支持 3 中 if 语句
  - `if...fi`
  - `if...else...fi`
  - `if...elif...else...fi`

  ```shell
  if [ $useEncryption != "false" ] && [ $softEncryption != "false" ]
  then
      # do sth
  elif [ $useEncryption != "false" ] && [ $softEncryption == "false" ]
  then
      # do sth
  elif [ $useEncryption == "false" ] && [ $softEncryption != "false" ]
  then
      # do sth
  elif [ $useEncryption == "false" ] && [ $softEncryption == "false" ] # or else
  then
      # do sth
  fi
  ```

## shell 操作符

- 讨论 Bourne shell（默认的 shell） 支持的操作符

### 算术操作符

- Bourne shell 不支持运算符，但是可以使用`awk`或者`expr`外部程序，例如```res=`expr  2 + 2`; echo $res```
- 运算符和表达式之间必须有空格
- Bourne shell 支持的算术运算符包括：（假如`a=10; b=20`）
  - 加法`+`，例如`expr $a + $b`，结果是 30
  - 减法`-`，例如`expr $a - $b`，结果是 -10
  - 乘法`*`，例如`expr $a \* $b`，结果是 200
  - 除法`/`，例如`expr $b / $a`，结果是 2
  - 取模`%`，例如`expr $a % $b`，结果是 0
  - 赋值`=`，例如`a = $b`，结果是 a 被赋值 20
  - 等于`==`，例如`[$a == $b]`，结果是 false
  - 不等于`！=`，例如`[$a != $b]`，结果是 true
- 条件表达式必须在方括号中，且两端有空格隔开

### 关系操作符

- 只对数值生效，string 作为操作数是无效的，例如对`10`和`20`或者`"10"`和`"10"`生效，但是对`ten`和`twenty`无效
  - 无效的 string 是指 string 中包含非数字的字符
- Bourne shell 支持的关系型操作符包括：（假如`a=10; b=20`）
  - 等于`-eq`，例如`[ $a -eq $b ]`，结果是 false
  - 不等于`-ne`，例如`[ $a -ne $b ]`，结果是 true
  - 大于`-gt`，例如`[ $a -gt $b ]`，结果是 false
  - 小于`-lt`，例如`[ $a -lt $b ]`，结果是 true
  - 大于等于`-ge`，例如`[ $a -ge $b ]`，结果是 false
  - 小于等于`-le`，例如`[ $a -le $b ]`，结果是 true
- 条件表达式必须在方括号内，且两端有空格分开
- 其他 shell 可能支持的操作
  - 等于`==`，例如`(( $a == $b ))`，结果是 false
  - 不等于`!=`，例如`[ $a != $b ]`，结果是 true
  - 大于`>`，例如`(( $a > $b ))`，结果是 false
  - 小于`<`，例如`(( $a < $b ))`，结果是 true
  - 大于等于`>=`，例如`(( $a >= $b ))`，结果是 false
  - 小于等于`<=`，例如`(( $a <= $b ))`，结果是 true

### 布尔操作符

- Bourne shell 支持的布尔操作符包括：（假如`a=10; b=20`）
  - 逻辑取否`!`，例如`[ ! false ]`，结果是 true
  - 逻辑或`-o`，例如`[ $a -lt 20 -o $b -gt 100 ]`，结果是 true
  - 逻辑与`-a`，例如`[ $a -lt 20 -a $b -gt 100 ]`，结果是 false

### string 操作符

- Bourne shell 支持的字符串操作符包括：（假如`a="abc"; b="efg"`）
  - 等于`=`，例如`[ $a = $b ]`，结果是 false
  - 不等于`!=`，例如`[ $a != $b ]`，结果是 true
  - 字符串为 null，即长度为 0 `-z`，例如`[ -z $a ]`，结果是 false
    - `-z`的字符串可以不被双引号引用
  - 字符串不为 null，即长度不为 0 `-n`，例如`[ -n $a ]`，结果是 true
    - `-n`的字符串建议用双引号引用，不加双引号可以使用`! -z`
  - 字符串是否不是空串`str`，例如`[ $a ]`，结果是 true
- 其他 shell 可能支持的操作
  - 大于`>`，例如`[[ $a > $b ]]`或`[ $a \> $b ]`，结果是 false
  - 小于`<`，例如`[[ $a < $b ]]`或`[ $a \< $b ]`，结果是 true

### 文件测试运算符

- 假设文件`test`的大小是 100 Bytes，且有读写和可执行权限，`file="test"`
- `-b file`是否是块文件，例如`[ -b $file ]`，结果是 false
- `-c file`是否是字符文件，例如`[ -c $file ]`，结果是 false
- `-d file`是否是文件夹，例如`[ -d $file ]`，结果是 false
- `-f file`是否是普通文件（不是块/字符文件，也不是文件夹），例如`[ -f $file ]`，结果是 true
- `-g file`是否设置了group ID 位，即 SGID，例如`[ -g $file ]`，结果是 false
- `-k file`是否设置了 sticky 位，例如`[ -k $file ]`，结果是 false
- `-p file`是否是一个命名的管道，例如`[ -p $file ]`，结果是 false
- `-t file`文件描述符是否打开且和一个终端相关，例如`[ -t $file ]`，结果是 false
- `-u file`是否设置了 user ID 位，即 SUID，例如`[ -u $file ]`，结果是 false
- `-r file`是否可读，例如`[ -r $file ]`，结果是 true
- `-w file`是否可写，例如`[ -w $file ]`，结果是 true
- `-x file`是否可执行，例如`[ -x $file ]`，结果是 true
- `-s file`文件大小是否大于 0，例如`[ -s $file ]`，结果是 true
- `-e file`文件是否存在，如果是一个存在的文件夹也返回 true，例如`[ -e $file ]`，结果是 true

### [C Shell 操作符](https://www.tutorialspoint.com/unix/unix-c-shell-operators.htm)

### [Korn Shell 操作符](https://www.tutorialspoint.com/unix/unix-korn-shell-operators.htm)