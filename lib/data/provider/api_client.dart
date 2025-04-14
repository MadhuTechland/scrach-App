// file: data/provider/api_client.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:scratch_app/core/models/promotion_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final response = await http.get(Uri.parse(appBaseUrl + '/api/promotions'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'] as List;
      return data.map((item) => Promotion.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load promotions');
    }
  }
}
