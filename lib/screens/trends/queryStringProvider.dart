import 'package:flutter/foundation.dart';

class QueryStringProvider extends ChangeNotifier {
  String _queryString = '';

  String getQueryString() => _queryString;

  updateQueryString(String userQueryString) {
    _queryString = userQueryString;
    notifyListeners();
  }
}
