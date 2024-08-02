// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HistoryStore on HistoryStoreBase, Store {
  late final _$historiesAtom =
      Atom(name: 'HistoryStoreBase.histories', context: context);

  @override
  ObservableList<History> get histories {
    _$historiesAtom.reportRead();
    return super.histories;
  }

  @override
  set histories(ObservableList<History> value) {
    _$historiesAtom.reportWrite(value, super.histories, () {
      super.histories = value;
    });
  }

  late final _$lastHistoryAtom =
      Atom(name: 'HistoryStoreBase.lastHistory', context: context);

  @override
  History? get lastHistory {
    _$lastHistoryAtom.reportRead();
    return super.lastHistory;
  }

  @override
  set lastHistory(History? value) {
    _$lastHistoryAtom.reportWrite(value, super.lastHistory, () {
      super.lastHistory = value;
    });
  }

  late final _$loadHistoriesAsyncAction =
      AsyncAction('HistoryStoreBase.loadHistories', context: context);

  @override
  Future<void> loadHistories() {
    return _$loadHistoriesAsyncAction.run(() => super.loadHistories());
  }

  late final _$loadLastHistoryAsyncAction =
      AsyncAction('HistoryStoreBase.loadLastHistory', context: context);

  @override
  Future<void> loadLastHistory() {
    return _$loadLastHistoryAsyncAction.run(() => super.loadLastHistory());
  }

  late final _$saveHistoryAsyncAction =
      AsyncAction('HistoryStoreBase.saveHistory', context: context);

  @override
  Future<void> saveHistory(
      Uint8List imageBytes,
      String items,
      String additionalCharges,
      String additionalDiscounts,
      double total,
      String friendsList) {
    return _$saveHistoryAsyncAction.run(() => super.saveHistory(imageBytes,
        items, additionalCharges, additionalDiscounts, total, friendsList));
  }

  late final _$deleteHistoryAsyncAction =
      AsyncAction('HistoryStoreBase.deleteHistory', context: context);

  @override
  Future<void> deleteHistory(int id) {
    return _$deleteHistoryAsyncAction.run(() => super.deleteHistory(id));
  }

  @override
  String toString() {
    return '''
histories: ${histories},
lastHistory: ${lastHistory}
    ''';
  }
}
