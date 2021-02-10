import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:myApp/ui/shared/fyreworkTheme.dart';
import 'package:better_player/better_player.dart';

class GigItemMediaPreviewer extends StatefulWidget {
  final List<dynamic> receivedGigMediaFilesUrls;

  GigItemMediaPreviewer({Key key, @required this.receivedGigMediaFilesUrls})
      : super(key: key);

  @override
  _GigItemMediaPreviewerState createState() =>
      _GigItemMediaPreviewerState(receivedGigMediaFilesUrls);
}

class _GigItemMediaPreviewerState extends State<GigItemMediaPreviewer> {
  List<dynamic> receivedGigMediaFilesUrls;
  _GigItemMediaPreviewerState(this.receivedGigMediaFilesUrls);
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
            height: MediaQuery.of(context).size.height / 2,
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
                  child: BetterPlayer.network(url),
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
