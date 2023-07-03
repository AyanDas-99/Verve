import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/auth/backend/authenticator.dart';
import 'package:verve/state/auth/models/auth_result.dart';
import 'package:verve/state/auth/models/auth_state.dart';
import 'package:verve/state/user_info/backend/user_storage.dart';

class AuthStateNotifier extends StateNotifier<AuthState> {
  final _authenticator = Authenticator();
  final _userStorage = const UserStorage();
  AuthStateNotifier() : super(const AuthState.unknown()) {
    if (_authenticator.isLoggedIn) {
      state = AuthState(
          authResult: AuthResult.success,
          isLoading: false,
          userId: _authenticator.userId);
    }
  }

  Future<bool> loginWithGoogle() async {
    state = state.copyWithLoading(true);
    final result = await _authenticator.loginWithGoogle();
    if (result != AuthResult.success) {
      return false;
    }
    final userId = _authenticator.userId;
    final displayName = _authenticator.displayName;
    final email = _authenticator.email;
    state = AuthState(authResult: result, isLoading: false, userId: userId);
    // Store user in firebase storage
    final isStored = _userStorage.storeUser(
        userId: userId ?? '', displayName: displayName, email: email);
    state = AuthState(
        authResult: AuthResult.success, isLoading: false, userId: userId);
    return true;
  }

  Future<void> logOut() async {
    state = state.copyWithLoading(true);
    await _authenticator.logOut();
    await Future.delayed(Duration(seconds: 2));
    state = const AuthState.unknown();
  }
}
