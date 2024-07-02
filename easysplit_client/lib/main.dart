import 'dart:async';

import 'package:easysplit_flutter/common/services/log_service.dart';
import 'package:easysplit_flutter/di/locator.dart';
import 'package:easysplit_flutter/modules/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    await configureDependencies();
    await LogService.init();

    LogService.i('Starting the app.');
    runApp(App());
  }, (error, stack) {
    LogService.e(error.toString());
  });
}
