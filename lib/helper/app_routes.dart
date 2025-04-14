import 'dart:convert';
import 'package:get/get.dart';
import 'package:scratch_app/app/dashboard/dashboard_screen.dart';
import 'package:scratch_app/app/home/home_screen.dart';
import 'package:scratch_app/app/onboarding/view/onboarding_screen.dart';
import 'package:scratch_app/app/scratched/scratched_screen.dart';
import 'package:scratch_app/app/unscratched/unscratched_screen.dart';
import 'package:scratch_app/auth/view/otp_verification_screen.dart';
import 'package:scratch_app/auth/view/sign_in_screen.dart';

class RouteHelper {
  static const String initial = '/';
  static const String splash = '/splash';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String otp = '/otp';
  static const String home = '/homescreen';
  static const String scratched = '/scratched';
  static const String unScratched = '/unscratched';

  static List<GetPage> routes = [
    GetPage(name: initial, page: () => const OnboardingScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: dashboard, page: () => const DashboardScreen()),
    GetPage(name: home, page: () => const HomeScreen()),
    GetPage(name: scratched, page: () => const ScratchedScreen()),
    GetPage(name: unScratched, page: () => UnscratchedScreen()),
    GetPage(
    name: otp,
    page: () => OtpVerificationScreen(email: Get.arguments['email']),
  ),
    // Add splash if needed
  ];
  }
