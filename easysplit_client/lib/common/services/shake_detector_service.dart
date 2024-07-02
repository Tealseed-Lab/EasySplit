import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';

class ShakeDetectorService {
  final VoidCallback onShake;
  final double shakeThreshold;
  final Duration samplingPeriod;
  final Duration debounceDuration;
  StreamSubscription<AccelerometerEvent>? _subscription;
  DateTime? _lastShakeTime;

  ShakeDetectorService({
    required this.onShake,
    this.shakeThreshold = 40.0,
    this.samplingPeriod = const Duration(milliseconds: 100),
    this.debounceDuration = const Duration(seconds: 2),
  });

  void start() {
    _subscription = accelerometerEventStream(samplingPeriod: samplingPeriod)
        .listen((AccelerometerEvent event) {
      if (event.x.abs() > shakeThreshold ||
          event.y.abs() > shakeThreshold ||
          event.z.abs() > shakeThreshold) {
        final now = DateTime.now();
        if (_lastShakeTime == null ||
            now.difference(_lastShakeTime!) > debounceDuration) {
          _lastShakeTime = now;
          onShake();
        }
      }
    });
  }

  void stop() {
    _subscription?.cancel();
  }

  void dispose() {
    stop();
  }

  Stream<AccelerometerEvent> accelerometerEventStream({
    required Duration samplingPeriod,
  }) {
    return SensorsPlatform.instance
        .accelerometerEventStream(samplingPeriod: samplingPeriod);
  }
}
