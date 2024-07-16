import 'package:easysplit_flutter/common/utils/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditFormWidget extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController amountController;
  final String nameLabel;
  final String amountLabel;
  final bool isItem;
  final VoidCallback onSave;

  const EditFormWidget({
    super.key,
    required this.nameController,
    required this.amountController,
    required this.nameLabel,
    required this.amountLabel,
    this.isItem = true,
    required this.onSave,
  });

  @override
  State<StatefulWidget> createState() {
    return _EditFormWidgetState();
  }
}

class _EditFormWidgetState extends State<EditFormWidget>
    with WidgetsBindingObserver {
  final FocusNode _focusNode = FocusNode();

  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateKeyboardVisibility();
      FocusScope.of(context).requestFocus(_focusNode);
    });

    widget.nameController.addListener(_updateButtonState);
    widget.amountController.addListener(_updateButtonState);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    _updateKeyboardVisibility();
  }

  void _updateKeyboardVisibility() {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    setState(() {
      _isKeyboardVisible = bottomInset > 0;
    });
  }

  bool get _isFormValid {
    final price = double.tryParse(widget.amountController.text) ?? -1.0;
    if (widget.isItem) {
      return widget.nameController.text.isNotEmpty &&
          widget.amountController.text.isNotEmpty &&
          price > 0 &&
          price < 1000000000;
    } else {
      return widget.nameController.text.isNotEmpty &&
          widget.amountController.text.isNotEmpty &&
          price >= 0 &&
          price < 100000000;
    }
  }

  void _updateButtonState() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.nameController.removeListener(_updateButtonState);
    widget.amountController.removeListener(_updateButtonState);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 73,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '\$',
                        style: TextStyle(
                            color: widget.amountController.text.isEmpty
                                ? Colors.grey
                                : Colors.black,
                            fontSize: 36,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        focusNode: _focusNode,
                        controller: widget.amountController,
                        decoration: const InputDecoration(
                          hintText: '0.00',
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 36,
                              fontWeight: FontWeight.w600),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*')),
                        ],
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 36,
                            fontWeight: FontWeight.w600),
                        cursorColor: const Color.fromRGBO(13, 170, 220, 1),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (widget.isItem)
                Container(
                  height: 54,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: widget.nameController,
                    decoration: const InputDecoration(
                      hintText: itemNamePlaceholder,
                      hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                    cursorColor: const Color.fromRGBO(13, 170, 220, 1),
                  ),
                ),
            ],
          ),
        ),
        Positioned(
          bottom:
              _isKeyboardVisible ? MediaQuery.of(context).viewInsets.bottom : 0,
          right: 0,
          child: SizedBox(
            width: 48,
            height: 48,
            child: FloatingActionButton(
              onPressed: _isFormValid ? widget.onSave : null,
              backgroundColor: Colors.white,
              shape: const CircleBorder(),
              elevation: 0,
              child: Icon(
                Icons.check,
                color: _isFormValid ? Colors.black : Colors.grey,
                size: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
