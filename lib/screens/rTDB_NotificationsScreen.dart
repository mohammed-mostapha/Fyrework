import 'package:Fyrework/custom_widgets/individual_gig_item.dart';
import 'package:Fyrework/models/myUser.dart';
import 'package:Fyrework/firebase_database/realtime_database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeAgo;

class RTDBNotificationsScreen extends StatefulWidget {
  const RTDBNotificationsScreen({Key key}) : super(key: key);

  @override
  _RTDBNotificationsScreenState createState() =>
      _RTDBNotificationsScreenState();
}

class _RTDBNotificationsScreenState extends State<RTDBNotificationsScreen> {
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
                          builder: (context) => IndividualGigItem(
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

  @override
  void dispose() {
    super.dispose();
  }
}
