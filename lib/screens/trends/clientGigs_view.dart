import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:Fyrework/main.dart';
import 'package:Fyrework/models/myUser.dart';
import 'package:Fyrework/services/database.dart';
import 'package:Fyrework/ui/widgets/gig_item.dart';
import 'package:flutter/material.dart';

class ClientGigsView extends StatelessWidget {
  ClientGigsView({Key key}) : super(key: key);
  // String currentUserId = UserController.currentUserId;
  final String currentUserId = MyUser.uid;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: DatabaseService().listenToCilentGigs(),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? Center(child: Text(''))
              : snapshot.data.documents.length > 0
                  ? ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot data = snapshot.data.documents[index];
                        Map getDocData = data.data;

                        return GestureDetector(
                          // onTap: () => model.editGig(index),
                          child: GigItem(
                            appointed: getDocData['appointed'],
                            appointedusername:
                                getDocData['appointedUserFullName'],
                            gigId: getDocData['gigId'],
                            currentUserId: currentUserId,
                            gigOwnerId: getDocData['gigOwnerId'],
                            gigOwnerAvatarUrl: getDocData['gigOwnerAvatarUrl'],
                            gigOwnerUsername: getDocData['gigOwnerUsername'],
                            createdAt: getDocData['createdAt'],
                            gigOwnerLocation: getDocData['gigOwnerLocation'],
                            gigLocation: getDocData['gigLocation'],
                            gigHashtags: getDocData['gigHashtags'],
                            gigMediaFilesDownloadUrls:
                                getDocData['gigMediaFilesDownloadUrls'],
                            gigPost: getDocData['gigPost'],
                            gigDeadline:
                                getDocData['gigDeadlineInUnixMilliseconds'],
                            gigCurrency: getDocData['gigCurrency'],
                            gigBudget: getDocData['gigBudget'],
                            gigValue: getDocData['gigValue'],
                            gigLikes: getDocData['gigLikes'],
                            adultContentText: getDocData['adultContentText'],
                            adultContentBool: getDocData['adultContentBool'],
                            appointedUserId: getDocData['appointedUserId'],
                            hidden: getDocData['hidden'],

                            // onDeleteItem: () => model.deleteGig(index),
                          ),
                        );
                      })
                  : Center(
                      child: Text(
                      'No gigs matching your criteria',
                      style: TextStyle(fontSize: 16),
                    ));
        },
      ),
    );
  }

  void scheduleNotification() async {
    var scheduleNotificationDateTime = DateTime.now().add(Duration(seconds: 5));

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'Fyrework',
      'Fyrework',
      'Fyrework',
      // color: Colors.transparent,
      showWhen: true,
      icon: 'ic_notification',
      sound: RawResourceAndroidNotificationSound('ios_notification_sound'),
      importance: Importance.max,
      priority: Priority.max,
      largeIcon: DrawableResourceAndroidBitmap('ic_launcher_round'),
    );

    var iOSPlatformSChannelSpecifics = IOSNotificationDetails(
      sound: 'ios_notification_sound',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformSChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.schedule(
      1,
      'Fyrework',
      'You have a new notification',
      scheduleNotificationDateTime,
      platformChannelSpecifics,
    );
  }
}
