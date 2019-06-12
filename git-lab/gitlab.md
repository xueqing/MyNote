# gitlab

## cache

- 使用 gitlab 的 CI/CD 时，将项目的 runner 设置为 group-runner
- 若同一个 pipeline 中的 stage 之间共享的 cache 依赖于同一个 runner，所以要保证同一个 pipeline 使用的是一个 runner
- 可以定义基类的 job，指定某个 tag  的 runner，其他需要共享 cache 的 job 继承此 job。例如

```yaml
.job:
  tags:
    - vdms1

build-job:
  extends: .job

package-job:
  extends: .job
```

## 问题

- 含有子模块的工程在克隆源码时遇到下面的问题

```txt
Checking out 7f97aadf as master...
Skipping Git submodules setup
```

- 解决方案[参考](https://docs.gitlab.com/ee/ci/git_submodules.html#using-git-submodules-in-your-ci-jobs)
  - 1 确定子模块的 URL 使用相对路径
  - 2 gitlab-runner 版本是 v1.10+ 的，设置`GIT_SUBMODULE_STRATEGY`为`normal`或`recursive`
  - 3 gitlab-runner 版本较低的，在`before-script`中使用`git submodule sync/update`

```yml
 before_script:
   - git submodule sync --recursive
   - git submodule update --init --recursive
```
