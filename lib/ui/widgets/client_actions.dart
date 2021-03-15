import 'package:Fyrework/models/myUser.dart';
import 'package:Fyrework/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';

class ClientActions extends StatelessWidget {
  @required
  final String passedGigId;
  final String unsatisfied = 'assets/svgs/flaticon/unsatisfied.svg';
  final String leaveReviewIcon = 'assets/svgs/flaticon/leave_review.svg';
  final String markAsCompletedIcon =
      'assets/svgs/flaticon/mark_as_completed.svg';
  final String releaseEscrowPaymentIcon =
      'assets/svgs/flaticon/release_escrow_payment.svg';

  ClientActions({this.passedGigId});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait
        ? true
        : false;

    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Actions',
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(color: Theme.of(context).accentColor),
              )
            ],
          ),
          SizedBox(
            height: 50,
          ),
          Expanded(
            child: StaggeredGridView.count(
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              // shrinkWrap: true,
              crossAxisCount: 3,
              staggeredTiles: [
                StaggeredTile.count(1, isPortrait ? 1 : 0.5),
                StaggeredTile.count(1, isPortrait ? 1 : 0.5),
                StaggeredTile.count(1, isPortrait ? 1 : 0.5),
                StaggeredTile.count(1, isPortrait ? 1 : 0.5),
              ],
              children: <Widget>[
                Center(
                  child: GestureDetector(
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: SvgPicture.asset(
                              unsatisfied,
                              semanticsLabel: 'check-circle',
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Unsatisfied',
                            textAlign: TextAlign.center,
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      color: Theme.of(context).accentColor,
                                    ),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      DatabaseService().addGigWorkstreamActions(
                        gigId: passedGigId,
                        action: 'unsatisfied',
                        userAvatarUrl: MyUser.userAvatarUrl,
                      );
                    },
                  ),
                ),
                Center(
                  child: GestureDetector(
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: SvgPicture.asset(
                              markAsCompletedIcon,
                              semanticsLabel: 'completed',
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Mark As Completed',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(color: Theme.of(context).accentColor),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      DatabaseService().addGigWorkstreamActions(
                        gigId: passedGigId,
                        action: 'marked As Completed',
                        userAvatarUrl: MyUser.userAvatarUrl,
                      );
                    },
                  ),
                ),
                Center(
                  child: GestureDetector(
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: SvgPicture.asset(
                              releaseEscrowPaymentIcon,
                              semanticsLabel: 'release_escrow_payment',
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Release Payment',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(color: Theme.of(context).accentColor),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      DatabaseService().addGigWorkstreamActions(
                        gigId: passedGigId,
                        action: 'released Payment',
                        userAvatarUrl: MyUser.userAvatarUrl,
                      );
                    },
                  ),
                ),
                Center(
                  child: GestureDetector(
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: SvgPicture.asset(
                              leaveReviewIcon,
                              semanticsLabel: 'leave_review',
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Leave Review',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(color: Theme.of(context).accentColor),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      DatabaseService().addGigWorkstreamActions(
                        gigId: passedGigId,
                        action: 'left Review',
                        userAvatarUrl: MyUser.userAvatarUrl,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
