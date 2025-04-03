import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scratch_app/app/home/notification_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white,Colors.red, Colors.yellowAccent],
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 20), 
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
                                Get.to(()=>const NotificationListScreen());
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

              // Image List Section
              Expanded(
                child: ListView.builder(
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
