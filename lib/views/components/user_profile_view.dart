import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/auth/providers/auth_state_provider.dart';
import 'package:verve/state/friends/providers/add_and_remove_friends_provider.dart';
import 'package:verve/state/friends/providers/is_friend_provider.dart';
import 'package:verve/state/posts/providers/posts_by_user_id_provider.dart';
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
import 'package:verve/views/components/dialogs/get_confirmation_dialog_model.dart';
import 'package:verve/views/components/dialogs/log_out_dialog.dart';
import 'package:verve/views/components/dialogs/text_update_dialog_model.dart';
import 'package:verve/views/components/friends_list_view.dart';
import 'package:verve/views/components/padded_divider.dart';
import 'package:verve/views/components/post/post_tile.dart';
import 'package:verve/views/components/snackbars/failure_snackbar.dart';
import 'package:verve/views/components/snackbars/snackbar_model.dart';
import 'package:verve/views/components/snackbars/success_snackbar.dart';
import 'package:verve/views/components/text/regular_text.dart';
import 'package:verve/views/components/text/title_text.dart';
import 'package:verve/views/constants/strings.dart';
import 'package:verve/views/responsive/responsive.dart';

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
    final userPosts = ref.watch(postsByUserIdProvider(userId));
    final isFriend = ref.watch(isFriendProvider(userId));

    return user.when(
      data: (user) {
        final bool isCurrentUser = myUserId == userId;
        return Scaffold(
          appBar: (isCurrentUser)
              ? null
              : AppBar(
                  centerTitle: true,
                  title: titleText("${user!.displayName}'s Profile"),
                ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User detail section

                  if (!Responsive.isSmallPhone(context))
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: (!isCurrentUser)
                              ? null
                              : () {
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
                                fontFamily:
                                    GoogleFonts.josefinSans().fontFamily,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            // Show email address only if isCurrentUser
                            if (isCurrentUser)
                              Text(
                                user.email,
                                style: TextStyle(
                                  fontFamily:
                                      GoogleFonts.josefinSans().fontFamily,
                                  fontSize: 12,
                                ),
                              ),

                            // Show edit button if isCurrentUser is true
                            // Edit user name button
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
                                        final isNameUpdated = await ref
                                            .read(userProfileUpdateProvider
                                                .notifier)
                                            .updateName(updatedName);

                                        if (isNameUpdated && context.mounted) {
                                          SuccessSnackBar(Strings
                                                  .nameUpdatedSuccessfully)
                                              .show(context);
                                        } else if (context.mounted) {
                                          FailureSnackBar(
                                                  Strings.couldNotUpdateName)
                                              .show(context);
                                        }
                                      }
                                    }),
                              ),

                            if (!isCurrentUser)
                              isFriend.when(
                                data: (isFriend) {
                                  return (isFriend)
                                      ? button(
                                          backgroundColor: Colors.red,
                                          text: Strings.removeFriend,
                                          color: Colors.white,
                                          onPress: () async {
                                            final isRemoved = await ref
                                                .read(
                                                    addAndRemoveFriendsProvider
                                                        .notifier)
                                                .removeFriend(userId);

                                            if (context.mounted) {
                                              if (isRemoved) {
                                                SuccessSnackBar(Strings
                                                        .removedFromFriendList)
                                                    .show(context);
                                              } else {
                                                FailureSnackBar(Strings
                                                        .couldNotRemoveFromFriendList)
                                                    .show(context);
                                              }
                                            }
                                          },
                                        )
                                      : button(
                                          backgroundColor: Colors.white,
                                          text: Strings.addFriend,
                                          onPress: () async {
                                            final isAdded = await ref
                                                .read(
                                                    addAndRemoveFriendsProvider
                                                        .notifier)
                                                .addFriend(userId);

                                            if (context.mounted) {
                                              if (isAdded) {
                                                SuccessSnackBar(
                                                        Strings.addedAsFriend)
                                                    .show(context);
                                              } else {
                                                FailureSnackBar(Strings
                                                        .couldNotAddAsFriend)
                                                    .show(context);
                                              }
                                            }
                                          });
                                },
                                error: (e, st) =>
                                    regularText('error loading button'),
                                loading: () =>
                                    const CircularProgressIndicator(),
                              ),
                          ],
                        ),
                      ],
                    ),

                  if (Responsive.isSmallPhone(context))
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: (!isCurrentUser)
                                ? null
                                : () {
                                    ref
                                        .read(
                                            userProfileUpdateProvider.notifier)
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
                            children: [
                              Text(
                                user.displayName,
                                style: TextStyle(
                                  fontFamily:
                                      GoogleFonts.josefinSans().fontFamily,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              // Show email address only if isCurrentUser
                              if (isCurrentUser)
                                Text(
                                  user.email,
                                  style: TextStyle(
                                    fontFamily:
                                        GoogleFonts.josefinSans().fontFamily,
                                    fontSize: 12,
                                  ),
                                ),

                              // Show edit button if isCurrentUser is true
                              // Edit user name button
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
                                          final isNameUpdated = await ref
                                              .read(userProfileUpdateProvider
                                                  .notifier)
                                              .updateName(updatedName);

                                          if (isNameUpdated &&
                                              context.mounted) {
                                            SuccessSnackBar(Strings
                                                    .nameUpdatedSuccessfully)
                                                .show(context);
                                          } else if (context.mounted) {
                                            FailureSnackBar(
                                                    Strings.couldNotUpdateName)
                                                .show(context);
                                          }
                                        }
                                      }),
                                ),

                              if (!isCurrentUser)
                                isFriend.when(
                                  data: (isFriend) {
                                    return (isFriend)
                                        ? button(
                                            backgroundColor: Colors.red,
                                            text: Strings.removeFriend,
                                            color: Colors.white,
                                            onPress: () async {
                                              final isRemoved = await ref
                                                  .read(
                                                      addAndRemoveFriendsProvider
                                                          .notifier)
                                                  .removeFriend(userId);

                                              if (context.mounted) {
                                                if (isRemoved) {
                                                  SuccessSnackBar(Strings
                                                          .removedFromFriendList)
                                                      .show(context);
                                                } else {
                                                  FailureSnackBar(Strings
                                                          .couldNotRemoveFromFriendList)
                                                      .show(context);
                                                }
                                              }
                                            },
                                          )
                                        : button(
                                            backgroundColor: Colors.white,
                                            text: Strings.addFriend,
                                            onPress: () async {
                                              final isAdded = await ref
                                                  .read(
                                                      addAndRemoveFriendsProvider
                                                          .notifier)
                                                  .addFriend(userId);

                                              if (context.mounted) {
                                                if (isAdded) {
                                                  SuccessSnackBar(
                                                          Strings.addedAsFriend)
                                                      .show(context);
                                                } else {
                                                  FailureSnackBar(Strings
                                                          .couldNotAddAsFriend)
                                                      .show(context);
                                                }
                                              }
                                            });
                                  },
                                  error: (e, st) =>
                                      regularText('error loading button'),
                                  loading: () =>
                                      const CircularProgressIndicator(),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),

                  // Friends count
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  FriendsListView(user.friendsList)));
                    },
                    child: regularText('${user!.friendsList.length} friends'),
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
                      onPress: () async {
                        if (context.mounted) {
                          final shouldLogOut =
                              await LogOutDialog().present(context);
                          if (shouldLogOut) {
                            ref.read(authStateProvider.notifier).logOut();
                          }
                        }
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
                      if (isCurrentUser)
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
                                final isUpdated = await ref
                                    .read(userProfileUpdateProvider.notifier)
                                    .updateBio(updatedBio);

                                if (isUpdated && context.mounted) {
                                  SuccessSnackBar(Strings.bioUpdateSuccessfully)
                                      .show(context);
                                } else if (context.mounted) {
                                  FailureSnackBar(Strings.couldNotUpdateBio)
                                      .show(context);
                                }
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
                              if (toAdd == null) {
                                return;
                              }
                              final tags = toAdd.toList() as List<String>;
                              final isUpdated = await ref
                                  .read(userProfileUpdateProvider.notifier)
                                  .updateFavourites(tags);

                              if (isUpdated && context.mounted) {
                                SuccessSnackBar(Strings.updatedFavouriteTags)
                                    .show(context);
                              } else if (context.mounted) {
                                FailureSnackBar(
                                        Strings.couldNotUpdateFavouriteTags)
                                    .show(context);
                              }
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

                  paddedDivider(),

                  // user posts
                  titleText(Strings.posts),

                  const SizedBox(
                    height: 10,
                  ),
                  ...userPosts.when(
                    data: (posts) => (posts.isNotEmpty)
                        ? posts
                            .map((post) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: PostTile(
                                    post,
                                  ),
                                ))
                            .toList()
                        : [
                            SizedBox(
                              height: 100,
                              child: searchNotFoundWithTextAnimationView(
                                  text: Strings.youHaventPostedYet),
                            )
                          ],
                    error: (error, stackTrace) => [
                      SizedBox(
                        height: 100,
                        child: searchNotFoundWithTextAnimationView(
                            text: Strings.youHaventPostedYet),
                      )
                    ],
                    loading: () => [const CircularProgressIndicator()],
                  ),

                  // bottom space
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  )
                ],
              ),
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
