import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/auth/constants/firebase_collection_names.dart';
import 'package:verve/state/auth/constants/firebase_field_names.dart';
import 'package:verve/state/user_info/providers/user_id_provider.dart';
import 'package:verve/state/user_info/typedefs/user_id.dart';

final removeFriendProvider = FutureProvider.autoDispose
    .family<bool, UserId>((ref, UserId userToAddFriend) async {
  final myUserId = ref.watch(userIdProvider);

  try {
    await FirebaseFirestore.instance
        .collection(FirebaseCollectionNames.users)
        .where(FirebaseFieldNames.userId, isEqualTo: myUserId)
        .limit(1)
        .get()
        .then((snapshot) => snapshot.docs.first.reference.update({
              FirebaseFieldNames.friendsList:
                  FieldValue.arrayRemove([userToAddFriend])
            }));
    return true;
  } catch (e) {
    return false;
  }
});
