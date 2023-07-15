import 'dart:io';

import 'package:flutter/foundation.dart' show immutable;
import 'package:image_picker/image_picker.dart';
import 'package:verve/state/image_upload/extensions/xfile_to_file.dart';

@immutable
class ImagePickerHelper {
  Future<File?> getImageFromGallery() async {
    final file =
        await ImagePicker().pickImage(source: ImageSource.gallery).toFile();
    return file;
  }

  Future<File?> getVideoFromGallery() async {
    final file =
        await ImagePicker().pickVideo(source: ImageSource.gallery).toFile();
    return file;
  }
}
