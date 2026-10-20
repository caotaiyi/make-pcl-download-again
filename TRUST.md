# 如何核对这个工具

本页介绍可独立核对的来源和检查记录。这些机制不等于 GitHub 人工审核、无病毒保证或第三方安全认证。

## 普通用户

从 [本仓库的 Release](https://github.com/caotaiyi/make-pcl-download-again/releases) 下载 CMD 即可，日常使用不需要安装任何验证工具。双击时的离线自检主要发现损坏与意外改动；恶意修改者也能改写自检逻辑，因此自检不能独立证明来源。

想进一步确认时，在原项目页面查看附件的 SHA-256，或按 README 中的命令比对。不要只相信转发者随文件提供的校验值。

## 公开自动检查

[Verify distribution 工作流](https://github.com/caotaiyi/make-pcl-download-again/actions/workflows/verify.yml) 在 Windows 上使用系统自带的 Windows PowerShell，检查：

- CMD 的 CRLF、UTF-8 格式和 PowerShell 语法。
- 完整文件 SHA-256 与独立校验值文件是否一致。
- 内置自检摘要是否匹配。
- 正常脚本能否通过自检，改动后的测试副本是否停止。
- 不支持的测试文件是否被拒绝，且不产生修改或备份。

这些检查使用临时假文件，不分发 PCL 本体，也不进行游戏联网下载。绿勾仅表示以上检查通过，不能替代真实整合包的完整安装验证。

## 发布文件的签名来源证明

[Attest release 工作流](https://github.com/caotaiyi/make-pcl-download-again/actions/workflows/attest-release.yml) 从发布标签取出 CMD 和校验值文件，检查 SHA-256，并逐字节比较已有的 Release 附件。一致后，通过 GitHub 官方的 attest action 生成签名来源证明。

这是无需编译的脚本，流程对发布文件的来源及一致性进行验证，不重新编译或分发 PCL。

打开 [仓库的 Attestations 页面](https://github.com/caotaiyi/make-pcl-download-again/attestations) 可核对文件摘要、来源仓库和工作流记录。签名证明文件与指定工作流的关联，不保证代码没有漏洞或恶意行为。

已经安装 GitHub CLI 的用户可以在下载目录中进一步验证，无需运行 CMD：

```powershell
gh attestation verify .\MAKE-PCL-DOWNLOAD-AGAIN.cmd -R caotaiyi/make-pcl-download-again
```

应确认结果对应本仓库的 `.github/workflows/attest-release.yml`，并核对目标版本的发布记录。

工作流中的官方 action 固定到完整提交 SHA，避免仅靠可移动的版本标签引用执行代码。来源证明通过短期的工作流身份签名，不在仓库中保存长期签名私钥。

## Verified 提交的含义

GitHub 显示 Verified 时，表示该次 Git 提交的签名通过验证。它不能证明作者经过身份实名审核，也不意味着 GitHub 保证代码安全。应结合具体提交、工作流记录和文件摘要判断。

## 免费声明

本项目免费提供，作者未在任何渠道售卖本工具。如通过购买获取，请联系商家退款。

## 官方说明

- [GitHub：使用制品来源证明](https://docs.github.com/en/actions/how-tos/secure-your-work/use-artifact-attestations/use-artifact-attestations)
- [GitHub 官方 attest action](https://github.com/actions/attest)
- [GitHub：提交签名验证](https://docs.github.com/en/authentication/managing-commit-signature-verification/about-commit-signature-verification)
