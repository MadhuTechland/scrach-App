import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:scratch_app/auth/controller/auth_controller.dart';
import 'package:scratch_app/core/models/scratch_card_model.dart';
import 'package:scratch_app/data/provider/api_client.dart';

class ScratchCardRepo {
  final ApiClient apiClient;

  ScratchCardRepo({required this.apiClient});

  Future<Map<String, List<ScratchCard>>> getUserScratchCards(int userId) async {

    final userId = Get.find<AuthController>().user?.id;
if (userId != null) {
  print("userid was null $userId");
}
  final url = Uri.parse('${apiClient.appBaseUrl}/api/user/$userId/scratch-cards');
  final response = await http.get(url);

  print("📤 Requested URL: $url");
  print("📥 Response Status Code: ${response.statusCode}");
  print("📥 Response Body: ${response.body}");

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    List<ScratchCard> scratched = (data['scratched'] as List)
        .map((e) => ScratchCard.fromJson(e))
        .toList();
    List<ScratchCard> unscratched = (data['unscratched'] as List)
        .map((e) => ScratchCard.fromJson(e))
        .toList();
    return {'scratched': scratched, 'unscratched': unscratched};
  } else {
    throw Exception('Failed to load scratch cards');
  }
}


  Future<void> markAsScratched(int cardId) async {
  final response = await http.post(
    Uri.parse('${apiClient.appBaseUrl}/api/scratch-card/$cardId/mark-scratched'),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to mark card as scratched');
  }
}

}
