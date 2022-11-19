# git submodule

- [git submodule](#git-submodule)
  - [应用场景](#应用场景)
  - [问题](#问题)
  - [高级命令](#高级命令)

- `git`将`submodule`有关的信息保存在两个地方：
  - `.gitmodules`在仓库中，有版本控制，修改之后会同步到其他仓库，使用`submodule`相关命令的时候会自动更新
  - `.git/config`在本地，需要手动更新，或者执行`git submodule sync`将新的配置从`.gitmodules`拷贝到`.git/config`
  - `git submodule sync`会将`submodule`远程的 url 配置设置到`.gitmodules`，并且只会影响`.git/config`已经有 url 的条目
    - 指定`--recursive`，将会递归更新注册的`submodule`

## 应用场景

- 场景1：添加一个`submodule`
  - `git submodule add repo_url local_path`
  - 此命令做三件事：克隆工程到本地；创建/修改`.gitmodules`标记`submodule`的具体信息；更新`.git/config`文件，增加`submodule`的地址
  - 可用`git submodule add -b branch_name repo_url local_path`指定`submodule`跟踪的分支
- 场景 2：删除一个`submodule`
  - `git submodule deinit -f -- path_to_submodule`(路径最后不要加斜线)
  - 删除`.git/modules`下面的文件夹
  - 从 git 版本控制中删除缓存的子模块对应文件夹
    - 本地仍保留文件`git rm --cached path_to_submodule`(路径最后不要加斜线)
    - 本地不保留文件`git rm -f path_to_submodule`(路径最后不要加斜线)
- 场景 3：更新`submodule`的`url`
  - 删除`.git/config`相关代码
  - 删除工程目录下的`.gitmodules`相关代码
  - 执行`git submodule sync --recursive`更新到本地的配置文件
- 场景 4：克隆一个有`submodule`的项目
  - 分步克隆
    - `git clone repo_url`，`submodule`的代码不会和父项目一起克隆出来
    - `git submodule update --init [--recursive]`可以检出`submodule`的代码，`recursive`适用于嵌套`submodule`的项目
    - `git submodule update --init [--recursive] subname`可以检出指定子模块`subname`的代码，`recursive`适用于嵌套`submodule`的项目
  - 一步克隆
    - `git clone repo_url --recursive`
- 场景 5：更新`submodule`，与远程仓库同步
  - 更改对应的`submodule`提交到远程仓库
  - 在父工程中，进入该`submodule`，执行`git pull`，可以用`git status`查看`submodule`是否有改到
    - 如果有改到，需要执行`git add`提交该`submodule`的更新
  - 也可在父工程中执行`git submodule update --remote`更新所有子模块到最新版本，再执行`git add`提交所有子模块的更新
  - 注意：在含有子模块的工程中，每次执行`git pull`之后需要执行`git submodule update --remote`更新子模块
  - 技巧：可以通过修改`~/.gitconfig`设置每次`git pull`之后执行`git submodule update --remote`

    ```code
    [alias]
    psu = !git pull && git submodule update
    ```

## 问题

- 问题 1：`git submodule add`时报错`A git directory for xxx is found locally with remote(s): origin`
  - 删除`.git/config`相关代码
  - 删除工程目录下的`.gitmodules`相关代码
  - 删除缓存的子模块`git rm --cached path_to_submodule``(路径最后不要加斜线)
  - 执行`git submodule sync --recursive`更新到本地的配置文件
- 问题 2：`git submodule add`时报错`Pathspec xxx is in submodule`
  - 删除缓存的子模块`git rm --cached path_to_submodule`(路径最后不要加斜线)

## 高级命令

- 查看差异输出，使得子模块的差异输出更加具体`git diff --cached --submodule`
- 修改子模块跟踪分支
  - 只修改本地：修改`.git/config`文件中对应子模块的设置
  - 修改仓库：
    - 修改`.gitmodule`的命令`git config -f .gitmodules submodule.Utility.branch dev`
      - `Utility`是子模块的名字
      - `dev`是`Utility`的分支
      - 不用`-f .gitmodules`只会应用到本地
    - 同步到本地配置`git submodule sync`????
- 在主项目查看子模块的更改摘要：配置选项`status.submodulesummary`，使用命令`git config status.submodulesummary 1`
- 子模块遍历
  - 遍历子模块保存工作进度`git submodule foreach 'git stash save'`
  - 遍历子模块新建工作分支`git submodule foreach 'git checkout -b featureA'`
  - 在主项目查看所有子模块的修改内容`git diff; git submodule foreach 'git diff'`
  - 删除所有子模块本地的修改`git submodule foreach --recursive 'git checkout .'`
  - **如果某个子模块出错，需要跳过错误继续执行**，例如执行`git submodule foreach 'git stash pop'`，有的子模块没有暂存的修改，会出错停止，可以修改命令为`git submodule foreach 'git stash pop || git status'`，总之添加一个一定可以成功执行的命令就好了，例如`git submodule foreach 'git stash pop || echo 1'`
- 在主项目修改子模块
  - `git submodule update`更新子模块的文件时，会将子仓库留在一个`游离的HEAD`状态，本地没有工作分支跟踪改到
  - 首先进入子模块检出一个分支，修改之后提交到本地
  - 拉取远程仓库的子模块提交并合并到本地`git submodule update --remote --rebase/merge`
- 发布子模块的改到
  - 在主项目推送代码到远程仓库前检查本地有没有未推送的子模块修改`git push --recursive-submodules=check`
    - 如果提交的子模块改到未推送，会导致主项目的推送失败，可以根据提示进入子模块然后推送到远程仓库
    - 或者使用`git push --recursive-submodules=on-demand`，`git`会尝试推送子模块修改到远程仓库，只有子模块都推送成功，主项目才可以推送
