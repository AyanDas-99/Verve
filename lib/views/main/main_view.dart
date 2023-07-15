import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/image_upload/helper/image_picker_helper.dart';
import 'package:verve/state/providers/is_floating_action_visible_provider.dart';
import 'package:verve/views/components/logo/logo_text.dart';
import 'package:verve/views/components/screens/new_post_view.dart';
import 'package:verve/views/components/screens/video_player_view.dart';
import 'package:verve/views/tabs/current_user_profile/current_user_profile_view.dart';

class MainView extends ConsumerWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isVisible = ref.watch(isFloatingActionProvider);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        floatingActionButton: isVisible
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewPostView(),
                      ));
                },
                child: const Icon(Icons.add),
              )
            : null,
        body: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            if (notification.direction == ScrollDirection.forward) {
              ref.read(isFloatingActionProvider.notifier).state = true;
            } else if (notification.direction == ScrollDirection.reverse) {
              ref.read(isFloatingActionProvider.notifier).state = false;
            }

            return true;
          },
          child: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                backgroundColor: Colors.white,
                shadowColor: Colors.white,
                elevation: 0,
                floating: true,
                snap: true,
                title: logoText(),
                centerTitle: true,
                bottom: const TabBar(
                  padding: EdgeInsets.all(10),
                  tabs: [
                    Tab(
                      icon: Icon(Icons.home),
                    ),
                    Tab(
                      icon: Icon(Icons.person),
                    ),
                    Tab(
                      icon: Icon(Icons.settings),
                    ),
                  ],
                ),
              )
            ],
            body: TabBarView(
              children: [
                const Center(
                  child: Text('Tab 1'),
                ),
                Center(
                  child: Consumer(builder: (context, WidgetRef ref, child) {
                    return TextButton(
                      child: Text('Post'),
                      onPressed: () async {
                        final file =
                            await ImagePickerHelper().getVideoFromGallery();
                        if (file == null) {
                          print('No file selected!!!');
                          return;
                        }
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoPlayerView(
                                false,
                                videoFile: file,
                              ),
                            ));
                        // final userId = ref.watch(userIdProvider);
                        // ref.read(postUploadProvider.notifier).upload(
                        //     postedBy: userId,
                        //     title: 'My 1st post!',
                        //     message: "This post is for testing only",
                        //     allowComments: true,
                        //     fileType: FileType.video,
                        //     file: file);
                      },
                    );
                  }),
                ),
                const CurrentUserProfileView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
