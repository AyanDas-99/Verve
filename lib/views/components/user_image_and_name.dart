import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/user_info/providers/user_from_id_provider.dart';
import 'package:verve/state/user_info/providers/user_id_provider.dart';
import 'package:verve/state/user_info/typedefs/user_id.dart';
import 'package:verve/views/components/animations/circular_loading_animation_view.dart';
import 'package:verve/views/components/circular_profile_photo.dart';
import 'package:verve/views/components/text/regular_text.dart';
import 'package:verve/views/components/user_profile_view.dart';

class UserImageAndName extends ConsumerWidget {
  final UserId userId;
  final double? size;
  const UserImageAndName(
    this.userId, {
    super.key,
    this.size,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userFromIdProvider(userId));
    final currentUserId = ref.watch(userIdProvider);

    return user.when(
      data: (user) {
        final bool postedByUser = user!.userId == currentUserId;
        return Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: InkWell(
            onTap: (postedByUser)
                ? null
                : () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserProfileView(
                          userId: user.userId,
                        ),
                      ),
                    ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                circularProfilePhoto(
                    user.photoUrl, (size != null) ? size! * 1.7 : 24),
                const SizedBox(
                  width: 10,
                ),
                regularText(user.displayName, fontSize: size ?? 15),
              ],
            ),
          ),
        );
      },
      error: (error, stackTrace) => regularText('Error getting user'),
      loading: () => circularLoadingAnimation(),
    );
  }
}
