class FriendTable {
  static const String tableName = 'friends';
  static const String columnId = 'id';
  static const String columnName = 'name';
  static const String columnColor = 'color';
  static const String columnCreatedAt = 'created_at';
  static const String columnDeletedAt = 'deleted_at';
  static const String columnIsSelected = 'is_selected';

  static String create() {
    return '''
      CREATE TABLE IF NOT EXISTS $tableName (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL,
        $columnColor TEXT NOT NULL,
        $columnCreatedAt INTEGER NOT NULL,
        $columnDeletedAt INTEGER,
        $columnIsSelected INTEGER NOT NULL
      );
    ''';
  }
}
