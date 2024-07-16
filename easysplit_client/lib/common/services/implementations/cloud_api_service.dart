import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:easysplit_flutter/common/models/api/image_response_payload.dart';
import 'package:easysplit_flutter/common/services/interfaces/api_service.dart';
import 'package:easysplit_flutter/common/services/log_service.dart';
import 'package:easysplit_flutter/common/utils/env/env.dart';
import 'package:easysplit_flutter/common/utils/sessions/session_utils.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

@Singleton(as: ApiService)
class CloudApiService extends ApiService {
  final _uuid = const Uuid();

  @override
  Future<ImageResponsePayload> processImage(File file) async {
    final requestId = _uuid.v4();
    final startTime = DateTime.now();
    const method = 'POST';

    try {
      final url = Uri.parse('${Env.localBaseUrl}/api/v1/receipts/process');
      final request = http.MultipartRequest(method, url);

      // Get the session ID
      await SessionUtil.saveSessionId();
      String? sessionId = await SessionUtil.getSessionId();

      request.headers.addAll({
        'X-Request-ID': requestId,
        'User-Agent': 'EasySplit/1.0',
        'Session-ID': sessionId!,
      });

      request.files.add(
        http.MultipartFile.fromBytes(
          'receipt_image',
          File(file.path).readAsBytesSync(),
          filename: file.path,
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);

      LogService.i(
          'Request [$method] $url, requestId: $requestId, sessionId: $sessionId, statusCode: ${response.statusCode}, requestBody: null, responseBody: ${response.body}, startTime: ${startTime.toIso8601String()}, endTime: ${endTime.toIso8601String()}, duration: ${duration.inSeconds}s');

      final Map<String, dynamic> responseJson = json.decode(response.body);

      if (response.statusCode != 200) {
        throw Exception('Failed to upload image: ${responseJson['error']}');
      }

      final data = responseJson['data'];
      final noTextDetected = responseJson['no_text_detected'] as bool? ?? false;
      if (data == null) {
        throw Exception(
            'Invalid response format: data field is missing or null');
      }

      return ImageResponsePayload(
        data: data,
        noTextDetected: noTextDetected,
      );
    } catch (e, stackTrace) {
      LogService.e('Error processing image: $e, stack trace: $stackTrace');
      rethrow;
    }
  }
}
