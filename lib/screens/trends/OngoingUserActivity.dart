import 'package:flutter/material.dart';
import 'package:myApp/ui/shared/theme.dart';

class OngoingUserActivity extends StatefulWidget {
  @override
  _OngoingUserActivityState createState() => _OngoingUserActivityState();
}

class _OngoingUserActivityState extends State<OngoingUserActivity>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    // return Container(
    //   child: ListView.builder(
    //     itemCount: 200,
    //     itemBuilder: (context, index) {
    //       return Padding(
    //         padding: const EdgeInsets.all(10.0),
    //         child: Card(
    //           color:
    //               index % 2 == 0 ? Colors.teal : FyreworkrColors.fyreworkBlack,
    //           child: Column(
    //             children: <Widget>[
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                 children: <Widget>[
    //                   Icon(
    //                     Icons.account_circle,
    //                     size: 30,
    //                     color: FyreworkrColors.white,
    //                   ),
    //                   Text(
    //                     'Account No. ${index + 1}',
    //                     style: TextStyle(
    //                         fontSize: 30, color: FyreworkrColors.white),
    //                   ),
    //                   Icon(
    //                     Icons.mail,
    //                     size: 30,
    //                     color: FyreworkrColors.white,
    //                   ),
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ),
    //       );
    //     },
    //   ),
    // );
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Flexible(
              child: Text(
            'Here you will see your user activity...you gigs...or gigs you\'ve liked',
            style: TextStyle(fontSize: 18.0),
          )),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
