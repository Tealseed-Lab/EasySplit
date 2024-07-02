import 'dart:io';

import 'package:easysplit_flutter/common/models/api/image_response_payload.dart';

abstract class ApiService {
  Future<ImageResponsePayload> processImage(File file);
}
