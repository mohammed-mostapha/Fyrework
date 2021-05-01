import 'package:Fyrework/models/myUser.dart';
import 'package:Fyrework/services/database.dart';
import 'package:Fyrework/ui/shared/fyreworkDarkTheme.dart';
import 'package:Fyrework/ui/shared/fyreworkLightTheme.dart';
import 'package:Fyrework/viewmodels/add_comment_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ClientActions extends StatefulWidget {
  @required
  final String passedGigId;
  @required
  final String passedGigOwnerId;
  @required
  final String pasedGigOwnerUsername;

  ClientActions({
    this.passedGigId,
    this.passedGigOwnerId,
    this.pasedGigOwnerUsername,
  });

  @override
  _ClientActionsState createState() => _ClientActionsState();
}

class _ClientActionsState extends State<ClientActions> {
  String userId = MyUser.uid;
  String username = MyUser.username;
  dynamic userProfilePictureUrl = MyUser.userAvatarUrl;
  String appointedUserId;
  String appointedUsername;

  // bool showReviewTemplate = false;
  final String unsatisfied = 'assets/svgs/flaticon/unsatisfied.svg';
  final String markAsCompletedIcon =
      'assets/svgs/flaticon/mark_as_completed.svg';

  final String releaseEscrowPaymentIcon =
      'assets/svgs/flaticon/release_escrow_payment.svg';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
        future:
            DatabaseService().fetchAppointedUserData(gigId: widget.passedGigId),
        builder: (BuildContext context, AsyncSnapshot appointedUserSnapshot) {
          switch (appointedUserSnapshot.connectionState) {
            case ConnectionState.none:
              return Container(
                  child: Center(
                      child: Text(
                'Actions not available right now',
                style: fyreworkLightTheme().textTheme.bodyText1,
              )));
            case ConnectionState.waiting:
            case ConnectionState.active:
              return Container(
                  child: Center(
                      child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    fyreworkLightTheme().primaryColor),
              )));
            case ConnectionState.done:
              if (appointedUserSnapshot.hasError) {
                return Container(
                    child: Center(
                        child: Text(
                  'Actions not available right now',
                  style: fyreworkLightTheme().textTheme.bodyText1,
                )));
              } else if (appointedUserSnapshot.hasData) {
                appointedUserId = appointedUserSnapshot.data['appointedUserId'];
                appointedUsername =
                    appointedUserSnapshot.data['appointedUsername'];

                return StreamBuilder(
                  stream: DatabaseService()
                      .showGigWorkstreamActions(gigId: widget.passedGigId),
                  builder:
                      (BuildContext context, AsyncSnapshot gigActionsSnapshot) {
                    if (!gigActionsSnapshot.hasData) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              fyreworkLightTheme().accentColor,
                            ),
                          ),
                        ),
                      );
                    } else if (gigActionsSnapshot.hasData &&
                        !(gigActionsSnapshot.data.docs.length > 0)) {
                      return Container(
                        width: double.infinity,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Actions',
                                  style:
                                      fyreworkLightTheme().textTheme.headline1,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 30,
                                            height: 30,
                                            child: SvgPicture.asset(unsatisfied,
                                                semanticsLabel: 'unsatisfied',
                                                color: fyreworkLightTheme()
                                                    .primaryColor),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'Unsatisfied',
                                            textAlign: TextAlign.center,
                                            style: fyreworkLightTheme()
                                                .textTheme
                                                .bodyText1,
                                          )
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 30,
                                          height: 30,
                                          child: SvgPicture.asset(
                                            markAsCompletedIcon,
                                            semanticsLabel: 'completed',
                                            color: fyreworkLightTheme()
                                                .primaryColor,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'Mark As Completed',
                                          textAlign: TextAlign.center,
                                          style: fyreworkLightTheme()
                                              .textTheme
                                              .bodyText1,
                                        )
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    DatabaseService()
                                        .addGigWorkstreamActions(
                                      gigId: widget.passedGigId,
                                      action: 'marked as completed',
                                      userAvatarUrl: MyUser.userAvatarUrl,
                                      gigActionOwner: "client",
                                    )
                                        .then((value) async {
                                      await AddCommentViewModel().addComment(
                                        gigIdHoldingComment: widget.passedGigId,
                                        gigOwnerId: widget.passedGigOwnerId,
                                        gigOwnerUsername:
                                            widget.pasedGigOwnerUsername,
                                        commentOwnerUsername: username,
                                        commentBody: 'wating client review',
                                        commentOwnerId: userId,
                                        commentOwnerAvatarUrl:
                                            userProfilePictureUrl,
                                        commentId: '',
                                        isPrivateComment: true,
                                        proposal: false,
                                        approved: true,
                                        rejected: false,
                                        containMediaFile: false,
                                        isGigCompleted: true,
                                        appointedUserId: appointedUserId,
                                        appointedUsername: appointedUsername,
                                        ratingCount: 0,
                                        leftReview: false,
                                      );
                                    });
                                  },
                                ),
                                GestureDetector(
                                    child: FittedBox(
                                      fit: BoxFit.fill,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 30,
                                            height: 30,
                                            child: SvgPicture.asset(
                                                releaseEscrowPaymentIcon,
                                                semanticsLabel:
                                                    'release_escrow_payment',
                                                color: fyreworkLightTheme()
                                                    .primaryColor),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'Release Payment',
                                            textAlign: TextAlign.center,
                                            style: fyreworkLightTheme()
                                                .textTheme
                                                .bodyText1,
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
                              ],
                            ),
                          ],
                        ),
                      );
                    } else {
                      String lastGigActionOwner =
                          gigActionsSnapshot.data.docs.last['gigActionOwner'];
                      bool clientAction =
                          (lastGigActionOwner == 'client') ? true : false;
                      List gigActionsList =
                          List.from(gigActionsSnapshot.data.docs);
                      bool worksteamActionsEmpty =
                          !(gigActionsList.length > 0) ? true : false;
                      bool markedAsCompleted = gigActionsList.any(
                        (element) =>
                            element["gigAction"] == "marked as completed",
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
                                  style:
                                      fyreworkLightTheme().textTheme.headline1,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 30,
                                          height: 30,
                                          child: SvgPicture.asset(
                                            unsatisfied,
                                            semanticsLabel: 'unsatisfied',
                                            color: !clientAction
                                                ? fyreworkLightTheme()
                                                    .primaryColor
                                                : fyreworkLightTheme()
                                                    .primaryColor
                                                    .withOpacity(0.5),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'Unsatisfied',
                                          textAlign: TextAlign.center,
                                          style: !clientAction
                                              ? fyreworkLightTheme()
                                                  .textTheme
                                                  .bodyText1
                                              : fyreworkLightTheme()
                                                  .textTheme
                                                  .bodyText1
                                                  .copyWith(
                                                      color:
                                                          fyreworkLightTheme()
                                                              .primaryColor
                                                              .withOpacity(
                                                                  (0.5))),
                                        )
                                      ],
                                    ),
                                  ),
                                  onTap: !clientAction
                                      ? () {
                                          DatabaseService()
                                              .addGigWorkstreamActions(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 30,
                                          height: 30,
                                          child: SvgPicture.asset(
                                            markAsCompletedIcon,
                                            semanticsLabel: 'completed',
                                            color: !clientAction
                                                ? fyreworkLightTheme()
                                                    .primaryColor
                                                : fyreworkLightTheme()
                                                    .primaryColor
                                                    .withOpacity(0.5),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'Mark as Completed',
                                          textAlign: TextAlign.center,
                                          style: !clientAction
                                              ? fyreworkLightTheme()
                                                  .textTheme
                                                  .bodyText1
                                              : fyreworkLightTheme()
                                                  .textTheme
                                                  .bodyText1
                                                  .copyWith(
                                                      color:
                                                          fyreworkLightTheme()
                                                              .primaryColor
                                                              .withOpacity(
                                                                  (0.5))),
                                        )
                                      ],
                                    ),
                                  ),
                                  onTap: !clientAction || worksteamActionsEmpty
                                      ? () {
                                          DatabaseService()
                                              .addGigWorkstreamActions(
                                            gigId: widget.passedGigId,
                                            action: 'marked as completed',
                                            userAvatarUrl: MyUser.userAvatarUrl,
                                            gigActionOwner: 'client',
                                          );
                                          //     .then((value) {
                                          //   print('should add template');
                                          //   addGigCompletedCommentTemplate(
                                          //     containMediaFile: false,
                                          //     commentBody: 'Gig Completed',
                                          //   );
                                          // });
                                        }
                                      // look at this

                                      : null,
                                ),
                                GestureDetector(
                                  child: FittedBox(
                                    fit: BoxFit.fill,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 30,
                                          height: 30,
                                          child: SvgPicture.asset(
                                            releaseEscrowPaymentIcon,
                                            semanticsLabel: 'release_payment',
                                            color: fyreworkLightTheme()
                                                .primaryColor,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text('Release Payment',
                                            textAlign: TextAlign.center,
                                            style: fyreworkLightTheme()
                                                .textTheme
                                                .bodyText1)
                                      ],
                                    ),
                                  ),
                                  onTap: markedAsCompleted
                                      ? () {
                                          DatabaseService()
                                              .addGigWorkstreamActions(
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
                                        ? Text('You can leave a review...',
                                            style: fyreworkLightTheme()
                                                .textTheme
                                                .bodyText1)
                                        : Text('Waiting for worker action...',
                                            style: fyreworkLightTheme()
                                                .textTheme
                                                .bodyText1)
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
          return Container(
              child: Center(
                  child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
                fyreworkLightTheme().primaryColor),
          )));
        },
      ),
    );
  }
}
