import 'dart:math';
import 'package:myApp/services/database.dart';

class BackendService {
  static Future<List> getSuggestions(String query) async {
    List filteredHashtags = List();
    await Future.delayed(Duration(seconds: 1));
    return await DatabaseService().fetchPopularHashtags(query);
  }
}
