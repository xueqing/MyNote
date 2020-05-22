# 版本比较

- [版本比较](#%e7%89%88%e6%9c%ac%e6%af%94%e8%be%83)
  - [diff 插件](#diff-%e6%8f%92%e4%bb%b6)
  - [git diff](#git-diff)
  - [git diff 打补丁](#git-diff-%e6%89%93%e8%a1%a5%e4%b8%81)

## diff 插件

- 可以使用 `git difftool` 命令来用 Araxis , emerge 或 vimdiff 等软件通过图形化的方式或其它格式输出方式输出 diff 分析结果
- 使用 `git difftool --tool-help` 命令查看系统支持哪些 git diff 插件

## git diff

```sh
# 工作目录中当前文件和暂存区域快照之间的差异, 即修改之后还没有暂存起来的变化内容
git diff
# HEAD 和暂存区比较, 即已暂存的将要添加到下次提交里的内容, --staged
git diff --cached
# HEAD 和工作区比较
git diff HEAD
# HEAD 和 HEAD 的父版本比较
git diff HEAD HEAD^
# HEAD 父父版本和 HEAD 的父版本比较
git diff HEAD~2 HEAD^
```

## git diff 打补丁

```sh
# 旧的提交在前，包含 commit1(不包含此次修改) 到 commit2(包含) 的修改
git diff commit1 commit2 --binary -- path_to_diff_file > diff_file.diff
# 检查 diff 是否能正常应用
git apply --check path_to_diff_file.diff
# 应用 diff，不提交
git apply path_to_diff_file.diff
```
