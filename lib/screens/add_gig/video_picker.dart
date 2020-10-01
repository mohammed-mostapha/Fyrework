import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class Video_picker extends StatefulWidget {
  @override
  _Video_pickerState createState() => _Video_pickerState();
}

class _Video_pickerState extends State<Video_picker> {
  PickedFile videoFile;

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _videoRecord());
  }

  _videoRecord() async {
    PickedFile theVid =
        await ImagePicker().getVideo(source: ImageSource.camera);

    if (theVid != null) {
      setState(() {
        videoFile = theVid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ChewieVideoPlayer extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;

  ChewieVideoPlayer({
    @required this.videoPlayerController,
    this.looping,
    Key key,
  }) : super(key: key);

  @override
  _ChewieVideoPlayerState createState() => _ChewieVideoPlayerState();
}

class _ChewieVideoPlayerState extends State<ChewieVideoPlayer> {
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();

    _chewieController = ChewieController(
        videoPlayerController: widget.videoPlayerController,
        aspectRatio: 16 / 9,
        //prepare the video to be played and display the first frame of it
        autoInitialize: true,
        looping: widget.looping,

        // errors that may occur
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: TextStyle(color: Colors.white),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    //very important to dipose of all the used resources
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
  }
}
