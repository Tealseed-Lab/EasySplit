import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'database/database_client.dart';
import 'locator.config.dart';

final locator = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt', // default
  preferRelativeImports: true, // default
  asExtension: false, // default
  usesNullSafety: true,
)
Future<void> configureDependencies() async => $initGetIt(locator);

Future<void> initializeDependencies() async {
  // First configure dependencies to register all necessary services
  await configureDependencies();

  // Initialize DatabaseClient manually after registration to ensure it's ready
  await locator<DatabaseClient>().initDatabase();
}
