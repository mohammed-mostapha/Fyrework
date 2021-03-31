import 'package:Fyrework/services/connectivity_provider.dart';
import 'package:Fyrework/services/connectivity_status.dart';
import 'package:Fyrework/ui/shared/fyreworkTheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NetworkSensor extends StatefulWidget {
  final Widget child;
  final double opacity;

  NetworkSensor({this.child, this.opacity = 0.5});

  @override
  _NetworkSensorState createState() => _NetworkSensorState();
}

class _NetworkSensorState extends State<NetworkSensor> {
  @override
  void initState() {
    super.initState();
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
      builder: (context, model, chilZ) {
        if (model.isOnline != null) {
          return IgnorePointer(
            ignoring: model.isOnline ? false : true,
            child: Stack(
              children: [
                Opacity(
                  opacity: model.isOnline ? 1 : widget.opacity,
                  child: widget.child,
                ),
                !model.isOnline
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          color: fyreworkTheme().accentColor,
                          width: MediaQuery.of(context).size.width,
                          height: 30,
                          child: Center(
                            child: Text(
                              'No internet connection',
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

        return Container(
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
