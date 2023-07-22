import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/posts/providers/posts_by_search_term_provider.dart';
import 'package:verve/views/components/animations/profile_search_loading_animation_view.dart';
import 'package:verve/views/components/animations/search_not_found_with_text_animation_view.dart';
import 'package:verve/views/components/post/post_tile.dart';
import 'package:verve/views/constants/strings.dart';

class SearchedPostsListView extends ConsumerWidget {
  final String searchTerm;
  const SearchedPostsListView(this.searchTerm, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchedPosts = ref.watch(postsBySearchTermProvider(searchTerm));

    if (searchTerm.isEmpty) {
      return profileSearchLoadingAnimationView();
    }

    return searchedPosts.when(
      data: (posts) {
        if (posts.isEmpty) {
          return searchNotFoundWithTextAnimationView(text: 'Posts not found');
        }
        return Expanded(
          child: ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) => PostTile(
              posts.elementAt(index),
            ),
          ),
        );
      },
      error: (er, st) =>
          searchNotFoundWithTextAnimationView(text: Strings.encounteredAnError),
      loading: () => profileSearchLoadingAnimationView(),
    );
  }
}
