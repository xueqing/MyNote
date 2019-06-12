# code_review 预研

## [code_review 中的几个提示](https://coolshell.cn/articles/1302.html)

## [从 code_review 谈如何做技术](https://coolshell.cn/articles/11432.html)

## [简单实用的 code_review 工具](https://coolshell.cn/articles/1218.html)

- [Review board](https://www.reviewboard.org/)
  - 追踪待决代码的改动，并可以让 Code-Review 更为容易和简练
- [Codestriker](http://codestriker.sourceforge.net/)
- [Groogle](http://groogle.sourceforge.net/)
  - 各式各样语言的语法高亮
  - 支持整个版本树的比较
  - 支持当个文件不同版本的 diff 功能，并有一个图形的版本树
  - 邮件通知所有的 Reivew 的人当前的状态
  - 认证机制
- [Rietveld](http://code.google.com/p/rietveld/)
- [JCR](http://jcodereview.sourceforge.net/)
  - 主要面对的是大型的项目，或是非常正式的代码评审
  - 主要想协助：
    - 审查者：所有的代码更改会被高亮，以及大多数语言的语法高亮。Code extracts 可以显示代码评审意见。如果你正在 Review Java 的代码，你可以点击代码中的类名来查看相关的类的声明
    - 项目所有者。可以轻松创建并配置需要 Review 的项目，并不需要集成任何的软件配置管理系统（SCM）
    - 流程信仰者。所有的评语都会被记录在数据库中，并且会有状态报告，以及各种各样的统计
    - 架构师和开发者。这个系统也可以让我们查看属于单个文件的评语，这样有利于我们重构代码
- [Jupiter](https://code.google.com/archive/p/jupiter-eclipse-plugin)
  - 是一个 Eclipse IDE 的插件
- 风格检查工具：PC-Lint
