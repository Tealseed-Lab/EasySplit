import 'package:easysplit_flutter/common/utils/constants/constants.dart';
import 'package:easysplit_flutter/common/widgets/buttons/navigation_button.dart';
import 'package:easysplit_flutter/common/widgets/forms/form_widget.dart';
import 'package:easysplit_flutter/modules/bills/stores/receipt_store.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateItemPage extends StatefulWidget {
  final ReceiptStore receiptStore;
  final double? scrollPosition;

  const CreateItemPage(
      {super.key, required this.receiptStore, this.scrollPosition});

  @override
  State<StatefulWidget> createState() {
    return _CreateItemPageState();
  }
}

class _CreateItemPageState extends State<CreateItemPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  void _save() {
    final newItem = {
      'name': nameController.text,
      'price': double.parse(priceController.text),
    };
    widget.receiptStore.addItem(newItem);
    context.go('/bill', extra: {'scrollPosition': widget.scrollPosition});
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    super.dispose();
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
            NavigationButton(
                pageName: 'bill',
                svgIconPath: 'assets/svg/close.svg',
                extra: {'scrollPosition': widget.scrollPosition}),
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
