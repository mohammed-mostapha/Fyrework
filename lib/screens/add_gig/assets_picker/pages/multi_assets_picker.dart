import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_common_exports/flutter_common_exports.dart';
import 'package:myApp/screens/home/home.dart';
import 'package:myApp/services/storage_repo.dart';
import 'package:myApp/ui/shared/theme.dart';
import 'package:myApp/viewmodels/create_gig_view_model.dart';
import 'package:path/path.dart' as fileName;
import '../src/wechat_assets_picker.dart';
import '../constants/picker_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum UrlType { IMAGE, VIDEO, UNKNOWN }

class MultiAssetsPicker extends StatefulWidget {
  final String gigId;
  final String receivedUserId;
  final String receivedUserProfilePictureDownloadUrl;
  final String receivedUserFullName;
  final String receivedGigHashtags;
  final List<String> gigMeidaFilesDownloadUrls = List<String>();
  final String receivedGigPost;
  final dynamic receivedGigDeadLine;
  final String receivedGigCurrency;
  final dynamic receivedGigBudget;
  final String receivedAdultContentText;
  final bool receivedAdultContentBool;
  final String receivedGigValue;

  MultiAssetsPicker({
    Key key,
    this.gigId,
    this.receivedUserId,
    this.receivedUserProfilePictureDownloadUrl,
    this.receivedUserFullName,
    this.receivedGigHashtags,
    this.receivedGigPost,
    this.receivedGigDeadLine,
    this.receivedGigCurrency,
    this.receivedGigBudget,
    this.receivedAdultContentText,
    this.receivedAdultContentBool,
    this.receivedGigValue,
  }) : super(key: key);

  @override
  _MultiAssetsPickerState createState() => _MultiAssetsPickerState();
}

class _MultiAssetsPickerState extends State<MultiAssetsPicker> {
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) => () {}());
  // }

  String id;
  final db = Firestore.instance;

  bool choosedAssets = false;

  List<File> gigMediaFiles = List();

  final int maxAssetsCount = 9;

  List<AssetEntity> assets = <AssetEntity>[];

  bool isDisplayingDetail = true;

  int get assetsLength => assets.length;

  ThemeData get currentTheme => context.themeData;

  List<PickMethodModel> get pickMethods => <PickMethodModel>[
        PickMethodModel(
          icon: '📹',
          name: 'Common picker',
          description: 'Pick images and videos.',
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
        ),
      ];

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

  Widget methodItemBuilder(BuildContext _, int index) {
    final PickMethodModel model = pickMethods[index];

    // if (!choosedAssets) {
    (() async {
      final List<AssetEntity> result = await model.method(context, assets);
      if (result != null && result != assets) {
        assets = List<AssetEntity>.from(result);
        if (mounted) {
          setState(() {
            choosedAssets = !choosedAssets;
          });
        }
      }
    }());
    // } else {}
  }

  Widget get methodListView => Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          itemCount: pickMethods.length,
          itemBuilder: methodItemBuilder,
        ),
      );

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
                fontSize: 10.0,
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
            SizedBox(
              height: 50.0,
              child: GestureDetector(
                // onTap: () {
                //   if (assets.isNotEmpty) {
                //     setState(() {
                //       isDisplayingDetail = !isDisplayingDetail;
                //     });
                //   }
                // },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(
                      'Selected Assets',
                      style: TextStyle(fontSize: 20),
                    ),
                    Container(
                      height: 25.0,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                      ),
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: FyreworkrColors.fyreworkBlack),
                      child: Text(
                        '${assets.length}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          height: 1.0,
                        ),
                      ),
                    ),
                    // if (assets.isNotEmpty)
                    //   Icon(
                    //     isDisplayingDetail
                    //         ? Icons.arrow_downward
                    //         : Icons.arrow_upward,
                    //     size: 18.0,
                    //   ),
                  ],
                ),
              ),
            ),
            selectedAssetsListView,
          ],
        ),
      );

  Widget get selectedAssetsListView => Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          scrollDirection: Axis.horizontal,
          itemCount: assetsLength,
          itemBuilder: (BuildContext _, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 16.0,
              ),
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

  prepareGigMediaFilesAndPublish() {
    Future<List<File>> assignAssetsToGigMediaFiles = assigingLists();
    assignAssetsToGigMediaFiles.then((value) {
      String storageResult;
      if (gigMediaFiles != null) {
        () async {
          for (var i = 0; i < gigMediaFiles.length; i++) {
            final parsedItemUrl = getUrlType(gigMediaFiles[i].path);
            if (parsedItemUrl == UrlType.IMAGE) {
              //uploading as an image file
              storageResult = await StorageRepo().uploadMediaFile(
                mediaFileToUpload: gigMediaFiles[i],
                title: fileName.basename(gigMediaFiles[i].path + "imageFile"),
              );
            } else if (parsedItemUrl == UrlType.VIDEO) {
              //uplloading as a video file
              storageResult = await StorageRepo().uploadMediaFile(
                mediaFileToUpload: gigMediaFiles[i],
                title: fileName.basename(gigMediaFiles[i].path + "videoFile"),
              );
            } else {
              // uploading and didn't specify an extension
            }

            //adding each downloadUrl to downloadUrls list
            widget.gigMeidaFilesDownloadUrls.add(storageResult);
            print(
                "no. of urls now is: : ${widget.gigMeidaFilesDownloadUrls.length}");
          }

          print(gigMediaFiles.length);
          print(
              "The URLS from the widget variable are: ${widget.gigMeidaFilesDownloadUrls}");

          CreateGigViewModel().addGig(
            gigId: widget.gigId,
            userId: widget.receivedUserId,
            userProfilePictureDownloadUrl:
                widget.receivedUserProfilePictureDownloadUrl,
            userFullName: widget.receivedUserFullName,
            gigHashtags: widget.receivedGigHashtags,
            gigMediaFilesDownloadUrls: widget.gigMeidaFilesDownloadUrls,
            gigPost: widget.receivedGigPost,
            gigDeadLine: widget.receivedGigDeadLine,
            gigCurrency: widget.receivedGigCurrency,
            gigBudget: widget.receivedGigBudget,
            gigValue: widget.receivedGigValue,
            adultContentText: widget.receivedAdultContentText,
            adultContentBool: widget.receivedAdultContentBool,
          );
          print('new gig should be added');
          clearGigMediaFiles();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => Home(passedSelectedIndex: 0),
              ),
              (route) => false);
        }();
      }
    });
  }

  Future<List<File>> assigingLists() async {
    for (final mediaFile in assets) {
      gigMediaFiles.add(await mediaFile.originFile);
    }
  }

  clearGigMediaFiles() {
    gigMediaFiles.clear();
    print(gigMediaFiles);
    choosedAssets = false;
  }

  @override
  void dispose() {
    // Additional disposal code
    super.dispose();
  }

  Widget get gigPreview {
    return Container(
      height: MediaQuery.of(context).size.height * 0.70,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: <Widget>[
              Text('${widget.receivedGigHashtags}',
                  style: TextStyle(fontSize: 18)),
              selectedAssetsWidget,
              SizedBox(height: 10.0),
              Text('${widget.receivedGigPost}', style: TextStyle(fontSize: 18)),
              SizedBox(
                height: 10.0,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      FaIcon(
                        FontAwesomeIcons.hourglassStart,
                        size: 20,
                      ),
                      Container(
                        width: 5.0,
                        height: 0,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: AutoSizeText(
                          '${widget.receivedGigDeadLine}',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: <Widget>[
                      Container(
                        child: AutoSizeText(
                          '${widget.receivedGigCurrency}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        width: 2.5,
                        height: 0,
                      ),
                      Container(
                        child: AutoSizeText(
                          '${widget.receivedGigBudget}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              widget.receivedAdultContentBool
                  ? Container(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.solidStar,
                                size: 20,
                              ),
                              Container(
                                width: 5.0,
                                height: 0,
                              ),
                              Expanded(
                                child: AutoSizeText(
                                  "${widget.receivedAdultContentText}",
                                  style: TextStyle(
                                    fontSize: 18,
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

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: <Widget>[
              //     Text('Adult content', style: TextStyle(fontSize: 18)),
              //     Text('${widget.receivedAdultContentBool}',
              //         style: TextStyle(fontSize: 18)),
              //   ],
              // ),
              // SizedBox(
              //   height: 20.0,
              // ),

              // Center(
              //   child: Text('${widget.receivedGigValue}',
              //       style: TextStyle(fontSize: 18)),
              // ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Container(
      // child: methodListView,
      //   // gigPreview,
      //   // selectedAssetsWidget,
      // ),
      body: Stack(alignment: Alignment.center, children: <Widget>[
        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RaisedButton(
                        color: FyreworkrColors.fyreworkBlack,
                        child: Text(
                          'back',
                          style: TextStyle(color: FyreworkrColors.white),
                        ),
                        onPressed: () {
                          clearGigMediaFiles();
                          print(gigMediaFiles.length);
                        }),
                    RaisedButton(
                        color: FyreworkrColors.fyreworkBlack,
                        child: Text(
                          'PUBLISH',
                          style: TextStyle(color: FyreworkrColors.white),
                        ),
                        onPressed: () {
                          prepareGigMediaFilesAndPublish();
                        }),
                  ],
                ),
              ),
            ),
            gigPreview,
          ],
        ),
        Container(height: 0, child: methodListView),
        // Container(
        //   width: 200,
        //   height: 200,
        //   child: CircularProgressIndicator(
        //     valueColor:
        //         AlwaysStoppedAnimation<Color>(FyreworkrColors.fyreworkBlack),
        //     strokeWidth: 5,
        //   ),
        // ),
      ]),
    );
  }

  void createData() async {
    DocumentReference ref = await db.collection('Gigs').add({
      'Gig_hashtags': '${widget.receivedGigHashtags}',
      'Gig_post': '${widget.receivedGigPost}',
      // 'Gig_deadline': '${widget.receivedGigDeadLine}',
      // 'Gig_currency': '${widget.receivedGigCurrency}',
      // 'Gig_budget': '${widget.receivedGigBudget}',
      // 'Gig_adult_content_bool': '${widget.receivedAdultContentBool}',
      // 'Gig_value': '${widget.receivedGigValue}',
    });
    setState(() => id = ref.documentID);
    print(ref.documentID);
  }

  void readData() async {
    DocumentSnapshot snapshot = await db.collection('Gigs').document(id).get();
    print(snapshot.data['jobName']);
  }

  void updateData(DocumentSnapshot doc) async {
    await db
        .collection('Gigs')
        .document(doc.documentID)
        .updateData({'job description': 'new job description'});
  }

  void deleteData(DocumentSnapshot doc) async {
    await db.collection('Gigs').document(doc.documentID).delete();
    setState(() => id = null);
  }
}
