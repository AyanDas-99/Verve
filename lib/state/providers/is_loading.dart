import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/auth/providers/auth_state_provider.dart';
import 'package:verve/state/typedefs/is_loading.dart';

final isLoadingProvider = Provider<IsLoading>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.isLoading;
});
