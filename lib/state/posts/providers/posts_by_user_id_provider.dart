import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/auth/constants/firebase_collection_names.dart';
import 'package:verve/state/auth/constants/firebase_field_names.dart';
import 'package:verve/state/posts/exceptions/post_not_found_exception.dart';
import 'package:verve/state/posts/models/post.dart';
import 'package:verve/state/user_info/typedefs/user_id.dart';

final postsByUserIdProvider = StreamProvider.family
    .autoDispose<Iterable<Post>, UserId>((ref, UserId userId) {
  final controller = StreamController<Iterable<Post>>();

  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionNames.posts)
      .where(FirebaseFieldNames.userId, isEqualTo: userId)
      .snapshots()
      .listen((snapshot) {
    if (snapshot.docs.isNotEmpty) {
      print(snapshot.docs);
      final Iterable<Post> posts = snapshot.docs
          .where((element) => !element.metadata.hasPendingWrites)
          .map((doc) => Post.fromJson(doc.id, doc.data()))
          .toList();
      controller.sink.add(posts);
    } else {
      controller.sink.addError(PostsNotFoundException);
    }
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});
