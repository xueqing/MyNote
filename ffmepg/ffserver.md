# ffserver

- [ffserver](#ffserver)
  - [使用 ffprobe 探测文件格式](#%e4%bd%bf%e7%94%a8-ffprobe-%e6%8e%a2%e6%b5%8b%e6%96%87%e4%bb%b6%e6%a0%bc%e5%bc%8f)
  - [安装依赖包](#%e5%ae%89%e8%a3%85%e4%be%9d%e8%b5%96%e5%8c%85)
  - [编译 ffmpeg](#%e7%bc%96%e8%af%91-ffmpeg)
  - [添加 ffserver 启动的配置文件](#%e6%b7%bb%e5%8a%a0-ffserver-%e5%90%af%e5%8a%a8%e7%9a%84%e9%85%8d%e7%bd%ae%e6%96%87%e4%bb%b6)
    - [报错](#%e6%8a%a5%e9%94%99)
  - [搭建 flv 服务](#%e6%90%ad%e5%bb%ba-flv-%e6%9c%8d%e5%8a%a1)
  - [参考](#%e5%8f%82%e8%80%83)

## 使用 ffprobe 探测文件格式

```json
# ./ffprobe  -print_format json -v quiet -show_streams ../1movie.flv
{
    "streams": [
        {
            "index": 0,
            "codec_name": "h264",
            "codec_long_name": "H.264 / AVC / MPEG-4 AVC / MPEG-4 part 10",
            "profile": "High",
            "codec_type": "video",
            "codec_time_base": "41/1966",
            "codec_tag_string": "[0][0][0][0]",
            "codec_tag": "0x0000",
            "width": 1920,
            "height": 1080,
            "coded_width": 1920,
            "coded_height": 1080,
            "has_b_frames": 2,
            "sample_aspect_ratio": "1:1",
            "display_aspect_ratio": "16:9",
            "pix_fmt": "yuv420p",
            "level": 31,
            "chroma_location": "left",
            "field_order": "progressive",
            "refs": 1,
            "is_avc": "true",
            "nal_length_size": "4",
            "r_frame_rate": "24000/1001",
            "avg_frame_rate": "983/41",
            "time_base": "1/1000",
            "start_pts": 83,
            "start_time": "0.083000",
            "bit_rate": "2000713",
            "bits_per_raw_sample": "8",
            "disposition": {
                "default": 0,
                "dub": 0,
                "original": 0,
                "comment": 0,
                "lyrics": 0,
                "karaoke": 0,
                "forced": 0,
                "hearing_impaired": 0,
                "visual_impaired": 0,
                "clean_effects": 0,
                "attached_pic": 0,
                "timed_thumbnails": 0
            }
        },
        {
            "index": 1,
            "codec_name": "aac",
            "codec_long_name": "AAC (Advanced Audio Coding)",
            "profile": "LC",
            "codec_type": "audio",
            "codec_time_base": "1/48000",
            "codec_tag_string": "[0][0][0][0]",
            "codec_tag": "0x0000",
            "sample_fmt": "fltp",
            "sample_rate": "48000",
            "channels": 2,
            "channel_layout": "stereo",
            "bits_per_sample": 0,
            "r_frame_rate": "0/0",
            "avg_frame_rate": "0/0",
            "time_base": "1/1000",
            "start_pts": 83,
            "start_time": "0.083000",
            "bit_rate": "96000",
            "disposition": {
                "default": 0,
                "dub": 0,
                "original": 0,
                "comment": 0,
                "lyrics": 0,
                "karaoke": 0,
                "forced": 0,
                "hearing_impaired": 0,
                "visual_impaired": 0,
                "clean_effects": 0,
                "attached_pic": 0,
                "timed_thumbnails": 0
            }
        }
    ]
}
```

## 安装依赖包

```sh
sudo apt-get install libx264-dev
sudo apt-get install libfaac-dev
```

## 编译 ffmpeg

```sh
# 不添加 --enable-gpl 会报错：
## libx264 is gpl and --enable-gpl is not specified
./configure --enable-libx264 --enable-gpl --enable-libfaac
make clean
make -j8
```

报错信息 `Unknown option "--enable-faac"`，是因为 3.2 之后的版本不再支持 libfaac，换成 fdk-aac 了。下载最新的 fdk-aac，然后编译

```sh
sudo apt-get install libx264-dev
sudo apt-get install libfdk-aac-dev
# 不添加 --enable-nonfree 会报错：
## libfdk_aac is incompatible with the gpl and --enable-nonfree is not specified
./configure --enable-libx264 --enable-gpl --enable-libfdk-aac --enable-nonfree
make clean
make -j8
```

## 添加 ffserver 启动的配置文件

- 创建文件 `ffserver.conf`，并添加下面的内容

```conf
Port 8090
BindAddress 0.0.0.0
MaxHTTPConnections 2000
MaxClients 1000
MaxBandwidth 1000
CustomLog -

<Stream stat.html>
Format status
ACL allow localhost
ACL allow 192.168.0.0 192.168.255.255
</Stream>

<Feed feed1.ffm>
File /tmp/feed1.ffm
FileMaxSize 1G
ACL allow 127.0.0.1
</Feed>

<Stream live.flv>
Format flv
Feed feed1.ffm

AudioCodec aac
Strict -2
AudioBitRate 128
AudioChannels 2
AudioSampleRate 44100
AVOptionAudio flags +global_header

VideoCodec libx264
VideoFrameRate 30
VideoBitRate 800
VideoSize 720x576
AVOptionVideo crf 23
AVOptionVideo preset medium
AVOptionVideo me_range 16
AVOptionVideo qdiff 4
AVOptionVideo qmin 10
AVOptionVideo qmax 51
AVOptionVideo flags +global_header
</Stream>
```

### 报错

- 写成 `VideoCodec h264` 会报错

```txt
ffserver.conf:24: Invalid codec name: 'h264'
```

使用 `./ffmpeg -codecs | grep 264` 可知 h264 是解码器的名字，输出信息如下，对应编码器的名字是 libx264。所以改成 `VideoCodec libx264` 即可

```txt
DEV.LS h264                 H.264 / AVC / MPEG-4 AVC / MPEG-4 part 10 (decoders: h264 h264_v4l2m2m h264_vdpau h264_cuvid ) (encoders: libx264 libx264rgb h264_nvenc h264_v4l2m2m h264_vaapi nvenc nvenc_h264 )
```

## 搭建 flv 服务

```sh
# 启动 ffserver
./ffserver -d -f conf/ffserver.conf
# ffmpeg 推流
./ffmpeg -i ../1movie.flv http://localhost:8090/feed1.ffm
# ffplay 播放
./ffplay http://localhost:8090/live.flv
```

## 参考

- [Compile FFmpeg for Ubuntu, Debian, or Mint](https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu)
- [Play with ffserver – a quick overview](https://www.alkannoide.com/2013/07/04/play-with-ffserver-a-quick-overview/)
