import 'dart:async';
import 'dart:core';
import 'package:Fyrework/custom_widgets/user_profile.dart';
import 'package:Fyrework/custom_widgets/workstreamFiles_viewer.dart';
import 'package:Fyrework/firebase_database/realtime_database.dart';
import 'package:Fyrework/screens/my_profile.dart';
import 'package:Fyrework/firebase_database/firestore_database.dart';
import 'package:Fyrework/ui/shared/constants.dart';
import 'package:Fyrework/ui/shared/fyreworkDarkTheme.dart';
import 'package:Fyrework/ui/shared/fyreworkLightTheme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Fyrework/models/myUser.dart';
import 'package:timeago/timeago.dart' as timeAgo;
import 'package:expandable_text/expandable_text.dart';
import 'package:video_player/video_player.dart';

import 'chewie_list_item.dart';
import 'client_worker_rating.dart';

class CommentItem extends StatefulWidget {
  final parentGigId;
  final isGigAppointed;
  final gigOwnerId;
  final gigOwnerUsername;
  final commentId;
  final commentOwnerId;
  final commentOwnerAvatarUrl;
  final commentOwnerUsername;
  final commentBody;
  final gigValue;
  final createdAt;
  final isPrivateComment;
  final proposal;
  final approved;
  final rejected;
  final preferredPaymentMethod;
  final workstreamFileUrl;
  final containMediaFile;
  final ratingCount;
  CommentItem({
    Key key,
    @required this.parentGigId,
    @required this.isGigAppointed,
    @required this.gigOwnerId,
    @required this.gigOwnerUsername,
    @required this.commentId,
    @required this.commentOwnerId,
    @required this.commentOwnerAvatarUrl,
    @required this.commentOwnerUsername,
    @required this.commentBody,
    @required this.gigValue,
    @required this.createdAt,
    @required this.isPrivateComment,
    @required this.proposal,
    @required this.approved,
    @required this.rejected,
    @required this.preferredPaymentMethod,
    @required this.workstreamFileUrl,
    @required this.containMediaFile,
    @required this.ratingCount,
  }) : super(key: key);

  @override
  _CommentItemState createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem>
    with TickerProviderStateMixin {
  final _reviewFormKey = GlobalKey<FormState>();
  AnimationController _ratingStarsAnimationController;
  TextEditingController _clientReviewTextController = TextEditingController();
  final String paypalIcon = 'assets/svgs/flaticon/paypal.svg';
  final String cash = 'assets/svgs/flaticon/cash.svg';
  final String alternatePayment = 'assets/svgs/flaticon/alternate_payment.svg';

  bool imageMediaFile;
  bool videoMediaFile;
  Timer _timer;
  int _commentViewIndex = 0;
  double _commentOpacity = 0.9;
  dynamic createdAtDateTime;
  int initialRating = 0;
  bool _userMissedRating = false;
  // bool commentPrivacytoggle = false;

  void initState() {
    super.initState();

    _ratingStarsAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 125),
      value: 1.0,
      lowerBound: 1.0,
      upperBound: 1.5,
    );
  }

  void commentViewShifter() {
    if (!widget.isPrivateComment) {
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
      setState(() {
        _commentViewIndex = 0;
      });
    }
  }

  showUserProfile({@required String userId}) {
    userId != MyUser.uid
        ? Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UserProfileView(
                      passedUserUid: userId,
                    )))
        : Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyProfileView(),
            ),
          );
  }

  alertUserToSelectRating() {
    _ratingStarsAnimationController.forward().then((value) {
      _ratingStarsAnimationController.forward();
      _ratingStarsAnimationController.reverse();
    });
    setState(() {
      _userMissedRating = true;
    });
  }

  addReview({userIdToReceiveRating}) async {
    if (validate()) {
      await FirestoreDatabase().updateCommentRatingCount(
        commentId: widget.commentId,
        ratingCount: initialRating,
      );
      // await FirestoreDatabase().addRatingToUser(
      //   // userId: widget.appointedUserId,
      //   gigId: widget.gigIdHoldingComment,
      //   userRating: initialRating,
      // );
      await FirestoreDatabase().updateLeftReviewFieldToTrue(
        commentId: widget.commentId,
        review: _clientReviewTextController.text,
      );
      setState(() {});
    }
  }

  bool validate() {
    final form = _reviewFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    print('widget.commentOwnerId: ${widget.commentOwnerId}');
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = brightness == Brightness.dark;

    bool myGig = widget.gigOwnerId == MyUser.uid ? true : false;
    bool gigICanDo = widget.gigValue == 'Gig i can do' ? true : false;
    bool myComment = widget.commentOwnerId == MyUser.uid ? true : false;
    // appointedUser = widget.appointedUserId == MyUser.uid ? true : false;
    // createdAtDateTime =
    //     widget.createdAt != null ? widget.createdAt.toDate() : DateTime.now();

    if (widget.containMediaFile == true) {
      String workStreamFileUrl = widget.commentBody.toString().split('/').last;
      if (workStreamFileUrl.contains("jpeg") ||
          workStreamFileUrl.contains("jpg") ||
          workStreamFileUrl.contains("PNG") ||
          workStreamFileUrl.contains("WBMP") ||
          workStreamFileUrl.contains("SVG")) {
        imageMediaFile = true;
        videoMediaFile = false;
      } else if (workStreamFileUrl.contains("mp4") ||
          workStreamFileUrl.contains("m4v") ||
          workStreamFileUrl.contains("mov") ||
          workStreamFileUrl.contains("avi")) {
        videoMediaFile = true;
        imageMediaFile = false;
      }
    }

    // public comment view
    Widget publicCommentView = Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                        Container(
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
                Container(
                  child: (myGig &&
                          widget.gigOwnerId != widget.commentOwnerId &&
                          widget.proposal &&
                          !widget.approved &&
                          !widget.rejected)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            GestureDetector(
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                        color: myComment
                                            ? Colors.white
                                            : Theme.of(context).primaryColor,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(2))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Approve',
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
                                  ),
                                ),
                                onTap: () async {
                                  RealTimeDatabase()
                                      .acceptOrRejectProposalComment(
                                    parentGigId: widget.parentGigId,
                                    commentId: widget.commentId,
                                    approved: true,
                                    rejected: false,
                                  );

                                  gigICanDo
                                      ? await RealTimeDatabase()
                                          .setGigClientAndGigWorker(
                                              parentGigId: widget.parentGigId,
                                              parentGigClientId:
                                                  widget.commentOwnerId,
                                              parentGigWorkerId: MyUser.uid)
                                      : await RealTimeDatabase()
                                          .setGigClientAndGigWorker(
                                              parentGigId: widget.parentGigId,
                                              parentGigClientId: MyUser.uid,
                                              parentGigWorkerId:
                                                  widget.commentOwnerId);
                                }),
                            Container(
                              width: 10,
                            ),
                            GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: myComment
                                          ? Theme.of(context).accentColor
                                          : Theme.of(context).primaryColor,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(2))),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Reject',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                          color: myComment
                                              ? Theme.of(context).accentColor
                                              : Theme.of(context).primaryColor,
                                        ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                RealTimeDatabase()
                                    .acceptOrRejectProposalComment(
                                  parentGigId: widget.parentGigId,
                                  commentId: widget.commentId,
                                  approved: false,
                                  rejected: true,
                                );
                              },
                            ),
                          ],
                        )
                      : (myGig &&
                              widget.gigOwnerId != widget.commentOwnerId &&
                              widget.proposal &&
                              !widget.approved &&
                              widget.rejected)
                          ? RejectedLabel()
                          : (myGig &&
                                  widget.gigOwnerId != widget.commentOwnerId &&
                                  widget.proposal &&
                                  widget.approved &&
                                  !widget.rejected)
                              ? ApprovedLabel()
                              : (myComment && widget.proposal)
                                  ? Container(
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
                                        padding: const EdgeInsets.all(8.0),
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
                                                        ? Theme.of(context)
                                                            .accentColor
                                                        : Colors.red
                                                    : Colors.green,
                                              ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 0,
                                      height: 0,
                                    ),
                ),
                // Container(
                //    decoration: BoxDecoration(
                //      border: Border.all(
                //        width: 1,
                //        color: Colors.green,
                //      ),
                //     borderRadius: BorderRadius.all(
                //       Radius.circular(2),
                //     ),
                //   ),
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Text(
                //       'GIG COMPLETED',
                //       style:
                //           Theme.of(context).textTheme.bodyText1.copyWith(
                //                 color: Colors.green,
                //               ),
                //     ),
                //   ),
                // ),
              ],

              // SizedBox(
              //   height: 5,
              // ),
              //     Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         myGig || myComment
              //             ?
              //             Form(
              //                 key: _reviewFormKey,
              //                 child: SizedBox(
              //                   height: 200,
              //                   child: Column(
              //                     children: [
              //                       SizedBox(width: 10),
              //                       Column(
              //                         children: [
              //                           Container(
              //                             child: RichText(
              //                               textAlign: TextAlign.center,
              //                               overflow: TextOverflow.ellipsis,
              //                               text: TextSpan(
              //                                   style: DefaultTextStyle.of(context)
              //                                       .style,
              //                                   children: [
              //                                     TextSpan(
              //                                       text: 'Rate ',
              //                                       style: Theme.of(context)
              //                                           .textTheme
              //                                           .bodyText1
              //                                           .copyWith(
              //                                             color: myComment
              //                                                 ? Theme.of(context)
              //                                                     .accentColor
              //                                                 : Theme.of(context)
              //                                                     .primaryColor,
              //                                           ),
              //                                     ),
              //                                     TextSpan(
              //                                       text: myGig
              //                                           ? "should be worker name"
              //                                           : widget.gigOwnerUsername,
              //                                       style: Theme.of(context)
              //                                           .textTheme
              //                                           .bodyText1
              //                                           .copyWith(
              //                                             color: myComment
              //                                                 ? Theme.of(context)
              //                                                     .accentColor
              //                                                 : Theme.of(context)
              //                                                     .primaryColor,
              //                                             fontWeight: FontWeight.bold,
              //                                           ),
              //                                       recognizer: TapGestureRecognizer()
              //                                         ..onTap = () {
              //                                           showUserProfile(
              //                                               // userId: widget
              //                                               //     .appointedUserId,
              //                                               );
              //                                         },
              //                                     ),
              //                                   ]),
              //                             ),
              //                           ),
              //                           SizedBox(
              //                             height: 10,
              //                           ),
              //                           ScaleTransition(
              //                             scale: _ratingStarsAnimationController,
              //                             child: ClientWorkerRating(
              //                               onRatingSelected: (rating) {
              //                                 setState(() {
              //                                   initialRating = rating;
              //                                 });
              //                               },
              //                               passedRatingCount:
              //                                   widget.ratingCount == null
              //                                       ? 0
              //                                       : widget.ratingCount,
              //                             ),
              //                           ),
              //                         ],
              //                       ),
              //                       SizedBox(
              //                         height: 20,
              //                       ),
              //                       Expanded(
              //                         child: TextFormField(
              //                           validator: ReviewValidator().validate,
              //                           style: TextStyle(
              //                             color: Theme.of(context).accentColor,
              //                           ),
              //                           controller: _clientReviewTextController,
              //                           decoration: signUpInputDecoration(
              //                                   context,
              //                                   "Leave Review...",
              //                                   !darkModeOn
              //                                       ? fyreworkDarkTheme()
              //                                           .inputDecorationTheme
              //                                           .fillColor
              //                                       : fyreworkLightTheme()
              //                                           .inputDecorationTheme
              //                                           .fillColor)
              //                               .copyWith(
              //                                   contentPadding: EdgeInsets.all(10)),
              //                           inputFormatters: [
              //                             LengthLimitingTextInputFormatter(100),
              //                           ],
              //                           maxLength: 100,
              //                           minLines: 1,
              //                           maxLines: 6,
              //                         ),
              //                       ),
              //                       SizedBox(
              //                         height: 10,
              //                       ),
              //                       GestureDetector(
              //                           child: Container(
              //                             width: double.infinity,
              //                             decoration: BoxDecoration(
              //                               color: Theme.of(context).accentColor,
              //                               border: Border.all(
              //                                 width: 1,
              //                               ),
              //                               borderRadius: BorderRadius.all(
              //                                 Radius.circular(
              //                                   5,
              //                                 ),
              //                               ),
              //                             ),
              //                             child: Center(
              //                               child: Padding(
              //                                 padding: const EdgeInsets.all(8.0),
              //                                 child: Text(
              //                                   'Submit Review',
              //                                   style: Theme.of(context)
              //                                       .textTheme
              //                                       .bodyText1
              //                                       .copyWith(
              //                                         color: Theme.of(context)
              //                                             .primaryColor,
              //                                       ),
              //                                 ),
              //                               ),
              //                             ),
              //                           ),
              //                           onTap: () async {
              //                             initialRating > 0 != true
              //                                 ? alertUserToSelectRating()
              //                                 : addReview(
              //                                     // userIdToReceiveRating: myGig
              //                                     //     ? widget.appointedUserId
              //                                     //     : widget.gigOwnerId,
              //                                     );
              //                           }),
              //                     ],
              //                   ),
              //                 ),
              //               )
              //             :
              //                 Column(
              //                     children: [
              //                       Text(
              //                         'You have been rated with ',
              //                         style: Theme.of(context)
              //                             .textTheme
              //                             .bodyText1
              //                             .copyWith(
              //                               color: Theme.of(context).primaryColor,
              //                             ),
              //                       ),
              //                       SizedBox(
              //                         height: 10,
              //                       ),
              //                       ClientWorkerRating(
              //                         onRatingSelected: (rating) {
              //                           setState(() {
              //                             initialRating = rating;
              //                           });
              //                         },
              //                         passedRatingCount: widget.ratingCount,
              //                       ),

              //                     ],
              //                   )

              //         //     :
              //         //      (appointedUser && !widget.leftReview ||
              //         //             appointedUser && widget.leftReview == null)
              //         //     false
              //         //         ?
              //         //     Row(
              //         //         mainAxisAlignment: MainAxisAlignment.center,
              //         //         children: [
              //         //           Column(
              //         //             children: [
              //         //               Text(
              //         //                 'Congrats!!',
              //         //                 style: Theme.of(context).textTheme.bodyText1,
              //         //               ),
              //         //               SizedBox(
              //         //                 height: 10,
              //         //               ),
              //         //               Text(
              //         //                 '${widget.gigOwnerUsername} will rate your work',
              //         //                 style: Theme.of(context).textTheme.bodyText1,
              //         //               ),
              //         //             ],
              //         //           ),
              //         //         ],
              //         //       )
              //         //             :
              //         //         //  (appointedUser && widget.leftReview == true)
              //         //         false
              //         //             ? Row(
              //         //                 mainAxisAlignment: MainAxisAlignment.center,
              //         //                 children: [
              //         //                   Column(
              //         //                     children: [
              //         //                       Text(
              //         //                         'You have been rated with',
              //         //                         style: Theme.of(context)
              //         //                             .textTheme
              //         //                             .bodyText1,
              //         //                       ),
              //         //                       SizedBox(
              //         //                         height: 10,
              //         //                       ),
              //         //                       ClientWorkerRating(
              //         //                         onRatingSelected: (rating) {
              //         //                           setState(() {
              //         //                             initialRating = rating;
              //         //                           });
              //         //                         },
              //         //                         passedRatingCount:
              //         //                             widget.ratingCount,
              //         //                       ),
              //         //                     ],
              //         //                   ),
              //         //                 ],
              //         //               )
              //         //             : Container(
              //         //                 width: 0,
              //         //                 height: 0,
              //         //               )
              //         // : widget.containMediaFile != true
              //         //     ?
              //             Container(
              //                 child: ExpandableText(
              //                   '${widget.commentBody}',
              //                   expandText: ' more',
              //                   collapseText: ' less',
              //                   maxLines: 3,
              //                   linkColor: myComment
              //                       ? Theme.of(context).accentColor
              //                       : Theme.of(context).primaryColor,
              //                   style: Theme.of(context)
              //                       .textTheme
              //                       .bodyText1
              //                       .copyWith(
              //                         color: myComment
              //                             ? Theme.of(context).accentColor
              //                             : Theme.of(context).primaryColor,
              //                       ),
              //                 ),
              //               )
              //             : imageMediaFile
              //                 ? Container(
              //                     width: 300,
              //                     height: 300,
              //                     padding: EdgeInsets.all(2.5),
              //                     decoration: BoxDecoration(
              //                       borderRadius: BorderRadius.circular(10),
              //                       color: myComment
              //                           ? Theme.of(context).accentColor
              //                           : Theme.of(context).primaryColor,
              //                     ),
              //                     child: !(widget.commentBody.length > 1)
              //                         ? ClipRRect(
              //                             borderRadius: BorderRadius.circular(10),
              //                             child: InkResponse(
              //                               onTap: () {
              //                                 Navigator.of(context).push(
              //                                   MaterialPageRoute(
              //                                       builder: (context) {
              //                                     return WorkstreamFilesViewer(
              //                                       initialPage: 0,
              //                                       workstreamFilesUrls:
              //                                           widget.commentBody,
              //                                     );
              //                                   }),
              //                                 );
              //                               },
              //                               child: CachedNetworkImage(
              //                                 placeholder: (context, url) =>
              //                                     Center(
              //                                   child: CircularProgressIndicator(
              //                                     valueColor:
              //                                         AlwaysStoppedAnimation<
              //                                             Color>(
              //                                       myComment
              //                                           ? Theme.of(context)
              //                                               .accentColor
              //                                           : Theme.of(context)
              //                                               .primaryColor,
              //                                     ),
              //                                     strokeWidth: 2.0,
              //                                   ),
              //                                 ),
              //                                 errorWidget:
              //                                     (context, url, error) =>
              //                                         Icon(Icons.error),
              //                                 imageUrl: widget.commentBody[0],
              //                                 fit: BoxFit.cover,
              //                               ),
              //                             ),
              //                           )
              //                         : GridView.builder(
              //                             primary: true,
              //                             shrinkWrap: true,
              //                             physics: NeverScrollableScrollPhysics(),
              //                             gridDelegate:
              //                                 SliverGridDelegateWithFixedCrossAxisCount(
              //                               crossAxisCount: 2,
              //                               crossAxisSpacing: 2.5,
              //                               mainAxisSpacing: 2.5,
              //                               // childAspectRatio:
              //                               //     MediaQuery.of(context)
              //                               //             .size
              //                               //             .width /
              //                               //         (MediaQuery.of(context)
              //                               //                 .size
              //                               //                 .height /
              //                               //             2),
              //                             ),
              //                             itemCount: widget.commentBody.length,
              //                             itemBuilder: (context, index) =>
              //                                 index == 3
              //                                     ? Container(
              //                                         child: ClipRRect(
              //                                           borderRadius:
              //                                               BorderRadius.circular(
              //                                                   10),
              //                                           child: Container(
              //                                             width: double.infinity,
              //                                             child: InkResponse(
              //                                               onTap: () {
              //                                                 Navigator.of(
              //                                                         context)
              //                                                     .push(
              //                                                   MaterialPageRoute(
              //                                                       builder:
              //                                                           (context) {
              //                                                     return WorkstreamFilesViewer(
              //                                                       initialPage:
              //                                                           index,
              //                                                       workstreamFilesUrls:
              //                                                           widget
              //                                                               .commentBody,
              //                                                     );
              //                                                   }),
              //                                                 );
              //                                               },
              //                                               child: Stack(
              //                                                   children: <
              //                                                       Widget>[
              //                                                     Container(
              //                                                       width: double
              //                                                           .infinity,
              //                                                       child:
              //                                                           ColorFiltered(
              //                                                         colorFilter:
              //                                                             ColorFilter
              //                                                                 .mode(
              //                                                           Colors
              //                                                               .grey,
              //                                                           BlendMode
              //                                                               .saturation,
              //                                                         ),
              //                                                         child:
              //                                                             CachedNetworkImage(
              //                                                           placeholder:
              //                                                               (context, url) =>
              //                                                                   Center(
              //                                                             child:
              //                                                                 CircularProgressIndicator(
              //                                                               valueColor:
              //                                                                   AlwaysStoppedAnimation<Color>(
              //                                                                 myComment
              //                                                                     ? Theme.of(context).accentColor
              //                                                                     : Theme.of(context).primaryColor,
              //                                                               ),
              //                                                               strokeWidth:
              //                                                                   2.0,
              //                                                             ),
              //                                                           ),
              //                                                           errorWidget: (context,
              //                                                                   url,
              //                                                                   error) =>
              //                                                               Icon(Icons
              //                                                                   .error),
              //                                                           imageUrl:
              //                                                               widget
              //                                                                   .commentBody[index],
              //                                                           fit: BoxFit
              //                                                               .cover,
              //                                                         ),
              //                                                       ),
              //                                                     ),
              //                                                     Center(
              //                                                       child: Text(
              //                                                         '+ ${widget.commentBody.length - 4}',
              //                                                         style: TextStyle(
              //                                                             fontSize:
              //                                                                 30),
              //                                                       ),
              //                                                     )
              //                                                   ]),
              //                                             ),
              //                                           ),
              //                                         ),
              //                                       )
              //                                     : Container(
              //                                         child: ClipRRect(
              //                                           borderRadius:
              //                                               BorderRadius.circular(
              //                                                   10),
              //                                           child: InkResponse(
              //                                             onTap: () {
              //                                               Navigator.of(context)
              //                                                   .push(
              //                                                 MaterialPageRoute(
              //                                                     builder:
              //                                                         (context) {
              //                                                   return WorkstreamFilesViewer(
              //                                                     initialPage:
              //                                                         index,
              //                                                     workstreamFilesUrls:
              //                                                         widget
              //                                                             .commentBody,
              //                                                   );
              //                                                 }),
              //                                               );
              //                                             },
              //                                             child:
              //                                                 CachedNetworkImage(
              //                                               placeholder:
              //                                                   (context, url) =>
              //                                                       Center(
              //                                                 child:
              //                                                     CircularProgressIndicator(
              //                                                   valueColor:
              //                                                       AlwaysStoppedAnimation<
              //                                                           Color>(
              //                                                     myComment
              //                                                         ? Theme.of(
              //                                                                 context)
              //                                                             .accentColor
              //                                                         : Theme.of(
              //                                                                 context)
              //                                                             .primaryColor,
              //                                                   ),
              //                                                   strokeWidth: 2.0,
              //                                                 ),
              //                                               ),
              //                                               errorWidget: (context,
              //                                                       url, error) =>
              //                                                   Icon(Icons.error),
              //                                               imageUrl: widget
              //                                                       .commentBody[
              //                                                   index],
              //                                               fit: BoxFit.cover,
              //                                             ),
              //                                           ),
              //                                         ),
              //                                       ),
              //                           ),
              //                   )
              //                 : Container(
              //                     width: double.infinity,
              //                     height: 200,
              //                     child: GridView.builder(
              //                       primary: true,
              //                       shrinkWrap: true,
              //                       physics: NeverScrollableScrollPhysics(),
              //                       gridDelegate:
              //                           SliverGridDelegateWithFixedCrossAxisCount(
              //                         crossAxisCount: 2,
              //                         crossAxisSpacing: 5.0,
              //                         mainAxisSpacing: 5.0,
              //                         childAspectRatio: MediaQuery.of(context)
              //                                 .size
              //                                 .width /
              //                             (MediaQuery.of(context).size.height /
              //                                 3),
              //                       ),
              //                       itemCount: widget.commentBody.length,
              //                       itemBuilder: (context, index) =>
              //                           ChewieListItem(
              //                         videoPlayerController:
              //                             VideoPlayerController.network(
              //                           widget.commentBody[index],
              //                         ),
              //                       ),
              //                     ),
              //                   ),
              //         Container(height: 5),
              //         (myGig &&
              //                 !myComment &&
              //                 widget.proposal &&
              //                 !widget.approved &&
              //                 !widget.rejected)
              //             ? Column(
              //                 children: [
              //                   Container(
              //                     child: Row(
              //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                       children: [
              //                         Row(
              //                           children: <Widget>[
              //                             Text(
              //                               '${widget.gigCurrency}',
              //                               style: Theme.of(context)
              //                                   .textTheme
              //                                   .bodyText1
              //                                   .copyWith(
              //                                     color: myComment
              //                                         ? Theme.of(context).accentColor
              //                                         : Theme.of(context)
              //                                             .primaryColor,
              //                                   ),
              //                             ),
              //                             SizedBox(
              //                               width: 5,
              //                             ),
              //                             Text(
              //                               '${widget.offeredBudget}',
              //                               style: Theme.of(context)
              //                                   .textTheme
              //                                   .bodyText1
              //                                   .copyWith(
              //                                     color: myComment
              //                                         ? Theme.of(context).accentColor
              //                                         : Theme.of(context)
              //                                             .primaryColor,
              //                                   ),
              //                             ),
              //                             SizedBox(
              //                               width: 5,
              //                             ),
              //                             widget.preferredPaymentMethod != null
              //                                 ? SizedBox(
              //                                     width: 35,
              //                                     height: 35,
              //                                     child: SvgPicture.asset(
              //                                       widget.preferredPaymentMethod ==
              //                                               'paypal'
              //                                           ? paypalIcon
              //                                           : widget.preferredPaymentMethod ==
              //                                                   'cash'
              //                                               ? cash
              //                                               : alternatePayment,
              //                                       semanticsLabel: 'paypal',
              //                                       color: Theme.of(context)
              //                                           .primaryColor,
              //                                     ),
              //                                   )
              //                                 : SizedBox(
              //                                     width: 0,
              //                                     height: 0,
              //                                   ),
              //                           ],
              //                         ),
              //
              //             : (myGig &&
              //                     !myComment &&
              //                     widget.proposal &&
              //                     widget.rejected)
              //                 ? Column(
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     children: [
              //                       Container(
              //                         child: Wrap(
              //                           direction: Axis.horizontal,
              //                           alignment: WrapAlignment.start,
              //                           children: [
              //                             Text(
              //                               'You rejected ',
              //                               style: Theme.of(context)
              //                                   .textTheme
              //                                   .bodyText1
              //                                   .copyWith(
              //                                       color: myComment
              //                                           ? Theme.of(context)
              //                                               .accentColor
              //                                           : Theme.of(context)
              //                                               .primaryColor,
              //                                       fontWeight: FontWeight.bold),
              //                             ),
              //                             GestureDetector(
              //                               child: Text(
              //                                 '${widget.commentOwnerUsername}\'s proposal',
              //                                 style: Theme.of(context)
              //                                     .textTheme
              //                                     .bodyText1
              //                                     .copyWith(
              //                                         color: myComment
              //                                             ? Theme.of(context)
              //                                                 .accentColor
              //                                             : Theme.of(context)
              //                                                 .primaryColor,
              //                                         fontWeight: FontWeight.bold),
              //                               ),
              //                               onTap: () {
              //                                 showUserProfile(
              //                                     userId: widget.commentOwnerId);
              //                               },
              //                             ),
              //                           ],
              //                         ),
              //                       ),
              //                       Container(
              //                         height: 5,
              //                       ),
              //                     ],
              //                   )
              //                 : (myGig &&
              //                         !myComment &&
              //                         widget.proposal &&
              //                         widget.approved)
              //                     ? Column(
              //                         crossAxisAlignment: CrossAxisAlignment.start,
              //                         children: [
              //                           Row(
              //                             mainAxisAlignment: MainAxisAlignment.end,
              //                             children: [
              //                               Container(
              //                                 decoration: BoxDecoration(
              //                                     border: Border.all(
              //                                         width: 1,
              //                                         color: Theme.of(context)
              //                                             .hintColor),
              //                                     borderRadius:
              //                                         BorderRadius.circular(5)),
              //                                 child: Padding(
              //                                   padding: const EdgeInsets.all(8.0),
              //                                   child: Wrap(
              //                                     direction: Axis.horizontal,
              //                                     alignment: WrapAlignment.start,
              //                                     children: [
              //                                       Text(
              //                                         'Gig awarded to ',
              //                                         style: Theme.of(context)
              //                                             .textTheme
              //                                             .bodyText1
              //                                             .copyWith(
              //                                               color: myComment
              //                                                   ? Theme.of(context)
              //                                                       .accentColor
              //                                                   : Theme.of(context)
              //                                                       .primaryColor,
              //                                             ),
              //                                       ),
              //                                       GestureDetector(
              //                                         child: Text(
              //                                           '${widget.commentOwnerUsername}',
              //                                           style: Theme.of(context)
              //                                               .textTheme
              //                                               .bodyText1
              //                                               .copyWith(
              //                                                 color: myComment
              //                                                     ? Theme.of(context)
              //                                                         .accentColor
              //                                                     : Theme.of(context)
              //                                                         .primaryColor,
              //                                                 fontWeight:
              //                                                     FontWeight.bold,
              //                                               ),
              //                                         ),
              //                                         onTap: () {
              //                                           showUserProfile(
              //                                               userId: widget
              //                                                   .commentOwnerId);
              //                                         },
              //                                       ),
              //                                     ],
              //                                   ),
              //                                 ),
              //                               ),
              //                             ],
              //                           ),
              //                           Container(
              //                             height: 5,
              //                           ),
              //                         ],
              //                       )
              //                     : (myComment && widget.proposal)
              //                         ? Column(
              //                             crossAxisAlignment: CrossAxisAlignment.end,
              //                             children: [
              //                               Row(
              //                                 mainAxisAlignment:
              //                                     MainAxisAlignment.spaceBetween,
              //                                 children: [
              //                                   Row(
              //                                     children: <Widget>[
              //                                       widget.gigCurrency != null
              //                                           ? Text(
              //                                               '${widget.gigCurrency}',
              //                                               style: Theme.of(context)
              //                                                   .textTheme
              //                                                   .bodyText1
              //                                                   .copyWith(
              //                                                       color: myComment
              //                                                           ? Theme.of(
              //                                                                   context)
              //                                                               .accentColor
              //                                                           : Theme.of(
              //                                                                   context)
              //                                                               .primaryColor),
              //                                             )
              //                                           : Container(
              //                                               width: 0,
              //                                               height: 0,
              //                                             ),
              //                                       SizedBox(
              //                                         width: 5,
              //                                       ),
              //                                       widget.offeredBudget != null
              //                                           ? Text(
              //                                               '${widget.offeredBudget}',
              //                                               style: Theme.of(context)
              //                                                   .textTheme
              //                                                   .bodyText1
              //                                                   .copyWith(
              //                                                       color: myComment
              //                                                           ? Theme.of(
              //                                                                   context)
              //                                                               .accentColor
              //                                                           : Theme.of(
              //                                                                   context)
              //                                                               .primaryColor),
              //                                             )
              //                                           : Container(
              //                                               width: 0, height: 0),
              //                                       SizedBox(
              //                                         width: 5,
              //                                       ),
              //                                       widget.preferredPaymentMethod !=
              //                                               null
              //                                           ? SizedBox(
              //                                               width: 35,
              //                                               height: 35,
              //                                               child: SvgPicture.asset(
              //                                                   widget.preferredPaymentMethod ==
              //                                                           'paypal'
              //                                                       ? paypalIcon
              //                                                       : widget.preferredPaymentMethod ==
              //                                                               'cash'
              //                                                           ? cash
              //                                                           : alternatePayment,
              //                                                   semanticsLabel:
              //                                                       'paypal',
              //                                                   color:
              //                                                       Theme.of(context)
              //                                                           .accentColor),
              //                                             )
              //                                           : SizedBox(
              //                                               width: 0,
              //                                               height: 0,
              //                                             ),
              //                                     ],
              //                                   ),
              //                                   SizedBox(
              //                                     height: 10,
              //                                   ),
              //
              //                                 ],
              //                               ),
              //                             ],
              //                           )
              //                         :

              //     //   ],
              //     // ),
              //   ],
              // ),
            ),
            SizedBox(
              width: 0,
              height: 5,
            ),
            Container(
              child: Text(
                '${widget.commentBody}',
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: myComment
                          ? Theme.of(context).accentColor
                          : Theme.of(context).primaryColor,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: 0,
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  timeAgo.format(
                      DateTime.fromMillisecondsSinceEpoch(widget.createdAt)),
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: myComment
                            ? Theme.of(context).accentColor
                            : Theme.of(context).primaryColor,
                      ),
                ),
                CustomSwitch(
                  activeColor: Colors.black,
                  value: widget.isPrivateComment,
                  onChanged: (value) {
                    print('commentId: ${widget.commentId}');
                    RealTimeDatabase().changeCommentPrivacy(
                      parentGigId: widget.parentGigId,
                      commentId: widget.commentId,
                      isPrivateComment: value,
                    );
                    commentViewShifter();
                  },
                ),
              ],
            )
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
          // child: myGig || myComment || appointedUser
          child: myGig || myComment
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
              // : widget.commentPrivacyToggle
              //     ? privateCommentView
              //     : publicCommentView,
              : Container(
                  child: Text(
                    'Private comment view',
                    style: TextStyle(color: Colors.red),
                  ),
                )),
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
        borderRadius: BorderRadius.all(
          Radius.circular(2),
        ),
      ),
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

class ReviewValidator {
  String validate(String value) {
    if (value.isEmpty) {
      return '';
    } else if (value.length < 2) {
      return '';
    }
    return null;
  }
}
