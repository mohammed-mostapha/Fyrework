import 'dart:async';

import 'package:Fyrework/services/connectivity_status.dart';
import 'package:connectivity/connectivity.dart';

class ConnectivityService {
  StreamController<ConnectivityStatus> connectionStatusController =
      StreamController<ConnectivityStatus>();

  ConnectivityService() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      print('connection is: changed');
      // convert this result into our enum
      var connectionStatus = _getStatusFromResult(result);

      // Emit this over our stream
      connectionStatusController.add(connectionStatus);
    });
  }

  ConnectivityStatus _getStatusFromResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.mobile:
        print('connection is: cellular');
        return ConnectivityStatus.Cellular;
      case ConnectivityResult.wifi:
        print('connection is: wifi');
        return ConnectivityStatus.WiFi;
      case ConnectivityResult.none:
        print('connection is: offline');
        return ConnectivityStatus.Offline;

      default:
        return ConnectivityStatus.Offline;
    }
  }
}
