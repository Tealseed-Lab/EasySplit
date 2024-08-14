import 'package:easysplit_flutter/common/services/interfaces/image_service.dart';
import 'package:easysplit_flutter/common/services/log_service.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

@Singleton(as: ImageService)
class AppImageService extends ImageService {
  @override
  Future<ReceiptImage?> pickImage(ReceiptImageSource source) async {
    final picker = ImagePicker();
    ImageSource imageSource;
    switch (source) {
      case ReceiptImageSource.camera:
        imageSource = ImageSource.camera;
        break;
      case ReceiptImageSource.gallery:
        imageSource = ImageSource.gallery;
        break;
    }
    final pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile == null) {
      return null;
    } else {
      final correctedFile = await compressAndCorrectOrientation(pickedFile);
      if (correctedFile == null) {
        return null;
      } else {
        return ReceiptImage(
          path: correctedFile.path,
          mimeType: correctedFile.mimeType,
          name: correctedFile.name,
        );
      }
    }
  }

  @override
  Future<XFile?> compressAndCorrectOrientation(XFile image) async {
    final dir = await getTemporaryDirectory();
    final targetPath =
        join(dir.absolute.path, "${DateTime.now().millisecondsSinceEpoch}.jpg");

    const desiredSize = 1080;

    final result = await FlutterImageCompress.compressAndGetFile(
      image.path,
      targetPath,
      quality: 80,
      format: CompressFormat.jpeg,
      minWidth: desiredSize,
      minHeight: desiredSize,
    );

    if (result != null) {
      final originalSize = await image.length();
      final compressedSize = await result.length();
      LogService.i(
          'Compressed image from ${originalSize / 1024}KB to ${compressedSize / 1024}KB');
    }

    return result;
  }
}
