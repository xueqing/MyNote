# update-alternatives

- `update-alternatives`命令用于增加、删除、维护和显示`/etc/alternatives`下的软链接，用于切换相同或相似功能的应用程序（如浏览器、编辑器等）
  - `generic name`一系列功能相似的程序的公用名字
  - `alternative`一个可选的程序所在的路径
  - `link`一个`alternative`在`/etc/alternatives`中的名字
  - `priority`一个`alternative`的优先级，优先级越高，数字越大
- `ls -l /etc/alternatives`可以看到所有的软链接
- 显示所有可选命令：`update-alternatives --display editor`
- 选择配置命令程序：`update-alternatives --config editor`
  - 不使用交互模式：`update-alternatives --set editor path`
- 安装命令程序：`update-alternatives --install link generic_name path priority`
  - `update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 100`
- 删除命令程序：`update-alternatives --remove name path`

以 Ubuntu14.04 配置 java1.8 为例

- 安装 java1.6 和 java1.7 可以直接用`sudo apt-get install openjdk-6-gre(openjdk-7-gre)`
- 访问 oracle 官网下载 jdk
- 解压下载的 tar.gz 压缩包
- 执行命令安装：
  - `mkdir -p /usr/lib/jvm`
  - `sudo cp -a jdk1.8.0_162/ /usr/lib/jvm/`
  - `sudo ln -s /usr/lib/jvm/jdk1.8.0_162/ /usr/lib/jvm/java-8`
- 设置环境变量：
  - `vi ~/.bashrc`在文件最后加入
    - `export JAVA_HOME=/usr/lib/jvm/java-8`
    - `export JRE_HOME=${JAVA_HOME}/jre`
    - `export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib`
    - `export PATH=${JAVA_HOME}/bin:$PATH`
  - `source ~/.bashrc`
- 配置默认 jdk 版本
  - `sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-8/bin/java 300`
  - `sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/java-8/bin/javac 300`
  - `sudo update-alternatives --config java`
  - `sudo update-alternatives --config javac`
- 测试验证`java -version`