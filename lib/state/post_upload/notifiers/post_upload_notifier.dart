import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart' as img;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:verve/state/auth/constants/firebase_collection_names.dart';
import 'package:verve/state/enums/file_type.dart';
import 'package:verve/state/image_upload/extensions/get_aspect_ratio_from_uint8list.dart';
import 'package:verve/state/post_upload/constants/contants.dart';
import 'package:verve/state/post_upload/exceptions/could_not_generate_thumbnail.dart';
import 'package:verve/state/posts/models/post_payload.dart';
import 'package:verve/state/typedefs/is_loading.dart';
import 'package:verve/state/user_info/typedefs/user_id.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class PostUploadNotifier extends StateNotifier<IsLoading> {
  PostUploadNotifier() : super(false);

  set isLoading(bool value) => state = value;

  Future<bool> upload({
    required UserId postedBy,
    required String title,
    required String message,
    required bool allowComments,
    required FileType fileType,
    required File file,
  }) async {
    isLoading = true;

    try {
      late Uint8List? thumbnailData;

      // check if image or video
      // Get thumbnail
      switch (fileType) {
        case FileType.image:
          final image = img.decodeImage(file.readAsBytesSync());
          if (image == null) {
            isLoading = false;
            throw couldNotGenerateThumbnailException;
          }
          final thumbnail =
              img.copyResize(image, width: Constants.imageThumbnailWidth);
          thumbnailData = thumbnail.toUint8List();
          break;
        case FileType.video:
          thumbnailData = await VideoThumbnail.thumbnailData(
            video: file.path,
            imageFormat: ImageFormat.JPEG,
            maxHeight: Constants.videoThumbnailMaxHeight,
            quality: Constants.videoThumbnailQuality,
          );
          if (thumbnailData == null) {
            isLoading = false;
            throw couldNotGenerateThumbnailException;
          }
          break;
      }

      // get aspect ratio
      final aspectRatio = await thumbnailData.getAspectRatio();

      // Upload both thumbnail and file
      final fileName = const Uuid().v4();

      final thumbnailRef = FirebaseStorage.instance
          .ref()
          .child(postedBy)
          .child(FirebaseCollectionNames.thumbnails)
          .child(fileName);

      final originalFileRef = FirebaseStorage.instance
          .ref()
          .child(postedBy)
          .child(FirebaseCollectionNames.thumbnails)
          .child(fileName);

      final thumbnailUploadTask = await thumbnailRef.putData(thumbnailData);
      final originalFileUploadTask =
          await originalFileRef.putData(file.readAsBytesSync());

      // get storageId and url of both thumbnail and file
      final thumbnailStorageId = thumbnailUploadTask.ref.name;
      final thumbnailUrl = await thumbnailUploadTask.ref.getDownloadURL();

      final originalFileStorageId = originalFileUploadTask.ref.name;
      final originalFileUrl = await originalFileUploadTask.ref.getDownloadURL();

      // get payload and upload post
      final postPayload = PostPayload(
        postedBy: postedBy,
        title: title,
        message: message,
        allowComments: allowComments,
        fileType: fileType,
        originalFileUrl: originalFileUrl,
        originalFileStorageId: originalFileStorageId,
        thumbnailUrl: thumbnailUrl,
        thumbnailStorageId: thumbnailStorageId,
        aspectRatio: aspectRatio,
      );

      await FirebaseFirestore.instance
          .collection(FirebaseCollectionNames.posts)
          .add(postPayload);

      isLoading = false;
      return true;
    } catch (e) {
      return false;
    }
  }
}
