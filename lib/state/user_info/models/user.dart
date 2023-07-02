import 'package:flutter/foundation.dart' show immutable;
import 'package:verve/state/user_info/typedefs/user_id.dart';

@immutable
class UserInfoPayload {
  final String displayName;
  final UserId userId;
  final String email;
  final List<String> friendsList;
  final String photoUrl;
  final String photoStorageId;

  const UserInfoPayload({
    required this.displayName,
    required this.userId,
    required this.email,
    required this.friendsList,
    required this.photoUrl,
    required this.photoStorageId,
  });
}
