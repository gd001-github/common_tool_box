import 'dart:io';

import 'package:path_provider/path_provider.dart';

class DeviceFilePath {
  DeviceFilePath._();
  static final DeviceFilePath ins = DeviceFilePath._();

  Directory? _tempDir;

  /// 临时
  Future<Directory> get tempDir async {
    _tempDir ??= await getTemporaryDirectory();
    return _tempDir!;
  }

  Directory? _appDir;

  /// 文档
  Future<Directory> get appDir async {
    _appDir ??= await getApplicationDocumentsDirectory();
    return _appDir!;
  }

  Directory? _exDir;

  /// 额外(ios不能用)
  Future<Directory> get exDir async {
    _exDir ??= await getExternalStorageDirectory();
    return _exDir!;
  }
}
