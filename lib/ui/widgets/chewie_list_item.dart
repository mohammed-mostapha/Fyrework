import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class ChewieListItem extends StatefulWidget {
  VideoPlayerController videoPlayerController;
  final bool looping;

  ChewieListItem({
    @required this.videoPlayerController,
    this.looping,
    Key key,
  }) : super(key: key);

  @override
  _ChewieListItemState createState() => _ChewieListItemState();
}

class _ChewieListItemState extends State<ChewieListItem> {
  ChewieController _chewieController;

  void _initController(String link) {
    widget.videoPlayerController = VideoPlayerController.network(link)
      ..initialize();
  }

  @override
  void initState() {
    super.initState();

    _initController(widget.videoPlayerController.dataSource);

    _chewieController = ChewieController(
        videoPlayerController: widget.videoPlayerController,
        // aspectRatio: 1 / 1,
        aspectRatio: widget.videoPlayerController.value.aspectRatio,
        autoInitialize: true,
        looping: widget.looping,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              // errorMessage,
              "we can't play video at the moment",
              style: TextStyle(color: Colors.white),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.fill,
            child: SizedBox(
              width: widget.videoPlayerController.value.size?.width,
              height: widget.videoPlayerController.value.size?.height,
              child: Chewie(
                controller: _chewieController,
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.videoPlayerController.pause();
    // widget.videoPlayerController.dispose();
    _chewieController.pause();
    _chewieController.dispose();
    print('video player disposed');
  }
}
