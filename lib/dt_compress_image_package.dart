library dt_compress_image_package;

import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart';

class CompressImage
{
  static Future<String> compressJPG(File file, String path, {int maxMemorySize, int maxFileSize, int minOpt}) async
  {
    Image image = decodeImage(file.readAsBytesSync());
    bool isJpg = file.path.endsWith("jpg") || file.path.endsWith("jpeg");
    if (!isJpg) {
      throw Exception("typs is not jpg or jpeg");
    }
    int width = image.width;
    int height = image.height;
    int pixelLength = image.numberOfChannels;
    bool isNeedResize = false;
    int length = width * height * pixelLength * 8;
    while (maxMemorySize < length && width >= 4 && height >= 4)
    {
      print("maxMemorySize:" + maxMemorySize.toString() + "length:" + length.toString() + "width:" + width.toString() + "height:" + height.toString());
      width = (width ~/ 2);
      height = (height ~/ 2);
      length = width * height * pixelLength * 8;
      isNeedResize = true;
    }
    if ((width <= 2 || height <= 2) && maxMemorySize < length) {
      print("reducing width and height can not reach the memory demand");
    }
    if (isNeedResize) {
      image = copyResize(image, width: width, height:height);
    }

    File decodedImageFile = new File(path + 'img_${DateTime.now().millisecondsSinceEpoch}.jpg');
    _compressImageJPG(image, decodedImageFile, maxFileSize);
    return decodedImageFile.path;

  }

  static Future<String> compressPNG(File file, String path, {int maxMemorySize, int compressLevel}) async
  {
    Image image = decodeImage(file.readAsBytesSync());
    bool isPNG = file.path.endsWith("png");
    if (!isPNG) {
      throw Exception("typs is not png");
    }
    int width = image.width;
    int height = image.height;
    int pixelLength = image.numberOfChannels;
    bool isNeedResize = false;
    int length = width * height * pixelLength * 8;

    while (maxMemorySize < length && width >= 4 && height >= 4)
    {
      print("maxMemorySize:" + maxMemorySize.toString() + "length:" + length.toString() + "width:" + width.toString() + "height:" + height.toString());
      width = (width ~/ 2);
      height = (height ~/ 2);
      length = width * height * pixelLength * 8;
      isNeedResize = true;
    }
    if ((width <= 2 || height <= 2) && maxMemorySize < length) {
      print("reducing width and height can not reach the memory demand");
    }
    if (isNeedResize) {
      image = copyResize(image, width: width, height:height);
    }

    File decodedImageFile = new File(path + 'img_${DateTime.now().millisecondsSinceEpoch}.png');
    _compressImagePNG(image, decodedImageFile, compressLevel);
    return decodedImageFile.path;

  }

  static void _compressImageJPG(Image image, File file, int targetSize)
  {
    final step = 5;
    int quality = 100;
    var tempImageSize;
    var im;
    do{
      im = encodeJpg(image, quality: quality);
      tempImageSize = Uint8List.fromList(im).lengthInBytes;
      if (tempImageSize  > targetSize && quality > step) {
        quality -= step;
      }
      print("tempImageSize:" + tempImageSize.toString() + "targetSize:" + targetSize.toString() + "quality:" + quality.toString() + "step:" + step.toString());
    }while(tempImageSize  > targetSize && quality > 30);
    if (quality < 30) {
      print("quality is too low");
    }
    file.writeAsBytesSync(im);
  }

  static void _compressImagePNG(Image image, File file, int level) {
    print("level:" + level.toString());
    var im = encodePng(image, level: level);
    file.writeAsBytesSync(im);
  }
}
