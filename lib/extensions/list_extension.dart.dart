export 'package:common_tool_box/extensions/list_extension.dart.dart';

extension CusListExtension<T> on List<T> {
  void forEachIndex(void Function(int index, T e) action) {
    var index = 0;
    for (final T e in this) {
      try {
        action(index, e);
      } finally {
        index++;
      }
    }
  }
}
