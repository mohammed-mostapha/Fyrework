import 'package:Fyrework/models/myUser.dart';
import 'package:Fyrework/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';

class ClientActions extends StatefulWidget {
  @required
  final String passedGigId;

  ClientActions({this.passedGigId});

  @override
  _ClientActionsState createState() => _ClientActionsState();
}

class _ClientActionsState extends State<ClientActions> {
  // bool showReviewTemplate = false;
  final String unsatisfied = 'assets/svgs/flaticon/unsatisfied.svg';

  final String leaveReviewIcon = 'assets/svgs/flaticon/leave_review.svg';

  final String markAsCompletedIcon =
      'assets/svgs/flaticon/mark_as_completed.svg';

  final String releaseEscrowPaymentIcon =
      'assets/svgs/flaticon/release_escrow_payment.svg';

  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;
    // bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait
    //     ? true
    //     : false;

    return StreamBuilder(
      stream:
          DatabaseService().showGigWorkstreamActions(gigId: widget.passedGigId),
      builder: (BuildContext context, AsyncSnapshot gigActionSnapshot) {
        if (!gigActionSnapshot.hasData) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).accentColor,
                ),
              ),
            ),
          );
        } else if (gigActionSnapshot.hasData &&
            !(gigActionSnapshot.data.documents.length > 0)) {
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
                  height: 20,
                ),
                Wrap(
                  // alignment: WrapAlignment.spaceEvenly,
                  spacing: 20,
                  runSpacing: 20,
                  runAlignment: WrapAlignment.center,
                  children: [
                    GestureDetector(
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 30,
                                height: 30,
                                child: SvgPicture.asset(unsatisfied,
                                    semanticsLabel: 'unsatisfied',
                                    color: Theme.of(context).accentColor),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Unsatisfied',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                          color: Theme.of(context).accentColor))
                            ],
                          ),
                        ),
                        onTap: () {
                          DatabaseService().addGigWorkstreamActions(
                            gigId: widget.passedGigId,
                            action: 'unsatisfied',
                            userAvatarUrl: MyUser.userAvatarUrl,
                            gigActionOwner: "client",
                          );
                        }),
                    GestureDetector(
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 30,
                              height: 30,
                              child: SvgPicture.asset(markAsCompletedIcon,
                                  semanticsLabel: 'completed',
                                  color: Theme.of(context).accentColor),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text('Mark As Completed',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                        color: Theme.of(context).accentColor))
                          ],
                        ),
                      ),
                      onTap: () {
                        DatabaseService().addGigWorkstreamActions(
                          gigId: widget.passedGigId,
                          action: 'marked as completed',
                          userAvatarUrl: MyUser.userAvatarUrl,
                          gigActionOwner: "client",
                        );
                      },
                    ),
                    GestureDetector(
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 30,
                                height: 30,
                                child: SvgPicture.asset(
                                  releaseEscrowPaymentIcon,
                                  semanticsLabel: 'release_escrow_payment',
                                  color: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .color
                                      .withOpacity(0.8),
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
                                    .caption
                                    .copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .color
                                            .withOpacity((0.8))),
                              )
                            ],
                          ),
                        ),
                        onTap: null
                        // () {
                        //   DatabaseService().addGigWorkstreamActions(
                        //     gigId: widget.passedGigId,
                        //     action: 'released Payment',
                        //     userAvatarUrl: MyUser.userAvatarUrl,
                        //     gigActionOwner: "client",
                        //   );
                        // },
                        ),
                    GestureDetector(
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 30,
                                height: 30,
                                child: SvgPicture.asset(leaveReviewIcon,
                                    semanticsLabel: 'leave_review',
                                    // color: Theme.of(context).accentColor,
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color
                                        .withOpacity(0.8)),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Leave Review',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .copyWith(
                                          color: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .color
                                              .withOpacity((0.8))))
                            ],
                          ),
                        ),
                        onTap: null
                        // () {
                        //         DatabaseService().addGigWorkstreamActions(
                        //             gigId: widget.passedGigId,
                        //             action: 'left Review',
                        //             userAvatarUrl: MyUser.userAvatarUrl,
                        //             gigActionOwner: 'client');
                        //       }

                        ),
                  ],
                ),
              ],
            ),
          );
        } else {
          String lastGigActionOwner =
              gigActionSnapshot.data.documents.last['gigActionOwner'];
          bool clientAction = (lastGigActionOwner == 'client') ? true : false;
          List gigActionsList = List.from(gigActionSnapshot.data.documents);
          bool markedAsCompleted = gigActionsList.any(
            (element) => element["gigAction"] == "marked as completed",
          );
          print('markedAsCompleted: $markedAsCompleted');

          return Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  height: 20,
                ),
                Wrap(
                  // alignment: WrapAlignment.spaceEvenly,
                  spacing: 20,
                  runSpacing: 20,
                  runAlignment: WrapAlignment.center,
                  children: [
                    GestureDetector(
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 30,
                              height: 30,
                              child: SvgPicture.asset(
                                unsatisfied,
                                semanticsLabel: 'unsatisfied',
                                color: !clientAction
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color
                                        .withOpacity(0.8),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Unsatisfied',
                              textAlign: TextAlign.center,
                              style: !clientAction
                                  ? Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                          color: Theme.of(context).accentColor)
                                  : Theme.of(context)
                                      .textTheme
                                      .caption
                                      .copyWith(
                                          color: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .color
                                              .withOpacity((0.8))),
                            )
                          ],
                        ),
                      ),
                      onTap: !clientAction
                          ? () {
                              DatabaseService().addGigWorkstreamActions(
                                gigId: widget.passedGigId,
                                action: 'unsatisfied',
                                userAvatarUrl: MyUser.userAvatarUrl,
                                gigActionOwner: "client",
                              );
                            }
                          : null,
                    ),
                    GestureDetector(
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 30,
                              height: 30,
                              child: SvgPicture.asset(
                                markAsCompletedIcon,
                                semanticsLabel: 'completed',
                                color: !clientAction
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color
                                        .withOpacity(0.8),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Mark As Completed',
                              textAlign: TextAlign.center,
                              style: !clientAction
                                  ? Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                          color: Theme.of(context).accentColor)
                                  : Theme.of(context)
                                      .textTheme
                                      .caption
                                      .copyWith(
                                          color: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .color
                                              .withOpacity((0.8))),
                            )
                          ],
                        ),
                      ),
                      onTap: !clientAction
                          ? () {
                              DatabaseService().addGigWorkstreamActions(
                                gigId: widget.passedGigId,
                                action: 'marked as completed',
                                userAvatarUrl: MyUser.userAvatarUrl,
                                gigActionOwner: 'client',
                              );
                            }
                          : null,
                    ),
                    GestureDetector(
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 30,
                              height: 30,
                              child: SvgPicture.asset(
                                releaseEscrowPaymentIcon,
                                semanticsLabel: 'release_payment',
                                // color: Theme.of(context).accentColor,
                                color: !markedAsCompleted
                                    ? Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color
                                        .withOpacity(0.8)
                                    : Theme.of(context).accentColor,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Release Payment',
                              textAlign: TextAlign.center,
                              style: !markedAsCompleted
                                  ? Theme.of(context)
                                      .textTheme
                                      .caption
                                      .copyWith(
                                          color: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .color
                                              .withOpacity((0.8)))
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                        color: Theme.of(context).accentColor,
                                      ),
                            )
                          ],
                        ),
                      ),
                      onTap: markedAsCompleted
                          ? () {
                              DatabaseService().addGigWorkstreamActions(
                                gigId: widget.passedGigId,
                                action: 'left Review',
                                userAvatarUrl: MyUser.userAvatarUrl,
                                gigActionOwner: 'client',
                              );
                            }
                          : null,
                    ),
                    GestureDetector(
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 30,
                              height: 30,
                              child: SvgPicture.asset(
                                leaveReviewIcon,
                                semanticsLabel: 'leave_review',
                                // color: Theme.of(context).accentColor,
                                color: !markedAsCompleted
                                    ? Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color
                                        .withOpacity(0.8)
                                    : Theme.of(context).accentColor,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Leave Review',
                              textAlign: TextAlign.center,
                              style: !markedAsCompleted
                                  ? Theme.of(context)
                                      .textTheme
                                      .caption
                                      .copyWith(
                                          color: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .color
                                              .withOpacity((0.8)))
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                        color: Theme.of(context).accentColor,
                                      ),
                            )
                          ],
                        ),
                      ),
                      onTap: markedAsCompleted
                          ? () {
                              DatabaseService().addGigWorkstreamActions(
                                gigId: widget.passedGigId,
                                action: 'left Review',
                                userAvatarUrl: MyUser.userAvatarUrl,
                                gigActionOwner: 'client',
                              );
                            }
                          : null,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    (!clientAction)
                        ? Container(
                            width: 0,
                            height: 0,
                          )
                        : (clientAction && markedAsCompleted)
                            ? Text(
                                'You can leave a review...',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      color: Theme.of(context).accentColor,
                                    ),
                              )
                            : Text(
                                'Waiting for worker action...',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      color: Theme.of(context).accentColor,
                                    ),
                              )
                  ],
                )
              ],
            ),
          );
        }
      },
    );
  }
}
