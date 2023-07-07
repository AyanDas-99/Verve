import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/auth/providers/auth_state_provider.dart';
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
                child: Text('bar 2'),
              ),
            ),
            const CurrentUserProfileView(),
          ],
        ),
      ),
    );
  }
}
