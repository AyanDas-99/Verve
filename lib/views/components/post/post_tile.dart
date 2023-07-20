import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/comments/providers/comment_count_provider.dart';
import 'package:verve/state/enums/file_type.dart';
import 'package:verve/state/likes/providers/has_liked_post_provider.dart';
import 'package:verve/state/likes/providers/like_dislike_post_provider.dart';
import 'package:verve/state/likes/providers/likes_count_provider.dart';
import 'package:verve/state/posts/models/post.dart';
import 'package:verve/views/components/comments/comments_screen_view.dart';
import 'package:verve/views/components/padded_divider.dart';
import 'package:verve/views/components/post/like_count_text.dart';
import 'package:verve/views/components/post/post_count_text.dart';
import 'package:verve/views/components/text/regular_text.dart';
import 'package:verve/views/components/user_image_and_name.dart';
import 'package:verve/views/components/video_player_view.dart';

class PostTile extends HookConsumerWidget {
  final Post post;
  const PostTile(
    this.post, {
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postLikesCount = ref.watch(likesCountProvider(post.postId));
    final hasUserLiked = ref.watch(hasLikedPostProvider(post.postId));
    final commentCount = ref.watch(commentCountProvider(post.postId));

    // checks if post is posted by current user

    final postFocused = useState(false);

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
      ),
      margin: const EdgeInsets.only(
        bottom: 30.0,
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 0.2,
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // user name and photo

          UserImageAndName(post.postedBy),

          paddedDivider(),

          // Post title

          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              post.title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.josefinSans().fontFamily,
              ),
            ),
          ),

          // Message text
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              top: 5.0,
            ),
            child: regularText(post.message),
          ),

          paddedDivider(),

          // Media content

          if (postFocused.value) ...[
            // Image or video
            if (post.fileType == FileType.image)
              AspectRatio(
                aspectRatio: post.aspectRatio,
                child: Image.network(
                  post.originalFileUrl,
                ),
              ),

            if (post.fileType == FileType.video)
              VideoPlayerView(
                true,
                videoUrl: post.originalFileUrl,
              ),
          ],

          if (!postFocused.value)
            GestureDetector(
              onTap: () => postFocused.value = true,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.network(
                    post.thumbnailUrl,
                    scale: 0.3,
                  ),
                  if (post.fileType == FileType.video)
                    const FaIcon(
                      FontAwesomeIcons.circlePlay,
                      color: Colors.white,
                    ),
                ],
              ),
            ),

          paddedDivider(),

          // Like and comment icons
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              bottom: 8.0,
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        ref.read(likeDislidePostProvider(post.postId));
                      },
                      icon: hasUserLiked.when(
                        data: (hasLiked) => (!hasLiked)
                            ? const FaIcon(
                                FontAwesomeIcons.heart,
                                size: 20,
                              )
                            : const FaIcon(
                                FontAwesomeIcons.solidHeart,
                                size: 20,
                                color: Colors.red,
                              ),
                        error: (e, st) =>
                            const FaIcon(FontAwesomeIcons.heartCrack),
                        loading: () => const CircularProgressIndicator(),
                      ),
                    ),
                    postLikesCount.when(
                        data: (count) => likeCountText(count),
                        error: (e, st) => likeCountText(0),
                        loading: () => const CircularProgressIndicator()),
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CommentsScreenView(postId: post.postId)));
                      },
                      icon: const FaIcon(
                        FontAwesomeIcons.comment,
                        size: 20,
                      ),
                    ),
                    commentCount.when(
                      data: (count) => commentCountText(count),
                      error: (e, st) => commentCountText(0),
                      loading: () => const CircularProgressIndicator(),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
