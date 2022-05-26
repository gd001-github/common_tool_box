import 'dart:typed_data';
import 'dart:ui' as ui;

class ImageUtils {
  ImageUtils._();

  /// ByteData 转 ui.image图片
  static Future<ui.Image> byte2UiImage(ByteData imageByteData) async {
    final u8 = imageByteData.buffer.asUint8List();
    final ui.Codec codec = await ui.instantiateImageCodec(u8);
    final ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }
}
