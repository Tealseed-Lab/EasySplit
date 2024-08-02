import 'package:easysplit_flutter/common/utils/constants/constants.dart';
import 'package:easysplit_flutter/di/locator.dart';
import 'package:easysplit_flutter/modules/bills/stores/receipt_store.dart';
import 'package:easysplit_flutter/modules/friends/stores/friend_store.dart';
import 'package:easysplit_flutter/modules/friends/utils/friend_with_bill_utils.dart';
import 'package:easysplit_flutter/modules/friends/widgets/color_circle.dart';
import 'package:easysplit_flutter/modules/friends/widgets/friend_with_bill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BillImage extends StatelessWidget {
  BillImage({super.key});

  final ReceiptStore receiptStore = locator<ReceiptStore>();
  final FriendStore friendStore = locator<FriendStore>();

  @override
  Widget build(BuildContext context) {
    final chargesAndDiscounts = [
      ...receiptStore.additionalCharges,
      ...receiptStore.additionalDiscounts
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            'assets/svg/image_header.svg',
            width: 361,
            height: 82,
          ),
          const SizedBox(height: 16),
          ...receiptStore.items
              .where((item) => item['price'] != 0)
              .map<Widget>((item) {
            int index = receiptStore.items.indexOf(item);
            final noAssignee = receiptStore.itemAssignments[index] == null ||
                receiptStore.itemAssignments[index]!.isEmpty;
            final allSelectedFriendsAssigned =
                receiptStore.itemAssignments[index]?.length ==
                    friendStore.selectedFriendsCount;
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
                            fontWeight: FontWeight.w400,
                            height: BillImageConstants.itemLineHeight / 16,
                            color: noAssignee
                                ? BillImageConstants.unassignedItemColor
                                : Colors.black,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: SizedBox(
                        width: BillImageConstants.itemAmountWidth,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '\$${item['price'].toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: noAssignee
                                  ? BillImageConstants.unassignedItemColor
                                  : Colors.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                if (allSelectedFriendsAssigned)
                  SizedBox(
                    height: 22,
                    child: Text(
                      BillImageConstants.shareByAllText,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  )
                else
                  Row(
                    children: receiptStore.itemAssignments[index]
                            ?.map<Widget>((friendId) {
                          final friend = friendStore.getFriendById(friendId);
                          return Container(
                              height: 24,
                              padding: const EdgeInsets.only(right: 6.0),
                              child: ColorCircle(
                                size: 24,
                                text: friend?.name[0] ?? '',
                                color: friend?.color ?? Colors.grey,
                                fontSize: 12.0,
                              ));
                        }).toList() ??
                        [],
                  ),
                const SizedBox(height: 16),
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
          const SizedBox(height: 16),
          Expanded(
            child: Observer(
              builder: (_) {
                const space = 8.0;
                final selectedFriends = friendStore.friends
                    .where((friend) => friend.isSelected)
                    .toList();
                return Wrap(
                  spacing: space,
                  runSpacing: space,
                  children: [
                    for (var friend in selectedFriends)
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final maxWidth = constraints.maxWidth;
                          final minWidth = (maxWidth - space) / 2;
                          final billAmount =
                              '\$${receiptStore.calculatePersonBill(friend.id).toStringAsFixed(2)}';
                          final widgetWidth = calculateWidgetWidth(
                              friend.name, billAmount, maxWidth, minWidth);

                          return SizedBox(
                            width: widgetWidth,
                            child: FriendWithBill(
                                friend: friend,
                                backgroundColor: Colors.transparent),
                          );
                        },
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
