import 'package:easysplit_flutter/common/utils/constants/constants.dart';
import 'package:easysplit_flutter/common/widgets/buttons/circular_icon_button.dart';
import 'package:easysplit_flutter/common/widgets/buttons/navigation_button.dart';
import 'package:easysplit_flutter/di/locator.dart';
import 'package:easysplit_flutter/modules/bills/stores/receipt_store.dart';
import 'package:easysplit_flutter/modules/bills/widgets/add_item_placeholder.dart';
import 'package:easysplit_flutter/modules/bills/widgets/animated_total.dart';
import 'package:easysplit_flutter/modules/bills/widgets/charges.dart';
import 'package:easysplit_flutter/modules/bills/widgets/item_card.dart';
import 'package:easysplit_flutter/modules/friends/stores/friend_store.dart';
import 'package:easysplit_flutter/modules/friends/utils/friend_with_bill_utils.dart';
import 'package:easysplit_flutter/modules/friends/widgets/color_circle.dart';
import 'package:easysplit_flutter/modules/friends/widgets/friend_with_bill.dart';
import 'package:easysplit_flutter/modules/friends/widgets/pax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';

class BillPage extends StatefulWidget {
  final double? scrollPosition;

  const BillPage({super.key, this.scrollPosition});

  @override
  State<StatefulWidget> createState() {
    return _BillPageState();
  }
}

class _BillPageState extends State<BillPage> {
  final _receiptStore = locator<ReceiptStore>();
  final _friendStore = locator<FriendStore>();

  late ReactionDisposer _receiptDisposer;
  late ReactionDisposer _itemAssignmentsDisposer;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.scrollPosition != null) {
        _scrollController.jumpTo(widget.scrollPosition!);
      }
      _receiptDisposer = autorun((_) {
        if (_receiptStore.items.isNotEmpty && _receiptStore.total != 0) {
          setState(() {});
        }
      });

      _itemAssignmentsDisposer = reaction(
        (_) => _receiptStore.itemAssignments.entries
            .map((entry) => entry.value.toList())
            .toList(),
        (_) {
          setState(() {});
        },
      );

      _friendStore.loadFriends();
    });
  }

  @override
  void dispose() {
    _receiptDisposer();
    _itemAssignmentsDisposer();
    _scrollController.dispose();
    super.dispose();
  }

  void _navigateToEditItem(BuildContext context, Map<String, dynamic> item) {
    final scrollPosition = _scrollController.position.pixels;
    context.go(
      '/editItem',
      extra: {
        'item': item,
        'index': _receiptStore.items.indexOf(item),
        'scrollPosition': scrollPosition,
      },
    );
  }

  void _navigateToCreateItem(BuildContext context) {
    final scrollPosition = _scrollController.position.pixels;
    context.go(
      '/createItem',
      extra: {'receiptStore': _receiptStore, 'scrollPosition': scrollPosition},
    );
  }

  void _navigateToFriendsPage(BuildContext context) {
    final scrollPosition = _scrollController.position.pixels;
    context.go(
      '/friends',
      extra: {'scrollPosition': scrollPosition},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    NavigationButton(
                      pageName: 'camera',
                      confirmMessage: _receiptStore.itemAssignments.isNotEmpty
                          ? clearConstantMessage
                          : null,
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 20),
                      child: IconButton(
                        padding: const EdgeInsets.all(0),
                        icon: const CircularIconButton(
                          iconSize: 24,
                          backgroundSize: 48,
                          svgIconPath: 'assets/svg/share.svg',
                        ),
                        onPressed: () {
                          context.go('/shareBill');
                        },
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 272.0,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ..._receiptStore.items
                          .where((item) => item['price'] != 0)
                          .map<Widget>((item) {
                        return Stack(
                          children: [
                            SizedBox(
                              height: 272,
                              width: 224,
                              child: ItemCard(item: item),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              height: 122,
                              child: GestureDetector(
                                onTap: () => _navigateToEditItem(context, item),
                              ),
                            ),
                          ],
                        );
                      }),
                      SizedBox(
                        height: 272,
                        width: 224,
                        child: AddItemPlaceholder(
                          onAdd: () => _navigateToCreateItem(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Charges(),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Observer(
                  builder: (_) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: AnimatedTotal(receiptStore: _receiptStore),
                      ),
                      Pax(onTap: () => _navigateToFriendsPage(context)),
                    ],
                  ),
                ),
              ),
              Observer(
                builder: (_) {
                  if (_friendStore.friends
                      .where((friend) => friend.isSelected)
                      .toList()
                      .isEmpty) {
                    return Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 153,
                        width: 269,
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Image.asset('assets/png/guide.png'),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Observer(
                  builder: (_) {
                    const space = 8.0;
                    final selectedFriends = _friendStore.friends
                        .where((friend) => friend.isSelected)
                        .toList();
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Wrap(
                          spacing: space,
                          runSpacing: space,
                          children: [
                            for (var friend in selectedFriends)
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final maxWidth = constraints.maxWidth;
                                  final minWidth = (maxWidth - space) / 2;
                                  final billAmount =
                                      '\$${_receiptStore.calculatePersonBill(friend.id).toStringAsFixed(2)}';
                                  final widgetWidth = calculateWidgetWidth(
                                      friend.name,
                                      billAmount,
                                      maxWidth,
                                      minWidth);

                                  return SizedBox(
                                    width: widgetWidth,
                                    child: Draggable<int>(
                                      data: friend.id,
                                      feedback: ColorCircle(
                                        size: 69,
                                        text: friend.name[0],
                                        color: friend.color,
                                        fontSize: 32.0,
                                      ),
                                      child: FriendWithBill(friend: friend),
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
