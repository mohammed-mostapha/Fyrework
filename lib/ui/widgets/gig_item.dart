import 'dart:core';
import 'package:Fyrework/models/myUser.dart';
import 'package:Fyrework/services/database.dart';
import 'package:Fyrework/ui/shared/fyreworkDarkTheme.dart';
import 'package:Fyrework/ui/shared/fyreworkLightTheme.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Fyrework/services/firestore_service.dart';
import 'package:Fyrework/ui/views/add_comments_view.dart';
import 'package:Fyrework/ui/widgets/gig_item_media_previewer.dart';
import 'package:Fyrework/ui/widgets/user_profile.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeAgo;
import 'package:Fyrework/ui/views/edit_your_gig.dart';
import 'package:Fyrework/screens/trends/gigIndexProvider.dart';

class GigItem extends StatefulWidget {
  final index;
  final appointed;
  final appointedusername;
  final appliersOrHirersByUserId;
  final gigId;
  final currentUserId;
  final gigOwnerId;
  final gigOwnerEmail;
  final gigOwnerAvatarUrl;
  final gigOwnerUsername;
  final createdAt;
  final gigOwnerLocation;
  final gigLocation;
  final gigHashtags;
  final gigMediaFilesDownloadUrls;
  final gigPost;
  final gigDeadline;
  final gigCurrency;
  final gigBudget;
  final gigValue;
  final appointedUserId;
  final adultContentText;
  final adultContentBool;
  final hidden;
  final gigActions;
  final paymentReleased;
  final markedAsComplete;
  final clientLeftReview;
  final likesCount;
  final likersByUserId;

  GigItem({
    Key key,
    this.index,
    this.appointed,
    this.appointedusername,
    this.appliersOrHirersByUserId,
    this.gigId,
    this.currentUserId,
    this.gigOwnerId,
    this.gigOwnerEmail,
    this.gigOwnerAvatarUrl,
    this.gigOwnerUsername,
    this.createdAt,
    this.gigOwnerLocation,
    this.gigLocation,
    this.gigHashtags,
    this.gigMediaFilesDownloadUrls,
    this.gigPost,
    this.gigDeadline,
    this.gigCurrency,
    this.gigBudget,
    this.gigValue,
    this.appointedUserId,
    this.adultContentText,
    this.adultContentBool,
    this.hidden,
    this.gigActions,
    this.paymentReleased,
    this.markedAsComplete,
    this.clientLeftReview,
    this.likesCount,
    this.likersByUserId,
  }) : super(key: key);

  @override
  _GigItemState createState() => _GigItemState();
}

class _GigItemState extends State<GigItem> with TickerProviderStateMixin {
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  bool myGig = false;
  bool appointed = false;
  bool appointedUser = false;
  String appointedUserId = '';
  bool appliedOrHired = false;
  List appliersOrHirersByUserId = [];
  bool gigICanDo = false;

  final String heart = 'assets/svgs/light/heart.svg';
  final String heartSolid = 'assets/svgs/solid/heart.svg';
  final String comment = 'assets/svgs/light/comment.svg';
  final String mapMarkerAlt = 'assets/svgs/light/map-marker-alt.svg';
  final String hourglassStart = 'assets/svgs/light/hourglass-start.svg';
  final String editIcon = 'assets/svgs/flaticon/edit.svg';
  final String deleteIcon = 'assets/svgs/flaticon/delete.svg';
  final String markAsCompletedIcon =
      'assets/svgs/flaticon/mark_as_completed.svg';
  final String releaseEscrowPaymentIcon =
      'assets/svgs/flaticon/release_escrow_payment.svg';

  AnimationController _likeAnimationController;

  // List<String> gigMediaFilesDownloadedUrls = List<String>();

  void initState() {
    super.initState();

    _likeAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 125),
      value: 1.0,
      lowerBound: 1.0,
      upperBound: 1.25,
    );
  }

  _commentButtonPressed() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddCommentsView(
                  passedGigId: widget.gigId,
                  passedGigOwnerId: widget.gigOwnerId,
                  passGigOwnerUsername: widget.gigOwnerUsername,
                  passedCurrentUserId: widget.currentUserId,
                  // passedGigAppointed: widget.appointed,
                  passedGigValue: widget.gigValue,
                  passedGigCurrency: widget.gigCurrency,
                  passedGigBudget: widget.gigBudget,
                )));
  }

  // _doubleTappedLike() {
  //   if (liked == false && showLikeOverlay == false) {
  //     setState(() {
  //       liked = true;
  //       showLikeOverlay = true;
  //       _likeAnimationController.forward().then((value) {
  //         _likeAnimationController.reverse();
  //       });
  //       if (showLikeOverlay) {
  //         Timer(const Duration(milliseconds: 500), () {
  //           setState(() {
  //             showLikeOverlay = false;
  //           });
  //         });
  //       }

  //       FirestoreService().updateGigAddRemoveLike(widget.gigId, liked);
  //     });
  //   }
  //   showLikeOverlay = true;
  //   _likeAnimationController.forward().then((value) {
  //     _likeAnimationController.reverse();
  //     showLikeOverlay = false;
  //   });
  // }

  showUserProfile() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UserProfileView(
                  passedUserUid: widget.gigOwnerId,
                  // passedUsername: widget.gigOwnerUsername,
                  fromComment: false,
                  fromGig: true,
                )));
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool darkModeOn = brightness == Brightness.dark;
    ThemeData themeOfOppositeContext =
        darkModeOn ? fyreworkLightTheme() : fyreworkDarkTheme();

    bool gigHasLikes = widget.likesCount > 0 ? true : false;
    bool liked = widget.likersByUserId.contains(MyUser.uid) ? true : false;

    _likedPressed() {
      setState(() {
        liked = !liked;
        _likeAnimationController.forward().then((value) {
          _likeAnimationController.reverse();
        });
      });
      FirestoreService().updateGigAddRemoveLike(
        gigId: widget.gigId,
        userId: MyUser.uid,
        likedOrNot: liked,
      );
    }

    myGig = widget.gigOwnerId == MyUser.uid ? true : false;
    appointed = widget.appointed;
    appointedUserId = widget.appointedUserId;
    appliedOrHired =
        appliersOrHirersByUserId.contains(MyUser.uid) ? true : false;
    appliersOrHirersByUserId = widget.appliersOrHirersByUserId;
    gigICanDo = widget.gigValue == 'Gig I can do' ? true : false;

    appointedUser = appointedUserId == MyUser.uid ? true : false;

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

    ScaleTransition likeButton = ScaleTransition(
      scale: _likeAnimationController,
      child: GestureDetector(
        child: SizedBox(
          width: 25,
          height: 25,
          child: SvgPicture.asset(
            liked ? heartSolid : heart,
            semanticsLabel: 'Like',
            color: liked ? Colors.red[300] : Theme.of(context).primaryColor,
          ),
        ),
        onTap: () => _likedPressed(),
      ),
    );

    GestureDetector commentButton = GestureDetector(
      child: SizedBox(
        width: 25,
        height: 25,
        child: SvgPicture.asset(
          comment,
          semanticsLabel: 'Comment',
          color: Theme.of(context).primaryColor,
        ),
      ),
      onTap: () => _commentButtonPressed(),
    );

    void editYourGig() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                    create: (context) => GigIndexProvider(),
                    child: EditYourGig(
                      gigIndex: widget.index,
                      gigId: widget.gigId,
                      currentUserId: widget.currentUserId,
                      gigOwnerId: widget.gigOwnerId,
                      gigOwnerEmail: widget.gigOwnerEmail,
                      gigOwnerAvatarUrl: widget.gigOwnerAvatarUrl,
                      gigOwnerUsername: widget.gigOwnerUsername,
                      createdAt: widget.createdAt,
                      gigOwnerLocation: widget.gigOwnerLocation,
                      gigLocation: widget.gigLocation,
                      gigHashtags: widget.gigHashtags,
                      gigMediaFilesDownloadUrls:
                          widget.gigMediaFilesDownloadUrls,
                      gigPost: widget.gigPost,
                      gigDeadline: widget.gigDeadline,
                      gigCurrency: widget.gigCurrency,
                      gigBudget: widget.gigBudget,
                      gigValue: widget.gigValue,
                      adultContentText: widget.adultContentText,
                      adultContentBool: widget.adultContentBool,
                    ),
                  )));
    }

    Widget deleteYourGigAlert = AlertDialog(
      backgroundColor: Theme.of(context).primaryColor,
      content: Text('Are you sure you want to delete this gig?',
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(color: Theme.of(context).accentColor)),
      actions: [
        FlatButton(
          child: Text(
            'No',
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(color: Theme.of(context).accentColor),
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
        FlatButton(
          child: Text(
            'Yes',
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(color: Theme.of(context).accentColor),
          ),
          onPressed: () async {
            Navigator.of(context, rootNavigator: true).pop();
            EasyLoading.show();
            await DatabaseService().deleteMyGigByGigId(gigId: widget.gigId);

            EasyLoading.showSuccess('');

            EasyLoading.dismiss();
          },
        )
      ],
    );

    void deleteYourGig() {
      showDialog(
        context: context,
        builder: ((_) => deleteYourGigAlert),
        barrierDismissible: true,
      );
    }

    final String editText = 'Edit Your Gig';
    final String deleteText = 'Delete Your Gig';
    final String markAsCompletedText = 'Mark as completed';
    final String releaseEscrowPaymentText = 'Release Escrow Payment';

    List<String> notAppointedGigActionTexts = [editText, deleteText];
    List<String> appointedGigActionTexts = [
      markAsCompletedText,
      releaseEscrowPaymentText,
    ];

    void yourGigChoicesAction(String choice) {
      if (choice == editText) {
        return editYourGig();
      } else if (choice == deleteText) {
        return deleteYourGig();
      }
    }

    return Container(
      color: Theme.of(context).accentColor,
      child: Column(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        child: Container(
                          width: 250,
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Row(
                              children: [
                                Container(
                                  child: CircleAvatar(
                                    maxRadius: 30,
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    backgroundImage: NetworkImage(
                                        "${widget.gigOwnerAvatarUrl}"),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                  height: 0,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Container(
                                        width: 150,
                                        child: Text(
                                          capitalize(
                                              "${widget.gigOwnerUsername}"),
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Flexible(
                                      child: Container(
                                        width: 150,
                                        child: Text(
                                          '${widget.gigLocation}',
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .copyWith(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: showUserProfile,
                      ),
                      (myGig && !widget.appointed)
                          ? PopupMenuButton(
                              color: Theme.of(context).primaryColor,
                              onSelected: yourGigChoicesAction,
                              itemBuilder: (BuildContext context) {
                                return notAppointedGigActionTexts
                                    .map((String choice) {
                                  return PopupMenuItem<String>(
                                    value: choice,
                                    child: ListTile(
                                      leading: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: SvgPicture.asset(
                                          choice == editText
                                              ? editIcon
                                              : deleteIcon,
                                          semanticsLabel: 'edit',
                                          color: Theme.of(context).accentColor,
                                        ),
                                      ),
                                      title: Text(
                                        choice,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .accentColor),
                                      ),
                                    ),
                                  );
                                }).toList();
                              },
                            )
                          : (myGig && widget.appointed)
                              ? PopupMenuButton(
                                  icon: Icon(Icons.more_horiz,
                                      color: Theme.of(context).primaryColor),
                                  color: Theme.of(context).primaryColor,
                                  itemBuilder: (BuildContext context) {
                                    return appointedGigActionTexts
                                        .map((String choice) {
                                      return PopupMenuItem<String>(
                                        value: choice,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: themeOfOppositeContext
                                                    .inputDecorationTheme
                                                    .fillColor,
                                                border: Border(),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: ListTile(
                                              leading: SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: SvgPicture.asset(
                                                  choice == markAsCompletedText
                                                      ? markAsCompletedIcon
                                                      : releaseEscrowPaymentIcon,
                                                  semanticsLabel:
                                                      'popupMenuItem',
                                                  color: Theme.of(context)
                                                      .accentColor,
                                                ),
                                              ),
                                              title: Text(
                                                choice,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                        color: Theme.of(context)
                                                            .accentColor),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList();
                                  },
                                )
                              : GestureDetector(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(2))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        (!appliedOrHired && !gigICanDo)
                                            ? 'APPLY'
                                            : (!appliedOrHired && gigICanDo)
                                                ? 'HIRE'
                                                : (appliedOrHired && !gigICanDo)
                                                    ? 'APPLIED'
                                                    : 'HIRED',
                                        // !gigICanDo ? 'APPLY' : 'HIRE',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .primaryColor),
                                      ),
                                    ),
                                  ),
                                  onTap: (!appliedOrHired && !gigICanDo)
                                      ? () {
                                          //APPLY on this gig
                                        }
                                      : (!appliedOrHired && gigICanDo)
                                          ? () {
                                              // HIRE the gig poster
                                            }
                                          : (appliedOrHired && !gigICanDo)
                                              ? () {
                                                  // You have applied on this gig
                                                }
                                              : () {
                                                  // You hired the gig poster
                                                })
                    ],
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            // onDoubleTap: () => _doubleTappedLike(),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                GigItemMediaPreviewer(
                  receivedGigMediaFilesUrls: widget.gigMediaFilesDownloadUrls,
                ),
                // showLikeOverlay
                //     ? Icon(
                //         Icons.favorite,
                //         size: 120.0,
                //         color: Colors.white,
                //       )
                //     : Container()
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(13, 0, 13, 16.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        children: <Widget>[
                          likeButton,
                          SizedBox(
                            width: 15,
                          ),
                          commentButton
                        ],
                      ),
                    ),

                    // width: MediaQuery.of(context).size.width / 2.5,
                    // widget.gigLocation != null
                    //     ? Expanded(
                    //         child: Padding(
                    //           padding: const EdgeInsets.only(left: 10),
                    //           child: Row(
                    //             mainAxisAlignment: MainAxisAlignment.end,
                    //             children: [
                    //               SizedBox(
                    //                 width: 16,
                    //                 height: 16,
                    //                 child: SvgPicture.asset(
                    //                   mapMarkerAlt,
                    //                   semanticsLabel: 'Location',
                    //                   color: Theme.of(context).primaryColor,
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       )
                    //     : Container(width: 0, height: 0),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    gigHasLikes
                        ? Flexible(
                            child: Text(
                                (widget.likesCount > 1)
                                    ? '${widget.likesCount}' + ' ' + 'likes'
                                    : '${widget.likesCount}' + ' ' + 'like',
                                style: Theme.of(context).textTheme.bodyText1))
                        : Container(
                            width: 0,
                            height: 0,
                          ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    capitalize("${widget.gigPost}"),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  width: double.infinity,
                  child: Wrap(
                    children: widget.gigHashtags
                        .map<Widget>((h) => Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 5, 2.5),
                              child: GestureDetector(
                                child: Text(
                                  '$h',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                          color:
                                              Theme.of(context).primaryColor),
                                ),
                                onTap: () {},
                              ),
                            ))
                        .toList(),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: SvgPicture.asset(
                            hourglassStart,
                            semanticsLabel: 'hourglass-start',
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Container(
                          width: 5.0,
                          height: 0,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: widget.gigDeadline != null
                                  ? Text(
                                      widget.gigDeadline,
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    )
                                  : Text(
                                      "Book Gig",
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    )),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Container(
                      child: RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                            style: Theme.of(context).textTheme.bodyText1,
                            children: <TextSpan>[
                              TextSpan(
                                text: "${widget.gigCurrency} ",
                              ),
                              TextSpan(
                                text: "${widget.gigBudget}",
                              ),
                            ]),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                widget.createdAt != null
                    ? Row(
                        children: [
                          Text(
                            timeAgo.format(widget.createdAt.toDate()),
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ],
                      )
                    : Container(
                        width: 0,
                        height: 0,
                      ),
                widget.adultContentBool
                    ? Container(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: [
                            SizedBox(height: 5),
                            Row(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.asterisk,
                                  size: 12,
                                ),
                                Container(
                                  width: 5.0,
                                ),
                                Expanded(
                                  child: Text(
                                    "${widget.adultContentText}",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : Container(
                        width: 0,
                        height: 0,
                      ),
                SizedBox(height: 5),
              ],
            ),
          ),
        ],
      ),
      // decoration: BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.circular(5),
      //     boxShadow: [
      //       BoxShadow(blurRadius: 8, color: Colors.grey[200], spreadRadius: 3)
      //     ]),
    );
  }

  @override
  void dispose() {
    _likeAnimationController.dispose();
    super.dispose();
  }
}
