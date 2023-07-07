// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/user_info/providers/current_user_provider.dart';
import 'package:verve/views/components/button.dart';
import 'package:verve/views/components/text/regular_text.dart';
import 'package:verve/views/constants/strings.dart';

@immutable
class AddFavouriteDialog<Iterable> {
  final String title;
  final Iterable allTags;
  const AddFavouriteDialog({
    required this.title,
    required this.allTags,
  });
}

final toBeAddedListProvider = StateProvider.autoDispose<Set<String>>((ref) {
  final favs = ref.watch(currentUserProvider)!.favouriteTags;
  return Set.from(favs);
});

extension Present<String> on AddFavouriteDialog {
  Future<Set?> present(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Consumer(builder: (context, WidgetRef ref, child) {
            final toBeAdded = ref.watch(toBeAddedListProvider);
            return AlertDialog(
              title: regularText(
                title.toString(),
                fontSize: 20,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                        border: Border.symmetric(
                      vertical: BorderSide(),
                      horizontal: BorderSide(),
                    )),
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.25,
                    ),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          regularText(Strings.selectedTags),
                          ...toBeAdded
                              .map((tag) => button(
                                    text: tag,
                                    backgroundColor: Colors.blueAccent.shade200,
                                    icon: Icons.cancel,
                                    onPress: () {
                                      ref
                                          .read(toBeAddedListProvider.notifier)
                                          .update((state) => state
                                              .where(
                                                  (element) => element != tag)
                                              .toSet());
                                    },
                                  ))
                              .toList()
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.25,
                      maxWidth: MediaQuery.of(context).size.width * 0.8,
                    ),
                    child: SingleChildScrollView(
                      child: Wrap(
                        children: [
                          ...allTags.map((tag) => button(
                                text: tag,
                                backgroundColor: Colors.red.shade200,
                                onPress: () {
                                  ref
                                      .read(toBeAddedListProvider.notifier)
                                      .update((state) => {...state, tag});
                                },
                              ))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                button(
                    backgroundColor: Colors.red.shade100,
                    text: Strings.cancel,
                    onPress: () {
                      Navigator.of(context).pop(null);
                    }),
                button(
                  backgroundColor: Colors.purple.shade300,
                  text: Strings.save,
                  color: Colors.white,
                  onPress: () async {
                    Navigator.of(context).pop(toBeAdded);
                  },
                ),
              ],
            );
          });
        });
  }
}
