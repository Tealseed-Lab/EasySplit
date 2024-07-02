import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CircularIconButton extends StatelessWidget {
  final double iconSize;
  final double backgroundSize;
  final Color? backgroundColor;
  final String? svgIconPath;

  const CircularIconButton({
    super.key,
    required this.iconSize,
    required this.backgroundSize,
    this.backgroundColor,
    this.svgIconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: backgroundSize,
      height: backgroundSize,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        shape: BoxShape.circle,
      ),
      child: Center(
          child: SvgPicture.asset(
        svgIconPath!,
        width: iconSize,
        height: iconSize,
      )),
    );
  }
}
