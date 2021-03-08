import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as extractedFileName;

class WorkstreamFiles extends StatefulWidget {
  @override
  _WorkstreamFilesState createState() => _WorkstreamFilesState();
}

class _WorkstreamFilesState extends State<WorkstreamFiles> {
  final String document = 'assets/svgs/flaticon/document.svg';
  final String image = 'assets/svgs/flaticon/image.svg';
  final String video = 'assets/svgs/flaticon/video.svg';
  final String audio = 'assets/svgs/flaticon/audio.svg';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _filename;
  File _filePath;
  List<File> _multipleFilesPaths;
  String _fileExtension;
  List<String> _multipleFilesExtensions;
  FileType _pickType;
  bool _multiPick = false;

  List<StorageUploadTask> _storageUploadTasks = <StorageUploadTask>[];

  @override
  void initState() {
    super.initState();
  }

  openFileExplorer() async {
    try {
      //multiple files pick
      if (_multiPick) {
        FilePickerResult result =
            await FilePicker.platform.pickFiles(allowMultiple: true);

        if (result != null) {
          _multipleFilesPaths = result.paths.map((path) => File(path)).toList();
        } else {
          // User canceled the picker
        }
      } else {
        ///////////////////////////////////////

        //single file pick
        FilePickerResult result = await FilePicker.platform.pickFiles();
        if (result != null) {
          // _filename = result.paths.single;
          _filename = extractedFileName.basename(result.paths.single);
          _filePath = File(result.files.single.path);
          uploadWorkstreamFiles(_filename, _filePath.path);
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

  uploadWorkstreamFiles(String fileName, String filePath) {
    _fileExtension = fileName.toString().split('.').last;
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('gigs/workstreamFiles/$fileName');
    final StorageUploadTask uploadTask = storageReference.putFile(
        File(filePath),
        StorageMetadata(contentType: '$_pickType/$_fileExtension'));
    setState(() {
      _storageUploadTasks.add(uploadTask);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
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
              )
            ],
          ),
        ));
  }
}
