import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scratch_app/auth/controller/auth_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/dashboard/dashboard_screen.dart';
import '../../core/models/user_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final dobController = TextEditingController();
  final passwordController = TextEditingController();

  final authController = Get.find<AuthController>();
  bool isLoading = false;
  bool _obscureText = true;
  String selectedGender = "male";

  final InputDecoration inputDecoration = const InputDecoration(
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
  );

  void _registerUser() async {
    if (nameController.text.isEmpty ||
        firstNameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        emailController.text.isEmpty ||
        dobController.text.isEmpty) {
      Get.snackbar("Error", "All fields are mandatory");
      return;
    }

    setState(() {
      isLoading = true;
    });

    final response = await authController.registerUser(
      name: nameController.text.trim(),
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      phone: phoneController.text.trim(),
      email: emailController.text.trim(),
      dob: dobController.text.trim(),
      gender: selectedGender,
      password: passwordController.text.trim(),
    );

    setState(() {
      isLoading = false;
    });

    if (response['status'] == true) {
      final data = response['data'];
      if (data != null && data['status'] == true && data.containsKey('user')) {
        final userJson = data['user'];
        authController.user = User.fromJson(userJson);
        final token = data['token'];
        await authController.saveUserToPrefs(authController.user!);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
      }
Get.offAll(() => DashboardScreen(key: dashboardKey));
    } else {
      Get.snackbar("Error", response['res'] ?? "Something went wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Register Account", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 12),
                TextField(
                  controller: nameController,
                  decoration: inputDecoration.copyWith(
                    labelText: "Shop / Business Name",
                    prefixIcon: const Icon(Icons.store_mall_directory_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: firstNameController,
                  decoration: inputDecoration.copyWith(
                    labelText: "First Name",
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: lastNameController,
                  decoration: inputDecoration.copyWith(
                    labelText: "Last Name",
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: inputDecoration.copyWith(
                    labelText: "Mobile Number",
                    prefixIcon: const Icon(Icons.phone_android_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: inputDecoration.copyWith(
                    labelText: "Email ID",
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: dobController,
                  readOnly: true,
                  decoration: inputDecoration.copyWith(
                    labelText: "Date of Birth (DD/MM/YYYY)",
                    prefixIcon: const Icon(Icons.calendar_today_outlined),
                  ),
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime(1995),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      dobController.text =
                          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                    }
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedGender,
                  decoration: inputDecoration.copyWith(
                    labelText: "Gender",
                    prefixIcon: const Icon(Icons.male_outlined),
                  ),
                  items: const [
                    DropdownMenuItem(value: "male", child: Text("Male")),
                    DropdownMenuItem(value: "female", child: Text("Female")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value!;
                    });
                  },
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
                    onPressed: isLoading ? null : _registerUser,
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Save",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
