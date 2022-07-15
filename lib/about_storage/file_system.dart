import 'dart:io';

import 'package:common_tool_box/about_storage/device_file_path.dart';
import 'package:common_tool_box/extensions/template_extension.dart';

enum DirType {
  image_app_dir,
  sound_app_dir,
  file_app_dir,
  image_temp_dir,
  sound_temp_dir,
  file_temp_dir,
}

class FileSystem {
  FileSystem._();
  static final FileSystem ins = FileSystem._();

  final Map<DirType, Directory> _pathMap = {};

  Future<void> init() async {
    final appDir = await DeviceFilePath.ins.appDir;
    final tempDir = await DeviceFilePath.ins.tempDir;

    Directory create(DirType type, Directory rootDir) {
      final retPath = '${rootDir.path}/${type.name}/';
      final dir = Directory(retPath);
      if (!dir.existsSync()) {
        dir.createSync();
      }
      return dir;
    }

    DirType.image_app_dir.go((it) => _pathMap[it] = create(it, appDir));
    DirType.sound_app_dir.go((it) => _pathMap[it] = create(it, appDir));
    DirType.file_app_dir.go((it) => _pathMap[it] = create(it, appDir));
    DirType.image_temp_dir.go((it) => _pathMap[it] = create(it, tempDir));
    DirType.sound_temp_dir.go((it) => _pathMap[it] = create(it, tempDir));
    DirType.file_temp_dir.go((it) => _pathMap[it] = create(it, tempDir));
  }

  /// 获取类型对应路径
  Directory getDir(DirType type) => _pathMap[type]!;

  /// 清空类型文件夹
  Future clearDir(DirType type) async {
    final dir = getDir(type);
    await dir.delete(recursive: true);
    await dir.create();
  }

  /// 清空所有
  Future clearAll() async {
    for (final e in DirType.values) {
      try {
        await clearDir(e);
      } catch (e) {
        rethrow;
      }
    }
  }

  /// 计算类型文件大小
  Future<int> calculateSize(DirType type) async {
    final dir = getDir(type);

    Future<int> calculate(FileSystemEntity f) async {
      if (f is File) {
        return f.length();
      } else if (f is Directory) {
        final list = dir.listSync();
        var count = 0;
        for (final e in list) {
          count += await calculate(e);
        }
        return count;
      }
      return 0;
    }

    final length = await calculate(dir);
    return length;
  }

  /// 计算一共大小
  Future<int> calculateAllSize() async {
    var length = 0;
    for (final e in DirType.values) {
      try {
        length += await calculateSize(e);
      } catch (e) {
        rethrow;
      }
    }
    return length;
  }
}
