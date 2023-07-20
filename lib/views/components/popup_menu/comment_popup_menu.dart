import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/comments/models/comment.dart';
import 'package:verve/state/comments/providers/post_and_delete_comment_provider.dart';
import 'package:verve/state/user_info/providers/user_id_provider.dart';
import 'package:verve/views/components/popup_menu/popup_menu_model.dart';
import 'package:verve/views/constants/strings.dart';

class CommentPopupMenu extends ConsumerWidget {
  final Comment comment;
  const CommentPopupMenu(this.comment, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(userIdProvider);
    final Map<String, VoidCallback> buttons = {};
    if (comment.commentBy == currentUserId) {
      buttons[Strings.deleteComment] = () {
        ref
            .read(postAndDeleteCommentsProvider.notifier)
            .deleteComment(commentId: comment.commentId);
      };
    }

    if (buttons.entries.isEmpty) {
      return Container();
    }
    return PopupMenuModel(buttons);
  }
}
