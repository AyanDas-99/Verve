import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:verve/state/auth/models/auth_result.dart';
import 'package:verve/state/auth/providers/auth_state_provider.dart';
import 'package:verve/state/providers/is_loading_provider.dart';
import 'package:verve/views/components/loading/loading_view.dart';
import 'package:verve/views/main/main_view.dart';
import 'package:verve/views/onboarding/onboarding_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // if (Platform.isAndroid) {
  //   await Firebase.initializeApp();
  // } else {
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyBOwtMBWw-43-XihKeS8KhaHDOD2DpMyJc",
    appId: "1:685199959416:web:755174d6797801c169148d",
    projectId: "verve-f9fb9",
    messagingSenderId: "685199959416",
    storageBucket: "verve-f9fb9.appspot.com",
  ));
  // }
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
                ? const MainView()
                : const OnBoardingView();
          },
        ));
  }
}
