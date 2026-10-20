# MAKE PCL DOWNLOAD AGAIN!

**一键解除PCL下载限制 玩的开心**

Windows 直接下载 [MAKE-PCL-DOWNLOAD-AGAIN.cmd](https://github.com/caotaiyi/make-pcl-download-again/raw/refs/heads/main/MAKE-PCL-DOWNLOAD-AGAIN.cmd)，双击运行。无需解压，也无需安装 Python、Java 或其他编程环境。

## 玩的开心

<img src="happy.png" alt="玩的开心" width="360">



希望你把时间花在盖房子、挖矿、和朋友联机上。愿你的钻石总在下一镐，愿你的存档平安无事。

**MAKE PCL DOWNLOAD AGAIN! 玩的开心。**

## Windows：

1. 关闭 PCL。
2. [下载 CMD 文件](https://github.com/caotaiyi/make-pcl-download-again/raw/refs/heads/main/MAKE-PCL-DOWNLOAD-AGAIN.cmd)，双击打开；也可以直接把 PCL 的 `.exe` 拖到 CMD 上。
3. 工具自动查找启动器。找到多个文件时选择编号，没找到时粘贴完整路径。
4. 输入 `y` 确认。看到「玩的开心」后，重新打开 PCL，可进入「下载 → 自动安装」，也可以把本地 `.zip` / `.mrpack` 整合包拖入 PCL 安装。

CMD 调用 Windows 自带的 PowerShell，不需要安装额外软件。自动查找最多深入 3 层、检查 15,000 个目录项，约 6 秒后停止继续查找；慢盘的单次读取可能更久。直接拖入文件可以省去查找。

## v1.1.0：恢复整合包拖入安装

新版同时恢复游戏下载页和本地整合包拖入安装。已用 v1.0.0 修复过下载的用户，重新下载 CMD 运行一次即可升级，原版备份会保留。

支持接回 PCL 自带的 CurseForge、Modrinth、HMCL、MMC、MCBBS 格式安装器，以及其原有的带启动器压缩包、普通压缩包处理流程。具体整合包仍需满足 PCL 原有的格式和环境要求；RAR 不受支持，请使用 ZIP 或 MRPACK。

## 检查与恢复

在 CMD 所在目录打开终端，可以运行：

```bat
:: 仅检查文件，不修改
MAKE-PCL-DOWNLOAD-AGAIN.cmd "D:\Plain Craft Launcher 2.exe" --check

:: 校验通过后直接修复
MAKE-PCL-DOWNLOAD-AGAIN.cmd "D:\Plain Craft Launcher 2.exe" --yes

:: 从原版备份恢复，需要确认
MAKE-PCL-DOWNLOAD-AGAIN.cmd "D:\Plain Craft Launcher 2.exe" --restore
```

## 支持范围

- 当前只支持经过文件校验的 **PCL 正式版 2.99.0.0 (413)**，不匹配的文件会停止处理。
- 修改前先在启动器旁保存 `.pcl-download-backup` 备份；不覆盖不匹配的备份，重复运行不会重复修改。
- 恢复 MC「自动安装」下载页的版本列表加载器，并补回整合包格式识别后的安装器分流。兼容原版及 v1.0.0 已修复的文件，重复运行会跳过。
- 已在真实 PCL 文件副本上验证修复、旧补丁升级、重复运行、备份冲突与恢复，恢复后与原文件完全一致。另将实际补丁中的识别与分流 IL 放入隔离验证程序，使用 16 个根目录/嵌套目录压缩包样例验证格式分流、成功/异常路径及资源释放，并验证损坏 ZIP 报错。安装器调用在隔离验证中使用替身；尚未完成联网下载及真实整合包的端到端安装验证。
- 工具离线运行，不读取账号信息，不改动游戏存档。仓库不分发 PCL 本体。

## 原理

该版本的整合包格式识别、拖拽入口及各格式安装器仍在，识别完格式后原本会直接抛出禁用提示。补丁保留原有识别和异常处理逻辑，按照 [PCL 上游的格式分流](https://github.com/Meloong-Git/PCL/blob/6b9a50df911c9d68b69b24c979efba477fb14b67/Plain%20Craft%20Launcher%202/Modules/Minecraft/ModModpack.vb) 重新调用对应安装器，并在退出时释放压缩包。

新增方法体复用现有元数据标记，写入 EXE 最后一个 PE 节的扩展空间，再调整方法入口和相应 PE 字段；同时应用原有的下载列表补丁。不会额外下载组件，CMD 内已包含补丁数据。处理前后均检查完整文件 SHA-256，不接受其他版本或未知改动。

支持的原文件 SHA-256：

```text
6b6e1260cb5a1d6a303855f1c60cab3d0bc1aebba7e40a964180188b271e7386
```

这是一个独立的小工具，与 PCL 官方无关联。感谢原启动器开发者，也祝每个打开它的人，玩的开心。
