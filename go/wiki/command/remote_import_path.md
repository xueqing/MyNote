# 远程导入路径

一些导入路径也描述了如何使用版本控制系统获取包的源码。

一些常见的代码托管网站有一些特殊的语法：

```txt
Bitbucket (Git, Mercurial)

  import "bitbucket.org/user/project"
  import "bitbucket.org/user/project/sub/directory"

GitHub (Git)

  import "github.com/user/project"
  import "github.com/user/project/sub/directory"

Launchpad (Bazaar)

  import "launchpad.net/project"
  import "launchpad.net/project/series"
  import "launchpad.net/project/series/sub/directory"

  import "launchpad.net/~user/project/branch"
  import "launchpad.net/~user/project/branch/sub/directory"

IBM DevOps Services (Git)

  import "hub.jazz.net/git/user/project"
  import "hub.jazz.net/git/user/project/sub/directory"
```

对于托管在其他服务商的代码，导入路径或者具备版本控制类型，或者 go 工具可以通过 https/http 动态拉取导入路径，然后从 HTML 的 `<meta>` 标签代码位置。

为了声明代码位置，具有形式 `repository.vcs/path` 的导入路径指定了给定的仓库(使用或不使用 .vcs 后缀，使用命名的版本控制系统)和该仓库内的路径。支持的版本控制系统是：

```txt
Bazaar      .bzr
Fossil      .fossil
Git         .git
Mercurial   .hg
Subversion  .svn
```

比如，`import "example.org/user/foo.hg"` 表示根目录在 Mercurial 仓库的 example.org/user/foo 或 foo.hg，且 `import "example.org/repo.git/foo/bar"` 表示 Git 仓库的 foo/bar 目录在 example.org/repo 或 repo.git。

当一个版本控制系统支持多个协议时，下载时轮流尝试每个协议。比如，一个 Git 下载尝试 `https://`，然后是 `git+ssh://`。

默认的，下载受限于已知的安全协议(比如，https 和 ssh)。要覆盖 Git 下载的这个设置，可以设置 GIT_ALLOW_PROTOCOL 环境变量(查看 `go help environment` 获取更多信息)。

如果导入路径不是已知的代码托管网站，且缺少版本控制限定符，go 工具尝试通过 https/http 查找 HTML  `<head>` 的 `<meta>` 标签来拉取导入。

meta 标签有这样的形式 `<meta name="go-import" content="import-prefix vcs repo-root">`。

import-prefix 是对应 repo-root 的导入路径。它必须是一个前缀，或者是借助 `go get` 拉取包的一个精确匹配。如果不是一个精确匹配，生成另外一个 http 请求来验证 meta 标签。

meta 标签应该尽早出现在文件中。特别地，它应该出现在任何原始的 JavaScript 或 CSS 之前，避免使 go 命令受限的解释器不能理解。

vcs 是 bzr/fossil/git/hg/svn 中的一个。

repo-root 是版本控制系统的根，包含了一个体系，但是不包含 .vcs 限定符。

比如，`import "example.org/pkg/foo"` 会导致下面的请求

```sh
https://example.org/pkg/foo?go-get=1 (preferred)
http://example.org/pkg/foo?go-get=1  (fallback, only with -insecure)
```

如果页面包含 meta 标签 `<meta name="go-import" content="example.org git https://code.org/r/p/exproj">`，那么 go 工具会验证 `https://example.org/pkg/foo?go-get=1` 包含相同的 meta 标签，然后使用 `git clone https://code.org/r/p/exproj` 克隆源码到 `GOPATH/src/example.org`。

当使用 GOPATH 时，下载的包被写到 GOPATH 环境变量列举的第一个目录。(查看 `go help gopath-get` 和 `go help gopath`。)

当使用模块时，下载的包存储在模块缓存。(查看 `go help module-get` 和 `go help goproxy`。)

当使用模块时，go-import meta 标签的额外的变量被识别且更倾向于通过这些列举的版本控制系统。比如，在 `<meta name="go-import" content="example.org mod https://code.org/moduleproxy">` 中，该变量使用 “mod” 作为 vcs 内容的值。

这个标签意味着使用以 example.org 开始的路径拉取模块，模块代理可通过 `https://code.org/moduleproxy` URL。查看 `go help goproxy` 获取更多关于代理的信息。
