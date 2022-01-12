import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart';

class ImageUtils {
  static Future<bool> imageIsLandscape(Uint8List bytes) async {
    var image = await decodeImageFromList(bytes);
    return image.width >= image.height;
  }

  static Future<File> resizeImageMaintainOrientation(File imageFile, {required int width, required int height, bool? isLandscape, bool rotate = false}) async {
    isLandscape ??= await imageIsLandscape(imageFile.readAsBytesSync());
    var image = decodeImage(imageFile.readAsBytesSync());
    print("Input Image Size ${image?.width}x${image?.height}, landscape=${isLandscape}");
    if (!isLandscape & rotate) {
      var x = height;
      height = width;
      width = x;
    }
    var resized = copyResize(image!, width: width, height: height);
    print("Output Image Size ${resized.width}x${resized.height}");
    return File(imageFile.path + '-resized.png').writeAsBytes(encodePng(resized));
  }
}
