import 'package:Fyrework/firebase_database/realtime_database.dart';
import 'package:Fyrework/models/myUser.dart';
import 'package:Fyrework/services/auth_service.dart';
import 'package:Fyrework/services/storage_repo.dart';
import 'package:Fyrework/firebase_database/firestore_database.dart';
import 'package:get_it/get_it.dart';
import 'package:Fyrework/services/navigation_service.dart';
import 'package:Fyrework/services/dialog_service.dart';
import 'package:Fyrework/view_controllers/myUser_controller.dart';

import 'models/otherUser.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => FirestoreDatabase());
  locator.registerLazySingleton(() => StorageRepo());
  locator.registerLazySingleton(() => MyUser());
  locator.registerLazySingleton(() => OtherUser());
  locator.registerLazySingleton(() => MyUserController());
  locator.registerLazySingleton(() => RealTimeDatabase());
}
