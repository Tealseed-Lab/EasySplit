import 'package:easysplit_flutter/common/utils/constants/constants.dart';
import 'package:easysplit_flutter/di/locator.dart';
import 'package:easysplit_flutter/modules/bills/stores/receipt_store.dart';
import 'package:easysplit_flutter/modules/friends/stores/friend_store.dart';
import 'package:easysplit_flutter/modules/friends/widgets/color_circle_with_minus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ItemCard extends StatelessWidget {
  final Map<String, dynamic> item;

  ItemCard({super.key, required this.item});

  final _receiptStore = locator<ReceiptStore>();
  final _friendStore = locator<FriendStore>();

  @override
  Widget build(BuildContext context) {
    final itemIndex = _receiptStore.items.indexOf(item);
    _receiptStore.cleanupItemAssignments();

    return Observer(
      builder: (_) => Container(
        padding: const EdgeInsets.all(4),
        child: Container(
          padding: const EdgeInsets.all(8.0),
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
                            fontSize: 36.0, fontWeight: FontWeight.w600)),
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
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.grey,
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: _receiptStore.itemAssignments[itemIndex] ==
                                null ||
                            _receiptStore.itemAssignments[itemIndex]!.isEmpty
                        ? [
                            Container(
                                padding: const EdgeInsets.all(4.0),
                                width: 36.0,
                                height: 36.0,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFF4F4F4),
                                )),
                          ]
                        : _receiptStore.itemAssignments[itemIndex]
                                ?.map((personId) {
                              final friend =
                                  _friendStore.getFriendById(personId);
                              return ColorCircleWithMinus(
                                friend: friend!,
                                onTap: () => _receiptStore.removePersonFromItem(
                                    itemIndex, personId),
                              );
                            }).toList() ??
                            [],
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
                    width: 224,
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
