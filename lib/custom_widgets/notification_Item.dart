import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeAgo;

class NotificationItem extends StatefulWidget {
  final index;
  final notificationId;
  final gigId;
  final notificationTitle;
  final notificationBody;
  bool seen;
  bool generalNotification;
  Timestamp createdAt;

  NotificationItem({
    Key key,
    this.index,
    this.notificationId,
    this.gigId,
    this.notificationTitle,
    this.notificationBody,
    this.seen,
    this.generalNotification,
    this.createdAt,
  }) : super(key: key);

  @override
  _NotificationItemState createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: CircleAvatar(
                  maxRadius: 15,
                  backgroundColor: Theme.of(context).primaryColor,
                  backgroundImage: AssetImage(
                    "assets/images/fyrework_launcher_icon.png",
                  ),
                ),
              ),
              SizedBox(
                width: 10,
                height: 0,
              ),
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Text(
                      //   'gigId: ${widget.gigId}',
                      //   style: Theme.of(context).textTheme.bodyText1,
                      // ),
                      Text('${widget.notificationTitle}',
                          style: Theme.of(context).textTheme.bodyText1),
                      SizedBox(
                        width: 0,
                        height: 5,
                      ),
                      Text('${widget.notificationBody}',
                          style: Theme.of(context).textTheme.bodyText1),
                      // Text('seen: ${widget.seen}',
                      //     style: Theme.of(context).textTheme.bodyText1),
                      // Text('generalNotification: ${widget.generalNotification}',
                      //     style: Theme.of(context).textTheme.bodyText1),
                      SizedBox(
                        width: 0,
                        height: 5,
                      ),
                      Text(
                        timeAgo.format(widget.createdAt.toDate()),
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // onTap: () async {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => Individual_gig_item(
      //         gigId: widget.gigId,
      //       ),
      //     ),
      //   );
      //   await DatabaseService()
      //       .markNotificationAsSeen(notificationId: widget.notificationId);
      // },
    );
  }
}
