param([string] $ArtifactRoot = (Split-Path -Parent $PSScriptRoot))
$ErrorActionPreference = 'Stop'
$ScriptPath = Join-Path $ArtifactRoot 'MAKE-PCL-DOWNLOAD-AGAIN.cmd'
$ChecksumPath = Join-Path $ArtifactRoot 'SHA256SUMS.txt'
$Bytes = [IO.File]::ReadAllBytes($ScriptPath)
$Source = [Text.Encoding]::UTF8.GetString($Bytes)
$AdapterFile = Join-Path $ArtifactRoot 'src/AutoAdapter.cs'
if ([IO.File]::Exists($AdapterFile)) {
    $Embedded = [regex]::Match($Source, '(?s)\$AutoAdapterSource = @''\r?\n(.*?)\r?\n''@')
    $AdapterText = [IO.File]::ReadAllText($AdapterFile).Replace("`r`n", "`n").TrimEnd()
    if (-not $Embedded.Success -or $Embedded.Groups[1].Value.Replace("`r`n", "`n").TrimEnd() -ne $AdapterText) { throw 'Embedded automatic adapter differs from public source.' }
}
if ($Bytes.Length -ge 3 -and $Bytes[0] -eq 239 -and $Bytes[1] -eq 187 -and $Bytes[2] -eq 191) { throw 'CMD must not have a UTF-8 BOM.' }
if ($Source -match '(?<!\r)\n') { throw 'CMD must use CRLF line endings.' }
$Checksum = [IO.File]::ReadAllText($ChecksumPath).Trim()
if ($Checksum -notmatch '^([0-9a-f]{64})  MAKE-PCL-DOWNLOAD-AGAIN\.cmd$') { throw 'Unexpected checksum manifest format.' }
$ExpectedHash = $Matches[1]
$ActualHash = (Get-FileHash -LiteralPath $ScriptPath -Algorithm SHA256).Hash.ToLowerInvariant()
if ($ActualHash -ne $ExpectedHash) { throw 'Whole-file SHA-256 does not match SHA256SUMS.txt.' }

$Pattern = '(?m)^(# PCL_TOOL_SHA256: )([0-9a-f]{64})(\r?)$'
$Digests = [regex]::Matches($Source, $Pattern)
if ($Digests.Count -ne 1) { throw 'Expected exactly one self-check digest field.' }
$Normalized = [regex]::Replace($Source, $Pattern, ('${1}' + ('0' * 64) + '${3}'))
$Hasher = [Security.Cryptography.SHA256]::Create()
try { $NormalizedHash = ([BitConverter]::ToString($Hasher.ComputeHash([Text.Encoding]::UTF8.GetBytes($Normalized)))).Replace('-','').ToLowerInvariant() }
finally { $Hasher.Dispose() }
if ($NormalizedHash -ne $Digests[0].Groups[2].Value) { throw 'Embedded self-check digest does not match.' }

$Parts = $Source -split '(?m)^# POWERSHELL_START\r?$', 2
if ($Parts.Count -ne 2) { throw 'Missing embedded PowerShell section.' }
$Tokens = $null; $Errors = $null
[void][Management.Automation.Language.Parser]::ParseInput($Parts[1], [ref]$Tokens, [ref]$Errors)
if ($Errors.Count -gt 0) { throw ($Errors | Out-String) }
$BootstrapLine = ($Source -split '\r\n' | Where-Object { $_.StartsWith('powershell.exe ') })
if (@($BootstrapLine).Count -ne 1 -or $BootstrapLine -notmatch ' -Command "(.*)"$') { throw 'Unexpected bootstrap format.' }
[void][Management.Automation.Language.Parser]::ParseInput($Matches[1], [ref]$Tokens, [ref]$Errors)
if ($Errors.Count -gt 0) { throw ($Errors | Out-String) }
Write-Host 'PASS: CRLF, UTF-8, published digest, embedded digest and PowerShell syntax.'

# Only disposable dummy files are used. No PCL executable, accounts or saves
# are needed by CI, and no actual patch installation is performed.
$Temporary = Join-Path ([IO.Path]::GetTempPath()) ('pcl-distribution-check-' + [Guid]::NewGuid().ToString('N'))
[void][IO.Directory]::CreateDirectory($Temporary)
try {
    $Target = Join-Path $Temporary 'unsupported-PCL.exe'
    [IO.File]::WriteAllText($Target, 'deliberately unsupported test fixture')
    $TargetHash = (Get-FileHash -LiteralPath $Target).Hash
    $Probe = Join-Path $Temporary 'probe.cmd'
    function Invoke-Probe([byte[]] $Data, [bool] $ShouldPassSelfCheck, [string] $ProfilePath = '', [int] $ExpectedExit = 1) {
        [IO.File]::WriteAllBytes($Probe, $Data)
        $Start = New-Object Diagnostics.ProcessStartInfo
        $Start.FileName = $env:ComSpec
        $ProfileArgument = ''
        if ($ProfilePath) { $ProfileArgument = ' --profile "' + $ProfilePath + '"' }
        $Start.Arguments = '/d /s /c ""{0}" "{1}" --check{2}"' -f $Probe, $Target, $ProfileArgument
        $Start.UseShellExecute = $false
        $Start.CreateNoWindow = $true
        $Start.RedirectStandardOutput = $true
        $Start.RedirectStandardError = $true
        $Start.StandardOutputEncoding = [Text.Encoding]::UTF8
        $Start.StandardErrorEncoding = [Text.Encoding]::UTF8
        $Process = [Diagnostics.Process]::Start($Start)
        try {
            $Stdout = $Process.StandardOutput.ReadToEndAsync()
            $Stderr = $Process.StandardError.ReadToEndAsync()
            if (-not $Process.WaitForExit(30000)) { $Process.Kill(); throw 'Probe timed out.' }
            $Result = $Stdout.GetAwaiter().GetResult() + $Stderr.GetAwaiter().GetResult()
            if ($Process.ExitCode -ne $ExpectedExit) { throw "Unexpected probe exit code: $Result" }
        } finally { $Process.Dispose() }
        if ($ShouldPassSelfCheck) {
            if ($Result -notmatch '(?m)^\[OK\] Script integrity self-check passed\.') { throw "Normal self-check failed: $Result" }
        } else {
            if ($Result -notmatch '(?m)^\[STOP\]' -or $Result -match '(?m)^\[OK\]') { throw "Changed script was not stopped: $Result" }
        }
        if ((Get-FileHash -LiteralPath $Target).Hash -ne $TargetHash -or [IO.File]::Exists($Target + '.pcl-download-backup')) { throw 'Dummy file or backup unexpectedly changed.' }
    }
    Invoke-Probe $Bytes $true
    Invoke-Probe ([Text.Encoding]::UTF8.GetBytes($Source + "`r`n# unexpected appended content`r`n")) $false
    $Changed = $Source.Replace('$OriginalLength = 5980160', '$OriginalLength = 5980161')
    if ($Changed -eq $Source) { throw 'Body-change fixture did not change the input.' }
    Invoke-Probe ([Text.Encoding]::UTF8.GetBytes($Changed)) $false
    Invoke-Probe ([Text.Encoding]::UTF8.GetBytes($Source.Replace('# PCL_TOOL_SHA256: ', '# REMOVED_DIGEST: '))) $false
    Write-Host 'PASS: original self-check, modified-script rejection and unsupported-file protection.'
    $Dummy = [IO.File]::ReadAllBytes($Target)
    $ChangedDummy = [byte[]]$Dummy.Clone()
    $ChangedDummy[0] = 88
    $DigestTool = [Security.Cryptography.SHA256]::Create()
    try { $ChangedHash = ([BitConverter]::ToString($DigestTool.ComputeHash($ChangedDummy))).Replace('-','').ToLowerInvariant() }
    finally { $DigestTool.Dispose() }
    $ProfileFile = Join-Path $Temporary 'synthetic-profile.json'
    $Profile = @{
        schemaVersion = 1
        name = 'Synthetic interface fixture, not PCL 414'
        originalLength = $Dummy.Length
        originalHash = $TargetHash.ToLowerInvariant()
        patchedHash = $ChangedHash
        patches = @(@{ offset = 0; old = [Convert]::ToBase64String([byte[]]@($Dummy[0])); new = [Convert]::ToBase64String([byte[]]@(88)) })
    }
    [IO.File]::WriteAllText($ProfileFile, ($Profile | ConvertTo-Json -Depth 5))
    Invoke-Probe $Bytes $true $ProfileFile 0
    $Profile.patches[0].offset = $Dummy.Length
    [IO.File]::WriteAllText($ProfileFile, ($Profile | ConvertTo-Json -Depth 5))
    Invoke-Probe $Bytes $true $ProfileFile 1
    Write-Host 'PASS: external profile preflight and invalid-range rejection without writes.'
} finally {
    # Delete only this process-created folder, after checking its resolved path.
    $ResolvedTemporary = [IO.Path]::GetFullPath($Temporary)
    $ResolvedTempRoot = [IO.Path]::GetFullPath([IO.Path]::GetTempPath()).TrimEnd('\') + '\'
    if ($ResolvedTemporary.StartsWith($ResolvedTempRoot, [StringComparison]::OrdinalIgnoreCase) -and [IO.Path]::GetFileName($ResolvedTemporary).StartsWith('pcl-distribution-check-')) {
        Remove-Item -LiteralPath $ResolvedTemporary -Recurse -Force
    }
}
