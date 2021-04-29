import 'dart:async';
import 'dart:core';
import 'package:Fyrework/services/database.dart';
import 'package:Fyrework/ui/shared/constants.dart';
import 'package:Fyrework/ui/shared/fyreworkDarkTheme.dart';
import 'package:Fyrework/ui/shared/fyreworkLightTheme.dart';
import 'package:Fyrework/viewmodels/add_comment_view_model.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Fyrework/models/myUser.dart';
import 'package:Fyrework/services/firestore_service.dart';
import 'package:Fyrework/ui/widgets/user_profile.dart';
import 'package:timeago/timeago.dart' as timeAgo;
import 'package:expandable_text/expandable_text.dart';
import 'package:video_player/video_player.dart';

import 'chewie_list_item.dart';
import 'client_worker_rating.dart';

class CommentItem extends StatefulWidget {
  // final passedCurrentUserId;
  final isGigAppointed;
  final gigIdHoldingComment;
  final gigOwnerId;
  final gigOwnerUsername;
  final commentId;
  final commentOwnerId;
  final commentOwnerAvatarUrl;
  final commentOwnerUsername;
  final commentBody;
  final gigCurrency;
  final createdAt;
  final isPrivateComment;
  final proposal;
  final approved;
  final rejected;
  final offeredBudget;
  final preferredPaymentMethod;
  final workstreamFileUrl;
  final containMediaFile;
  final commentPrivacyToggle;
  final isGigCompleted;
  final appointedUserId;
  final appointedUsername;
  final ratingCount;
  CommentItem({
    Key key,
    // this.passedCurrentUserId,
    this.isGigAppointed,
    this.gigIdHoldingComment,
    this.gigOwnerId,
    this.gigOwnerUsername,
    this.commentId,
    this.commentOwnerId,
    this.commentOwnerAvatarUrl,
    this.commentOwnerUsername,
    this.commentBody,
    this.gigCurrency,
    this.createdAt,
    this.isPrivateComment,
    this.proposal,
    this.approved,
    this.rejected,
    this.offeredBudget,
    this.preferredPaymentMethod,
    this.workstreamFileUrl,
    this.containMediaFile,
    this.commentPrivacyToggle,
    this.isGigCompleted,
    this.appointedUserId,
    this.appointedUsername,
    this.ratingCount,
  }) : super(key: key);

  @override
  _CommentItemState createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  final String paypalIcon = 'assets/svgs/flaticon/paypal.svg';
  final String cash = 'assets/svgs/flaticon/cash.svg';
  final String alternatePayment = 'assets/svgs/flaticon/alternate_payment.svg';
  bool myGig;
  bool myComment;
  bool appointedUser;
  bool imageMediaFile;
  bool videoMediaFile;
  Timer _timer;
  int _commentViewIndex = 0;
  double _commentOpacity = 0.9;
  bool isAppointedUser;
  dynamic createdAtDateTime;
  int workerRating = 0;
  bool _userMissedRating = false;
  // bool commentPrivacytoggle = false;

  void initState() {
    super.initState();
  }

  void commentViewShifter() {
    if (!widget.isPrivateComment) {
      print('condition 1');
      setState(() {
        _commentOpacity = 0;
      });
      _timer = new Timer(Duration(milliseconds: 1000), () {
        setState(() {
          _commentOpacity = 0.9;
          _commentViewIndex = 1;
        });
      });
      _timer = new Timer(Duration(milliseconds: 2000), () {
        setState(() {
          _commentOpacity = 0;
        });
      });

      _timer = new Timer(Duration(milliseconds: 3000), () {
        setState(() {
          _commentOpacity = 0.9;
          _commentViewIndex = 0;
        });
      });
    } else {
      print('condition 2');
      setState(() {
        _commentViewIndex = 0;
      });
    }
  }

  showUserProfile({@required String userId}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UserProfileView(
                  // passedUserUid: widget.commentOwnerId,
                  passedUserUid: userId,
                  fromComment: true,
                  fromGig: false,
                )));
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = brightness == Brightness.dark;

    myGig = widget.gigOwnerId == MyUser.uid ? true : false;
    myComment = widget.commentOwnerId == MyUser.uid ? true : false;
    appointedUser = widget.appointedUserId == MyUser.uid ? true : false;
    createdAtDateTime =
        widget.createdAt != null ? widget.createdAt.toDate() : DateTime.now();
    TextEditingController _clientReviewTextController = TextEditingController();

    if (widget.containMediaFile == true) {
      if (widget.commentBody.contains("jpeg") ||
          widget.commentBody.contains("jpg") ||
          widget.commentBody.contains("PNG") ||
          widget.commentBody.contains("WBMP") ||
          widget.commentBody.contains("SVG")) {
        imageMediaFile = true;
        videoMediaFile = false;
      } else if (widget.commentBody.contains("mp4") ||
          widget.commentBody.contains("m4v") ||
          widget.commentBody.contains("mov") ||
          widget.commentBody.contains("avi")) {
        videoMediaFile = true;
        imageMediaFile = false;
      }
    }

    // public comment view
    Widget publicCommentView = Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 200,
                  child: GestureDetector(
                    onTap: () {
                      showUserProfile(userId: widget.commentOwnerId);
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          maxRadius: 20,
                          backgroundColor: Theme.of(context).primaryColor,
                          backgroundImage:
                              NetworkImage("${widget.commentOwnerAvatarUrl}"),
                        ),
                        SizedBox(
                          width: 10,
                          height: 0,
                        ),
                        Flexible(
                          child: Text('${widget.commentOwnerUsername}',
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: myComment
                                          ? Theme.of(context).accentColor
                                          : Theme.of(context).primaryColor)),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                !widget.isGigCompleted
                    ? Container(
                        child: (myGig &&
                                widget.gigOwnerId != widget.commentOwnerId &&
                                widget.proposal &&
                                !widget.approved &&
                                widget.rejected)
                            ? RejectedLabel()
                            : (myGig &&
                                    widget.gigOwnerId !=
                                        widget.commentOwnerId &&
                                    widget.proposal &&
                                    widget.approved &&
                                    !widget.rejected)
                                ? ApprovedLabel()
                                : (myComment &&
                                        !widget.proposal &&
                                        !widget.isGigAppointed)
                                    ? Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 1,
                                            color:
                                                Theme.of(context).accentColor,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50)),
                                        ),
                                        child: CustomSwitch(
                                          activeColor: Colors.black,
                                          value: widget.commentPrivacyToggle,
                                          onChanged: (value) {
                                            FirestoreService()
                                                .commentPrivacyToggle(
                                              widget.commentId,
                                              value,
                                            );
                                            commentViewShifter();
                                          },
                                        ),
                                      )
                                    : Container(
                                        width: 0,
                                        height: 0,
                                      ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.green,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(2))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'GIG COMPLETED',
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      color: Colors.green,
                                    ),
                          ),
                        ),
                      ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(widget.commentBody),
                widget.isGigCompleted
                    ? myGig || myComment
                        ? widget.ratingCount > 0 != true
                            ? SizedBox(
                                height: 200,
                                child: Column(
                                  children: [
                                    SizedBox(width: 10),
                                    Column(
                                      children: [
                                        Container(
                                          child: RichText(
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            text: TextSpan(
                                                style:
                                                    DefaultTextStyle.of(context)
                                                        .style,
                                                children: [
                                                  TextSpan(
                                                    text: 'Rate ',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        .copyWith(
                                                          color: myComment
                                                              ? Theme.of(
                                                                      context)
                                                                  .accentColor
                                                              : Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                        ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        "${widget.appointedUsername}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        .copyWith(
                                                          color: myComment
                                                              ? Theme.of(
                                                                      context)
                                                                  .accentColor
                                                              : Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                    recognizer:
                                                        TapGestureRecognizer()
                                                          ..onTap = () {
                                                            showUserProfile(
                                                              userId: widget
                                                                  .appointedUserId,
                                                            );
                                                          },
                                                  ),
                                                ]),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        ClientWorkerRating((rating) {
                                          setState(() {
                                            workerRating = rating;
                                          });
                                        }),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        style: TextStyle(
                                          color: Theme.of(context).accentColor,
                                        ),
                                        controller: _clientReviewTextController,
                                        decoration: signUpInputDecoration(
                                                context,
                                                "Leave Review...",
                                                !darkModeOn
                                                    ? fyreworkDarkTheme()
                                                        .inputDecorationTheme
                                                        .fillColor
                                                    : fyreworkLightTheme()
                                                        .inputDecorationTheme
                                                        .fillColor)
                                            .copyWith(
                                                contentPadding:
                                                    EdgeInsets.all(10)),
                                        // onFieldSubmitted:
                                        //     (String submittedString) async {
                                        //   if (submittedString.isNotEmpty) {
                                        //     await AddCommentViewModel()
                                        //         .addComment(
                                        //       gigIdHoldingComment:
                                        //           widget.passedGigId,
                                        //       gigOwnerId: widget.passedGigOwnerId,
                                        //       commentOwnerUsername: username,
                                        //       commentBody: submittedString,
                                        //       commentOwnerId: userId,
                                        //       commentOwnerAvatarUrl:
                                        //           userProfilePictureUrl,
                                        //       commentId: '',
                                        //       isPrivateComment: isPrivateComment,
                                        //       isGigCompleted: false,
                                        //       containMediaFile: false,
                                        //       gigOwnerUsername:
                                        //           widget.passGigOwnerUsername,
                                        //       proposal: proposal,
                                        //       approved: approved,
                                        //       rejected: rejected,
                                        //       gigCurrency:
                                        //           widget.passedGigCurrency,
                                        //       offeredBudget: offeredBudget,
                                        //     );
                                        //   }

                                        //   _addCommentsController.clear();
                                        //   _addProposalController.clear();
                                        //   _offeredBudgetController.clear();
                                        // },
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(100),
                                        ],

                                        maxLength: 100,
                                        // minLines: 1,
                                        maxLines: 6,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    GestureDetector(
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).accentColor,
                                            border: Border.all(
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                5,
                                              ),
                                            ),
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'Submit Review',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        onTap: workerRating > 0 != true
                                            ? () {
                                                setState(() {
                                                  _userMissedRating = true;
                                                });
                                              }
                                            : () async {
                                                await DatabaseService()
                                                    .updateCommentRatingCount(
                                                  commentId: widget.commentId,
                                                  ratingCount: workerRating,
                                                );
                                                await DatabaseService()
                                                    .addRatingToUser(
                                                  userId:
                                                      widget.appointedUserId,
                                                  gigId: widget
                                                      .gigIdHoldingComment,
                                                  userRating: workerRating,
                                                );
                                                setState(() {});
                                              }),
                                  ],
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1,
                                            color: Theme.of(context).hintColor),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Wrap(
                                        direction: Axis.horizontal,
                                        alignment: WrapAlignment.start,
                                        children: [
                                          Text(
                                            'You rated ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(
                                                  color: myComment
                                                      ? Theme.of(context)
                                                          .accentColor
                                                      : Theme.of(context)
                                                          .primaryColor,
                                                ),
                                          ),
                                          GestureDetector(
                                            child: Text(
                                              "${widget.appointedUsername}\'s ",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .copyWith(
                                                      color: myComment
                                                          ? Theme.of(context)
                                                              .accentColor
                                                          : Theme.of(context)
                                                              .primaryColor,
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                            onTap: () {
                                              showUserProfile(
                                                  userId:
                                                      widget.appointedUserId);
                                            },
                                          ),
                                          Text(
                                            "work with ${widget.ratingCount} star(s)",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(
                                                  color: myComment
                                                      ? Theme.of(context)
                                                          .accentColor
                                                      : Theme.of(context)
                                                          .primaryColor,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                        : appointedUser
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        'Congrats!!',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        '${widget.gigOwnerUsername} will rate your work',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Container(
                                width: 0,
                                height: 0,
                              )
                    : widget.containMediaFile != true
                        ? Container(
                            child: ExpandableText(
                              '${widget.commentBody}',
                              expandText: ' more',
                              collapseText: ' less',
                              maxLines: 3,
                              linkColor: myComment
                                  ? Theme.of(context).accentColor
                                  : Theme.of(context).primaryColor,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    color: myComment
                                        ? Theme.of(context).accentColor
                                        : Theme.of(context).primaryColor,
                                  ),
                            ),
                          )
                        : imageMediaFile
                            ? Container(
                                width: 300,
                                height: 200,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    widget.commentBody,
                                    fit: BoxFit.cover,
                                  ),
                                ))
                            : Container(
                                width: double.infinity,
                                height: 200,
                                child: ChewieListItem(
                                  videoPlayerController:
                                      VideoPlayerController.network(
                                          widget.commentBody),
                                ),
                              ),
                Container(height: 5),
                (myGig &&
                        !myComment &&
                        widget.proposal &&
                        !widget.approved &&
                        !widget.rejected)
                    ? Column(
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: <Widget>[
                                    Text(
                                      '${widget.gigCurrency}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                            color: myComment
                                                ? Theme.of(context).accentColor
                                                : Theme.of(context)
                                                    .primaryColor,
                                          ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      '${widget.offeredBudget}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                            color: myComment
                                                ? Theme.of(context).accentColor
                                                : Theme.of(context)
                                                    .primaryColor,
                                          ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    widget.preferredPaymentMethod != null
                                        ? SizedBox(
                                            width: 35,
                                            height: 35,
                                            child: SvgPicture.asset(
                                              widget.preferredPaymentMethod ==
                                                      'paypal'
                                                  ? paypalIcon
                                                  : widget.preferredPaymentMethod ==
                                                          'cash'
                                                      ? cash
                                                      : alternatePayment,
                                              semanticsLabel: 'paypal',
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          )
                                        : SizedBox(
                                            width: 0,
                                            height: 0,
                                          ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    GestureDetector(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                width: 1,
                                                color: myComment
                                                    ? Colors.white
                                                    : Theme.of(context)
                                                        .primaryColor,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(2))),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Approve',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .copyWith(
                                                    color: myComment
                                                        ? Theme.of(context)
                                                            .accentColor
                                                        : Theme.of(context)
                                                            .primaryColor,
                                                  ),
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          FirestoreService().appointedGigToUser(
                                            widget.gigIdHoldingComment,
                                            widget.commentOwnerId,
                                            widget.commentId,
                                          );
                                        }),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    GestureDetector(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 1,
                                              color: myComment
                                                  ? Theme.of(context)
                                                      .accentColor
                                                  : Theme.of(context)
                                                      .primaryColor,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(2))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Reject',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(
                                                  color: myComment
                                                      ? Theme.of(context)
                                                          .accentColor
                                                      : Theme.of(context)
                                                          .primaryColor,
                                                ),
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        FirestoreService()
                                            .rejectProposal(widget.commentId);
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    : (myGig &&
                            !myComment &&
                            widget.proposal &&
                            widget.rejected)
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Wrap(
                                  direction: Axis.horizontal,
                                  alignment: WrapAlignment.start,
                                  children: [
                                    Text(
                                      'You rejected ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                              color: myComment
                                                  ? Theme.of(context)
                                                      .accentColor
                                                  : Theme.of(context)
                                                      .primaryColor,
                                              fontWeight: FontWeight.bold),
                                    ),
                                    GestureDetector(
                                      child: Text(
                                        '${widget.commentOwnerUsername}\'s proposal',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                                color: myComment
                                                    ? Theme.of(context)
                                                        .accentColor
                                                    : Theme.of(context)
                                                        .primaryColor,
                                                fontWeight: FontWeight.bold),
                                      ),
                                      onTap: () {
                                        showUserProfile(
                                            userId: widget.commentOwnerId);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 5,
                              ),
                            ],
                          )
                        : (myGig &&
                                !myComment &&
                                widget.proposal &&
                                widget.approved)
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1,
                                                color: Theme.of(context)
                                                    .hintColor),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Wrap(
                                            direction: Axis.horizontal,
                                            alignment: WrapAlignment.start,
                                            children: [
                                              Text(
                                                'Gig awarded to ',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                      color: myComment
                                                          ? Theme.of(context)
                                                              .accentColor
                                                          : Theme.of(context)
                                                              .primaryColor,
                                                    ),
                                              ),
                                              GestureDetector(
                                                child: Text(
                                                  '${widget.commentOwnerUsername}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(
                                                        color: myComment
                                                            ? Theme.of(context)
                                                                .accentColor
                                                            : Theme.of(context)
                                                                .primaryColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                                onTap: () {
                                                  showUserProfile(
                                                      userId: widget
                                                          .commentOwnerId);
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 5,
                                  ),
                                ],
                              )
                            : (myComment && widget.proposal)
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: <Widget>[
                                              widget.gigCurrency != null
                                                  ? Text(
                                                      '${widget.gigCurrency}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1
                                                          .copyWith(
                                                              color: myComment
                                                                  ? Theme.of(
                                                                          context)
                                                                      .accentColor
                                                                  : Theme.of(
                                                                          context)
                                                                      .primaryColor),
                                                    )
                                                  : Container(
                                                      width: 0,
                                                      height: 0,
                                                    ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              widget.offeredBudget != null
                                                  ? Text(
                                                      '${widget.offeredBudget}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1
                                                          .copyWith(
                                                              color: myComment
                                                                  ? Theme.of(
                                                                          context)
                                                                      .accentColor
                                                                  : Theme.of(
                                                                          context)
                                                                      .primaryColor),
                                                    )
                                                  : Container(
                                                      width: 0, height: 0),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              widget.preferredPaymentMethod !=
                                                      null
                                                  ? SizedBox(
                                                      width: 35,
                                                      height: 35,
                                                      child: SvgPicture.asset(
                                                          widget.preferredPaymentMethod ==
                                                                  'paypal'
                                                              ? paypalIcon
                                                              : widget.preferredPaymentMethod ==
                                                                      'cash'
                                                                  ? cash
                                                                  : alternatePayment,
                                                          semanticsLabel:
                                                              'paypal',
                                                          color:
                                                              Theme.of(context)
                                                                  .accentColor),
                                                    )
                                                  : SizedBox(
                                                      width: 0,
                                                      height: 0,
                                                    ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  width: 1,
                                                  color: !widget.approved
                                                      ? !widget.rejected
                                                          ? Theme.of(context)
                                                              .accentColor
                                                          : Colors.red
                                                      : Colors.green,
                                                ),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(2))),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                !widget.approved
                                                    ? !widget.rejected
                                                        ? 'Pending approval'
                                                        : 'Rejected'
                                                    : 'Approved',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                      color: !widget.approved
                                                          ? !widget.rejected
                                                              ? Theme.of(
                                                                      context)
                                                                  .accentColor
                                                              : Colors.red
                                                          : Colors.green,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: 5,
                                      ),
                                    ],
                                  )
                                : Container(
                                    width: 0,
                                    height: 0,
                                  ),
                Text(
                  timeAgo.format(createdAtDateTime),
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: myComment
                            ? Theme.of(context).accentColor
                            : Theme.of(context).primaryColor,
                      ),
                )
              ],
            ),
          ],
        ),
      ),
    );

    // private comment view
    Widget privateCommentView = Container(
      width: double.infinity,
      height: 70,
      child: Center(
        child: Text('Private comment',
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                  color: myComment
                      ? Theme.of(context).accentColor
                      : Theme.of(context).primaryColor,
                )),
      ),
    );

    timeAgo.setLocaleMessages('de', timeAgo.DeMessages());
    timeAgo.setLocaleMessages('dv', timeAgo.DvMessages());
    timeAgo.setLocaleMessages('dv_short', timeAgo.DvShortMessages());
    timeAgo.setLocaleMessages('fr', timeAgo.FrMessages());
    timeAgo.setLocaleMessages('fr_short', timeAgo.FrShortMessages());
    timeAgo.setLocaleMessages('gr', timeAgo.GrMessages());
    timeAgo.setLocaleMessages('gr_short', timeAgo.GrShortMessages());
    timeAgo.setLocaleMessages('ca', timeAgo.CaMessages());
    timeAgo.setLocaleMessages('ca_short', timeAgo.CaShortMessages());
    timeAgo.setLocaleMessages('cs', timeAgo.CsMessages());
    timeAgo.setLocaleMessages('cs_short', timeAgo.CsShortMessages());
    timeAgo.setLocaleMessages('ja', timeAgo.JaMessages());
    timeAgo.setLocaleMessages('km', timeAgo.KmMessages());
    timeAgo.setLocaleMessages('km_short', timeAgo.KmShortMessages());
    timeAgo.setLocaleMessages('ko', timeAgo.KoMessages());
    timeAgo.setLocaleMessages('id', timeAgo.IdMessages());
    timeAgo.setLocaleMessages('pt_BR', timeAgo.PtBrMessages());
    timeAgo.setLocaleMessages('pt_BR_short', timeAgo.PtBrShortMessages());
    timeAgo.setLocaleMessages('zh_CN', timeAgo.ZhCnMessages());
    timeAgo.setLocaleMessages('zh', timeAgo.ZhMessages());
    timeAgo.setLocaleMessages('it', timeAgo.ItMessages());
    timeAgo.setLocaleMessages('it_short', timeAgo.ItShortMessages());
    timeAgo.setLocaleMessages('fa', timeAgo.FaMessages());
    timeAgo.setLocaleMessages('ru', timeAgo.RuMessages());
    timeAgo.setLocaleMessages('tr', timeAgo.TrMessages());
    timeAgo.setLocaleMessages('pl', timeAgo.PlMessages());
    timeAgo.setLocaleMessages('th', timeAgo.ThMessages());
    timeAgo.setLocaleMessages('th_short', timeAgo.ThShortMessages());
    timeAgo.setLocaleMessages('nb_NO', timeAgo.NbNoMessages());
    timeAgo.setLocaleMessages('nb_NO_short', timeAgo.NbNoShortMessages());
    timeAgo.setLocaleMessages('nn_NO', timeAgo.NnNoMessages());
    timeAgo.setLocaleMessages('nn_NO_short', timeAgo.NnNoShortMessages());
    timeAgo.setLocaleMessages('ku', timeAgo.KuMessages());
    timeAgo.setLocaleMessages('ku_short', timeAgo.KuShortMessages());
    timeAgo.setLocaleMessages('ar', timeAgo.ArMessages());
    timeAgo.setLocaleMessages('ar_short', timeAgo.ArShortMessages());
    timeAgo.setLocaleMessages('ko', timeAgo.KoMessages());
    timeAgo.setLocaleMessages('vi', timeAgo.ViMessages());
    timeAgo.setLocaleMessages('vi_short', timeAgo.ViShortMessages());
    timeAgo.setLocaleMessages('tr', timeAgo.TrMessages());
    timeAgo.setLocaleMessages('ta', timeAgo.TaMessages());
    timeAgo.setLocaleMessages('ro', timeAgo.RoMessages());
    timeAgo.setLocaleMessages('ro_short', timeAgo.RoShortMessages());
    timeAgo.setLocaleMessages('sv', timeAgo.SvMessages());
    timeAgo.setLocaleMessages('sv_short', timeAgo.SvShortMessages());

    var locale = 'en';
    return Padding(
      padding: const EdgeInsets.all(0.1),
      child: Container(
        decoration: BoxDecoration(
          color: myComment
              ? Theme.of(context).primaryColor
              : Theme.of(context).accentColor,
          border: Border(
            top: myComment
                ? BorderSide(width: 0.3, color: Theme.of(context).accentColor)
                : BorderSide(
                    width: 0.3,
                    color: Theme.of(context).primaryColor,
                  ),
            bottom: myComment
                ? BorderSide(width: 0.3, color: Theme.of(context).accentColor)
                : BorderSide(
                    width: 0.3,
                    color: Theme.of(context).primaryColor,
                  ),
          ),
        ),
        child: myGig || myComment || appointedUser
            ? IndexedStack(
                index: _commentViewIndex,
                children: [
                  AnimatedOpacity(
                    opacity: _commentOpacity,
                    child: publicCommentView,
                    duration: Duration(milliseconds: 500),
                  ),
                  AnimatedOpacity(
                      opacity: _commentOpacity,
                      child: privateCommentView,
                      duration: Duration(milliseconds: 500)),
                ],
              )
            : widget.commentPrivacyToggle
                ? privateCommentView
                : publicCommentView,
      ),
    );
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
    super.dispose();
  }
}

class ApprovedLabel extends StatelessWidget {
  const ApprovedLabel({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Colors.green,
          ),
          borderRadius: BorderRadius.all(Radius.circular(2))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Approved',
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(color: Colors.green),
        ),
      ),
    );
  }
}

class RejectedLabel extends StatelessWidget {
  const RejectedLabel({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Colors.red,
          ),
          borderRadius: BorderRadius.all(Radius.circular(2))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Rejected',
          style:
              Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.red),
        ),
      ),
    );
  }
}
