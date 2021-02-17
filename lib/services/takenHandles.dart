import 'dart:math';
import 'package:Fyrework/services/database.dart';

class TakenHandlesService {
  static Future<List> fetchTakenHandles(String query) async {
    // List filteredHashtags = List();
    await Future.delayed(Duration(seconds: 1));
    return await DatabaseService().fetchTakenHandles(query);
  }
}
