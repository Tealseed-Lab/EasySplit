import 'package:flutter/material.dart';

class PersonCircle extends StatelessWidget {
  final double size;
  final int index;
  final double fontSize;

  const PersonCircle(
      {super.key,
      required this.size,
      required this.index,
      required this.fontSize});

  @override
  Widget build(BuildContext context) {
    final colors = [
      const Color(0xFFFDD91F),
      const Color(0xFFFB7472),
      const Color(0xFFFFA5AE),
      const Color(0xFF01BDA4),
      const Color(0xFFB38CFF),
      const Color(0xFFB3EA31),
      const Color(0xFFFCA952),
      const Color(0xFF8B99A6),
    ];
    final color = colors[index - 1];

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: Center(
        child: Text(
          '$index',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: fontSize,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
