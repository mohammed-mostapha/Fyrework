import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:myApp/models/gig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common_exports/src/extensions/build_context_extension.dart';
import 'package:myApp/services/firestore_service.dart';
import 'package:myApp/ui/shared/theme.dart';
import 'package:timeago/timeago.dart' as timeAgo;

class CommentItem extends StatefulWidget {
  final currentUserId;
  final gigIdHoldingComment;
  final commentId;
  final commentOwnerId;
  final commentOwnerProfilePictureUrl;
  final commentOwnerFullName;
  final commentBody;
  final commentTime;
  final privateComment;
  final Function onDeleteItem;
  CommentItem({
    Key key,
    this.currentUserId,
    this.gigIdHoldingComment,
    this.commentId,
    this.commentOwnerId,
    this.commentOwnerProfilePictureUrl,
    this.commentOwnerFullName,
    this.commentBody,
    this.commentTime,
    this.privateComment,
    this.onDeleteItem,
  }) : super(key: key);

  @override
  _CommentItemState createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  ThemeData get currentTheme => context.themeData;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // public comment view
    Widget publicCommentView = ListTile(
      leading: CircleAvatar(
        backgroundImage:
            NetworkImage('${widget.commentOwnerProfilePictureUrl}'),
        radius: 20,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${widget.commentOwnerFullName}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: widget.commentOwnerId == widget.currentUserId
                    ? Colors.white
                    : FyreworkrColors.fyreworkBlack,
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text('${widget.commentBody}',
                    style: TextStyle(
                      fontSize: 18,
                      color: widget.commentOwnerId == widget.currentUserId
                          ? Colors.white
                          : FyreworkrColors.fyreworkBlack,
                    )),
              ),
              SizedBox(
                width: 10,
              ),
              widget.commentOwnerId == widget.currentUserId
                  ? Container(
                      width: 60,
                      height: 25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white54,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white54,
                          ),
                        ],
                      ),
                      child: Switch(
                        activeColor: FyreworkrColors.fyreworkBlack,
                        activeTrackColor: Colors.black54,
                        value: widget.privateComment,
                        onChanged: (value) {
                          FirestoreService()
                              .commentPrivacyToggle(widget.commentId, value);
                        },
                      ),
                    )
                  : Container(width: 0, height: 0)
            ],
          ),
        ],
      ),
      subtitle: Flexible(
        child: Text(
          timeAgo.format(widget.commentTime.toDate()),
          style: TextStyle(
            fontSize: 12,
            color: widget.commentOwnerId == widget.currentUserId
                ? Colors.white
                : FyreworkrColors.fyreworkBlack,
          ),
        ),
        // child: Text('${widget.commentTime}'),
      ),
    );

    // private comment view
    Widget privateCommentView = Container(
      width: double.infinity,
      height: 70,
      child: Center(
        child: Text('Private comment',
            style: TextStyle(
              color: widget.commentOwnerId == widget.currentUserId
                  ? Colors.white
                  : FyreworkrColors.fyreworkBlack,
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
    return Container(
        decoration: BoxDecoration(
          color: widget.commentOwnerId == widget.currentUserId
              ? FyreworkrColors.fyreworkBlack
              : Colors.grey[50],
          border: Border(
            top: widget.commentOwnerId == widget.currentUserId
                ? BorderSide(width: 0.3, color: Colors.grey[50])
                : BorderSide(width: 0.3, color: FyreworkrColors.fyreworkBlack),
            bottom: widget.commentOwnerId == widget.currentUserId
                ? BorderSide(width: 0.3, color: Colors.green)
                : BorderSide(width: 0.3, color: FyreworkrColors.fyreworkBlack),
          ),
        ),
        child: widget.commentOwnerId == widget.currentUserId
            ? publicCommentView
            : widget.privateComment ? privateCommentView : publicCommentView);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
