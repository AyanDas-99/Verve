import 'package:flutter/material.dart';
import 'package:verve/views/components/user_image_and_name.dart';

class FriendsListView extends StatelessWidget {
  final List friends;
  const FriendsListView(this.friends, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: friends.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: UserImageAndName(
            friends.elementAt(index),
          ),
        ),
      ),
    );
  }
}
