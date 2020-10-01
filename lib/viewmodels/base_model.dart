import 'package:myApp/locator.dart';
import 'package:myApp/models/user.dart';
import 'package:flutter/widgets.dart';
import 'package:myApp/services/authentication_service.dart';

class BaseModel extends ChangeNotifier {
  // final AuthenticationService _authenticationService =
  //     locator<AuthenticationService>();

  // User get currentUser => _authenticationService.currentUser;

  bool _busy = false;
  bool get busy => _busy;

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }
}
