import 'package:flutter/foundation.dart' show immutable;
import 'package:verve/state/auth/constants/firebase_field_names.dart';
import 'package:verve/state/posts/typedefs/post_id.dart';
import 'package:verve/state/user_info/typedefs/user_id.dart';

@immutable
class Like {
  final UserId likedBy;
  final PostId postId;

  const Like({required this.likedBy, required this.postId});

  Like.fromJson(Map<String, dynamic> json)
      : this(
          likedBy: json[FirebaseFieldNames.userId],
          postId: json[FirebaseFieldNames.postId],
        );

  @override
  operator ==(covariant Like other) =>
      likedBy == other.likedBy && postId == other.postId;

  @override
  int get hashCode => Object.hashAll([
        likedBy,
        postId,
      ]);
}
