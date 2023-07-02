// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart' show immutable;
import 'package:verve/state/auth/models/auth_result.dart';
import 'package:verve/state/typedefs/is_loading.dart';
import 'package:verve/state/user_info/typedefs/user_id.dart';

@immutable
class AuthState {
  final AuthResult? authResult;
  final IsLoading isLoading;
  final UserId? userId;
  AuthState({
    required this.authResult,
    required this.isLoading,
    required this.userId,
  });

  const AuthState.unknown()
      : authResult = null,
        isLoading = false,
        userId = null;

  AuthState copyWithLoading(bool value) =>
      AuthState(authResult: authResult, isLoading: value, userId: userId);

  @override
  bool operator ==(covariant AuthState other) =>
      authResult == other.authResult &&
      isLoading == other.isLoading &&
      userId == other.userId &&
      runtimeType == other.runtimeType;

  @override
  // TODO: implement hashCode
  int get hashCode => Object.hashAll([authResult, isLoading, userId]);
}
