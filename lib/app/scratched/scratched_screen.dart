import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scratch_app/app/home/notification_screen.dart';
import 'package:scratch_app/app/scratched/scratch_card_controller.dart';
import 'package:scratch_app/auth/controller/auth_controller.dart';
import 'package:scratch_app/data/provider/api_client.dart';
import 'package:scratch_app/data/repository/scratch_repo.dart';

class ScratchedScreen extends StatelessWidget {
  const ScratchedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ScratchCardController(
      scratchCardRepo: ScratchCardRepo(apiClient: Get.find()),
    ));
    final authController = Get.find<AuthController>();

    final userId = authController.user?.id;

    // Only load scratch cards if userId is available
    if (userId != null) {
      controller.loadScratchCards(userId); // ✅ dynamic user ID
    } else {
      debugPrint("User ID not found, user might not be logged in");
    }

    final media = MediaQuery.of(context).size;
    final height = media.height;
    final width = media.width;

    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
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
                    horizontal: width * 0.06, // ~24 on 400 width
                    vertical: height * 0.025, // ~20 on 800 height
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
                      SizedBox(height: height * 0.0625), // ~50 on 800 height
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Scratched cards",
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
                                height: height * 0.05, // ~40
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Padding(
                //   padding: const EdgeInsets.all(16.0),
                //   child: Text(
                //     "You have Scratched ${controller.scratchedCards.length} cards",
                //     style: const TextStyle(
                //       fontSize: 18,
                //       fontWeight: FontWeight.bold,
                //       color: Colors.black,
                //     ),
                //   ),
                // ),

                // Grid of Scratched Cards
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      controller.loadScratchCards(userId!); // Refresh data
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GridView.builder(
                          itemCount: controller.scratchedCards.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1,
                          ),
                          itemBuilder: (context, index) {
                            final card = controller.scratchedCards[index];
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: card.image != null
                                  ? Image.network(
                                      '${Get.find<ApiClient>().appBaseUrl}/${card.image}',
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.broken_image,
                                                  size: 50),
                                    )
                                  : const Icon(Icons.image_not_supported,
                                      size: 50),
                            );
                          }),
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
}
