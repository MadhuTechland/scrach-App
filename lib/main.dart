import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Scratch App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: RouteHelper.initial,  // Set the initial route if needed
      getPages: RouteHelper.routes,
      debugShowCheckedModeBanner: false,
      home: const OnboardingScreen(), // or LoginScreen if onboarding is done
    );
  }
}
