import 'dart:io';

import 'package:Fyrework/models/myUser.dart';
import 'package:Fyrework/screens/add_gig/assets_picker/constants/picker_model.dart';
import 'package:Fyrework/screens/add_gig/assets_picker/src/widget/asset_picker.dart';
import 'package:Fyrework/services/bunny_service.dart';
import 'package:Fyrework/viewmodels/add_comment_view_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as extractedFileName;
import 'package:http/http.dart' as http;
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

  String _fileName;
  File _filePath;
  List<File> _multipleFilesPaths;
  String _fileExtension;
  List<String> _multipleFilesExtensions;
  FileType _pickType;
  bool _multiPick = false;
  List<AssetEntity> selectedWorkStreamFilesList;
  File assetEntityToFile;
  final int maxAssetsCount = 5;

  final String document = 'assets/svgs/flaticon/document.svg';
  final String image = 'assets/svgs/flaticon/image.svg';
  final String video = 'assets/svgs/flaticon/video.svg';
  final String audio = 'assets/svgs/flaticon/audio.svg';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<UploadTask> _storageUploadTasks = <UploadTask>[];
  List urlsForFirestoreDB = [];

  String myUsername = MyUser.username;
  String myUserId = MyUser.uid;
  String myUserAvatarUrl = MyUser.userAvatarUrl;

  addWorkstreamFileAsComment(
      {bool persistentPrivateComment, dynamic commentBody}) {
    AddCommentViewModel().addComment(
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
    );
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
              requestType: RequestType.image,
            );
          },
        ),
      ];

  openFileExplorer() async {
    try {
      await navigateToSelectWorkstreamFiles(isMultiPick: _multiPick);
    } on PlatformException catch (e) {
      print('Unsupported Operation' + e.toString());
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
    String filePath,
    String storageZonePath,
    bool multipleFiles,
  }) async {
    String uploadResult;
    File fileToUPload;

    if (multipleFiles) {
      for (var i = 0; i < selectedWorkStreamFilesList.length; i++) {
        assetEntityToFile = await selectedWorkStreamFilesList[i].file;
        _fileName = extractedFileName.basename(assetEntityToFile.path);
        _filePath = File(assetEntityToFile.path);
        fileToUPload = _filePath;
        ////////////
        uploadResult = await BunnyService().uploadFileToBunny(
          fileToUpload: fileToUPload,
          storageZonePath: storageZonePath,
        );

        urlsForFirestoreDB.add(uploadResult);
      }

      // uploadResult = await BunnyService().uploadFileToBunny(
      //   fileToUpload: fileToUPload,
      //   storageZonePath: storageZonePath,
      // );

      return addWorkstreamFileAsComment(
        persistentPrivateComment: true,
        commentBody: urlsForFirestoreDB,
      );
      ////////////////////////////
      ///////////////////////////
    } else {
      assetEntityToFile = await selectedWorkStreamFilesList.first.file;
      _fileName = extractedFileName.basename(assetEntityToFile.path);
      _filePath = File(assetEntityToFile.path);
      fileToUPload = _filePath;

      uploadResult = await BunnyService().uploadFileToBunny(
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).inputDecorationTheme.fillColor,
            border: Border.all(width: 1, color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(10),
              topRight: const Radius.circular(10),
            ),
          ),
          width: double.infinity,
          // height: 100,
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
                                document,
                                semanticsLabel: 'document',
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'document',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyText1,
                            )
                          ],
                        ),
                      ),
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
                          _pickType = FileType.image;
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
                          _pickType = FileType.video;
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
                                audio,
                                semanticsLabel: 'audio',
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'audio',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyText1,
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _pickType = FileType.audio;
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
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

// class UploadTaskListTile extends StatelessWidget {
// addWorkstreamFileAsComment(
//     {bool persistentPrivateComment, String commentBody}) {
//   AddCommentViewModel().addComment(
//     gigIdHoldingComment: WorkstreamFiles.passedGigId,
//     gigOwnerId: WorkstreamFiles.passedGigOwnerId,
//     commentOwnerUsername: myUsername,
//     commentBody: commentBody,
//     commentOwnerId: myUserId,
//     commentOwnerAvatarUrl: myUserProfilePictureUrl,
//     commentId: '',
//     commentTime: new DateTime.now(),
//     isPrivateComment: false,
//     persistentPrivateComment: persistentPrivateComment,
//     proposal: false,
//     approved: false,
//     rejected: false,
//     gigCurrency: null,
//     offeredBudget: null,
//   );
// }

//   UploadTaskListTile({Key key, this.task, this.onDismissed, this.onDownload})
//       : super(key: key);

//   final UploadTask task;
//   final VoidCallback onDismissed;
//   final VoidCallback onDownload;

//   Future pushWorkstreamFile() async {
//     print('coming from pushWorkstreamFile');
//     String workstreamfileUrl = await task.snapshot.ref.getDownloadURL();
//     // addWorkstreamFileAsComment(
//     //     persistentPrivateComment: true, commentBody: workstreamfileUrl);
//   }

//   String get uploadStatus {
//     String result;
//     if (task.isComplete) {
//       if (task.isSuccessful) {
//         result = 'Complete';
//         //post a comment with the uploaded file
//         pushWorkstreamFile();
//       } else if (task.isCanceled) {
//         result = 'Canceled';
//       } else {
//         result = 'Failed Error ${task.lastSnapshot.error}';
//       }
//     } else if (task.isInProgress) {
//       result = 'Uploading';
//     } else if (task.isPaused) {
//       result = 'Paused';
//     }
//     return result;
//   }

//   String bytesTransferred(TaskSnapshot snapshot) {
//     return '${snapshot.bytesTransferred} / ${snapshot.bytesTransferred}';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<StorageTaskEvent>(
//         stream: task.events,
//         builder: (BuildContext context,
//             AsyncSnapshot<StorageTaskEvent> asyncSnapshot) {
//           Widget subtitle;
//           if (asyncSnapshot.hasData) {
//             final StorageTaskEvent event = asyncSnapshot.data;
//             final TaskSnapshot snapshot = event.snapshot;

//             subtitle =
//                 Text('$uploadStatus: ${bytesTransferred(snapshot)} bytes sent');
//           } else {
//             subtitle = const Text('Starting...');
//           }
//           return Dismissible(
//             key: Key(task.hashCode.toString()),
//             onDismissed: (_) => onDismissed(),
//             child: ListTile(
//               title: Text('Upload Task #${task.hashCode}'),
//               subtitle: subtitle,
//               trailing: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   Offstage(
//                     offstage: !task.isInProgress,
//                     child: IconButton(
//                       icon: const Icon(Icons.pause),
//                       onPressed: () => task.pause(),
//                     ),
//                   ),
//                   Offstage(
//                     offstage: !task.isPaused,
//                     child: IconButton(
//                       icon: const Icon(Icons.file_upload),
//                       onPressed: () => task.resume(),
//                     ),
//                   ),
//                   Offstage(
//                     offstage: task.isComplete,
//                     child: IconButton(
//                       icon: const Icon(Icons.cancel),
//                       onPressed: () => task.cancel(),
//                     ),
//                   ),
//                   Offstage(
//                     offstage: !(task.isComplete && task.isSuccessful),
//                     child: IconButton(
//                       icon: const Icon(Icons.file_download),
//                       onPressed: () => onDownload(),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }
// }
