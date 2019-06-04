# Authentication vs Authorization

- [Authentication vs Authorization](#authentication-vs-authorization)
  - [1 Authentication 证明，身份验证](#1-authentication-%E8%AF%81%E6%98%8E%E8%BA%AB%E4%BB%BD%E9%AA%8C%E8%AF%81)
  - [2 Authorization 授权](#2-authorization-%E6%8E%88%E6%9D%83)
  - [3 Encryption 加密](#3-encryption-%E5%8A%A0%E5%AF%86)
  - [4 参考](#4-%E5%8F%82%E8%80%83)

## 1 Authentication 证明，身份验证

- 服务器使用身份验证：当服务器需要知道谁在访问信息或网站
- 客户端使用身份验证：当客户端需要知道服务器是其所声明的系统
- 在身份验证中，用户或极端及需要向服务器或客户端证明它的身份
- 通常，服务器的身份验证需要用户名和密码。其他的身份验证方式可以通过卡片、视网膜扫描、语音识别、指纹等
- 通常，客户端的身份验证是服务器给客户端一个证书，且证书中第三方可信机构声明服务器是客户端所期望的实体
- 身份认证不判断个人可以做的任务或者个人可以看到的文件。身份认证只是识别和认证个人或系统

## 2 Authorization 授权

- 授权是服务器确定客户端是否有权限使用一个资源或访问一个文件的过程
- 授权通常和身份认证一起，以便于服务器识别正在请求访问的客户端身份
- 授权要求的身份认证类型可能不同：某些情况可能需要密码，某些情况可能不需要密码
- 在某些情况下，没有授权：任何用户可以使用一个资源或访问一个文件。网络上大部分网页不要求任何身份认证或授权

## 3 Encryption 加密

- 加密包括转换数据的过程，以使得没有解密密钥的人不可读
- SSH 和 SSL 协议通常用户加密流程
- SSL 业务中，客户端(浏览器)和服务器(web 服务)之间所有的数据在发送到对方之前都会加密
- SSH 会话中，客户端和服务器之间的数据都会加密
- 通过加密客户端和服务器之间的交互数据，使得网络传输过程中被拦截的风险降低

## 4 参考

- [Understanding Authentication, Authorization, and Encryption](https://www.bu.edu/tech/about/security-resources/bestpractice/auth/)