import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:verve/state/auth/constants/firebase_field_names.dart';
import 'package:verve/state/enums/file_type.dart';
import 'package:verve/state/posts/typedefs/post_id.dart';
import 'package:verve/state/user_info/typedefs/user_id.dart';

@immutable
class Post {
  final PostId postId;
  final UserId postedBy;
  final String title;
  final String message;
  final bool allowComments;
  final FileType fileType;
  final String originalFileUrl;
  final String originalFileStorageId;
  final String thumbnailUrl;
  final String thumbnailStorageId;
  final double aspectRatio;
  final DateTime createdAt;
  final String tag;
  const Post({
    required this.postId,
    required this.postedBy,
    required this.title,
    required this.message,
    required this.allowComments,
    required this.fileType,
    required this.originalFileUrl,
    required this.originalFileStorageId,
    required this.thumbnailUrl,
    required this.thumbnailStorageId,
    required this.aspectRatio,
    required this.createdAt,
    required this.tag,
  });

  Post.fromJson(Map<String, dynamic> json)
      : this(
          postId: json[FirebaseFieldNames.postId],
          postedBy: json[FirebaseFieldNames.userId],
          title: json[FirebaseFieldNames.title],
          message: json[FirebaseFieldNames.message],
          allowComments: json[FirebaseFieldNames.allowComments],
          fileType: FileType.values.firstWhere(
            (fileType) => fileType.name == json[FirebaseFieldNames.fileType],
            orElse: () => FileType.image,
          ),
          originalFileUrl: json[FirebaseFieldNames.originalFileUrl],
          originalFileStorageId: json[FirebaseFieldNames.originalFileStorageId],
          thumbnailUrl: json[FirebaseFieldNames.thumbnailUrl],
          thumbnailStorageId: json[FirebaseFieldNames.thumbnailStorageId],
          aspectRatio: json[FirebaseFieldNames.aspectRatio],
          createdAt: (json[FirebaseFieldNames.createdAt] as Timestamp).toDate(),
          tag: json[FirebaseFieldNames.tag],
        );

  @override
  operator ==(covariant Post other) =>
      postId == other.postId &&
      postedBy == other.postedBy &&
      title == other.title &&
      message == other.message &&
      allowComments == other.allowComments &&
      fileType == other.fileType &&
      originalFileUrl == other.originalFileUrl &&
      originalFileStorageId == other.originalFileStorageId &&
      thumbnailUrl == other.thumbnailUrl &&
      thumbnailStorageId == other.thumbnailStorageId &&
      aspectRatio == other.aspectRatio &&
      createdAt == other.createdAt &&
      tag == other.tag;

  @override
  // TODO: implement hashCode
  int get hashCode => Object.hashAll([
        postId,
        postedBy,
        title,
        message,
        allowComments,
        fileType,
        originalFileUrl,
        originalFileStorageId,
        thumbnailUrl,
        thumbnailStorageId,
        aspectRatio,
        createdAt,
        tag,
      ]);
}
