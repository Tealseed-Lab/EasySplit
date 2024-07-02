enum VibrationType {
  success,
  warning,
  error,
  light,
  medium,
  heavy,
  rigid,
  soft,
  selection,
}

abstract class VibrationService {
  Future<bool> canVibrate();
  Future<void> vibrate(VibrationType type);
}
