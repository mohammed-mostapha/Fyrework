// import 'package:circular_reveal_animation/circular_reveal_animation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

// class WSRevealAnimation extends StatefulWidget {
//   @override
//   _WSRevealAnimationState createState() => _WSRevealAnimationState();
// }

// class _WSRevealAnimationState extends State<WSRevealAnimation>
//     with SingleTickerProviderStateMixin {
//   AnimationController animationController;
//   Animation<double> animation;

//   final String paperClip = 'assets/svgs/solid/paperclip.svg';

//   @override
//   void initState() {
//     super.initState();
//     animationController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 300),
//     );
//     animation = CurvedAnimation(
//       parent: animationController,
//       curve: Curves.easeInOut,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(border: Border.all(color: Colors.white)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         // MaterialButton(
//         //   child: Text("show reveal dialog"),
//         //   onPressed: () => showRevealDialog(context),
//         //   color: Colors.amber,
//         // ),
//         children: <Widget>[
//           CircularRevealAnimation(
//             child: Container(
//               width: 100,
//               height: 100,
//               color: Colors.red,
//             ),
//             animation: animation,
//             // centerAlignment: Alignment.centerRight,
//             centerOffset: Offset(130, 100),
// //                minRadius: 12,
// //                maxRadius: 200,
//           ),
//           GestureDetector(
//             onTap: () {
//               print('paperclip tapped');
//               if (animationController.status == AnimationStatus.forward ||
//                   animationController.status == AnimationStatus.completed) {
//                 animationController.reverse();
//               } else {
//                 animationController.forward();
//               }
//             },
//             child: Padding(
//               padding: const EdgeInsets.only(bottom: 15),
//               child: SizedBox(
//                 width: 20,
//                 height: 20,
//                 child: SvgPicture.asset(
//                   paperClip,
//                   semanticsLabel: 'paperclip',
//                   color: Theme.of(context).accentColor,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Future<void> showRevealDialog(BuildContext context) async {
//   //   showGeneralDialog(
//   //     barrierLabel: "Label",
//   //     barrierDismissible: true,
//   //     barrierColor: Colors.black.withOpacity(0.5),
//   //     transitionDuration: Duration(milliseconds: 700),
//   //     context: context,
//   //     pageBuilder: (context, anim1, anim2) {
//   //       return Align(
//   //         alignment: Alignment.bottomCenter,
//   //         child: Container(
//   //           child: Padding(
//   //               padding: const EdgeInsets.all(12.0),
//   //               child: Container(
//   //                 color: Colors.blue,
//   //               )),
//   //           margin: EdgeInsets.only(top: 50, left: 12, right: 12, bottom: 0),
//   //           decoration: BoxDecoration(
//   //             color: Colors.white,
//   //             borderRadius: BorderRadius.circular(5),
//   //           ),
//   //         ),
//   //       );
//   //     },
//   //     transitionBuilder: (context, anim1, anim2, child) {
//   //       return CircularRevealAnimation(
//   //         child: child,
//   //         animation: anim1,
//   //         centerAlignment: Alignment.bottomCenter,
//   //       );
//   //     },
//   //   );
//   // }
// }
