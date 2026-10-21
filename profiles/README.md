# 自定义版本适配接口

从 v1.2.0 起，可通过外部 JSON 配置提供不同版本的文件摘要、修改位置和补丁数据，无需修改 CMD 源码或关闭自检。默认双击使用仍只加载内置的 413 配置。

```bat
MAKE-PCL-DOWNLOAD-AGAIN.cmd "D:\PCL-414.exe" --check --profile "D:\414.json"
MAKE-PCL-DOWNLOAD-AGAIN.cmd "D:\PCL-414.exe" --yes --profile "D:\414.json"
MAKE-PCL-DOWNLOAD-AGAIN.cmd "D:\PCL-414.exe" --restore --profile "D:\414.json"
```

提供了可工作的 [413 示例](413.example.json)，可用于验证接口。**它不适用于 414。**

本目录另附社区适配者提供的 [414 配置](414.json)，对应 PCL 2.99.0.0 快照版：

```bat
MAKE-PCL-DOWNLOAD-AGAIN.cmd "D:\PCL 2.99.0.0 (414).exe" --yes --profile ".\profiles\414.json"
```

该配置由社区提供、未经本项目独立验证；使用前请确认原文件 SHA-256 为 `5b64d6d540c376390470cea3ab99d47661e8bca81be2ba647ea83e7d2e9428fa`。

有 414 原始文件的适配者只需生成对应 JSON，即可接入同一个工具，不必改掉硬编码的版本白名单。配置中的摘要和原始字节必须与目标文件匹配；不能把 413 示例只改名为 414。

## JSON 字段

| 字段 | 含义 |
|---|---|
| schemaVersion | 当前为数字 1 |
| name | 配置名称，1 至 128 字符 |
| originalLength | 原文件字节数，最大 64 MB |
| originalHash | 原文件完整 SHA-256，小写 64 字符 |
| patchedHash | 修改后完整 SHA-256，小写 64 字符 |
| downloadOnlyHash | 可选，能够由此配置还原的旧补丁文件摘要 |
| patches | 1 至 256 处等长字节替换 |
| patches[].offset | 从文件起点计算的十进制字节偏移 |
| patches[].old | 修改前字节，Base64 |
| patches[].new | 修改后字节，Base64，与 old 等长 |
| tail | 可选，追加在原文件末尾的 Base64 数据 |

修改范围不能重叠或越界。若追加 PE 方法体，必须在 patches 中同步修改该版本需要的 PE 字段和方法入口；接口不会自动重建 PE。

工具检查配置格式、完整文件摘要及原始字节，保留原版备份，并验证输出摘要。恢复时也必须提供同一份配置。自定义配置由适配者提供，尚未经过本项目验证的配置会显示为自定义来源。

**配置决定 EXE 将如何被修改。脚本自检与现有来源证明不覆盖外部配置，请只使用你信任的来源。完整摘要匹配不代表补丁逻辑正确。**
