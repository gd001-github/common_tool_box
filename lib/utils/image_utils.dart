import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:image/image.dart' as image_lib;

class ImageUtils {
  ImageUtils._();

  /// ByteData 转 ui.image
  static Future<ui.Image> byte2UiImage(ByteData imageByteData) async {
    final u8 = imageByteData.buffer.asUint8List();
    final ui.Codec codec = await ui.instantiateImageCodec(u8);
    final ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  /// IamgeProvider 转 ui.image
  static Future<ui.Image> provider2UiImage(
      {required ImageProvider provider,
      ImageConfiguration config = ImageConfiguration.empty}) {
    final completer = Completer<ui.Image>();

    ImageStream stream = provider.resolve(config);
    late ImageStreamListener listener;
    listener = ImageStreamListener((info, synchronousCall) {
      final image = info.image;
      completer.complete(image);
      stream.removeListener(listener);
    });
  }

  ///图片旋转操作
  static Uint8List rotate(Uint8List srcU8, num angle) {
    final sImage = image_lib.decodeImage(srcU8);
    final rotateImage = image_lib.copyRotate(sImage!, angle);
    final newU8 = image_lib.writePng(rotateImage) as Uint8List;
    return newU8;
  }
}
