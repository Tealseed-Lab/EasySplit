// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ReceiptStore on ReceiptStoreBase, Store {
  Computed<int>? _$validItemsCountComputed;

  @override
  int get validItemsCount =>
      (_$validItemsCountComputed ??= Computed<int>(() => super.validItemsCount,
              name: 'ReceiptStoreBase.validItemsCount'))
          .value;
  Computed<int>? _$assignedItemsCountComputed;

  @override
  int get assignedItemsCount => (_$assignedItemsCountComputed ??= Computed<int>(
          () => super.assignedItemsCount,
          name: 'ReceiptStoreBase.assignedItemsCount'))
      .value;
  Computed<int>? _$sharedByAllCountComputed;

  @override
  int get sharedByAllCount => (_$sharedByAllCountComputed ??= Computed<int>(
          () => super.sharedByAllCount,
          name: 'ReceiptStoreBase.sharedByAllCount'))
      .value;

  late final _$itemsAtom =
      Atom(name: 'ReceiptStoreBase.items', context: context);

  @override
  ObservableList<Map<String, dynamic>> get items {
    _$itemsAtom.reportRead();
    return super.items;
  }

  @override
  set items(ObservableList<Map<String, dynamic>> value) {
    _$itemsAtom.reportWrite(value, super.items, () {
      super.items = value;
    });
  }

  late final _$additionalChargesAtom =
      Atom(name: 'ReceiptStoreBase.additionalCharges', context: context);

  @override
  ObservableList<Map<String, dynamic>> get additionalCharges {
    _$additionalChargesAtom.reportRead();
    return super.additionalCharges;
  }

  @override
  set additionalCharges(ObservableList<Map<String, dynamic>> value) {
    _$additionalChargesAtom.reportWrite(value, super.additionalCharges, () {
      super.additionalCharges = value;
    });
  }

  late final _$additionalDiscountsAtom =
      Atom(name: 'ReceiptStoreBase.additionalDiscounts', context: context);

  @override
  ObservableList<Map<String, dynamic>> get additionalDiscounts {
    _$additionalDiscountsAtom.reportRead();
    return super.additionalDiscounts;
  }

  @override
  set additionalDiscounts(ObservableList<Map<String, dynamic>> value) {
    _$additionalDiscountsAtom.reportWrite(value, super.additionalDiscounts, () {
      super.additionalDiscounts = value;
    });
  }

  late final _$totalAtom =
      Atom(name: 'ReceiptStoreBase.total', context: context);

  @override
  num get total {
    _$totalAtom.reportRead();
    return super.total;
  }

  @override
  set total(num value) {
    _$totalAtom.reportWrite(value, super.total, () {
      super.total = value;
    });
  }

  late final _$oldTotalAtom =
      Atom(name: 'ReceiptStoreBase.oldTotal', context: context);

  @override
  num get oldTotal {
    _$oldTotalAtom.reportRead();
    return super.oldTotal;
  }

  @override
  set oldTotal(num value) {
    _$oldTotalAtom.reportWrite(value, super.oldTotal, () {
      super.oldTotal = value;
    });
  }

  late final _$itemAssignmentsAtom =
      Atom(name: 'ReceiptStoreBase.itemAssignments', context: context);

  @override
  ObservableMap<int, ObservableList<int>> get itemAssignments {
    _$itemAssignmentsAtom.reportRead();
    return super.itemAssignments;
  }

  @override
  set itemAssignments(ObservableMap<int, ObservableList<int>> value) {
    _$itemAssignmentsAtom.reportWrite(value, super.itemAssignments, () {
      super.itemAssignments = value;
    });
  }

  late final _$imageWidthAtom =
      Atom(name: 'ReceiptStoreBase.imageWidth', context: context);

  @override
  double get imageWidth {
    _$imageWidthAtom.reportRead();
    return super.imageWidth;
  }

  @override
  set imageWidth(double value) {
    _$imageWidthAtom.reportWrite(value, super.imageWidth, () {
      super.imageWidth = value;
    });
  }

  late final _$imageHeightAtom =
      Atom(name: 'ReceiptStoreBase.imageHeight', context: context);

  @override
  double get imageHeight {
    _$imageHeightAtom.reportRead();
    return super.imageHeight;
  }

  @override
  set imageHeight(double value) {
    _$imageHeightAtom.reportWrite(value, super.imageHeight, () {
      super.imageHeight = value;
    });
  }

  late final _$isImageSavedVisibleAtom =
      Atom(name: 'ReceiptStoreBase.isImageSavedVisible', context: context);

  @override
  bool get isImageSavedVisible {
    _$isImageSavedVisibleAtom.reportRead();
    return super.isImageSavedVisible;
  }

  @override
  set isImageSavedVisible(bool value) {
    _$isImageSavedVisibleAtom.reportWrite(value, super.isImageSavedVisible, () {
      super.isImageSavedVisible = value;
    });
  }

  late final _$ReceiptStoreBaseActionController =
      ActionController(name: 'ReceiptStoreBase', context: context);

  @override
  void calculateImageDimensions() {
    final _$actionInfo = _$ReceiptStoreBaseActionController.startAction(
        name: 'ReceiptStoreBase.calculateImageDimensions');
    try {
      return super.calculateImageDimensions();
    } finally {
      _$ReceiptStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setImageDimensions(double width, double height) {
    final _$actionInfo = _$ReceiptStoreBaseActionController.startAction(
        name: 'ReceiptStoreBase.setImageDimensions');
    try {
      return super.setImageDimensions(width, height);
    } finally {
      _$ReceiptStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEmptyReceiptData() {
    final _$actionInfo = _$ReceiptStoreBaseActionController.startAction(
        name: 'ReceiptStoreBase.setEmptyReceiptData');
    try {
      return super.setEmptyReceiptData();
    } finally {
      _$ReceiptStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setReceiptData(Map<String, dynamic> data) {
    final _$actionInfo = _$ReceiptStoreBaseActionController.startAction(
        name: 'ReceiptStoreBase.setReceiptData');
    try {
      return super.setReceiptData(data);
    } finally {
      _$ReceiptStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addItem(Map<String, dynamic> newItem) {
    final _$actionInfo = _$ReceiptStoreBaseActionController.startAction(
        name: 'ReceiptStoreBase.addItem');
    try {
      return super.addItem(newItem);
    } finally {
      _$ReceiptStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateItem(int index, Map<String, dynamic> newItem) {
    final _$actionInfo = _$ReceiptStoreBaseActionController.startAction(
        name: 'ReceiptStoreBase.updateItem');
    try {
      return super.updateItem(index, newItem);
    } finally {
      _$ReceiptStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateCharge(int index, Map<String, dynamic> newCharge) {
    final _$actionInfo = _$ReceiptStoreBaseActionController.startAction(
        name: 'ReceiptStoreBase.updateCharge');
    try {
      return super.updateCharge(index, newCharge);
    } finally {
      _$ReceiptStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateDiscount(int index, Map<String, dynamic> newDiscount) {
    final _$actionInfo = _$ReceiptStoreBaseActionController.startAction(
        name: 'ReceiptStoreBase.updateDiscount');
    try {
      return super.updateDiscount(index, newDiscount);
    } finally {
      _$ReceiptStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void calculateTotal() {
    final _$actionInfo = _$ReceiptStoreBaseActionController.startAction(
        name: 'ReceiptStoreBase.calculateTotal');
    try {
      return super.calculateTotal();
    } finally {
      _$ReceiptStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateOldTotal() {
    final _$actionInfo = _$ReceiptStoreBaseActionController.startAction(
        name: 'ReceiptStoreBase.updateOldTotal');
    try {
      return super.updateOldTotal();
    } finally {
      _$ReceiptStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void assignPersonToItem(int itemIndex, int personId) {
    final _$actionInfo = _$ReceiptStoreBaseActionController.startAction(
        name: 'ReceiptStoreBase.assignPersonToItem');
    try {
      return super.assignPersonToItem(itemIndex, personId);
    } finally {
      _$ReceiptStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removePersonFromItem(int itemIndex, int personId) {
    final _$actionInfo = _$ReceiptStoreBaseActionController.startAction(
        name: 'ReceiptStoreBase.removePersonFromItem');
    try {
      return super.removePersonFromItem(itemIndex, personId);
    } finally {
      _$ReceiptStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void assignAllPeopleToItem(int itemIndex) {
    final _$actionInfo = _$ReceiptStoreBaseActionController.startAction(
        name: 'ReceiptStoreBase.assignAllPeopleToItem');
    try {
      return super.assignAllPeopleToItem(itemIndex);
    } finally {
      _$ReceiptStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearAssignmentsFromItem(int itemIndex) {
    final _$actionInfo = _$ReceiptStoreBaseActionController.startAction(
        name: 'ReceiptStoreBase.clearAssignmentsFromItem');
    try {
      return super.clearAssignmentsFromItem(itemIndex);
    } finally {
      _$ReceiptStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  num calculatePersonBill(int personId) {
    final _$actionInfo = _$ReceiptStoreBaseActionController.startAction(
        name: 'ReceiptStoreBase.calculatePersonBill');
    try {
      return super.calculatePersonBill(personId);
    } finally {
      _$ReceiptStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void showImageSaved() {
    final _$actionInfo = _$ReceiptStoreBaseActionController.startAction(
        name: 'ReceiptStoreBase.showImageSaved');
    try {
      return super.showImageSaved();
    } finally {
      _$ReceiptStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void cleanupItemAssignments() {
    final _$actionInfo = _$ReceiptStoreBaseActionController.startAction(
        name: 'ReceiptStoreBase.cleanupItemAssignments');
    try {
      return super.cleanupItemAssignments();
    } finally {
      _$ReceiptStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
items: ${items},
additionalCharges: ${additionalCharges},
additionalDiscounts: ${additionalDiscounts},
total: ${total},
oldTotal: ${oldTotal},
itemAssignments: ${itemAssignments},
imageWidth: ${imageWidth},
imageHeight: ${imageHeight},
isImageSavedVisible: ${isImageSavedVisible},
validItemsCount: ${validItemsCount},
assignedItemsCount: ${assignedItemsCount},
sharedByAllCount: ${sharedByAllCount}
    ''';
  }
}
