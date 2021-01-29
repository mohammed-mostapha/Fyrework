import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_common_exports/flutter_common_exports.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myApp/screens/home/home.dart';
import 'package:myApp/services/storage_repo.dart';
import 'package:myApp/viewmodels/create_gig_view_model.dart';
import 'package:path/path.dart' as fileName;
import '../src/wechat_assets_picker.dart';
import '../constants/picker_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';

enum UrlType { IMAGE, VIDEO, UNKNOWN }

class MultiAssetsPicker extends StatefulWidget {
  final bool appointed;
  final String gigId;
  final String userId;
  final String userProfilePictureDownloadUrl;
  final String username;
  final String userLocation;
  final String gigLocation;
  final List gigHashtags;
  final List<String> gigMeidaFilesDownloadUrls = List<String>();
  final String gigPost;
  final dynamic gigDeadLine;
  final String gigCurrency;
  final dynamic gigBudget;
  final String adultContentText;
  final bool adultContentBool;
  final String gigValue;

  MultiAssetsPicker({
    Key key,
    this.appointed,
    this.gigId,
    this.userId,
    this.userProfilePictureDownloadUrl,
    this.username,
    this.userLocation,
    this.gigLocation,
    this.gigHashtags,
    this.gigPost,
    this.gigDeadLine,
    this.gigCurrency,
    this.gigBudget,
    this.adultContentText,
    this.adultContentBool,
    this.gigValue,
  }) : super(key: key);

  @override
  _MultiAssetsPickerState createState() => _MultiAssetsPickerState();
}

class _MultiAssetsPickerState extends State<MultiAssetsPicker> {
  final String hourglassStart = 'assets/svgs/light/hourglass-start.svg';
  var formattedGigDeadline;

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final List<AssetEntity> result = await PickMethodModel(
        method: (
          BuildContext context,
          List<AssetEntity> assets,
        ) async {
          return await AssetPicker.pickAssets(
            context,
            maxAssets: maxAssetsCount,
            selectedAssets: assets,
            requestType: RequestType.common,
          );
        },
      ).method(context, assets);
      if (result != null && result != assets) {
        assets = List<AssetEntity>.from(result);
        if (mounted) {
          setState(() {
            // choosedAssets = !choosedAssets;
            print('count: ${result.length}');
          });
        }
      }
    });
  }

  String id;
  final db = Firestore.instance;

  // bool choosedAssets = false;

  List<File> gigMediaFiles = List();

  final int maxAssetsCount = 5;

  List<AssetEntity> assets = <AssetEntity>[];

  bool isDisplayingDetail = true;

  int get assetsLength => assets.length;

  ThemeData get currentTheme => context.themeData;

  Future<void> selectAssets(PickMethodModel model) async {
    final List<AssetEntity> result = await model.method(context, assets);
    if (result != null) {
      assets = List<AssetEntity>.from(result);
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> methodWrapper(PickMethodModel model) async {
    assets = List<AssetEntity>.from(
      await model.method(context, assets),
    );
    if (mounted) {
      setState(() {});
    }
  }

  void removeAsset(int index) {
    setState(() {
      assets.remove(assets.elementAt(index));
      if (assets.isEmpty) {
        isDisplayingDetail = false;
      }
    });
  }

  Widget _assetWidgetBuilder(AssetEntity asset) {
    Widget widget;
    switch (asset.type) {
      case AssetType.audio:
        widget = _audioAssetWidget(asset);
        break;
      case AssetType.video:
        widget = _videoAssetWidget(asset);
        break;
      case AssetType.image:
      case AssetType.other:
        widget = _imageAssetWidget(asset);
        break;
    }
    return widget;
  }

  Widget _audioAssetWidget(AssetEntity asset) {
    return ColoredBox(
      color: context.themeData.dividerColor,
      child: Stack(
        children: <Widget>[
          AnimatedPositioned(
            duration: kThemeAnimationDuration,
            top: 0.0,
            left: 0.0,
            right: 0.0,
            bottom: isDisplayingDetail ? 20.0 : 0.0,
            child: Center(
              child: Icon(
                Icons.audiotrack,
                size: isDisplayingDetail ? 24.0 : 16.0,
              ),
            ),
          ),
          AnimatedPositioned(
            duration: kThemeAnimationDuration,
            left: 0.0,
            right: 0.0,
            bottom: isDisplayingDetail ? 0.0 : -20.0,
            height: 20.0,
            child: Text(
              asset.title,
              style: const TextStyle(
                height: 1.0,
                fontSize: 16.0,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageAssetWidget(AssetEntity asset) {
    return Image(
      image: AssetEntityImageProvider(asset, isOriginal: false),
      fit: BoxFit.cover,
    );
  }

  Widget _videoAssetWidget(AssetEntity asset) {
    return Stack(
      children: <Widget>[
        Positioned.fill(child: _imageAssetWidget(asset)),
        ColoredBox(
          color: context.themeData.dividerColor.withOpacity(0.3),
          child: Center(
            child: Icon(
              Icons.video_library,
              color: Colors.white,
              size: isDisplayingDetail ? 24.0 : 16.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _selectedAssetWidget(int index) {
    final AssetEntity asset = assets.elementAt(index);
    return GestureDetector(
      onTap: isDisplayingDetail
          ? () async {
              final List<AssetEntity> result =
                  await AssetPickerViewer.pushToViewer(
                context,
                currentIndex: index,
                assets: assets,
                themeData: AssetPicker.themeData(Colors.transparent),
              );
              if (result != assets && result != null) {
                assets = List<AssetEntity>.from(result);
                if (mounted) {
                  setState(() {});
                }
              }
            }
          : null,
      child: RepaintBoundary(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: _assetWidgetBuilder(asset),
        ),
      ),
    );
  }

  Widget _selectedAssetDeleteButton(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          assets.remove(assets.elementAt(index));
          if (assetsLength == 0) {
            isDisplayingDetail = false;
          }
        });
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: currentTheme.canvasColor.withOpacity(0.5),
        ),
        child: Icon(
          Icons.close,
          color: currentTheme.iconTheme.color,
          size: 18.0,
        ),
      ),
    );
  }

  Widget get selectedAssetsWidget => AnimatedContainer(
        duration: kThemeChangeDuration,
        curve: Curves.easeInOut,
        height: assets.isNotEmpty ? isDisplayingDetail ? 250.0 : 80.0 : 40.0,
        child: Column(
          children: <Widget>[
            selectedAssetsListView,
          ],
        ),
      );

  Widget get selectedAssetsListView => Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          // padding: const EdgeInsets.symmetric(horizontal: 8.0),
          scrollDirection: Axis.horizontal,
          itemCount: assetsLength,
          itemBuilder: (BuildContext _, int index) {
            return Padding(
              // padding: const EdgeInsets.symmetric(
              //   // horizontal: 8.0,
              //   vertical: 16.0,
              // ),
              padding: EdgeInsets.fromLTRB(0, 16, 4, 16),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(child: _selectedAssetWidget(index)),
                    AnimatedPositioned(
                      duration: kThemeAnimationDuration,
                      top: isDisplayingDetail ? 6.0 : -30.0,
                      right: isDisplayingDetail ? 6.0 : -30.0,
                      child: _selectedAssetDeleteButton(index),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );

  Future prepareGigMediaFilesAndPublish() async {
    Future<List<File>> assignAssetsToGigMediaFiles = assigingLists();
    await assignAssetsToGigMediaFiles;
    await uploadMediaFiles();
    clearGigMediaFiles();
  }

  Future<List<File>> assigingLists() async {
    for (final mediaFile in assets) {
      gigMediaFiles.add(await mediaFile.originFile);
    }
  }

  Future uploadMediaFiles() async {
    String storageResult;
    if (gigMediaFiles != null) {
      for (var i = 0; i < gigMediaFiles.length; i++) {
        final parsedItemUrl = getUrlType(gigMediaFiles[i].path);
        if (parsedItemUrl == UrlType.IMAGE) {
          //uploading as an image file
          storageResult = await StorageRepo().uploadMediaFile(
            mediaFileToUpload: gigMediaFiles[i],
            title: fileName.basename(gigMediaFiles[i].path + "imageFile"),
          );
        } else if (parsedItemUrl == UrlType.VIDEO) {
          //uploading as a video file
          storageResult = await StorageRepo().uploadMediaFile(
            mediaFileToUpload: gigMediaFiles[i],
            title: fileName.basename(gigMediaFiles[i].path + "videoFile"),
          );
        } else {
          // uploading and didn't specify an extension
        }

        //adding each downloadUrl to downloadUrls list
        widget.gigMeidaFilesDownloadUrls.add(storageResult);
      }

      CreateGigViewModel().addGig(
        appointed: widget.appointed,
        gigId: widget.gigId,
        userId: widget.userId,
        userProfilePictureDownloadUrl: widget.userProfilePictureDownloadUrl,
        username: widget.username,
        gigHashtags: widget.gigHashtags,
        userLocation: widget.userLocation,
        gigLocation: widget.gigLocation,
        gigMediaFilesDownloadUrls: widget.gigMeidaFilesDownloadUrls,
        gigPost: widget.gigPost,
        gigDeadLine: widget.gigDeadLine,
        gigCurrency: widget.gigCurrency,
        gigBudget: widget.gigBudget,
        gigValue: widget.gigValue,
        adultContentText: widget.adultContentText,
        adultContentBool: widget.adultContentBool,
      );
      clearGigMediaFiles();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => Home(passedSelectedIndex: 0),
          ),
          (route) => false);
    }
  }

  clearGigMediaFiles() {
    gigMediaFiles.clear();
    print(gigMediaFiles);
    // choosedAssets = false;
  }

  @override
  void dispose() {
    // Additional disposal code
    super.dispose();
  }

  Widget get gigPreview {
    if (widget.gigDeadLine != null) {
      formattedGigDeadline = DateFormat.yMMMd()
          .format(DateTime.fromMillisecondsSinceEpoch(widget.gigDeadLine));
    }

    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(2))),
                      child: Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Back',
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(2))),
                      child: Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Publish',
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                    ),
                    onTap: () async {
                      EasyLoading.show();
                      await prepareGigMediaFilesAndPublish();
                      print('should dismiss');
                      EasyLoading.dismiss();
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Wrap(
                children: widget.gigHashtags
                    .map((e) => Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 2.5, 2.5),
                          child: Chip(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            backgroundColor: Theme.of(context).primaryColor,
                            label: Text(
                              '$e',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            onDeleted: () {
                              setState(() {
                                widget.gigHashtags
                                    .removeWhere((item) => item == e);
                                print(widget.gigHashtags.length);
                              });
                            },
                            deleteIconColor: Colors.white,
                          ),
                        ))
                    .toList(),
              ),
              selectedAssetsWidget,
              SizedBox(height: 10.0),
              Text('${widget.gigPost}', style: TextStyle(fontSize: 16)),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: widget.gigDeadLine != null
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.start,
                children: <Widget>[
                  widget.gigDeadLine != null
                      ? Row(
                          children: <Widget>[
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: SvgPicture.asset(
                                hourglassStart,
                                semanticsLabel: 'hourglass-start',
                                // color: Theme.of(context).primaryColor,
                                // color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Container(
                              width: 5.0,
                              height: 0,
                            ),
                            Container(
                              child: Text(
                                '$formattedGigDeadline',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(
                          width: 0,
                          height: 0,
                        ),
                  SizedBox(height: 5),
                  Row(
                    children: <Widget>[
                      Container(
                        child: AutoSizeText(
                          '${widget.gigCurrency}',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        width: 2.5,
                        height: 0,
                      ),
                      Container(
                        child: AutoSizeText(
                          '${widget.gigBudget}',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              widget.adultContentBool
                  ? Container(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.asterisk,
                                size: 8,
                              ),
                              Container(
                                width: 5.0,
                                height: 0,
                              ),
                              Expanded(
                                child: AutoSizeText(
                                  "${widget.adultContentText}",
                                  style: TextStyle(
                                    fontSize: 8,
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
            ],
          ),
        ),
      ),
    );
  }

  // detecting the urlType from firebase links
  UrlType getUrlType(String url) {
    Uri uri = Uri.parse(url);
    String typeString = uri.path.substring(uri.path.length - 3).toLowerCase();
    if (typeString == "jpg" || typeString == "PNG" || typeString == "gif") {
      return UrlType.IMAGE;
    } else if (typeString == "mp4" || typeString == "avi") {
      return UrlType.VIDEO;
    } else {
      return UrlType.UNKNOWN;
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   return SafeArea(
  //     child: Scaffold(
  //       body: Stack(
  //         // alignment: Alignment.center,
  //         children: <Widget>[
  //           Container(child: methodListView),
  //           Padding(
  //             padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
  //             child: Container(
  //               child: SingleChildScrollView(
  //                 child: Column(
  //                   children: <Widget>[
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: <Widget>[
  //                         RaisedButton(
  //                             color: FyreworkrColors.fyreworkBlack,
  //                             child: Text(
  //                               'back',
  //                               style: TextStyle(color: FyreworkrColors.white),
  //                             ),
  //                             onPressed: () {
  //                               clearGigMediaFiles();
  //                               print(gigMediaFiles.length);
  //                             }),
  //                         RaisedButton(
  //                           color: FyreworkrColors.fyreworkBlack,
  //                           child: Text(
  //                             'PUBLISH',
  //                             style: TextStyle(color: FyreworkrColors.white),
  //                           ),
  //                           onPressed: () {
  //                             prepareGigMediaFilesAndPublish();
  //                           },
  //                         ),
  //                       ],
  //                     ),
  //                     gigPreview,
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // body: pickAssetsCommon(),
        body: gigPreview,
      ),
    );
  }
}
