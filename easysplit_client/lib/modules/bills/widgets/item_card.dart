import 'package:easysplit_flutter/common/utils/constants/constants.dart';
import 'package:easysplit_flutter/di/locator.dart';
import 'package:easysplit_flutter/modules/bills/stores/item_card_store.dart';
import 'package:easysplit_flutter/modules/bills/stores/receipt_store.dart';
import 'package:easysplit_flutter/modules/friends/stores/friend_store.dart';
import 'package:easysplit_flutter/modules/friends/widgets/color_circle.dart';
import 'package:easysplit_flutter/modules/friends/widgets/color_circle_with_minus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final double? outerPadding;
  final double? innerPadding;
  final bool? overlay;

  ItemCard(
      {super.key,
      required this.item,
      this.outerPadding,
      this.innerPadding,
      this.overlay = false});

  final _receiptStore = locator<ReceiptStore>();
  final _friendStore = locator<FriendStore>();
  final _itemCardStore = locator<ItemCardStore>();

  @override
  Widget build(BuildContext context) {
    final itemIndex = _receiptStore.items.indexOf(item);
    _receiptStore.cleanupItemAssignments();

    return Observer(
      builder: (_) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Container(
          padding: EdgeInsets.all(outerPadding ?? 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                    child: Text('\$${item['price']}',
                        style: const TextStyle(
                          fontSize: 36.0,
                          fontWeight: FontWeight.w600,
                          height: 1.0,
                        )),
                  ),
                  const SizedBox(height: 8.0),
                  SizedBox(
                      height: 44,
                      child: Text(
                        item['name'],
                        style: const TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                            fontSize: 16.0),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    height: 24,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          payByText,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            bool? newValue = _receiptStore
                                    .itemAssignments[itemIndex]?.length !=
                                _friendStore.selectedFriendsCount;
                            if (newValue == true) {
                              _receiptStore.assignAllPeopleToItem(itemIndex);
                            } else {
                              _receiptStore.clearAssignmentsFromItem(itemIndex);
                            }
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                side: const BorderSide(
                                  color: Colors.transparent,
                                  width: 1.0,
                                ),
                                value: _receiptStore
                                        .itemAssignments[itemIndex]?.length ==
                                    _friendStore.selectedFriendsCount,
                                onChanged: (bool? value) {
                                  if (value == true) {
                                    _receiptStore
                                        .assignAllPeopleToItem(itemIndex);
                                  } else {
                                    _receiptStore
                                        .clearAssignmentsFromItem(itemIndex);
                                  }
                                },
                                fillColor:
                                    WidgetStateProperty.resolveWith((states) {
                                  if (states.contains(WidgetState.selected)) {
                                    return Theme.of(context).primaryColor;
                                  }
                                  return const Color(0xFFF4F4F4);
                                }),
                              ),
                              Text(
                                byAllText,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 2 * (innerPadding ?? 8.0),
                    child: Center(
                      child: Container(
                        width: double.infinity,
                        height: 1,
                        color: Colors.black.withOpacity(0.06),
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: innerPadding ?? 8.0,
                    runSpacing: innerPadding ?? 8.0,
                    children: _receiptStore.itemAssignments[itemIndex] ==
                                null ||
                            _receiptStore.itemAssignments[itemIndex]!.isEmpty
                        ? [
                            Container(
                              padding: const EdgeInsets.only(top: 6),
                              child: Container(
                                  width: 36.0,
                                  height: 36.0,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFF4F4F4),
                                  )),
                            ),
                          ]
                        : (_receiptStore.itemAssignments[itemIndex]!.length >
                                    8 &&
                                !overlay!)
                            ? [
                                ..._receiptStore.itemAssignments[itemIndex]!
                                    .take(7)
                                    .map((personId) {
                                  final friend =
                                      _friendStore.getFriendById(personId);
                                  return ColorCircleWithMinus(
                                    friend: friend!,
                                    onTap: () =>
                                        _receiptStore.removePersonFromItem(
                                            itemIndex, personId),
                                  );
                                }),
                                GestureDetector(
                                  onTap: () => _itemCardStore.showOverlay(item),
                                  child: Container(
                                    width: 42.0,
                                    height: 42.0,
                                    alignment: Alignment.bottomLeft,
                                    child: ColorCircle(
                                      size: 36,
                                      text:
                                          "+${_receiptStore.itemAssignments[itemIndex]!.length - 7}",
                                      color: const Color(0xFFF4F4F4),
                                      fontSize: 16.0,
                                      textColor: Colors.black,
                                      textWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ]
                            : _receiptStore.itemAssignments[itemIndex]!
                                .map((personId) {
                                final friend =
                                    _friendStore.getFriendById(personId);
                                return ColorCircleWithMinus(
                                  friend: friend!,
                                  onTap: () =>
                                      _receiptStore.removePersonFromItem(
                                          itemIndex, personId),
                                );
                              }).toList(),
                  ),
                  if (_receiptStore.itemAssignments[itemIndex] == null ||
                      _receiptStore.itemAssignments[itemIndex]!.isEmpty)
                    const Column(children: [
                      SizedBox(height: 16),
                      Center(
                        child: Text(
                          dragPersonPlaceholderText,
                          style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 0.2),
                            fontSize: 13.0,
                          ),
                        ),
                      ),
                    ]),
                ],
              ),
              DragTarget<int>(
                onAcceptWithDetails: (details) {
                  _receiptStore.assignPersonToItem(itemIndex, details.data);
                },
                builder: (context, candidateData, rejectedData) {
                  return const SizedBox(
                    height: 272,
                    width: 232,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
