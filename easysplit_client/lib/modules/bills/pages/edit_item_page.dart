import 'package:easysplit_flutter/common/utils/constants/constants.dart';
import 'package:easysplit_flutter/common/widgets/buttons/circular_icon_button.dart';
import 'package:easysplit_flutter/common/widgets/buttons/navigation_button.dart';
import 'package:easysplit_flutter/common/widgets/forms/form_widget.dart';
import 'package:easysplit_flutter/modules/bills/stores/receipt_store.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditItemPage extends StatefulWidget {
  final Map<String, dynamic> item;
  final int index;
  final ReceiptStore receiptStore;
  final double? scrollPosition;

  const EditItemPage({
    super.key,
    required this.item,
    required this.index,
    required this.receiptStore,
    this.scrollPosition,
  });

  @override
  State<StatefulWidget> createState() {
    return _EditItemPageState();
  }
}

class _EditItemPageState extends State<EditItemPage> {
  late TextEditingController nameController;
  late TextEditingController priceController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.item['name']);
    priceController =
        TextEditingController(text: widget.item['price'].toString());
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    super.dispose();
  }

  void _save() {
    final updatedItem = {
      'key': widget.item['key'],
      'name': nameController.text,
      'price': double.parse(priceController.text),
    };
    widget.receiptStore.updateItem(widget.index, updatedItem);
    context.go('/bill', extra: {'scrollPosition': widget.scrollPosition});
  }

  void _delete() {
    final updatedItem = {
      'key': widget.item['key'],
      'name': widget.item['name'],
      'price': 0.0,
    };
    widget.receiptStore.updateItem(widget.index, updatedItem);
    context.go('/bill', extra: {'scrollPosition': widget.scrollPosition});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                NavigationButton(
                    pageName: 'bill',
                    svgIconPath: 'assets/svg/close.svg',
                    extra: {'scrollPosition': widget.scrollPosition}),
                Container(
                  padding: const EdgeInsets.only(top: 24),
                  child: IconButton(
                    padding: const EdgeInsets.all(0),
                    icon: const CircularIconButton(
                      iconSize: 24,
                      backgroundSize: 48,
                      svgIconPath: 'assets/svg/delete.svg',
                    ),
                    onPressed: _delete,
                  ),
                )
              ],
            ),
            Expanded(
              child: EditFormWidget(
                nameController: nameController,
                amountController: priceController,
                nameLabel: itemNamePlaceholder,
                amountLabel: 'Price',
                onSave: _save,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
