# 输出重定向

`>` 是定向输出到文件，如果不存在则创建文件，如果文件存在，则覆盖文件；`>>` 是将输出追加到文件，如果不存在则创建文件，如果存在，将新内容追加到原文件末尾。

| 设备 | 设备文件名 | 文件描述符 | 类型 |
| --- | --- | --- | --- |
| 键盘 | `/dev/stdin` | 0 | 标准输入 |
| 显示器 | `/dev/stdout` | 1 | 标准输出 |
| 显示器 | `/dev/stderr` | 2 | 错误输出 |
| 空设备，一般表示丢弃 | `/dev/null` | - | - |

输出重定向是把 stdout 或 stderr 输出到文件。

- stdout 重定向到文件

  | 命令 | 描述 |
  | --- | --- |
  | `cmd > file` | 把 cmd 的 stdout 输出到 file，覆盖原文件(不存在则新建) |
  | `cmd >> file` | 把 cmd 的 stdout 输出到 file，追加到原文件末尾(不存在则新建) |

- stderr 重定向到文件

  | 命令 | 描述 |
  | --- | --- |
  | `cmd 2>file` | 把 cmd 的 stderr 输出到 file，覆盖原文件(不存在则新建) |
  | `cmd 2>>file` | 把 cmd 的 stderr 输出到 file，追加到原文件末尾(不存在则新建) |

  **注意**：`cmd 2>file` 和 `cmd 2>>file` 的重定向符号后面没有空格。

- 同时保存 stdout 和 stderr

  | 命令 | 描述 |
  | --- | --- |
  | `cmd > file 2>&1`/`cmd &>file` | 把 cmd 的 stdout 和 stderr 输出到 file，覆盖原文件(不存在则新建) |
  | `cmd >> file 2>&1`/`cmd &>>file` | 把 cmd 的 stdout 和 stderr 输出到 file，追加到原文件末尾(不存在则新建) |
  | `cmd>>file1 2>file2` |  把 cmd 的 stdout 追加到 file1， 把 cmd 的 stderr 追加到 file2 |

  `2>&1` 表示 2 的输出重定向等同于 1 的输出重定向。否则，写作 `2>1` 会将 2 输出重定向到名为 1 的文件。
