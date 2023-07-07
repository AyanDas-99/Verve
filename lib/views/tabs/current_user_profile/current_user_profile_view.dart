import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/user_info/providers/user_id_provider.dart';
import 'package:verve/views/components/user_profile_view.dart';

class CurrentUserProfileView extends ConsumerWidget {
  const CurrentUserProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myUserId = ref.watch(userIdProvider);
    return UserProfileView(userId: myUserId);
  }
}
