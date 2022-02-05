import 'dart:io';
import 'dart:async';
import 'package:Fyrework/screens/add_gig/addGigDetails.dart';
import 'package:Fyrework/services/bunny_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Fyrework/screens/home/home.dart';
import 'package:Fyrework/firebase_database/firestore_database.dart';
import 'package:Fyrework/viewmodels/create_gig_view_model.dart';
import '../src/wechat_assets_picker.dart';
import '../constants/picker_model.dart';

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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddGigDetails(selectedAssets: assets),
            ),
          );
        }
      }
    });
  }

  String id;
  final db = FirebaseFirestore.instance;

  List<File> gigMediaFiles = List();

  final int maxAssetsCount = 5;

  List<AssetEntity> assets = <AssetEntity>[];

  bool isDisplayingDetail = true;

  int get assetsLength => assets.length;

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
    return Container(width: 0, height: 0);
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
          color: Theme.of(context).accentColor,
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
          color: Theme.of(context).accentColor,
        ),
        child: Icon(
          Icons.close,
          color: Theme.of(context).primaryColor,
          size: 18.0,
        ),
      ),
    );
  }

  Widget get selectedAssetsWidget => AnimatedContainer(
        duration: kThemeChangeDuration,
        curve: Curves.easeInOut,
        height: assets.isNotEmpty
            ? isDisplayingDetail
                ? 250.0
                : 80.0
            : 40.0,
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

  Future<List<File>> assigingLists() async {
    for (final mediaFile in assets) {
      gigMediaFiles.add(await mediaFile.originFile);
    }
  }

  Future uploadMediaFiles() async {
    // String storageResult;
    String uploadResult;
    if (gigMediaFiles != null) {
      for (var i = 0; i < gigMediaFiles.length; i++) {
        uploadResult = await BunnyService().uploadMediaFileToBunny(
            fileToUpload: gigMediaFiles[i], storageZonePath: 'gigMediaFiles');

        //adding each downloadUrl to downloadUrls list
        widget.gigMeidaFilesDownloadUrls.add(uploadResult);
      }

      CreateGigViewModel().createGig(
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
      await FirestoreDatabase().addToPopularHashtags(widget.gigHashtags);
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
  }

  @override
  void dispose() {
    // Additional disposal code
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Scaffold(
          // body: pickAssetsCommon(),
          body: Container(),
        ),
      ),
    );
  }
}
