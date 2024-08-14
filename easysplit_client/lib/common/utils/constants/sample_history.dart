import 'package:easysplit_flutter/common/models/history/history.dart';
import 'package:easysplit_flutter/common/services/log_service.dart';
import 'package:flutter/services.dart';

Future<History> loadSampleHistory() async {
  final ByteData imageData =
      await rootBundle.load('assets/png/sample_bill_image.png');
  final Uint8List imageBlob = imageData.buffer.asUint8List();
  LogService.i('Loaded sample history');

  return History(
      id: 0,
      createdAt: 1727004400000,
      total: 180.28,
      friendsList:
          '[{"name":"Chandler","color":"ffb3ea31"},{"name":"Ross","color":"ffb38cff"},{"name":"Joey","color":"ff01bda4"},{"name":"Monica","color":"ffffa5ae"},{"name":"Rachel","color":"fffb7472"},{"name":"Phoebe","color":"fffdd91f"}]',
      imageBlob: imageBlob,
      items:
          '[{"key":1,"name":"Cucumber soup","price":3.50},{"key":2,"name":"Side salad","price":4.75},{"key":3,"name":"Chicken Pizza","price":6.50},{"key":4,"name":"Cajun Catfish","price":33.0},{"key":5,"name":"Carpaccio","price":49.9},{"key":6,"name":"Grilled Prawns","price":53.9}]',
      additionalCharges:
          '[{"amount":15.10,"key":1,"name":"Service Charge"},{"amount":13.63,"key":2,"name":"GST"}]',
      additionalDiscounts: '[{"amount":0,"key":1,"name":"Discount"}]',
      deletedAt: null,
      location:
          "https://raw.githubusercontent.com/Tealseed-Lab/EasySplit/main/images/sample_receipt.png");
}
