import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerView extends StatefulWidget {
  final String? videoUrl;
  final bool fromNetwork;
  final File? videoFile;
  const VideoPlayerView(this.fromNetwork,
      {super.key, this.videoFile, this.videoUrl});

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late VideoPlayerController videoPlayerController;

  late ChewieController chewieController;

  @override
  void initState() {
    super.initState();

    if (widget.fromNetwork) {
      videoPlayerController =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl ?? ''));
    } else {
      videoPlayerController = VideoPlayerController.file(
          widget.videoFile ?? File(widget.videoFile!.path));
    }

    videoPlayerController.initialize().then((value) {
      setState(() {
        chewieController = ChewieController(
            videoPlayerController: videoPlayerController,
            aspectRatio: videoPlayerController.value.aspectRatio);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (videoPlayerController.value.isInitialized) {
      return AspectRatio(
          aspectRatio: videoPlayerController.value.aspectRatio,
          child: Chewie(controller: chewieController));
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}
