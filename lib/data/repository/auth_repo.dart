import 'package:scratch_app/data/provider/api_client.dart';
import 'package:scratch_app/utils/app_constants.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final ApiClient apiClient;

  AuthRepo({required this.apiClient});

  Future<Response> login(String usernameOrEmail, String password) async {
    return await apiClient.postData(AppConstants.loginUri, {
      'username_or_email': usernameOrEmail,
      'password': password,
    });
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
