import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scratch_app/app/dashboard/dashboard_screen.dart';
import 'package:scratch_app/app/profile/edit_profile_controller.dart';
import 'package:scratch_app/auth/view/sign_in_screen.dart';
import 'package:scratch_app/data/provider/api_client.dart';
import 'package:scratch_app/helper/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:scratch_app/app/onboarding/view/onboarding_screen.dart';
import 'package:scratch_app/auth/controller/auth_controller.dart';
import 'package:scratch_app/data/repository/auth_repo.dart';
import 'package:scratch_app/utils/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();

  Get.put(sharedPreferences);
  Get.put(ApiClient(appBaseUrl: AppConstants.baseUrl, sharedPreferences: sharedPreferences));
  Get.put(AuthRepo(apiClient: Get.find()));
  Get.put(AuthController(authRepo: Get.find()));
  Get.lazyPut(() => EditProfileController(Get.find<AuthRepo>()));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X as a baseline
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Scratch App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          initialRoute: RouteHelper.initial,
          getPages: RouteHelper.routes,
          debugShowCheckedModeBanner: false,
          home: FutureBuilder<bool>(
            future: authController.checkLoginStatus(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.data == true) {
                return const DashboardScreen();
              } else {
                return const OnboardingScreen();
              }
            },
          ),
        );
      },
    );
  }
}