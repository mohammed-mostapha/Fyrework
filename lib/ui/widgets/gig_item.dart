import 'dart:async';
import 'dart:core';
import 'package:Fyrework/models/myUser.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Fyrework/screens/add_gig/assets_picker/src/constants/constants.dart';
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
  final appointedUserFullName;
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
  final gigLikes;
  final appointedUserId;
  final adultContentText;
  final adultContentBool;
  final Function onDeleteItem;
  GigItem({
    Key key,
    this.index,
    this.appointed,
    this.appointedUserFullName,
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
    this.gigLikes,
    this.appointedUserId,
    this.adultContentText,
    this.adultContentBool,
    this.onDeleteItem,
  }) : super(key: key);

  @override
  _GigItemState createState() => _GigItemState();
}

class _GigItemState extends State<GigItem> with TickerProviderStateMixin {
  bool myGig;
  final String heart = 'assets/svgs/light/heart.svg';
  final String heartSolid = 'assets/svgs/solid/heart.svg';
  final String comment = 'assets/svgs/light/comment.svg';
  final String mapMarkerAlt = 'assets/svgs/light/map-marker-alt.svg';
  final String hourglassStart = 'assets/svgs/light/hourglass-start.svg';
  bool liked = false;
  bool showLikeOverlay = false;
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

  _likedPressed() {
    setState(() {
      liked = !liked;
      _likeAnimationController.forward().then((value) {
        _likeAnimationController.reverse();
      });
    });
    FirestoreService().updateGigAddRemoveLike(widget.gigId.gigId, liked);
  }

  _commentButtonPressed() {
    setState(() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddCommentsView(
                    passedGigId: widget.gigId,
                    passedGigOwnerId: widget.gigOwnerId,
                    passedCurrentUserId: widget.currentUserId,
                    // passedGigAppointed: widget.appointed,
                    passedGigValue: widget.gigValue,
                    passedGigCurrency: widget.gigCurrency,
                    passedGigBudget: widget.gigBudget,
                  )));
    });
  }

  _doubleTappedLike() {
    if (liked == false && showLikeOverlay == false) {
      setState(() {
        liked = true;
        showLikeOverlay = true;
        _likeAnimationController.forward().then((value) {
          _likeAnimationController.reverse();
        });
        if (showLikeOverlay) {
          Timer(const Duration(milliseconds: 500), () {
            setState(() {
              showLikeOverlay = false;
            });
          });
        }

        FirestoreService().updateGigAddRemoveLike(widget.gigId.gigId, liked);
      });
    }
    showLikeOverlay = true;
    _likeAnimationController.forward().then((value) {
      _likeAnimationController.reverse();
      showLikeOverlay = false;
    });
  }

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
    print('index from gig_item is: ${widget.index}');
    myGig = widget.gigOwnerId == MyUser.uid ? true : false;
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
          width: 20,
          height: 20,
          child: SvgPicture.asset(
            liked ? heartSolid : heart,
            semanticsLabel: 'Like',
            color: liked ? Colors.red[400] : Theme.of(context).primaryColor,
          ),
        ),
        onTap: () => _likedPressed(),
      ),
    );

    GestureDetector commentButton = GestureDetector(
      child: SizedBox(
        width: 20,
        height: 20,
        child: SvgPicture.asset(
          comment,
          semanticsLabel: 'Comment',
          color: Theme.of(context).primaryColor,
        ),
      ),
      onTap: () => _commentButtonPressed(),
    );

    return Container(
      color: Theme.of(context).accentColor,
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        child: Container(
                          width: 200,
                          child: Row(
                            children: [
                              CircleAvatar(
                                maxRadius: 20,
                                backgroundColor: Theme.of(context).primaryColor,
                                backgroundImage:
                                    NetworkImage("${widget.gigOwnerAvatarUrl}"),
                              ),
                              Container(
                                width: 10,
                                height: 0,
                              ),
                              Flexible(
                                child: Text(
                                  "${widget.gigOwnerUsername}".capitalize(),
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: showUserProfile,
                      ),
                      GestureDetector(
                        onTap: (myGig && !widget.appointed)
                            ? () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ChangeNotifierProvider(
                                              create: (context) =>
                                                  GigIndexProvider(),
                                              child: EditYourGig(
                                                gigIndex: widget.index,
                                                gigId: widget.gigId,
                                                currentUserId:
                                                    widget.currentUserId,
                                                gigOwnerId: widget.gigOwnerId,
                                                gigOwnerEmail:
                                                    widget.gigOwnerEmail,
                                                gigOwnerAvatarUrl:
                                                    widget.gigOwnerAvatarUrl,
                                                gigOwnerUsername:
                                                    widget.gigOwnerUsername,
                                                createdAt: widget.createdAt,
                                                gigOwnerLocation:
                                                    widget.gigOwnerLocation,
                                                gigLocation: widget.gigLocation,
                                                gigHashtags: widget.gigHashtags,
                                                gigMediaFilesDownloadUrls: widget
                                                    .gigMediaFilesDownloadUrls,
                                                gigPost: widget.gigPost,
                                                gigDeadline: widget.gigDeadline,
                                                gigCurrency: widget.gigCurrency,
                                                gigBudget: widget.gigBudget,
                                                gigValue: widget.gigValue,
                                                adultContentText:
                                                    widget.adultContentText,
                                                adultContentBool:
                                                    widget.adultContentBool,
                                              ),
                                            )));
                              }
                            : (myGig && widget.appointed)
                                ? () {}
                                : widget.gigValue == 'Gigs I can do'
                                    ? () {}
                                    : () {},
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Theme.of(context).primaryColor,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              (myGig && !widget.appointed)
                                  ? 'Edit Your gig'
                                  : (myGig && widget.appointed)
                                      ? 'Your gig \n Appointed'
                                      : widget.gigValue == 'Gigs I can do'
                                          ? 'Hire me'
                                          : 'Apply',
                              style: Theme.of(context).textTheme.bodyText1,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  // SizedBox(height: 10),
                ],
              ),
            ),
          ),
          GestureDetector(
            onDoubleTap: () => _doubleTappedLike(),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                GigItemMediaPreviewer(
                  receivedGigMediaFilesUrls: widget.gigMediaFilesDownloadUrls,
                ),
                showLikeOverlay
                    ? Icon(
                        Icons.favorite,
                        size: 120.0,
                        color: Colors.white,
                      )
                    : Container()
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 16.0),
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
                    widget.gigLocation != null
                        ? Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: SvgPicture.asset(
                                      mapMarkerAlt,
                                      semanticsLabel: 'Location',
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      '${widget.gigLocation}',
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        : Container(width: 0, height: 0),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    widget.gigLikes != null &&
                            widget.gigLikes != 0 &&
                            widget.gigLikes > 0
                        ? Flexible(
                            child: Text(
                            '${widget.gigLikes}' + ' ' + 'likes',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ))
                        : Container(
                            width: 0,
                            height: 0,
                          ),
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${widget.gigPost}".capitalize(),
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
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                                onTap: () {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => SearchScreen(
                                  //               query: h,
                                  //             )));
                                },
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
                            child: Text(
                              widget.gigDeadline != null
                                  ? DateFormat('yyyy-MM-dd').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                        widget.gigDeadline,
                                      ),
                                    )
                                  : "Book Gig",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
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
                Row(
                  children: [
                    Text(
                      timeAgo.format(widget.createdAt.toDate()),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
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
