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

    if (connectivityStatus == ConnectivityStatus.WiFi) {
      return child;
    }

    if (connectivityStatus == ConnectivityStatus.Cellular) {
      return child;
    }

    return IgnorePointer(
      ignoring: true,
      child: Stack(children: [
        Opacity(
          opacity: opacity,
          child: child,
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: fyreworkTheme().accentColor,
              width: MediaQuery.of(context).size.width,
              height: 40,
              child: Center(
                child: Text(
                  'No Connection',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ))
      ]),
    );
  }
}
