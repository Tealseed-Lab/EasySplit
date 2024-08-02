import 'package:easysplit_flutter/common/utils/constants/constants.dart';
import 'package:easysplit_flutter/common/widgets/buttons/circular_icon_button.dart';
import 'package:flutter/material.dart';

class AddItemPlaceholder extends StatelessWidget {
  final VoidCallback onAdd;

  const AddItemPlaceholder({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onAdd,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularIconButton(
                  iconSize: 24,
                  backgroundSize: 36,
                  backgroundColor: Color(0xFFF4F4F4),
                  svgIconPath: 'assets/svg/add.svg',
                ),
                const SizedBox(height: 16),
                Text(
                  addItemPlaceholder,
                  style: TextStyle(
                      fontSize: 16, color: Colors.black.withOpacity(0.5)),
                ),
              ],
            )),
          ),
        ));
  }
}
