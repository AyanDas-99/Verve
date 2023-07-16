import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/enums/file_type.dart';
import 'package:verve/state/posts/models/post.dart';
import 'package:verve/state/user_info/providers/user_from_id_provider.dart';
import 'package:verve/views/components/animations/circular_loading_animation_view.dart';
import 'package:verve/views/components/circular_profile_photo.dart';
import 'package:verve/views/components/text/regular_text.dart';
import 'package:verve/views/components/video_player_view.dart';

class PostTile extends HookConsumerWidget {
  final Post post;
  const PostTile(
    this.post, {
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userFromIdProvider(post.postedBy));

    final postFocused = useState(false);

    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5,
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // user name and photo
            user.when(
              data: (user) => Row(
                children: [
                  circularProfilePhoto(user!.photoUrl, 13),
                  regularText(user.displayName),
                ],
              ),
              error: (error, stackTrace) => regularText('Error getting user'),
              loading: () => circularLoadingAnimation(),
            ),

            const SizedBox(
              height: 10,
            ),

            // Post title

            Text(
              post.title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.josefinSans().fontFamily,
              ),
            ),

            const SizedBox(
              height: 10,
            ),

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
                child: Image.network(
                  post.thumbnailUrl,
                  scale: 0.6,
                ),
              ),

            const SizedBox(
              height: 10,
            ),

            // Message text
            regularText(post.message),

            const SizedBox(
              height: 10,
            ),

            // Like and comment icons
            Row(
              children: [
                Column(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: FaIcon(FontAwesomeIcons.heart),
                    ),
                    regularText('1 like'),
                  ],
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: FaIcon(FontAwesomeIcons.comment),
                    ),
                    regularText('1 comment'),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
