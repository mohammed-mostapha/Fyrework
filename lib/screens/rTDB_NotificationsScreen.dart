import 'dart:async';

import 'package:Fyrework/models/myUser.dart';
import 'package:Fyrework/services/database.dart';
import 'package:Fyrework/services/realtime_database.dart';
import 'package:Fyrework/ui/widgets/individual_gig_item.dart';
import 'package:Fyrework/ui/widgets/notification_Item.dart';
import 'package:Fyrework/ui/widgets/notification_item_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:timeago/timeago.dart' as timeAgo;

// class NotificationsScreen extends StatefulWidget {
//   const NotificationsScreen({Key key}) : super(key: key);

//   @override
//   _NotificationsScreenState createState() => _NotificationsScreenState();
// }

// class _NotificationsScreenState extends State<NotificationsScreen> {
//   RefreshController _refreshController =
//       RefreshController(initialRefresh: false);
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: StreamBuilder(
//           stream: DatabaseService().fetchAllNotifications(),
//           builder: (_, allNotificationsSnapshot) {
//             if (!allNotificationsSnapshot.hasData) {
//               return Center(
//                 child: CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(
//                       Theme.of(context).primaryColor),
//                   strokeWidth: 2.0,
//                 ),
//               );
//             } else if (!(allNotificationsSnapshot.data.docs.length > 0)) {
//               return Center(
//                 child: Text(
//                   'Notifications list is empty',
//                   style: Theme.of(context).textTheme.headline6,
//                 ),
//               );
//             } else {
//               return SmartRefresher(
//                 controller: _refreshController,
//                 header: WaterDropHeader(
//                   refresh: SizedBox(
//                     width: 20,
//                     height: 20,
//                     child: CircularProgressIndicator(
//                       valueColor: AlwaysStoppedAnimation<Color>(
//                         Theme.of(context).primaryColor,
//                       ),
//                       strokeWidth: 2.0,
//                     ),
//                   ),
//                   complete: Container(),
//                   completeDuration: Duration(microseconds: 100),
//                 ),
//                 enablePullDown: true,
//                 child: ListView.builder(
//                     addAutomaticKeepAlives: false,
//                     cacheExtent: 100.0,
//                     itemCount: allNotificationsSnapshot.data.docs.length,
//                     itemBuilder: (context, index) {
//                       DocumentSnapshot data =
//                           allNotificationsSnapshot.data.docs[index];
//                       Map getDocData = data.data();
//                       return NotificationItem(
//                         index: index,
//                         notificationId: getDocData['notificationId'],
//                         gigId: getDocData['gigId'],
//                         notificationTitle: getDocData['notificationTitle'],
//                         notificationBody: getDocData['notificationBody'],
//                         seen: getDocData['seen'],
//                         generalNotification: getDocData['generalNotification'],
//                         createdAt: getDocData['createdAt'],
//                       );
//                     }),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

class RTDBNotificationsScreen extends StatefulWidget {
  const RTDBNotificationsScreen({Key key}) : super(key: key);

  @override
  _RTDBNotificationsScreenState createState() =>
      _RTDBNotificationsScreenState();
}

class _RTDBNotificationsScreenState extends State<RTDBNotificationsScreen> {
  StreamSubscription _myNotificationsStream;
  String _notificationBody = '';
  String likerUserAvatarUrl = '';
  String gigId = '';
  final _rTDB = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder(
          stream: _rTDB
              .child('/users/${MyUser.uid}')
              .orderByKey()
              .limitToLast(10)
              .onValue,
          builder: (context, notificationsSnapshot) {
            final _notificationsList = <Widget>[];
            if (!notificationsSnapshot.hasData) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor)),
                ),
              );
            } else if (notificationsSnapshot.hasData &&
                !notificationsSnapshot.hasError &&
                notificationsSnapshot.data.snapshot.value != null) {
              final _notifications = Map<String, dynamic>.from(
                  (notificationsSnapshot.data as Event).snapshot.value);
              _notifications.forEach(
                (key, value) {
                  final _notification = Map<String, dynamic>.from(value);
                  final _notificationTile = InkWell(
                    onTap: () async {
                      await RealTimeDatabase().markNotificationAsSeen(
                        myUserId: MyUser.uid,
                        notificationId: _notification['notificationId'],
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Individual_gig_item(
                            gigId: _notification['gigId'],
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: Container(
                        child: CircleAvatar(
                          maxRadius: 15,
                          backgroundColor: Theme.of(context).primaryColor,
                          backgroundImage: NetworkImage(
                            // likerUserAvatarUrl,
                            _notification['userAvatarUrl'],
                          ),
                        ),
                      ),
                      title: Text(
                        _notification['body'],
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      subtitle: Text(
                        timeAgo.format(
                          DateTime.fromMillisecondsSinceEpoch(
                            _notification['createdAt'],
                          ),
                        ),
                        // timeAgo.format(_notification['createdAt'].toDate()),
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  );
                  _notificationsList.add(_notificationTile);
                },
              );
              return Column(
                children: [
                  Expanded(
                    child: ListView(children: _notificationsList),
                  ),
                ],
              );
            } else {
              return Container(
                child: Center(
                  child: Text(
                    'No Notifications',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  // @override
  // void deactivate() {
  //   // _myNotificationsStream.cancel();
  //   // super.deactivate();
  // }

  @override
  void dispose() {
    super.dispose();
  }
}
