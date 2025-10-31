// file: data/provider/api_client.dart

import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:scratch_app/core/models/promotion_model.dart';
import 'package:scratch_app/data/repository/auth_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/controller/auth_controller.dart';

class ApiClient {
  final String appBaseUrl;
  final SharedPreferences sharedPreferences;

  ApiClient({
    required this.appBaseUrl,
    required this.sharedPreferences,
  });

  Future<http.Response> postData(String uri, Map<String, dynamic> body) async {
    final url = Uri.parse(appBaseUrl + uri);
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
  }

  Future<List<Promotion>> getPromotions() async {
    final userId = Get.find<AuthController>().user?.id;

    final response = await http.get(Uri.parse(appBaseUrl + '/api/promotions/${userId}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'] as List;
      return data.map((item) => Promotion.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load promotions');
    }
  }

  Future<http.StreamedResponse> postMultipart({
  required String uri,
  required Map<String, String> fields,
  required List<File> files,
  String fieldName = 'images[]',
}) async {
  final url = Uri.parse(appBaseUrl + uri);
  final request = http.MultipartRequest('POST', url);

  final authRepo = AuthRepo(apiClient: this);
  final token = await authRepo.getToken(); // Fetch token from instance
  request.headers['Authorization'] = 'Bearer $token';
  request.headers['Accept'] = 'application/json';

  // Add text fields
  fields.forEach((key, value) {
    request.fields[key] = value;
  });

  // Add image files
  for (File image in files) {
    final mimeType = lookupMimeType(image.path);
    final mediaType = mimeType != null ? MediaType.parse(mimeType) : null;

    request.files.add(await http.MultipartFile.fromPath(
      fieldName,
      image.path,
      contentType: mediaType,
    ));
  }

  return await request.send();
}

Future<http.Response> getData(String uri) async {
  final url = Uri.parse(appBaseUrl + uri);
  final token = sharedPreferences.getString('token');

  final headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
    if (token != null) HttpHeaders.authorizationHeader: 'Bearer $token',
  };

  final response = await http.get(url, headers: headers);
  return response;
}

}
