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
  final String bio;
  final List favouriteTags;

  const UserInfoModel({
    required this.displayName,
    required this.userId,
    required this.email,
    required this.friendsList,
    required this.photoUrl,
    required this.photoStorageId,
    required this.bio,
    required this.favouriteTags,
  });

  UserInfoModel.fromJson(Map<String, dynamic> json, {required UserId userId})
      : this(
          userId: userId,
          displayName: json[FirebaseFieldNames.displayName],
          email: json[FirebaseFieldNames.email],
          friendsList: json[FirebaseFieldNames.friendsList],
          photoUrl: json[FirebaseFieldNames.photoUrl],
          photoStorageId: json[FirebaseFieldNames.photoStorageId],
          bio: json[FirebaseFieldNames.bio],
          favouriteTags: json[FirebaseFieldNames.favouriteTags],
        );

  @override
  operator ==(covariant UserInfoModel other) =>
      displayName == other.displayName &&
      userId == other.userId &&
      email == other.email &&
      const IterableEquality().equals(friendsList, other.friendsList) &&
      photoUrl == other.photoUrl &&
      photoStorageId == other.photoStorageId &&
      bio == other.bio &&
      const IterableEquality().equals(favouriteTags, other.favouriteTags);

  @override
  int get hashCode => Object.hashAll([
        displayName,
        userId,
        email,
        friendsList,
        photoUrl,
        photoStorageId,
        bio,
        favouriteTags,
      ]);
}
