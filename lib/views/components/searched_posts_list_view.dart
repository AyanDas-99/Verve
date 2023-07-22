import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/posts/providers/posts_by_search_term_provider.dart';
import 'package:verve/views/components/animations/search_not_found_animation_view.dart';
import 'package:verve/views/components/post/post_tile.dart';

class SearchedPostsListView extends ConsumerWidget {
  final String searchTerm;
  const SearchedPostsListView(this.searchTerm, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchedPosts = ref.watch(postsBySearchTermProvider(searchTerm));

    if (searchTerm.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: SearchNotFoundAnimationView(),
      );
    }

    return searchedPosts.when(
      data: (posts) {
        if (posts.isEmpty) {
          return SearchNotFoundAnimationView();
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
      error: (er, st) => Text("Error"),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
