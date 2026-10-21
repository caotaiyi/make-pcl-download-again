@echo off
chcp 65001 >nul
set "PCL_TOOL_PATH=%~1"
set "PCL_TOOL_MODE=%~2"
set "PCL_TOOL_SELF=%~f0"
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; try { $s=[Text.Encoding]::UTF8.GetString([IO.File]::ReadAllBytes($env:PCL_TOOL_SELF)); $p='(?m)^(# PCL_TOOL_SHA256: )([0-9a-f]{64})(\r?)$'; $m=[regex]::Matches($s,$p); if($m.Count -ne 1){throw 'Missing or invalid script checksum.'}; $n=[regex]::Replace($s,$p,('${1}'+('0'*64)+'${3}')); $a=[Security.Cryptography.SHA256]::Create(); try{$h=([BitConverter]::ToString($a.ComputeHash([Text.Encoding]::UTF8.GetBytes($n)))).Replace('-','').ToLowerInvariant()}finally{$a.Dispose()}; if($h -ne $m[0].Groups[2].Value){throw 'Script integrity check failed. Download again from github.com/caotaiyi/make-pcl-download-again .'}; Write-Host '[OK] Script integrity self-check passed.' -ForegroundColor Green; & ([scriptblock]::Create(($s -split '(?m)^# POWERSHELL_START\r?$',2)[1])) } catch { Write-Host ('[STOP] '+$_.Exception.Message) -ForegroundColor Red; exit 1 }"
set "PCL_TOOL_EXIT=%errorlevel%"
if not defined PCL_TOOL_MODE pause
exit /b %PCL_TOOL_EXIT%
# PCL_TOOL_SHA256: 134ece4be0a41e91ac8590c11413ec63bfd542c1aba0aa343dc1ba644a1cab50
# POWERSHELL_START
$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = New-Object Text.UTF8Encoding($false)
$ExpectedHash = '6b6e1260cb5a1d6a303855f1c60cab3d0bc1aebba7e40a964180188b271e7386'
$DownloadOnlyHash = 'ba7585206d97d63ad6f48cdf5fe3f79757b405990d85d1009e1ee19edf4272a9'
$PatchedHash = '9d41a4947d9b3ab09582379349fdb77ef6bfc3e2034a2951f6abcdefecd32cdd'
$OriginalLength = 5980160
$Patches = @'
[{"offset":180442,"old":"cjNHAXB++wkABCwHfvsJAAQrFn75CQAE/gZnFAAGc40FAAolgPsJAAQUGHOOBQAK","new":"fg8EAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"},{"offset":720216,"old":"ECEBAA==","new":"AGJbAA=="},{"offset":464,"old":"DAAAAA==","new":"4AUAAA=="},{"offset":472,"old":"AAIAAA==","new":"AAYAAA=="},{"offset":492,"old":"QAAAQg==","new":"YAAAYA=="},{"offset":208,"old":"AIBbAA==","new":"AIBbAA=="}]
'@ | ConvertFrom-Json
$PatchTail = [Convert]::FromBase64String('GzAFAIcDAABoAAARcjtGAHACJS0GJnJTRgBwKGQAAAoWcl1GAHAo3QAAChQLcrYDAHAMcvZGAHAovgoABgMo0QAACg0JchhHAHBv4gEACi0NCXIcRwBwb+IBAAosGHIgRwBwCSjAAAAKGBcoZAIABnPCAgAKehUTBAISBf4VNgAAAREFKF4DAAoLB3JCRwBwb18DAAosCBkTBN1HAgAAB3JgRwBwb18DAAosCBgTBN0yAgAAB3J8RwBwb18DAAosCBoTBN0dAgAAB3KkRwBwb18DAAosQAdypEcAcG9fAwAKb2ADAAooYQMACihiAwAKKDMDAAp0fAAAAXLARwBwb+8BAAotCBYTBN3YAQAAGRME3dABAAAHcs5HAHBvXwMACiwIFxME3bsBAAAHcuhHAHBvXwMACi0NB3IASABwb18DAAosCR8JEwTdmAEAAAAHb2MDAApvZAMAChMGOBMBAAARBm9lAwAKEwcRB29mAwAKcmwwAHAWKGcDAAoTCBEIFppybDAAcCjAAAAKDBEIKIEAACsYQNoAAAARCBeackJHAHAWKLAAAAotCBkTBN0zAQAAEQgXmnJgRwBwFiiwAAAKLQgYEwTdGgEAABEIF5pyfEcAcBYosAAACi0IGhME3QEBAAARCBeacqRHAHAWKLAAAAotPREHb2ADAAooYQMACihiAwAKKDMDAAp0fAAAAXLARwBwb+8BAAotCBYTBN3BAAAAGRMEch5IAHAM3bMAAAARCBeacs5HAHAWKLAAAAotCBcTBN2aAAAAEQgXmnLoRwBwFiiwAAAKLBERCBeacgBIAHAWKLAAAAotBh8JEwTechEGbygAAAo64f7//94MEQYsBxEGbycAAArc3lYlKGIAAAoTCREJFyjTAQAKcjRIAHBv4gEACiwNclZIAHARCXNoAwAKegIoaQMACnJqSABwFiiwAAAKLQ1yckgAcBEJc2gDAAp6csJIAHARCXNoAwAKehEEHwA7MgAAABEEHwE7OQAAABEEHwI7PgAAABEEHwM7QwAAABEEHwQ7SQAAABEEHwk7UAAAADhZAAAAAgcIAwQo9AEABgrdYAAAAAIHCCj2AQAGCt1SAAAAAgcIKPcBAAYK3UQAAAACBwgDKPgBAAYK3TUAAAACBwgDBCj1AQAGCt0lAAAAAgcIKPkBAAYK3RcAAAACByj6AQAGCt0KAAAABywGB29qAwAK3AYqAEFMAAACAAAAQwEAADMBAAB2AgAADAAAAAAAAAAAAAAAbQAAABcCAACEAgAAVgAAADMAAAECAAAAJwAAAFQDAAB7AwAACgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==')
$Profiles = @(
    [pscustomobject]@{
        Label          = '2.99.0.0 (413)'
        OriginalHash   = $ExpectedHash
        DownloadOnlyHash = $DownloadOnlyHash
        PatchedHash    = $PatchedHash
        OriginalLength = $OriginalLength
        Patches        = $Patches
    },
    [pscustomobject]@{
        Label          = '2.99.0.0 (414)'
        OriginalHash   = '5b64d6d540c376390470cea3ab99d47661e8bca81be2ba647ea83e7d2e9428fa'
        DownloadOnlyHash = $null
        PatchedHash    = '3fda153bf7150e72259b2c59a3d68cb8442f1be2a2a29b48681b1d7de538eeea'
        OriginalLength = 5985280
        Patches        = @'
[{"offset":464,"old":"DAA=","new":"AAY="},{"offset":473,"old":"Ag==","new":"Bg=="},{"offset":492,"old":"QA==","new":"YA=="},{"offset":495,"old":"Qg==","new":"Yg=="},{"offset":182174,"old":"copJAXB+/Qk=","new":"fg8EAAQAAAA="},{"offset":182183,"old":"BCwHfv0J","new":"AAAAAAAA"},{"offset":182190,"old":"BCsWfvsJ","new":"AAAAAAAA"},{"offset":182197,"old":"BP4GZxQ=","new":"AAAAAAA="},{"offset":182203,"old":"BnOOBQ==","new":"AAAAAA=="},{"offset":182208,"old":"CiWA/Qk=","new":"AAAAAAA="},{"offset":182214,"old":"BBQYc48F","new":"AAAAAAAA"},{"offset":182221,"old":"Cg==","new":"AA=="},{"offset":723212,"old":"ECEB","new":"AIJb"}]
'@ | ConvertFrom-Json
    }
)

function Get-Hash([byte[]] $Bytes) {
    $Hasher = [Security.Cryptography.SHA256]::Create()
    try { return ([BitConverter]::ToString($Hasher.ComputeHash($Bytes))).Replace('-','').ToLowerInvariant() }
    finally { $Hasher.Dispose() }
}
function Get-State([byte[]] $Bytes) {
    $Hash = Get-Hash $Bytes
    $script:Profile = $null
    foreach ($Candidate in $Profiles) {
        if ($Hash -eq $Candidate.OriginalHash) { $script:Profile = $Candidate; return 'original' }
        if ($Candidate.PatchedHash -and $Hash -eq $Candidate.PatchedHash) { $script:Profile = $Candidate; return 'patched' }
    }
    if ($DownloadOnlyHash -and $Hash -eq $DownloadOnlyHash) { $script:Profile = $Profiles[0]; return 'download-only' }
    throw '文件版本或完整性不匹配，未修改。仅支持已验证的正式版 2.99.0.0 (413)/(414) 及本工具修复过的文件。'
}
function Get-Original([byte[]] $Bytes) {
    $State = Get-State $Bytes
    $Original = New-Object byte[] $Profile.OriginalLength
    [Array]::Copy($Bytes, 0, $Original, 0, $Profile.OriginalLength)
    foreach ($Patch in $Profile.Patches) {
        $Old = [Convert]::FromBase64String($Patch.old)
        [Array]::Copy($Old, 0, $Original, [int]$Patch.offset, $Old.Length)
    }
    if ((Get-Hash $Original) -ne $Profile.OriginalHash) { throw '原版还原校验失败，未修改。' }
    return ,$Original
}
function Get-Patched([byte[]] $Original) {
    $Patched = New-Object byte[] ($Profile.OriginalLength + $PatchTail.Length)
    [Array]::Copy($Original, 0, $Patched, 0, $Profile.OriginalLength)
    foreach ($Patch in $Profile.Patches) {
        $New = [Convert]::FromBase64String($Patch.new)
        [Array]::Copy($New, 0, $Patched, [int]$Patch.offset, $New.Length)
    }
    [Array]::Copy($PatchTail, 0, $Patched, $Profile.OriginalLength, $PatchTail.Length)
    if ((Get-Hash $Patched) -ne $Profile.PatchedHash) { throw '补丁校验失败，未修改。' }
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
    if ($Mode -eq '--check') { Write-Host "检查通过：$State，文件受支持。"; exit 0 }
    if ($Mode -eq '--restore') {
        if ($State -eq 'original') { Write-Host '已经是原版，无需恢复。'; exit 0 }
        $Output = Read-Program $Backup
        if ((Get-Hash $Output) -ne $Profile.OriginalHash) { throw '备份校验失败，未恢复。' }
        if ((Read-Host '从备份恢复原版？[y/N]') -notmatch '^(?i)y(es)?$') { Write-Host '已取消。'; exit 0 }
        Write-Atomic $Target $Data $Output
        Write-Host '已恢复原版，备份保留。'
    } else {
        if ($State -eq 'patched') { Write-Host '游戏下载和整合包拖入安装均已修复，无需重复操作。'; exit 0 }
        if ($Mode -ne '--yes' -and (Read-Host '请先关闭 PCL。备份并恢复游戏下载及整合包拖入安装？[y/N]') -notmatch '^(?i)y(es)?$') { Write-Host '已取消。'; exit 0 }
        $Original = Get-Original $Data
        if ([IO.File]::Exists($Backup)) { if ((Get-Hash (Read-Program $Backup)) -ne $Profile.OriginalHash) { throw '已有备份与原版不符，未修改。请先妥善保留该备份。' } }
        else {
            $Stream = New-Object IO.FileStream($Backup, [IO.FileMode]::CreateNew, [IO.FileAccess]::Write, [IO.FileShare]::None)
            try { $Stream.Write($Original,0,$Original.Length); $Stream.Flush($true) } finally { $Stream.Dispose() }
        }
        if ((Get-Hash (Read-Program $Backup)) -ne $Profile.OriginalHash) { throw '备份校验失败，未修改。' }
        $Output = Get-Patched $Original
        if ((Get-State $Output) -ne 'patched') { throw '补丁校验失败。' }
        Write-Atomic $Target $Data $Output
        Write-Host '玩的开心' -ForegroundColor Green
        Write-Host "原版备份：$Backup"
    }
    exit 0
} catch { Write-Host ('未完成：' + $_.Exception.Message) -ForegroundColor Red; exit 1 }
