import 'package:Fyrework/screens/trends/queryStringProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:Fyrework/main.dart';
import 'package:Fyrework/models/myUser.dart';
import 'package:Fyrework/services/database.dart';
import 'package:Fyrework/ui/widgets/gig_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'gigIndexProvider.dart';

class ClientGigsView extends StatefulWidget {
  ClientGigsView({Key key}) : super(key: key);

  @override
  _ClientGigsViewState createState() => _ClientGigsViewState();
}

class _ClientGigsViewState extends State<ClientGigsView> {
  final String currentUserId = MyUser.uid;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    if (mounted) setState(() {});
    _refreshController.refreshCompleted();
    print('smartRefresher: refresh');
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    if (mounted) setState(() {});
    _refreshController.loadComplete();
    print('smartRefresher: loadComplete');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
              FutureBuilder<QuerySnapshot>(
                future: DatabaseService()
                    .filterCilentGigs(QueryStringProvider.getQueryString()),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    //start
                    return SmartRefresher(
                      enablePullDown: true,
                      child: ListView.builder(itemBuilder: (context, index) {
                        return Center(child: Text(''));
                      }),
                      controller: _refreshController,
                      onRefresh: _onRefresh,
                      onLoading: _onLoading,
                    );
                    //end

                  } else if (snapshot.data.docs.length > 0) {
                    print('smartRefresher: you should see gigs now');
                    return SmartRefresher(
                      enablePullDown: true,
                      child: ListView.builder(
                          addAutomaticKeepAlives: false,
                          cacheExtent: 100.0,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot data = snapshot.data.docs[index];
                            Map getDocData = data.data();

                            return getDocData['hidden'] != true
                                ? GigItem(
                                    index: index,
                                    appointed: getDocData['appointed'],
                                    appointedusername:
                                        getDocData['appointedUserFullName'],
                                    appliersOrHirersByUserId:
                                        getDocData['appliersOrHirersByUserId'],
                                    gigRelatedUsersByUserId:
                                        getDocData['gigRelatedUsersByUserId'],
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
                                    gigCurrency: getDocData['gigCurrency'],
                                    gigBudget: getDocData['gigBudget'],
                                    gigValue: getDocData['gigValue'],
                                    adultContentText:
                                        getDocData['adultContentText'],
                                    adultContentBool:
                                        getDocData['adultContentBool'],
                                    appointedUserId:
                                        getDocData['appointedUserId'],
                                    hidden: getDocData['hidden'],
                                    gigActions: getDocData['gigActions'],
                                    paymentReleased:
                                        getDocData['paymentReleased'],
                                    markedAsComplete:
                                        getDocData['markedAsComplete'],
                                    clientLeftReview:
                                        getDocData['clientLeftReview'],
                                    likesCount: getDocData['likesCount'],
                                    likersByUserId:
                                        getDocData['likersByUserId'],
                                  )
                                : Container(
                                    width: 0,
                                    height: 0,
                                  );
                          }),
                      controller: _refreshController,
                      onRefresh: _onRefresh,
                      onLoading: _onLoading,
                    );
                  } else {
                    //start
                    return SmartRefresher(
                      enablePullDown: true,
                      child: ListView.builder(itemBuilder: (context, index) {
                        return Center(child: Text(''));
                      }),
                      controller: _refreshController,
                      onRefresh: _onRefresh,
                      onLoading: _onLoading,
                    );
                    //end
                  }
                },
              ),
              //end of FutureBuilder

              //end of smart refresh
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
  }
}
