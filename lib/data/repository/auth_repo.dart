import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:scratch_app/data/provider/api_client.dart';
import 'package:scratch_app/utils/app_constants.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:get/get.dart' hide Response, MultipartFile;

class AuthRepo {
  final ApiClient apiClient;
  var isLoading = false.obs;

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

  Future<Response> updateProfile({
    required String token,
    required String firstName,
    required String lastName,
    required String phone,
    required String gender,
    required String companyName,
    File? profilePic,
    File? companyLogo,
  }) async {
    isLoading.value = true;

    // Create request headers
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data',
    };

    var request =
        MultipartRequest('POST', Uri.parse(AppConstants.updateProfileUrl));
    request.headers.addAll(headers);
    request.fields['first_name'] = firstName;
    request.fields['last_name'] = lastName;
    request.fields['phone'] = phone;
    request.fields['gender'] = gender;
    request.fields['company_name'] = companyName;

    if (profilePic != null) {
      request.files
          .add(await MultipartFile.fromPath('profile_pic', profilePic.path));
    }
    if (companyLogo != null) {
      request.files
          .add(await MultipartFile.fromPath('company_logo', companyLogo.path));
    }

    final streamedResponse = await request.send();
    final response = await Response.fromStream(streamedResponse);

    isLoading.value = false;

    return response;
  }

  Future<http.StreamedResponse> uploadSliderImages(List<File> images) async {
    return await apiClient.postMultipart(
      uri: AppConstants.uploadPromotionsUrl,
      fields: {}, // No text fields needed in your case
      files: images,
    );
  }

  Future<int> getCustomSliderCount() async {
  final response = await apiClient.getData(AppConstants.sliderCount); // create proper route
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['count'] ?? 0;
  } else {
    throw Exception("Failed to get slider count");
  }
}
}
