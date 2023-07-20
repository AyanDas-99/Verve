import 'dart:async' show StreamController;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/auth/constants/firebase_collection_names.dart';
import 'package:verve/state/auth/constants/firebase_field_names.dart';
import 'package:verve/state/posts/typedefs/post_id.dart';

final commentCountProvider =
    StreamProvider.family.autoDispose<int, PostId>((ref, PostId postId) {
  final controller = StreamController<int>();

  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionNames.comments)
      .where(FirebaseFieldNames.postId, isEqualTo: postId)
      .snapshots()
      .listen((snapshot) {
    controller.sink.add(snapshot.docs.length);
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});
