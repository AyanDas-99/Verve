import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/auth/constants/firebase_collection_names.dart';
import 'package:verve/state/auth/constants/firebase_field_names.dart';
import 'package:verve/state/typedefs/is_loading.dart';
import 'package:verve/state/user_info/typedefs/user_id.dart';

class FriendsAddAndRemoveNotifier extends StateNotifier<IsLoading> {
  final UserId myUserId;
  FriendsAddAndRemoveNotifier(this.myUserId) : super(false);

  set isLoading(bool value) => {if (mounted) state = value};

  Future<bool> addFriend(UserId userToAddFriend) async {
    try {
      isLoading = true;
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionNames.users)
          .where(FirebaseFieldNames.userId, isEqualTo: myUserId)
          .limit(1)
          .get()
          .then((snapshot) => snapshot.docs.first.reference.update({
                FirebaseFieldNames.friendsList:
                    FieldValue.arrayUnion([userToAddFriend])
              }));
      isLoading = false;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeFriend(UserId userToRemoveFriend) async {
    try {
      isLoading = true;
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionNames.users)
          .where(FirebaseFieldNames.userId, isEqualTo: myUserId)
          .limit(1)
          .get()
          .then((snapshot) => snapshot.docs.first.reference.update({
                FirebaseFieldNames.friendsList:
                    FieldValue.arrayRemove([userToRemoveFriend])
              }));

      isLoading = false;
      return true;
    } catch (e) {
      return false;
    }
  }
}
