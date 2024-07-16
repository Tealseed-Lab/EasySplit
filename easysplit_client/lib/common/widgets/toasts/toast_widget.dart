import 'package:flutter/material.dart';

class ToastWidget extends StatelessWidget {
  final String text;

  const ToastWidget({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(40, 40, 40, 1),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: RichText(
        text: TextSpan(
          text: text,
          style: const TextStyle(
              color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w400),
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.visible,
        maxLines: 1,
      ),
    );
  }
}
