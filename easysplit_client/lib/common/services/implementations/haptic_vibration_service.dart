import 'package:easysplit_flutter/common/services/interfaces/vibration_service.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: VibrationService)
class HapticVibrationService extends VibrationService {
  @override
  Future<bool> canVibrate() {
    return Haptics.canVibrate();
  }

  @override
  Future<void> vibrate(VibrationType type) async {
    HapticsType hapticsType;
    switch (type) {
      case VibrationType.success:
        hapticsType = HapticsType.success;
        break;
      case VibrationType.warning:
        hapticsType = HapticsType.warning;
        break;
      case VibrationType.error:
        hapticsType = HapticsType.error;
        break;
      case VibrationType.light:
        hapticsType = HapticsType.light;
        break;
      case VibrationType.medium:
        hapticsType = HapticsType.medium;
        break;
      case VibrationType.heavy:
        hapticsType = HapticsType.heavy;
        break;
      case VibrationType.rigid:
        hapticsType = HapticsType.rigid;
        break;
      case VibrationType.soft:
        hapticsType = HapticsType.soft;
        break;
      case VibrationType.selection:
        hapticsType = HapticsType.selection;
        break;
    }
    Haptics.vibrate(hapticsType);
  }
}
