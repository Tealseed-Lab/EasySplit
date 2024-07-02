// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'process_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProcessStore on ProcessStoreBase, Store {
  late final _$showAnimationBarAtom =
      Atom(name: 'ProcessStoreBase.showAnimationBar', context: context);

  @override
  bool get showAnimationBar {
    _$showAnimationBarAtom.reportRead();
    return super.showAnimationBar;
  }

  @override
  set showAnimationBar(bool value) {
    _$showAnimationBarAtom.reportWrite(value, super.showAnimationBar, () {
      super.showAnimationBar = value;
    });
  }

  late final _$showConnectionErrorAtom =
      Atom(name: 'ProcessStoreBase.showConnectionError', context: context);

  @override
  bool get showConnectionError {
    _$showConnectionErrorAtom.reportRead();
    return super.showConnectionError;
  }

  @override
  set showConnectionError(bool value) {
    _$showConnectionErrorAtom.reportWrite(value, super.showConnectionError, () {
      super.showConnectionError = value;
    });
  }

  late final _$noTextDetectedAtom =
      Atom(name: 'ProcessStoreBase.noTextDetected', context: context);

  @override
  bool get noTextDetected {
    _$noTextDetectedAtom.reportRead();
    return super.noTextDetected;
  }

  @override
  set noTextDetected(bool value) {
    _$noTextDetectedAtom.reportWrite(value, super.noTextDetected, () {
      super.noTextDetected = value;
    });
  }

  late final _$loopingLastTextAtom =
      Atom(name: 'ProcessStoreBase.loopingLastText', context: context);

  @override
  bool get loopingLastText {
    _$loopingLastTextAtom.reportRead();
    return super.loopingLastText;
  }

  @override
  set loopingLastText(bool value) {
    _$loopingLastTextAtom.reportWrite(value, super.loopingLastText, () {
      super.loopingLastText = value;
    });
  }

  late final _$ProcessStoreBaseActionController =
      ActionController(name: 'ProcessStoreBase', context: context);

  @override
  void setLoopingLastText(bool value) {
    final _$actionInfo = _$ProcessStoreBaseActionController.startAction(
        name: 'ProcessStoreBase.setLoopingLastText');
    try {
      return super.setLoopingLastText(value);
    } finally {
      _$ProcessStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setShowAnimationBar(bool value) {
    final _$actionInfo = _$ProcessStoreBaseActionController.startAction(
        name: 'ProcessStoreBase.setShowAnimationBar');
    try {
      return super.setShowAnimationBar(value);
    } finally {
      _$ProcessStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setShowConnectionError(bool value) {
    final _$actionInfo = _$ProcessStoreBaseActionController.startAction(
        name: 'ProcessStoreBase.setShowConnectionError');
    try {
      return super.setShowConnectionError(value);
    } finally {
      _$ProcessStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setNoTextDetected(bool value) {
    final _$actionInfo = _$ProcessStoreBaseActionController.startAction(
        name: 'ProcessStoreBase.setNoTextDetected');
    try {
      return super.setNoTextDetected(value);
    } finally {
      _$ProcessStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void reset() {
    final _$actionInfo = _$ProcessStoreBaseActionController.startAction(
        name: 'ProcessStoreBase.reset');
    try {
      return super.reset();
    } finally {
      _$ProcessStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
showAnimationBar: ${showAnimationBar},
showConnectionError: ${showConnectionError},
noTextDetected: ${noTextDetected},
loopingLastText: ${loopingLastText}
    ''';
  }
}
