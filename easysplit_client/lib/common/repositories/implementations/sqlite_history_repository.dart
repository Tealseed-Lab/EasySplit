import 'package:easysplit_flutter/common/models/history/history.dart';
import 'package:easysplit_flutter/common/repositories/interfaces/history_repository.dart';
import 'package:easysplit_flutter/common/services/log_service.dart';
import 'package:easysplit_flutter/common/utils/exceptions/database_exception.dart';
import 'package:easysplit_flutter/di/database/database_client.dart';
import 'package:easysplit_flutter/di/database/tables/history_table.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: HistoryRepository)
class SqliteHistoryRepository implements HistoryRepository {
  @factoryMethod
  SqliteHistoryRepository.of(this._databaseClient);

  final DatabaseClient _databaseClient;

  @override
  Future<List<History>> getHistory() async {
    final db = _databaseClient.database;
    if (db == null) {
      LogService.e('Database not initialized');
      throw AppDatabaseException(
          'Database not initialized', DatabaseErrorType.databaseNotInit);
    }
    final res = await db.query(
      HistoryTable.tableName,
      where: '${HistoryTable.columnDeletedAt} IS NULL',
    );

    LogService.i('Loaded ${res.length} histories');

    return List<History>.from(
        res.map((json) => History.fromJson(json)).toList().reversed);
  }

  @override
  Future<History?> getLastHistory() async {
    final db = _databaseClient.database;
    if (db == null) {
      LogService.e('Database not initialized');
      throw AppDatabaseException(
          'Database not initialized', DatabaseErrorType.databaseNotInit);
    }
    final res = await db.query(
      HistoryTable.tableName,
      orderBy: '${HistoryTable.columnCreatedAt} DESC',
      limit: 1,
    );
    if (res.isEmpty) return null;
    LogService.i(
        'Loaded last history with id ${res.first[HistoryTable.columnId]}');
    return History.fromJson(res.first);
  }

  @override
  Future<int> addHistory(History history) async {
    final db = _databaseClient.database;
    if (db == null) {
      LogService.e('Database not initialized');
      throw AppDatabaseException(
          'Database not initialized', DatabaseErrorType.databaseNotInit);
    }
    final historyData = history.toJson();
    historyData.remove('id');
    LogService.i('Adding history with total: ${history.total}');
    return await db.insert(HistoryTable.tableName, historyData);
  }

  @override
  Future<void> updateHistory(History history) async {
    final db = _databaseClient.database;
    if (db == null) {
      LogService.e('Database not initialized');
      throw AppDatabaseException(
          'Database not initialized', DatabaseErrorType.databaseNotInit);
    }
    LogService.i('Updating history: $history');
    await db.update(
      HistoryTable.tableName,
      history.toJson(),
      where: '${HistoryTable.columnId} = ?',
      whereArgs: [history.id],
    );
  }

  @override
  Future<void> removeHistory(int id) async {
    final db = _databaseClient.database;
    if (db == null) {
      LogService.e('Database not initialized');
      throw AppDatabaseException(
          'Database not initialized', DatabaseErrorType.databaseNotInit);
    }
    LogService.i('Removing history with id: $id');
    await db.update(
      HistoryTable.tableName,
      {HistoryTable.columnDeletedAt: DateTime.now().millisecondsSinceEpoch},
      where: '${HistoryTable.columnId} = ?',
      whereArgs: [id],
    );
  }
}
