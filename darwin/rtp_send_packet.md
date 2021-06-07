# RTP 发包

- [RTP 发包](#rtp-发包)
  - [发包的主要流程](#发包的主要流程)
    - [RTPSession 计算时间请求发送数据包](#rtpsession-计算时间请求发送数据包)
    - [QTSSRTPFileModule 读取数据包并发送](#qtssrtpfilemodule-读取数据包并发送)
    - [RTPFileSession 读取数据包](#rtpfilesession-读取数据包)
  - [读取数据包的实现](#读取数据包的实现)
    - [QTSSStream 定义基本流对象及其接口](#qtssstream-定义基本流对象及其接口)
    - [QTSSDictionary 添加字典 API 功能](#qtssdictionary-添加字典-api-功能)
    - [QTSSFile 实现调用模块流接口](#qtssfile-实现调用模块流接口)
    - [QTSSPosixFileSysModule 调用 OSFileSource 实现底层的读](#qtssposixfilesysmodule-调用-osfilesource-实现底层的读)

## 发包的主要流程

### RTPSession 计算时间请求发送数据包

定期调用 `RTPSession::Run` 函数，在其中调用 `(void)fModule->CallDispatch(QTSS_RTPSendPackets_Role, &theParams);` 读取并发送一包数据，实现 RTP 包的发送流程。

```cpp
SInt64 RTPSession::Run()
{
  EventFlags events = this->GetEvents();
  QTSS_RoleParams theParams;
  theParams.clientSessionClosingParams.inClientSession = this;// 保存本身地址

  // 异常需要停止此会话
  if ((events & Task::kKillEvent) || (events & Task::kTimeoutEvent) || (fModuleDoingAsyncStuff))
  {
    // ......
    return -1;// 返回 -1 线程池会杀掉此任务
  }

  // 如果是暂停状态，等待新的 play；包发送模块未赋值也会直接返回
  if ((fState == qtssPausedState) || (fModule == NULL))
    return 0;

  // 持有互斥锁，避免发包时接受 RTSP 请求
  {
    OSMutexLocker locker(&fSessionMutex);

    // 确保在计划的播放时间(fNextSendPacketsTime)之前不会被调度。如果被调度，重新调整下次调度的时间（正在播放时客户端发送一个 play，会发生这种情况）
    theParams.rtpSendPacketsParams.inCurrentTime = OS::Milliseconds();
    // 未到下次发送时间
    if (fNextSendPacketsTime > theParams.rtpSendPacketsParams.inCurrentTime)
    {
      RTPStream** retransStream = NULL;
      UInt32 retransStreamLen = 0;

      // 如果需要发送一个 retransmits
      for (int streamIter = 0; this->GetValuePtr(qtssCliSesStreamObjects, streamIter, (void**)&retransStream, &retransStreamLen) == QTSS_NoErr; streamIter++)
        if (retransStream && *retransStream)
          (*retransStream)->SendRetransmits();

      // 更新下次调度的时间，即任务下次被调度的超时时间
      theParams.rtpSendPacketsParams.outNextPacketTime = fNextSendPacketsTime - theParams.rtpSendPacketsParams.inCurrentTime;
    }
    else
    {
      if ((theParams.rtpSendPacketsParams.inCurrentTime - fLastBandwidthTrackerStatsUpdate) > 1000)
        this->GetBandwidthTracker()->UpdateStats();

      theParams.rtpSendPacketsParams.outNextPacketTime = 0;
      // 此角色支持异步事件注册
      fModuleState.eventRequested = false;
      // 调用包发送模块发送一包数据
      (void)fModule->CallDispatch(QTSS_RTPSendPackets_Role, &theParams);
      // 确保不会在这里返回负数导致任务线程被删除
      if (theParams.rtpSendPacketsParams.outNextPacketTime < 0)
        theParams.rtpSendPacketsParams.outNextPacketTime = 0;
      // 更新下一包的发送时间
      fNextSendPacketsTime = theParams.rtpSendPacketsParams.inCurrentTime + theParams.rtpSendPacketsParams.outNextPacketTime;
    }
  }

  // 确保下次调用时间不大于最大的 retransmit 延迟间隔
  UInt32 theRetransDelayInMsec = QTSServerInterface::GetServer()->GetPrefs()->GetMaxRetransmitDelayInMsec();
  UInt32 theSendInterval = QTSServerInterface::GetServer()->GetPrefs()->GetSendIntervalInMsec();

  // 如果下次发包时间大于最大重发延时和发送间隔之和，等到下次唤醒之后还需要重发，再继续等待。
  if (theParams.rtpSendPacketsParams.outNextPacketTime > (theRetransDelayInMsec + theSendInterval))
    theParams.rtpSendPacketsParams.outNextPacketTime = theRetransDelayInMsec;

  // 确保不会在这里返回负数导致任务线程被删除
  Assert(theParams.rtpSendPacketsParams.outNextPacketTime >= 0);
  return theParams.rtpSendPacketsParams.outNextPacketTime;
}
```

### QTSSRTPFileModule 读取数据包并发送

`QTSSRTPFileModule` 通过注册 `QTSS_RTPSendPackets_Role` 角色实现外部对 `SendPackets` 函数的调用。`SendPackets` 内部调用 `GetNextPacket` 获取一包数据，再调用 `QTSS_Write` 发送数据包。

```cpp
QTSS_Error SendPackets(QTSS_RTPSendPackets_Params* inParams)
{
  FileSession** theFile = NULL;
  UInt32 theLen = 0;
  // 在 describe/setup 阶段保存文件相关属性
  QTSS_Error theErr = QTSS_GetValuePtr(inParams->inClientSession, sFileSessionAttr, 0, (void**)&theFile, &theLen);
  if ((theErr != QTSS_NoErr) || (theLen != sizeof(FileSession*)))
  {
    Assert( 0 );
    return QTSS_RequestFailed;
  }

  while (true)
  {   
    // 数据包内容为空，则重新读取一包
    if ((*theFile)->fPacketStruct.packetData == NULL)
    {
      void* theCookie = NULL;
      // 获取要发送的包，theTransmitTime 是发送时间
      Float64 theTransmitTime = (*theFile)->fFile.GetNextPacket((UInt8**)&(*theFile)->fPacketStruct.packetData, &(*theFile)->fNextPacketLen, &theCookie);

      //断基于用户请求的 Range 头域的停止时间，判断是否应该停止播放
      if (((*theFile)->fStopTime != -1) && (theTransmitTime > (*theFile)->fStopTime))
      {
        (void)QTSS_Pause(inParams->inClientSession);
        inParams->outNextPacketTime = qtssDontCallSendPacketsAgain;
        return QTSS_NoErr;
      }

      // 基于速度调整发送时间，倍速播放时，发送时间间隔变小
      // RTSPRequest 在解析 Range 头域的时候设置 fStartTime
      // fStartTime 在 DoPlay 设置为 RTSPRequest(RTSPRequestInterface) 的 fStartTime，默认为 0
      // theTransmitTime 相对于 Range 头域的开始时间
      Float64 theOffsetFromStartTime = theTransmitTime - (*theFile)->fStartTime;
      theTransmitTime = (*theFile)->fStartTime + (theOffsetFromStartTime / (*theFile)->fSpeed);

      (*theFile)->fStream = (QTSS_RTPStreamObject)theCookie;
      // RTPSession 在 DoPlay 时调用 RTPSession::Play 设置 fAdjustedPlayTime，等于开始播放的系统时间减去播放请求 Range 域的开始时间
      // fAdjustedPlayTime 在 DoPlay 时设置为 RTPSessionInterface 的 fAdjustedPlayTime，单位毫秒
      // packetTransmitTime 相对于开始播放的系统时间
      (*theFile)->fPacketStruct.packetTransmitTime = (*theFile)->fAdjustedPlayTime + ((SInt64)(theTransmitTime * 1000));
    }

    // 读不到数据，表示所有流播完，不再调用此函数
    if ((*theFile)->fPacketStruct.packetData == NULL)
    {
      inParams->outNextPacketTime = qtssDontCallSendPacketsAgain;
      return QTSS_NoErr;
    }
    // 确认读到一包数据需要发送
    Assert((*theFile)->fStream != NULL);

    // 发送数据包。调用 RTPStream::Write 函数，发送 RTP 数据给客户端。调用者需要指定 qtssWriteFlagsIsRTP/qtssWriteFlagsIsRTCP
    // RTPStream::Write 返回 EAGAIN/QTSS_WouldBlock 时，QTSS_Write 返回 QTSS_WouldBlock
    theErr =  QTSS_Write((*theFile)->fStream, &(*theFile)->fPacketStruct, (*theFile)->fNextPacketLen, NULL, qtssWriteFlagsIsRTP);
    if ( theErr == QTSS_WouldBlock )
    {   
      if ((*theFile)->fPacketStruct.packetTransmitTime == -1)
        inParams->outNextPacketTime = sFlowControlProbeInterval;  // for buffering, try me again in # MSec
      else
      {
        Assert((*theFile)->fPacketStruct.packetTransmitTime > inParams->inCurrentTime);
        inParams->outNextPacketTime = (*theFile)->fPacketStruct.packetTransmitTime - inParams->inCurrentTime;
      }
      return QTSS_NoErr;
    }
    (*theFile)->fPacketStruct.packetData = NULL;
  }
  Assert(0);
  return QTSS_NoErr;
}
```

### RTPFileSession 读取数据包

```cpp
Float64 RTPFileSession::GetNextPacket(UInt8** outPacket, UInt32* outPacketLength, void** outCookie)
{
  Bool16 isValidPacket = false;
  RTPFilePacket* thePacket = NULL;

  // 循环直至找到有效的包
  while (!isValidPacket)
  {
    // If we are between blocks, read the next block
    if (fCurrentPacket == NULL)
    {
      // 文件已经读完
      if (fCurrentPosition == fFileLength)
      {
        *outPacket = NULL;
        return -1;
      }
      // 读一包
      this->ReadAndAdvise();
    }

    Assert(fCurrentPacket != NULL);
    thePacket = (RTPFilePacket*)fCurrentPacket;

    if (thePacket->fTrackID & kPaddingBit)
    {
      // 是一个填充包，将 fCurrentPacket 指针移到下个区块
      fReadBufferOffset += kBlockSize;
      fReadBufferOffset &= kBlockMask; //Rounds down to the nearest block size

      // 确保不在 buffer 末尾
      if (fReadBufferOffset >= fDataBufferLen)
        fCurrentPacket = NULL;
      else
        fCurrentPacket = fDataBuffer + fReadBufferOffset;
    }
    else if (!fTrackInfo[thePacket->fTrackID].fEnabled)
    {
      // 包有效，但是轨道未启用，因此跳过此包
      Assert(thePacket->fTrackID <= fFile->GetMaxTrackNumber());
      this->SkipToNextPacket(thePacket);
    }
    else
      // 包有效，且轨道已启用
      isValidPacket = true;
  }

  // 确保是一个有效包
  Assert(thePacket != NULL);
  Assert(thePacket->fTrackID <= fFile->GetMaxTrackNumber());
  
  // 设置返回值
  *outPacket = (UInt8*)(thePacket + 1);
  *outPacketLength = thePacket->fPacketLength;
  *outCookie = fTrackInfo[thePacket->fTrackID].fCookie;

  // 设置包的 SSRC
  UInt32* ssrcPtr = (UInt32*)*outPacket;
  ssrcPtr[2] = fTrackInfo[thePacket->fTrackID].fSSRC;

  // 保存当前包的发送时间
  Float64 transmitTime = thePacket->fTransmitTime;

  // 设置下一包
  this->SkipToNextPacket(thePacket);
  return transmitTime;  
}
```

## 读取数据包的实现

### QTSSStream 定义基本流对象及其接口

```cpp
// QTSSStream 是抽象基类，包含通用流函数的原型。
class QTSSStream
{
public:
  QTSSStream() : fTask(NULL) {}
  virtual ~QTSSStream() {}

  // A stream can have a task associated with it. If this stream supports
  // async I/O, the task is needed to know what to wakeup when there is an event
  // 流可以管理一个任务。当此流支持异步 IO 时，有事件时需要知道要唤醒的任务
  void  SetTask(Task* inTask)   { fTask = inTask; }
  Task*   GetTask()         { return fTask; }

  virtual QTSS_Error  Read(void* /*ioBuffer*/, UInt32 /*inLen*/, UInt32* /*outLen*/) { return QTSS_Unimplemented; }
  virtual QTSS_Error  Write(void* /*inBuffer*/, UInt32 /*inLen*/, UInt32* /*outLenWritten*/, UInt32 /*inFlags*/) { return QTSS_Unimplemented; }
  virtual QTSS_Error  WriteV(iovec* /*inVec*/, UInt32 /*inNumVectors*/, UInt32 /*inTotalLength*/, UInt32* /*outLenWritten*/){ return QTSS_Unimplemented; }
  virtual QTSS_Error  Flush() { return QTSS_Unimplemented; }
  virtual QTSS_Error  Seek(UInt64 /*inNewPosition*/)  { return QTSS_Unimplemented; }
  virtual QTSS_Error  Advise(UInt64 /*inPosition*/, UInt32 /*inAdviseSize*/) { return QTSS_Unimplemented; }
  virtual QTSS_Error  RequestEvent(QTSS_EventType /*inEventMask*/) { return QTSS_Unimplemented; }

private:
  Task* fTask;
};
```

### QTSSDictionary 添加字典 API 功能

`QTSSDictionary` 继承 `QTSSStream` 类，和 `QTSSDictionaryMap` 一起实现 QTSS API 中的“字典” API。`QTSSDictionary` 对应一个 `QTSS_Object`，`QTSSDictionaryMap` 对应一个 `QTSS_ObjectType`。

### QTSSFile 实现调用模块流接口

`QTSSFile` 添加打开和关闭的接口，并实现流的接口。`QTSSFile::Read` 和 `QTSSFile::Advise` 内部是调用拥有 `QTSS` API 的模块，由底层模块实现实际的功能。

```cpp
class QTSSFile : public QTSSDictionary
{
public:
  QTSSFile();
  virtual ~QTSSFile() {}

  static void     Initialize();

  // 打开和关闭
  QTSS_Error          Open(char* inPath, QTSS_OpenFileFlags inFlags);
  void                Close();

  // 实现流函数
  virtual QTSS_Error  Read(void* ioBuffer, UInt32 inLen, UInt32* outLen);
  virtual QTSS_Error  Seek(UInt64 inNewPosition);
  virtual QTSS_Error  Advise(UInt64 inPosition, UInt32 inAdviseSize);
  virtual QTSS_Error  RequestEvent(QTSS_EventType inEventMask);

private:
  QTSSModule* fModule;
  UInt64      fPosition;
  QTSSFile*   fThisPtr;

  // 文件属性
  UInt64      fLength;
  time_t      fModDate;

  static QTSSAttrInfoDict::AttrInfo   sAttributes[];
};
```

### QTSSPosixFileSysModule 调用 OSFileSource 实现底层的读

`QTSSPosixFileSysModule` 注册相关的角色，`QTSSFile` 调用这些角色时，`QTSSPosixFileSysModule` 调用 `OSFileSource` 的接口实现真正的读数据。

```cpp
QTSS_Error  AdviseFile(QTSS_AdviseFile_Params* inParams)
{
  OSFileSource** theFile = NULL;
  UInt32 theLen = 0;

  (void)QTSS_GetValuePtr(inParams->inFileObject, sOSFileSourceAttr, 0, (void**)&theFile, &theLen);
  Assert(theLen == sizeof(OSFileSource*));
  (*theFile)->Advise(inParams->inPosition, inParams->inSize);

  return QTSS_NoErr;
}

QTSS_Error  ReadFile(QTSS_ReadFile_Params* inParams)
{
  OSFileSource** theFile = NULL;
  UInt32 theLen = 0;

  (void)QTSS_GetValuePtr(inParams->inFileObject, sOSFileSourceAttr, 0, (void**)&theFile, &theLen);
  Assert(theLen == sizeof(OSFileSource*));
  OS_Error osErr = (*theFile)->Read(inParams->inFilePosition, inParams->ioBuffer, inParams->inBufLen, inParams->outLenRead);

  if (osErr == EAGAIN)
    return QTSS_WouldBlock;
  else if (osErr != OS_NoErr)
    return QTSS_RequestFailed;
  else
    return QTSS_NoErr;
}
```

```cpp
// 建议操作系统很快要从 advisePos 位置读取 adviseAmt 长度的数据
void OSFileSource::Advise(UInt64 advisePos, UInt32 adviseAmt)
{
  // 除了 MacOSXServer 其他 OS 不做任何操作
}

// 从缓存或者磁盘的 inPosition 开始读取数据写入 inBuffer(长度为 inLength)，实际读取长度保存在 outRcvLen
OS_Error OSFileSource::Read(UInt64 inPosition, void* inBuffer, UInt32 inLength, UInt32* outRcvLen)
{
  if ((!fFileMap.Initialized())
    || (!fCacheEnabled)
    || (fFileMap.GetBuffIndex(inPosition + inLength) > fFileMap.GetMaxBuffIndex())
    )
    return  this->ReadFromPos(inPosition, inBuffer, inLength, outRcvLen);
  return  this->ReadFromCache(inPosition, inBuffer, inLength, outRcvLen);
}
```
