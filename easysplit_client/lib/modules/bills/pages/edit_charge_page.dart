import 'package:easysplit_flutter/common/widgets/buttons/navigation_button.dart';
import 'package:easysplit_flutter/common/widgets/forms/form_widget.dart';
import 'package:easysplit_flutter/modules/bills/stores/receipt_store.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditChargePage extends StatefulWidget {
  final Map<String, dynamic> charge;
  final int index;
  final bool isDiscount;
  final ReceiptStore receiptStore;

  const EditChargePage({
    super.key,
    required this.charge,
    required this.index,
    required this.isDiscount,
    required this.receiptStore,
  });

  @override
  State<StatefulWidget> createState() {
    return _EditChargePageState();
  }
}

class _EditChargePageState extends State<EditChargePage> {
  late TextEditingController nameController;
  late TextEditingController amountController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.charge['name']);
    amountController = TextEditingController(
        text: widget.isDiscount
            ? widget.charge['amount'].abs().toString()
            : widget.charge['amount'].toString());
  }

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    super.dispose();
  }

  void _save() {
    final updatedCharge = {
      'key': widget.charge['key'],
      'name': nameController.text,
      'amount': widget.isDiscount
          ? -double.parse(amountController.text)
          : double.parse(amountController.text),
    };
    if (widget.isDiscount) {
      widget.receiptStore.updateDiscount(widget.index, updatedCharge);
    } else {
      widget.receiptStore.updateCharge(widget.index, updatedCharge);
    }
    context.go('/bill');
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
            const NavigationButton(
              pageName: 'bill',
              svgIconPath: 'assets/svg/close.svg',
            ),
            Expanded(
              child: EditFormWidget(
                nameController: nameController,
                amountController: amountController,
                nameLabel: 'Charge Name',
                amountLabel: 'Amount',
                onSave: _save,
                isItem: false,
              ),
            )
          ],
        ),
      ),
    );
  }
}
