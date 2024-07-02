import 'package:easysplit_flutter/di/locator.dart';
import 'package:easysplit_flutter/modules/bills/stores/receipt_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';

class Charges extends StatelessWidget {
  final ReceiptStore _receiptStore = locator<ReceiptStore>();

  Charges({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final chargesAndDiscounts = [
          ..._receiptStore.additionalCharges,
          ..._receiptStore.additionalDiscounts
        ];

        return SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: chargesAndDiscounts.length,
            itemBuilder: (context, index) {
              final charge = chargesAndDiscounts[index];
              final amount = charge['amount'];
              final isDiscount =
                  index >= _receiptStore.additionalCharges.length;

              return GestureDetector(
                onTap: () {
                  final adjustedIndex = isDiscount
                      ? index - _receiptStore.additionalCharges.length
                      : index;

                  context.go(
                    '/editCharge',
                    extra: {
                      'charge': charge,
                      'index': adjustedIndex,
                      'isDiscount': isDiscount,
                    },
                  );
                },
                child: Container(
                  width: (MediaQuery.of(context).size.width -
                          32 -
                          (8 * (chargesAndDiscounts.length - 1))) /
                      chargesAndDiscounts.length,
                  margin: EdgeInsets.only(
                    left: index == 0 ? 0 : 4,
                    right: index == chargesAndDiscounts.length - 1 ? 0 : 4,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        charge['name'],
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            overflow: TextOverflow.ellipsis,
                            color: Color.fromARGB(223, 60, 59, 59)),
                      ),
                      Container(
                        width: 150,
                        height: 45,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          isDiscount ? '-\$${amount.abs()}' : '\$$amount',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
