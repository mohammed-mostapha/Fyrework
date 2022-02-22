import 'dart:io';

import 'package:Fyrework/firebase_database/firestore_database.dart';
import 'package:Fyrework/models/comment.dart';
import 'package:Fyrework/models/myUser.dart';
import 'package:Fyrework/screens/add_gig/assets_picker/constants/picker_model.dart';
import 'package:Fyrework/screens/add_gig/assets_picker/src/widget/asset_picker.dart';
import 'package:Fyrework/services/bunny_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path/path.dart' as extractedFileName;
import 'package:photo_manager/photo_manager.dart';

class WorkstreamFiles extends StatefulWidget {
  final String passedGigId;
  final String passedGigOwnerId;
  final String passedGigOwnerUsername;
  List<String> multipleWorkStreamFiles;

  WorkstreamFiles({
    Key key,
    @required this.passedGigId,
    @required this.passedGigOwnerId,
    @required this.passedGigOwnerUsername,
  });

  @override
  _WorkstreamFilesState createState() => _WorkstreamFilesState();
}

class _WorkstreamFilesState extends State<WorkstreamFiles> {
  @override
  void initState() {
    super.initState();
  }

  RequestType _pickType;
  bool _multiPick = false;
  List<AssetEntity> selectedWorkStreamFilesList;
  File assetEntityToFile;
  final int maxAssetsCount = 5;

  final String document = 'assets/svgs/flaticon/document.svg';
  final String image = 'assets/svgs/flaticon/image.svg';
  final String video = 'assets/svgs/flaticon/video.svg';
  final String audio = 'assets/svgs/flaticon/audio.svg';
  List urlsForFirestoreDB = [];
  String myUsername = MyUser.username;
  String myUserId = MyUser.uid;
  String myUserAvatarUrl = MyUser.userAvatarUrl;

  addWorkstreamFileAsComment(
      {bool persistentPrivateComment, dynamic commentBody}) {
    FirestoreDatabase().addComment(
        Comment(
          gigIdHoldingComment: widget.passedGigId,
          gigOwnerId: widget.passedGigOwnerId,
          gigOwnerUsername: widget.passedGigOwnerUsername,
          commentOwnerUsername: myUsername,
          commentBody: commentBody,
          commentOwnerId: myUserId,
          commentOwnerAvatarUrl: myUserAvatarUrl,
          commentId: '',
          isPrivateComment: false,
          proposal: false,
          approved: false,
          rejected: false,
          gigCurrency: null,
          offeredBudget: null,
          containMediaFile: true,
          isGigCompleted: false,
        ),
        widget.passedGigId);
    urlsForFirestoreDB = [];
  }

  List<PickMethodModel> get pickMethods => <PickMethodModel>[
        PickMethodModel(
          method: (
            BuildContext context,
            List<AssetEntity> assets,
          ) async {
            return await AssetPicker.pickAssets(
              context,
              maxAssets: maxAssetsCount,
              selectedAssets: assets,
              requestType: _pickType,
            );
          },
        ),
      ];

  openFileExplorer() async {
    try {
      await navigateToSelectWorkstreamFiles(isMultiPick: _multiPick);
    } on PlatformException catch (e) {
      print(
        'Unsupported Operation' + e.toString(),
      );
    }
    if (!mounted) {
      return;
    }
  }

  navigateToSelectWorkstreamFiles({bool isMultiPick}) async {
    (BuildContext context, int index) async {
      final PickMethodModel model = pickMethods[index];

      final List<AssetEntity> retrievedAssets =
          await model.method(context, selectedWorkStreamFilesList);

      if (retrievedAssets != null &&
          retrievedAssets != selectedWorkStreamFilesList) {
        selectedWorkStreamFilesList = retrievedAssets;

        await uploadWorkstreamFiles(
          storageZonePath: 'workstreamFiles',
          multipleFiles: isMultiPick ? true : false,
        );

        selectedWorkStreamFilesList = null;
      }
    }(context, 0);
    setState(() {
      _multiPick = false;
    });
  }

  Future<dynamic> uploadWorkstreamFiles({
    String fileName,
    File filePath,
    String storageZonePath,
    bool multipleFiles,
  }) async {
    String uploadResult;
    File fileToUPload;

    if (multipleFiles) {
      for (var i = 0; i < selectedWorkStreamFilesList.length; i++) {
        assetEntityToFile = await selectedWorkStreamFilesList[i].file;
        fileName = extractedFileName.basename(assetEntityToFile.path);
        filePath = File(assetEntityToFile.path);
        fileToUPload = filePath;
        ////////////
        uploadResult = await BunnyService().uploadMediaFileToBunny(
          fileToUpload: fileToUPload,
          storageZonePath: storageZonePath,
        );

        urlsForFirestoreDB.add(uploadResult);
      }
      return addWorkstreamFileAsComment(
        persistentPrivateComment: true,
        commentBody: urlsForFirestoreDB,
      );
      ////////////////////////////
      ///////////////////////////
    } else {
      assetEntityToFile = await selectedWorkStreamFilesList.first.file;
      fileName = extractedFileName.basename(assetEntityToFile.path);
      filePath = File(assetEntityToFile.path);
      fileToUPload = filePath;

      uploadResult = await BunnyService().uploadMediaFileToBunny(
        fileToUpload: fileToUPload,
        storageZonePath: storageZonePath,
      );
      urlsForFirestoreDB.add(uploadResult);

      return addWorkstreamFileAsComment(
        persistentPrivateComment: true,
        commentBody: urlsForFirestoreDB,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceEvenly,
              spacing: 40,
              runAlignment: WrapAlignment.center,
              children: [
                GestureDetector(
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: SvgPicture.asset(
                            image,
                            semanticsLabel: 'image',
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text('image',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyText1)
                      ],
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _pickType = RequestType.image;
                    });
                    openFileExplorer();
                  },
                ),
                GestureDetector(
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: SvgPicture.asset(
                            video,
                            semanticsLabel: 'video',
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text('video',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyText1)
                      ],
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _pickType = RequestType.video;
                    });
                    openFileExplorer();
                  },
                ),
              ],
            ),
            Container(
              width: 200,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: SwitchListTile.adaptive(
                      title: Text(
                        'Multiple Files',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      onChanged: (bool value) {
                        setState(() {
                          _multiPick = value;
                        });
                      },
                      value: _multiPick,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            // Container(
            //   color: Colors.white,
            //   width: double.infinity,
            //   height: 300,
            //   child: ListView(
            //     children: workstreamFilesList,
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}