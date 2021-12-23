import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart';

class ImageUtils {
  static Future<bool> imageIsLandscape(File imageFile) async {
    var image = await decodeImageFromList(imageFile.readAsBytesSync());
    return image.width >= image.height;
  }

  static Future<File> resizeImageMaintainOrientation(File imageFile, {required int width, required int height, bool? isLandscape}) async {
    isLandscape ??= await imageIsLandscape(imageFile);
    var image = decodeImage(imageFile.readAsBytesSync());
    if (!isLandscape) {
      var x = height;
      height = width;
      width = x;
    }
    var resized = copyResize(image, width: width, height: height);
    return File(imageFile.path + '-resized.jpg').writeAsBytes(encodeJpg(resized, quality: 50));
  }
}
