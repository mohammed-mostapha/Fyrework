import 'package:Fyrework/services/database.dart';
import 'package:Fyrework/ui/widgets/notification_Item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder(
          stream: DatabaseService().fetchAllNotifications(),
          builder: (_, allNotificationsSnapshot) {
            if (!allNotificationsSnapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                  strokeWidth: 2.0,
                ),
              );
            } else if (!(allNotificationsSnapshot.data.docs.length > 0)) {
              return Center(
                child: Text(
                  'Notifications list is empty',
                  style: Theme.of(context).textTheme.headline6,
                ),
              );
            } else {
              return SmartRefresher(
                controller: _refreshController,
                header: WaterDropHeader(
                  refresh: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                      strokeWidth: 2.0,
                    ),
                  ),
                  complete: Container(),
                  completeDuration: Duration(microseconds: 100),
                ),
                enablePullDown: true,
                child: ListView.builder(
                    addAutomaticKeepAlives: false,
                    cacheExtent: 100.0,
                    itemCount: allNotificationsSnapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot data =
                          allNotificationsSnapshot.data.docs[index];
                      Map getDocData = data.data();
                      return NotificationItem(
                        index: index,
                        notificationId: getDocData['notificationId'],
                        gigId: getDocData['gigId'],
                        notificationTitle: getDocData['notificationTitle'],
                        notificationBody: getDocData['notificationBody'],
                        seen: getDocData['seen'],
                        generalNotification: getDocData['generalNotification'],
                        createdAt: getDocData['createdAt'],
                      );
                    }),
              );
            }
          },
        ),
      ),
    );
  }
}
