import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/auth/constants/firebase_collection_names.dart';
import 'package:verve/state/auth/constants/firebase_field_names.dart';
import 'package:verve/state/comments/enums/comment_type.dart';
import 'package:verve/state/comments/models/comment_payload.dart';
import 'package:verve/state/comments/typedefs/comment_id.dart';
import 'package:verve/state/posts/typedefs/post_id.dart';
import 'package:verve/state/typedefs/is_loading.dart';
import 'package:verve/state/user_info/typedefs/user_id.dart';

class PostAndDeleteCommentsNotifier extends StateNotifier<IsLoading> {
  final UserId? currentUserId;
  PostAndDeleteCommentsNotifier(this.currentUserId) : super(false);

  set isLoading(bool value) => {if (mounted) state = value};

  Future<bool> postComment({
    required String message,
    required CommentType commentType,
    required CommentId? replyTo,
    required PostId postId,
  }) async {
    if (currentUserId == null) {
      return false;
    }
    try {
      isLoading = true;
      final commentPayload = CommentPayload(
          message: message,
          commentBy: currentUserId!,
          commentType: commentType.name,
          replyTo: replyTo ?? '',
          postId: postId);

      await FirebaseFirestore.instance
          .collection(FirebaseCollectionNames.comments)
          .add(commentPayload);

      isLoading = false;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteComment({required CommentId commentId}) async {
    try {
      isLoading = true;
      final commentsRef = FirebaseFirestore.instance
          .collection(FirebaseCollectionNames.comments);

      // delete comment
      await commentsRef
          .where(FieldPath.documentId, isEqualTo: commentId)
          .limit(1)
          .get()
          .then((value) async {
        await value.docs.first.reference.delete();
      });

      // delete replies to the comment
      await commentsRef
          .where(FirebaseFieldNames.replyTo, isEqualTo: commentId)
          .get()
          .then((snapshot) async {
        for (final doc in snapshot.docs) {
          await doc.reference.delete();
        }
      });
      isLoading = false;
      return true;
    } catch (e) {
      return false;
    }
  }
}
