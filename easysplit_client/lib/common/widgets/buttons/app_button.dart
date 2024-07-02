import 'package:easysplit_flutter/common/services/interfaces/vibration_service.dart';
import 'package:easysplit_flutter/di/locator.dart';
import 'package:flutter/material.dart';

enum AppButtonType {
  inkwell,
  icon,
  normal,
}

class AppButton extends StatelessWidget {
  final Widget child;
  final bool enabled;
  final Function()? onTap;
  final Function()? onLongPress;
  final AppButtonType type;
  final bool vibrate;
  final VibrationType vibrationType;
  final _vibrationService = locator<VibrationService>();

  AppButton({
    super.key,
    required this.child,
    this.type = AppButtonType.normal,
    this.vibrate = false,
    this.vibrationType = VibrationType.light,
    this.enabled = true,
    this.onTap,
    this.onLongPress,
  });

  AppButton.inkwell({
    super.key,
    required this.child,
    this.vibrate = false,
    this.vibrationType = VibrationType.light,
    this.enabled = true,
    this.onTap,
    this.onLongPress,
  }) : type = AppButtonType.inkwell;

  AppButton.icon({
    super.key,
    required this.child,
    this.vibrate = false,
    this.vibrationType = VibrationType.light,
    this.enabled = true,
    this.onTap,
  })  : type = AppButtonType.icon,
        onLongPress = null;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case AppButtonType.normal:
        return GestureDetector(
          onTap: _onTap,
          child: child,
        );
      case AppButtonType.inkwell:
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _onTap,
            onLongPress: _onLongPress,
            child: child,
          ),
        );
      case AppButtonType.icon:
        return IconButton(
          onPressed: _onTap,
          icon: child,
        );
    }
  }

  void _onTap() {
    if (!enabled) return;
    if (vibrate) {
      _vibrationService.vibrate(vibrationType);
    }
    onTap?.call();
  }

  void _onLongPress() {
    if (!enabled) return;
    if (vibrate) {
      _vibrationService.vibrate(vibrationType);
    }
    onLongPress?.call();
  }
}
