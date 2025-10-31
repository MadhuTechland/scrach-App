import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scratch_app/core/models/user_model.dart';

import '../../app/dashboard/dashboard_screen.dart';
import '../controller/auth_controller.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String phone; // 👈 change here
  const VerifyOtpScreen({super.key, required this.phone}); // 👈 change here

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final otpController = TextEditingController();
  final authController = Get.find<AuthController>();
  bool isLoading = false;

  void _verifyOtp() async {
    setState(() {
      isLoading = true;
    });

    final result = await authController.verifyOtp(
      phone: widget.phone,
      otp: otpController.text.trim(),
    );

    setState(() {
      isLoading = false;
    });

    if (result) {
      Get.offAll(() => DashboardScreen(key: dashboardKey));
    } else {
      Get.snackbar('Error', 'Invalid OTP or OTP expired');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:
              const Text('Verify OTP', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
          iconTheme: const IconThemeData(color: Colors.white)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter OTP',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2.5),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: isLoading ? null : _verifyOtp,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Verify OTP',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VerifyRegisterOtpScreen extends StatefulWidget {
  final String phone;
  final String email;

  const VerifyRegisterOtpScreen({
    super.key,
    required this.phone,
    required this.email,
  });

  @override
  State<VerifyRegisterOtpScreen> createState() =>
      _VerifyRegisterOtpScreenState();
}

class _VerifyRegisterOtpScreenState extends State<VerifyRegisterOtpScreen> {
  final otpController = TextEditingController();
  final authController = Get.find<AuthController>();
  bool isLoading = false;

  void _verifyRegisterOtp() async {
    String otp = otpController.text.trim();
    if (otp.isEmpty) {
      Get.snackbar('Error', 'Please enter OTP');
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Call the repo directly and capture the raw response
    final response = await authController.authRepo.verifyRegisterOtp(
      phone: widget.phone,
      email: widget.email,
      otp: otp,
    );

    // 🔹 Print the raw response for debugging
    print("Register OTP raw response: $response");

    setState(() {
      isLoading = false;
    });

    if (response['status'] == true) {
      // ✅ OTP verified successfully
      if (response.containsKey('user')) {
        final userJson = response['user'];
        authController.user = User.fromJson(userJson);
        await authController.saveUserToPrefs(authController.user!);
      }
      Get.offAllNamed('/dashboard');
    } else {
      // 🔹 Also print the error message
      print("Register OTP error message: ${response['res']}");
      Get.snackbar('Error', response['res'] ?? 'Invalid OTP or expired');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Registration OTP')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              "Please enter the 4-digit OTP sent to your email (${widget.email})",
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter OTP',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : _verifyRegisterOtp,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Verify OTP'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
