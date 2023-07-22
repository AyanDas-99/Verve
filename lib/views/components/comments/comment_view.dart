import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/comments/enums/comment_type.dart';
import 'package:verve/state/comments/models/comment.dart';
import 'package:verve/state/comments/providers/post_and_delete_comment_provider.dart';
import 'package:verve/state/comments/providers/replies_provider.dart';
import 'package:verve/state/user_info/providers/user_from_id_provider.dart';
import 'package:verve/views/components/date_time_view.dart';
import 'package:verve/views/components/dialogs/send_reply_dialog.dart';
import 'package:verve/views/components/padded_divider.dart';
import 'package:verve/views/components/popup_menu/comment_popup_menu.dart';
import 'package:verve/views/components/text/regular_text.dart';
import 'package:verve/views/components/user_image_and_name.dart';
import 'package:verve/views/constants/strings.dart';

class CommentView extends HookConsumerWidget {
  final Comment comment;
  final Color? backgroundColor;
  const CommentView(
    this.comment, {
    super.key,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentUser = ref.watch(userFromIdProvider(comment.commentBy));
    final replies = ref.watch(repliesProvider(comment.commentId));

    final showReplies = useState(false);

    return Container(
      padding: const EdgeInsets.all(5),
      decoration:
          BoxDecoration(color: backgroundColor, border: Border.all(width: 0.4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              UserImageAndName(
                comment.commentBy,
                size: 10,
              ),
              const Spacer(),
              DateTimeView(
                comment.createdAt,
                fontSize: 10,
              ),
              // popup menu
              CommentPopupMenu(comment),
            ],
          ),
          paddedDivider(),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: regularText(comment.message),
          ),
          paddedDivider(),
          Row(
            children: [
              // Reply button
              commentUser.when(
                data: (user) => TextButton(
                  onPressed: () async {
                    final message = await SendReplyDialog(
                            title: Strings.replyTo + user!.displayName)
                        .present(context);
                    if (message == null) {
                      return;
                    }

                    await ref
                        .read(postAndDeleteCommentsProvider.notifier)
                        .postComment(
                          message: message,
                          commentType: CommentType.commentReply,
                          replyTo: comment.commentId,
                          postId: comment.postId,
                        );
                  },
                  child: regularText(
                    Strings.reply,
                    fontSize: 12,
                  ),
                ),
                error: (e, st) => regularText(Strings.encounteredAnError),
                loading: () => const CircularProgressIndicator(),
              ),

              const Spacer(),

              // show replies button
              replies.when(
                data: (replies) => (replies.isNotEmpty)
                    ? TextButton(
                        onPressed: () {
                          showReplies.value = !showReplies.value;
                        },
                        child: Row(
                          children: [
                            regularText(
                              Strings.replies,
                              fontSize: 12,
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.blue),
                              child: regularText(
                                replies.length.toString(),
                                color: Colors.white,
                              ),
                            ),
                            FaIcon(
                              (showReplies.value)
                                  ? FontAwesomeIcons.arrowUp
                                  : FontAwesomeIcons.arrowDown,
                              size: 12,
                            )
                          ],
                        ),
                      )
                    : Container(),
                error: (e, st) => const Text('Error loading replies'),
                loading: () => const CircularProgressIndicator(),
              ),
            ],
          ),
          if (showReplies.value)
            replies.when(
              data: (replies) => Column(
                children: List.generate(
                    replies.length,
                    (index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CommentView(
                            replies.elementAt(index),
                            backgroundColor: Colors.blueGrey.shade50,
                          ),
                        )),
              ),
              error: (error, st) => const Text('Not found'),
              loading: () => const CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
