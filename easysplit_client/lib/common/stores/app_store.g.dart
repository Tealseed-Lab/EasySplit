// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AppStore on AppStoreBase, Store {
  late final _$appVersionAtom =
      Atom(name: 'AppStoreBase.appVersion', context: context);

  @override
  String get appVersion {
    _$appVersionAtom.reportRead();
    return super.appVersion;
  }

  @override
  set appVersion(String value) {
    _$appVersionAtom.reportWrite(value, super.appVersion, () {
      super.appVersion = value;
    });
  }

  late final _$fetchAppVersionAsyncAction =
      AsyncAction('AppStoreBase.fetchAppVersion', context: context);

  @override
  Future<void> fetchAppVersion() {
    return _$fetchAppVersionAsyncAction.run(() => super.fetchAppVersion());
  }

  @override
  String toString() {
    return '''
appVersion: ${appVersion}
    ''';
  }
}
