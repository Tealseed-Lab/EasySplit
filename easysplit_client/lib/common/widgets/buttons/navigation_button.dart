import 'package:easysplit_flutter/common/widgets/alerts/double_check_bottom_sheet.dart';
import 'package:easysplit_flutter/common/widgets/buttons/circular_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationButton extends StatelessWidget {
  final String pageName;
  final Color? backgroundColor;
  final Color? iconBackgroundColor;
  final String? confirmMessage;
  final String? svgIconPath;
  final Map<String, dynamic>? extra;

  const NavigationButton({
    super.key,
    required this.pageName,
    this.backgroundColor,
    this.iconBackgroundColor,
    this.confirmMessage,
    this.svgIconPath,
    this.extra,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 24),
        padding: const EdgeInsets.symmetric(vertical: 16),
        color: backgroundColor ?? Theme.of(context).primaryColor,
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.hardEdge,
          color: Colors.transparent,
          child: IconButton(
            padding: const EdgeInsets.all(0),
            icon: CircularIconButton(
              iconSize: 24,
              backgroundSize: 48,
              backgroundColor: iconBackgroundColor,
              svgIconPath: svgIconPath ?? "assets/svg/arrow-left.svg",
            ),
            onPressed: () {
              if (confirmMessage != null) {
                showDoubleCheckBottomSheet(
                  context,
                  title: '',
                  message: confirmMessage,
                  onConfirm: () {
                    if (extra == null) {
                      context.go('/$pageName');
                    } else {
                      context.go('/$pageName', extra: extra);
                    }
                  },
                  confirmText: 'Yes',
                  cancelText: 'Stay',
                  flip: true,
                );
              } else {
                if (extra == null) {
                  context.go('/$pageName');
                } else {
                  context.go('/$pageName', extra: extra);
                }
              }
            },
          ),
        ));
  }
}
