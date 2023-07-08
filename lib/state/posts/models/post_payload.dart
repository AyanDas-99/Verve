import 'dart:collection' show MapView;
import 'package:flutter/foundation.dart' show immutable;
import 'package:verve/state/auth/constants/firebase_field_names.dart';
import 'package:verve/state/enums/file_type.dart';
import 'package:verve/state/user_info/typedefs/user_id.dart';

@immutable
class PostPayload extends MapView<String, dynamic> {
  PostPayload({
    required UserId postedBy,
    required String title,
    required String message,
    required bool allowComments,
    required FileType fileType,
    required String originalFileUrl,
    required String originalFileStorageId,
    required String thumbnailUrl,
    required String thumbnailStorageId,
    required double aspectRatio,
  }) : super({
          FirebaseFieldNames.userId: postedBy,
          FirebaseFieldNames.title: title,
          FirebaseFieldNames.message: message,
          FirebaseFieldNames.allowComments: allowComments,
          FirebaseFieldNames.fileType: fileType.name,
          FirebaseFieldNames.originalFileUrl: originalFileUrl,
          FirebaseFieldNames.originalFileStorageId: originalFileStorageId,
          FirebaseFieldNames.thumbnailUrl: thumbnailUrl,
          FirebaseFieldNames.thumbnailStorageId: thumbnailStorageId,
          FirebaseFieldNames.aspectRatio: aspectRatio,
        });
}
