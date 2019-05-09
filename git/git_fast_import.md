# 制造历史

- [制造历史](#%E5%88%B6%E9%80%A0%E5%8E%86%E5%8F%B2)
  - [git fast-import](#git-fast-import)
  - [git fast-export](#git-fast-export)

## git fast-import

- `git fast-import`支持从一个特定格式的文本读入，从头创建 git 历史记录
- 可用这个命令很快写一个脚本运行一次，一次迁移整个项目
- 写一个临时文件置于`/tmp/history`，文本内容如下

```txt
commit refs/heads/master
committer Alice <alice@example.com> Thu, 01 Jan 1970 00:00:00 +0000
data <<EOT
Initial commit.
EOT

M 100644 inline hello.c
data <<EOT
#include <stdio.h>

int main() {
  printf("Hello, world!\n");
  return 0;
}
EOT


commit refs/heads/master
committer Bob <bob@example.com> Tue, 14 Mar 2000 01:59:26 -0800
data <<EOT
Replace printf() with write().
EOT

M 100644 inline hello.c
data <<EOT
#include <unistd.h>

int main() {
  write(1, "Hello, world!\n", 14);
  return 0;
}
EOT
```

```sh
# 使用上述临时文件创建一个 git 仓库
mkdir project; cd project; git init
git fast-import --date-format=rfc2822 < /tmp/history
# 检出最新版本
git checkout master
```

## git fast-export

- `git fast-export`可将任意仓库转成`git fast-import`格式