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