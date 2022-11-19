# 遇到的问题

## 使用 qmake2cmake

安装之后，使用 `qmake2cmake` 转换 QMake 项目时遇到报错 `Add the installation prefix of "QT" to CMAKE_PREFIX_PATH or set "QT_DIR" ...`，需要查找 Qt 的安装路径，使用 `CMAKE_PREFIX_PATH` 指定路径，比如 `cmake -DCMAKE_PREFIX_PATH=/home/kiki/Qt5.7.1 ../`。

遇到 `Unknown CMake command "qt_add_library"` 的错误，根据[官方文档](https://doc.qt.io/qt-6/qt-add-library.html)可知此命令在 Qt6.2 才引入，所以需要[下载](https://www.qt.io/download-qt-installer?hsCtaTracking=99d9dd4f-5681-48d2-b096-470725510d34%7C074ddad0-fdef-4e53-8aa8-5e8a876d6ab4)安装更新的 Qt。
