# RTSTful Web API 设计

- [RTSTful Web API 设计](#rtstful-web-api-设计)
  - [什么是 REST](#什么是-rest)
  - [围绕资源组织 API 设计](#围绕资源组织-api-设计)
  - [根据 HTTP 方法定义 API 操作](#根据-http-方法定义-api-操作)
  - [符合 HTTP 语义](#符合-http-语义)
    - [媒体类型](#媒体类型)
    - [GET 方法](#get-方法)
    - [POST 方法](#post-方法)
    - [PUT 方法](#put-方法)
    - [PATCH 方法](#patch-方法)
    - [DELETE 方法](#delete-方法)
    - [异步操作](#异步操作)
  - [过滤和分页操作](#过滤和分页操作)
  - [支持大型二进制资源的部分响应](#支持大型二进制资源的部分响应)
  - [使用 HATEOAS 启用对相关资源的导航](#使用-hateoas-启用对相关资源的导航)
  - [版本化 RTSTful Web API](#版本化-rtstful-web-api)
    - [无版本控制](#无版本控制)
    - [URI 版本控制](#uri-版本控制)
    - [查询字符串版本控制](#查询字符串版本控制)
    - [标头版本控制](#标头版本控制)
    - [媒体类型版本控制](#媒体类型版本控制)
  - [开放 API 计划](#开放-api-计划)
  - [更多信息](#更多信息)

翻译[原文](https://docs.microsoft.com/en-us/azure/architecture/best-practices/api-design)。

大多数现代 Web 应用程序都暴露了客户端可以用来与应用程序交互的 API。设计良好的 Web API 应该旨在支持：

- **平台独立性**。无论内部如何实现 API，任何客户端都应该能够调用 API。这需要使用标准协议，并具有一种机制，使客户端和 Web 服务可以就要交换的数据格式达成一致。
- **服务进化**。Web API 应该能够独立于客户端应用程序发展和添加功能。随着 API 的发展，现有的客户端应用程序应该继续运行而无需修改。所有功能都应该是可发现的，以便客户端应用程序可以充分使用它。

本指南描述了你在设计 Web API 时应考虑的问题。

## 什么是 REST

2000 年，Roy Fielding 提出了代表性状态转移 (Representational State Transfer, REST) 作为设计 Web 服务的架构方法。REST 是一种基于超媒体构建分布式系统的架构风格。REST 独立于任何底层协议，不一定与 HTTP 绑定。但是，大多数常见的 REST API 实现使用 HTTP 作为应用程序协议，本指南重点介绍为 HTTP 设计 REST API。

基于 HTTP 的 REST 一个主要优点是它使用开放标准，并且不会将 API 或客户端应用程序的实现绑定到任何特定的实现。例如，一个 REST Web 服务可以用 ASP.NET 编写，客户端应用程序可以使用任何语言或工具集，它们可以生成 HTTP 请求并解析 HTTP 响应。

以下是使用 HTTP 的 RESTful API 的一些主要设计原则：

- REST API 是围绕*资源*设计的，资源是客户端可以访问的任何类型的对象、数据或服务。
- 资源有一个*标识符*，它是唯一标识该资源的 URI。例如，特定客户订单的 URI 可能是：

  ```txt
  HTTP

  https://adventure-works.com/orders/1
  ```

- 客户端通过交换资源的*表示*与服务进行交互。许多 Web API 使用 JSON 作为交换格式。例如，上面列出的 URI 的 GET 请求可能会返回此响应正文：

  ```txt
  JSON

  {"orderId":1,"orderValue":99.90,"productId":1,"quantity":1}
  ```

- REST API 使用统一的接口，这有助于将客户端和服务端实现解耦合。对于基于 HTTP 构建的 REST API，统一接口包括使用标准 HTTP 动词对资源执行操作。最常见的操作是 GET、POST、PUT、PATCH 和 DELETE。
- REST API 使用无状态请求模型。HTTP 请求应该是独立的，并且可以以任何顺序发生，因此保持请求之间的瞬时信息是不可行的。唯一存储信息的地方是资源本身，并且每个请求都应该是一个原子操作。此约束使 Web 服务具有高度可扩展性，因为不需要在客户端和特定服务器之间保留任何亲和性。任何服务器都可以处理来自任何客户端的任何请求。也就是说，其他因素可能会限制可扩展性。例如，许多 Web 服务写入后端数据存储，这可能难以横向扩展。有关横向扩展数据存储的策略的更多信息，请参阅[水平、垂直和功能数据分区](https://docs.microsoft.com/en-us/azure/architecture/best-practices/data-partitioning)。
- REST API 由表示中包含的超媒体链接驱动。例如，以下显示了一个订单的 JSON 表示。它包含链接用于获取或更新与订单关联的客户。

  ```txt
  JSON

  {
      "orderID":3,
      "productID":2,
      "quantity":4,
      "orderValue":16.60,
      "links": [
          {"rel":"product","href":"https://adventure-works.com/customers/3", "action":"GET" },
          {"rel":"product","href":"https://adventure-works.com/customers/3", "action":"PUT" }
      ]
  }
  ```

2008 年，Leonard Richardson 提出了以下 Web API [成熟度模型](https://martinfowler.com/articles/richardsonMaturityModel.html)：

- Level 0：定义一个 URI，所有操作都是对这个 URI 的 POST 请求。
- Level 1：为各个资源创建单独的 URI。
- Level 2：使用 HTTP 方法定义对资源的操作。
- Level 3：使用超媒体（HATEOAS，如下所述）。

根据 Fielding 的定义，Level 3 对应真正的 RESTful API。事实上，许多已发布的 Web API 都属于  Level 2 左右。

## 围绕资源组织 API 设计

关注 Web API 开放的业务实体。例如，在电子商务系统中，主要实体可能是客户和订单。可以通过发送包含订单信息的 HTTP POST 请求来创建订单。HTTP 响应指示订单是否成功下达。如果可能，资源 URI 应该基于名词（资源）而不是动词（对资源的操作）。

```txt
HTTP

https://adventure-works.com/orders // Good

https://adventure-works.com/create-order // Avoid
```

资源不必基于单个物理数据项。例如，订单资源在内部可能实现为关系数据库中的多个表，但作为单个实体呈现给客户端。避免创建简单映射到数据库内部结构的 API。REST 的目的是对实体和应用程序可以对这些实体执行的操作进行建模。客户端不应暴露于内部实现。

通常将实体分组为集合（订单、客户）。集合是与集合中的条目分开的资源，并且应该有自己的 URI。例如，以下 URI 可能表示订单集合：

```txt
HTTP

Copy
https://adventure-works.com/orders
```

向集合 URI 发送 HTTP GET 请求会检索集合中的条目列表。集合中的每个条目也有自己唯一的 URI。对条目 URI 的 HTTP GET 请求会返回该条目的详细信息。

在 URI 中采用一致的命名约定。通常，对引用集合的 URI 使用复数名词会有所帮助。将集合和条目的 URI 组织到层次结构中是一种很好的做法。例如，`/customers` 是客户集合的路径，`/customers/5` 是 ID 等于 5 的客户的路径。这种方法有助于保持 Web API 的直观性。此外，许多 Web API 框架可以根据参数化的 URI 路径路由请求，因此你可以为路径 `/customers/{id}` 定义路由。

还要考虑不同类型资源之间的关系，以及如何暴露这些关系。例如，`/customers/5/orders` 可能代表客户 5 的所有订单。你也可以朝另一个方向，使用类似 `/orders/99/` 的 URI 表示从订单到客户的关系。但是，将此模型扩展得太远可能会变得难以实现。更好的解决方案是在 HTTP 响应消息的正文中提供相关资源的可导航链接。此机制在使用 [HATEOAS 启用对相关资源的导航部分](#使用-hateoas-启用对相关资源的导航)中进行了更详细的描述。

在更复杂的系统中，提供 URI 使客户端能够浏览多个级别的关系可能很棒，例如 `/customers/1/orders/99/products`。然而，如果资源之间的关系在未来发生变化，这种复杂程度可能难以维持并且不灵活。相反，尽量保持 URI 相对简单。一旦应用程序引用了资源，就应该可以使用此引用来查找与该资源相关的条目。前面的查询可以替换为 URI `/customers/1/orders` 以查找客户 1 的所有订单，然后 `/orders/99/products` 以查找此订单中的产品。

```txt
提示:

避免需要比 collection/item/collection 更复杂的资源 URI。
```

另一个因素是所有 Web 请求都会对 Web 服务器施加负载。请求越多，负载就越大。因此，尽量避免暴露大量小资源的“健谈”Web API。这样的 API 可能需要客户端应用程序发送多个请求以查找所需的所有数据。相反，你可能希望对数据进行非规范化并将相关信息组合成更大的资源，这些资源可以通过单个请求进行检索。但是，你需要平衡这种方法与获取客户端不需要的数据的开销。检索大型对象会增加请求的延迟并产生额外的带宽成本。有关这些性能反模式的更多信息，请参阅[健谈的 I/O](https://docs.microsoft.com/en-us/azure/architecture/antipatterns/chatty-io/) 和[冗余的请求](https://docs.microsoft.com/en-us/azure/architecture/antipatterns/extraneous-fetching/)。

避免在 Web API 和底层数据源之间引入依赖。例如，如果你的数据存储在关系型数据库，则 Web API 不需要将每个表公开为一个资源集。事实上，这可能是一个糟糕的设计。相反，将 Web API 视为数据库的抽象。如有必要，在数据库和 Web API 之间引入一个映射层。这样，就将客户端应用程序与底层数据库方案的更改隔离开。

最后，可能无法将 Web API 实现的每个操作都映射到特定资源。处理此类*非资源*场景，你可以通过 HTTP 请求调用函数并返回结果作为 HTTP 响应消息。例如，实现简单计算器操作（如加法和减法）的 Web API 可以提供 URI 公开这些操作作为伪资源，并使用查询字符串指定所需参数。例如，对 URI `/add?operand1=99&operand2=1` 的 GET 请求返回的响应消息正文包含值 100。但是，请谨慎使用这些形式的 URI。

## 根据 HTTP 方法定义 API 操作

HTTP 协议定义了许多方法为请求分配语义含义。大多数 RESTful Web API 使用的常见 HTTP 方法是：

- **GET** 检索指定 URI 处的资源表示。响应消息的正文包含所请求资源的详细信息。
- **POST** 在指定的 URI 处创建一个新资源。请求消息的正文提供了新资源的详细信息。请注意，POST 也可用于触发实际上不创建资源的操作。
- **PUT** 创建或替换指定 URI 处的资源。请求消息的正文指定要创建或更新的资源。
- **PATCH** 执行资源的部分更新。请求正文指定要应用于资源的更改集。
- **DELETE** 删除指定 URI 处的资源。

特定请求的效果应取决于资源是集合还是单个条目。下表使用电子商务示例总结了大多数 RESTful 实现所采用的常见约定。并非所有这些请求都可以实现——这取决于具体的场景。

| 资源 | POST | GET | PUT | DELETE |
| --- | --- | --- | --- | --- |
| /customers | 创建一个新客户 | 检索所有客户 | 批量更新客户 | 删除所有客户 |
| /customers/1 | 错误 | 检索客户 1 的详细信息 | 如果存在更新客户 1 的详细信息 | 删除客户 1 |
| /customers/1/orders | 为客户 1 创建一个新订单 | 检索客户 1 的所有订单 | 批量更新客户 1 的订单 | 删除客户 1 的所有订单 |

POST、PUT 和 PATCH 之间的区别可能令人困惑。

- POST 请求创建一个资源。服务器为新资源分配一个 URI，并将该 URI 返回给客户端。在 REST 模型中，你经常将 POST 请求应用于集合。将新资源添加到集合中。POST 请求还可用于将数据提交到现有资源进行处理，而无需创建任何新资源。
- PUT 请求创建资源或更新现有资源。客户端指定资源的 URI。请求正文包含资源的完整表示。如果具有此 URI 的资源已存在，则将其替换。否则，如果服务器支持，则会创建一个新资源。PUT 请求最常应用于作为单个条目的资源(例如特定客户)而不是集合。服务器可能支持通过 PUT 更新，但不支持创建。是否支持通过 PUT 创建取决于客户端是否可以在资源存在之前将 URI 有意义地分配给资源。如果没有，则使用 POST 创建资源并使用 PUT 或 PATCH 进行更新。
- PATCH 请求对现有资源执行*部分更新*。客户端指定资源的 URI。请求正文指定要应用于资源的一组*更改*。这可能比使用 PUT 更有效，因为客户端只发送更改，而不是资源的整个表示。如果服务器支持，从技术上讲，PATCH 还可以创建新资源（通过指定对“空”资源的一组更新）。

PUT 请求必须是幂等的。如果客户端多次提交相同的 PUT 请求，结果应该始终相同（相同的资源将被修改为相同的值）。POST 和 PATCH 请求不保证是幂等的。

## 符合 HTTP 语义

本节介绍了一些典型注意事项，关于设计符合 HTTP 规范的 API。但是，它并未涵盖所有可能的细节或场景。如有疑问，请查阅 HTTP 规范。

### 媒体类型

如前所述，客户端和服务器交换资源的表示。例如，在 POST 请求中，请求正文包含要创建资源的表示。在 GET 请求中，响应正文包含获取资源的表示。

在 HTTP 协议中，格式是通过使用*媒体类型*（也称为 MIME 类型）来指定的。对于非二进制数据，大多数 Web API 支持 JSON（media type = application/json）和可能的 XML（media type = application/xml）。

请求或响应中的 Content-Type 标头指定表示的格式。下面是一个包含 JSON 数据的 POST 请求示例：

```txt
HTTP

POST https://adventure-works.com/orders HTTP/1.1
Content-Type: application/json; charset=utf-8
Content-Length: 57

{"Id":1,"Name":"Gizmo","Category":"Widgets","Price":1.99}
```

如果服务器不支持媒体类型，它应该返回 HTTP 状态码 415（Unsupported Media Type，不支持的媒体类型）。

客户端请求可以包含一个 Accept 标头，该标头包含客户端将从服务器响应消息中接受的媒体类型列表。例如：

```txt
HTTP

GET https://adventure-works.com/orders/2 HTTP/1.1
Accept: application/json
```

如果服务器无法匹配任何列出的媒体类型，它应该返回 HTTP 状态代码 406（Not Acceptable，不可接受）。

### GET 方法

成功的 GET 方法通常会返回 HTTP 状态代码 200（OK）。如果找不到资源，该方法应返回 404（Not Found，未找到）。

如果请求已完成，但 HTTP 响应中没有包含响应正文，则应返回 HTTP 状态代码 204（No Content，无内容）；例如，未产生匹配项的搜索操作可能会通过此行为实现。

### POST 方法

如果 POST 方法创建一个新资源，它会返回 HTTP 状态代码 201（Created，已创建）。新资源的 URI 包含在响应的 Location 标头中。响应正文包含资源的表示。

如果该方法进行了一些处理但没有创建新资源，则该方法可以返回 HTTP 状态码 200，并将操作结果包含在响应正文中。或者，如果没有结果返回，该方法可以返回 HTTP 状态代码 204（No Content，无内容），且没有响应正文。

如果客户端将无效数据放入请求中，服务器应返回 HTTP 状态码 400（Bad Request，错误请求）。响应正文可以包含有关错误的附加信息或提供更多详细信息的 URI 链接。

### PUT 方法

如果 PUT 方法创建一个新资源，它会返回 HTTP 状态代码 201（Created，已创建），与 POST 方法一样。如果该方法更新现有资源，则返回 200（OK）或 204（No Content，无内容）。在某些情况下，可能无法更新现有资源。在这种情况下，请考虑返回 HTTP 状态代码 409（Conflict，冲突）。

考虑实施批量 HTTP PUT 操作，可以批量更新集合中的多个资源。PUT 请求应指定集合的​​ URI，且请求正文应指定要修改的资源的详细信息。这种方法可以帮助减少喋喋不休并提高性能。

### PATCH 方法

通过 PATCH 请求，客户端以*补丁文档*的形式向现有资源发送一组更新。服务器处理补丁文档以执行更新。补丁文档没有描述整个资源，只描述了一组要应用的更改。PATCH 方法规范 ([RFC 5789](https://tools.ietf.org/html/rfc5789)) 没有定义补丁文档的特定格式。必须从请求中的媒体类型推断格式。

JSON 可能是 Web API 最常见的数据格式。有两种主要的基于 JSON 的补丁格式，称为 *JSON 补丁*和 *JSON 合并补丁*。

JSON 合并补丁稍微简单一些。补丁文档与原始 JSON 资源具有相同的结构，但仅包含应更改或添加的字段子集。另外，可以通过将补丁文档中的字段值指定为 `null` 来删除字段。（这意味着如果原始资源可以具有显式 `null` 值，则合并补丁不适合。）

例如，假设原始资源具有以下 JSON 表示：

```txt
JSON

{
    "name":"gizmo",
    "category":"widgets",
    "color":"blue",
    "price":10
}
```

这是此资源的一个可能的 JSON 合并补丁：

```txt
JSON

{
    "price":12,
    "color":null,
    "size":"small"
}
```

这告诉服务器更新 `price`、删除 `color`，并添加 `size`，而不会修改 `name` 和 `category`。有关 JSON 合并补丁的详细信息，请参阅 [RFC 7396](https://tools.ietf.org/html/rfc7396)。JSON 合并补丁的媒体类型为 `application/merge-patch+json`。

如果原始资源可以包含显式的 `null` 值，由于 `null` 在补丁文档中的特殊含义，合并补丁不适合。此外，补丁文档没有指定服务器应用更新的顺序。这可能重要或可能不重要，具体取决于数据和域。[RFC 6902](https://tools.ietf.org/html/rfc6902) 中定义的 JSON 补丁更加灵活。它将更改指定为要应用的操作序列。操作包括添加、删除、替换、复制和测试（以验证值）。JSON 补丁的媒体类型为 `application/json-patch+json`。

以下是处理 PATCH 请求时可能遇到的一些典型错误情况，以及相应的 HTTP 状态代码。

| 错误条件 | HTTP 状态码 |
| --- | --- |
| 不支持补丁文件格式 | 415（Unsupported Media Type，不支持的媒体类型） |
| 格式错误的补丁文档 | 400（Bad Request，错误请求） |
| 补丁文档有效，但无法将更改应用于当前状态的资源 | 409（Conflict，冲突） |

### DELETE 方法

如果删除操作成功，则 Web 服务器应返回 HTTP 状态码 204（No Content，无内容），表示该过程已成功处理，但响应正文中未包含更多信息。如果资源不存在，Web 服务器可以返回 HTTP 404（Not Found，未找到）。

### 异步操作

有时，POST、PUT、PATCH 或 DELETE 操作可能需要一段时间才能完成处理。如果在向客户端发送响应之前等待完成，可能会导致无法接受的延迟。如果是这样，请考虑使用异步操作。返回 HTTP 状态代码 202（Accepted，已接受）指示请求已接受处理但未完成。

你应该暴露一个返回异步请求状态的端点，以便客户端可以通过轮询状态端点来监控状态。在 202 响应的 Location 标头中包含状态端点的 URI。例如：

```txt
HTTP

HTTP/1.1 202 Accepted
Location: /api/status/12345
```

如果客户端向此端点发送 GET 请求，则响应应包含请求的当前状态。可选地，它还可以包括估计的完成时间或取消操作的链接。

```txt
HTTP

HTTP/1.1 200 OK
Content-Type: application/json

{
    "status":"In progress",
    "link": { "rel":"cancel", "method":"delete", "href":"/api/status/12345" }
}
```

如果异步操作创建新资源，则状态端点应在操作完成后返回状态代码 303（See Other，请参阅其他）。在 303 响应中，包含一个 Location 标头提供新资源的 URI：

```txt
HTTP

HTTP/1.1 303 See Other
Location: /api/orders/12345
```

有关更多信息，请参阅[异步的请求-回复模式](https://docs.microsoft.com/en-us/azure/architecture/patterns/async-request-reply)。

## 过滤和分页操作

当只需要信息的子集时，通过单个 URI 暴露资源集合可能会导致应用程序获取大量数据。例如，假设客户端应用程序需要查找成本超过特定值的所有订单。它可能会从 `/orders` URI 中检索所有订单，然后在客户端过滤这些订单。显然，这个过程非常低效。它浪费了托管 Web API 的服务器的网络带宽和处理能力。

相反，API 可以允许在 URI 的查询字符串中传递过滤器，例如 `/orders?minCost=n`。然后，Web API 负责解析和处理查询字符串中的 `minCost` 参数，并返回服务器端过滤后的结果。

对集合资源的 GET 请求可能返回大量条目。你应该设计一个 Web API 限制任何单个请求返回的数据量。考虑支持查询字符串，该字符串指定要检索的最大条目数和集合中的起始偏移量。例如：

```txt
HTTP

/orders?limit=25&offset=50
```

还可以考虑对返回的条目数量设置上限，以帮助防止拒绝服务攻击。为了帮助客户端应用程序，返回分页数据的 GET 请求还应包括某种形式的元数据，以指示集合中可用资源的总数。

你可以使用类似的策略在获取数据时对其进行排序，方法是提供一个将字段名称作为值的 `sort` 参数，例如 `/orders?sort=ProductID`。但是，这种方法可能对缓存产生负面影响，因为查询字符串参数构成了资源标识符的一部分，许多缓存实现将该资源标识符用作缓存数据的键。

如果每个条目包含大量数据，你可以扩展此方法以限制为每个条目返回的字段。例如，你可以使用查询字符串参数接受逗号分隔的字段列表，例如 `/orders?fields=ProductID,Quantity`。

为查询字符串中的所有可选参数提供有意义的默认值。例如，如果实现分页，设置 `limit` 和 `offset` 参数分别为 10 和 0；如果实现排序，设置 `sort` 参数为资源的键；如果支持投射，设置 `fields` 参数为资源中的所有字段。

## 支持大型二进制资源的部分响应

资源可能包含大型二进制字段，例如文件或图像。要解决不可靠和间歇性连接引起的问题并缩短响应时间，请考虑启用以块的形式检索此类资源。为此，Web API 应支持大型资源的 GET 请求的 Accept-Ranges 标头。此标头表示 GET 操作支持部分请求。客户端应用程序可以提交 GET 请求返回资源的子集，指定为字节范围。

此外，请考虑对这些资源实施 HTTP HEAD 请求。HEAD 请求类似于 GET 请求，除了它只返回描述资源的 HTTP 标头，消息正文为空。客户端应用程序可以发出 HEAD 请求以确定是否使用部分 GET 请求来获取资源。例如：

```txt
HTTP

HEAD https://adventure-works.com/products/10?fields=productImage HTTP/1.1
```

这是一个示例响应消息：

```txt
HTTP

HTTP/1.1 200 OK

Accept-Ranges: bytes
Content-Type: image/jpeg
Content-Length: 4580
```

Content-Length 标头给出了资源的总大小，Accept-Ranges 标头表示对应的 GET 操作支持部分结果。客户端应用程序可以使用此信息以较小的块检索图像。第一个请求使用 Range 标头获取前 2500 个字节：

```txt
HTTP

GET https://adventure-works.com/products/10?fields=productImage HTTP/1.1
Range: bytes=0-2499
```

响应消息通过返回 HTTP 状态码 206 表示这是部分响应。Content-Length 标头指定消息正文中返回的实际字节数（不是资源的大小），Content-Range 标头指示这是资源的哪一部分（4580 个字节中的 0-2499 个字节）：

```txt
HTTP

HTTP/1.1 206 Partial Content

Accept-Ranges: bytes
Content-Type: image/jpeg
Content-Length: 2500
Content-Range: bytes 0-2499/4580

[...]
```

客户端应用程序的后续请求可以检索资源的剩余部分。

## 使用 HATEOAS 启用对相关资源的导航

REST 背后的主要动机之一是应该可以导航整个资源集，而无需事先了解 URI 方案。每个 HTTP GET 请求都应该通过响应中包含的超链接，返回查找与请求对象直接相关的资源必要的信息，还应该提供信息描述每个资源上可用的操作。这一原则被称为 HATEOAS(Hypertext as the Engine of Application State)，或超文本作为应用程序状态的引擎。此系统实际上是一个有限状态机，对每个请求的响应都包含从一种状态转移到另一种状态所需的信息；不需要其他信息。

```txt
注意

目前没有通用标准定义如何对 HATEOAS 原则建模。本节中显示的示例说明了一种可能的专有解决方案。
```

例如，为了处理订单和客户之间的关系，订单的表示可以包含链接标识订单的客户可用操作。下面一个可能的表示：

```txt
JSON

{
  "orderID":3,
  "productID":2,
  "quantity":4,
  "orderValue":16.60,
  "links":[
    {
      "rel":"customer",
      "href":"https://adventure-works.com/customers/3",
      "action":"GET",
      "types":["text/xml","application/json"]
    },
    {
      "rel":"customer",
      "href":"https://adventure-works.com/customers/3",
      "action":"PUT",
      "types":["application/x-www-form-urlencoded"]
    },
    {
      "rel":"customer",
      "href":"https://adventure-works.com/customers/3",
      "action":"DELETE",
      "types":[]
    },
    {
      "rel":"self",
      "href":"https://adventure-works.com/orders/3",
      "action":"GET",
      "types":["text/xml","application/json"]
    },
    {
      "rel":"self",
      "href":"https://adventure-works.com/orders/3",
      "action":"PUT",
      "types":["application/x-www-form-urlencoded"]
    },
    {
      "rel":"self",
      "href":"https://adventure-works.com/orders/3",
      "action":"DELETE",
      "types":[]
    }]
}
```

在此示例中，`links` 数组有一组链接。每个链接代表对相关实体的一个操作。每个链接的数据包括关系（“customer”）、URI (`https://adventure-works.com/customers/3`)、HTTP 方法和支持的 MIME 类型。这是客户端应用程序调用操作所需的所有信息。

`links` 数组还包括有关已检索资源本身的自引用信息。这些都具有 `self` 关系。

返回的链接集可能会更改，具体取决于资源的状态。这就是超文本是“应用程序状态引擎”的意思。

## 版本化 RTSTful Web API

Web API 不太可能保持静态。随着业务需求的变化，可能会添加新的资源集合，资源之间的关系可能会发生变化，并且资源中的数据结构可能会被修改。虽然更新 Web API 以处理新的或不同的需求是一个相对简单直接的过程，但你必须考虑此类更改将对使用这些 Web API 的客户端应用程序产生的影响。问题在于，虽然设计和实现 Web API 的开发人员可以完全控制该 API，但其开发人员对客户端应用程序的控制程度不同，这些客户端应用程序可能由远程操作的第三方组织构建。当务之急是使现有的客户端应用程序能够继续以不变的方式运行，同时允许新的客户端应用程序利用新的功能和资源。

版本控制使 Web API 能够指示其公开的功能和资源，并且客户端应用程序可以提交请求定向到功能或资源的特定版本。以下部分描述了几种不同的方法，每种方法都有其自身的优点和权衡。

### 无版本控制

这是最简单的方法，对于某些内部 API 可能是可以接受的。重大变化可以表示为新资源或新链接。向现有资源添加内容可能不会带来重大更改，因为不希望看到此内容的客户端应用程序将忽略它。

例如，对 URI `https://adventure-works.com/customers/3` 的请求应返回单个客户的详细信息，包含客户端应用程序所需的 `id`、`name` 和 `address` 字段：

```txt
HTTP

HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8

{"id":3,"name":"Contoso LLC","address":"1 Microsoft Way Redmond WA 98053"}
```

```txt
注意

为简单起见，本节中显示的示例响应不包括 HATEOAS 链接。
```

如果将 `DateCreated` 字段添加到客户资源的架构中，那么响应将如下所示：

```txt
HTTP

HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8

{"id":3,"name":"Contoso LLC","dateCreated":"2014-09-04T12:11:38.0376089Z","address":"1 Microsoft Way Redmond WA 98053"}
```

如果现有的客户端应用程序能够忽略无法识别的字段，它们可能会继续正常运行，而新的客户端应用程序可以设计为处理这个新字段。但是，如果资源架构发生更彻底的更改（例如删除或重命名字段）或资源之间的关系发生更改，那么这些可能会构成破坏性更改，从而阻止现有客户端应用程序正常运行。在这些情况下，您应该考虑以下方法之一。

### URI 版本控制

每次修改 Web API 或更改资源架构时，将版本号添加到每个资源的 URI。先前存在的 URI 应该像以前一样继续运行，返回符合其原始模式的资源。

扩展前面的例子，如果 `address` 字段被重组为包含地址每个组成部分的子字段（例如 `streetAddress`、`city`、`state` 和 `zipCode`），则可以通过包含版本号的 URI 公开此版本的资源，例如 `https://adventure-works.com/v2/customers/3`：

```txt
HTTP

HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8

{"id":3,"name":"Contoso LLC","dateCreated":"2014-09-04T12:11:38.0376089Z","address":{"streetAddress":"1 Microsoft Way","city":"Redmond","state":"WA","zipCode":98053}}
```

这种版本控制机制非常简单，但取决于服务器将请求路由到适当的端点。但是，随着 Web API 经过多次迭代而成熟，服务器必须支持许多不同的版本，它可能会变得笨拙。此外，从纯粹主义者的角度来看，在所有情况下，客户端应用程序都在获取相同的数据（客户 3），因此 URI 不应该因版本而异。此方案还使 HATEOAS 的实现复杂化，因为所有链接都需要在其 URI 中包含版本号。

### 查询字符串版本控制

指定资源的版本可以使用附加到 HTTP 请求的查询字符串中的参数，而不是提供多个 URI，例如 `https://adventure-works.com/customers/3?version=2`。如果较旧的客户端应用程序忽略版本参数，则它应该默认为有意义的值，例如 1。

这种方法具有语义优势，即始终从相同的 URI 检索相同的资源，但它取决于代码处理请求以解析查询字符串，并发送回适当的 HTTP 响应。这种方法在实现 HATEOAS 时遇到的复杂性与 URI 版本控制机制相同。

```txt
笔记

一些较旧的 Web 浏览器和 Web 代理不会缓存 URI 中包含查询字符串的请求的响应。这会降低使用 Web API 并在此类 Web 浏览器中运行的 Web 应用程序的性能。
```

### 标头版本控制

你可以实现一个指示资源版本的自定义标头，而不是附加版本号作为查询字符串参数。这种方法要求客户端应用程序添加适当的标头到所有请求，尽管如果省略版本标头，处理客户端请求的代码可以使用默认值（版本 1）。以下示例使用名为 `Custom-Header` 的自定义标头。此标头的值表示 Web API 的版本。

版本 1：

```txt
HTTP

GET https://adventure-works.com/customers/3 HTTP/1.1
Custom-Header: api-version=1
```

```txt
HTTP

HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8

{"id":3,"name":"Contoso LLC","address":"1 Microsoft Way Redmond WA 98053"}
```

版本 2：

```txt
HTTP

GET https://adventure-works.com/customers/3 HTTP/1.1
Custom-Header: api-version=2
```

```txt
HTTP

HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8

{"id":3,"name":"Contoso LLC","dateCreated":"2014-09-04T12:11:38.0376089Z","address":{"streetAddress":"1 Microsoft Way","city":"Redmond","state":"WA","zipCode":98053}}
```

与前两种方法一样，实现 HATEOAS 需要在所有链接中包含适当的自定义标头。

### 媒体类型版本控制

当客户端应用程序向 Web 服务器发送 HTTP GET 请求时，它应该使用 `Accept` 标头规定可以处理的内容格式，如本指南前面所述。通常，`Accept` 标头的目的是允许客户端应用程序指定响应的主体应该是 XML、JSON 还是客户端可以解析的其他一些常见格式。但是，可以定义自定义媒体类型，其中包括使客户端应用程序能够指示其期望的资源版本的信息。

以下示例显示了一个请求，该请求指定了值为 `application/vnd.adventure-works.v1+json` 的 `Accept` 标头。`vnd.adventure-works.v1` 元素指示 Web 服务器应该返回资源的版本 1，而 `json` 元素指定响应正文的格式应该是 JSON：

```txt
HTTP

GET https://adventure-works.com/customers/3 HTTP/1.1
Accept: application/vnd.adventure-works.v1+json
```

处理请求的代码负责处理 `Accept` 标头并尽可能地尊重它（客户端应用程序可以在 `Accept` 标头中指定多种格式，在这种情况下，Web 服务器可以为响应正文选择最合适的格式）。Web 服务器使用 `Content-Type` 标头确认响应正文中数据的格式：

```txt
HTTP

HTTP/1.1 200 OK
Content-Type: application/vnd.adventure-works.v1+json; charset=utf-8

{"id":3,"name":"Contoso LLC","address":"1 Microsoft Way Redmond WA 98053"}
```

如果 `Accept` 标头未指定任何已知媒体类型，则 Web 服务器可以生成 HTTP 406（不可接受）响应消息或返回具有默认媒体类型的消息。

这种方法可以说是最纯粹的版本控制机制，并且很自然地适用于 HATEOAS，它可以在资源链接中包含 MIME 类型的相关数据。

```txt
笔记

选择版本控制策略时，你还应该考虑对性能的影响，尤其是 Web 服务器上的缓存。URI 版本控制和查询字符串版本控制方案是缓存友好的，因为相同的 URI/查询字符串组合每次都引用相同的数据。

标头版本控制和媒体类型版本控制机制通常需要额外的逻辑来检查自定义标头或 `Accept` 标头中的值。在大规模环境中，许多使用不同 Web API 版本的客户端可能导致服务器端缓存出现大量重复数据。如果客户端应用程序通过实现缓存的代理与 Web 服务器通信，并且仅当代理当前缓存中没有所请求数据的副本时才将请求转发到 Web 服务器，则此问题可能会变得很严重。
```

## 开放 API 计划

[Open API 计划](https://www.openapis.org/)由一个行业联盟创建，旨在标准化供应商之间的 REST API 描述。作为该计划的一部分，Swagger 2.0 规范更名为 OpenAPI 规范 (OAS) 并归入开放 API 计划。

你可能希望为 Web API 采用 OpenAPI。需要考虑的几点：

- OpenAPI 规范附带一套固执己见的指南，关于如何设计 REST API。这有利于互操作性，但在设计符合规范的 API 时需要更加小心。
- OpenAPI 提倡约定优先的方法，而不是实现优先的方法。约定优先意味着首先设计 API 约定（接口），然后编写实现该约定的代码。
- Swagger 等工具可以从 API 约定生成客户端库或文档。例如，请参阅[使用 Swagger 的 ASP.NET Web API 帮助页面](https://docs.microsoft.com/en-us/aspnet/core/tutorials/web-api-help-pages-using-swagger)。

## 更多信息

- [Microsoft REST API 指南](https://github.com/Microsoft/api-guidelines/blob/master/Guidelines.md)。设计公共 REST API 的详细建议。
- [Web API 清单](https://mathieu.fenniak.net/the-api-checklist)。设计和实现 Web API 时要考虑的有用项目列表。
- [开放 API 计划](https://www.openapis.org/)。Open API 的文档和实现细节。
