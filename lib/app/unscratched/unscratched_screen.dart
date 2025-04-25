import 'package:flutter/material.dart';
import 'package:flutter_scratcher/widgets.dart';
import 'package:get/get.dart';
import 'package:scratch_app/app/home/notification_screen.dart';
import 'package:scratch_app/app/scratched/scratch_card_controller.dart';
import 'package:scratch_app/data/provider/api_client.dart';
import 'package:scratch_app/data/repository/scratch_repo.dart';

class UnscratchedScreen extends StatelessWidget {
  const UnscratchedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ScratchCardController>();
    controller.loadScratchCards(2); // Replace with dynamic userId

    final media = MediaQuery.of(context).size;
    final height = media.height;
    final width = media.width;

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return Scaffold(
        body: Stack(
          children: [
            // Gradient Background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.redAccent, Colors.yellowAccent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            // Main Content
            Column(
              children: [
                // Custom AppBar
                Container(
                  height: height * 0.18,
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.06, // ~24 on 400px width
                    vertical: height * 0.025, // ~20 on 800px height
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: height * 0.0625), // ~50 on 800px height
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Unscratched cards",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: height * 0.025, // ~20
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(() => const NotificationListScreen());
                            },
                            child: Center(
                              child: Image.asset(
                                'assets/images/notification_image.png',
                                height: height * 0.05, // ~40 on 800px height
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Grid of Unscratched Cards
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      controller.loadScratchCards(2); // Refresh data
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: controller.unscratchedCards.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Card(
                                    color: Colors.grey[300],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 4,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Total Cards: ${controller.totalCards}",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "Scratched Cards: ${controller.scratchedCards.length}",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "Unscratched Cards: ${controller.unscratchedCards.length}",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Expanded(
                                  child: GridView.builder(
                                    itemCount:
                                        controller.unscratchedCards.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 1,
                                    ),
                                    itemBuilder: (context, index) {
                                      final card =
                                          controller.unscratchedCards[index];
                                      return RepaintBoundary(
                                        child: Scratcher(
                                          brushSize: 50,
                                          threshold: 50,
                                          color: Colors.red,
                                          onThreshold: () async {
                                            final cardId = card.id;
                                            await controller
                                                .markAsScratched(cardId);
                                            controller.loadScratchCards(2);

                                            // 🎉 Show Congratulations popup with scratched image
                                            Get.defaultDialog(
                                              title: "🎉 Congratulations!",
                                              titleStyle: const TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              content: Column(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    child: Image.network(
                                                      '${Get.find<ApiClient>().appBaseUrl}/${card.image}',
                                                      height: 150,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context,
                                                              error,
                                                              stackTrace) =>
                                                          const Icon(
                                                              Icons.error),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  const Text(
                                                    "You’ve just scratched a reward card!",
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SizedBox(height: 10),
                                                  ElevatedButton(
                                                    onPressed: () => Get.back(),
                                                    child:
                                                        const Text("Awesome!"),
                                                  ),
                                                ],
                                              ),
                                              radius: 20,
                                              backgroundColor: Colors.white,
                                              barrierDismissible: false,
                                            );
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              image: card.image != null
                                                  ? DecorationImage(
                                                      image: NetworkImage(
                                                        '${Get.find<ApiClient>().appBaseUrl}/${card.image}',
                                                      ),
                                                      fit: BoxFit.cover,
                                                    )
                                                  : null,
                                            ),
                                            child: card.image == null
                                                ? const Center(
                                                    child: Icon(Icons
                                                        .image_not_supported))
                                                : null,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            )
                          : const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Oops! You don’t have any scratch cards 😢",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "Stay tuned for upcoming rewards!",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _scratchedCardContent(String? imageUrl) {
    final fullImageUrl = imageUrl != null
        ? '${Get.find<ApiClient>().appBaseUrl}/$imageUrl'
        : null;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: fullImageUrl != null
            ? Image.network(
                fullImageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(Icons.error),
                ),
              )
            : const Center(child: Icon(Icons.image_not_supported)),
      ),
    );
  }
}
