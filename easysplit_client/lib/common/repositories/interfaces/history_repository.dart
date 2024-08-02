import 'package:easysplit_flutter/common/models/history/history.dart';

abstract class HistoryRepository {
  Future<List<History>> getHistory();
  Future<History?> getLastHistory();
  Future<int> addHistory(History history);
  Future<void> removeHistory(int id);
  Future<void> updateHistory(History history);
}
