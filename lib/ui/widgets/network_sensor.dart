import 'package:Fyrework/services/connectivity_status.dart';
import 'package:Fyrework/ui/shared/fyreworkTheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NetworkSensor extends StatelessWidget {
  final Widget child;
  final double opacity;

  NetworkSensor({this.child, this.opacity = 0.5});
  @override
  Widget build(BuildContext context) {
    var connectivityStatus = Provider.of<ConnectivityStatus>(context);

    var isWiFi = connectivityStatus == ConnectivityStatus.WiFi;
    var isCellular = connectivityStatus == ConnectivityStatus.Cellular;

    return IgnorePointer(
      ignoring: isWiFi || isCellular ? false : true,
      child: Stack(
        children: [
          Opacity(
            opacity: isWiFi || isCellular ? 1 : opacity,
            child: child,
          ),
          !(isWiFi || isCellular)
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: fyreworkTheme().accentColor,
                    width: MediaQuery.of(context).size.width,
                    height: 30,
                    child: Center(
                      child: Text(
                        'No Connection',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  ))
              : Container(
                  width: 0,
                  height: 0,
                ),
        ],
      ),
    );
  }
}
