import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/comments/enums/comment_type.dart';
import 'package:verve/state/comments/providers/comments_by_post_id_provider.dart';
import 'package:verve/state/comments/providers/post_and_delete_comment_provider.dart';
import 'package:verve/state/posts/typedefs/post_id.dart';
import 'package:verve/views/components/animations/search_not_found_animation_view.dart';
import 'package:verve/views/components/comments/comment_view.dart';
import 'package:verve/views/components/snackbars/failure_snackbar.dart';
import 'package:verve/views/components/snackbars/snackbar_model.dart';
import 'package:verve/views/components/snackbars/success_snackbar.dart';
import 'package:verve/views/components/text/title_text.dart';
import 'package:verve/views/constants/strings.dart';

class CommentsScreenView extends HookConsumerWidget {
  final PostId postId;
  const CommentsScreenView({
    super.key,
    required this.postId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final comments = ref.watch(commentsByPostIdProvider(postId));
    final messageController = useTextEditingController();

    final isReadyToSend = useState(false);

    useEffect(() {
      void listener() {
        isReadyToSend.value = messageController.text.isNotEmpty;
      }

      messageController.addListener(listener);

      return () {
        messageController.removeListener(listener);
      };
    }, [messageController]);

    return Scaffold(
      appBar: AppBar(
        title: titleText(Strings.commentSection),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          ref.invalidate(commentsByPostIdProvider(postId));
          return Future.delayed(const Duration(seconds: 1));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child: comments.when(
                    data: (comments) => ListView.builder(
                        itemCount: comments.length,
                        itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CommentView(comments.elementAt(index)),
                            )),
                    error: (error, stackTrace) => SearchNotFoundAnimationView(),
                    loading: () => const CircularProgressIndicator(),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        labelText: Strings.writeYourComment,
                      ),
                    )),
                    IconButton(
                      onPressed: (!isReadyToSend.value)
                          ? null
                          : () async {
                              final commented = await ref
                                  .read(postAndDeleteCommentsProvider.notifier)
                                  .postComment(
                                    message: messageController.text,
                                    commentType: CommentType.postComment,
                                    replyTo: null,
                                    postId: postId,
                                  );

                              if (context.mounted) {
                                if (commented) {
                                  SuccessSnackBar(Strings.commentPosted)
                                      .show(context);
                                } else {
                                  FailureSnackBar(Strings.couldNotPostComment)
                                      .show(context);
                                }
                              }
                              messageController.clear();
                            },
                      icon: const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
