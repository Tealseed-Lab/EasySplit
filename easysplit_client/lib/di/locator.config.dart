// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../common/services/implementations/app_image_service.dart' as _i11;
import '../common/services/implementations/cloud_api_service.dart' as _i9;
import '../common/services/implementations/haptic_vibration_service.dart'
    as _i7;
import '../common/services/interfaces/api_service.dart' as _i8;
import '../common/services/interfaces/image_service.dart' as _i10;
import '../common/services/interfaces/vibration_service.dart' as _i6;
import '../modules/bills/stores/receipt_store.dart' as _i5;
import '../modules/images/stores/camera_store.dart' as _i3;
import '../modules/images/stores/image_store.dart' as _i12;
import '../modules/images/stores/process_store.dart' as _i4;

// initializes the registration of main-scope dependencies inside of GetIt
_i1.GetIt $initGetIt(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  gh.singleton<_i3.CameraStore>(() => _i3.CameraStore());
  gh.singleton<_i4.ProcessStore>(() => _i4.ProcessStore());
  gh.singleton<_i5.ReceiptStore>(() => _i5.ReceiptStore());
  gh.singleton<_i6.VibrationService>(() => _i7.HapticVibrationService());
  gh.singleton<_i8.ApiService>(() => _i9.CloudApiService());
  gh.singleton<_i10.ImageService>(() => _i11.AppImageService());
  gh.singleton<_i12.ImageStore>(() => _i12.ImageStore(
        gh<_i10.ImageService>(),
        gh<_i8.ApiService>(),
      ));
  return getIt;
}
