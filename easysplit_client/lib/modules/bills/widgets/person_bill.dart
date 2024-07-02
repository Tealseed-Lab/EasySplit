import 'package:easysplit_flutter/di/locator.dart';
import 'package:easysplit_flutter/modules/bills/stores/receipt_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class PersonBill extends StatelessWidget {
  final int personIndex;
  final Color? billColor;

  final _receiptStore = locator<ReceiptStore>();

  PersonBill({super.key, required this.personIndex, this.billColor});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final billAmount = _receiptStore.calculatePersonBill(personIndex);
        final displayAmount =
            billAmount.isNaN ? '0.00' : billAmount.toStringAsFixed(2);
        return Text(
          '\$$displayAmount',
          style: TextStyle(
            fontSize: 16,
            color: billColor ?? Colors.white,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        );
      },
    );
  }
}
