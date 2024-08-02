import 'package:easysplit_flutter/common/models/history/history.dart';
import 'package:easysplit_flutter/common/services/log_service.dart';
import 'package:flutter/services.dart';

Future<History> loadSampleHistory() async {
  final ByteData imageData =
      await rootBundle.load('assets/png/sample_receipt.png');
  final Uint8List imageBlob = imageData.buffer.asUint8List();
  LogService.i('Loaded sample history');

  return History(
    id: 0,
    createdAt: 814096800000,
    total: 170.69,
    friendsList:
        '[{"name":"Chandler","color":"ffb3ea31"},{"name":"Ross","color":"ffb38cff"},{"name":"Joey","color":"ff01bda4"},{"name":"Monica","color":"ffffa5ae"},{"name":"Rachel","color":"fffb7472"},{"name":"Phoebe","color":"fffdd91f"}]',
    imageBlob: imageBlob,
    items:
        '[{"key":1,"name":"House Salad","price":6.5},{"key":2,"name":"Side Salad","price":4.75},{"key":3,"name":"Cup of Soup","price":3.5},{"key":4,"name":"Entrecôte Steak","price":26.95},{"key":5,"name":"Mahi-mahi","price":24.95},{"key":6,"name":"Steamed Lobster","price":33},{"key":7,"name":"Opus One","price":45}]',
    additionalCharges:
        '[{"amount":14.47,"key":1,"name":"Service Charge"},{"amount":11.57,"key":2,"name":"GST"}]',
    additionalDiscounts: '[{"amount":0,"key":1,"name":"Discount"}]',
    deletedAt: null,
  );
}
