# github 账户管理

## 添加 SSH ke 到 github 账户

- 检查 .ssh 文件夹是否有密钥`ls ~/.ssh/`
  - 没有的话生成密钥`ssh-keygen -t rsa -C "your_email@example.com"`
- 添加 SSH key 到 ssh-agent
  - 后台启动 ssh-agent： `eval $(ssh-agent -s)`
  - 添加 key：`ssh-add ~/.ssh/id_rsa`
- 在 github 的个人设置中添加一个 ssh-key
- 也可在某个 repository 中单独管理访问的 ssh-key

## 测试连接 github 网站

- 尝试 ssh 到 github：`ssh -T git@github.com`
- 看到更详细的信息：`ssh -vT git@github.com`
- 看到 warning 之后输入 yes 尝试继续连接，如果看到`Hi username`说明连接成功

## 验证捆绑到 github 账户的 public key

- 启动 ssh-agent 服务：`ssh-agent -s`
- 查看 public key 的 fingerprint：`ssh-add -l`