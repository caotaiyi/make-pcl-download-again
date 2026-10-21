$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $PSScriptRoot
$Path = Join-Path $Root 'MAKE-PCL-DOWNLOAD-AGAIN.cmd'
$Source = [IO.File]::ReadAllText((Join-Path $Root 'src/AutoAdapter.cs')).Replace("`r`n", "`n").TrimEnd()
$Cmd = [IO.File]::ReadAllText($Path).Replace("`r`n", "`n")
$Pattern = '(?s)(\$AutoAdapterSource = @''\n).*?(\n''@)'
if ([regex]::Matches($Cmd, $Pattern).Count -ne 1) { throw 'Expected one embedded adapter.' }
$Cmd = [regex]::Replace($Cmd, $Pattern, [Text.RegularExpressions.MatchEvaluator]{ param($m) $m.Groups[1].Value + $Source + $m.Groups[2].Value })
$HashPattern = '(?m)^(# PCL_TOOL_SHA256: )[0-9a-f]{64}$'
if ([regex]::Matches($Cmd, $HashPattern).Count -ne 1) { throw 'Expected one self-check digest.' }
$Cmd = [regex]::Replace($Cmd, $HashPattern, ('${1}' + ('0' * 64))).Replace("`n", "`r`n")
$Sha = [Security.Cryptography.SHA256]::Create()
try {
    $Digest = ([BitConverter]::ToString($Sha.ComputeHash([Text.Encoding]::UTF8.GetBytes($Cmd)))).Replace('-','').ToLowerInvariant()
    $Cmd = $Cmd.Replace(('# PCL_TOOL_SHA256: ' + ('0' * 64)), ('# PCL_TOOL_SHA256: ' + $Digest))
    $Bytes = [Text.Encoding]::UTF8.GetBytes($Cmd)
    $FullHash = ([BitConverter]::ToString($Sha.ComputeHash($Bytes))).Replace('-','').ToLowerInvariant()
} finally { $Sha.Dispose() }
[IO.File]::WriteAllBytes($Path, $Bytes)
[IO.File]::WriteAllText((Join-Path $Root 'SHA256SUMS.txt'), ($FullHash + "  MAKE-PCL-DOWNLOAD-AGAIN.cmd`n"), (New-Object Text.UTF8Encoding($false)))
Write-Host $FullHash
