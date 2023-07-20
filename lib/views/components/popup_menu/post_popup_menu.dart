import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/post_upload/providers/post_delete_provider.dart';
import 'package:verve/state/posts/models/post.dart';
import 'package:verve/state/user_info/providers/user_id_provider.dart';
import 'package:verve/views/components/popup_menu/popup_menu_model.dart';
import 'package:verve/views/constants/strings.dart';

class PostPopupMenu extends ConsumerWidget {
  final Post post;
  const PostPopupMenu(this.post, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(userIdProvider);
    final Map<String, VoidCallback> buttons = {};
    if (post.postedBy == currentUserId) {
      buttons[Strings.deletePost] = () {
        ref.read(postDeleteProvider.notifier).deletePost(post);
      };
    }

    if (buttons.entries.isEmpty) {
      return Container();
    }
    return PopupMenuModel(buttons);
  }
}
