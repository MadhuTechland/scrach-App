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

  Future<Map<String, dynamic>> register({
    required String name,
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String dob,
    required String gender,
    required String password,
  }) async {
    final response = await apiClient.postData(
      AppConstants.registerUserUri,
      {
        'name': name,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
        'gender': gender,
        'dob': dob,
        'phone': phone,
        'terms': 'yes',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Register failed with status: ${response.statusCode}');
      return {
        'status': false,
        'res': 'Failed to register. Try again.',
      };
    }
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    final response = await apiClient.postData(
      '/api/verify-otp',
      {
        'phone': phone,
        'otp': otp,
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('OTP verification failed with status: ${response.statusCode}');
      return {
        'status': false,
        'res': 'Failed to verify OTP. Try again.',
      };
    }
  }

  Future<Map<String, dynamic>> verifyRegisterOtp({
    required String phone,
    required String email,
    required String otp,
  }) async {
    final response = await apiClient.postData(
      '/api/verify-register-otp',
      {
        'phone': phone,
        'email': email,
        'otp': otp,
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(
          'Register OTP verification failed with status: ${response.statusCode}');
      return {
        'status': false,
        'res': 'Failed to verify registration OTP. Try again.',
      };
    }
  }

  Future<Map<String, dynamic>> requestOtp(String phone) async {
    try {
      final response = await apiClient.postData(
        '/api/request-otp',
        {'phone': phone},
      );
      print('OTP API response: ${response.body}');
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } catch (e) {
      print('Error in requestOtp: $e');
      return {
        'status': false,
        'res': 'Something went wrong. Please try again later.',
      };
    }
  }

  Future<int> getCustomSliderCount() async {
    final response = await apiClient
        .getData(AppConstants.sliderCount); // create proper route
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['count'] ?? 0;
    } else {
      throw Exception("Failed to get slider count");
    }
  }
}
