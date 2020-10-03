import 'package:myApp/models/user.dart';
import 'package:myApp/services/auth_service.dart';
import 'package:myApp/services/storage_repo.dart';
import 'package:myApp/services/firestore_service.dart';
import 'package:get_it/get_it.dart';
import 'package:myApp/services/navigation_service.dart';
import 'package:myApp/services/dialog_service.dart';
import 'package:myApp/vew_controllers/user_controller.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => FirestoreService());
  locator.registerLazySingleton(() => StorageRepo());
  locator.registerLazySingleton(() => User());
  locator.registerLazySingleton(() => UserController());
}
