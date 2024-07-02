import 'package:flutter/material.dart';

const roundedCornerhorizontalPadding = 16.0;

Future<T?> showRoundedCornerBottomSheet<T>(
  BuildContext context, {
  Widget? child,
  double? cornerRadius,
  bool withMargin = true,
}) async {
  return await showModalBottomSheet(
    context: context,
    barrierColor: Colors.black.withOpacity(0.2),
    backgroundColor: Colors.transparent,
    enableDrag: false,
    isScrollControlled: true,
    builder: (context) => Padding(
      padding: withMargin
          ? EdgeInsets.only(
              left: roundedCornerhorizontalPadding,
              right: roundedCornerhorizontalPadding,
              bottom: MediaQuery.of(context).padding.bottom == 0
                  ? 16
                  : MediaQuery.of(context).padding.bottom,
            )
          : EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(cornerRadius ?? 24),
        child: child,
      ),
    ),
  );
}
