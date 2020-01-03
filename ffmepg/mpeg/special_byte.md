# 特殊字节

| 值 | 比特数 | 域 | 功能 |
| --- | --- | --- | --- |
| 0x000001BA | 32 | PS pack header | 同步字节 sync bytes |
| 0x000001BB | 32 | PS system header | 同步字节 sync bytes |
| 0x000001BC | 32 | PS map header | 包起始码前缀 packet start code prefix + 映射流标识 map stream id (0XBC) |
| 0X000001BD | 32 | private stream 1 | - |
| 0x000001BE | 32 | padding stream | - |
| 0X000001BF | 32 | private stream 2 | - |
| 0x000001B3 | 32 | MPEG-2 video ES header | 起始码 start code |
| 0xFFF | 12 | MPEG-1 audio ES header | 起始码 sync word |
| 0x000001 | 24 | PES header | 包起始码前缀 packet start code prefix |
| 0x000001C0 | 32 | PES header(audeo stream) | audio streams (0xC0-0xDF) |
| 0x000001E0 | 32 | PES header(video stream) | video streams (0xE0-0xEF) |
