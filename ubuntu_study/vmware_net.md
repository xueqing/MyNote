# VMWare 虚拟机网络连接方式

- [VMWare 虚拟机网络连接方式](#vmware-虚拟机网络连接方式)
  - [概述](#概述)
  - [桥接模式](#桥接模式)
  - [NAT 模式](#nat-模式)
  - [仅主机模式](#仅主机模式)
  - [参考](#参考)

## 概述

VMWare 虚拟机安装之后，可以在宿主机的网络连接中看到两块网卡：VMWare Network Adapter VMnet1、VMWare Network Adapter VMnet8。

- VMWare Network Adapter VMnet1 是虚拟机仅主机模式的网络接口
- VMWare Network Adapter VMnet8 是虚拟机 NAT 模式的网络接口

虚拟机设置中可以看到五种网络连接方式：

- 桥接模式(Bridged Networking, B): 虚拟机使用宿主机系统的物理网络适配器连接到网络
- NAT 模式(Network Address Translation, N): 虚拟机共享宿主机系统的 IP 地址和 MAC 地址
- 仅主机模式(Host-Only, H): 虚拟机和宿主机系统之间有 VPN(Virtual Private Network, 虚拟专用网络)
- 自定义(U): 特定虚拟网络
- LAN 区段(LAN Segments, L): 虚拟机使用可与其他虚拟机共享的专用网络。此模式适用于多层测试、网络性能分析和虚拟机隔离很重要的场景

这里只讨论前三种方式。

## 桥接模式

选择桥接模式时，虚拟机使用宿主机系统的物理网络适配器连接到网络。

如果宿主机系统在网络中，桥接模式通常是最简单的方式，使得虚拟机可以访问该网络。

通过桥接模式，虚拟机在和宿主机系统相同的物理以太网络上显示为附加计算机。虚拟机可以透明地使用网络上可用的服务，包括文件服务器、打印机和网关。物理主机和其他配置为桥接模式的虚拟机也可以使用此虚拟机的资源。

使用桥接模式时，虚拟机在网络中必须有自己的身份。比如，在 TCP/IP 网络中，虚拟机必须有自己的 IP 地址。虚拟机通常从 DHCP 服务器获取 IP 地址和其他网络详细信息。在某些配置中，你可能需要手动设置IP 地址和其他详细信息。

引导多个操作系统的用户通常会为所有系统分配相同的地址，因为他们假设同一时刻只有一个操作系统会运行。如果主机系统设置为引导操作系统，并且在虚拟机中运行其中的一个或多个，请为每个操作系统配置唯一的网络地址。

当选中**复制物理网络连接状态**(Replicate physical connection state)选项时，当从有线或无线网络移动到另一个网络时，IP 地址会自动更新。这个设置对于运行在笔记本电脑上或其他移动设备上的虚拟机有用。

桥接模式下，需要手动配置 IP 地址、子网掩码，且需要和宿主机位于同一网段，才可以和宿主机进行互相通信。

桥接模式下，局域网内的路由器通过虚拟网络 VMnet0 直接和虚拟机通信。虚拟机直接和物理网络相连，不用通过宿主机的网卡。

## NAT 模式

选择 NAT 模式时，虚拟机共享宿主机系统的 IP 地址和 MAC 地址。

虚拟机和宿主机系统共享同一身份，该身份对在网络之外不可见。虚拟机没有自己的 IP 地址。相反，在宿主机系统上设置了一个单独的专用网络，虚拟机从 VMWare 虚拟 DHCP 服务器获取在该网络的地址。VMware NAT 设备在一个或多个虚拟机与外部网络之间传递网卡数据。VMWare NAT 设备识别传给每个虚拟机的数据包，并将它们发送到正确的目的地。

通过 NAT，虚拟机可以使用许多标准协议连接到外部网络上的其他机器。例如，可以使用 HTTP 浏览网站，使用 FTP 传输文件，使用 Telnet 登录到其他系统。还可以通过使用宿主机上的令牌环适配器连接到 TCP/IP 网络。

在默认配置中，外部网络中的系统不能启动与虚拟机的连接。例如，默认配置不允许将虚拟机作为 Web 服务器将网页发送给外部网络上的系统。此限制可防止游客操作系统在安装安全软件之前受到损害。

默认地，当使用**新建虚拟机**向导创建虚拟机时会使用 NAT。

虚拟机通过使用宿主机系统上的网络连接，使用 NAT 连接到网络或其他 TCP/IP 网络。NAT 适用于以太网、DSL 和电话调制解调器。宿主机系统上设置了单独的专用网络。虚拟机从 VMWare 虚拟 DHCP 服务器获取在该网络上的地址。

NAT 模式下的虚拟系统的 TCP/IP 配置信息由 VMnet8 虚拟网络的 DHCP 服务器提供，不能手动修改，因此虚拟系统与局域网内其他设备无法互相访问。

使用 NAT 模式，不需要进行任何配置就可以使虚拟系统接入互联网，只需要宿主机可以访问互联网。

NAT 模式下，虚拟机连接到 VMnet8。系统的 VMWare NAT 服务充当路由器作用，将虚拟机发给 VMnet8 的包进行地址转换通过宿主机的物理网卡发到实际网络，，再将返回的包进行地址转换后通过 VMnet8 发给虚拟机。虚拟机可以通过宿主机单向访问其他主机，但是其他主机不能访问虚拟机。虚拟机和宿主机也可以互相访问。

## 仅主机模式

选择仅主机模式时，Workstation Player 在虚拟机和宿主机系统之间创建 VPN(Virtual Private Network, 虚拟专用网络)。

VPN 通常在宿主机之外是不可见的。同一宿主机系统上配置为仅主机模式的多个虚拟机在同一网络上。使用此配置，可以将虚拟机连接到令牌环或其他非以太网网络。

在 Windows 宿主机系统上，可以组合使用主机模式与 Internet 连接共享功能。通过这种组合，虚拟机可以使用宿主机上的拨号网络适配器或其他 Internet 的连接。请参阅 Windows 文档，查看有关 Internet 连接共享的详细文档。

仅主机模式下，所有的虚拟系统可以互相访问，但是和互联网隔离开。虚拟系统的 TCP/IP 配置信息由 VMnet1 虚拟网络的 DHCP 服务器动态分配。

仅主机模式下，虚拟机的网卡连接到宿主机的 VMnet1 上，但系统并不为虚拟机提供路由服务，即 VMnet1 和路由器不相连。虚拟机和宿主机可以互相访问，但是与其他主机不能互相访问。

## 参考

- [网络配置三种模式对比（桥接模式，主机模式，网络地址转换）](https://cloud.tencent.com/developer/article/1184666)
- [虚拟机网络NAT模式配置静态IP](https://www.cnblogs.com/luxiaodai/p/9947343.html)
- [Configuring Virtual Network Adapter Settings](https://docs.vmware.com/en/VMware-Workstation-Player-for-Windows/16.0/com.vmware.player.win.using.doc/GUID-C82DCB68-2EFA-460A-A765-37225883337D.html)