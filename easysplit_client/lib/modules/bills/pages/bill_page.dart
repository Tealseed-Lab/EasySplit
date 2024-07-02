import 'package:easysplit_flutter/common/utils/constants/constants.dart';
import 'package:easysplit_flutter/common/widgets/buttons/circular_icon_button.dart';
import 'package:easysplit_flutter/common/widgets/buttons/navigation_button.dart';
import 'package:easysplit_flutter/di/locator.dart';
import 'package:easysplit_flutter/modules/bills/stores/receipt_store.dart';
import 'package:easysplit_flutter/modules/bills/widgets/add_item_placeholder.dart';
import 'package:easysplit_flutter/modules/bills/widgets/animated_total.dart';
import 'package:easysplit_flutter/modules/bills/widgets/charges.dart';
import 'package:easysplit_flutter/modules/bills/widgets/item_card.dart';
import 'package:easysplit_flutter/modules/bills/widgets/person_bill.dart';
import 'package:easysplit_flutter/modules/bills/widgets/person_circle.dart';
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Observer(
                      builder: (_) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: AnimatedTotal(receiptStore: _receiptStore),
                          ),
                          Row(
                            children: [
                              Text(
                                'Pax:',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.5),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 16),
                              InkWell(
                                onTap: _receiptStore.pax > 2
                                    ? () => _receiptStore.decreasePax()
                                    : null,
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Transform.translate(
                                      offset: const Offset(0, -3),
                                      child: const Text(
                                        "-",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 22,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                '${_receiptStore.pax}',
                                style: const TextStyle(
                                    fontSize: 28,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(width: 16),
                              InkWell(
                                onTap: _receiptStore.pax < 8
                                    ? () => _receiptStore.increasePax()
                                    : null,
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Transform.translate(
                                      offset: const Offset(0, -3),
                                      child: const Text(
                                        "+",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 22,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 140,
                      width: MediaQuery.of(context).size.width,
                      child: Observer(
                        builder: (_) => GridView.count(
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 4,
                          crossAxisSpacing:
                              MediaQuery.of(context).size.width / 3 - 120,
                          childAspectRatio: 0.7,
                          padding: EdgeInsets.zero,
                          children: List.generate(_receiptStore.pax, (index) {
                            return Column(
                              children: [
                                Draggable<int>(
                                  data: index + 1,
                                  feedback: PersonCircle(
                                    size: 69,
                                    index: index + 1,
                                    fontSize: 32.0,
                                  ),
                                  child: PersonCircle(
                                    size: 69,
                                    index: index + 1,
                                    fontSize: 32.0,
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                PersonBill(personIndex: index + 1),
                              ],
                            );
                          }),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
