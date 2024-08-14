import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:camera/camera.dart';
import 'package:easysplit_flutter/common/services/log_service.dart';
import 'package:easysplit_flutter/common/utils/constants/constants.dart';
import 'package:easysplit_flutter/common/widgets/buttons/navigation_button.dart';
import 'package:easysplit_flutter/di/locator.dart';
import 'package:easysplit_flutter/modules/images/stores/camera_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CameraPageState();
  }
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  final CameraStore _cameraStore = locator<CameraStore>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    LogService.i("Initializing camera in initState");
    _cameraStore.checkPermissionsAndInitializeCamera(init: true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraStore.disposeController();
    LogService.i("Camera controller disposed in dispose");
    super.dispose();
  }

  Future<void> _uploadImage(File file) async {
    if (mounted) {
      LogService.i(
          "Navigating to /transition with image path: ${file.path}, fromPage: camera");
      context.go('/transition',
          extra: {'imagePath': file.path, 'fromPage': 'camera'});
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraStore.controller != null &&
        _cameraStore.controller!.value.isInitialized &&
        !_cameraStore.isControllerDisposed) {
      final XFile? picture = await _cameraStore.capturePhoto();
      if (picture != null) {
        await _uploadImage(File(picture.path));
      } else {
        LogService.e("Error taking picture: picture is null");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error taking picture')),
          );
        }
      }
    }
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
      body: Stack(
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.fromLTRB(8, 48, 8, 48),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Observer(
                  builder: (_) {
                    if (!_cameraStore.isCheckingPermissions &
                            _cameraStore.isCameraAvailable &&
                        _cameraStore.controller != null &&
                        _cameraStore.controller!.value.isInitialized &&
                        !_cameraStore.isControllerDisposed) {
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
                                  onPressed: () =>
                                      AppSettings.openAppSettings(),
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
          Container(
            padding: const EdgeInsets.all(16.0),
            child: const NavigationButton(
              pageName: 'home',
              backgroundColor: Colors.transparent,
            ),
          ),
        ],
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
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
