import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/auth/constants/firebase_collection_names.dart';
import 'package:verve/state/auth/constants/firebase_field_names.dart';
import 'package:verve/state/user_info/exception/user_not_found_exception.dart';
import 'package:verve/state/user_info/models/user_info_model.dart';
import 'package:verve/state/user_info/typedefs/user_id.dart';

final userFromIdProvider =
    StreamProvider.family<UserInfoModel?, UserId>((ref, UserId userId) {
  final controller = StreamController<UserInfoModel?>();

  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionNames.users)
      .where(FirebaseFieldNames.userId, isEqualTo: userId)
      .limit(1)
      .snapshots()
      .listen((snapshot) {
    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs.first.data();
      final user = UserInfoModel.fromJson(data, userId: userId);
      controller.sink.add(user);
    } else {
      controller.sink.addError(userNotFoundException);
    }
  });

  ref.onDispose(() {
    controller.close();
    sub.cancel();
  });
  return controller.stream;
});
