import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/auth/models/auth_result.dart';
import 'package:verve/state/auth/providers/auth_state_provider.dart';
import 'package:verve/state/auth/providers/is_logged_in_provider.dart';
import 'package:verve/state/providers/is_loading_provider.dart';
import 'package:verve/views/components/loading/loading_view.dart';
import 'package:verve/views/onboarding/onboarding_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Consumer(
          builder: (context, ref, child) {
            // showing loading
            ref.listen(isLoadingProvider, (_, isLoading) {
              if (isLoading) {
                LoadingView.instance().showLoading(context);
              } else {
                LoadingView.instance().hide();
              }
            });

            return ref.watch(authStateProvider).authResult == AuthResult.success
                ? const MyHomePage()
                : const OnBoardingView();
          },
        ));
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer(
          builder: (context, ref, child) => Column(
                children: [
                  ref.watch(isLoadingProvider)
                      ? const CircularProgressIndicator()
                      : const SizedBox(),
                  FaIcon(ref.watch(isLoggedInProvider)
                      ? FontAwesomeIcons.check
                      : FontAwesomeIcons.cross),
                  ElevatedButton(
                    onPressed: () async {
                      final result = await ref
                          .read(authStateProvider.notifier)
                          .loginWithGoogle();
                    },
                    child: Text('login'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await ref.read(authStateProvider.notifier).logOut();
                    },
                    child: Text('logout'),
                  ),
                ],
              )),
    );
  }
}
