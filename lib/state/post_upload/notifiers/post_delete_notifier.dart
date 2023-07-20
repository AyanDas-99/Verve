import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/auth/constants/firebase_collection_names.dart';
import 'package:verve/state/auth/constants/firebase_field_names.dart';
import 'package:verve/state/enums/file_type.dart';
import 'package:verve/state/posts/models/post.dart';
import 'package:verve/state/posts/typedefs/post_id.dart';
import 'package:verve/state/typedefs/is_loading.dart';

class PostDeleteNotifier extends StateNotifier<IsLoading> {
  PostDeleteNotifier() : super(false);

  set isLoading(bool value) => {if (mounted) state = value};
  // post delete
  Future<bool> deletePost(Post post) async {
    try {
      isLoading = true;
      // delete post
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionNames.posts)
          .doc(post.postId)
          .delete();

      // delete thumbnail file
      try {
        await FirebaseStorage.instance
            .ref()
            .child(post.postedBy)
            .child(FirebaseCollectionNames.thumbnails)
            .child(post.thumbnailStorageId)
            .delete();
      } catch (e) {
        //
      }

      // delete the picture or video file depending upon the fileType
      final fileCollectionName = (post.fileType == FileType.image)
          ? FirebaseCollectionNames.images
          : FirebaseCollectionNames.videos;
      try {
        await FirebaseStorage.instance
            .ref()
            .child(post.postedBy)
            .child(fileCollectionName)
            .child(post.originalFileStorageId)
            .delete();
      } catch (e) {
        //
      }

      // delete likes files
      await _deleteAllDocs(
          postId: post.postId, inCollection: FirebaseCollectionNames.likes);

      // delete comments files
      await _deleteAllDocs(
          postId: post.postId, inCollection: FirebaseCollectionNames.comments);

      isLoading = false;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _deleteAllDocs(
      {required PostId postId, required String inCollection}) {
    return FirebaseFirestore.instance.runTransaction(maxAttempts: 3,
        (transaction) async {
      final query = await FirebaseFirestore.instance
          .collection(inCollection)
          .where(FirebaseFieldNames.postId, isEqualTo: postId)
          .get();

      for (final doc in query.docs) {
        transaction.delete(doc.reference);
      }
    });
  }
}
