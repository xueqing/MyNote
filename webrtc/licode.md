# licode

- room: 一个 room 的 user 和 client 可以通过 Licode 共享 stream
- Server APP 通过 Nuve API 创建 room，user 通过 Erizo 连接到 room
- 通过 Erizo Controller 控制 rooms，通过 Erizo API 控制 stream

| Client 的类 | 描述 | 类型 |
| --- | --- | --- |
| Erizo.Stream/Licode Event | 表示库中一般的事件，被其他类继承 | room-connected 等 |
| Erizo.Room/Room Event | 表示和 room 连接相关的事件 | room-connected/room-error/room-disconnected |
| Erizo.Events/Stream Event | 表示一个 room 内的 stream 相关的事件 | access-accepted/access-denied/stream-added/stream-removed/stream-data/stream-attributes/update/bandwidth-alert/stream-failed/stream-ended |

| Server 的类 | 描述 |
| --- | --- |
| Room | 表示一个视频会议 room | room-connected 等 |
| Token | 添加一个新的参与者到一个视频会议 room 的 key |
| User | 一个 user 可以发布和订阅一个视频会议 room 的 stream |