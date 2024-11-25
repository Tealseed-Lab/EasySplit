import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:easysplit_flutter/common/services/log_service.dart';
import 'package:easysplit_flutter/common/services/interfaces/image_service.dart';

part 'sample_help_store.g.dart';

@LazySingleton()
class SampleHelpStore = SampleHelpStoreBase with _$SampleHelpStore;

abstract class SampleHelpStoreBase with Store {
  final ImageService _imageService;

  SampleHelpStoreBase(this._imageService);

  @action
  Future<XFile?> pickSamplePicture(String samplePath) async {
    try {
      // Load the asset as bytes
      final byteData = await rootBundle.load(samplePath);

      // Get a temporary directory and save the asset file there
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/${samplePath.split('/').last}');
      await tempFile.writeAsBytes(byteData.buffer.asUint8List());

      LogService.i("Sample picture saved temporarily: ${tempFile.path}");

      // Create an XFile instance from the temporary file path
      final XFile picture = XFile(tempFile.path);

      // Compress and correct orientation
      final compressedFile =
          await _imageService.compressAndCorrectOrientation(picture);
      return compressedFile; // Return the compressed image file
    } catch (e) {
      LogService.e("Error handling sample picture: $e");
      return null;
    }
  }
}
