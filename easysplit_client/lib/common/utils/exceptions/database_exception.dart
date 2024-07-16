enum DatabaseErrorType { databaseNotInit }

class AppDatabaseException extends Error implements Exception {
  final DatabaseErrorType databaseErrorType;
  final String message;

  AppDatabaseException(this.message, this.databaseErrorType);
}
