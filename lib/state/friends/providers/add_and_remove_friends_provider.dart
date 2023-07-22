import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/friends/notifiers/friends_add_and_remove_notifier.dart';
import 'package:verve/state/typedefs/is_loading.dart';
import 'package:verve/state/user_info/providers/user_id_provider.dart';

final addAndRemoveFriendsProvider =
    StateNotifierProvider<FriendsAddAndRemoveNotifier, IsLoading>((ref) {
  final myUserId = ref.watch(userIdProvider);

  return FriendsAddAndRemoveNotifier(myUserId);
});
