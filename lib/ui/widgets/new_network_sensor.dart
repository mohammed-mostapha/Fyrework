import 'package:Fyrework/services/connectivity_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewNetworkSensor extends StatefulWidget {
  @override
  _NewNetworkSensorState createState() => _NewNetworkSensorState();
}

class _NewNetworkSensorState extends State<NewNetworkSensor> {
  @override
  void initState() {
    super.initState();
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
  }

  @override
  Widget build(BuildContext context) {
    return pageUI();
  }

  Widget pageUI() {
    return Consumer<ConnectivityProvider>(
      builder: (context, model, child) {
        if (model.isOnline != null) {
          if (model.isOnline) {
            print('connection consumer: online');
            return Container(
              child: Center(
                child: Text(
                  'Home Page',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            );
          } else {
            print('connection consumer: offline');
            return Container(
              child: Center(
                child: Text(
                  'No Internet',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            );
          }

          // return model.isOnline
          //     ? Container(
          //         child: Center(
          //           child: Text(
          //             'Home Page',
          //             style:
          //                 TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          //           ),
          //         ),
          //       )
          //     : Container(
          //         child: Center(
          //           child: Text(
          //             'No Internet',
          //             style:
          //                 TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          //           ),
          //         ),
          //       );
        }

        return Container(
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
