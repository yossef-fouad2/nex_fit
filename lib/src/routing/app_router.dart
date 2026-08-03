import 'package:go_router/go_router.dart';
import 'package:nex_fit/src/routing/global_navigator.dart';
import 'package:nex_fit/src/routing/app_routes.dart';

import 'package:nex_fit/src/ui/auth/login_screen.dart';
import 'package:nex_fit/src/ui/auth/signup_screen.dart';
import 'package:nex_fit/src/ui/auth/forgot_password_screen.dart';

import 'package:nex_fit/src/ui/home/home_page.dart';
import 'package:nex_fit/src/ui/onboarding/onboarding_page.dart';

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.onboarding,
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutes.onboarding,
      name: 'onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.signup,
      name: 'signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      name: 'forgotPassword',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
  ],
);
