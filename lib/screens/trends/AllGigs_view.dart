import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:Fyrework/main.dart';
import 'package:Fyrework/models/myUser.dart';
import 'package:Fyrework/services/database.dart';
import 'package:Fyrework/ui/widgets/gig_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Fyrework/screens/trends/queryStringProvider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:Fyrework/screens/trends/gigIndexProvider.dart';

class AllGigsView extends StatefulWidget {
  AllGigsView({Key key}) : super(key: key);
  // String currentUserId = UserController.currentUserId;

  @override
  _AllGigsViewState createState() => _AllGigsViewState();
}

class _AllGigsViewState extends State<AllGigsView> {
  final String currentUserId = MyUser.uid;
  int gigsCount;
  ItemScrollController gigScrollController;
  ItemPositionsListener gigPositionsListener;
  dynamic gigIndexProvider;

  @override
  void initState() {
    super.initState();
    gigIndexProvider = Provider.of<GigIndexProvider>(context, listen: false);
    gigScrollController = ItemScrollController();
    gigPositionsListener = ItemPositionsListener.create();
    shouldScroll();
  }

  Future shouldScroll() async {
    QuerySnapshot gigsDocuments =
        await Firestore.instance.collection('gigs').getDocuments();
    List<DocumentSnapshot> listOfGigsToCount = gigsDocuments.documents;
    gigsCount = listOfGigsToCount.length;

    if (gigsCount > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration(milliseconds: 2000), () {
          scrollToGigByIndex(
            gigIndex: gigIndexProvider.getGigIndex(),
          );
          gigIndexProvider.assignGigIndex(0);
        });
      });
    }
  }

  void scrollToGigByIndex({int gigIndex}) {
    print('should scroll to index: $gigIndex');
    gigScrollController.scrollTo(
        index: gigIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      child: Consumer2<QueryStringProvider, GigIndexProvider>(
        builder: (context, QueryStringProvider, GigIndexProvider, _) {
          return Stack(
            children: [
              Center(
                child: Text(
                  'No gigs matching your criteria',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: DatabaseService()
                    .filterAllGigs(QueryStringProvider.getQueryString()),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: Text(''));
                  } else if (snapshot.data.documents.length > 0) {
                    return ScrollablePositionedList.builder(
                        itemScrollController: gigScrollController,
                        itemPositionsListener: gigPositionsListener,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot data =
                              snapshot.data.documents[index];
                          Map getDocData = data.data;

                          return getDocData['hidden'] != true
                              ? GigItem(
                                  index: index,
                                  appointed: getDocData['appointed'],
                                  appointedusername:
                                      getDocData['appointedUserFullName'],
                                  appliersOrHirersByUserId:
                                      getDocData['appliersOrHirersByUserId'],
                                  gigId: getDocData['gigId'],
                                  currentUserId: currentUserId,
                                  gigOwnerId: getDocData['gigOwnerId'],
                                  gigOwnerAvatarUrl:
                                      getDocData['gigOwnerAvatarUrl'],
                                  gigOwnerUsername:
                                      getDocData['gigOwnerUsername'],
                                  createdAt: getDocData['createdAt'],
                                  gigOwnerLocation:
                                      getDocData['gigOwnerLocation'],
                                  gigLocation: getDocData['gigLocation'],
                                  gigHashtags: getDocData['gigHashtags'],
                                  gigMediaFilesDownloadUrls:
                                      getDocData['gigMediaFilesDownloadUrls'],
                                  gigPost: getDocData['gigPost'],
                                  // gigDeadline: getDocData['gigDeadline'],
                                  gigCurrency: getDocData['gigCurrency'],
                                  gigBudget: getDocData['gigBudget'],
                                  gigValue: getDocData['gigValue'],
                                  gigLikes: getDocData['gigLikes'],
                                  adultContentText:
                                      getDocData['adultContentText'],
                                  adultContentBool:
                                      getDocData['adultContentBool'],
                                  appointedUserId:
                                      getDocData['appointedUserId'],
                                  hidden: getDocData['hidden'],
                                )
                              : Container(
                                  width: 0,
                                  height: 0,
                                );
                        });
                  } else {
                    // return Center(
                    //   child: Text(
                    //     'No gigs matching your criteria',
                    //     style: TextStyle(fontSize: 16),
                    //   ),
                    return Container(
                      width: 0,
                      height: 0,
                    );
                  }
                },
              ),
            ],
          );
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
