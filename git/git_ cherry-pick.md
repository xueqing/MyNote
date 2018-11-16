# git cherry-pick

1. 选择某次提交应用到当前分支 `git cherry-pick <commit-id>`
2. 选择某次提交应用到当前分支，并保留原提交者信息 `git cherry-pick -x <commit-id>`
3. 批量操作
    1. 应用 start-commit-id （不包含） 到 end-commit-id （包含）之间的提交到当前分支 `git cherry-pick <start-commit-id>..<end-commit-id>`
    2. 应用 start-commit-id （包含） 到 end-commit-id （包含）之间的提交到当前分支   `git cherry-pick <start-commit-id>^..<end-commit-id>`