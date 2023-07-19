import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/comments/notifiers/post_and_delete_comments_notifiers.dart';
import 'package:verve/state/typedefs/is_loading.dart';
import 'package:verve/state/user_info/providers/user_id_provider.dart';

final postAndDeleteCommentsProvider =
    StateNotifierProvider<PostAndDeleteCommentsNotifier, IsLoading>((ref) {
  final currentUserId = ref.watch(userIdProvider);
  return PostAndDeleteCommentsNotifier(currentUserId);
});
