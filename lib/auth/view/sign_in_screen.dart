import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:scratch_app/auth/controller/auth_controller.dart';
import 'package:scratch_app/helper/app_routes.dart';

import 'register_screen.dart';
import 'verify_otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final authController = Get.find<AuthController>();
  bool _obscureText = true;

  // ✅ Helper: Validate phone number (starts with 6–9 and exactly 10 digits)
  bool isValidPhone(String phone) {
    return RegExp(r'^[6-9]\d{9}$').hasMatch(phone);
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD), // Light blue background
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 8,
            color: Colors.black12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              child: GetBuilder<AuthController>(
                builder: (auth) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/logo.jpg',
                      height: 72,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ✅ Phone Number Field
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: const InputDecoration(
                        counterText: '',
                        labelText: 'Phone',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 2.5,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ✅ Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: auth.isLoading
                            ? null
                            : () async {
                                final phone = emailController.text.trim();

                                if (phone.isEmpty) {
                                  Get.snackbar(
                                    'Error',
                                    'Please enter your phone number',
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                  return;
                                }

                                if (!isValidPhone(phone)) {
                                  Get.snackbar(
                                    'Invalid Number',
                                    'Enter a valid 10-digit number starting with 6, 7, 8, or 9',
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                  return;
                                }

                                bool success =
                                    await auth.requestOtp(phone);

                                if (success) {
                                  print("OTP sent successfully for $phone");
                                  Get.to(() =>
                                      VerifyOtpScreen(phone: phone));
                                }
                              },
                        child: auth.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.black,
                                ),
                              )
                            : const Text(
                                'Login',
                                style: TextStyle(fontSize: 20),
                              ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ✅ Register Text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account? "),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => const RegisterScreen());
                          },
                          child: const Text(
                            "Register",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
