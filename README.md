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
4. 输入 `y` 确认。看到「玩的开心」后，重新打开 PCL，进入「下载 → 自动安装」。

CMD 调用 Windows 自带的 PowerShell，不需要安装额外软件。自动查找最多深入 3 层、检查 15,000 个目录项，约 6 秒后停止继续查找；慢盘的单次读取可能更久。直接拖入文件可以省去查找。

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
- 恢复 MC「自动安装」下载页的版本列表加载器，修改范围为一处方法中的 48 字节。此版本已删除的整合包安装逻辑不在恢复范围内。
- Windows 已在真实 PCL 副本上验证修复、重复运行与恢复，恢复后与原文件完全一致；尚未验证完整游戏下载。
- 工具离线运行，不读取账号信息，不改动游戏存档。仓库不分发 PCL 本体。

支持的原文件 SHA-256：

```text
6b6e1260cb5a1d6a303855f1c60cab3d0bc1aebba7e40a964180188b271e7386
```

这是一个独立的小工具，与 PCL 官方无关联。感谢原启动器开发者，也祝每个打开它的人，玩的开心。
