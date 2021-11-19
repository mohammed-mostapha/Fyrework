import 'dart:core';
import 'package:Fyrework/models/myUser.dart';
import 'package:Fyrework/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'gig_item.dart';

class Individual_gig_item extends StatefulWidget {
  final gigId;
  Individual_gig_item({
    Key key,
    @required this.gigId,
  }) : super(key: key);

  @override
  _Individual_gig_itemState createState() => _Individual_gig_itemState();
}

class _Individual_gig_itemState extends State<Individual_gig_item> {
  final String currentUserId = MyUser.uid;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<QuerySnapshot>(
        stream: DatabaseService().fetchIndividualGig(gigId: widget.gigId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text(
                'Gig is not available',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            );
          } else if (!(snapshot.data.docs.length > 0)) {
            return Center(
              child: Text(
                'Gig is not available',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            );
          } else {
            print('smartRefresher: you should see gigs right now');

            DocumentSnapshot data = snapshot.data.docs[0];
            Map getDocData = data.data();

            return getDocData['hidden'] != true
                ? GigItem(
                    appointed: getDocData['appointed'],
                    appointedUserId: getDocData['appointedUserId'],
                    appointedusername: getDocData['appointedUserFullName'],
                    hirerUserId: getDocData['hirerUserId'],
                    hirerUsername: getDocData['hirerUsername'],
                    appliersOrHirersByUserId:
                        getDocData['appliersOrHirersByUserId'],
                    gigRelatedUsersByUserId:
                        getDocData['gigRelatedUsersByUserId'],
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
                    gigCurrency: getDocData['gigCurrency'],
                    gigBudget: getDocData['gigBudget'],
                    gigValue: getDocData['gigValue'],
                    adultContentText: getDocData['adultContentText'],
                    adultContentBool: getDocData['adultContentBool'],
                    hidden: getDocData['hidden'],
                    gigActions: getDocData['gigActions'],
                    paymentReleased: getDocData['paymentReleased'],
                    markedAsComplete: getDocData['markedAsComplete'],
                    clientLeftReview: getDocData['clientLeftReview'],
                    likesCount: getDocData['likesCount'],
                    likersByUserId: getDocData['likersByUserId'],
                  )
                : Container(
                    width: 0,
                    height: 0,
                  );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
