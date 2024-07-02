import 'package:easysplit_flutter/common/utils/constants/constants.dart';
import 'package:easysplit_flutter/di/locator.dart';
import 'package:easysplit_flutter/modules/bills/stores/receipt_store.dart';
import 'package:easysplit_flutter/modules/bills/widgets/person_bill.dart';
import 'package:easysplit_flutter/modules/bills/widgets/person_circle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BillImage extends StatelessWidget {
  BillImage({super.key});

  final ReceiptStore receiptStore = locator<ReceiptStore>();

  @override
  Widget build(BuildContext context) {
    final chargesAndDiscounts = [
      ...receiptStore.additionalCharges,
      ...receiptStore.additionalDiscounts
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'Easy Split',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: SvgPicture.asset('assets/svg/bill_divider1.svg')),
          ...receiptStore.items
              .where((item) => item['price'] != 0)
              .map<Widget>((item) {
            int index = receiptStore.items.indexOf(item);
            final noAssignee = receiptStore.itemAssignments[index] == null ||
                receiptStore.itemAssignments[index]!.isEmpty;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: BillImageConstants.itemTextWidth,
                        child: RichText(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              text: item['name'],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                height: BillImageConstants.itemLineHeight / 16,
                                color: noAssignee
                                    ? BillImageConstants.unassignedItemColor
                                    : Colors.black,
                              ),
                            ))),
                    Text(
                      '\$${item['price'].toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: noAssignee
                            ? BillImageConstants.unassignedItemColor
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Column(
                  children: <Widget>[
                    if ((receiptStore
                                .itemAssignments[
                                    receiptStore.items.indexOf(item)]
                                ?.length ??
                            0) ==
                        receiptStore.pax)
                      SizedBox(
                          height: 22,
                          child: Text(
                            BillImageConstants.shareByAllText,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ))
                    else
                      Row(
                        children: receiptStore.itemAssignments[
                                    receiptStore.items.indexOf(item)]
                                ?.map<Widget>((personIndex) {
                              return Container(
                                  height: 24,
                                  padding: const EdgeInsets.only(right: 6.0),
                                  child: PersonCircle(
                                    size: 24,
                                    index: personIndex,
                                    fontSize: 12.0,
                                  ));
                            }).toList() ??
                            [],
                      ),
                    const SizedBox(height: 16),
                  ],
                )
              ],
            );
          }),
          SvgPicture.asset('assets/svg/bill_divider2.svg'),
          const SizedBox(height: 16.0),
          ...chargesAndDiscounts.map<Widget>((charge) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  charge['name'],
                  style: const TextStyle(
                    color: BillImageConstants.additionalChargesColor,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Text(
                  charge['amount'] < 0
                      ? '-\$${charge['amount'].abs().toStringAsFixed(2)}'
                      : '\$${charge['amount'].toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: BillImageConstants.additionalChargesColor,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            );
          }),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '\$${receiptStore.total.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SvgPicture.asset('assets/svg/bill_divider1.svg'),
          GridView.count(
            padding: const EdgeInsets.only(top: 18.0),
            crossAxisCount: 4,
            crossAxisSpacing: 16.0,
            childAspectRatio: 0.7,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: List.generate(receiptStore.pax, (index) {
              return Column(
                children: [
                  PersonCircle(
                    size: 69,
                    index: index + 1,
                    fontSize: 32.0,
                  ),
                  const SizedBox(height: 4),
                  PersonBill(personIndex: index + 1, billColor: Colors.black),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
