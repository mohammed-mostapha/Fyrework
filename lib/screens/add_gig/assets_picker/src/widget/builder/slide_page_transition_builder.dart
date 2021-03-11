import 'dart:io';
import 'package:Fyrework/screens/add_gig/assets_picker/src/wechat_assets_picker.dart';
import 'package:Fyrework/ui/shared/fyreworkTheme.dart';
import 'package:flutter/material.dart';
import 'package:Fyrework/screens/add_gig/camera/src/widget/camera_picker.dart';

/// Built a slide page transition for the picker.
/// 为选择器构造一个上下进出的页面过渡动画
class SlidePageTransitionBuilder<T> extends PageRoute<T> {
  SlidePageTransitionBuilder({
    @required this.builder,
    this.transitionCurve = Curves.easeIn,
    this.transitionDuration = const Duration(milliseconds: 500),
  });

  bool get isAppleOS => Platform.isIOS || Platform.isMacOS;

  final Widget builder;

  final Curve transitionCurve;

  @override
  final Duration transitionDuration;

  @override
  final bool opaque = true;

  @override
  final bool barrierDismissible = false;

  @override
  final bool maintainState = true;

  @override
  Color get barrierColor => null;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder;
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          bottomNavigationBar: BottomAppBar(
            child: TabBar(
              indicatorColor: fyreworkTheme().accentColor,
              tabs: [
                Tab(
                  child: Text(
                    'Gallery',
                    style: fyreworkTheme().textTheme.bodyText1.copyWith(
                          // color: theme.textTheme.caption.color,
                          color: fyreworkTheme().textTheme.caption.color,
                        ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Camera',
                    style: fyreworkTheme().textTheme.bodyText1.copyWith(
                          color: fyreworkTheme().textTheme.caption.color,
                        ),
                  ),
                ),
              ],
            ),
            color: fyreworkTheme()
                .bottomAppBarColor
                .withOpacity(isAppleOS ? 0.90 : 1.0),
          ),
          body: TabBarView(
            children: [
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                  // end: const Offset(0, 0.2),
                ).animate(CurvedAnimation(
                  curve: transitionCurve,
                  parent: animation,
                )),
                child: child,
              ),
              CameraPicker(
                isAllowRecording: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
