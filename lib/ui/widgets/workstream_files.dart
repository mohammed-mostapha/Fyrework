import 'dart:io';

import 'package:Fyrework/models/myUser.dart';
import 'package:Fyrework/viewmodels/add_comment_view_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as extractedFileName;
import 'package:http/http.dart' as http;

class WorkstreamFiles extends StatefulWidget {
  final String passedGigId;
  final String passedGigOwnerId;

  WorkstreamFiles({
    Key key,
    @required this.passedGigId,
    @required this.passedGigOwnerId,
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

  final String document = 'assets/svgs/flaticon/document.svg';
  final String image = 'assets/svgs/flaticon/image.svg';
  final String video = 'assets/svgs/flaticon/video.svg';
  final String audio = 'assets/svgs/flaticon/audio.svg';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<UploadTask> _storageUploadTasks = <UploadTask>[];

  String myUsername = MyUser.username;
  String myUserId = MyUser.uid;
  String myUserAvatarUrl = MyUser.userAvatarUrl;

  addWorkstreamFileAsComment(
      {bool persistentPrivateComment, String commentBody}) {
    AddCommentViewModel().addComment(
      gigIdHoldingComment: widget.passedGigId,
      gigOwnerId: widget.passedGigOwnerId,
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
    );
  }

  openFileExplorer() async {
    try {
      if (_multiPick) {
        FilePickerResult result =
            await FilePicker.platform.pickFiles(allowMultiple: true);

        if (result != null) {
          _multipleFilesPaths = result.paths.map((path) => File(path)).toList();
          for (var i = 0; i < _multipleFilesPaths.length; i++) {
            _fileName = extractedFileName.basename(_multipleFilesPaths[i].path);
            _filePath = File(_multipleFilesPaths[i].path);
            uploadWorkstreamFiles(_fileName, _filePath.path);
          }
        } else {
          // User canceled the picker
        }
      } else {
        ///////////////////////////////////////
        FilePickerResult result = await FilePicker.platform.pickFiles();
        if (result != null) {
          _fileName = extractedFileName.basename(result.paths.single);
          _filePath = File(result.files.single.path);
          uploadWorkstreamFiles(_fileName, _filePath.path);
        } else {
          // User canceled the picker
        }
      }
      // uploadToFirebase();
    } on PlatformException catch (e) {
      print('Unsupported Operation' + e.toString());
    }
    if (!mounted) {
      return;
    }
  }

  uploadWorkstreamFiles(String fileName, String filePath) async {
    print('coming from UploadWorkStreamFiles');
    _fileExtension = fileName.toString().split('.').last;
    Reference storageReference =
        FirebaseStorage.instance.ref().child('gigs/workstreamFiles/$fileName');
    UploadTask uploadTask = storageReference.putFile(File(filePath),
        StorageMetadata(contentType: '$_pickType/$_fileExtension'));

    TaskSnapshot uploadTaskCompleted = await uploadTask;
    String uploadTaskDownloadUrl =
        await uploadTaskCompleted.ref.getDownloadURL();

    // String workstreamFileDownloadUrl =
    // await uploadTask.lastSnapshot.ref.getDownloadURL();

    // setState(() {
    //   _storageUploadTasks.add(uploadTask);
    //     print('coming from length: ${_storageUploadTasks.length}');
    // });
    addWorkstreamFileAsComment(
        persistentPrivateComment: true, commentBody: uploadTaskDownloadUrl);
  }

  downloadWorkstreamFile(Reference ref) async {
    final String workstreamFileName = await ref.name;
    // final String workstreamFilePath = await ref.getPath();

    final String workstreamFileUrl = await ref.getDownloadURL();
    final http.Response workstreamFile = await http.get(workstreamFileUrl);
    final Directory systemTempDir = Directory.systemTemp;
    // final File tempFile = File('${systemTempDir.path}/tmp.jpg'); //adjust this
    final File tempFile = File('${systemTempDir.path}/$workstreamFileName');
    if (tempFile.existsSync()) {
      await tempFile.delete();
    }
    await tempFile.create();
    final DownloadTask writeFileTask = ref.writeToFile(tempFile);
    final int byteCount = (await writeFileTask.future).totalByteCount;
    var bodyBytes = workstreamFile.bodyBytes;

    print(
        'Success\nDownloaded $workstreamFileName\nUrl: $workstreamFileUrl\nBytes Count: $byteCount');
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Colors.white,
      content: Image.memory(
        bodyBytes,
        fit: BoxFit.fill,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> workstreamFilesList = <Widget>[];

    // _storageUploadTasks.forEach((StorageUploadTask task) {
    //   final Widget tile = UploadTaskListTile(
    //     task: task,
    //     onDismissed: () {
    //       setState(() {
    //         _storageUploadTasks.remove(task);
    //       });
    //     },
    //     onDownload: () {
    //       downloadWorkstreamFile(task.lastSnapshot.ref);
    //     },
    //   );
    //   workstreamFilesList.add(tile);
    // });

    return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          border: Border.all(width: 1, color: Theme.of(context).accentColor),
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
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'document',
                            textAlign: TextAlign.center,
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      color: Theme.of(context).accentColor,
                                    ),
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
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'image',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(color: Theme.of(context).accentColor),
                          )
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
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'video',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(color: Theme.of(context).accentColor),
                          )
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
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'audio',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(color: Theme.of(context).accentColor),
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
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(color: Theme.of(context).accentColor),
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
        ));
  }
}

class UploadTaskListTile extends StatelessWidget {
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

  UploadTaskListTile({Key key, this.task, this.onDismissed, this.onDownload})
      : super(key: key);

  final UploadTask task;
  final VoidCallback onDismissed;
  final VoidCallback onDownload;

  Future pushWorkstreamFile() async {
    print('coming from pushWorkstreamFile');
    String workstreamfileUrl = await task.lastSnapshot.ref.getDownloadURL();
    // addWorkstreamFileAsComment(
    //     persistentPrivateComment: true, commentBody: workstreamfileUrl);
  }

  String get uploadStatus {
    String result;
    if (task.isComplete) {
      if (task.isSuccessful) {
        result = 'Complete';
        //post a comment with the uploaded file
        pushWorkstreamFile();
      } else if (task.isCanceled) {
        result = 'Canceled';
      } else {
        result = 'Failed Error ${task.lastSnapshot.error}';
      }
    } else if (task.isInProgress) {
      result = 'Uploading';
    } else if (task.isPaused) {
      result = 'Paused';
    }
    return result;
  }

  String bytesTransferred(StorageTaskSnapshot snapshot) {
    return '${snapshot.bytesTransferred} / ${snapshot.bytesTransferred}';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StorageTaskEvent>(
        stream: task.events,
        builder: (BuildContext context,
            AsyncSnapshot<StorageTaskEvent> asyncSnapshot) {
          Widget subtitle;
          if (asyncSnapshot.hasData) {
            final StorageTaskEvent event = asyncSnapshot.data;
            final StorageTaskSnapshot snapshot = event.snapshot;

            subtitle =
                Text('$uploadStatus: ${bytesTransferred(snapshot)} bytes sent');
          } else {
            subtitle = const Text('Starting...');
          }
          return Dismissible(
            key: Key(task.hashCode.toString()),
            onDismissed: (_) => onDismissed(),
            child: ListTile(
              title: Text('Upload Task #${task.hashCode}'),
              subtitle: subtitle,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Offstage(
                    offstage: !task.isInProgress,
                    child: IconButton(
                      icon: const Icon(Icons.pause),
                      onPressed: () => task.pause(),
                    ),
                  ),
                  Offstage(
                    offstage: !task.isPaused,
                    child: IconButton(
                      icon: const Icon(Icons.file_upload),
                      onPressed: () => task.resume(),
                    ),
                  ),
                  Offstage(
                    offstage: task.isComplete,
                    child: IconButton(
                      icon: const Icon(Icons.cancel),
                      onPressed: () => task.cancel(),
                    ),
                  ),
                  Offstage(
                    offstage: !(task.isComplete && task.isSuccessful),
                    child: IconButton(
                      icon: const Icon(Icons.file_download),
                      onPressed: () => onDownload(),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
