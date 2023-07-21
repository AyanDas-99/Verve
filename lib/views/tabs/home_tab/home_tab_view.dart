import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/posts/providers/all_posts_provider.dart';
import 'package:verve/state/user_info/providers/current_user_provider.dart';
import 'package:verve/views/components/animations/circular_loading_animation_view.dart';
import 'package:verve/views/components/animations/search_not_found_with_text_animation_view.dart';
import 'package:verve/views/components/post/post_tile.dart';

class HomeTabView extends ConsumerWidget {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allPosts = ref.watch(allPostsProvider);
    final currentUser = ref.watch(currentUserProvider);

    return RefreshIndicator(
      onRefresh: () {
        ref.invalidate(allPostsProvider);
        return Future.delayed(const Duration(seconds: 1));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: allPosts.when(
          data: (posts) {
            if (currentUser != null) {
              final postsToShow = posts.where(
                  (post) => currentUser.favouriteTags.contains(post.tag));

              return ListView.builder(
                itemBuilder: (context, index) =>
                    PostTile(postsToShow.elementAt(index)),
                itemCount: postsToShow.length,
              );
            } else {
              return CircularProgressIndicator();
            }
          },
          error: (error, stackTrace) =>
              searchNotFoundWithTextAnimationView(text: 'Not found'),
          loading: () => circularLoadingAnimation(),
        ),
      ),
    );
  }
}
