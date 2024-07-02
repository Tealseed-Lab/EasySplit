import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:camera/camera.dart';
import 'package:easysplit_flutter/common/services/interfaces/image_service.dart';
import 'package:easysplit_flutter/common/services/log_service.dart';
import 'package:easysplit_flutter/common/services/shake_detector_service.dart';
import 'package:easysplit_flutter/common/utils/constants/constants.dart';
import 'package:easysplit_flutter/common/utils/logs/log_utils.dart';
import 'package:easysplit_flutter/common/widgets/alerts/double_check_bottom_sheet.dart';
import 'package:easysplit_flutter/di/locator.dart';
import 'package:easysplit_flutter/modules/bills/stores/receipt_store.dart';
import 'package:easysplit_flutter/modules/images/stores/camera_store.dart';
import 'package:easysplit_flutter/modules/images/stores/image_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CameraPageState();
  }
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  final CameraStore _cameraStore = locator<CameraStore>();
  final ImageStore _imageStore = locator<ImageStore>();
  final _receiptStore = locator<ReceiptStore>();

  late ShakeDetectorService _shakeDetector;
  bool _isCameraInitialized = false;
  bool _isReinitializing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _shakeDetector = ShakeDetectorService(onShake: _onShake);
    _shakeDetector.start();
    LogService.i("Initializing camera in initState");
    _checkPermissionsAndInitializeCamera(init: true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraStore.disposeController();
    _shakeDetector.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      _shakeDetector.start();
      if (!_isReinitializing &&
          !_isCameraInitialized &&
          _cameraStore.firstTimeInitialized) {
        _isReinitializing = true;
        LogService.i("Re-initializing camera on app resume");
        await _checkPermissionsAndInitializeCamera();
        _isReinitializing = false;
      }
    } else if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _shakeDetector.stop();
      _cameraStore.disposeController();
      _isCameraInitialized = false;
    }
  }

  Future<void> _checkPermissionsAndInitializeCamera({bool init = false}) async {
    if (_isCameraInitialized) {
      LogService.i(
          "Refused - Checking camera permissions refused as camera is already initialized");

      return;
    }
    await _cameraStore.checkPermissionsAndInitializeCamera(init: init);
    if (_cameraStore.isCameraAvailable) {
      _isCameraInitialized = true;
    }
  }

  Future<void> _checkGalleryPermission() async {
    var galleryStatus = await Permission.photos.status;
    if (galleryStatus.isDenied) {
      galleryStatus = await Permission.photos.request();
    }

    if (galleryStatus.isGranted || galleryStatus.isLimited) {
      await _uploadImageFromSource(ReceiptImageSource.gallery);
    } else {
      _showPermissionBottomSheet(
        photoLibraryPermissionTitle,
        photoLibraryPermissionMessage,
        onConfirm: () => AppSettings.openAppSettings(),
      );
    }
  }

  Future<void> _uploadImageFromSource(ReceiptImageSource source) async {
    final file = await _imageStore.pickImageFromSource(source);
    if (file != null && mounted) {
      LogService.i("Navigating to /transition with image path: ${file.path}");
      context.go('/transition', extra: file.path);
      LogService.i("Navigation to /transition completed");
    }
  }

  Future<void> _uploadImage(File file) async {
    if (mounted) {
      LogService.i("Navigating to /transition with image path: ${file.path}");
      context.go('/transition', extra: file.path);
      LogService.i("Navigation to /transition completed");
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraStore.controller != null &&
        _cameraStore.controller!.value.isInitialized &&
        !_cameraStore.isControllerDisposed) {
      try {
        final XFile picture = await _cameraStore.controller!.takePicture();
        LogService.i("Picture captured: ${picture.path}");
        await _uploadImage(File(picture.path));
      } catch (e) {
        LogService.e("Error taking picture: $e");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error capturing photo: $e')),
          );
        }
      }
    }
  }

  Future<void> _onShake() async {
    final logFile = await LogService.packetLogFiles();
    if (logFile != null && mounted) {
      showShareDialog(context, File(logFile));
    }
  }

  void _showPermissionBottomSheet(String title, String message,
      {required VoidCallback onConfirm}) {
    if (!mounted) return;
    showDoubleCheckBottomSheet(
      context,
      title: title,
      message: message,
      onConfirm: onConfirm,
    );
  }

  void logCameraState() {
    LogService.i("isCameraAvailable: ${_cameraStore.isCameraAvailable}, "
        "isCheckingPermissions: ${_cameraStore.isCheckingPermissions}, "
        "_cameraStore.controller != null: ${_cameraStore.controller != null}, "
        "_cameraStore.controller != null && _cameraStore.controller!.value.isInitialized: ${_cameraStore.controller != null && _cameraStore.controller!.value.isInitialized}, "
        "isControllerDisposed: ${_cameraStore.isControllerDisposed}, "
        "isPermissionDenied: ${_cameraStore.isPermissionDenied}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          margin: const EdgeInsets.fromLTRB(8, 54, 8, 48),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: Observer(
              builder: (_) {
                if (_cameraStore.isCheckingPermissions) {
                  LogService.i("CircularProgressIndicator");
                  logCameraState();
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  );
                } else if (_cameraStore.isCameraAvailable &&
                    _cameraStore.controller != null &&
                    _cameraStore.controller!.value.isInitialized &&
                    !_cameraStore.isControllerDisposed) {
                  LogService.i("CameraPreview");
                  logCameraState();
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: AspectRatio(
                          aspectRatio:
                              _cameraStore.controller!.value.aspectRatio,
                          child: CameraPreview(_cameraStore.controller!),
                        ),
                      ),
                      Positioned.fill(
                        child: _buildBottomBar(true),
                      ),
                    ],
                  );
                } else if (_cameraStore.isPermissionDenied) {
                  LogService.i("NoCameraAccess");
                  logCameraState();
                  return Stack(
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text(
                                noCameraAccessAlert,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => AppSettings.openAppSettings(),
                              child: const Text(
                                goToSettingsMessage,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildBottomBar(false),
                    ],
                  );
                } else {
                  LogService.i("CameraNotYetInitialized");
                  logCameraState();
                  return Stack(
                    children: [
                      Container(
                        color: Colors.black,
                      ),
                      _buildBottomBar(false),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(bool isCameraAvailable) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isCameraAvailable)
              Container(
                width: 325,
                height: 45,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(100.0),
                ),
                child: const Center(
                  child: Text(
                    takePhotoMessage,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            if (isCameraAvailable) const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/svg/edit.svg',
                    width: 32,
                    height: 32,
                  ),
                  onPressed: () {
                    _receiptStore.setEmptyReceiptData();
                    context.go('/bill');
                  },
                ),
                const SizedBox(width: 40),
                IconButton(
                  icon: Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/svg/ellipse2.svg',
                        width: 94,
                        height: 94,
                      ),
                      SvgPicture.asset(
                        'assets/svg/ellipse1.svg',
                        width: 74,
                        height: 74,
                      ),
                    ],
                  ),
                  onPressed: isCameraAvailable ? _capturePhoto : null,
                ),
                const SizedBox(width: 40),
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/svg/picture.svg',
                    width: 32,
                    height: 32,
                  ),
                  onPressed: () async {
                    await _checkGalleryPermission();
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
