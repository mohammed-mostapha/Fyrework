import 'package:flutter/foundation.dart';

class NotificationItemBuilder {
  final String gigId;
  final String gigOwnerId;
  final String likerId;
  final String likerUsername;
  final String likerUserAvatarUrl;
  final String notificationBody;
  final bool seen;

  NotificationItemBuilder({
    @required this.gigId,
    @required this.gigOwnerId,
    @required this.notificationBody,
    @required this.likerId,
    @required this.likerUsername,
    @required this.likerUserAvatarUrl,
    @required this.seen,
  });

  factory NotificationItemBuilder.fromRTDB(Map<String, dynamic> data) {
    return NotificationItemBuilder(
      gigId: data['gigId'],
      gigOwnerId: data['gigOwnerId'],
      notificationBody: data['notificationBody'],
      likerId: data['likerId'],
      likerUsername: data['likerUsername'],
      likerUserAvatarUrl: data['likerUserAvatarUrl'],
      seen: data['seen'],
    );
  }

  String notificationView() {
    return '$likerUsername liked your gig';
  }
}
