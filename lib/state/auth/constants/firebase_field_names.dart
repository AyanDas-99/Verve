import 'package:flutter/foundation.dart' show immutable;

@immutable
class FirebaseFieldNames {
  static String displayName = 'display_name';
  static String userId = 'user_id';
  static String email = 'email';
  static String friendsList = 'friends_list';
  static String photoUrl = 'photo_url';
  static String photoStorageId = 'photo_storage_id';
  const FirebaseFieldNames._();
}
