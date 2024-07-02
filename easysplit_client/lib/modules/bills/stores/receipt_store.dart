import 'package:easysplit_flutter/common/services/log_service.dart';
import 'package:easysplit_flutter/common/utils/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'receipt_store.g.dart';

@Singleton()
class ReceiptStore = ReceiptStoreBase with _$ReceiptStore;

abstract class ReceiptStoreBase with Store {
  @observable
  ObservableList<Map<String, dynamic>> items =
      ObservableList<Map<String, dynamic>>();

  @observable
  ObservableList<Map<String, dynamic>> additionalCharges =
      ObservableList<Map<String, dynamic>>();

  @observable
  ObservableList<Map<String, dynamic>> additionalDiscounts =
      ObservableList<Map<String, dynamic>>();

  @observable
  num total = 0.0;

  @observable
  num oldTotal = 0.0;

  @observable
  int pax = 2;

  @observable
  ObservableMap<int, ObservableList<int>> itemAssignments =
      ObservableMap<int, ObservableList<int>>();

  @observable
  double imageWidth = 0.0;

  @observable
  double imageHeight = 0.0;

  @observable
  bool isImageSavedVisible = false;

  Map<String, dynamic> emptyReceiptData = BillImageConstants.emptyReceiptData;

  @computed
  int get validItemsCount => items.where((item) => item['price'] != 0).length;

  @computed
  int get assignedItemsCount => items.where((item) {
        int index = items.indexOf(item);
        return item['price'] != 0 &&
            (itemAssignments[index]?.isNotEmpty ?? false);
      }).length;

  @computed
  int get sharedByAllCount => items.where((item) {
        int index = items.indexOf(item);
        return item['price'] != 0 && itemAssignments[index]?.length == pax;
      }).length;

  double calculateItemNamesHeight() {
    double totalHeight = validItemsCount * 21;
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
      maxLines: 2,
    );

    for (var item in items.where((item) => item['price'] != 0)) {
      textPainter.text = TextSpan(
        text: item['name'],
        style: BillImageConstants.textStyle,
      );

      textPainter.layout(maxWidth: BillImageConstants.itemTextWidth);

      int lines =
          (textPainter.size.height / BillImageConstants.itemLineHeight).ceil();
      lines = lines > 2 ? 2 : lines;

      if (lines > 1) {
        totalHeight += BillImageConstants.itemLineHeight * 2 - 1;
      } else {
        totalHeight += BillImageConstants.itemLineHeight;
      }
    }
    return totalHeight;
  }

  @action
  void calculateImageDimensions() {
    double bottomBillHeight = pax > 4 ? 201 : 95;
    double assigneeHeight = assignedItemsCount * 24 - sharedByAllCount * 2;
    double itemNamesHeight = calculateItemNamesHeight();
    double height = bottomBillHeight +
        BillImageConstants.baseHeight +
        assigneeHeight +
        itemNamesHeight;
    LogService.i('Bottom Bill Height: $bottomBillHeight; '
        'Assignee Height: $assigneeHeight; '
        'Item Names Height: $itemNamesHeight; '
        'Total Height: $height');
    setImageDimensions(BillImageConstants.baseWidth, height);
  }

  @action
  void setImageDimensions(double width, double height) {
    imageWidth = width;
    imageHeight = height;
  }

  @action
  void setEmptyReceiptData() {
    setReceiptData(emptyReceiptData);
  }

  @action
  void setReceiptData(Map<String, dynamic> data) {
    LogService.i('Setting receipt data.');
    items = ObservableList.of(List<Map<String, dynamic>>.from(data['items']));
    additionalCharges = ObservableList.of(
        List<Map<String, dynamic>>.from(data['additional_charges']));
    additionalDiscounts = ObservableList.of(
        List<Map<String, dynamic>>.from(data['additional_discounts']));
    calculateTotal();
    itemAssignments.clear();
  }

  @action
  void addItem(Map<String, dynamic> newItem) {
    LogService.i('Adding new item.');
    int newKey = _getMaxKey() + 1;
    newItem['key'] = newKey;
    items.add(newItem);
    calculateTotal();
  }

  int _getMaxKey() {
    return items
        .map((item) => item['key'] as int)
        .fold(0, (a, b) => a > b ? a : b);
  }

  @action
  void updateItem(int index, Map<String, dynamic> newItem) {
    LogService.i('Updating item with index $index.');
    items[index] = newItem;
    calculateTotal();
  }

  @action
  void updateCharge(int index, Map<String, dynamic> newCharge) {
    LogService.i('Updating charge with index $index.');
    additionalCharges[index] = newCharge;
    calculateTotal();
  }

  @action
  void updateDiscount(int index, Map<String, dynamic> newDiscount) {
    LogService.i('Updating discount with index $index.');
    additionalDiscounts[index] = newDiscount;
    calculateTotal();
  }

  @action
  void calculateTotal() {
    oldTotal = total; // Store the old total before calculating the new one

    num subtotal = items.fold(0.0, (sum, item) => sum + item['price']);
    num totalCharges =
        additionalCharges.fold(0.0, (sum, charge) => sum + charge['amount']);
    num totalDiscounts = additionalDiscounts.fold(
        0.0, (sum, discount) => sum + discount['amount']);

    total = subtotal + totalCharges + totalDiscounts;
  }

  @action
  void updateOldTotal() {
    oldTotal = total;
  }

  @action
  void increasePax() {
    if (pax < 8) {
      pax++;
      LogService.i('Increased pax to $pax.');
    }
  }

  @action
  void decreasePax() {
    if (pax > 2) {
      if (itemAssignments.values.any((assignees) => assignees.contains(pax))) {
        items.asMap().forEach((itemIndex, _) {
          removePersonFromItem(itemIndex, pax);
        });
      }
      pax--;
      LogService.i('Decreased pax to $pax.');
    }
  }

  @action
  void assignPersonToItem(int itemIndex, int personIndex) {
    itemAssignments.putIfAbsent(itemIndex, () => ObservableList<int>());
    if (!itemAssignments[itemIndex]!.contains(personIndex)) {
      itemAssignments[itemIndex]!.add(personIndex);
    }
    itemAssignments[itemIndex]!.sort();
  }

  @action
  void removePersonFromItem(int itemIndex, int personIndex) {
    itemAssignments[itemIndex]?.remove(personIndex);
  }

  @action
  void assignAllPeopleToItem(int itemIndex) {
    itemAssignments[itemIndex] =
        ObservableList<int>.of(List<int>.generate(pax, (i) => i + 1));
  }

  @action
  void clearAssignmentsFromItem(int itemIndex) {
    itemAssignments.remove(itemIndex);
  }

  @action
  num calculatePersonBill(int personIndex) {
    num personTotal = 0.0;

    for (int itemIndex = 0; itemIndex < items.length; itemIndex++) {
      if (itemAssignments.containsKey(itemIndex) &&
          itemAssignments[itemIndex]!.contains(personIndex)) {
        final assignees = itemAssignments[itemIndex]!.length;
        final itemPrice = items[itemIndex]['price'];
        final itemTotal = itemPrice + _getChargesDiscountsForItem(itemPrice);
        personTotal += itemTotal / assignees;
      }
    }

    return personTotal;
  }

  @action
  void showImageSaved() {
    isImageSavedVisible = true;
    Future.delayed(const Duration(seconds: 2), () {
      isImageSavedVisible = false;
    });
  }

  num _getChargesDiscountsForItem(num itemPrice) {
    num totalCharges =
        additionalCharges.fold(0.0, (sum, charge) => sum + charge['amount']);
    num totalDiscounts = additionalDiscounts.fold(
        0.0, (sum, discount) => sum + discount['amount']);
    return (totalCharges + totalDiscounts) *
        (itemPrice / (total - totalCharges - totalDiscounts));
  }
}