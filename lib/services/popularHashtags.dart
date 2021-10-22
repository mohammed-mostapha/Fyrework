import 'dart:math';
import 'package:Fyrework/services/database.dart';

class PopularHashtagsService {
  static Future<List> fetchPopularHashtags(String query) async {
    // List filteredHashtags = List();
    await Future.delayed(Duration(seconds: 1));
    return await DatabaseService().fetchPopularHashtags(query);
  }
}
