// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  Future<Set?> present(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return Consumer(builder: (context, WidgetRef ref, child) {
            final toBeAdded = ref.watch(toBeAddedListProvider);
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: regularText(
                title.toString(),
                fontSize: 20,
              ),
              content: SizedBox(
                height: 300,
                child: SingleChildScrollView(
                  child: Wrap(
                    children: (allTags as Iterable<String>)
                        .map((tag) => Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: button(
                                  backgroundColor: Colors.lightBlue.shade100,
                                  text: tag.toString(),
                                  icon: (toBeAdded.contains(tag))
                                      ? (FontAwesomeIcons.check)
                                      : null,
                                  onPress: () {
                                    if (toBeAdded.contains(tag)) {
                                      ref
                                          .read(toBeAddedListProvider.notifier)
                                          .update((state) => state
                                              .where(
                                                  (element) => element != tag)
                                              .toSet());
                                    } else {
                                      ref
                                          .read(toBeAddedListProvider.notifier)
                                          .update((state) => {
                                                ...state,
                                                tag.toString(),
                                              });
                                    }
                                  }),
                            ))
                        .toList(),
                  ),
                ),
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
