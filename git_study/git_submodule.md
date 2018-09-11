# git submodule

- `git`将`submodule`有关的信息保存在两个地方：
  - `.gitmodules`在仓库中，有版本控制，修改之后会同步到其他仓库，使用`submodule`相关命令的时候会自动更新
  - `.git/config`在本地，需要手动更新，或者执行`git submodule sync`将新的配置从`.gitmodules`拷贝到`.git/config`
  - `git submodule sync`会将`submodule`远程的 url 配置设置到`.gitmodules`，并且只会影响`.git/config`已经有 url 的条目
    - 指定`--recursive`，将会递归更新注册的`submodule`
- 应用场景
  - 场景1：添加一个`submodule`
    - `git submodule add repo_url local_path`
    - 此命令做三件事：克隆工程到本地；创建/修改 `.gitmodules`标记`submodule`的具体信息；更新`.git/config`文件，增加`submodule`的地址
    - 可用`git submodule add -b branch_name repo_url local_path`指定`submodule`跟踪的分支
  - 场景 2：删除一个`submodule`
    - 删除`.git/config`相关代码
    - 删除工程目录下的`.gitmodules`相关代码
    - 删除缓存的子模块`git rm --cached path_to_submodule`(路径最后不要加斜线)
    - 删除`.git/modules`下面的文件夹（曾经手动删除）
  - 场景 3：更新`submodule`的`url`
    - 删除`.git/config`相关代码
    - 删除工程目录下的`.gitmodules`相关代码
    - 执行`git submodule sync --recursive`更新到本地的配置文件
  - 场景 4：克隆一个有`submodule`的项目
    - 分步克隆
      - `git clone repo_url`，`submodule`的代码不会和父项目一起克隆出来
      - `git submodule update --init [--recursive]`可以检出`submodule`的代码，`recursive`适用于嵌套`submodule`的项目
    - 一步克隆
      - `git clone repo_url --recursive`
  - 场景 5：更新`submodule`，与远程仓库同步
    - 更改对应的`submodule`提交到远程仓库
    - 在父工程中，进入该`submodule`，执行`git pull`，可以用`git status`查看`submodule`是否有改到
      - 如果有改到，需要执行`git add`提交该`submodule`的更新
    - 也可在父工程中执行`git submodule update -remote`更新所有子模块到最新版本，再执行`git add`提交所有子模块的更新
    - 注意：在含有子模块的工程中，每次执行`git pull`之后需要执行`git submodule update -remote`更新子模块
    - 技巧：可以通过修改`~/.gitconfig`设置每次`git pull`之后执行`git submodule update -remote`
      ```code
      [alias]
      psu = !git pull && git submodule update
      ```
- 问题
  - 问题 1：`git submodule add`时报错`A git directory for xxx is found locally with remote(s): origin`
    - 删除`.git/config`相关代码
    - 删除工程目录下的`.gitmodules`相关代码
    - 删除缓存的子模块`git rm --cached path_to_submodule``(路径最后不要加斜线)
    - 执行`git submodule sync --recursive`更新到本地的配置文件
  - 问题 2：`git submodule add`时报错`Pathspec xxx is in submodule`
    - 删除缓存的子模块`git rm --cached path_to_submodule`(路径最后不要加斜线)