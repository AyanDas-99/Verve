import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:verve/state/auth/constants/firebase_field_names.dart';
import 'package:verve/state/user_info/typedefs/user_id.dart';

@immutable
class UserInfoModel {
  final String displayName;
  final UserId userId;
  final String email;
  final List friendsList;
  final String photoUrl;
  final String photoStorageId;

  const UserInfoModel({
    required this.displayName,
    required this.userId,
    required this.email,
    required this.friendsList,
    required this.photoUrl,
    required this.photoStorageId,
  });

  UserInfoModel.fromJson(Map<String, dynamic> json, {required UserId userId})
      : this(
          userId: userId,
          displayName: json[FirebaseFieldNames.userId],
          email: json[FirebaseFieldNames.email],
          friendsList: json[FirebaseFieldNames.friendsList],
          photoUrl: json[FirebaseFieldNames.photoUrl],
          photoStorageId: json[FirebaseFieldNames.photoStorageId],
        );

  @override
  operator ==(covariant UserInfoModel other) =>
      displayName == other.displayName &&
      userId == other.userId &&
      email == other.email &&
      IterableEquality().equals(friendsList, other.friendsList) &&
      photoUrl == other.photoUrl &&
      photoStorageId == other.photoStorageId;

  @override
  // TODO: implement hashCode
  int get hashCode => Object.hashAll([
        displayName,
        userId,
        email,
        friendsList,
        photoUrl,
        photoStorageId,
      ]);
}
