import 'dart:async' show StreamController;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/auth/constants/firebase_collection_names.dart';
import 'package:verve/state/auth/constants/firebase_field_names.dart';
import 'package:verve/state/comments/enums/comment_type.dart';
import 'package:verve/state/comments/models/comment.dart';
import 'package:verve/state/comments/typedefs/comment_id.dart';

final repliesProvider = StreamProvider.family
    .autoDispose<Iterable<Comment>, CommentId>((ref, CommentId commentId) {
  final controller = StreamController<Iterable<Comment>>();

  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionNames.comments)
      .where(FirebaseFieldNames.commentType,
          isEqualTo: CommentType.commentReply.name)
      .where(FirebaseFieldNames.replyTo, isEqualTo: commentId)
      .orderBy(FirebaseFieldNames.createdAt, descending: false)
      .snapshots()
      .listen((snapshot) {
    final comments = snapshot.docs
        .where((element) => !element.metadata.hasPendingWrites)
        .map((doc) => Comment.fromJson(commentId: doc.id, json: doc.data()));

    controller.sink.add(comments);
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});
