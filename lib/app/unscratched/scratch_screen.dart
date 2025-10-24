import 'package:flutter/material.dart';
import 'package:flutter_scratcher/widgets.dart';
import 'package:get/get.dart';
import 'package:scratch_app/app/scratched/scratch_card_controller.dart';
import 'package:scratch_app/auth/controller/auth_controller.dart';
import 'package:scratch_app/core/models/scratch_card_model.dart';
import 'package:scratch_app/data/provider/api_client.dart';

class ScratchCardScreen extends StatelessWidget {
  final ScratchCard scratchCard;
  const ScratchCardScreen({super.key, required this.scratchCard});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ScratchCardController>();
    final authController = Get.find<AuthController>();

    final userId = authController.user?.id;
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;

    final double cardSize = mediaWidth * 0.7; // 70% of screen width for a square

    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: SizedBox(
                width: cardSize,
                height: cardSize,
                child: RepaintBoundary(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Scratcher(
                      brushSize: 50,
                      threshold: 50,
                      color: Colors.red,
                      onThreshold: () async {
                        final cardId = scratchCard.id;
                        await controller.markAsScratched(cardId);
                        controller.loadScratchCards(userId!);
                        Get.back();

                        // Bottom sheet
                        Get.bottomSheet(
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "🎉 Congratulations!",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(
                                    '${Get.find<ApiClient>().appBaseUrl}/${scratchCard.image}',
                                    height: mediaHeight * 0.2,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(Icons.error),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  "You’ve just scratched a reward card!",
                                  style: TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () => Get.back(),
                                    child: const Text("Awesome!"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          isDismissible: true,
                          enableDrag: true,
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: scratchCard.image != null
                              ? DecorationImage(
                                  image: NetworkImage(
                                    '${Get.find<ApiClient>().appBaseUrl}/${scratchCard.image}',
                                  ),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: scratchCard.image == null
                            ? const Center(child: Icon(Icons.image_not_supported))
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: mediaHeight * 0.2,
            padding: EdgeInsets.symmetric(
              horizontal: mediaWidth * 0.05,
              vertical: mediaHeight * 0.025,
            ),
            decoration: BoxDecoration(
              color: Colors.indigo[900],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Image.asset('assets/images/logo.jpg', height: mediaHeight * 0.05),
                    const SizedBox(width: 8),
                    const Text(
                      'Gift card',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Rewarded for scratching a card in nudeal',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
