import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scratch_app/app/home/home_screen.dart';
import 'package:scratch_app/app/profile/profile_screen.dart';
import 'package:scratch_app/app/scratched/scratched_screen.dart';
import 'package:scratch_app/app/unscratched/unscratched_screen.dart';
import 'package:scratch_app/auth/controller/auth_controller.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return GetBuilder<AuthController>(
      builder: (_) {
        // Check if the user is available
        if (authController.user == null) {
          return Center(child: CircularProgressIndicator()); // Show loading if user is not available
        }

        final List<Widget> _screens = [
          const HomeScreen(),
          const ScratchedScreen(),
          UnscratchedScreen(),
          ProfileScreen(user: authController.user!),
        ];

        return Scaffold(
          body: _screens[_selectedIndex], // Show selected screen
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.redAccent,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.check_box), label: "Scratched"),
              BottomNavigationBarItem(icon: Icon(Icons.crop_square), label: "Unscratched"),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
            ],
          ),
        );
      },
    );
  }
}
