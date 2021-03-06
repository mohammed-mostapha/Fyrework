import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:file_picker/file_picker.dart';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        child: Wrap(
          alignment: WrapAlignment.spaceEvenly,
          spacing: 10,
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
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
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
            ),
          ],
        ));
  }
}
