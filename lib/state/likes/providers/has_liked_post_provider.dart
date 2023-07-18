import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/auth/constants/firebase_collection_names.dart';
import 'package:verve/state/auth/constants/firebase_field_names.dart';
import 'package:verve/state/posts/typedefs/post_id.dart';
import 'package:verve/state/user_info/providers/user_id_provider.dart';

final hasLikedPostProvider =
    StreamProvider.family.autoDispose<bool, PostId>((ref, PostId postId) {
  final currentUserId = ref.watch(userIdProvider);

  final controller = StreamController<bool>();

  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionNames.likes)
      .where(FirebaseFieldNames.postId, isEqualTo: postId)
      .where(FirebaseFieldNames.userId, isEqualTo: currentUserId)
      .snapshots()
      .listen((snapshot) {
    controller.sink.add(snapshot.docs.isNotEmpty);
  });

  ref.onDispose(() {
    controller.close();
    sub.cancel();
  });

  return controller.stream;
});
