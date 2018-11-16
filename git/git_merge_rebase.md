# git merge, git rebase

常进行的操作

- `git checkout dev` 切换到 dev 分支
- commit some modification
- `git checkout master` 切换到 master 分支
- `git pull --rebase origin master` 拉取最新的代码
- 合并分支分两种
  - 刻意制造分支，使得版本迭代历史更加清晰
    - `git merge --no-off dev` 合并 dev 分支代码到 master 分支
    - `--no-off` 即执行正常合并，在当前分支上生成一个合并节点
      - 不加 `--no-off`，git 默认执行“快速合并（fast-forward merge）”，如果 dev 分支本来是基于最新的 master 分支开发的，合并之后 master 分支会指向当前的 dev 分支
  - 将提交历史直线化，使得 master 分支的提交历史没有分叉
    - `git checkout dev` 切换到要合并的分支
    - `git rebase master` 将需要提交的代码变基到最新的 master 分支
    - `git checkout master`  切换到 master 分支
    - `git merge dev` 快速合并 dev 分支
- `git push origin master` 推送代码到远程仓库