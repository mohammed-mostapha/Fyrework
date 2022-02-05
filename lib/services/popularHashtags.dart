import 'package:Fyrework/firebase_database/firestore_database.dart';

class PopularHashtagsService {
  static Future<List> fetchPopularHashtags(String query) async {
    await Future.delayed(Duration(seconds: 1));
    return await FirestoreDatabase().fetchPopularHashtags(query);
  }
}
