import 'package:cached_network_image/cached_network_image.dart';
import 'package:easysplit_flutter/common/repositories/interfaces/guide_repository.dart';
import 'package:easysplit_flutter/common/stores/guide_store.dart';
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
import 'package:easysplit_flutter/modules/friends/widgets/friend_with_bill.dart';
import 'package:easysplit_flutter/modules/friends/widgets/pax.dart';
import 'package:easysplit_flutter/modules/images/pages/full_size_image_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  final GuideStore _guideStore = locator<GuideStore>();

  final ReceiptStore _receiptStore = locator<ReceiptStore>();
  final FriendStore _friendStore = locator<FriendStore>();

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
      body: Stack(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        NavigationButton(
                          pageName: 'home',
                          confirmMessage:
                              _receiptStore.itemAssignments.isNotEmpty
                                  ? clearContentMessage
                                  : null,
                        ),
                        if (_receiptStore.receiptLink != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullSizeImagePage(
                                        imageUrl: _receiptStore.receiptLink!),
                                  ),
                                );
                              },
                              child: Container(
                                height: 48,
                                width: 48,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: CachedNetworkImage(
                                    imageUrl: _receiptStore.receiptLink!,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        Container(
                          padding: const EdgeInsets.only(top: 24),
                          child: IconButton(
                            padding: const EdgeInsets.all(0),
                            icon: const CircularIconButton(
                              iconSize: 24,
                              backgroundSize: 48,
                              svgIconPath: 'assets/svg/check_small.svg',
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
                                  width: 232,
                                  child: ItemCard(item: item),
                                ),
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  right: 0,
                                  height: 122,
                                  child: GestureDetector(
                                    onTap: () =>
                                        _navigateToEditItem(context, item),
                                  ),
                                ),
                              ],
                            );
                          }),
                          SizedBox(
                            height: 272,
                            width: 232,
                            child: AddItemPlaceholder(
                              onAdd: () => _navigateToCreateItem(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Charges(),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
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
                          alignment: Alignment.topRight,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final double screenWidth = constraints.maxWidth;
                              final double containerWidth = screenWidth * 0.55;

                              return Container(
                                width: containerWidth,
                                padding: const EdgeInsets.only(right: 36.0),
                                child: Image.asset(
                                    'assets/png/guide_friends.png',
                                    fit: BoxFit.cover),
                              );
                            },
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Observer(
                      builder: (_) {
                        const space = 8.0;
                        final selectedFriends = _friendStore.friends
                            .where((friend) => friend.isSelected)
                            .toList();
                        return SingleChildScrollView(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
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
                                        child: FriendWithBill(
                                          friend: friend,
                                          isDraggable: true,
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
          Observer(
            builder: (_) {
              if (_receiptStore.items.isNotEmpty &&
                  _friendStore.friends
                      .where((friend) => friend.isSelected)
                      .isNotEmpty &&
                  _guideStore.splitGuideState == GuideState.notViewed) {
                return Stack(
                  children: [
                    Container(
                      color: Colors.black.withOpacity(0.3),
                    ),
                    Positioned(
                      top: 324,
                      left: 38,
                      child: Image.asset(
                        'assets/png/guide_drag.png',
                        width: 100,
                      ),
                    ),
                    Positioned(
                      top: 400,
                      right: 24,
                      child: GestureDetector(
                        onTap: () {
                          _guideStore.setSplitGuideViewed();
                        },
                        child: SvgPicture.asset(
                          'assets/svg/guide_pop.svg',
                          width: 282,
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}
