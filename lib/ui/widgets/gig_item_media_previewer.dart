import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:myApp/ui/shared/theme.dart';
import 'package:myApp/ui/widgets/chewie_player.dart';
import 'package:video_player/video_player.dart';

class GitItemMediaPreviewer extends StatefulWidget {
  final List<dynamic> receivedGigMediaFilesUrls;

  GitItemMediaPreviewer({Key key, @required this.receivedGigMediaFilesUrls})
      : super(key: key);

  @override
  _GitItemMediaPreviewerState createState() =>
      _GitItemMediaPreviewerState(receivedGigMediaFilesUrls);
}

class _GitItemMediaPreviewerState extends State<GitItemMediaPreviewer> {
  List<dynamic> receivedGigMediaFilesUrls;
  _GitItemMediaPreviewerState(this.receivedGigMediaFilesUrls);
  int _current = 0;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CarouselSlider(
            height: 200.0,
            initialPage: 0,
            enableInfiniteScroll:
                receivedGigMediaFilesUrls.length > 1 ? true : false,
            onPageChanged: (index) {
              setState(() {
                _current = index;
              });
            },
            items: receivedGigMediaFilesUrls.map((url) {
              //condition to specify whether its an image or a video to show
              if (url.contains("imageFile")) {
                return Container(
                  width: double.infinity,
                  child: Image.network(
                    url,
                    fit: BoxFit.fill,
                  ),
                );
              } else if (url.contains("videoFile")) {
                return Container(
                  child: ChewiePlayer(
                    videoPlayerController: VideoPlayerController.network(url),
                    looping: false,
                  ),
                );
              } else {
                //
              }
              //end codition
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    color: FyreworkrColors.fyreworkBlack,
                    child: Image.asset(
                      url,
                      fit: BoxFit.fill,
                    ),
                  );
                },
              );
            }).toList(),
          ),
          SizedBox(height: 10),
          receivedGigMediaFilesUrls.length > 1
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                      map<Widget>(receivedGigMediaFilesUrls, (index, url) {
                    return Container(
                      width: 5.0,
                      height: 5.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _current == index
                            ? FyreworkrColors.fyreworkBlack
                            : FyreworkrColors.fyreworkGrey,
                      ),
                    );
                  }),
                )
              : Container(
                  width: 0.0,
                  height: 0.0,
                ),
        ],
      ),
    );
  }
}
