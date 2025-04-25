// file: lib/app/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:scratch_app/app/home/home_controller.dart';
import 'package:scratch_app/core/models/promotion_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:scratch_app/app/home/notification_screen.dart';
import 'package:scratch_app/utils/app_constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PromotionController promotionController = Get.put(
    PromotionController(apiClient: Get.find()),
  );
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    promotionController.fetchPromotions();
  }

 @override
Widget build(BuildContext context) {
  final media = MediaQuery.of(context).size;
  final height = media.height;
  final width = media.width;

  return Scaffold(
    body: Obx(() {
      if (promotionController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      bool isSliderPromotion(Promotion promo) => promo.isSlider == '1';

      List<Promotion> sliderPromos =
          promotionController.promotions.where(isSliderPromotion).toList();
      List<Promotion> nonSliderPromos =
          promotionController.promotions.where((promo) => !isSliderPromotion(promo)).toList();

      return Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.red, Colors.yellowAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Main content
          Column(
            children: [
              // App Bar Section
              Container(
                height: height * 0.18,
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.06, // ~24 on a 400px width screen
                  vertical: height * 0.025,  // ~20 on a 800px height screen
                ),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: height * 0.05), // ~40
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'assets/images/logo.jpg',
                          height: height * 0.075, // ~60
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(() => const NotificationListScreen());
                          },
                          child: Image.asset(
                            'assets/images/notification_image.png',
                            height: height * 0.05, // ~40
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

                const SizedBox(height: 10),

                // SLIDER SECTION
                if (sliderPromos.isNotEmpty) ...[
                  CarouselSlider(
                    items: sliderPromos.map((promo) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          '${AppConstants.baseUrl}/${promo.image}',
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      );
                    }).toList(),
                    options: CarouselOptions(
                      height: 200,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      onPageChanged: (i, _) {
                        setState(() => _currentIndex = i);
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  AnimatedSmoothIndicator(
                    activeIndex: _currentIndex,
                    count: sliderPromos.length,
                    effect: const WormEffect(
                      dotWidth: 10,
                      dotHeight: 10,
                      activeDotColor: Colors.white,
                      dotColor: Colors.grey,
                    ),
                  ),
                ] else
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text("No slider promotions available"),
                  ),

                const SizedBox(height: 8),

                // NON‑SLIDER LIST SECTION
                Expanded(
                  child: nonSliderPromos.isNotEmpty
                      ? ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: nonSliderPromos.length,
                          itemBuilder: (ctx, idx) {
                            final promo = nonSliderPromos[idx];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  '${AppConstants.baseUrl}/${promo.image}',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 180,
                                ),
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Text("No non‑slider promotions available"),
                        ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
