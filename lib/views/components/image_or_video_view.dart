import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:verve/state/enums/file_type.dart';
import 'package:verve/state/image_upload/extensions/get_aspect_ratio.dart';
import 'package:verve/views/components/video_player_view.dart';

class ImageOrVideoView extends HookWidget {
  final File? file;
  final FileType? fileType;
  const ImageOrVideoView(this.file, this.fileType, {super.key});

  @override
  Widget build(BuildContext context) {
    late double? aspectRatio = null;
    final isReady = useState(false);

    useEffect(() {
      if (fileType == FileType.image && file != null) {
        if (aspectRatio == null) {
          if (kIsWeb) {
            Image.network(file!.path)
                .getImageAspectRatio()
                .then((value) => aspectRatio = value);
          } else {
            Image.file(file!)
                .getImageAspectRatio()
                .then((value) => aspectRatio = value);
          }
          isReady.value = true;
        } else {
          isReady.value = true;
        }
      } else if (fileType == FileType.video && file != null) {
        isReady.value = true;
      }
      return () {};
    }, [file, fileType, aspectRatio]);

    if (isReady.value) {
      switch (fileType) {
        case FileType.video:
          return VideoPlayerView(
            false,
            videoFile: file,
          );
        case FileType.image:
          return AspectRatio(
            aspectRatio: aspectRatio ?? 16 / 9,
            child: (kIsWeb) ? Image.network(file!.path) : Image.file(file!),
          );
        default:
          return Container();
      }
    } else {
      return Container();
    }
  }
}
