import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/auth/constants/firebase_collection_names.dart';
import 'package:verve/state/auth/constants/firebase_field_names.dart';
import 'package:verve/state/posts/models/post.dart';

final allPostsProvider = StreamProvider<Iterable<Post>>((ref) {
  final controller = StreamController<Iterable<Post>>();

  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionNames.posts)
      .orderBy(
        FirebaseFieldNames.createdAt,
        descending: true,
      )
      .snapshots()
      .listen((snapshot) {
    if (snapshot.docs.isNotEmpty) {
      final Iterable<Post> posts = snapshot.docs
          .where((element) => !element.metadata.hasPendingWrites)
          .map((doc) => Post.fromJson(doc.id, doc.data()))
          .toList();
      controller.sink.add(posts);
    }
  });

  ref.onDispose(() {
    controller.close();
    sub.cancel();
  });

  return controller.stream;
});
