import 'package:Fyrework/ui/widgets/workstreamFiles_viewer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:video_player/video_player.dart';
import 'package:Fyrework/ui/widgets/chewie_list_item.dart';

class GigItemMediaPreviewer extends StatefulWidget {
  final List<dynamic> receivedGigMediaFilesUrls;
  final double preferredHeight;

  GigItemMediaPreviewer(
      {Key key, @required this.receivedGigMediaFilesUrls, this.preferredHeight})
      : super(key: key);

  @override
  _GigItemMediaPreviewerState createState() =>
      _GigItemMediaPreviewerState(receivedGigMediaFilesUrls, preferredHeight);
}

class _GigItemMediaPreviewerState extends State<GigItemMediaPreviewer> {
  @override
  void initState() {
    super.initState();
  }

  TabController gigMediaFilesController;
  List<dynamic> receivedGigMediaFilesUrls;
  double preferredHeight;
  _GigItemMediaPreviewerState(
    this.receivedGigMediaFilesUrls,
    this.preferredHeight,
  );
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
            options: CarouselOptions(
              height: preferredHeight != null
                  ? preferredHeight
                  : MediaQuery.of(context).size.height / 2,
              viewportFraction: 1,
              initialPage: 0,
              enableInfiniteScroll:
                  receivedGigMediaFilesUrls.length > 1 ? true : false,
              onPageChanged: (index, carouselPageChangedReason) {
                setState(() {
                  _current = index;
                });
              },
            ),
            items: receivedGigMediaFilesUrls.map((url) {
              //condition to specify whether its an image or a video to show
              if (url.contains("jpeg") ||
                  url.contains("jpg") ||
                  url.contains("PNG")) {
                return Container(
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    // child: Image.network(
                    //   url,
                    //   fit: BoxFit.cover,
                    // ),
                    child: InkResponse(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return WorkstreamFilesViewer(
                                initialPage: 0,
                                workstreamFilesUrls: receivedGigMediaFilesUrls,
                              );
                            },
                          ),
                        );
                      },
                      child: CachedNetworkImage(
                        imageUrl: url,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor,
                            ),
                            strokeWidth: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              } else if (url.contains("mp4") ||
                  url.contains("m4v") ||
                  url.contains("mov") ||
                  url.contains("avi")) {
                return Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: ChewieListItem(
                      videoPlayerController: VideoPlayerController.network(url),
                    ),
                  ),
                );
              } else {
                //
              }
            }).toList(),
          ),
          receivedGigMediaFilesUrls.length > 1
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                      map<Widget>(receivedGigMediaFilesUrls, (index, url) {
                    return Container(
                      width: 5.0,
                      height: 5.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == index
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).hintColor),
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
