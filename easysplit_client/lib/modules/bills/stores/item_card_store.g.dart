// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_card_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ItemCardStore on ItemStoreBase, Store {
  late final _$isOverlayVisibleAtom =
      Atom(name: 'ItemStoreBase.isOverlayVisible', context: context);

  @override
  bool get isOverlayVisible {
    _$isOverlayVisibleAtom.reportRead();
    return super.isOverlayVisible;
  }

  @override
  set isOverlayVisible(bool value) {
    _$isOverlayVisibleAtom.reportWrite(value, super.isOverlayVisible, () {
      super.isOverlayVisible = value;
    });
  }

  late final _$selectedItemAtom =
      Atom(name: 'ItemStoreBase.selectedItem', context: context);

  @override
  Map<String, dynamic>? get selectedItem {
    _$selectedItemAtom.reportRead();
    return super.selectedItem;
  }

  @override
  set selectedItem(Map<String, dynamic>? value) {
    _$selectedItemAtom.reportWrite(value, super.selectedItem, () {
      super.selectedItem = value;
    });
  }

  late final _$ItemStoreBaseActionController =
      ActionController(name: 'ItemStoreBase', context: context);

  @override
  void showOverlay(Map<String, dynamic> item) {
    final _$actionInfo = _$ItemStoreBaseActionController.startAction(
        name: 'ItemStoreBase.showOverlay');
    try {
      return super.showOverlay(item);
    } finally {
      _$ItemStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void hideOverlay() {
    final _$actionInfo = _$ItemStoreBaseActionController.startAction(
        name: 'ItemStoreBase.hideOverlay');
    try {
      return super.hideOverlay();
    } finally {
      _$ItemStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isOverlayVisible: ${isOverlayVisible},
selectedItem: ${selectedItem}
    ''';
  }
}
