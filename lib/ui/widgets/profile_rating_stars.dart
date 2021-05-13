import 'package:Fyrework/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileRatingStars extends StatefulWidget {
  final String userId;
  final int maximumRating;
  ProfileRatingStars({@required this.userId, this.maximumRating = 5});

  @override
  _ProfileRatingStarsState createState() => _ProfileRatingStarsState();
}

class _ProfileRatingStarsState extends State<ProfileRatingStars> {
  final String outlineStar = 'assets/svgs/flaticon/outline_star.svg';
  final String solidStar = 'assets/svgs/flaticon/solid_star.svg';
  int _userProfileRatingCount = 0;

  _buildRatingStars(int index) {
    if (index < _userProfileRatingCount) {
      return SizedBox(
        width: 25,
        height: 20,
        child: Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: SvgPicture.asset(
            solidStar,
            semanticsLabel: 'rating_star',
            color: Colors.amber,
          ),
        ),
      );
    }
    return SizedBox(
      width: 25,
      height: 20,
      child: Padding(
        padding: const EdgeInsets.only(right: 5.0),
        child: SvgPicture.asset(
          outlineStar,
          semanticsLabel: 'rating_star',
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildProfileRatingStars() {
    final stars = List.generate(this.widget.maximumRating, (index) {
      return Container(
        child: _buildRatingStars(index),
      );
    });

    return FittedBox(
      fit: BoxFit.contain,
      child: Row(
        children: stars,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DatabaseService().fetchUserRating(userId: widget.userId),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> userRatingSnapshot) {
          switch (userRatingSnapshot.connectionState) {
            case ConnectionState.none:
              return Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
              );
            case ConnectionState.waiting:
            case ConnectionState.active:
              return _buildProfileRatingStars();
            case ConnectionState.done:
              if (userRatingSnapshot.hasError) {
                return _buildProfileRatingStars();
              } else if (userRatingSnapshot.hasData) {
                if (userRatingSnapshot.data != null) {
                  if (!(userRatingSnapshot.data.docs.length > 0)) {
                    return _buildProfileRatingStars();
                  }
                  List userRatingDocumentSnapshotsList = [];
                  List<QueryDocumentSnapshot> userRatingDocumentSnapshots =
                      userRatingSnapshot.data.docs;

                  userRatingDocumentSnapshots.forEach((element) {
                    if (element.data().containsKey('userRating')) {
                      userRatingDocumentSnapshotsList
                          .add(element.data()['userRating']);
                    }
                  });

                  int userRatingSum = userRatingDocumentSnapshotsList.reduce(
                    (a, b) => a + b,
                  );

                  int estimatedUserRating =
                      (userRatingSum ~/ userRatingDocumentSnapshotsList.length);
                  // .toInt();

                  _userProfileRatingCount = estimatedUserRating;
                } else {
                  return _buildProfileRatingStars();
                }
              }
              return _buildProfileRatingStars();
          }
          return _buildProfileRatingStars();
        });
    // return _buildProfileRatingStars();
  }
}
