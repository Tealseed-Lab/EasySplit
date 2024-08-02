import 'package:camera/camera.dart';
import 'package:easysplit_flutter/common/services/log_service.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:permission_handler/permission_handler.dart';

part 'camera_store.g.dart';

@Singleton()
class CameraStore = CameraStoreBase with _$CameraStore;

abstract class CameraStoreBase with Store {
  @observable
  List<CameraDescription> cameras = [];

  @observable
  CameraController? controller;

  @observable
  bool isCameraAvailable = true;

  @observable
  bool isCheckingPermissions = true;

  @observable
  bool isControllerDisposed = true;

  @observable
  bool isPermissionDenied = false;

  @observable
  bool firstTimeInitialized = false;

  @action
  Future<void> checkPermissionsAndInitializeCamera({bool init = false}) async {
    isCheckingPermissions = true;
    LogService.i("Checking camera permissions...");

    var cameraStatus = await Permission.camera.status;
    if (init && cameraStatus.isDenied) {
      cameraStatus = await Permission.camera.request();
      LogService.i("Requesting camera permissions...");
    }

    if (cameraStatus.isGranted) {
      await initializeCamera();
    } else {
      isCameraAvailable = false;
      isPermissionDenied = true;
    }

    firstTimeInitialized = true;
    isCheckingPermissions = false;
  }

  @action
  Future<void> initializeCamera() async {
    try {
      LogService.i("Initializing camera...");
      cameras = await availableCameras();
      LogService.i("Number of available cameras: ${cameras.length}");
      if (cameras.isNotEmpty) {
        controller = CameraController(cameras[0], ResolutionPreset.ultraHigh,
            enableAudio: false);

        await controller?.initialize();
        if (controller != null && controller!.value.isInitialized) {
          isControllerDisposed = false;
          isCameraAvailable = true;
          isPermissionDenied = false;
        } else {
          isCameraAvailable = false;
        }
      } else {
        isCameraAvailable = false;
      }
    } catch (e) {
      LogService.e("Error initializing camera: $e");
      isCameraAvailable = false;
    }
  }

  @action
  Future<void> disposeController() async {
    if (controller != null && !isControllerDisposed) {
      LogService.i("Disposing camera controller...");
      await controller?.dispose();
      isControllerDisposed = true;
    }
  }
}
