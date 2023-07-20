import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:verve/state/auth/constants/firebase_field_names.dart';
import 'package:verve/state/comments/enums/comment_type.dart';
import 'package:verve/state/comments/typedefs/comment_id.dart';
import 'package:verve/state/posts/typedefs/post_id.dart';
import 'package:verve/state/user_info/typedefs/user_id.dart';

@immutable
class Comment {
  final String message;
  final CommentType commentType;
  final CommentId commentId;
  final UserId commentBy;
  final CommentId replyTo;
  final PostId postId;
  final DateTime createdAt;

  const Comment({
    required this.message,
    required this.commentType,
    required this.commentId,
    required this.commentBy,
    required this.replyTo,
    required this.postId,
    required this.createdAt,
  });

  Comment.fromJson(
      {required CommentId commentId, required Map<String, dynamic> json})
      : this(
          message: json[FirebaseFieldNames.message],
          commentType: CommentType.values.firstWhere(
              (type) => type.name == json[FirebaseFieldNames.commentType]),
          commentId: commentId,
          commentBy: json[FirebaseFieldNames.userId],
          replyTo: json[FirebaseFieldNames.replyTo],
          postId: json[FirebaseFieldNames.postId],
          createdAt: (json[FirebaseFieldNames.createdAt] as Timestamp).toDate(),
        );

  @override
  operator ==(covariant Comment other) =>
      message == other.message &&
      commentType == other.commentType &&
      commentBy == other.commentBy &&
      replyTo == other.replyTo &&
      createdAt == other.createdAt &&
      postId == other.postId;

  @override
  int get hashCode => Object.hashAll([
        createdAt,
        message,
        commentType,
        commentBy,
        replyTo,
        postId,
      ]);
}
