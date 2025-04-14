import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:scratch_app/utils/app_constants.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;

  const OtpVerificationScreen({super.key, required this.email});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final otpController = TextEditingController();
  bool isVerifying = false;

  Future<void> verifyOtp() async {
    setState(() => isVerifying = true);

    final response = await http.post(
      Uri.parse(AppConstants.baseUrl + AppConstants.loginUri),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': widget.email,
        'otp': otpController.text.trim(),
      }),
    );

    setState(() => isVerifying = false);

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['status'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("OTP Verified. Please login again.")));
      Navigator.pop(context); // Go back to login
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['res'] ?? 'OTP verification failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify OTP")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Enter the OTP sent to ${widget.email}"),
            TextField(controller: otpController, decoration: const InputDecoration(labelText: 'OTP')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isVerifying ? null : verifyOtp,
              child: isVerifying ? const CircularProgressIndicator() : const Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
