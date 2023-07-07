import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:verve/state/auth/constants/firebase_collection_names.dart';
import 'package:verve/state/auth/constants/firebase_field_names.dart';
import 'package:verve/state/user_info/models/user_info_payload.dart';
import 'package:verve/state/user_info/typedefs/user_id.dart';

@immutable
class UserStorage {
  const UserStorage();

  Future<bool> storeUser({
    required UserId userId,
    required String displayName,
    required String? email,
  }) async {
    // check if already exists
    try {
      final user = await FirebaseFirestore.instance
          .collection(FirebaseCollectionNames.users)
          .where(FirebaseFieldNames.userId, isEqualTo: userId)
          .limit(1)
          .get();
      if (user.docs.isNotEmpty) {
        // user exist
        // update display name and email
        await user.docs.first.reference.update({
          FirebaseFieldNames.email: email,
        });
        return true;
      } else {
        // user doesn't exist
        // create new user payload
        final userPayload = UserInfoPayload(
          displayName: displayName,
          userId: userId,
          email: email ?? '',
          friendsList: [],
          photoUrl: '',
          photoStorageId: '',
          bio: '',
          favouriteTags: [],
        );

        await FirebaseFirestore.instance
            .collection(FirebaseCollectionNames.users)
            .add(userPayload);
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
