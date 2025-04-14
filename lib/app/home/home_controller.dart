// file: lib/data/controller/promotion_controller.dart

import 'package:get/get.dart';
import 'package:scratch_app/core/models/promotion_model.dart';
import 'package:scratch_app/data/provider/api_client.dart';

class PromotionController extends GetxController {
  final ApiClient apiClient;

  PromotionController({required this.apiClient});

  var promotions = <Promotion>[];
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchPromotions();
    super.onInit();
  }

  // Method to fetch promotions
  Future<void> fetchPromotions() async {
    try {
      isLoading(true);
      promotions = await apiClient.getPromotions();
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading(false);
    }
  }
}
