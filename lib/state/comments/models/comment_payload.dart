import 'dart:collection';

import 'package:verve/state/auth/constants/firebase_field_names.dart';
import 'package:verve/state/comments/typedefs/comment_id.dart';
import 'package:verve/state/posts/typedefs/post_id.dart';
import 'package:verve/state/user_info/typedefs/user_id.dart';

class CommentPayload extends MapView<String, dynamic> {
  CommentPayload({
    required String message,
    required UserId commentBy,
    required String commentType,
    required CommentId replyTo,
    required PostId postId,
  }) : super({
          FirebaseFieldNames.message: message,
          FirebaseFieldNames.commentType: commentType,
          FirebaseFieldNames.replyTo: replyTo,
          FirebaseFieldNames.postId: postId,
          FirebaseFieldNames.userId: commentBy,
        });
}
