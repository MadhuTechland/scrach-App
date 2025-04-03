import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scratch_app/app/home/notification_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // Tracks current page index
  final List<String> images = [
    'assets/images/image.png',
    'assets/images/image.png',
    'assets/images/image.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.red, Colors.yellowAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Main Content
          Column(
            children: [
              // App Bar Section
              Container(
                height: MediaQuery.of(context).size.height * 0.18,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          height: 60,
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(() => const NotificationListScreen());
                          },
                          child: Center(
                            child: Image.asset(
                              'assets/images/notification_image.png',
                              height: 40,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              CarouselSlider(
                items: images.map((image) {
                  return ClipRRect(
                    // Apply ClipRRect inside CarouselSlider
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
              ),

              // Dots Indicator
              const SizedBox(height: 10),
              AnimatedSmoothIndicator(
                activeIndex: _currentIndex,
                count: images.length,
                effect: const WormEffect(
                  dotWidth: 10,
                  dotHeight: 10,
                  activeDotColor: Colors.white, // Change color as needed
                  dotColor: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 8,
              ),

              // Image List Section
              Expanded(
                child: ListView.builder(
                  // shrinkWrap: true,
                  // physics: const NeverScrollableScrollPhysics(),
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/images/image.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
