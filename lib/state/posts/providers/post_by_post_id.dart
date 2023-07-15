import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/auth/constants/firebase_collection_names.dart';
import 'package:verve/state/posts/models/post.dart';
import 'package:verve/state/posts/typedefs/post_id.dart';

final postByPostIdProvider =
    StreamProvider.family.autoDispose<Post, PostId>((ref, PostId postId) {
  final controller = StreamController<Post>();

  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionNames.posts)
      .where(FieldPath.documentId, isEqualTo: postId)
      .limit(1)
      .snapshots()
      .listen((snapshot) {
    if (snapshot.docs.isNotEmpty) {
      final post = Post.fromJson(snapshot.docs.first.data());
      controller.sink.add(post);
    }
  });

  ref.onDispose(() {
    controller.close();
    sub.cancel();
  });

  return controller.stream;
});
