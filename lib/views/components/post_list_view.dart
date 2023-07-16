import 'package:flutter/material.dart';
import 'package:verve/state/posts/models/post.dart';
import 'package:verve/views/components/post_tile.dart';

class PostListView extends StatelessWidget {
  final Iterable<Post> posts;
  const PostListView(
    this.posts, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) => PostTile(posts.elementAt(index)),
      itemCount: posts.length,
    );
  }
}
