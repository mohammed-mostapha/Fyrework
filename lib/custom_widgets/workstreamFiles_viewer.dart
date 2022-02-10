import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';

class WorkstreamFilesViewer extends StatefulWidget {
  WorkstreamFilesViewer({
    Key key,
    @required this.workstreamFilesUrls,
    @required this.initialPage,
  }) : super(key: key);

  final List<dynamic> workstreamFilesUrls;
  final int initialPage;

  @override
  _WorkstreamFilesViewerState createState() => _WorkstreamFilesViewerState();
}

class _WorkstreamFilesViewerState extends State<WorkstreamFilesViewer> {
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PhotoViewGallery.builder(
      scrollDirection: Axis.vertical,
      pageController: _pageController,
      itemCount: widget.workstreamFilesUrls.length,
      builder: (BuildContext, int index) {
        return PhotoViewGalleryPageOptions(
          imageProvider: CachedNetworkImageProvider(
            widget.workstreamFilesUrls.elementAt(index),
          ),
        );
      },
    );
  }
}
