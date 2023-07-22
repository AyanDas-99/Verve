import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/providers/is_floating_action_visible_provider.dart';
import 'package:verve/views/components/logo/logo_text.dart';
import 'package:verve/views/components/screens/new_post_view.dart';
import 'package:verve/views/tabs/current_user_profile/current_user_profile_view.dart';
import 'package:verve/views/tabs/home_tab/home_tab_view.dart';
import 'package:verve/views/tabs/post_search_tab/post_search_view.dart';

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
                        builder: (context) => const NewPostView(),
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
                      icon: FaIcon(FontAwesomeIcons.houseChimneyWindow),
                    ),
                    Tab(
                      icon: FaIcon(FontAwesomeIcons.magnifyingGlass),
                    ),
                    Tab(
                      icon: FaIcon(FontAwesomeIcons.user),
                    ),
                  ],
                ),
              )
            ],
            body: const TabBarView(
              children: [
                HomeTabView(),
                PostSearchView(),
                CurrentUserProfileView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
