import 'dart:io';

import 'package:easysplit_flutter/common/services/interfaces/api_service.dart';
import 'package:easysplit_flutter/common/services/interfaces/image_service.dart';
import 'package:easysplit_flutter/common/services/log_service.dart';
import 'package:easysplit_flutter/di/locator.dart';
import 'package:easysplit_flutter/modules/bills/stores/receipt_store.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'image_store.g.dart';

@Singleton()
class ImageStore = ImageStoreBase with _$ImageStore;

abstract class ImageStoreBase with Store {
  final ImageService _imageService;
  final ApiService _apiService;
  final _receiptStore = locator<ReceiptStore>();

  @observable
  bool noTextDetected = false;

  ImageStoreBase(
    this._imageService,
    this._apiService,
  );

  @action
  Future<File?> pickImageFromSource(ReceiptImageSource source) async {
    try {
      final pickedFile = await _imageService.pickImage(source);
      if (pickedFile == null) {
        LogService.i('Picked file is null');
        return null;
      }
      final file = File(pickedFile.path);
      LogService.i('Picked file: ${pickedFile.path}');
      return file;
    } catch (e) {
      LogService.e('Failed to pick image: $e');
      rethrow;
    }
  }

  @action
  Future<bool> uploadImage(File file) async {
    try {
      final processImagePayload = await _apiService.processImage(file);
      LogService.i('Successfully processed image through api');

      if (processImagePayload.noTextDetected == true) {
        LogService.i('No text detected in image');
        noTextDetected = true;
        return false;
      }

      noTextDetected = false;
      _receiptStore.setReceiptData(processImagePayload.data);
      return true;
    } catch (e) {
      LogService.e('Failed to process image: $e');
      noTextDetected = false;
      return false;
    }
  }
}
