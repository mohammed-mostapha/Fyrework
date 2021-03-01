import 'package:flutter/foundation.dart';

class GigIndexProvider extends ChangeNotifier {
  static int _gigIndex = 0;

  int getGigIndex() => _gigIndex;

  assignGigIndex(int assignedGigIndex) {
    _gigIndex = assignedGigIndex;
    print('from the provider: ${getGigIndex()}');
    notifyListeners();
  }
}
