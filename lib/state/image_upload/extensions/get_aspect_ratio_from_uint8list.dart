import 'dart:typed_data';
import 'package:flutter/material.dart' show Image;
import 'package:verve/state/image_upload/extensions/get_aspect_ratio.dart';

extension GetAspectRatio on Uint8List {
  Future<double> getAspectRatio() async {
    final image = Image.memory(this);
    return await image.getImageAspectRatio();
  }
}
