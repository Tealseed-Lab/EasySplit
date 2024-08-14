// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'camera_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CameraStore on CameraStoreBase, Store {
  late final _$camerasAtom =
      Atom(name: 'CameraStoreBase.cameras', context: context);

  @override
  List<CameraDescription> get cameras {
    _$camerasAtom.reportRead();
    return super.cameras;
  }

  @override
  set cameras(List<CameraDescription> value) {
    _$camerasAtom.reportWrite(value, super.cameras, () {
      super.cameras = value;
    });
  }

  late final _$controllerAtom =
      Atom(name: 'CameraStoreBase.controller', context: context);

  @override
  CameraController? get controller {
    _$controllerAtom.reportRead();
    return super.controller;
  }

  @override
  set controller(CameraController? value) {
    _$controllerAtom.reportWrite(value, super.controller, () {
      super.controller = value;
    });
  }

  late final _$isCameraAvailableAtom =
      Atom(name: 'CameraStoreBase.isCameraAvailable', context: context);

  @override
  bool get isCameraAvailable {
    _$isCameraAvailableAtom.reportRead();
    return super.isCameraAvailable;
  }

  @override
  set isCameraAvailable(bool value) {
    _$isCameraAvailableAtom.reportWrite(value, super.isCameraAvailable, () {
      super.isCameraAvailable = value;
    });
  }

  late final _$isCheckingPermissionsAtom =
      Atom(name: 'CameraStoreBase.isCheckingPermissions', context: context);

  @override
  bool get isCheckingPermissions {
    _$isCheckingPermissionsAtom.reportRead();
    return super.isCheckingPermissions;
  }

  @override
  set isCheckingPermissions(bool value) {
    _$isCheckingPermissionsAtom.reportWrite(value, super.isCheckingPermissions,
        () {
      super.isCheckingPermissions = value;
    });
  }

  late final _$isControllerDisposedAtom =
      Atom(name: 'CameraStoreBase.isControllerDisposed', context: context);

  @override
  bool get isControllerDisposed {
    _$isControllerDisposedAtom.reportRead();
    return super.isControllerDisposed;
  }

  @override
  set isControllerDisposed(bool value) {
    _$isControllerDisposedAtom.reportWrite(value, super.isControllerDisposed,
        () {
      super.isControllerDisposed = value;
    });
  }

  late final _$isPermissionDeniedAtom =
      Atom(name: 'CameraStoreBase.isPermissionDenied', context: context);

  @override
  bool get isPermissionDenied {
    _$isPermissionDeniedAtom.reportRead();
    return super.isPermissionDenied;
  }

  @override
  set isPermissionDenied(bool value) {
    _$isPermissionDeniedAtom.reportWrite(value, super.isPermissionDenied, () {
      super.isPermissionDenied = value;
    });
  }

  late final _$firstTimeInitializedAtom =
      Atom(name: 'CameraStoreBase.firstTimeInitialized', context: context);

  @override
  bool get firstTimeInitialized {
    _$firstTimeInitializedAtom.reportRead();
    return super.firstTimeInitialized;
  }

  @override
  set firstTimeInitialized(bool value) {
    _$firstTimeInitializedAtom.reportWrite(value, super.firstTimeInitialized,
        () {
      super.firstTimeInitialized = value;
    });
  }

  late final _$checkPermissionsAndInitializeCameraAsyncAction = AsyncAction(
      'CameraStoreBase.checkPermissionsAndInitializeCamera',
      context: context);

  @override
  Future<void> checkPermissionsAndInitializeCamera({bool init = false}) {
    return _$checkPermissionsAndInitializeCameraAsyncAction
        .run(() => super.checkPermissionsAndInitializeCamera(init: init));
  }

  late final _$initializeCameraAsyncAction =
      AsyncAction('CameraStoreBase.initializeCamera', context: context);

  @override
  Future<void> initializeCamera() {
    return _$initializeCameraAsyncAction.run(() => super.initializeCamera());
  }

  late final _$disposeControllerAsyncAction =
      AsyncAction('CameraStoreBase.disposeController', context: context);

  @override
  Future<void> disposeController() {
    return _$disposeControllerAsyncAction.run(() => super.disposeController());
  }

  late final _$capturePhotoAsyncAction =
      AsyncAction('CameraStoreBase.capturePhoto', context: context);

  @override
  Future<XFile?> capturePhoto() {
    return _$capturePhotoAsyncAction.run(() => super.capturePhoto());
  }

  @override
  String toString() {
    return '''
cameras: ${cameras},
controller: ${controller},
isCameraAvailable: ${isCameraAvailable},
isCheckingPermissions: ${isCheckingPermissions},
isControllerDisposed: ${isControllerDisposed},
isPermissionDenied: ${isPermissionDenied},
firstTimeInitialized: ${firstTimeInitialized}
    ''';
  }
}
