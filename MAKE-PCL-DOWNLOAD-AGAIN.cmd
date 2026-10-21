@echo off
chcp 65001 >nul
set "PCL_TOOL_PATH=%~1"
set "PCL_TOOL_MODE=%~2"
set "PCL_TOOL_PROFILE_FLAG=%~3"
set "PCL_TOOL_PROFILE=%~4"
set "PCL_TOOL_EXTRA=%~5"
set "PCL_TOOL_SELF=%~f0"
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; try { $s=[Text.Encoding]::UTF8.GetString([IO.File]::ReadAllBytes($env:PCL_TOOL_SELF)); $p='(?m)^(# PCL_TOOL_SHA256: )([0-9a-f]{64})(\r?)$'; $m=[regex]::Matches($s,$p); if($m.Count -ne 1){throw 'Missing or invalid script checksum.'}; $n=[regex]::Replace($s,$p,('${1}'+('0'*64)+'${3}')); $a=[Security.Cryptography.SHA256]::Create(); try{$h=([BitConverter]::ToString($a.ComputeHash([Text.Encoding]::UTF8.GetBytes($n)))).Replace('-','').ToLowerInvariant()}finally{$a.Dispose()}; if($h -ne $m[0].Groups[2].Value){throw 'Script integrity check failed. Download again from github.com/caotaiyi/make-pcl-download-again .'}; Write-Host '[OK] Script integrity self-check passed.' -ForegroundColor Green; & ([scriptblock]::Create(($s -split '(?m)^# POWERSHELL_START\r?$',2)[1])) } catch { Write-Host ('[STOP] '+$_.Exception.Message) -ForegroundColor Red; exit 1 }"
set "PCL_TOOL_EXIT=%errorlevel%"
if not defined PCL_TOOL_MODE pause
exit /b %PCL_TOOL_EXIT%
# PCL_TOOL_SHA256: bc054e9f9386f04ed585e6288e19b18404c974e4c83c22043db8edd89d2e0fed
# POWERSHELL_START
$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = New-Object Text.UTF8Encoding($false)
$ProfileName = 'PCL 正式版 2.99.0.0 (413)'
$ExpectedHash = '6b6e1260cb5a1d6a303855f1c60cab3d0bc1aebba7e40a964180188b271e7386'
$DownloadOnlyHash = 'ba7585206d97d63ad6f48cdf5fe3f79757b405990d85d1009e1ee19edf4272a9'
$PatchedHash = '9d41a4947d9b3ab09582379349fdb77ef6bfc3e2034a2951f6abcdefecd32cdd'
$OriginalLength = 5980160
$Patches = @'
[{"offset":180442,"old":"cjNHAXB++wkABCwHfvsJAAQrFn75CQAE/gZnFAAGc40FAAolgPsJAAQUGHOOBQAK","new":"fg8EAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"},{"offset":720216,"old":"ECEBAA==","new":"AGJbAA=="},{"offset":464,"old":"DAAAAA==","new":"4AUAAA=="},{"offset":472,"old":"AAIAAA==","new":"AAYAAA=="},{"offset":492,"old":"QAAAQg==","new":"YAAAYA=="},{"offset":208,"old":"AIBbAA==","new":"AIBbAA=="}]
'@ | ConvertFrom-Json
$PatchTail = [Convert]::FromBase64String('GzAFAIcDAABoAAARcjtGAHACJS0GJnJTRgBwKGQAAAoWcl1GAHAo3QAAChQLcrYDAHAMcvZGAHAovgoABgMo0QAACg0JchhHAHBv4gEACi0NCXIcRwBwb+IBAAosGHIgRwBwCSjAAAAKGBcoZAIABnPCAgAKehUTBAISBf4VNgAAAREFKF4DAAoLB3JCRwBwb18DAAosCBkTBN1HAgAAB3JgRwBwb18DAAosCBgTBN0yAgAAB3J8RwBwb18DAAosCBoTBN0dAgAAB3KkRwBwb18DAAosQAdypEcAcG9fAwAKb2ADAAooYQMACihiAwAKKDMDAAp0fAAAAXLARwBwb+8BAAotCBYTBN3YAQAAGRME3dABAAAHcs5HAHBvXwMACiwIFxME3bsBAAAHcuhHAHBvXwMACi0NB3IASABwb18DAAosCR8JEwTdmAEAAAAHb2MDAApvZAMAChMGOBMBAAARBm9lAwAKEwcRB29mAwAKcmwwAHAWKGcDAAoTCBEIFppybDAAcCjAAAAKDBEIKIEAACsYQNoAAAARCBeackJHAHAWKLAAAAotCBkTBN0zAQAAEQgXmnJgRwBwFiiwAAAKLQgYEwTdGgEAABEIF5pyfEcAcBYosAAACi0IGhME3QEBAAARCBeacqRHAHAWKLAAAAotPREHb2ADAAooYQMACihiAwAKKDMDAAp0fAAAAXLARwBwb+8BAAotCBYTBN3BAAAAGRMEch5IAHAM3bMAAAARCBeacs5HAHAWKLAAAAotCBcTBN2aAAAAEQgXmnLoRwBwFiiwAAAKLBERCBeacgBIAHAWKLAAAAotBh8JEwTechEGbygAAAo64f7//94MEQYsBxEGbycAAArc3lYlKGIAAAoTCREJFyjTAQAKcjRIAHBv4gEACiwNclZIAHARCXNoAwAKegIoaQMACnJqSABwFiiwAAAKLQ1yckgAcBEJc2gDAAp6csJIAHARCXNoAwAKehEEHwA7MgAAABEEHwE7OQAAABEEHwI7PgAAABEEHwM7QwAAABEEHwQ7SQAAABEEHwk7UAAAADhZAAAAAgcIAwQo9AEABgrdYAAAAAIHCCj2AQAGCt1SAAAAAgcIKPcBAAYK3UQAAAACBwgDKPgBAAYK3TUAAAACBwgDBCj1AQAGCt0lAAAAAgcIKPkBAAYK3RcAAAACByj6AQAGCt0KAAAABywGB29qAwAK3AYqAEFMAAACAAAAQwEAADMBAAB2AgAADAAAAAAAAAAAAAAAbQAAABcCAACEAgAAVgAAADMAAAECAAAAJwAAAFQDAAB7AwAACgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==')
function Get-Hash([byte[]] $Bytes) {
    $Hasher = [Security.Cryptography.SHA256]::Create()
    try { return ([BitConverter]::ToString($Hasher.ComputeHash($Bytes))).Replace('-','').ToLowerInvariant() }
    finally { $Hasher.Dispose() }
}
function Import-PatchProfile([string] $Path) {
    $Info = Get-Item -LiteralPath $Path
    if ($Info.PSIsContainer -or $Info.Length -gt 2097152) { throw '补丁配置必须是小于 2 MB 的 JSON 文件。' }
    $Profile = [IO.File]::ReadAllText($Info.FullName, [Text.Encoding]::UTF8) | ConvertFrom-Json
    if ($Profile.schemaVersion -ne 1) { throw '不支持的补丁配置格式。' }
    if ($Profile.name -isnot [string] -or $Profile.name.Length -lt 1 -or $Profile.name.Length -gt 128 -or $Profile.name -match '[\x00-\x1f]') { throw '配置名称无效。' }
    foreach ($Field in @('originalHash', 'patchedHash')) {
        if ($Profile.$Field -isnot [string] -or $Profile.$Field -cnotmatch '^[0-9a-f]{64}$') { throw "配置字段 $Field 必须是完整的小写 SHA-256。" }
    }
    if ($Profile.originalHash -eq $Profile.patchedHash) { throw '原版和修复后的摘要不能相同。' }
    $Length = 0
    if (-not [int]::TryParse([string]$Profile.originalLength, [ref]$Length) -or $Length -lt 1 -or $Length -gt 67108864) { throw '配置中的原始文件长度无效。' }
    if ($Profile.downloadOnlyHash -and ([string]$Profile.downloadOnlyHash -cnotmatch '^[0-9a-f]{64}$')) { throw '旧补丁摘要格式无效。' }
    $Items = @($Profile.patches)
    if ($Items.Count -lt 1 -or $Items.Count -gt 256) { throw '配置需要 1 至 256 处修改。' }
    $Ranges = @()
    foreach ($Patch in $Items) {
        $Offset = 0
        if (-not [int]::TryParse([string]$Patch.offset, [ref]$Offset) -or $Offset -lt 0) { throw '修改位置无效。' }
        if ($Patch.old -isnot [string] -or $Patch.new -isnot [string]) { throw '补丁字节必须是 Base64 字符串。' }
        $Old = [Convert]::FromBase64String($Patch.old)
        $New = [Convert]::FromBase64String($Patch.new)
        if ($Old.Length -lt 1 -or $Old.Length -ne $New.Length -or ([long]$Offset + $Old.Length) -gt $Length) { throw '补丁长度或修改范围无效。' }
        foreach ($Range in $Ranges) {
            if ($Offset -lt $Range.end -and ($Offset + $Old.Length) -gt $Range.start) { throw '补丁修改范围不能重叠。' }
        }
        $Ranges += @{ start=$Offset; end=($Offset + $Old.Length) }
    }
    $Tail = [byte[]]@()
    if ($Profile.tail) { $Tail = [Convert]::FromBase64String([string]$Profile.tail) }
    if (($Length + $Tail.Length) -gt 67108864) { throw '修复后的文件不能超过 64 MB。' }
    Set-Variable -Scope 1 -Name ProfileName -Value ($Profile.name)
    Set-Variable -Scope 1 -Name ExpectedHash -Value ($Profile.originalHash)
    Set-Variable -Scope 1 -Name PatchedHash -Value ($Profile.patchedHash)
    Set-Variable -Scope 1 -Name DownloadOnlyHash -Value ($Profile.downloadOnlyHash)
    Set-Variable -Scope 1 -Name OriginalLength -Value ($Length)
    Set-Variable -Scope 1 -Name Patches -Value ($Items)
    Set-Variable -Scope 1 -Name PatchTail -Value ($Tail)
    Write-Host ('已加载自定义补丁配置：' + $ProfileName) -ForegroundColor Yellow
    Write-Host '配置决定 EXE 的修改内容，请只使用你信任的适配者提供的配置。'
}
function Get-State([byte[]] $Bytes) {
    $Hash = Get-Hash $Bytes
    if ($Hash -eq $ExpectedHash) { return 'original' }
    if ($Hash -eq $DownloadOnlyHash) { return 'download-only' }
    if ($Hash -eq $PatchedHash) { return 'patched' }
    throw ('文件与当前配置不匹配，未修改。当前配置：' + $ProfileName + '。其他版本可通过 --profile 加载独立适配配置。')
}
function Get-Original([byte[]] $Bytes) {
    $State = Get-State $Bytes
    $Original = New-Object byte[] $OriginalLength
    [Array]::Copy($Bytes, 0, $Original, 0, $OriginalLength)
    foreach ($Patch in $Patches) {
        $Old = [Convert]::FromBase64String($Patch.old)
        [Array]::Copy($Old, 0, $Original, [int]$Patch.offset, $Old.Length)
    }
    if ((Get-Hash $Original) -ne $ExpectedHash) { throw '原版还原校验失败，未修改。' }
    return ,$Original
}
function Get-Patched([byte[]] $Original) {
    $Patched = New-Object byte[] ($OriginalLength + $PatchTail.Length)
    [Array]::Copy($Original, 0, $Patched, 0, $OriginalLength)
    foreach ($Patch in $Patches) {
        $Old = [Convert]::FromBase64String($Patch.old)
        for ($i = 0; $i -lt $Old.Length; $i++) { if ($Original[[int]$Patch.offset + $i] -ne $Old[$i]) { throw '配置中的原始字节与文件不一致，未修改。' } }
        $New = [Convert]::FromBase64String($Patch.new)
        [Array]::Copy($New, 0, $Patched, [int]$Patch.offset, $New.Length)
    }
    [Array]::Copy($PatchTail, 0, $Patched, $OriginalLength, $PatchTail.Length)
    if ((Get-Hash $Patched) -ne $PatchedHash) { throw '补丁校验失败，未修改。' }
    return ,$Patched
}
function Read-Program([string] $Path) {
    $Info = Get-Item -LiteralPath $Path
    if ($Info.PSIsContainer -or $Info.Length -gt 67108864) { throw '请选择小于 64 MB 的 PCL 程序文件。' }
    return ,([IO.File]::ReadAllBytes($Info.FullName))
}
function Find-Pcl([string[]] $Roots) {
    $Found = @{}
    $Visited = @{}
    $Queue = New-Object 'Collections.Generic.Queue[object]'
    foreach ($Root in $Roots) { if ($Root -and (Test-Path -LiteralPath $Root -PathType Container)) { $Queue.Enqueue(@($Root, 0)) } }
    $Count = 0
    $Timer = [Diagnostics.Stopwatch]::StartNew()
    while ($Queue.Count -gt 0 -and $Count -lt 15000 -and $Timer.Elapsed.TotalSeconds -lt 6) {
        $Node = $Queue.Dequeue(); $Dir = [string]$Node[0]; $Depth = [int]$Node[1]
        if ($Visited.ContainsKey($Dir)) { continue }; $Visited[$Dir] = $true
        foreach ($Item in @(Get-ChildItem -LiteralPath $Dir -Force -ErrorAction SilentlyContinue)) {
            $Count++
            if ($Count -gt 15000 -or $Timer.Elapsed.TotalSeconds -gt 6) { break }
            if ($Item.PSIsContainer) {
                if ($Depth -lt 3 -and -not ($Item.Attributes -band [IO.FileAttributes]::ReparsePoint) -and $Item.Name -notin @('Windows','node_modules','.git','$RECYCLE.BIN','System Volume Information')) { $Queue.Enqueue(@($Item.FullName, $Depth + 1)) }
            } elseif ($Item.Extension -eq '.exe' -and $Item.Name -match '(?i)pcl|plain craft launcher') {
                $Found[$Item.FullName] = $Item.FullName
            }
        }
    }
    return @($Found.Values | Sort-Object)
}
function Write-Atomic([string] $Path, [byte[]] $Before, [byte[]] $After) {
    $Temporary = Join-Path ([IO.Path]::GetDirectoryName($Path)) ('.pcl-' + [Guid]::NewGuid().ToString('N') + '.tmp')
    try {
        $Stream = New-Object IO.FileStream($Temporary, [IO.FileMode]::CreateNew, [IO.FileAccess]::Write, [IO.FileShare]::None)
        try { $Stream.Write($After,0,$After.Length); $Stream.Flush($true) } finally { $Stream.Dispose() }
        if ((Get-Hash ([IO.File]::ReadAllBytes($Path))) -ne (Get-Hash $Before)) { throw '操作期间文件发生变化，已停止。' }
        [IO.File]::Replace($Temporary, $Path, [System.Management.Automation.Language.NullString]::Value)
        if ((Get-Hash ([IO.File]::ReadAllBytes($Path))) -ne (Get-Hash $After)) { throw '写入校验失败，请使用备份恢复。' }
    } finally { if ([IO.File]::Exists($Temporary)) { [IO.File]::Delete($Temporary) } }
}
try {
    Write-Host @'
+----------------------------------------------------------------------------+
|                                                                            |
|                  |\/|  /\  | /  |===      |==\  /== |                      |
|                  |  | /  \ |/   |         |  | |    |                      |
|                  |  | |--| |<   |==       |==/ |    |                      |
|                  |  | |  | |\   |         |    |    |                      |
|                  |  | |  | | \  |===      |     \== |___                   |
|                                                                            |
| |==\  /\  |  | |\ | |     /\   /\  |==\       /\   /==  /\  ==== |\ |  ||  |
| |  | |  | |  | |\ | |    |  | /  \ |  |      /  \ |    /  \  ||  |\ |  ||  |
| |  | |  | |  | | \| |    |  | |--| |  |      |--| | == |--|  ||  | \|  ||  |
| |  | |  | |/\| | \| |    |  | |  | |  |      |  | |  | |  |  ||  | \|      |
| |==/  \/  V  V |  | |___  \/  |  | |==/      |  |  \_/ |  | ==== |  |  ..  |
|                                                                            |
|                          MAKE PCL DOWNLOAD AGAIN!                          |
|                                                                            |
+----------------------------------------------------------------------------+
'@ -ForegroundColor Cyan
    Write-Host 'PCL 下载与整合包拖入安装修复工具 | v1.2.0 | 免安装 Windows 版'
    Write-Host '本工具免费提供，作者未在任何渠道售卖。如购买获取，请联系商家退款。'
    $Target = $env:PCL_TOOL_PATH
    $Mode = [string]$env:PCL_TOOL_MODE
    if ($Mode -notin @('', '--check', '--restore', '--yes')) { throw '用法：修复PCL下载.cmd "PCL.exe完整路径" [--check|--restore|--yes]' }
    if ($env:PCL_TOOL_EXTRA) { throw '参数过多。' }
    if ($env:PCL_TOOL_PROFILE_FLAG -or $env:PCL_TOOL_PROFILE) {
        if ($env:PCL_TOOL_PROFILE_FLAG -ne '--profile' -or -not $env:PCL_TOOL_PROFILE) { throw '自定义配置用法：工具.cmd "PCL.exe路径" --check|--yes|--restore --profile "配置.json路径"' }
        Import-PatchProfile $env:PCL_TOOL_PROFILE
    }
    if (-not $Target -or (Test-Path -LiteralPath $Target -PathType Container)) {
        if ($Target) { $Roots = @($Target) } else {
            $Roots = @((Get-Location).Path, (Split-Path -LiteralPath $env:PCL_TOOL_SELF), ([Environment]::GetFolderPath('Desktop')), (Join-Path $env:USERPROFILE 'Downloads'), ([Environment]::GetFolderPath('MyDocuments')))
            $Roots += @(Get-PSDrive -PSProvider FileSystem | Select-Object -ExpandProperty Root)
        }
        Write-Host '正在快速查找 PCL（最多约 6 秒）……'
        $Candidates = @(Find-Pcl $Roots)
        if ($Candidates.Count -eq 1) { $Target = $Candidates[0] }
        elseif ($Candidates.Count -gt 1) {
            for ($i = 0; $i -lt $Candidates.Count; $i++) { Write-Host ('{0}. {1}' -f ($i + 1), $Candidates[$i]) }
            $Choice = Read-Host '找到多个文件，请输入编号（回车取消）'
            $Number = 0
            if (-not [int]::TryParse($Choice, [ref]$Number) -or $Number -lt 1 -or $Number -gt $Candidates.Count) { throw '已取消。' }
            $Target = $Candidates[$Number - 1]
        } else { $Target = (Read-Host '未自动找到，请粘贴 PCL.exe 完整路径').Trim().Trim('"') }
    }
    if (-not $Target) { throw '已取消。' }
    $Target = (Resolve-Path -LiteralPath $Target).ProviderPath
    Write-Host "目标：$Target"
    $Data = Read-Program $Target
    $State = Get-State $Data
    $Backup = $Target + '.pcl-download-backup'
    if ($Mode -eq '--check') {
        $CheckOriginal = Get-Original $Data
        $CheckPatched = Get-Patched $CheckOriginal
        Write-Host "检查通过：$State，文件及补丁计划匹配配置 $ProfileName。"
        exit 0
    }
    if ($Mode -eq '--restore') {
        if ($State -eq 'original') { Write-Host '已经是原版，无需恢复。'; exit 0 }
        $Output = Read-Program $Backup
        if ((Get-Hash $Output) -ne $ExpectedHash) { throw '备份校验失败，未恢复。' }
        if ((Read-Host '从备份恢复原版？[y/N]') -notmatch '^(?i)y(es)?$') { Write-Host '已取消。'; exit 0 }
        Write-Atomic $Target $Data $Output
        Write-Host '已恢复原版，备份保留。'
    } else {
        if ($State -eq 'patched') { Write-Host '游戏下载和整合包拖入安装均已修复，无需重复操作。'; exit 0 }
        if ($Mode -ne '--yes' -and (Read-Host '请先关闭 PCL。备份并恢复游戏下载及整合包拖入安装？[y/N]') -notmatch '^(?i)y(es)?$') { Write-Host '已取消。'; exit 0 }
        $Original = Get-Original $Data
        if ([IO.File]::Exists($Backup)) { if ((Get-Hash (Read-Program $Backup)) -ne $ExpectedHash) { throw '已有备份与原版不符，未修改。请先妥善保留该备份。' } }
        else {
            $Stream = New-Object IO.FileStream($Backup, [IO.FileMode]::CreateNew, [IO.FileAccess]::Write, [IO.FileShare]::None)
            try { $Stream.Write($Original,0,$Original.Length); $Stream.Flush($true) } finally { $Stream.Dispose() }
        }
        if ((Get-Hash (Read-Program $Backup)) -ne $ExpectedHash) { throw '备份校验失败，未修改。' }
        $Output = Get-Patched $Original
        if ((Get-State $Output) -ne 'patched') { throw '补丁校验失败。' }
        Write-Atomic $Target $Data $Output
        Write-Host '玩的开心' -ForegroundColor Green
        Write-Host "原版备份：$Backup"
    }
    exit 0
} catch { Write-Host ('未完成：' + $_.Exception.Message) -ForegroundColor Red; exit 1 }
