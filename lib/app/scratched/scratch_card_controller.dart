import 'package:get/get.dart';
import 'package:scratch_app/core/models/scratch_card_model.dart';
import 'package:scratch_app/data/provider/api_client.dart';
import 'package:scratch_app/data/repository/scratch_repo.dart';
import 'package:share_plus/share_plus.dart';

class ScratchCardController extends GetxController {
  final ScratchCardRepo scratchCardRepo;

  ScratchCardController({required this.scratchCardRepo});

  var scratchedCards = <ScratchCard>[].obs;
  var unscratchedCards = <ScratchCard>[].obs;
  var isLoading = true.obs;
  int get totalCards => scratchedCards.length + unscratchedCards.length;

  void loadScratchCards(int userId) async {
    try {
      isLoading.value = true;
      final data = await scratchCardRepo.getUserScratchCards(userId);
      scratchedCards.value = data['scratched']!;
      unscratchedCards.value = data['unscratched']!;
    } catch (e) {
      print("Error loading scratch cards: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsScratched(int cardId) async {
    try {
      await scratchCardRepo.markAsScratched(cardId);
    } catch (e) {
      print('Error marking card as scratched: $e');
    }
  }

  void shareUnscratchedCard(card) {
    print("🟡 Sharing card: ${card.name}");
    final baseUrl = Get.find<ApiClient>().appBaseUrl;
    final imageUrl = card.image != null ? "$baseUrl/${card.image}" : '';
    final message = '''
Hey! Check out this scratch card 🎉

${card.name ?? 'Scratch Card'}
You can win amazing rewards!

${imageUrl.isNotEmpty ? 'Image: $imageUrl' : ''}
''';

    Share.share(message);
  }
}
