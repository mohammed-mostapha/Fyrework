import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myApp/models/myUser.dart';
import 'package:myApp/services/database.dart';
import 'package:myApp/ui/widgets/gig_item.dart';

class IndividualGigItem extends StatelessWidget {
  final String gigId;

  IndividualGigItem({@required this.gigId});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: DatabaseService().listenToAnIndividualGig(gigId),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              child: Center(
                  child: Text(
                'Loading gig...',
                style: Theme.of(context).textTheme.bodyText1,
              )),
            );
          }
          return !snapshot.hasData
              ? Container(
                  child: Center(
                      child: Text(
                    'Loading gig...',
                    style: Theme.of(context).textTheme.bodyText1,
                  )),
                )
              : snapshot.data.data != null
                  ? GigItem(
                      appointed: snapshot.data['appointed'],
                      appointedUserFullName:
                          snapshot.data['appointedUserFullName'],
                      gigId: snapshot.data['gigId'],
                      currentUserId: MyUser.uid,
                      gigOwnerId: snapshot.data['gigOwnerId'],
                      gigOwnerAvatarUrl: snapshot.data['gigOwnerAvatarUrl'],
                      gigOwnerUsername: snapshot.data['gigOwnerUsername'],
                      gigTime: snapshot.data['gigTime'],
                      gigOwnerLocation: snapshot.data['gigOwnerLocation'],
                      gigLocation: snapshot.data['gigLocation'],
                      gigHashtags: snapshot.data['gigHashtags'],
                      gigMediaFilesDownloadUrls:
                          snapshot.data['gigMediaFilesDownloadUrls'],
                      gigPost: snapshot.data['gigPost'],
                      gigDeadline: snapshot.data['gigDeadline'],
                      gigCurrency: snapshot.data['gigCurrency'],
                      gigBudget: snapshot.data['gigBudget'],
                      gigValue: snapshot.data['gigValue'],
                      gigLikes: snapshot.data['gigLikes'],
                      adultContentText: snapshot.data['adultContentText'],
                      adultContentBool: snapshot.data['adultContentBool'],
                      appointedUserId: snapshot.data['appointedUserId'],
                      // onDeleteItem: () => model.deleteGig(index),
                    )
                  : Container(
                      child: Center(
                          child: Text(
                        'Gig no longer exists',
                        style: Theme.of(context).textTheme.bodyText1,
                      )),
                    );
        },
      ),
    );
  }
}
