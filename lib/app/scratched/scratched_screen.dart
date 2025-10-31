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
      controller.loadScratchCards(userId);
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
                    horizontal: width * 0.06,
                    vertical: height * 0.025,
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
                      SizedBox(height: height * 0.0625),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Scratched cards",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: height * 0.025,
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
                                height: height * 0.05,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Grid of Scratched Cards
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      controller.loadScratchCards(userId!);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final screenWidth = MediaQuery.of(context).size.width;
                          final screenHeight =
                              MediaQuery.of(context).size.height;

                          // Dynamically set columns based on device width
                          int crossAxisCount = 2;
                          if (screenWidth > 600) {
                            crossAxisCount = 3;
                          } else if (screenWidth > 900) {
                            crossAxisCount = 4;
                          }

                          // Adjust aspect ratio based on height & width
                          double aspectRatio = screenWidth < 400 ? 0.6 : 0.75;

                          return GridView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: controller.scratchedCards.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: aspectRatio,
                            ),
                            itemBuilder: (context, index) {
                              final card = controller.scratchedCards[index];
                              final double fontScale =
                                  screenWidth / 400; // scale text a bit

                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    // 🖼 Image Section
                                    Expanded(
                                      flex: 3,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(16),
                                          topRight: Radius.circular(16),
                                        ),
                                        child: card.image != null
                                            ? Image.network(
                                                '${Get.find<ApiClient>().appBaseUrl}/${card.image}',
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                        stackTrace) =>
                                                    Container(
                                                  color: Colors.grey[200],
                                                  child: const Icon(
                                                    Icons.broken_image,
                                                    size: 50,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                color: Colors.grey[200],
                                                child: const Icon(
                                                  Icons.image_not_supported,
                                                  size: 50,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                      ),
                                    ),

                                    // 👑 Winner Information Section
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        padding:
                                            EdgeInsets.all(screenWidth * 0.025),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.red.shade50,
                                              Colors.white,
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(16),
                                            bottomRight: Radius.circular(16),
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Winner Label
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.emoji_events,
                                                  size: 14 * fontScale,
                                                  color: Colors.amber[700],
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  "Winner",
                                                  style: TextStyle(
                                                    fontSize: 10 * fontScale,
                                                    color: Colors.grey[600],
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 2),

                                            // Winner Name
                                            Text(
                                              card.winnerName ?? "N/A",
                                              style: TextStyle(
                                                fontSize: 13 * fontScale,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 2),

                                            // Phone Number
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.phone,
                                                  size: 18 * fontScale,
                                                  color: Colors.grey[600],
                                                ),
                                                const SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(
                                                    card.phoneNumber ?? "N/A",
                                                    style: TextStyle(
                                                      fontSize: 12 * fontScale,
                                                      color: Colors.grey[700],
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      );
    });
  }
}
