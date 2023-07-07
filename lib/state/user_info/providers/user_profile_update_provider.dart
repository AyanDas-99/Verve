import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/typedefs/is_loading.dart';
import 'package:verve/state/user_info/notifiers/user_profile_update_notifier.dart';
import 'package:verve/state/user_info/providers/current_user_provider.dart';

final userProfileUpdateProvider =
    StateNotifierProvider<UserProfileUpdateNotifier, IsLoading>((ref) {
  final currentUser = ref.watch(currentUserProvider);
  return UserProfileUpdateNotifier(currentUser);
});
