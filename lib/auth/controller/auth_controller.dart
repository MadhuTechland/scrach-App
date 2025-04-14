import 'package:get/get.dart';
import 'package:scratch_app/core/models/user_model.dart';
import 'dart:convert';
import 'package:scratch_app/data/repository/auth_repo.dart';

class AuthController extends GetxController {
  final AuthRepo authRepo;
  bool isLoading = false;
  User? user;

  AuthController({required this.authRepo});

  Future<bool> login(String usernameOrEmail, String password) async {
    isLoading = true;
    update();

    final response = await authRepo.login(usernameOrEmail, password);
    isLoading = false;
    update();

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['status'] == true) {
      final token = data['token'];
      final userJson = data['user'];

      // ✅ Save token locally
      await authRepo.saveToken(token);

      // ✅ Save user data in memory or local storage
      user = User.fromJson(userJson);

      print("Login successful! Token: $token");
      return true;
    } else if (data['res'] == 'Registration pending.') {
      Get.toNamed('/otp', arguments: {'email': usernameOrEmail});
      return false;
    } else {
      Get.snackbar('Login Failed', data['res'] ?? 'Something went wrong');
      return false;
    }
  }
}
