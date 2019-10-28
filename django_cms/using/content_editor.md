# 内容编辑参考

- [内容编辑参考](#%e5%86%85%e5%ae%b9%e7%bc%96%e8%be%91%e5%8f%82%e8%80%83)
  - [管理页面](#%e7%ae%a1%e7%90%86%e9%a1%b5%e9%9d%a2)
    - [接口](#%e6%8e%a5%e5%8f%a3)
      - [django CMS](#django-cms)
      - [Site menu](#site-menu)
      - [Page menu](#page-menu)
      - [Language menu](#language-menu)
      - [Publishing controller](#publishing-controller)
    - [管理员视图和组成](#%e7%ae%a1%e7%90%86%e5%91%98%e8%a7%86%e5%9b%be%e5%92%8c%e7%bb%84%e6%88%90)
      - [页面列表](#%e9%a1%b5%e9%9d%a2%e5%88%97%e8%a1%a8)

## 管理页面

### 接口

django CMS 的工具栏包括以下几部分。

#### django CMS

返回到网站的主页。

#### Site menu

example.com 是网站菜单。这个菜单开放一些对网站的管理控制。

- `Pages ...`：直接跳转到页面编辑接口
- `Users ...`：直接跳转到用户管理面板
- `Administration ...`：跳转到网站管理员面板
- `User settings ...`：切换管理员界面和工具栏的语言
- `Disable toolbar`：无论登录和工作状态如何，完全禁用工具栏和前端编辑。想要重新记号，需要手动或通过后端管理进入编辑模式
- `Shortcuts ...`：快捷键
- `Logout admin`：退出登录

#### Page menu

管理当前页面的选项。

#### Language menu

切换当前页面的语言，管理多个翻译。支持的操作

- 增加一个缺失的翻译
- 删除一个已有的翻译
- 从一个已有的翻译复制所有插件及其内容到当前语言

#### Publishing controller

管理页面的发布状态。

- `Edit`：打开页面进行编辑
- `View published`：更新页面，退出编辑模式
- `Publish page now`：发布一个未发布的页面
- `Publish page changes`：发布在页面做的修改

### 管理员视图和组成

#### 页面列表

页面列表可以纵观页面及其状态。

从左至右，列表元素具有下面的属性：

- 展开/折叠控制：有子节点的页面有这个控制
- tab：用于拖拽列表元素
- 页面 Title
- 语言版本指示符和控制：
  - 空白：不存在翻译；点击之后会打开基本设置
  - 灰色：翻译存在但是未发布
  - 绿色：翻译已发布
  - 蓝色：翻译有一个修改的草稿
- Menu 指示符：页面是否会出现在导航菜单
- 编辑：修改页面设置
- 添加子页面
- 其他行为：拷贝页面、剪切页面、删除页面、高级设置等
