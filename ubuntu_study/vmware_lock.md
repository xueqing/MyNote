# vmware 锁定文件失败

当虚拟机挂起并保存数据到磁盘的生活，主机突然崩溃或关机会导致再次打开虚拟机报错“锁定文件失败。打不开磁盘xxx或它所依赖的某个快照磁盘……”(Cannot open the disk xxxx or one of the snapshot disks it depends on. Reason: Failed to lock the file)。因为虚拟机认定当前是挂起状态，并尝试引用锁定的虚拟硬盘，但是文件是损坏的，所以虚拟机不能恢复。

解决方法是：删除锁定的虚拟硬盘文件。这样不能从挂起的时间恢复，相当于执行了一次重启。

- 点击确定按钮返回虚拟机主界面
- 右击虚拟机，选择“编辑虚拟机设置”
- 点击“选项”
- 点击“常规”
- 点击“工作目录”，查看在主机上的位置
- 打开上述目录，删除以“vmdk.lck”为扩展名的文件夹。这些文件表示虚拟机在关机之前失败地尝试保存虚拟硬盘的状态
