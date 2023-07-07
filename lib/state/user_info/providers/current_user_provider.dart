import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/user_info/models/user_info_model.dart';
import 'package:verve/state/user_info/providers/user_from_id_provider.dart';
import 'package:verve/state/user_info/providers/user_id_provider.dart';

final currentUserProvider = Provider<UserInfoModel?>((ref) {
  final userId = ref.watch(userIdProvider);
  final user = ref.watch(userFromIdProvider(userId));
  if (user.hasValue) {
    return user.value;
  }
});
