// import 'dart:io';
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_common_exports/flutter_common_exports.dart';
// import 'package:myApp/ui/shared/theme.dart';
// import 'package:path/path.dart' as fileName;
// import '../src/wechat_assets_picker.dart';
// import '../constants/picker_model.dart';

// class ProfilePicturePicker extends StatefulWidget {
//   ProfilePicturePicker({
//     Key key,
//   }) : super(key: key);

//   @override
//   _ProfilePicturePickerState createState() => _ProfilePicturePickerState();
// }

// class _ProfilePicturePickerState extends State<ProfilePicturePicker> {
//   final int maxAssetsCount = 1;

//   void initState() {
//     super.initState();
//     WidgetsBinding.instance
//         .addPostFrameCallback((_) => ((BuildContext context, int index) async {
//               final PickMethodModel model = pickMethods[index];
//               final List<AssetEntity> result =
//                   await model.method(context, selectedProfilePicture);
//               if (result != null && result != selectedProfilePicture) {
//                 selectedProfilePicture = result;
//                 if (mounted) {
//                   // Navigator.of(context).pop(selectedProfilePicture);
//                   print('coming from add_profile_picture');
//                   // setState(() {});
//                 }
//               }
//             }(context, 0)));
//   }

//   List<AssetEntity> selectedProfilePicture;

//   // ThemeData get currentTheme => context.themeData;

//   List<PickMethodModel> get pickMethods => <PickMethodModel>[
//         PickMethodModel(
//           icon: '📹',
//           name: 'Common picker',
//           description: 'Pick images and videos.',
//           method: (
//             BuildContext context,
//             List<AssetEntity> assets,
//           ) async {
//             return await AssetPicker.pickAssets(
//               context,
//               maxAssets: maxAssetsCount,
//               selectedAssets: assets,
//               requestType: RequestType.image,
//             );
//           },
//         ),
//       ];

//   Future<void> selectAssets(PickMethodModel model) async {
//     final List<AssetEntity> result =
//         await model.method(context, selectedProfilePicture);
//     if (result != null) {
//       selectedProfilePicture = result;
//       if (mounted) {
//         setState(() {});
//       }
//     }
//   }

//   // Future<void> methodWrapper(PickMethodModel model) async {
//   //   selectedProfilePicture =
//   //       await model.method(context, selectedProfilePicture);

//   //   if (mounted) {
//   //     setState(() {});
//   //   }
//   // }

//   // void removeAsset(int index) {
//   //   setState(() {
//   //     assets.remove(assets.elementAt(index));
//   //     if (assets.isEmpty) {
//   //       isDisplayingDetail = false;
//   //     }
//   //   });
//   // }

//   // Widget methodItemBuilder(BuildContext _, int index) {
//   //   final PickMethodModel model = pickMethods[index];

//   //   (() async {
//   //     final List<AssetEntity> result =
//   //         await model.method(context, selectedProfilePicture);
//   //     if (result != null && result != selectedProfilePicture) {
//   //       selectedProfilePicture = result;
//   //       if (mounted) {
//   //         setState(() {});
//   //       }
//   //     }
//   //   }());
//   // }

//   // Widget get methodListView => Expanded(
//   //       child: ListView.builder(
//   //         padding: const EdgeInsets.symmetric(vertical: 10.0),
//   //         itemCount: pickMethods.length,
//   //         itemBuilder: methodItemBuilder,
//   //       ),
//   //     );

//   Widget _assetWidgetBuilder(AssetEntity asset) {
//     Widget widget;
//     switch (asset.type) {
//       case AssetType.audio:
//         // widget = _audioAssetWidget(asset);
//         break;
//       case AssetType.video:
//         // widget = _videoAssetWidget(asset);
//         break;
//       case AssetType.image:
//       case AssetType.other:
//         widget = _imageAssetWidget(asset);
//         break;
//     }
//     return widget;
//   }

//   Widget _imageAssetWidget(AssetEntity asset) {
//     return Image(
//       image: AssetEntityImageProvider(asset, isOriginal: false),
//       fit: BoxFit.cover,
//     );
//   }

//   @override
//   void dispose() {
//     // Additional disposal code
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         // body: Stack(alignment: Alignment.center, children: <Widget>[
//         //   Container(height: 0, child: methodListView),
//         // ]),
//         );
//   }
// }
