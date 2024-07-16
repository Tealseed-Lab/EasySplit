import 'dart:math';

import 'package:flutter/material.dart';

double calculateWidgetWidth(
    String name, String billAmount, double maxWidth, double minWidth) {
  final namePainter = TextPainter(
    text: TextSpan(
      text: name,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
    ),
    maxLines: 1,
    textDirection: TextDirection.ltr,
  );
  namePainter.layout();

  final billAmountPainter = TextPainter(
    text: TextSpan(
      text: billAmount,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
    maxLines: 1,
    textDirection: TextDirection.ltr,
  );
  billAmountPainter.layout();

  // Calculate the maximum width required for either name or billAmount
  final nameRequiredWidth = namePainter.size.width + 105;
  final billAmountRequiredWidth = billAmountPainter.size.width + 85;
  final totalWidth = max(nameRequiredWidth, billAmountRequiredWidth);

  // Constrain the total width to a minimum and maximum value
  return totalWidth.clamp(minWidth, maxWidth);
}

double calculateTotalHeight(
    List<String> names, List<String> billAmounts, double maxWidth) {
  if (names.isEmpty) {
    return 0;
  }
  double currentRowWidth = 0;
  double currentRowHeight = 58;
  double space = 8.0;

  double minWidth = (maxWidth - space) / 2;
  double totalHeight = currentRowHeight;

  for (int i = 0; i < names.length; i++) {
    double widgetWidth =
        calculateWidgetWidth(names[i], billAmounts[i], maxWidth, minWidth);
    if (currentRowWidth == 0) {
      currentRowWidth = widgetWidth;
    } else {
      currentRowWidth += widgetWidth + space;
    }
    if (currentRowWidth > maxWidth) {
      totalHeight += currentRowHeight + space;
      currentRowWidth = widgetWidth;
    }
  }

  return totalHeight;
}
