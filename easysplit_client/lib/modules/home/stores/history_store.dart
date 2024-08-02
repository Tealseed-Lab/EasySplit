import 'dart:typed_data';

import 'package:easysplit_flutter/common/models/history/history.dart';
import 'package:easysplit_flutter/common/repositories/interfaces/history_repository.dart';
import 'package:easysplit_flutter/common/services/log_service.dart';
import 'package:easysplit_flutter/common/utils/constants/sample_history.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'history_store.g.dart';

@singleton
class HistoryStore = HistoryStoreBase with _$HistoryStore;

abstract class HistoryStoreBase with Store {
  final HistoryRepository _historyRepository;

  HistoryStoreBase(this._historyRepository);

  @observable
  ObservableList<History> histories = ObservableList<History>();

  @observable
  History? lastHistory;

  @action
  Future<void> loadHistories() async {
    final historyList = await _historyRepository.getHistory();
    LogService.i('Loaded ${historyList.length} histories');
    histories = ObservableList.of(historyList);
  }

  @action
  Future<void> loadLastHistory() async {
    lastHistory = await _historyRepository.getLastHistory();
    lastHistory ??= await loadSampleHistory();
  }

  @action
  Future<void> saveHistory(
      Uint8List imageBytes,
      String items,
      String additionalCharges,
      String additionalDiscounts,
      double total,
      String friendsList) async {
    final newHistory = History(
      id: 0,
      imageBlob: imageBytes,
      items: items,
      additionalCharges: additionalCharges,
      additionalDiscounts: additionalDiscounts,
      total: total,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      deletedAt: null,
      friendsList: friendsList,
    );
    LogService.i('Saving a new history');
    await _historyRepository.addHistory(newHistory);
  }

  @action
  Future<void> deleteHistory(int id) async {
    LogService.i('Deleting history');
    await _historyRepository.removeHistory(id);
  }
}
