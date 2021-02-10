import 'package:flutter/material.dart';
import 'package:myApp/screens/add_gig/camera/src/widget/camera_picker.dart';

/// Built a slide page transition for the picker.
/// 为选择器构造一个上下进出的页面过渡动画
class SlidePageTransitionBuilder<T> extends PageRoute<T> {
  SlidePageTransitionBuilder({
    @required this.builder,
    this.transitionCurve = Curves.easeIn,
    this.transitionDuration = const Duration(milliseconds: 500),
  });

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
    // return Scaffold(
    //   body: PageView(
    //     controller: _pageController,
    //     children: [
    //       SlideTransition(
    //         position: Tween<Offset>(
    //           begin: const Offset(0, 1),
    //           end: Offset.zero,
    //           // end: const Offset(0, 0.2),
    //         ).animate(CurvedAnimation(
    //           curve: transitionCurve,
    //           parent: animation,
    //         )),
    //         child: child,
    //       ),
    //       Image_picker(),
    //       Video_picker(),
    //     ],
    //   ),
    // );

    return WillPopScope(
      onWillPop: () {
        // Navigator.pushNamedAndRemoveUntil(context, "/addGig", (r) => false);
        Navigator.of(context).pop();
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          bottomNavigationBar: BottomAppBar(
            child: TabBar(
              indicatorColor: Theme.of(context).accentColor,
              tabs: [
                Tab(
                  child: Text('Gallery',
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                      )),
                ),
                Tab(
                  child: Text('Camera',
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                      )),
                ),
              ],
            ),
            color: Theme.of(context).primaryColor,
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
              CameraPicker(),
            ],
          ),
        ),
      ),
    );
  }
}
