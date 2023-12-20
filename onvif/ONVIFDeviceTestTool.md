# ONVIF Device Test Tool 使用

- [ONVIF Device Test Tool 使用](#onvif-device-test-tool-使用)
  - [添加模板文件 GetOSDs](#添加模板文件-getosds)

## 添加模板文件 GetOSDs

- 找到 `Debug==>Requests`，可以看到其中有很多请求的模板文件。
- 点击右侧 `Add Request To Templates` 可以找到模板文件存放位置，比如 `C:\Users\kiki\AppData\Roaming\ONVIF\ONVIF Device Test Tool\Requests\`。
- 在 `MediaConf` 中新建文件夹 `GetOSDs`，将 `GetVideoSourceConfigurations` 中的文件拷贝到 `GetOSDs`，并修改为以下内容

```xml
<?xml version='1.0' encoding='utf-8'?>
<soap:Envelope
 xmlns:soap="http://www.w3.org/2003/05/soap-envelope"
 xmlns:trt="http://www.onvif.org/ver10/media/wsdl"
 xmlns:tt="http://www.onvif.org/ver10/schema">
	<soap:Body>
        <trt:GetOSDs>
            <trt:ConfigurationToken>VideoSourceConfigurationToken006</trt:ConfigurationToken>
        </trt:GetOSDs>
    </soap:Body>
</soap:Envelope>
```

- 重启 ONVIF Device Test Tool 即可
