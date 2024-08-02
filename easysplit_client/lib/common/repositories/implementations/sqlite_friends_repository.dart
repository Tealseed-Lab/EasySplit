import 'package:easysplit_flutter/common/models/friends/friend.dart';
import 'package:easysplit_flutter/common/repositories/interfaces/friends_repository.dart';
import 'package:easysplit_flutter/common/services/log_service.dart';
import 'package:easysplit_flutter/common/utils/exceptions/database_exception.dart';
import 'package:easysplit_flutter/di/database/database_client.dart';
import 'package:easysplit_flutter/di/database/tables/friend_table.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: FriendsRepository)
class SqliteFriendsRepository implements FriendsRepository {
  @factoryMethod
  SqliteFriendsRepository.of(this._databaseClient);

  final DatabaseClient _databaseClient;

  @override
  Future<List<Friend>> getFriends() async {
    final db = _databaseClient.database;
    if (db == null) {
      LogService.e('Database not initialized');
      throw AppDatabaseException(
          'Database not initialized', DatabaseErrorType.databaseNotInit);
    }
    final res = await db.query(
      FriendTable.tableName,
      where: '${FriendTable.columnDeletedAt} IS NULL',
    );
    LogService.i('Loaded ${res.length} friends');
    return List<Friend>.from(res.map(Friend.fromJson).toList().reversed);
  }

  @override
  Future<int> addFriend(Friend friend) async {
    final db = _databaseClient.database;
    if (db == null) {
      LogService.e('Database not initialized');
      throw AppDatabaseException(
          'Database not initialized', DatabaseErrorType.databaseNotInit);
    }
    final friendData = friend.toJson();
    friendData.remove('id'); // Ensure 'id' is auto-incremented by the database
    LogService.i('Adding friend: $friendData');
    return await db.insert(FriendTable.tableName, friendData);
  }

  @override
  Future<void> removeFriend(int id) async {
    final db = _databaseClient.database;
    if (db == null) {
      LogService.e('Database not initialized');
      throw AppDatabaseException(
          'Database not initialized', DatabaseErrorType.databaseNotInit);
    }
    LogService.i('Removing friend with id: $id');
    await db.update(
      FriendTable.tableName,
      {FriendTable.columnDeletedAt: DateTime.now().millisecondsSinceEpoch},
      where: '${FriendTable.columnId} = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> updateFriend(Friend friend) async {
    final db = _databaseClient.database;
    if (db == null) {
      LogService.e('Database not initialized');
      throw AppDatabaseException(
          'Database not initialized', DatabaseErrorType.databaseNotInit);
    }
    LogService.i('Updating friend with id: ${friend.id}');
    await db.update(
      FriendTable.tableName,
      friend.toJson(),
      where: '${FriendTable.columnId} = ?',
      whereArgs: [friend.id],
    );
  }
}
