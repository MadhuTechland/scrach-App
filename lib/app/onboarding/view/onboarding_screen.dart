import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scratch_app/app/onboarding/controller/onboarding_controller.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());

    return Scaffold(
      body: PageView(
        controller: controller.pageController,
        onPageChanged: controller.onPageChanged,
        children: [
          OnboardingPage(
            image: 'assets/images/Spash screen 1.png',
            buttonText: 'Let\'s Start',
            onButtonPressed: controller.nextPage,
          ),
          OnboardingPage(
            image: 'assets/images/Spash screen 2.png',
            buttonText: 'Next',
            onButtonPressed: controller.nextPage,
          ),
          OnboardingPage(
            image: 'assets/images/Spash screen 3.png',
            buttonText: 'Continue',
            onButtonPressed: controller.nextPage,
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String image;

  final String buttonText;
  final VoidCallback onButtonPressed;

  const OnboardingPage({
    super.key,
    required this.image,
    required this.buttonText,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        
        Positioned.fill(
          child: Image.asset(
            image,
            fit: BoxFit.cover, 
          ),
        ),

        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 40), 
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 50, // Button height
              child: ElevatedButton(
                onPressed: onButtonPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow, 
                  foregroundColor: Colors.black, 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), 
                  ),
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
