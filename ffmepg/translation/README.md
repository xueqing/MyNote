# 维基教程

- [维基教程](#维基教程)
  - [欢迎使用 FFmpeg 错误跟踪和维基](#欢迎使用-ffmpeg-错误跟踪和维基)
  - [报告错误](#报告错误)
  - [FFmpeg 官方文档](#ffmpeg-官方文档)
    - [开发者文档](#开发者文档)
  - [FFmpeg 相关赞助计划](#ffmpeg-相关赞助计划)
  - [FFmpeg 开发者会议](#ffmpeg-开发者会议)
  - [FFmpeg 会议](#ffmpeg-会议)
  - [社区贡献文档](#社区贡献文档)
    - [编译 FFmpeg](#编译-ffmpeg)
    - [编码](#编码)
    - [硬件加速](#硬件加速)
    - [抓/捕捉](#抓捕捉)
    - [流](#流)
    - [过滤](#过滤)
    - [图像/帧](#图像帧)
    - [字幕](#字幕)
    - [使用 FFmpeg 库开发程序](#使用-ffmpeg-库开发程序)
    - [杂项](#杂项)
  - [关于此维基](#关于此维基)
    - [许可](#许可)
    - [维基页面索引](#维基页面索引)
    - [Trac 文档](#trac-文档)

翻译[原文](https://trac.ffmpeg.org/wiki)。

## 欢迎使用 FFmpeg 错误跟踪和维基

此维基用于各种 FFmpeg 和多媒体相关的信息。欢迎所有人添加、编辑和改进它！

## 报告错误

- [错误报告清单](https://trac.ffmpeg.org/report/1)
- [非开发人员可以帮助完成的任务](https://trac.ffmpeg.org/report/15)

在提交新报告之前，请阅读[错误跟踪手册](https://git.videolan.org/?p=ffmpeg.git;a=blob_plain;f=doc/issue_tracker.txt;hb=HEAD)和[提交一个错误报告](https://ffmpeg.org/bugreports.html)。你必须先注册，然后才能提交报告或编辑此维基。要上传丹玉 2.5MB 的样本，请在[提交一个错误报告](https://ffmpeg.org/bugreports.html)使用 [VideoLAN 文件上传工具](https://streams.videolan.org/upload/)或 FTP (没有严格文件大小限制)。

## FFmpeg 官方文档

- [文档](https://ffmpeg.org/documentation.html)——FFmpeg 主要的文档页面
- [提交一个 FFmpeg 标识](https://trac.ffmpeg.org/wiki/SubmitALogo)——指导如何向 FFmpeg 提交主体标识或横幅

### 开发者文档

- [开发者规定和指南](https://ffmpeg.org/developer.html)
- [Git 使用指南](https://ffmpeg.org/git-howto.html)
- [关于维护 FFmpeg 源码和称为维护者的说明](https://trac.ffmpeg.org/wiki/MaintainingFFmpeg)
- [FATE](https://trac.ffmpeg.org/wiki/FATE)——我们的持续继承平台/回归测试系统
- [Cleanup](https://trac.ffmpeg.org/wiki/Cleanup)——可以考虑删除的组件清单
- 调试
  - [宏块和运动矢量](https://trac.ffmpeg.org/wiki/Debug/MacroblocksAndMotionVectors)
- [如何从 Libav 合并](https://trac.ffmpeg.org/wiki/LibavMerge)

## FFmpeg 相关赞助计划

- Google Summer of Code
  - [GSOC 2020](https://trac.ffmpeg.org/wiki/SponsoringPrograms/GSoC/2020)
  - [GSOC 2019](https://trac.ffmpeg.org/wiki/SponsoringPrograms/GSoC/2019)
  - [GSOC 2018](https://trac.ffmpeg.org/wiki/SponsoringPrograms/GSoC/2018)
  - [GSOC 2017](https://trac.ffmpeg.org/wiki/SponsoringPrograms/GSoC/2017)
  - [GSOC 2016](https://trac.ffmpeg.org/wiki/SponsoringPrograms/GSoC/2016)
  - [GSOC 2015](https://trac.ffmpeg.org/wiki/SponsoringPrograms/GSoC/2015)
  - [GSOC 2014](https://trac.ffmpeg.org/wiki/SponsoringPrograms/GSoC/2014)
- Outreachy
  - [Outreachy/2016-12](https://trac.ffmpeg.org/wiki/SponsoringPrograms/Outreachy/2016-12)
  - [Outreachy/2016-05](https://trac.ffmpeg.org/wiki/SponsoringPrograms/Outreachy/2016-05)
  - [Outreachy/2015-05](https://trac.ffmpeg.org/wiki/SponsoringPrograms/Outreachy/2015-05)
  - [OPW/2014-12](https://trac.ffmpeg.org/wiki/SponsoringPrograms/OPW/2014-12)

## FFmpeg 开发者会议

- [FFmeeting/2016-05](https://trac.ffmpeg.org/wiki/FFmeeting/2016-05)
- [FFmeeting/2015-09](https://trac.ffmpeg.org/wiki/FFmeeting/2015-09)
- [FFmeeting/2014-10](https://trac.ffmpeg.org/wiki/FFmeeting/2014-10)
- [FFmeeting/2014-01](https://trac.ffmpeg.org/wiki/FFmeeting/2014-01)

## FFmpeg 会议

- [会议日程](https://trac.ffmpeg.org/wiki/Conferences)

## 社区贡献文档

以下指南由用户编写，供用户补充[官方的 FFmpeg 文档](https://ffmpeg.org/documentation.html)。如果你对某些内容感到困惑，请参考官方文档，如果仍有问题，我们可以[帮助](https://ffmpeg.org/contact.html)你。

### 编译 FFmpeg

- [通用编译指南](compilation_guide/generic.md)
- [FFmpeg 编译指南](compilation_guide/README.md)——Windows、macOS、Linux 和其他平台
- [编译基准](https://trac.ffmpeg.org/wiki/CompileBenchmarks)

### 编码

- 视频编解码器
  - [FFV1 备忘录](https://trac.ffmpeg.org/wiki/Encode/FFV1)
  - [H.264 编码指南](https://trac.ffmpeg.org/wiki/Encode/H.264)
  - [H.265 编码指南](https://trac.ffmpeg.org/wiki/Encode/H.265)
  - [VP9(WebM) 编码指南](https://trac.ffmpeg.org/wiki/Encode/VP9)
  - [AV1 编码指南](https://trac.ffmpeg.org/wiki/Encode/AV1)
- 传统的编解码器
  - [Xvid/DivX/MPEG-4 编码指南](https://trac.ffmpeg.org/wiki/Encode/MPEG-4)
  - [VP8(WebM) 编码指南](https://trac.ffmpeg.org/wiki/Encode/VP8)
  - [Theora 视频和 Vorbis 音频编码指南](https://trac.ffmpeg.org/wiki/TheoraVorbisEncodingGuide)
- 音频编解码器
  - [AAC 编码指南](https://trac.ffmpeg.org/wiki/Encode/AAC)
  - [MP3 编码指南](https://trac.ffmpeg.org/wiki/Encode/MP3)
- 通用的编码指南
  - [高品质音频编码指南](https://trac.ffmpeg.org/wiki/Encode/HighQualityAudio)
  - [VFX 流水线编码指南](https://trac.ffmpeg.org/wiki/Encode/VFX)
  - [如何为 YouTube 和其他视频共享网站的视频编码](https://trac.ffmpeg.org/wiki/Encode/YouTube)

### 硬件加速

- [FFmpeg 的硬件加速介绍](https://trac.ffmpeg.org/wiki/HWAccelIntro)

### 抓/捕捉

- [使用 FFmpeg 和 ALSA 捕获音频](https://trac.ffmpeg.org/wiki/Capture/ALSA)
- [如何使用 FFmpeg 抓取桌面(屏幕)](https://trac.ffmpeg.org/wiki/Capture/Desktop)
- [如何使用 FFmpeg 捕捉闪电(雷电)](https://trac.ffmpeg.org/wiki/Capture/Lightning)
- [如何捕获网络摄像头输入](https://trac.ffmpeg.org/wiki/Capture/Webcam)
- [如何在 Linux 上使用采集卡捕获](https://trac.ffmpeg.org/wiki/Capture/V4L2_ALSA)
- [DirectShow](https://trac.ffmpeg.org/wiki/DirectShow)

### 流

- [为流媒体网站(比如 twitch.tv、ustream.tv、YouTube Live 和其他 RTMP(E) 流媒体提供商)编码](https://trac.ffmpeg.org/wiki/EncodingForStreamingSites)
- [流媒体指南](https://trac.ffmpeg.org/wiki/StreamingGuide)
- [使用 ffserver 流媒体](https://trac.ffmpeg.org/wiki/ffserver)

### 过滤

- [过滤指南](https://trac.ffmpeg.org/wiki/FilteringGuide)，包括过滤器选项的语法
- [花式过滤示例](https://trac.ffmpeg.org/wiki/FancyFilteringExamples)
- [缩放](https://trac.ffmpeg.org/wiki/Scaling)视频
- [Xfade](https://trac.ffmpeg.org/wiki/Xfade)——淡入淡出，擦拭和其他过渡
- [后期处理](https://trac.ffmpeg.org/wiki/Postprocessing)——使用 FFmpeg 后期处理低品质视频
- [立体](https://trac.ffmpeg.org/wiki/Stereoscopic)——使用 ffmpeg 的 3D 电影
- [Null](https://trac.ffmpeg.org/wiki/Null)——用于测试解码速度的过滤器
- [波形监视器](https://trac.ffmpeg.org/wiki/WaveformMonitor)——FFmpeg 中的波形监视器
- [矢量示波器](https://trac.ffmpeg.org/wiki/Vectorscope)——FFmpeg 中的矢量示波器
- [直方图](https://trac.ffmpeg.org/wiki/Histogram)——FFmpeg 中的直方图
- [淡入淡出音频滤波器曲线](https://trac.ffmpeg.org/wiki/AfadeCurves)
- [Remap](https://trac.ffmpeg.org/wiki/RemapFilter)——根据映射文件/流将像素从源帧复制到目标帧
- [音频通道处理](https://trac.ffmpeg.org/wiki/AudioChannelManipulation)——上混、下混、分割和处理音频通道
- [音频音量处理](https://trac.ffmpeg.org/wiki/AudioVolume)——修改音量并执行归一化(峰、RMS、EBU R128)

### 图像/帧

- [从图像创建视频幻灯片](https://trac.ffmpeg.org/wiki/Slideshow)
- [每隔 X 秒创建一个视频的缩略图](https://trac.ffmpeg.org/wiki/Create%20a%20thumbnail%20image%20every%20X%20seconds%20of%20the%20video)
- [如何对图像拍摄多个屏幕截图(拼贴，马赛克)](https://trac.ffmpeg.org/wiki/How%20to%20take%20multiple%20screenshots%20to%20an%20image%20(tile%2C%20mosaic))
- [从多个输入视频创建马赛克](https://trac.ffmpeg.org/wiki/Create%20a%20mosaic%20out%20of%20several%20input%20videos)
- [使用 xstack 从多个输入视频创建马赛克](https://trac.ffmpeg.org/wiki/Create%20a%20mosaic%20out%20of%20several%20input%20videos%20using%20xstack)
- [从音频流创建波形图像](https://trac.ffmpeg.org/wiki/Waveform)

### 字幕

- [如何将字幕刻录到视频中](https://trac.ffmpeg.org/wiki/HowToBurnSubtitlesIntoVideo)
- [如何将其他 FFmpeg 支持的字幕转换为 ASS 格式](https://trac.ffmpeg.org/wiki/HowToConvertSubtitleToASS)
- [如何将 YouTube SBV 转换为 SRT](https://trac.ffmpeg.org/wiki/HowToConvertYouTubeSBVtoSRT)

### 使用 FFmpeg 库开发程序

- [如何为 FFmpeg 开发设置 Eclipse IDE](https://trac.ffmpeg.org/wiki/Eclipse)
- [使用 libav*](https://trac.ffmpeg.org/wiki/Using%20libav*)——指导如何将 FFmpeg 主库集成到自己的自定义程序中
- [在 C++ 应用程序中包含 FFmpeg 头文件](https://trac.ffmpeg.org/wiki/Including%20FFmpeg%20headers%20in%20a%20C%2B%2B%20application)
- [FFmpeg API 更改/兼容性测试结果列表](https://trac.ffmpeg.org/wiki/Including%20FFmpeg%20headers%20in%20a%20C%2B%2B%20application)
- [雷霄骅华最简单的 FFmpeg 演示](https://leixiaohua1020.github.io/#ffmpeg-development-examples)

### 杂项

- 通用的命令行用法：
  - [一些错误和消息的解决方案](https://trac.ffmpeg.org/wiki/Errors)
  - 从同一输入[创建多个输出](https://trac.ffmpeg.org/wiki/Creating%20multiple%20outputs)
  - [如何串联、连接或合并媒体文件](https://trac.ffmpeg.org/wiki/Concatenate)
  - [如何使用 -map 选项](https://trac.ffmpeg.org/wiki/Map)准确选择要处理的流
  - [seek](https://trac.ffmpeg.org/wiki/Seeking) 分割文件或选择段
  - [framemd5 介绍和如何](https://trac.ffmpeg.org/wiki/framemd5%20Intro%20and%20HowTo)使用每帧校验和
  - [FFprobe](https://trac.ffmpeg.org/wiki/FFprobeTips) 获取帧速率、帧大小、持续时间等的提示
  - [如何提取视频文件中包含的字幕](https://trac.ffmpeg.org/wiki/How%20to%20speed%20up%20/%20slow%20down%20a%20video)
- 效果：
  - [如何加快/减慢视频时间流逝等](https://trac.ffmpeg.org/wiki/How%20to%20speed%20up%20/%20slow%20down%20a%20video)
- 视频：
  - [更改帧频](https://trac.ffmpeg.org/wiki/ChangingFrameRate)
  - [限制输出比特率](https://trac.ffmpeg.org/wiki/Limiting%20the%20output%20bitrate)
  - [色度二次采样](https://trac.ffmpeg.org/wiki/Chroma%20Subsampling)
  - [调试宏块和运动矢量](https://trac.ffmpeg.org/wiki/Debug/MacroblocksAndMotionVectors)
  - [为什么要删除 ffmpeg -sameq 选项？用什么代替？](https://ffmpeg.org/faq.html#Why-was-the-ffmpeg-_002dsameq-option-removed_003f-What-to-use-instead_003f)
  - [维特比算法](https://trac.ffmpeg.org/wiki/ViterbiAlgorithm)
- 音频：
  - [音频类型](https://trac.ffmpeg.org/wiki/audio%20types)——原始音频的不同类型的列表
  - [FFmpeg 和 SoX 重采样器](https://trac.ffmpeg.org/wiki/FFmpeg%20and%20the%20SoX%20Resampler)——高质量音频重采样
- 使用其他工具工作：
  - [如何使用 Adobe Premiere Pro 中的 FFmpeg 进行编码](https://trac.ffmpeg.org/wiki/Encode/PremierePro)
  - [从 PHP 脚本使用 FFmpeg](https://trac.ffmpeg.org/wiki/PHP)
- 其他的：
  - [如何在 ffmpeg 用户邮件列表上提出好问题](https://trac.ffmpeg.org/wiki/MailingListEtiquette)
  - [创作文章](https://trac.ffmpeg.org/wiki/ArticlesForCreation)——新社区贡献的维基文章的简单想法/提醒列表
  - [下游](https://trac.ffmpeg.org/wiki/Downstreams)——发布 FFmpeg 的下游软件产品列表，包括版本和寿命终止日期
  - [项目](https://trac.ffmpeg.org/wiki/Projects)——已知包含 FFmpeg 的工作的免费项目和程序列表

## 关于此维基

### 许可

FFmpeg 维基的“社区贡献文档”部分中的材料是根据[“知识共享署名-相同方式共享3.0许可”](https://creativecommons.org/licenses/by-sa/3.0/)发布的。只要使用了相同或兼容的许可证，并且功劳归功于作者，那么即使是出于商业目的，任何人都可以以此为基础共享，改编并构建。应归功于“FFmpeg 社区文档维基的贡献者”。

### 维基页面索引

查看[标题索引](https://trac.ffmpeg.org/wiki/TitleIndex)获取有关所有本地维基页面的完整列表。

### Trac 文档

Trac 是 FFmpeg 用于跟踪错误的工具(并且还托管此维基)。

- [Trac 指南](https://trac.ffmpeg.org/wiki/TracGuide)——内置的文档
- [Trac 项目](https://trac.edgewall.org/)——Trac 开源项目
- ​[Trac FAQ](https://trac.edgewall.org/wiki/TracFaq)——经常问的问题
- [Trac 支持](https://trac.ffmpeg.org/wiki/TracSupport)——Trac 支持
