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
    loadUserFromPrefs(); 
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
      await prefs.setString('user', jsonEncode(userJson));
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

  Future<bool> requestOtp(String phone) async {
    isLoading = true;
    update();

    final response = await authRepo.requestOtp(phone);
    isLoading = false;
    update();

    if (response['status'] == true) {
      Get.snackbar('Success', response['res'] ?? 'OTP sent successfully');
      // Get.toNamed('/otp', arguments: {
      //   'phone': phone,
      //   'otp': response['otp'].toString(),
      // });
      return true;
    } else {
      Get.snackbar('Error', response['res'] ?? 'Failed to send OTP');
      return false;
    }
  }

  Future<bool> checkLoginStatus() async {
    final token = await authRepo.getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); 
    user = null; 
    update(); 

    Get.offAllNamed('/login'); 
  }

  Future<Map<String, dynamic>> registerUser({
    required String name,
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String dob,
    required String gender,
    required String password,
  }) async {
    isLoading = true;
    update();

    final response = await authRepo.register(
      name: name,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      email: email,
      dob: dob,
      gender: gender,
      password: password,
    );

    isLoading = false;
    update();

    return response;
  }

  Future<bool> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    isLoading = true;
    update();

    final response = await authRepo.verifyOtp(phone: phone, otp: otp);

    isLoading = false;
    update();

    if (response['status'] == true) {
      // ✅ Save user info if returned
      if (response.containsKey('user')) {
        final userJson = response['user'];
        user = User.fromJson(userJson);
        await saveUserToPrefs(user!);
      }

      // ✅ Optionally store token
      if (response.containsKey('token')) {
        final token = response['token'];
        await authRepo.saveToken(token);
        final userJson = response['user'];
        user = User.fromJson(userJson);
        await saveUserToPrefs(user!);
      }

      return true;
    } else {
      Get.snackbar('Error', response['res'] ?? 'Invalid OTP');
      return false;
    }
  }

  Future<bool> verifyRegisterOtp({
    required String phone,
    required String email,
    required String otp,
  }) async {
    isLoading = true;
    update();

    final response = await authRepo.verifyRegisterOtp(
      phone: phone,
      email: email,
      otp: otp,
    );

    isLoading = false;
    update();

    if (response['status'] == true) {
      // ✅ Save user info if provided
      if (response.containsKey('user')) {
        final userJson = response['user'];
        user = User.fromJson(userJson);
        await saveUserToPrefs(user!);
      }
      return true;
    } else {
      Get.snackbar('Error', response['res'] ?? 'Invalid OTP');
      return false;
    }
  }
}
