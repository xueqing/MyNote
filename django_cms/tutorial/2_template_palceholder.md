# 2 模板和占位符

- [2 模板和占位符](#2-%e6%a8%a1%e6%9d%bf%e5%92%8c%e5%8d%a0%e4%bd%8d%e7%ac%a6)
  - [2.1 模板](#21-%e6%a8%a1%e6%9d%bf)
  - [2.2 占位符](#22-%e5%8d%a0%e4%bd%8d%e7%ac%a6)
  - [2.3 静态占位符](#23-%e9%9d%99%e6%80%81%e5%8d%a0%e4%bd%8d%e7%ac%a6)
  - [2.4 渲染菜单](#24-%e6%b8%b2%e6%9f%93%e8%8f%9c%e5%8d%95)

## 2.1 模板

可以使用 HTML 模板来定制网站外观、定义占位符标记要管理的内容，以及使用特殊标签生成菜单等。

可以使用不同的格式或内置组件定义多个模板，然后根据需要为每个页面选择模板。一个页面的模板总是可被其他页面使用。

网站模板位于 `mysite/templates`。

默认的，网站页面使用 `fullwidth.html` 模板，即列举在项目 `settings.py` 的 `CMS_TEMPLATES` 元组的第一个。

```html(settings.py)
CMS_TEMPLATES = (
    ## Customize this
    ('fullwidth.html', 'Fullwidth'),
    ('sidebar_left.html', 'Sidebar Left'),
    ('sidebar_right.html', 'Sidebar Right')
)
```

## 2.2 占位符

占位符定义 HTML 模板的一部分，然后在渲染网页的时候使用数据库的内容填充它。通过使用 django CMS 的前端的编辑机制(使用 Django 的模板标签)编辑网页内容。

`fullwidth.html` 包含一个占位符 `{% placeholder "content" %}`。

`fullwidth.html` 还有一个占位符 `{% load cms_tags %}`。`cms_tags` 是需要的模板标签库。

可以参考 [Django 文档](https://docs.djangoproject.com/en/dev/topics/templates/) 查看更多关于 Django 的模板标签。

给 `fullwidth.html` 的 `{% block content %}` 部分增加一些占位符。比如：

```html
{% block content %}
  {% placeholder "feature" %}
  {% placeholder "content" %}
  {% placeholder "splashbox" %}
{% endblock content %}
```

如果切换到结构模式，看以看到新的可用的占位符：`Feature` 和 `Splashbox`。

## 2.3 静态占位符

静态占位符可以在网站的多个位置展示相同的内容。静态占位符大多数行为类似普通占位符，但是当创建一个静态占位符并增加内容，它会在全局保存。即使从一个模板删除这个静态占位符，也可以之后重用。

比如，增加一个 footer 到所有的页面。因为我们想要 footer 出现在每个页面，应该增加到基础模板(`mysite/templates/base.html`)。放置在 HTML `<body>` 元素的末尾：

```html
        <footer>
            {% static_placeholder 'footer' %}
        </footer>

        {% render_block "js" %}
    </body>
</html>
```

保存模板文件，返回到浏览器。刷新任一页面，在结构模式可以看到新的静态占位符。

**注意**：为了减少界面的凌乱，静态占位符的插件默认会被隐藏。可点击展开。

如果按照正常方式增加内容到新的占位符，你会看到它出现在网站的其他页面。

## 2.4 渲染菜单

使用 [show_menu](http://docs.django-cms.org/en/latest/reference/navigation.html) 渲染模板中的菜单。

使用 `show_menu` 的模板必须首先加载 CMS 的 `menu_tags` 库：

```html
{% load menu_tags %}
```

我们在 `mysite/templates/base.html` 使用的菜单：

```html
<ul class="nav">
    {% show_menu 0 100 100 100 %}
</ul>
```

这个选项控制展示在菜单树的网站层级。
