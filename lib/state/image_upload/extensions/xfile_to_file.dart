import 'dart:io';

import 'package:image_picker/image_picker.dart';

extension ToFile on Future<XFile?> {
  Future<File?> toFile() => then((xfile) => xfile?.path)
      .then((path) => path != null ? File(path) : null);
}
