import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/auth/providers/auth_state_provider.dart';
import 'package:verve/state/enums/file_type.dart';
import 'package:verve/state/image_upload/helper/image_picker_helper.dart';
import 'package:verve/state/post_upload/providers/post_upload_provider.dart';
import 'package:verve/state/user_info/providers/user_id_provider.dart';
import 'package:verve/views/components/logo/logo_text.dart';
import 'package:verve/views/tabs/current_user_profile/current_user_profile_view.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: logoText(),
          centerTitle: true,
        ),
        bottomSheet: Container(
          height: 50,
          child: const TabBar(
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
        ),
        body: TabBarView(
          children: [
            Container(
              child: Center(
                child: Consumer(builder: (context, ref, child) {
                  return TextButton(
                    child: Text('Log out'),
                    onPressed: () {
                      ref.read(authStateProvider.notifier).logOut();
                    },
                  );
                }),
              ),
            ),
            Container(
              child: Center(
                child: Consumer(builder: (context, WidgetRef ref, child) {
                  return TextButton(
                    child: Text('Post'),
                    onPressed: () async {
                      final file =
                          await ImagePickerHelper().getImageFromGallery();
                      if (file == null) {
                        print('No file selected!!!');
                        return;
                      }
                      final userId = ref.watch(userIdProvider);
                      ref.read(postUploadProvider.notifier).upload(
                          postedBy: userId,
                          title: 'My 1st post!',
                          message: "This post is for testing only",
                          allowComments: true,
                          fileType: FileType.image,
                          file: file);
                    },
                  );
                }),
              ),
            ),
            const CurrentUserProfileView(),
          ],
        ),
      ),
    );
  }
}
