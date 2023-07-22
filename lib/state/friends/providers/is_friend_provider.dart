import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/user_info/providers/current_user_provider.dart';
import 'package:verve/state/user_info/typedefs/user_id.dart';

final isFriendProvider =
    StreamProvider.family.autoDispose<bool, UserId>((ref, UserId userId) {
  final currentUser = ref.watch(currentUserProvider);

  final controller = StreamController<bool>();

  if (currentUser != null) {
    controller.sink.add(currentUser.friendsList.contains(userId));
  }

  ref.onDispose(() {
    controller.close();
  });

  return controller.stream;
});
