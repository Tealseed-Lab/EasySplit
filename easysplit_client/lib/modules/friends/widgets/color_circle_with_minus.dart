import 'package:easysplit_flutter/common/models/friends/friend.dart';
import 'package:flutter/material.dart';

import 'color_circle.dart';

class ColorCircleWithMinus extends StatelessWidget {
  final Friend friend;
  final VoidCallback onTap;

  const ColorCircleWithMinus(
      {super.key, required this.friend, required this.onTap});

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
            ColorCircle(
              size: 36,
              text: friend.name[0],
              color: friend.color,
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
