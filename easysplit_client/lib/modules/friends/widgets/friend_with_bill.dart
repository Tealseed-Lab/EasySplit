import 'package:easysplit_flutter/common/models/friends/friend.dart';
import 'package:easysplit_flutter/di/locator.dart';
import 'package:easysplit_flutter/modules/bills/stores/receipt_store.dart';
import 'package:easysplit_flutter/modules/friends/utils/friend_with_bill_utils.dart';
import 'package:easysplit_flutter/modules/friends/widgets/color_circle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class FriendWithBill extends StatelessWidget {
  final Friend friend;
  final Color? backgroundColor;
  final bool isDraggable;

  FriendWithBill(
      {super.key,
      required this.friend,
      this.backgroundColor,
      this.isDraggable = false});

  final _receiptStore = locator<ReceiptStore>();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final minWidth = maxWidth / 2;

        return Observer(
          builder: (_) {
            final billAmount =
                '\$${_receiptStore.calculatePersonBill(friend.id).toStringAsFixed(2)}';
            final widgetWidth = calculateWidgetWidth(
                friend.name, billAmount, maxWidth, minWidth);

            return Container(
              height: 58,
              width: widgetWidth,
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
              decoration: BoxDecoration(
                color: backgroundColor ?? Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(100.0),
              ),
              child: Row(
                children: [
                  if (isDraggable)
                    Draggable<int>(
                      data: friend.id,
                      feedback: ColorCircle(
                        size: 69,
                        text: friend.name[0],
                        color: friend.color,
                        fontSize: 32.0,
                      ),
                      child: ColorCircle(
                        size: 36,
                        text: friend.name[0],
                        color: friend.color,
                        fontSize: 16.0,
                      ),
                    )
                  else
                    ColorCircle(
                      size: 36,
                      text: friend.name[0],
                      color: friend.color,
                      fontSize: 16.0,
                    ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          friend.name,
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w400),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          billAmount,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
