import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:scratch_app/auth/controller/auth_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scratch_app/utils/app_constants.dart';

import '../../data/repository/auth_repo.dart';
import '../profile/card_statistics_screen.dart';
import '../profile/create_scratch_card_screen.dart';
import '../profile/custom_slider_screen.dart';
import '../profile/customer_support_screen.dart';
import '../profile/edit_profile_screen.dart';
import '../profile/enable_notification_screen.dart';
import 'package:http/http.dart' as http;

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) {
  final authController = Get.find<AuthController>();
  final user = authController.user;

  return AnnotatedRegion<SystemUiOverlayStyle>(
    value: const SystemUiOverlayStyle(
      statusBarColor: Colors.red,
      statusBarIconBrightness: Brightness.light, 
    ),
    child: Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Container(
        color: Colors.red, 
        child: SafeArea(
          bottom: false, 
          child: Container(
            color: Colors.white, 
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    UserAccountsDrawerHeader(
                      decoration: const BoxDecoration(
                        color: Colors.red,
                      ),
                      accountName: Text(
                        user?.name ?? 'Guest User',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      accountEmail: const Text(
                         '',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      currentAccountPicture: GestureDetector(
                        onTap: () {
                          Get.to(() => EditProfileScreen());
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage:
                              (user?.profilePic != null &&
                                      user!.profilePic!.isNotEmpty)
                                  ? NetworkImage(user.profilePic!)
                                  : const AssetImage(
                                          'assets/images/user_placeholder.png')
                                      as ImageProvider,
                        ),
                      ),
                    ),

                    // Menu Items
                    _drawerTile(
                      icon: Icons.home,
                      title: 'Home',
                      onTap: () => Navigator.pop(context),
                    ),
                    _drawerTile(
                      icon: Icons.notifications,
                      title: 'Notifications',
                      onTap: () =>
                          Get.to(() => const EnableNotificationScreen()),
                    ),
                    _drawerTile(
                      icon: Icons.slideshow,
                      title: 'Custom Sliders',
                      onTap: () => Get.to(() =>
                          CustomSliderScreen(authRepo: Get.find<AuthRepo>())),
                    ),
                    _drawerTile(
                      icon: Icons.card_membership,
                      title: 'Design Cards',
                      onTap: () => Get.to(() => CreateScratchCardScreen()),
                    ),
                    _drawerTile(
                      icon: Icons.card_giftcard_sharp,
                      title: 'My Cards',
                      onTap: () => Get.to(() => CardStatisticsScreen()),
                    ),
                    _drawerTile(
                      icon: Icons.support_agent,
                      title: 'Customer support',
                      onTap: () => Get.to(() => const CustomerSupportScreen()),
                    ),
                    _drawerTile(
                      icon: Icons.description,
                      title: 'Terms & Conditions',
                      onTap: () {},
                    ),
                    _drawerTile(
                      icon: Icons.lock,
                      title: 'Privacy Policy',
                      onTap: () {},
                    ),

                    const Divider(),

                    // Logout
                    _drawerTile(
                      icon: Icons.logout,
                      title: 'Logout',
                      onTap: () {
                        _showLogoutBottomSheet(context, authController);
                      },
                    ),

                    // Delete Account
                    _drawerTile(
                      icon: Icons.delete,
                      title: 'Delete Account',
                      onTap: () {
                        _showDeleteAccountBottomSheet(
                            context, user?.id, authController);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _drawerTile({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
}) {
  return ListTile(
    leading: Icon(icon, color: Colors.red),
    title: Text(
      title,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
    ),
    onTap: onTap,
  );
}

  void _showLogoutBottomSheet(
      BuildContext context, AuthController authController) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Are you sure to logout?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Yes Button
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      authController.logout();
                    },
                    child: Container(
                      width: 100,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "Yes",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),

                  // No Button
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 100,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: const Center(
                        child: Text(
                          "No",
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteAccountBottomSheet(
      BuildContext context, int? id, AuthController authController) {
    Future<void> handleDeleteUser(int id) async {
      try {
        final url =
            Uri.parse('${AppConstants.baseUrl}${AppConstants.deleteUser}$id');
        final response = await http.delete(url, headers: {
          'Accept': 'application/json',
        });

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['status'] == true) {
            print('User deleted successfully');
            authController.logout();
          } else {
            print('Failed: ${data['message']}');
          }
        } else {
          print('Server error: ${response.statusCode}');
        }
      } catch (e) {
        print('Exception: $e');
      }
    }

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Are you sure you want to delete your account?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Yes Button
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        print("Delete account clicked --------->$id");
                        handleDeleteUser(id!);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "Yes",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),

                  // Cancel Button
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
