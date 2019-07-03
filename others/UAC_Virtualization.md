# UAC 虚拟化

- [UAC 虚拟化](#UAC-%E8%99%9A%E6%8B%9F%E5%8C%96)
  - [前言](#%E5%89%8D%E8%A8%80)
  - [Windows 7 上的 UAC 虚拟化](#Windows-7-%E4%B8%8A%E7%9A%84-UAC-%E8%99%9A%E6%8B%9F%E5%8C%96)
  - [UAC 虚拟化的现象](#UAC-%E8%99%9A%E6%8B%9F%E5%8C%96%E7%9A%84%E7%8E%B0%E8%B1%A1)
  - [思考](#%E6%80%9D%E8%80%83)
  - [总结](#%E6%80%BB%E7%BB%93)
  - [参考](#%E5%8F%82%E8%80%83)

## 前言

在早期的 Windows 版本(XP,NTY,95 等)，通常由管理员安装应用。这些应用可以自由地读写系统文件和注册表。但是，标准养护运行相同的应用会导致错误弹窗。

## Windows 7 上的 UAC 虚拟化

- 在 Windows 7 上通过重定向写操作到用户配置的一个特殊位置来改善标准账户的应用兼容性
- 例如：如果标准用户运行一个应用，尝试写`C:\Program Files\National Instruments\Settings.ini`，这个写操作会被重定向到`C:\User\Username\AppData\Local\VirtualStore\Program Files\National Instruments\Settings.ini`。同样地，尝试注册到`HKEY_LOCAL_MACHINE\Software\National Instruments\`文件会被重定向到`HKEY_CURRENT_USER\Software\Classes\VirtualStore\MACHINE\Software\National Instruments or HKEY_USERS\...`

## UAC 虚拟化的现象

- 如果有下面的现象表明应用可能是受到 UAC 虚拟化的影响
  - 应用写入 `Program Files`，`Windows`目录或系统根目录(通常是 C 盘)，但是在这些位置不能找到文件
  - 应用写入 Windows 注册表，特比是`HKLM/Software`，但是看不到注册表更新
  - 切换到另外一个用户账户时，应用不能找到之前写入 `Program Files`，`Windows`目录或系统根目录(通常是 C 盘)的文件，或者应用找到了这些文件的旧版本

## 思考

- UAC 虚拟化只用于辅助在 Windows Vista 之前开发的应用的兼容性。Windows 7 的新应用不应该执行写操作到敏感的系统文件，而且不应该依赖 UAC 虚拟化来提供必要的重定向
- 当更新已有代码再 Windows 7 上运行时，确保应用在运行时只存储数据在每个用户的位置
- 判断需要写数据文件到已有目录。被所有用户使用的通用数据应写入全局的公共位置，由所有用户共享。其他的数据应写入每个用户的位置
- 在确定合适的位置后，确保不会硬编码路径

## 总结

通过 UAC 虚拟化，Windows 7 支持标准用户运行开发的需要管理员权限的应用。

## 参考

- [UAC Virtualization and how it affects your Installers](https://forums.ni.com/t5/Windows-7/UAC-Virtualization-and-how-it-affects-your-Installers/gpm-p/3477163?profile.language=en)
