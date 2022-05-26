import 'dart:ui';

export 'package:common_tool_box/extensions/rect_extension.dart';

extension RectExtension on Rect {
  Rect copy({double? left, double? top, double? width, double? height}) {
    return Rect.fromLTWH(left ?? this.left, top ?? this.top,
        width ?? this.width, height ?? this.height);
  }
}
