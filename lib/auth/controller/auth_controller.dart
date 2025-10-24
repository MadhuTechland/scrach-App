import 'package:get/get.dart';
import 'package:scratch_app/core/models/user_model.dart';
import 'dart:convert';
import 'package:scratch_app/data/repository/auth_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final AuthRepo authRepo;
  bool isLoading = false;
  User? user;

  AuthController({required this.authRepo});

  @override
  void onInit() {
    super.onInit();
    loadUserFromPrefs(); // ✅ Load user on controller init
  }

  Future<void> saveUserToPrefs(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(user.toJson()));
    this.user = user;
    update();
  }

  Future<void> loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user');
    if (userData != null) {
      user = User.fromJson(jsonDecode(userData));
      update();
    }
  }

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


      // ✅ Save user to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'user', jsonEncode(userJson)); // 👈 store raw API data
      user = User.fromJson(userJson);

      final keys = prefs.getKeys();
      for (String key in keys) {
        print('[$key] => ${prefs.get(key)}');
      }

      print("Saving user to prefs: ${jsonEncode(user!.toJson())}");
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

  Future<bool> checkLoginStatus() async {
    final token = await authRepo.getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all saved data
    user = null; // Clear the user in memory
    update(); // Notify UI

    Get.offAllNamed('/login'); // Navigate to login screen
  }
}
