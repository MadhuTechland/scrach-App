import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:scratch_app/core/models/scratch_card_model.dart';
import 'package:scratch_app/data/provider/api_client.dart';

class ScratchCardRepo {
  final ApiClient apiClient;

  ScratchCardRepo({required this.apiClient});

  Future<Map<String, List<ScratchCard>>> getUserScratchCards(int userId) async {
    final response = await http.get(Uri.parse('${apiClient.appBaseUrl}/api/user/$userId/scratch-cards'));
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
