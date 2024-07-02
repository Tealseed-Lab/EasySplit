import 'package:easysplit_flutter/common/services/interfaces/image_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

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
      return ReceiptImage(
        path: pickedFile.path,
        mimeType: pickedFile.mimeType,
        name: pickedFile.name,
      );
    }
  }
}
