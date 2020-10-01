import 'package:flutter/material.dart';
import 'package:myApp/screens/add_gig/image_picker.dart';
import 'package:myApp/screens/add_gig/video_picker.dart';
import 'package:myApp/ui/shared/theme.dart';

import 'assets_picker/pages/multi_assets_picker.dart';

class AddGigMedia extends StatefulWidget {
  @override
  _AddGigMediaState createState() => _AddGigMediaState();
}

class _AddGigMediaState extends State<AddGigMedia> {
  @override
  void dispose() {
    // Additional disposal code
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Center(
    //       child: Text(
    //         'AddGigMedia2',
    //         style:
    //             TextStyle(color: FyreworkrColors.fyreworkBlack, fontSize: 30),
    //         textAlign: TextAlign.center,
    //       ),
    //     ),
    //     backgroundColor: FyreworkrColors.white,
    //   ),
    //   body: Container(
    //     child: ListView.builder(
    //       itemCount: 200,
    //       itemBuilder: (context, index) {
    //         return Padding(
    //           padding: const EdgeInsets.all(10.0),
    //           child: Card(
    //             color: index % 2 == 0 ? Colors.teal : null,
    //             child: Column(
    //               children: <Widget>[
    //                 Text(
    //                   '#Hashtag ${index + 1}',
    //                   style: TextStyle(
    //                     fontSize: 20,
    //                     color: index % 2 == 0 ? Colors.white : null,
    //                     fontWeight: FontWeight.bold,
    //                   ),
    //                 ),
    //                 SizedBox(
    //                   height: 10,
    //                 ),
    //                 Text(
    //                     'lorem ipsum lorem ipsum lorem ipsumlorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum',
    //                     style: TextStyle(fontSize: 20)),
    //               ],
    //             ),
    //           ),
    //         );
    //       },
    //     ),
    //   ),
    // );

    return Scaffold(
      body: Container(
          // child: MultiAssetsPicker(),
          ),
    );
  }
}
