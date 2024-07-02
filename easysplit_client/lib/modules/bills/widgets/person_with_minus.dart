import 'package:flutter/material.dart';

import 'person_circle.dart';

class PersonWithMinus extends StatelessWidget {
  final int index;
  final VoidCallback onTap;

  const PersonWithMinus({super.key, required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        padding: const EdgeInsets.all(3.0),
        child: Stack(
          children: [
            PersonCircle(
              size: 36,
              index: index,
              fontSize: 16.0,
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 14,
                height: 14,
                decoration: const BoxDecoration(
                  color: Color(0xFFDEDEDE),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.remove,
                    size: 12,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
