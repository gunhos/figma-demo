import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/auth/sign_in_screen.dart';

final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, _) => const SignInScreen()),
  ],
);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Dating App',
      routerConfig: _router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE94057)),
        useMaterial3: true,
      ),
    );
  }
}
