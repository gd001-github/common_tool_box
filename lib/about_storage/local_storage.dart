import 'package:shared_preferences/shared_preferences.dart';

/// 本地缓存服务
class LocalStorage {
  /// 默认用默认的storage
  LocalStorage({this.storageName = defaultName}) {
    // ignore: prefer_asserts_in_initializer_lists
    assert(_preferences != null);
    _keyList = _preferences!.getStringList(prefix) ?? [];
  }

  static SharedPreferences? _preferences;

  static const String defaultName = 'default';

  final String storageName;

  late final String prefix = '${storageName}_@@_';

  var _keyList = <String>[];

  String getFinalKey(String key) {
    if (!_keyList.contains(key)) {
      _keyList.add(key);
      _preferences!.setStringList(prefix, _keyList);
    }
    return '$prefix$key';
  }

  /// 初始化（app启动）
  static Future<void> init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  Future<bool> _setData<T>(String key, T value) {
    assert(_preferences != null);
    final finalKey = getFinalKey(key);
    switch (T) {
      case String:
        return _preferences!.setString(finalKey, value as String);
      case int:
        return _preferences!.setInt(finalKey, value as int);
      case bool:
        return _preferences!.setBool(finalKey, value as bool);
      case double:
        return _preferences!.setDouble(finalKey, value as double);
      case List:
        return _preferences!.setStringList(finalKey, value as List<String>);
      default:
        throw Exception('LocalStorage-setData: invalid type');
    }
  }

  T? _getData<T>(String key) {
    assert(_preferences != null);
    final finalKey = getFinalKey(key);
    switch (T) {
      case String:
        return _preferences?.getString(finalKey) as T?;
      case int:
        return _preferences?.getInt(finalKey) as T?;
      case bool:
        return _preferences?.getBool(finalKey) as T?;
      case double:
        return _preferences?.getDouble(finalKey) as T?;
      case List:
        return _preferences?.getStringList(finalKey) as T?;
      default:
        return _preferences?.get(finalKey) as T?;
    }
  }

  /// 判断本地存储是否已存在 key
  bool _containsKey(String key) {
    assert(_preferences != null);
    final finalKey = getFinalKey(key);
    return _preferences!.containsKey(finalKey);
  }

  ///移除某个数据
  Future<bool> _removeData(String key) {
    assert(_preferences != null);
    final finalKey = getFinalKey(key);
    return _preferences!.remove(finalKey);
  }

  ///移除当前storage全部数据
  Future<void> clearStorage() async {
    assert(_preferences != null);
    for (final e in _keyList) {
      try {
        await _removeData(e);
      } catch (e) {
        rethrow;
      }
    }
    await _preferences!.remove(prefix);
  }

// ==================================

  /// 保存
  Future<bool> setData<T>(String key, T value) async {
    return _setData(key, value);
  }

  /// 读取数据
  T? getData<T>(String key) {
    return _getData(key);
  }

  /// 判断本地存储是否已存在 key
  bool containsKey(String key) {
    return _containsKey(key);
  }

  ///移除某个数据
  Future<bool> removeData(String key) {
    return _removeData(key);
  }

  ///移除全部数据
  static Future<bool> clearAll() {
    return _preferences!.clear();
  }
}
