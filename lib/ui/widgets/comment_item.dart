import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myApp/models/gig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common_exports/src/extensions/build_context_extension.dart';
import 'package:timeago/timeago.dart' as timeAgo;

class CommentItem extends StatefulWidget {
  final gigIdHoldingComment;
  final commentId;
  final commentOwnerId;
  final commentOwnerProfilePictureUrl;
  final commentOwnerFullName;
  final commentBody;
  final commentTime;
  final Function onDeleteItem;
  CommentItem({
    Key key,
    this.gigIdHoldingComment,
    this.commentId,
    this.commentOwnerId,
    this.commentOwnerProfilePictureUrl,
    this.commentOwnerFullName,
    this.commentBody,
    this.commentTime,
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
          border:
              Border(bottom: BorderSide(width: 0.5, color: Colors.grey[400]))),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
              '${widget.commentOwnerProfilePictureUrl.commentOwnerProfilePictureUrl}'),
          radius: 20,
        ),
        title: Flexible(
          // child: Text('${widget.commentOwnerFullName.commentOwnerFullName}' +
          //     ' ' +
          //     '${widget.commentBody.commentBody}')),
          child: RichText(
            text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                      text:
                          '${widget.commentOwnerFullName.commentOwnerFullName} ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: '${widget.commentBody.commentBody}',
                      style: TextStyle(
                        fontSize: 18,
                      )),
                ]),
          ),
        ),
        subtitle: Flexible(
          child: Text(timeAgo.format(widget.commentTime.commentTime.toDate())),
          // child: Text('${widget.commentTime.commentTime}'),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
