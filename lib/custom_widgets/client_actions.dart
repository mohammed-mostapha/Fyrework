// import 'package:Fyrework/models/comment.dart';
// import 'package:Fyrework/models/myUser.dart';
// import 'package:Fyrework/firebase_database/firestore_database.dart';
// import 'package:Fyrework/ui/shared/fyreworkLightTheme.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

// class ClientActions extends StatefulWidget {
//   final String passedGigId;
//   final String passedGigOwnerId;
//   final String passedGigOwnerUsername;
//   String passedGigClientId;
//   String passedGigWorkerId;
//   String passedGigValue;

//   ClientActions({
//     @required this.passedGigId,
//     @required this.passedGigOwnerId,
//     @required this.passedGigOwnerUsername,
//     @required this.passedGigClientId,
//     @required this.passedGigWorkerId,
//     @required this.passedGigValue,
//   });

//   @override
//   _ClientActionsState createState() => _ClientActionsState();
// }

// class _ClientActionsState extends State<ClientActions> {
//   DatabaseReference _parentGigObjId;
//   String userId = MyUser.uid;
//   String username = MyUser.username;
//   dynamic userProfilePictureUrl = MyUser.userAvatarUrl;

//   // bool showReviewTemplate = false;
//   final String unsatisfied = 'assets/svgs/flaticon/unsatisfied.svg';
//   final String markAsCompletedIcon =
//       'assets/svgs/flaticon/mark_as_completed.svg';

//   final String releaseEscrowPaymentIcon =
//       'assets/svgs/flaticon/release_escrow_payment.svg';

//   void initState() {
//     super.initState();
//     _parentGigObjId = FirebaseDatabase.instance
//         .reference()
//         .child('gigs')
//         .child(widget.passedGigId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: FutureBuilder(
//         future: FirestoreDatabase()
//             .fetchAppointedUserData(gigId: widget.passedGigId),
//         builder: (BuildContext context, AsyncSnapshot appointedUserSnapshot) {
//           switch (appointedUserSnapshot.connectionState) {
//             case ConnectionState.none:
//               return Container(
//                   child: Center(
//                       child: Text(
//                 'Actions not available right now',
//                 style: fyreworkLightTheme().textTheme.bodyText1,
//               )));
//             case ConnectionState.waiting:
//             case ConnectionState.active:
//               return Container(
//                   child: Center(
//                       child: CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(
//                     fyreworkLightTheme().primaryColor),
//               )));
//             case ConnectionState.done:
//               if (appointedUserSnapshot.hasError) {
//                 return Container(
//                     child: Center(
//                         child: Text(
//                   'Actions not available right now',
//                   style: fyreworkLightTheme().textTheme.bodyText1,
//                 )));
//               } else if (appointedUserSnapshot.hasData) {
//                 if (appointedUserSnapshot.data != null) {
//                   return StreamBuilder<Event>(
//                     // stream: FirestoreDatabase()
//                     //     .showGigWorkstreamActions(gigId: widget.passedGigId),
//                     stream: _parentGigObjId.onValue,
//                     builder: (BuildContext context,
//                         AsyncSnapshot gigActionsSnapshot) {
//                       if (!gigActionsSnapshot.hasData) {
//                         return Container(
//                           width: MediaQuery.of(context).size.width,
//                           height: MediaQuery.of(context).size.height,
//                           child: Center(
//                             child: CircularProgressIndicator(
//                               valueColor: AlwaysStoppedAnimation<Color>(
//                                 fyreworkLightTheme().accentColor,
//                               ),
//                             ),
//                           ),
//                         );
//                       } else if (gigActionsSnapshot.hasData &&
//                           !(gigActionsSnapshot.data.docs.length > 0)) {
//                         return Container(
//                           width: double.infinity,
//                           child: Column(
//                             children: [
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     'Actions',
//                                     style: fyreworkLightTheme()
//                                         .textTheme
//                                         .headline1,
//                                   )
//                                 ],
//                               ),
//                               SizedBox(
//                                 height: 20,
//                               ),
//                               Wrap(
//                                 // alignment: WrapAlignment.spaceEvenly,
//                                 spacing: 20,
//                                 runSpacing: 20,
//                                 runAlignment: WrapAlignment.center,
//                                 children: [
//                                   GestureDetector(
//                                       child: FittedBox(
//                                         fit: BoxFit.fill,
//                                         child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             SizedBox(
//                                               width: 30,
//                                               height: 30,
//                                               child: SvgPicture.asset(
//                                                   unsatisfied,
//                                                   semanticsLabel: 'unsatisfied',
//                                                   color: fyreworkLightTheme()
//                                                       .primaryColor),
//                                             ),
//                                             SizedBox(
//                                               height: 10,
//                                             ),
//                                             Text(
//                                               'Unsatisfied',
//                                               textAlign: TextAlign.center,
//                                               style: fyreworkLightTheme()
//                                                   .textTheme
//                                                   .bodyText1,
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                       onTap: () async {
//                                         await FirestoreDatabase().addComment(
//                                           Comment(
//                                             gigIdHoldingComment:
//                                                 widget.passedGigId,
//                                             gigOwnerId: widget.passedGigOwnerId,
//                                             gigOwnerUsername:
//                                                 widget.passedGigOwnerUsername,
//                                             gigClientId:
//                                                 widget.passedGigClientId,
//                                             gigworkerId:
//                                                 widget.passedGigWorkerId,
//                                             commentOwnerUsername: username,
//                                             commentBody:
//                                                 '${MyUser.username} is unsatisfied with the work provided',
//                                             commentOwnerId: userId,
//                                             commentOwnerAvatarUrl:
//                                                 userProfilePictureUrl,
//                                             commentId: '',
//                                             createdAt: DateTime.now(),
//                                             isPrivateComment: true,
//                                             proposal: false,
//                                             approved: true,
//                                             rejected: false,
//                                             containMediaFile: false,
//                                             isGigCompleted: false,
//                                             ratingCount: 0,
//                                             leftReview: false,
//                                           ),
//                                           widget.passedGigId,
//                                         );
//                                         FirestoreDatabase()
//                                             .addGigWorkstreamActions(
//                                           gigId: widget.passedGigId,
//                                           action: 'unsatisfied',
//                                           userAvatarUrl: MyUser.userAvatarUrl,
//                                           gigActionOwner: "client",
//                                         );
//                                       }),
//                                   GestureDetector(
//                                     child: FittedBox(
//                                       fit: BoxFit.fill,
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           SizedBox(
//                                             width: 30,
//                                             height: 30,
//                                             child: SvgPicture.asset(
//                                               markAsCompletedIcon,
//                                               semanticsLabel: 'completed',
//                                               color: fyreworkLightTheme()
//                                                   .primaryColor,
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             height: 10,
//                                           ),
//                                           Text(
//                                             'Mark As Completed',
//                                             textAlign: TextAlign.center,
//                                             style: fyreworkLightTheme()
//                                                 .textTheme
//                                                 .bodyText1,
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                     onTap: () async {
//                                       await FirestoreDatabase().addComment(
//                                         Comment(
//                                           gigIdHoldingComment:
//                                               widget.passedGigId,
//                                           gigOwnerId: widget.passedGigOwnerId,
//                                           gigOwnerUsername:
//                                               widget.passedGigOwnerUsername,
//                                           commentOwnerUsername: username,
//                                           commentBody:
//                                               'Your review will appear here...',
//                                           commentOwnerId: userId,
//                                           commentOwnerAvatarUrl:
//                                               userProfilePictureUrl,
//                                           commentId: '',
//                                           isPrivateComment: true,
//                                           proposal: false,
//                                           approved: true,
//                                           rejected: false,
//                                           containMediaFile: false,
//                                           isGigCompleted: true,
//                                           ratingCount: 0,
//                                           leftReview: false,
//                                           createdAt: DateTime.now(),
//                                         ),
//                                         widget.passedGigId,
//                                       );

//                                       await FirestoreDatabase()
//                                           .addGigWorkstreamActions(
//                                         gigId: widget.passedGigId,
//                                         action: 'marked as completed',
//                                         userAvatarUrl: MyUser.userAvatarUrl,
//                                         gigActionOwner: "client",
//                                       );

//                                       await FirestoreDatabase()
//                                           .convertOpenGigToCompletedGig(
//                                         gigId: widget.passedGigId,
//                                         gigOwnerId: widget.passedGigOwnerId,
//                                         // appointedUserId: appointedUserId,
//                                       );
//                                     },
//                                   ),
//                                   GestureDetector(
//                                       child: FittedBox(
//                                         fit: BoxFit.fill,
//                                         child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             SizedBox(
//                                               width: 30,
//                                               height: 30,
//                                               child: SvgPicture.asset(
//                                                   releaseEscrowPaymentIcon,
//                                                   semanticsLabel:
//                                                       'release_escrow_payment',
//                                                   color: fyreworkLightTheme()
//                                                       .primaryColor),
//                                             ),
//                                             SizedBox(
//                                               height: 10,
//                                             ),
//                                             Text(
//                                               'Release Payment',
//                                               textAlign: TextAlign.center,
//                                               style: fyreworkLightTheme()
//                                                   .textTheme
//                                                   .bodyText1,
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                       onTap: null
//                                       // () {
//                                       //   DatabaseService().addGigWorkstreamActions(
//                                       //     gigId: widget.passedGigId,
//                                       //     action: 'released Payment',
//                                       //     userAvatarUrl: MyUser.userAvatarUrl,
//                                       //     gigActionOwner: "client",
//                                       //   );
//                                       // },
//                                       ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         );
//                       } else {
//                         String lastGigActionOwner =
//                             gigActionsSnapshot.data.docs.last['gigActionOwner'];
//                         bool clientAction =
//                             (lastGigActionOwner == 'client') ? true : false;
//                         List gigActionsList =
//                             List.from(gigActionsSnapshot.data.docs);
//                         bool worksteamActionsEmpty =
//                             !(gigActionsList.length > 0) ? true : false;
//                         bool markedAsCompleted = gigActionsList.any(
//                           (element) =>
//                               element["gigAction"] == "marked as completed",
//                         );
//                         print('markedAsCompleted: $markedAsCompleted');

//                         return Container(
//                           width: double.infinity,
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     'Actions',
//                                     style: fyreworkLightTheme()
//                                         .textTheme
//                                         .headline1,
//                                   )
//                                 ],
//                               ),
//                               SizedBox(
//                                 height: 20,
//                               ),
//                               Wrap(
//                                 // alignment: WrapAlignment.spaceEvenly,
//                                 spacing: 20,
//                                 runSpacing: 20,
//                                 runAlignment: WrapAlignment.center,
//                                 children: [
//                                   GestureDetector(
//                                     child: FittedBox(
//                                       fit: BoxFit.fill,
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           SizedBox(
//                                             width: 30,
//                                             height: 30,
//                                             child: SvgPicture.asset(
//                                               unsatisfied,
//                                               semanticsLabel: 'unsatisfied',
//                                               color: !clientAction
//                                                   ? fyreworkLightTheme()
//                                                       .primaryColor
//                                                   : fyreworkLightTheme()
//                                                       .primaryColor
//                                                       .withOpacity(0.3),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             height: 10,
//                                           ),
//                                           Text(
//                                             'Unsatisfied',
//                                             textAlign: TextAlign.center,
//                                             style: !clientAction
//                                                 ? fyreworkLightTheme()
//                                                     .textTheme
//                                                     .bodyText1
//                                                 : fyreworkLightTheme()
//                                                     .textTheme
//                                                     .bodyText1
//                                                     .copyWith(
//                                                         color:
//                                                             fyreworkLightTheme()
//                                                                 .primaryColor
//                                                                 .withOpacity(
//                                                                     (0.5))),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                     onTap: !clientAction
//                                         ? () async {
//                                             await FirestoreDatabase()
//                                                 .addComment(
//                                               Comment(
//                                                 gigIdHoldingComment:
//                                                     widget.passedGigId,
//                                                 gigOwnerId:
//                                                     widget.passedGigOwnerId,
//                                                 gigOwnerUsername: widget
//                                                     .passedGigOwnerUsername,
//                                                 commentOwnerUsername: username,
//                                                 commentBody:
//                                                     '$username is unsatisfied with the provided work',
//                                                 commentOwnerId: userId,
//                                                 commentOwnerAvatarUrl:
//                                                     userProfilePictureUrl,
//                                                 commentId: '',
//                                                 createdAt: DateTime.now(),
//                                                 isPrivateComment: true,
//                                                 proposal: false,
//                                                 approved: true,
//                                                 rejected: false,
//                                                 containMediaFile: false,
//                                                 isGigCompleted: false,
//                                                 ratingCount: 0,
//                                                 leftReview: false,
//                                               ),
//                                               widget.passedGigId,
//                                             );
//                                             FirestoreDatabase()
//                                                 .addGigWorkstreamActions(
//                                               gigId: widget.passedGigId,
//                                               action: 'unsatisfied',
//                                               userAvatarUrl:
//                                                   MyUser.userAvatarUrl,
//                                               gigActionOwner: "client",
//                                             );
//                                           }
//                                         : null,
//                                   ),
//                                   GestureDetector(
//                                     child: FittedBox(
//                                       fit: BoxFit.fill,
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           SizedBox(
//                                             width: 30,
//                                             height: 30,
//                                             child: SvgPicture.asset(
//                                               markAsCompletedIcon,
//                                               semanticsLabel: 'completed',
//                                               color: !clientAction
//                                                   ? fyreworkLightTheme()
//                                                       .primaryColor
//                                                   : fyreworkLightTheme()
//                                                       .primaryColor
//                                                       .withOpacity(0.8),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             height: 10,
//                                           ),
//                                           Text(
//                                             'Mark as Completed',
//                                             textAlign: TextAlign.center,
//                                             style: !clientAction
//                                                 ? fyreworkLightTheme()
//                                                     .textTheme
//                                                     .bodyText1
//                                                 : fyreworkLightTheme()
//                                                     .textTheme
//                                                     .bodyText1
//                                                     .copyWith(
//                                                         color:
//                                                             fyreworkLightTheme()
//                                                                 .primaryColor
//                                                                 .withOpacity(
//                                                                     (0.5))),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                     onTap: !clientAction ||
//                                             worksteamActionsEmpty
//                                         ? () async {
//                                             await FirestoreDatabase()
//                                                 .addComment(
//                                               Comment(
//                                                 gigIdHoldingComment:
//                                                     widget.passedGigId,
//                                                 gigOwnerId:
//                                                     widget.passedGigOwnerId,
//                                                 gigOwnerUsername: widget
//                                                     .passedGigOwnerUsername,
//                                                 commentOwnerUsername: username,
//                                                 commentBody: 'Gig is completed',
//                                                 commentOwnerId: userId,
//                                                 commentOwnerAvatarUrl:
//                                                     userProfilePictureUrl,
//                                                 commentId: '',
//                                                 createdAt: DateTime.now(),
//                                                 isPrivateComment: true,
//                                                 proposal: false,
//                                                 approved: true,
//                                                 rejected: false,
//                                                 containMediaFile: false,
//                                                 isGigCompleted: true,
//                                                 ratingCount: 0,
//                                                 leftReview: false,
//                                               ),
//                                               widget.passedGigId,
//                                             );
//                                             FirestoreDatabase()
//                                                 .addGigWorkstreamActions(
//                                               gigId: widget.passedGigId,
//                                               action: 'marked as completed',
//                                               userAvatarUrl:
//                                                   MyUser.userAvatarUrl,
//                                               gigActionOwner: 'client',
//                                             );
//                                           }
//                                         : null,
//                                   ),
//                                 ],
//                               ),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   (!clientAction)
//                                       ? Container(
//                                           width: 0,
//                                           height: 0,
//                                         )
//                                       : (clientAction && markedAsCompleted)
//                                           ? Text('You can leave a review...',
//                                               style: fyreworkLightTheme()
//                                                   .textTheme
//                                                   .bodyText1)
//                                           : Text('Waiting for worker action...',
//                                               style: fyreworkLightTheme()
//                                                   .textTheme
//                                                   .bodyText1)
//                                 ],
//                               )
//                             ],
//                           ),
//                         );
//                       }
//                     },
//                   );
//                 } else {
//                   return Container(
//                       child: Center(
//                           child: Text(
//                     'Actions not available right now',
//                     style: fyreworkLightTheme().textTheme.bodyText1,
//                   )));
//                 }
//               }
//           }
//           return Container(
//               child: Center(
//                   child: CircularProgressIndicator(
//             valueColor: AlwaysStoppedAnimation<Color>(
//                 fyreworkLightTheme().primaryColor),
//           )));
//         },
//       ),
//     );
//   }
// }
