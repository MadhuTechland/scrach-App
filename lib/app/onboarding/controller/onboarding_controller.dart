import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scratch_app/app/dashboard/dashboard_screen.dart';

class OnboardingController extends GetxController {
  final pageController = PageController();
  final currentPage = 0.obs;

  void nextPage() {
    if (currentPage.value < 2) {
      currentPage.value++;
      pageController.animateToPage(
        currentPage.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
   
      Get.offAll(()=>const DashboardScreen());
    }
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}