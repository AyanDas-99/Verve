import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/auth/constants/firebase_collection_names.dart';
import 'package:verve/state/auth/constants/firebase_field_names.dart';
import 'package:verve/state/image_upload/helper/image_picker_helper.dart';
import 'package:verve/state/typedefs/is_loading.dart';
import 'package:verve/state/user_info/models/user_info_model.dart';
import 'package:verve/state/user_info/typedefs/user_id.dart';
import 'package:uuid/uuid.dart';

class UserProfileUpdateNotifier extends StateNotifier<IsLoading> {
  final UserInfoModel? currentUser;
  UserProfileUpdateNotifier(this.currentUser) : super(false);

  set isLoading(bool value) => state = value;

  Future<bool> uploadPhoto(UserId userId) async {
    isLoading = true;
    // delete previous photos
    try {
      await FirebaseStorage.instance
          .ref()
          .child(userId)
          .child(FirebaseCollectionNames.profilePhoto)
          .child(currentUser!.photoStorageId)
          .delete();

      // get new picture from gallery
      final File? newPhoto = await ImagePickerHelper().getImageFromGallery();
      final list = newPhoto!.readAsBytesSync();
      final Uint8List data = Uint8List.fromList(list);

      // upload to storage

      final String newFileName = Uuid().v4();

      final imageRef = FirebaseStorage.instance
          .ref()
          .child(userId)
          .child(FirebaseCollectionNames.profilePhoto)
          .child(newFileName);

      final uploadTask = await imageRef.putData(data);

      final photoStorageId = uploadTask.ref.name;
      final photoUrl = await uploadTask.ref.getDownloadURL();

      // update users collection with new urls
      await _updateUserData({
        FirebaseFieldNames.photoUrl: photoUrl,
        FirebaseFieldNames.photoStorageId: photoStorageId,
      });

      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading = false;
    }
  }

  Future<bool> updateName(String name) async {
    isLoading = true;
    try {
      await _updateUserData({
        FirebaseFieldNames.displayName: name,
      });
      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading = false;
    }
  }

  Future<bool> _updateUserData(Map<String, dynamic> data) async {
    final userId = currentUser!.userId;
    try {
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionNames.users)
          .where(FirebaseFieldNames.userId, isEqualTo: userId)
          .limit(1)
          .get()
          .then((snapshot) => snapshot.docs.first.reference.update(data));
      return true;
    } catch (e) {
      return false;
    }
  }
}
