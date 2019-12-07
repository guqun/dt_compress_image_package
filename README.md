# dt_compress_image_package

## A package to compress image (png or jpg).

## This package is used to compress image(png or jpg currently)
### There are two ways to compress images.
### 1、scale image. Resizing image (width / 2 and height / 2 pertime) until the image memory size is less than given size
### 2、compress image. optional params in the jpg and level in the png ensure the size of image's file is less than given size

## example:
### jpg:desPath = await CompressImage.compressJPG(File(srcPath), "/storage/emulated/0/XXX/", maxMemorySize: 2 * 1024 * 1024, maxFileSize: 200 * 1024);
### png:desPath = await CompressImage.compressPNG(File(srcPath), "/storage/emulated/0/XXX/", maxMemorySize: 2 * 1024 * 1024, compressLevel: PNGCompressLevel.BEST_COMPRESSION);

