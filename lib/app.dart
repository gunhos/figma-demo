import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/auth/sign_in_screen.dart';
import 'features/home/home_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/profile/profile_details_screen.dart';
import 'features/profile/i_am_screen.dart';
import 'features/profile/friends_screen.dart';
import 'features/profile/passions_screen.dart';
import 'features/profile/phone_number_screen.dart';
import 'features/profile/verify_code_screen.dart';
import 'features/profile/notifications_screen.dart';

final _router = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(path: '/onboarding', builder: (context, _) => const OnboardingScreen()),
    GoRoute(path: '/sign-in', builder: (context, _) => const SignInScreen()),
    GoRoute(path: '/profile-details', builder: (context, _) => const ProfileDetailsScreen()),
    GoRoute(path: '/i-am', builder: (context, _) => const IAmScreen()),
    GoRoute(path: '/friends', builder: (context, _) => const FriendsScreen()),
    GoRoute(path: '/passions', builder: (context, _) => const PassionsScreen()),
    GoRoute(path: '/phone-number', builder: (context, _) => const PhoneNumberScreen()),
    GoRoute(path: '/verify-code', builder: (context, _) => const VerifyCodeScreen()),
    GoRoute(path: '/notifications', builder: (context, _) => const NotificationsScreen()),
    GoRoute(path: '/home', builder: (context, _) => const HomeScreen()),
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
