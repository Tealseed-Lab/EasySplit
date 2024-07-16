import 'package:flutter/material.dart';

class ColorCircle extends StatelessWidget {
  final double size;
  final String? text;
  final Color color;
  final double? fontSize;

  const ColorCircle({
    super.key,
    required this.size,
    this.text,
    required this.color,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: Center(
        child: Text(
          text ?? "",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: fontSize ?? size / 12,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
