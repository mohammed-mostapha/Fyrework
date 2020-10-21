import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class ChewiePlayer extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;

  ChewiePlayer({@required this.videoPlayerController, this.looping, Key key})
      : super(key: key);

  @override
  _ChewiePlayerState createState() => _ChewiePlayerState();
}

class _ChewiePlayerState extends State<ChewiePlayer> {
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();

    _chewieController = ChewieController(
        videoPlayerController: widget.videoPlayerController,
        aspectRatio: 16 / 9,
        autoInitialize: true,
        looping: widget.looping,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: AutoSizeText(
              errorMessage,
              style: TextStyle(color: Colors.white),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller: _chewieController,
    );
  }

  // @override
  void dispose() {
    //Important to dispose all of the used resources
    // widget.videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }
}
