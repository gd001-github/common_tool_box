export 'package:common_tool_box/data/value_cache.dart';

class ValueCache<T> {
  ValueCache({required this.value}) {
    _cachevalue = value;
  }

  late T _cachevalue;
  T get cachevalue => _cachevalue;

  T value;

  void restore() => value = _cachevalue;
  void coverCache() => _cachevalue = value;
}
