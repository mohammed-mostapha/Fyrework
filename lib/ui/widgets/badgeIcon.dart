import 'package:flutter/material.dart';

class BadgeIcon extends StatelessWidget {
  BadgeIcon(
      {this.icon,
      this.badgeCount,
      this.showIfZero = false,
      this.badgeColor,
      this.badgeCountColor,
      TextStyle badgeTextStyle})
      : this.badgeTextStyle = badgeTextStyle ??
            TextStyle(
              color: Colors.white,
              fontSize: 8,
            );
  final Widget icon;
  final int badgeCount;
  final bool showIfZero;
  final Color badgeColor;
  final Color badgeCountColor;
  final TextStyle badgeTextStyle;

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        icon,
        if (badgeCount > 0 || showIfZero) badge(badgeCount),
      ],
    );
  }

  Widget badge(int count) => Positioned(
        left: 10,
        bottom: 20,
        child: new Container(
          padding: EdgeInsets.all(2),
          decoration: new BoxDecoration(
            color: badgeCountColor,
            border: Border.all(width: 1, color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          constraints: BoxConstraints(
            minWidth: 20,
            minHeight: 20,
          ),
          child: Text(
            count.toString(),
            style: badgeTextStyle ??
                new TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      );
}
