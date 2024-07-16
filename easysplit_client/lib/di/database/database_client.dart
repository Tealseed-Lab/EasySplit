import 'dart:io';

import 'package:easysplit_flutter/common/services/log_service.dart';
import 'package:easysplit_flutter/di/database/tables/friend_table.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class DatabaseClient {
  Future<Database> initDatabase();
  Future<void> clearDatabase();
  Future<String> databasePath();
  Database? get database;
  String get databaseName;
}

@Singleton(as: DatabaseClient)
class SqliteDatabaseClient extends DatabaseClient {
  Database? _database;

  @override
  Future<Database> initDatabase() async {
    final path = await databasePath();

    if (File(path).existsSync()) {
      LogService.i('Database already initialized at path: $path');
      _database = await openDatabase(path);
      return _database!;
    }

    final db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        final batch = db.batch();
        batch.execute(FriendTable.create());
        await batch.commit();
        LogService.i('Database created at path: $path');
      },
    );
    _database = db;
    LogService.i('Database initialized at path: $path');

    return db;
  }

  @override
  Future<void> clearDatabase() async {
    _database?.close();
    _database = null;
    final path = await databasePath();
    await deleteDatabase(path);
    await initDatabase();
    LogService.i('Database cleared and reinitialized at path: $path');
  }

  @override
  Future<String> databasePath() async {
    final path = join(await getDatabasesPath(), databaseName);
    LogService.i('Database path: $path');
    return path;
  }

  @override
  Database? get database => _database;

  @override
  String get databaseName => 'easysplit.db';
}
