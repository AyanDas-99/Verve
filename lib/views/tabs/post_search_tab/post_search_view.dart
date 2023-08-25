import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/views/components/padded_divider.dart';
import 'package:verve/views/components/searched_posts_list_view.dart';
import 'package:verve/views/components/text/regular_text.dart';
import 'package:verve/views/constants/strings.dart';

class PostSearchView extends HookConsumerWidget {
  const PostSearchView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchTerm = useState('');
    final searchController = useTextEditingController();

    useEffect(() {
      void listener() => searchTerm.value = searchController.text;

      searchController.addListener(listener);

      return () {
        searchController.removeListener(listener);
      };
    }, [searchController]);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5,
          )
        ]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                    labelText: Strings.enterSearchTerm,
                    border: const OutlineInputBorder()),
              ),
              paddedDivider(height: 20),
              if (searchTerm.value.isNotEmpty) ...[
                regularText("${Strings.youSearchedFor} '${searchTerm.value}'"),
                paddedDivider(height: 20),
              ],
              SearchedPostsListView(searchTerm.value),
            ],
          ),
        ),
      ),
    );
  }
}
