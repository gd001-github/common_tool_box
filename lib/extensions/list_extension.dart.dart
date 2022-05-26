export 'package:common_tool_box/extensions/list_extension.dart.dart';

extension CusListExtension<T> on List<T> {
  void forEachIndex(void Function(int index, T element) action) {
    var index = 0;
    for (T element in this) {
      action(index, element);
      index++;
    }
  }
}
