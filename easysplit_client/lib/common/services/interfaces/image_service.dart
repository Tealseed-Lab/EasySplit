import 'package:cross_file/cross_file.dart';

enum ReceiptImageSource {
  camera,
  gallery,
}

class ReceiptImage {
  final String path;
  final String? mimeType;
  final String? name;
  ReceiptImage({
    required this.path,
    this.mimeType,
    this.name,
  });
}

abstract class ImageService {
  Future<ReceiptImage?> pickImage(ReceiptImageSource source);
  Future<XFile?> compressAndCorrectOrientation(XFile image);
}
