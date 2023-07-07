// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:collection' show MapView;

import 'package:flutter/foundation.dart' show immutable;
import 'package:verve/state/auth/constants/firebase_field_names.dart';

import 'package:verve/state/user_info/typedefs/user_id.dart';

@immutable
class UserInfoPayload extends MapView<String, dynamic> {
  final String displayName;
  final UserId userId;
  final String email;
  final List<String> friendsList;
  final String photoUrl;
  final String photoStorageId;
  final String bio;
  final List<String> favouriteTags;

  UserInfoPayload({
    required this.displayName,
    required this.userId,
    required this.email,
    required this.friendsList,
    required this.photoUrl,
    required this.photoStorageId,
    required this.bio,
    required this.favouriteTags,
  }) : super({
          FirebaseFieldNames.displayName: displayName,
          FirebaseFieldNames.userId: userId,
          FirebaseFieldNames.email: email,
          FirebaseFieldNames.friendsList: friendsList,
          FirebaseFieldNames.photoUrl: photoUrl,
          FirebaseFieldNames.photoStorageId: photoStorageId,
          FirebaseFieldNames.bio: bio,
          FirebaseFieldNames.favouriteTags: favouriteTags,
        });
}
