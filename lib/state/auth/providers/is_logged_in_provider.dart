import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/auth/models/auth_result.dart';
import 'package:verve/state/auth/providers/auth_state_provider.dart';

final isLoggedInProvider = Provider<bool>((ref) {
  final result = ref.watch(authStateProvider);
  return result.authResult == AuthResult.success;
});
