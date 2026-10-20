ObjC.import('Foundation');
var fm = $.NSFileManager.defaultManager;
var HASH = '6b6e1260cb5a1d6a303855f1c60cab3d0bc1aebba7e40a964180188b271e7386';
var OFFSET = 180442;
function decode(s) { return $.NSData.alloc.initWithBase64EncodedStringOptions($(s), 0); }
var oldBytes = decode('cjNHAXB++wkABCwHfvsJAAQrFn75CQAE/gZnFAAGc40FAAolgPsJAAQUGHOOBQAK');
var newBytes = decode('fg8EAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
function print(s) { $.NSFileHandle.fileHandleWithStandardError.writeData($(String(s) + '\n').dataUsingEncoding($.NSUTF8StringEncoding)); }
function ask(s) {
    print(s);
    var handle = $.NSFileHandle.fileHandleForReadingAtPath('/dev/tty');
    if (!handle || handle.isNil()) throw Error('请在终端运行，或指定文件路径并加 --yes / --check。');
    var input = handle.availableData;
    handle.closeFile;
    return ObjC.unwrap($.NSString.alloc.initWithDataEncoding(input, $.NSUTF8StringEncoding)).trim();
}
function task(command, args, input) {
    var process = $.NSTask.alloc.init;
    process.launchPath = $(command); process.arguments = $(args);
    var out = $.NSPipe.pipe; process.standardOutput = out;
    var incoming;
    if (input) { incoming = $.NSPipe.pipe; process.standardInput = incoming; }
    process.launch;
    if (incoming) { incoming.fileHandleForWriting.writeData(input); incoming.fileHandleForWriting.closeFile; }
    var data = out.fileHandleForReading.readDataToEndOfFile;
    process.waitUntilExit;
    if (process.terminationStatus !== 0) throw Error('系统命令执行失败：' + command);
    return ObjC.unwrap($.NSString.alloc.initWithDataEncoding(data, $.NSUTF8StringEncoding));
}
function hash(data) { return task('/usr/bin/shasum', ['-a', '256'], data).split(/\s/)[0]; }
function read(path) {
    var attr = fm.attributesOfItemAtPathError($(path), null);
    if (!attr || attr.isNil() || Number(ObjC.unwrap(attr.objectForKey($.NSFileSize))) > 67108864) throw Error('请选择小于 64 MB 的 PCL 程序文件。');
    var data = $.NSData.dataWithContentsOfFile($(path));
    if (!data || data.isNil()) throw Error('无法读取：' + path);
    return data;
}
function replace(data, value) {
    var output = data.mutableCopy;
    output.replaceBytesInRangeWithBytesLength($.NSMakeRange(OFFSET, 48), value.bytes, 48);
    return output;
}
function state(data) {
    if (hash(data) === HASH) return 'original';
    if (Number(data.length) < OFFSET + 48 || !data.subdataWithRange($.NSMakeRange(OFFSET, 48)).isEqualToData(newBytes)) throw Error('文件版本不匹配，未修改。仅支持已验证的正式版 2.99.0.0 (413)。');
    if (hash(replace(data, oldBytes)) !== HASH) throw Error('文件已被其他方式修改，未作修改。');
    return 'patched';
}
function full(path) { return ObjC.unwrap($(path).stringByExpandingTildeInPath.stringByStandardizingPath.stringByResolvingSymlinksInPath); }
function isDir(path) {
    var yes = Ref();
    return fm.fileExistsAtPathIsDirectory($(path), yes) && Boolean(yes[0]);
}
function find(roots) {
    var queue = roots.map(function(p) { return [p, 0]; });
    var seen = {}, found = {}, count = 0, start = Date.now();
    while (queue.length && count < 15000 && Date.now() - start < 6000) {
        var node = queue.shift(), dir = full(node[0]), depth = node[1];
        if (seen[dir]) continue; seen[dir] = true;
        var names = fm.contentsOfDirectoryAtPathError($(dir), null);
        if (!names || names.isNil()) continue;
        var entries = ObjC.deepUnwrap(names);
        for (var i = 0; i < entries.length; i++) {
            if (++count > 15000 || Date.now() - start >= 6000) break;
            var name = entries[i], path = dir + '/' + name;
            var attrs = fm.attributesOfItemAtPathError($(path), null);
            if (!attrs || attrs.isNil()) continue;
            var kind = ObjC.unwrap(attrs.objectForKey($.NSFileType));
            if (kind === 'NSFileTypeSymbolicLink') continue;
            if (kind === 'NSFileTypeDirectory') {
                if (depth < 3 && ['Library', '.git', 'node_modules', '.Trash', '.Spotlight-V100', '.fseventsd'].indexOf(name) < 0) queue.push([path, depth + 1]);
            } else if (/\.exe$/i.test(name) && /pcl|plain craft launcher/i.test(name)) found[path] = true;
        }
    }
    return Object.keys(found).sort();
}
function save(path, before, output) {
    if (!read(path).isEqualToData(before)) throw Error('操作期间文件发生变化，已停止。');
    if (!output.writeToFileAtomically($(path), true)) throw Error('写入失败，请检查权限并关闭 PCL。');
    if (!read(path).isEqualToData(output)) throw Error('写入校验失败，请从备份恢复。');
}
function run(argv) {
    try {
        print("\u001b[36m+----------------------------------------------------------------------------+\n|                                                                            |\n|                  |\\/|  /\\  | /  |===      |==\\  /== |                      |\n|                  |  | /  \\ |/   |         |  | |    |                      |\n|                  |  | |--| |<   |==       |==/ |    |                      |\n|                  |  | |  | |\\   |         |    |    |                      |\n|                  |  | |  | | \\  |===      |     \\== |___                   |\n|                                                                            |\n| |==\\  /\\  |  | |\\ | |     /\\   /\\  |==\\       /\\   /==  /\\  ==== |\\ |  ||  |\n| |  | |  | |  | |\\ | |    |  | /  \\ |  |      /  \\ |    /  \\  ||  |\\ |  ||  |\n| |  | |  | |  | | \\| |    |  | |--| |  |      |--| | == |--|  ||  | \\|  ||  |\n| |  | |  | |/\\| | \\| |    |  | |  | |  |      |  | |  | |  |  ||  | \\|      |\n| |==/  \\/  V  V |  | |___  \\/  |  | |==/      |  |  \\_/ |  | ==== |  |  ..  |\n|                                                                            |\n|                          MAKE PCL DOWNLOAD AGAIN!                          |\n|                                                                            |\n+----------------------------------------------------------------------------+\u001b[0m");
        print('PCL 下载页修复工具 | 免安装 macOS 版');
        var path = argv[0] || '', mode = argv[1] || '';
        if (argv.length > 2 || ['', '--check', '--restore', '--yes'].indexOf(mode) < 0) throw Error('用法：sh macOS修复.command "PCL.exe完整路径" [--check|--restore|--yes]');
        var home = ObjC.unwrap($.NSHomeDirectory());
        if (!path || isDir(full(path))) {
            print('正在快速查找 PCL（最多约 6 秒）……');
            var toolDir = ObjC.unwrap($.NSProcessInfo.processInfo.environment.objectForKey($('PCL_TOOL_DIR'))) || ObjC.unwrap(fm.currentDirectoryPath);
            var roots = path ? [path] : [ObjC.unwrap(fm.currentDirectoryPath), toolDir, home + '/Desktop', home + '/Downloads', home + '/Documents', '/Volumes', home + '/.wine/drive_c', home + '/Library/Application Support/CrossOver/Bottles', home + '/Library/Containers/com.isaacmarovitz.Whisky/Bottles'];
            var candidates = find(roots);
            if (candidates.length === 1) path = candidates[0];
            else if (candidates.length > 1) {
                candidates.forEach(function(p, i) { print((i + 1) + '. ' + p); });
                var choice = ask('找到多个文件，请输入编号（回车取消）：');
                if (!/^\d+$/.test(choice) || Number(choice) < 1 || Number(choice) > candidates.length) throw Error('已取消。');
                path = candidates[Number(choice) - 1];
            } else path = ask('未自动找到，请粘贴 PCL.exe 完整路径：').replace(/^["']|["']$/g, '');
        }
        if (!path) throw Error('已取消。');
        path = full(path); print('目标：' + path);
        var data = read(path), current = state(data), backup = path + '.pcl-download-backup';
        if (mode === '--check') { print('检查通过：' + current + '，文件受支持。'); return; }
        if (mode === '--restore') {
            if (current === 'original') { print('已经是原版，无需恢复。'); return; }
            var original = read(backup);
            if (hash(original) !== HASH) throw Error('备份校验失败，未恢复。');
            if (!/^y(es)?$/i.test(ask('从备份恢复原版？[y/N]'))) { print('已取消。'); return; }
            save(path, data, original); print('已恢复原版，备份保留。');
        } else {
            if (current === 'patched') { print('已修复，无需重复操作。'); return; }
            if (mode !== '--yes' && !/^y(es)?$/i.test(ask('请先关闭 PCL。备份并恢复下载页？[y/N]'))) { print('已取消。'); return; }
            task('/bin/cp', ['-p', '-n', path, backup]);
            if (hash(read(backup)) !== HASH) throw Error('已有备份不匹配或备份失败，未修改。');
            var output = replace(data, newBytes);
            if (state(output) !== 'patched') throw Error('补丁校验失败。');
            save(path, data, output);
            print('玩的开心'); print('原版备份：' + backup);
        }
    } catch (error) { throw Error('未完成：' + error.message); }
}
