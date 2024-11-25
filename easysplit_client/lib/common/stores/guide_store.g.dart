// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guide_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$GuideStore on GuideStoreBase, Store {
  late final _$homeGuideStateAtom =
      Atom(name: 'GuideStoreBase.homeGuideState', context: context);

  @override
  GuideState get homeGuideState {
    _$homeGuideStateAtom.reportRead();
    return super.homeGuideState;
  }

  @override
  set homeGuideState(GuideState value) {
    _$homeGuideStateAtom.reportWrite(value, super.homeGuideState, () {
      super.homeGuideState = value;
    });
  }

  late final _$splitGuideStateAtom =
      Atom(name: 'GuideStoreBase.splitGuideState', context: context);

  @override
  GuideState get splitGuideState {
    _$splitGuideStateAtom.reportRead();
    return super.splitGuideState;
  }

  @override
  set splitGuideState(GuideState value) {
    _$splitGuideStateAtom.reportWrite(value, super.splitGuideState, () {
      super.splitGuideState = value;
    });
  }

  late final _$isSampleHelpDismissedAtom =
      Atom(name: 'GuideStoreBase.isSampleHelpDismissed', context: context);

  @override
  bool get isSampleHelpDismissed {
    _$isSampleHelpDismissedAtom.reportRead();
    return super.isSampleHelpDismissed;
  }

  @override
  set isSampleHelpDismissed(bool value) {
    _$isSampleHelpDismissedAtom.reportWrite(value, super.isSampleHelpDismissed,
        () {
      super.isSampleHelpDismissed = value;
    });
  }

  late final _$setHomeGuideViewedAsyncAction =
      AsyncAction('GuideStoreBase.setHomeGuideViewed', context: context);

  @override
  Future<void> setHomeGuideViewed() {
    return _$setHomeGuideViewedAsyncAction
        .run(() => super.setHomeGuideViewed());
  }

  late final _$setSplitGuideViewedAsyncAction =
      AsyncAction('GuideStoreBase.setSplitGuideViewed', context: context);

  @override
  Future<void> setSplitGuideViewed() {
    return _$setSplitGuideViewedAsyncAction
        .run(() => super.setSplitGuideViewed());
  }

  late final _$dismissSampleHelpAsyncAction =
      AsyncAction('GuideStoreBase.dismissSampleHelp', context: context);

  @override
  Future<void> dismissSampleHelp() {
    return _$dismissSampleHelpAsyncAction.run(() => super.dismissSampleHelp());
  }

  @override
  String toString() {
    return '''
homeGuideState: ${homeGuideState},
splitGuideState: ${splitGuideState},
isSampleHelpDismissed: ${isSampleHelpDismissed}
    ''';
  }
}
