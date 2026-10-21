# MAKE PCL DOWNLOAD AGAIN!

[![Windows 自动检查](https://github.com/caotaiyi/make-pcl-download-again/actions/workflows/verify.yml/badge.svg?branch=main)](https://github.com/caotaiyi/make-pcl-download-again/actions/workflows/verify.yml)
[![发行文件来源验证](https://github.com/caotaiyi/make-pcl-download-again/actions/workflows/attest-release.yml/badge.svg?branch=main)](https://github.com/caotaiyi/make-pcl-download-again/actions/workflows/attest-release.yml)

**一键解除PCL下载限制 玩的开心**

**本项目免费提供，作者未在任何渠道售卖本工具。如通过购买获取，请联系商家退款。**

v1.1.1 已生成 [GitHub 签名来源证明](https://github.com/caotaiyi/make-pcl-download-again/attestations/57839429)，并通过 [公开 Windows 自动检查](https://github.com/caotaiyi/make-pcl-download-again/actions/workflows/verify.yml)。可核对文件摘要、仓库和工作流；这些记录不等于无病毒保证或 GitHub 人工审核。详见 [来源与验证说明](TRUST.md)。

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

## v1.2.0：开放自定义版本适配接口

新增 `--profile` 接口：其他版本可以通过独立 JSON 配置提供文件摘要、修改位置和补丁数据，无需改动 CMD 源码。普通双击仍使用内置的 413 配置。详见 [适配接口与 413 示例](profiles/README.md)。

```bat
MAKE-PCL-DOWNLOAD-AGAIN.cmd "D:\PCL-414.exe" --check --profile "D:\414.json"
MAKE-PCL-DOWNLOAD-AGAIN.cmd "D:\PCL-414.exe" --yes --profile "D:\414.json"
MAKE-PCL-DOWNLOAD-AGAIN.cmd "D:\PCL-414.exe" --restore --profile "D:\414.json"
```

**414 的接入接口已开放，但目前没有取得和验证该版本的实际补丁配置。不能直接使用 413 的配置或仅修改版本名称。** 自定义配置会明确提示来源；已有签名来源证明及脚本自检不覆盖外部 JSON。检查模式会在内存中核对补丁计划，不修改目标文件。

## 双击自动自检

直接下载 CMD、双击运行即可。脚本会自动进行 SHA-256 完整性自检，通过后继续原有流程；不增加确认步骤，也不联网获取校验值。发现不一致或校验信息缺失时，停止进入修复逻辑，并提示重新从原项目下载。

自检覆盖脚本内容，包括启动段和内嵌补丁数据；计算时仅将自检摘要字段标准化为 64 个零，避免摘要包含自身。自检摘要与下面公布的完整文件 SHA-256 用途不同，请以发布页面的完整文件值做独立比对。

**自检主要用于发现损坏和意外改动，不是数字签名，不能证明来源可信。恶意修改者可以同时改写脚本、自检代码或摘要。** 请从本项目下载；如需独立验证，使用原项目公布的校验值，不要只信转发者附带的值。

v1.2.0 发布附件 `MAKE-PCL-DOWNLOAD-AGAIN.cmd` 的完整文件 SHA-256（[校验值文件](SHA256SUMS.txt)）：

```text
845f32a6e9df2e484013e3840342f01900ee0ce083ce3312a56f3188af5a8986
```

可选：在下载目录打开 PowerShell，粘贴下面一段即可比对文件。此操作只计算摘要，不运行下载的 CMD。改过文件名时请调整路径。

```powershell
$expected = '845f32a6e9df2e484013e3840342f01900ee0ce083ce3312a56f3188af5a8986'
$actual = (Get-FileHash -LiteralPath '.\MAKE-PCL-DOWNLOAD-AGAIN.cmd' -Algorithm SHA256 -ErrorAction Stop).Hash
if ($actual -eq $expected) {
    Write-Host '校验通过：与本项目发布的 v1.2.0 CMD 一致。' -ForegroundColor Green
} else {
    throw '校验不一致，请从原项目重新下载，勿运行该文件。'
}
```

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

- 内置支持经过文件校验的 **PCL 正式版 2.99.0.0 (413)**；其他版本可通过独立适配配置接入，414 的实际补丁参数仍待验证。
- 修改前先在启动器旁保存 `.pcl-download-backup` 备份；不覆盖不匹配的备份，重复运行不会重复修改。
- 恢复 MC「自动安装」下载页的版本列表加载器，并补回整合包格式识别后的安装器分流。兼容原版及 v1.0.0 已修复的文件，重复运行会跳过。
- 已在真实 PCL 文件副本上验证修复、旧补丁升级、重复运行、备份冲突与恢复，恢复后与原文件完全一致。另将实际补丁中的识别与分流 IL 放入隔离验证程序，使用 16 个根目录/嵌套目录压缩包样例验证格式分流、成功/异常路径及资源释放，并验证损坏 ZIP 报错。安装器调用在隔离验证中使用替身；尚未完成联网下载及真实整合包的端到端安装验证。
- 工具离线运行，不读取账号信息，不改动游戏存档。仓库不分发 PCL 本体。

## 原理

该版本的整合包格式识别、拖拽入口及各格式安装器仍在，识别完格式后原本会直接抛出禁用提示。补丁保留原有识别和异常处理逻辑，按照 [PCL 上游的格式分流](https://github.com/Meloong-Git/PCL/blob/6b9a50df911c9d68b69b24c979efba477fb14b67/Plain%20Craft%20Launcher%202/Modules/Minecraft/ModModpack.vb) 重新调用对应安装器，并在退出时释放压缩包。

新增方法体复用现有元数据标记，写入 EXE 最后一个 PE 节的扩展空间，再调整方法入口和相应 PE 字段；同时应用原有的下载列表补丁。不会额外下载组件，CMD 内已包含补丁数据。处理前后均按所选配置检查完整文件 SHA-256 和原始字节；其他版本可接入独立配置，不直接套用 413 参数。

支持的原文件 SHA-256：

```text
6b6e1260cb5a1d6a303855f1c60cab3d0bc1aebba7e40a964180188b271e7386
```

这是一个独立的小工具，与 PCL 官方无关联。感谢原启动器开发者，也祝每个打开它的人，玩的开心。
