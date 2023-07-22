import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/auth/constants/firebase_collection_names.dart';
import 'package:verve/state/posts/models/post.dart';

final postsBySearchTermProvider = StreamProvider.family
    .autoDispose<Iterable<Post>, String>((ref, String searchTerm) {
  final controller = StreamController<Iterable<Post>>();

  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionNames.posts)
      .snapshots()
      .listen((snapshot) {
    final posts = snapshot.docs
        .map((doc) => Post.fromJson(
              doc.id,
              doc.data(),
            ))
        .where((post) =>
            post.title.toLowerCase().contains(searchTerm.toLowerCase()) ||
            post.message.toLowerCase().contains(searchTerm.toLowerCase()));

    controller.sink.add(posts);
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});
