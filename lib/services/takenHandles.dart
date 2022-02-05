import 'package:Fyrework/firebase_database/firestore_database.dart';

class TakenHandlesService {
  static Future<List> fetchTakenHandles(String query) async {
    await Future.delayed(Duration(seconds: 1));
    return await FirestoreDatabase().fetchTakenHandles(query);
  }
}
