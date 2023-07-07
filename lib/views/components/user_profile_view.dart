import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/auth/providers/auth_state_provider.dart';
import 'package:verve/state/providers/creative_field_list_provider.dart';
import 'package:verve/state/user_info/providers/user_from_id_provider.dart';
import 'package:verve/state/user_info/providers/user_id_provider.dart';
import 'package:verve/state/user_info/providers/user_profile_update_provider.dart';
import 'package:verve/state/user_info/typedefs/user_id.dart';
import 'package:verve/views/components/animations/profile_search_loading_animation_view.dart';
import 'package:verve/views/components/animations/search_not_found_with_text_animation_view.dart';
import 'package:verve/views/components/button.dart';
import 'package:verve/views/components/circular_profile_photo.dart';
import 'package:verve/views/components/dialogs/add_favourite_dialog.dart';
import 'package:verve/views/components/dialogs/text_update_dialog_model.dart';
import 'package:verve/views/components/padded_divider.dart';
import 'package:verve/views/components/text/regular_text.dart';
import 'package:verve/views/components/text/title_text.dart';
import 'package:verve/views/constants/strings.dart';

class UserProfileView extends ConsumerWidget {
  final UserId userId;

  const UserProfileView({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userFromIdProvider(userId));
    final myUserId = ref.watch(userIdProvider);
    return user.when(
      data: (user) {
        final bool isCurrentUser = myUserId == userId;
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User detail section
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        ref
                            .read(userProfileUpdateProvider.notifier)
                            .updatePhoto();
                      },
                      child: circularProfilePhoto(
                        user!.photoUrl,
                        70,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.displayName,
                          style: TextStyle(
                            fontFamily: GoogleFonts.josefinSans().fontFamily,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        // Show email address only if isCurrentUser
                        if (isCurrentUser)
                          Text(
                            user.email,
                            style: TextStyle(
                              fontFamily: GoogleFonts.josefinSans().fontFamily,
                              fontSize: 15,
                            ),
                          ),

                        // Show edit button if isCurrentUser is true
                        if (isCurrentUser)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: button(
                                backgroundColor: Colors.white,
                                // text: 'Edit',
                                icon: Icons.edit,
                                onPress: () async {
                                  // Navigate to edit profile page
                                  final updatedName =
                                      await TextUpdateDialogModel(
                                    previousText: user.displayName,
                                    title: Strings.enterNewName,
                                  ).present(context);
                                  if (updatedName != null) {
                                    ref
                                        .read(
                                            userProfileUpdateProvider.notifier)
                                        .updateName(updatedName);
                                  }
                                }),
                          )
                      ],
                    ),
                  ],
                ),

                // Show account log out section only if it is currentUser account

                if (isCurrentUser) ...[
                  paddedDivider(),
                  // Account section
                  titleText(Strings.account),
                  const SizedBox(height: 10),
                  button(
                    backgroundColor: Colors.red.shade400,
                    color: Colors.white,
                    onPress: () {
                      ref.read(authStateProvider.notifier).logOut();
                    },
                    text: Strings.logout,
                  )
                ],

                paddedDivider(),
                // About section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    titleText(Strings.aboutMe),
                    button(
                        backgroundColor: Colors.white,
                        icon: Icons.edit,
                        onPress: () async {
                          // Navigate to edit profile page
                          final updatedBio = await TextUpdateDialogModel(
                            previousText: '',
                            title: Strings.letPeopleKnowAboutYou,
                          ).present(context);
                          if (updatedBio != null) {
                            ref
                                .read(userProfileUpdateProvider.notifier)
                                .updateBio(updatedBio);
                          }
                        }),
                  ],
                ),
                const SizedBox(height: 10),
                regularText(user.bio),
                paddedDivider(),
                // Favourite tags
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    titleText(Strings.favoriteTags),
                    if (isCurrentUser)
                      button(
                          backgroundColor: Colors.white,
                          color: Colors.white,
                          onPress: () async {
                            // Add tag
                            final allTags =
                                ref.watch(creativeFieldListProvider);
                            final toAdd = await AddFavouriteDialog(
                              allTags: allTags,
                              title: Strings.favoriteTags,
                            ).present(context);
                            print(toAdd);
                            if (toAdd == null) {
                              return;
                            }
                            final tags = toAdd.toList() as List<String>;
                            final added = await ref
                                .read(userProfileUpdateProvider.notifier)
                                .updateFavourites(tags);
                            print(added);
                          },
                          icon: Icons.edit)
                  ],
                ),

                // tags
                Wrap(
                  children: [
                    ...user.favouriteTags
                        .map((e) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: button(
                                  text: e,
                                  onPress: () {},
                                  backgroundColor: Colors.lightBlue.shade100),
                            ))
                        .toList()
                  ],
                ),

                // bottom space
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                )
              ],
            ),
          ),
        );
      },
      error: (e, st) =>
          searchNotFoundWithTextAnimationView(text: Strings.userNotFound),
      loading: () => profileSearchLoadingAnimationView(),
    );
  }
}
