import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/auth/constants/firebase_collection_names.dart';
import 'package:verve/state/auth/constants/firebase_field_names.dart';
import 'package:verve/state/likes/models/like_payload.dart';
import 'package:verve/state/posts/typedefs/post_id.dart';
import 'package:verve/state/user_info/providers/user_id_provider.dart';

final likeDislidePostProvider =
    FutureProvider.family.autoDispose<bool, PostId>((ref, PostId postId) async {
  final currentUserId = ref.watch(userIdProvider);

  final likesReference =
      FirebaseFirestore.instance.collection(FirebaseCollectionNames.likes);

  // check if already like by user
  try {
    final likeSnap = await likesReference
        .where(FirebaseFieldNames.postId, isEqualTo: postId)
        .where(FirebaseFieldNames.userId, isEqualTo: currentUserId)
        .limit(1)
        .get();

    // if liked delete the like else delete
    if (likeSnap.docs.isNotEmpty) {
      await likeSnap.docs.first.reference.delete();
    } else {
      final newLikePayload =
          LikePayload(likedBy: currentUserId, postId: postId);
      await likesReference.add(newLikePayload);
    }

    return true;
  } catch (e) {
    return false;
  }
});
