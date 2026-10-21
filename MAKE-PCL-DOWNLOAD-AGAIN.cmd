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
# PCL_TOOL_SHA256: b3bbc0a85edcf44d395d1a2ca610fb1bd1e0d71b452ba35b5f10f937cbfc8c91
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
function Initialize-AutoAdapter {
    if ('PclAutoAdapter' -as [type]) { return }
    $AutoAdapterSource = @'
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Reflection.Emit;
using System.Resources;
using System.Security.Cryptography;
using System.Text;

// Metadata-only adapter. Never Assembly.Load or invoke any target method.
public static class PclAutoAdapter
{
    public class Patch { public int offset; public string old; public string @new; }
    public class Plan {
        public string name, originalHash, patchedHash, tail;
        public int originalLength;
        public List<Patch> patches = new List<Patch>();
    }
    static readonly BindingFlags All = BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Static | BindingFlags.Instance | BindingFlags.DeclaredOnly;
    static readonly Dictionary<short, OpCode> Opcodes = typeof(OpCodes).GetFields(BindingFlags.Public | BindingFlags.Static).Where(f => f.FieldType == typeof(OpCode)).Select(f => (OpCode)f.GetValue(null)).ToDictionary(o => o.Value);
    static readonly string[] Installers = { "InstallPackCurseForge", "InstallPackHMCL", "InstallPackMMC", "InstallPackMCBBS", "InstallPackModrinth", "InstallPackLauncherPack", "InstallPackCompress" };
    static readonly Dictionary<string,string> Expected = new Dictionary<string,string> {
        { "LoaderInit", "338bbbe5f13eb6cb8a77389438f0e9e086162583236a47db80287d49a6026573" },
        { "ModpackInstall", "8bf65cdba3c687f6c679d867efa6a417cb859dee46c0c06bf46456907469252c" },
        { "InstallPackCurseForge", "662487df393f07912a5bb2da75a7689c5d59ffad94eca72319e9c9e7e4c30f2b" },
        { "InstallPackHMCL", "0d7407fe24a5daf105eb6f1c5aa86a5b4f801c446050d32f15487f2cd91a10f3" },
        { "InstallPackMMC", "68ffab66fd9f9746f89d76add61db6a97801bc976fbcb0b2c372399d64c8b49b" },
        { "InstallPackMCBBS", "96597d42135fa0d4c1f115b5ab2bf623bdd7d68cb9d44304caec0d0677466bf3" },
        { "InstallPackModrinth", "d14372233969287542e74a7f7cd3160ec8ec217c51ef801a70f3142a79580c7d" },
        { "InstallPackLauncherPack", "a15160663c49e789427e797b4b41e55e9d87c79cbc1c0eaade78518c9284b414" },
        { "InstallPackCompress", "293d8b1f56ecc6efe07e3fc504e18af5c073ee6667a8f01f6d4868605bb0ea03" }
    };
    static void Need(bool value, string message) { if (!value) throw new InvalidDataException(message); }
    static string Hash(byte[] data) { using (var h = SHA256.Create()) return BitConverter.ToString(h.ComputeHash(data)).Replace("-", "").ToLowerInvariant(); }
    static string LoadedTargetHash;
    static readonly object LoadGate = new object();
    static Assembly LoadTarget(byte[] data) {
        lock (LoadGate) {
            string digest = Hash(data);
            // Reflection-only binding may cache an assembly identity. Never
            // mix metadata from two different target files in one process.
            Need(LoadedTargetHash == null || LoadedTargetHash == digest, "Only one target image may be inspected per process.");
            LoadedTargetHash = digest;
            return Assembly.ReflectionOnlyLoad(data);
        }
    }
    static string TypeName(Type type) {
        if (type.IsByRef) return TypeName(type.GetElementType()) + "&";
        if (type.IsPointer) return TypeName(type.GetElementType()) + "*";
        if (type.IsArray) return TypeName(type.GetElementType()) + "[" + new string(',', type.GetArrayRank() - 1) + "]";
        if (type.IsGenericParameter) return (type.DeclaringMethod == null ? "!" : "!!") + type.GenericParameterPosition;
        if (type.IsGenericType) return type.GetGenericTypeDefinition().FullName + "<" + string.Join(",", type.GetGenericArguments().Select(TypeName).ToArray()) + ">";
        return type.FullName;
    }
    static string MemberName(MemberInfo info) {
        var method = info as MethodBase;
        if (method != null) {
            var generic = method.IsGenericMethod ? "<" + string.Join(",", method.GetGenericArguments().Select(TypeName).ToArray()) + ">" : "";
            return TypeName(method.DeclaringType) + "::" + method.Name + generic + "(" + string.Join(",", method.GetParameters().Select(p => TypeName(p.ParameterType)).ToArray()) + ")" + (method is MethodInfo ? ":" + TypeName(((MethodInfo)method).ReturnType) : ":void");
        }
        var field = info as FieldInfo;
        if (field != null) return TypeName(field.DeclaringType) + "::" + field.Name + ":" + TypeName(field.FieldType);
        var type = info as Type;
        if (type != null) return TypeName(type);
        throw new InvalidDataException("Unsupported metadata operand.");
    }
    static string Fingerprint(MethodInfo method) {
        var body = method.GetMethodBody();
        Need(body != null, "Missing method body.");
        byte[] code = body.GetILAsByteArray();
        var text = new StringBuilder();
        text.Append(MemberName(method)).Append('|').Append(body.InitLocals).Append('|');
        foreach (var local in body.LocalVariables) text.Append(local.LocalIndex).Append(':').Append(TypeName(local.LocalType)).Append(':').Append(local.IsPinned).Append(';');
        foreach (var clause in body.ExceptionHandlingClauses) {
            text.Append("EH:").Append(clause.Flags).Append(':').Append(clause.TryOffset).Append(':').Append(clause.TryLength).Append(':').Append(clause.HandlerOffset).Append(':').Append(clause.HandlerLength);
            if (clause.Flags == ExceptionHandlingClauseOptions.Clause) text.Append(':').Append(TypeName(clause.CatchType));
            else if (clause.Flags == ExceptionHandlingClauseOptions.Filter) text.Append(':').Append(clause.FilterOffset);
            text.Append(';');
        }
        int at = 0;
        while (at < code.Length) {
            int begin = at;
            short key = code[at++] == 0xfe ? (short)(0xfe00 | code[at++]) : (short)code[begin];
            OpCode op;
            Need(Opcodes.TryGetValue(key, out op), "Unknown IL instruction.");
            text.Append(begin).Append(':').Append(key).Append(':');
            int size;
            switch (op.OperandType) {
                case OperandType.InlineNone: size = 0; break;
                case OperandType.ShortInlineI: case OperandType.ShortInlineVar: case OperandType.ShortInlineBrTarget: size = 1; break;
                case OperandType.InlineVar: size = 2; break;
                case OperandType.InlineI8: case OperandType.InlineR: size = 8; break;
                case OperandType.InlineSwitch: Need(at + 4 <= code.Length, "Truncated IL switch."); size = checked(4 + 4 * BitConverter.ToInt32(code, at)); break;
                default: size = 4; break;
            }
            Need(size >= 0 && at <= code.Length - size, "Truncated IL operand.");
            if (op.OperandType == OperandType.InlineString) {
                string value = method.Module.ResolveString(BitConverter.ToInt32(code, at));
                // Logging-only absolute build paths differ between build hosts.
                if (value.Contains("\\Modules\\") && value.EndsWith(".vb", StringComparison.Ordinal)) value = "<build-path>/" + Path.GetFileName(value);
                text.Append(Convert.ToBase64String(Encoding.UTF8.GetBytes(value)));
            } else if (op.OperandType == OperandType.InlineField || op.OperandType == OperandType.InlineMethod || op.OperandType == OperandType.InlineType || op.OperandType == OperandType.InlineTok) {
                text.Append(MemberName(method.Module.ResolveMember(BitConverter.ToInt32(code, at))));
            } else {
                Need(op.OperandType != OperandType.InlineSig, "Unsupported standalone call signature.");
                if (size > 0) text.Append(BitConverter.ToString(code, at, size));
            }
            text.Append(';'); at += size;
        }
        return Hash(Encoding.UTF8.GetBytes(text.ToString()));
    }
    static ResolveEventHandler Resolver(Assembly root) {
        return delegate(object sender, ResolveEventArgs args) {
            string name = new AssemblyName(args.Name).Name;
            if (new[] { "Newtonsoft.Json", "PCLCS", "MeloongCore", "MeloongCore.Wpf" }.Contains(name)) {
                using (var stream = root.GetManifestResourceStream("PCL.Resources.resources")) {
                    Need(stream != null, "Missing embedded dependency resource.");
                    using (var reader = new ResourceReader(stream)) {
                        string kind; byte[] raw;
                        // Read raw resource bytes, never deserialize arbitrary resource objects.
                        reader.GetResourceData(name, out kind, out raw);
                        Need(kind == "ResourceTypeCode.ByteArray" && raw.Length > 6 && BitConverter.ToInt32(raw, 0) == raw.Length - 4 && raw[4] == 77 && raw[5] == 90, "Unsupported embedded dependency layout.");
                        return Assembly.ReflectionOnlyLoad(raw.Skip(4).ToArray());
                    }
                }
            }
            if (name == "mscorlib" || name == "netstandard" || name.StartsWith("System", StringComparison.Ordinal) || name == "Microsoft.VisualBasic" || name == "PresentationFramework" || name == "PresentationCore" || name == "WindowsBase") {
                try { return Assembly.ReflectionOnlyLoad(args.Name); }
                catch (FileNotFoundException) {
                    string framework = System.Runtime.InteropServices.RuntimeEnvironment.GetRuntimeDirectory();
                    foreach (string directory in new[] { framework, Path.Combine(framework, "Facades") }) {
                        string path = Path.Combine(directory, name + ".dll");
                        if (File.Exists(path)) return Assembly.ReflectionOnlyLoadFrom(path);
                    }
                    throw;
                }
            }
            return null;
        };
    }
    static Dictionary<string,MethodInfo> Methods(Assembly assembly) {
        var result = new Dictionary<string,MethodInfo>();
        result.Add("LoaderInit", assembly.GetType("PCL.PageDownloadInstall", true).GetMethods(All).Single(m => m.Name == "LoaderInit" && m.GetParameters().Length == 0));
        var type = assembly.GetType("PCL.ModModpack", true);
        result.Add("ModpackInstall", type.GetMethods(All).Single(m => m.Name == "ModpackInstall" && m.GetParameters().Length == 3));
        foreach (string name in Installers) result.Add(name, type.GetMethods(All).Single(m => m.Name == name));
        return result;
    }
    public static string[] Describe(byte[] data) {
        var assembly = LoadTarget(data);
        var handler = Resolver(assembly);
        AppDomain.CurrentDomain.ReflectionOnlyAssemblyResolve += handler;
        try { return Methods(assembly).Select(p => p.Key + "=" + Fingerprint(p.Value)).ToArray(); }
        finally { AppDomain.CurrentDomain.ReflectionOnlyAssemblyResolve -= handler; }
    }

    sealed class Pe {
        public byte[] Data;
        public int Opt, Sections, Last, MethodTable, MethodRowSize, FileAlign, SectionAlign, LastRaw, LastSize, LastRva;
        public uint U32(int p) { Need(p >= 0 && p <= Data.Length - 4, "PE offset out of range."); return BitConverter.ToUInt32(Data, p); }
        public int I32(int p) { uint v = U32(p); Need(v <= int.MaxValue, "PE integer too large."); return (int)v; }
        public ushort U16(int p) { Need(p >= 0 && p <= Data.Length - 2, "PE offset out of range."); return BitConverter.ToUInt16(Data, p); }
        public int Offset(int rva) {
            for (int i = 0; i < Sections; i++) { int s = Last - (Sections - 1 - i) * 40; int start = I32(s + 12), size = I32(s + 16); if (rva >= start && (long)rva < (long)start + size) return checked(I32(s + 20) + rva - start); }
            throw new InvalidDataException("RVA is not backed by file data.");
        }
        static int Index(uint[] rows, int table) { return rows[table] < 65536 ? 2 : 4; }
        static int Coded(uint[] rows, int bits, params int[] tables) { return tables.Max(t => rows[t]) < (1u << (16 - bits)) ? 2 : 4; }
        public Pe(byte[] data) {
            Data = data; Need(data.Length >= 512 && data.Length <= 67108864 && U16(0) == 0x5a4d, "Not a supported PE file.");
            int pe = I32(0x3c); Need(U32(pe) == 0x4550, "Invalid PE signature.");
            Sections = U16(pe + 6); Need(Sections >= 1 && Sections <= 32, "Invalid PE section count.");
            Opt = pe + 24; int magic = U16(Opt); Need(magic == 0x10b || magic == 0x20b, "Unsupported PE format.");
            int dirs = Opt + (magic == 0x10b ? 96 : 112);
            Need(U32(dirs + 4 * 8) == 0 && U32(dirs + 4 * 8 + 4) == 0, "Signed/overlay layout is not supported by automatic patching.");
            Last = Opt + U16(pe + 20) + 40 * (Sections - 1);
            LastRaw = I32(Last + 20); LastSize = I32(Last + 16); LastRva = I32(Last + 12);
            Need((long)LastRaw + LastSize == data.Length && I32(Last + 8) <= LastSize, "Trailing data or unsupported final PE section.");
            FileAlign = I32(Opt + 36); SectionAlign = I32(Opt + 32);
            Need(FileAlign >= 512 && FileAlign <= 65536 && (FileAlign & (FileAlign - 1)) == 0 && SectionAlign >= FileAlign && (SectionAlign & (SectionAlign - 1)) == 0, "Unsupported PE alignment.");
            int cli = Offset(I32(dirs + 14 * 8)); int metadata = Offset(I32(cli + 8)); Need(U32(metadata) == 0x424a5342, "Invalid CLR metadata.");
            int at = checked(metadata + 16 + I32(metadata + 12)); at = (at + 3) & ~3;
            int streams = U16(at + 2); at += 4; int table = -1;
            for (int i = 0; i < streams; i++) {
                int relative = I32(at); int p = at + 8, end = p; while (end < data.Length && data[end] != 0) end++;
                Need(end < data.Length && end - p < 32, "Invalid metadata stream.");
                string name = Encoding.ASCII.GetString(data, p, end - p);
                if (name == "#~" || name == "#-") table = checked(metadata + relative);
                at = (end + 4) & ~3;
            }
            Need(table >= 0, "Missing metadata tables.");
            int heaps = data[table + 6]; int str = (heaps & 1) != 0 ? 4 : 2, guid = (heaps & 2) != 0 ? 4 : 2, blob = (heaps & 4) != 0 ? 4 : 2;
            ulong valid = BitConverter.ToUInt64(data, table + 8); uint[] rows = new uint[64]; at = table + 24;
            for (int i = 0; i < 64; i++) if ((valid & (1ul << i)) != 0) { rows[i] = U32(at); at += 4; }
            int[] sizes = { 2 + str + 3 * guid, Coded(rows, 2, 0, 26, 35, 1) + 2 * str,
                4 + 2 * str + Coded(rows, 2, 2, 1, 27) + Index(rows, 4) + Index(rows, 6), Index(rows, 4), 2 + str + blob, Index(rows, 6) };
            long rowStart = at;
            for (int i = 0; i < 6; i++) rowStart += (long)rows[i] * sizes[i];
            Need(rowStart >= 0 && rowStart < data.Length, "Invalid MethodDef table.");
            MethodTable = (int)rowStart; MethodRowSize = 8 + str + blob + Index(rows, 8);
        }
        public int MethodRow(MethodInfo method) { Need((method.MetadataToken >> 24) == 6, "Expected method definition."); return checked(MethodTable + ((method.MetadataToken & 0xffffff) - 1) * MethodRowSize); }
        public int MethodStart(MethodInfo method) { return Offset(I32(MethodRow(method))); }
        public int CodeStart(MethodInfo method) { int p = MethodStart(method); Need((U16(p) & 3) == 3, "Expected fat IL header."); return p + (U16(p) >> 12) * 4; }
    }
    static int Align(int value, int align) { return checked((value + align - 1) / align * align); }
    static void Put(List<byte> data, int value) { data.AddRange(BitConverter.GetBytes(value)); }
    static void AddPatch(Plan plan, byte[] data, int offset, byte[] replacement) {
        Need(offset >= 0 && offset <= data.Length - replacement.Length, "Patch out of range.");
        plan.patches.Add(new Patch { offset = offset, old = Convert.ToBase64String(data.Skip(offset).Take(replacement.Length).ToArray()), @new = Convert.ToBase64String(replacement) });
    }
    public static Plan Build(byte[] data) {
        var pe = new Pe(data);
        var assembly = LoadTarget(data); var handler = Resolver(assembly);
        AppDomain.CurrentDomain.ReflectionOnlyAssemblyResolve += handler;
        try {
            var baseType = assembly.GetType("PCL.ModBase", true);
            string version = (string)baseType.GetField("VersionBaseName", All).GetRawConstantValue();
            int build = Convert.ToInt32(baseType.GetField("VersionCode", All).GetRawConstantValue());
            Need((version == "2.99.0.0" || version == "2.99.0") && build == 414, "Experimental automatic matching is limited to 2.99.0 build 414; build 413 keeps exact-hash verification.");
            var methods = Methods(assembly);
            Need(Expected.Count == methods.Count, "Missing adapter reference fingerprints.");
            foreach (var item in methods) Need(Expected[item.Key] == Fingerprint(item.Value), "Method structure differs from the verified reference: " + item.Key);
            var field = assembly.GetType("PCL.ModDownload", true).GetField("DlClientListLoader", All);
            Need(field != null && field.IsStatic && field.Module == assembly.ManifestModule, "Missing original download-list field.");
            var loader = methods["LoaderInit"]; byte[] loaderCode = loader.GetMethodBody().GetILAsByteArray();
            Need(loaderCode.Length == 94 && loaderCode[26] == 0x72 && loaderCode[69] == 0x73, "Unexpected loader replacement region.");
            byte[] replacement = new byte[48]; replacement[0] = 0x7e; Array.Copy(BitConverter.GetBytes(field.MetadataToken), 0, replacement, 1, 4);
            var plan = new Plan { name = "PCL " + version + " (" + build + ") experimental structural adapter", originalHash = Hash(data), originalLength = data.Length };
            AddPatch(plan, data, pe.CodeStart(loader) + 26, replacement);

            var install = methods["ModpackInstall"]; byte[] old = install.GetMethodBody().GetILAsByteArray();
            Need(old.Length == 751 && old[730] == 0x72 && old[740] == 0x7a, "Unexpected modpack rejection region.");
            var code = new List<byte>(old.Take(730)); var labels = new Dictionary<string,int>(); var branches = new List<KeyValuePair<int,string>>();
            Action<byte,string> branch = delegate(byte op, string label) { code.Add(op); branches.Add(new KeyValuePair<int,string>(code.Count, label)); Put(code, 0); };
            int[] kinds = { 0, 1, 2, 3, 4, 9 }; int[] counts = { 5, 3, 3, 4, 5, 3 };
            for (int i = 0; i < 6; i++) { code.AddRange(new byte[] { 0x11, 4, 0x1f, (byte)kinds[i] }); branch(0x3b, Installers[i]); }
            branch(0x38, "InstallPackCompress");
            for (int i = 0; i < 7; i++) {
                labels[Installers[i]] = code.Count; code.Add(0x02); code.Add(0x07);
                if (i < 6) { code.Add(0x08); if (counts[i] >= 4) code.Add(0x03); if (counts[i] >= 5) code.Add(0x04); }
                code.Add(0x28); Put(code, methods[Installers[i]].MetadataToken); code.Add(0x0a); branch(0xdd, "return");
            }
            int finallyOffset = code.Count; code.AddRange(old.Skip(741)); labels["return"] = code.Count; code.AddRange(new byte[] { 0x06, 0x2a });
            foreach (var b in branches) { byte[] value = BitConverter.GetBytes(labels[b.Value] - b.Key - 4); for (int i = 0; i < 4; i++) code[b.Key + i] = value[i]; }
            var body = new List<byte>(); body.AddRange(BitConverter.GetBytes((ushort)0x301b)); body.AddRange(BitConverter.GetBytes((ushort)Math.Max(5, install.GetMethodBody().MaxStackSize)));
            Put(body, code.Count); Put(body, pe.I32(pe.MethodStart(install) + 8)); body.AddRange(code); while (body.Count % 4 != 0) body.Add(0);
            int eh = Align(pe.CodeStart(install) + old.Length, 4); bool fat = (data[eh] & 0x40) != 0;
            Need((data[eh] & 0x81) == 1, "Unexpected chained exception sections.");
            int sectionSize = fat ? data[eh+1] | (data[eh+2] << 8) | (data[eh+3] << 16) : data[eh+1];
            int clauseSize = fat ? 24 : 12; Need(sectionSize == 4 + 3 * clauseSize, "Unexpected exception region count.");
            body.AddRange(new byte[] { 0x41, 76, 0, 0 });
            for (int i = 0; i < 3; i++) {
                int p = eh + 4 + i * clauseSize;
                int flags = fat ? pe.I32(p) : pe.U16(p), start = fat ? pe.I32(p+4) : pe.U16(p+2), length = fat ? pe.I32(p+8) : data[p+4];
                int handlerStart = fat ? pe.I32(p+12) : pe.U16(p+5), handlerLength = fat ? pe.I32(p+16) : data[p+7], token = pe.I32(p+(fat ? 20 : 8));
                if (start == 39) { Need(flags == 2 && handlerStart == 741 && handlerLength == 10, "Outer finally does not match."); length = finallyOffset - start; handlerStart = finallyOffset; }
                foreach (int value in new[] { flags, start, length, handlerStart, handlerLength, token }) Put(body, value);
            }
            int virtualSize = checked(pe.LastSize + body.Count), rawSize = Align(virtualSize, pe.FileAlign);
            byte[] tail = new byte[rawSize - pe.LastSize]; body.CopyTo(tail);
            AddPatch(plan, data, pe.MethodRow(install), BitConverter.GetBytes(checked(pe.LastRva + pe.LastSize)));
            AddPatch(plan, data, pe.Last + 8, BitConverter.GetBytes(virtualSize)); AddPatch(plan, data, pe.Last + 16, BitConverter.GetBytes(rawSize));
            AddPatch(plan, data, pe.Last + 36, BitConverter.GetBytes(0x60000060)); AddPatch(plan, data, pe.Opt + 56, BitConverter.GetBytes(Align(checked(pe.LastRva + virtualSize), pe.SectionAlign)));
            byte[] output = new byte[data.Length + tail.Length]; Array.Copy(data, output, data.Length);
            foreach (var patch in plan.patches) { byte[] value = Convert.FromBase64String(patch.@new); Array.Copy(value, 0, output, patch.offset, value.Length); }
            Array.Copy(tail, 0, output, data.Length, tail.Length); plan.tail = Convert.ToBase64String(tail); plan.patchedHash = Hash(output);
            return plan;
        } finally { AppDomain.CurrentDomain.ReflectionOnlyAssemblyResolve -= handler; }
    }
}
'@
    Add-Type -TypeDefinition $AutoAdapterSource -Language CSharp
}
function New-AutomaticProfile([byte[]] $Bytes, [string] $Path) {
    Write-Host '正在只读核对 PCL 方法结构，尝试自动适配（首次可能需要数秒）……'
    Initialize-AutoAdapter
    $CurrentHash = Get-Hash $Bytes
    $OriginalBackup = $Path + '.pcl-download-backup'
    if ([IO.File]::Exists($OriginalBackup)) {
        try {
            $Plan = [PclAutoAdapter]::Build((Read-Program $OriginalBackup))
            if ($CurrentHash -eq $Plan.originalHash -or $CurrentHash -eq $Plan.patchedHash) { return $Plan }
            throw '原版备份与目标不匹配，或目标文件已被改动。'
        } catch { throw ('无法使用原版备份推导补丁，未修改文件。详情：' + $_.Exception.Message) }
    }
    try { return [PclAutoAdapter]::Build($Bytes) }
    catch { throw ('无法自动适配，未修改文件。只有方法结构完整匹配参考实现才会继续；已修复文件需要保留原版备份。详情：' + $_.Exception.Message) }
}
function Set-AutomaticProfile($Plan) {
    Set-Variable -Scope 1 -Name ProfileName -Value $Plan.name
    Set-Variable -Scope 1 -Name ExpectedHash -Value $Plan.originalHash
    Set-Variable -Scope 1 -Name PatchedHash -Value $Plan.patchedHash
    Set-Variable -Scope 1 -Name DownloadOnlyHash -Value $null
    Set-Variable -Scope 1 -Name OriginalLength -Value $Plan.originalLength
    Set-Variable -Scope 1 -Name Patches -Value @($Plan.patches)
    Set-Variable -Scope 1 -Name PatchTail -Value ([Convert]::FromBase64String($Plan.tail))
    Write-Host ('结构比对通过：' + $Plan.name) -ForegroundColor Yellow
    Write-Host '自动适配属于实验功能；未在真实 414 上验证，结构匹配不等于来源或完整安装验证。'
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
    Write-Host 'PCL 下载与整合包拖入安装修复工具 | v1.3.0 | 免安装 Windows 版'
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
    $CurrentHash = Get-Hash $Data
    if (-not $env:PCL_TOOL_PROFILE_FLAG -and $CurrentHash -notin @($ExpectedHash, $DownloadOnlyHash, $PatchedHash)) {
        $AutomaticPlan = New-AutomaticProfile $Data $Target
        Set-AutomaticProfile $AutomaticPlan
    }
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
