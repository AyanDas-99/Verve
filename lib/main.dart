import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/auth/models/auth_result.dart';
import 'package:verve/state/auth/providers/auth_state_provider.dart';
import 'package:verve/state/auth/providers/is_logged_in_provider.dart';
import 'package:verve/state/providers/is_loading.dart';
import 'package:verve/views/onboarding/onboarding_content_view.dart';
import 'package:verve/views/onboarding/onboarding_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: authState.authResult == AuthResult.success
          ? MyHomePage()
          : OnBoardingView(),
    );
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
