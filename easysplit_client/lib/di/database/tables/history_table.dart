class HistoryTable {
  static const String tableName = 'history';
  static const String columnId = 'id';
  static const String columnImage = 'image_blob';
  static const String columnItems = 'items';
  static const String columnAdditionalCharges = 'additional_charges';
  static const String columnAdditionalDiscounts = 'additional_discounts';
  static const String columnTotal = 'total';
  static const String columnCreatedAt = 'created_at';
  static const String columnDeletedAt = 'deleted_at';
  static const String columnFriendsList = 'friends_list';

  static String create() {
    return '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnImage BLOB NOT NULL,
      $columnItems TEXT NOT NULL,
      $columnAdditionalCharges TEXT NOT NULL,
      $columnAdditionalDiscounts TEXT NOT NULL,
      $columnTotal REAL NOT NULL,
      $columnCreatedAt INTEGER NOT NULL,
      $columnDeletedAt INTEGER,
      $columnFriendsList TEXT NOT NULL
    );
  ''';
  }
}
