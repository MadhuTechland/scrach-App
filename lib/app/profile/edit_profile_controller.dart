import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scratch_app/core/models/user_model.dart';
import 'package:scratch_app/data/repository/auth_repo.dart';
import 'package:scratch_app/auth/controller/auth_controller.dart';
import 'package:image_cropper/image_cropper.dart';

class EditProfileController extends GetxController {
  final AuthRepo repository;
  EditProfileController(this.repository);

  final authController = Get.find<AuthController>();

  // Controllers for text fields
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final companyNameController = TextEditingController();
  final email = ''.obs;

  // Gender selection
  final genderList = ['Male', 'Female', 'Other'];
  final selectedGender = ''.obs;

  // Image files
  File? profileImage;
  File? companyLogo;

  final isLoading = false.obs;

  final isReady = false.obs; 

  @override
  void onInit() {
    print("EditProfileController initialized");

    final user = authController.user;
    print("Current user: ${user?.name}");
    if (user == null) {
      print("User not loaded yet. Skipping init.");
      super.onInit();
      return;
    }
    if (user != null) {
      firstNameController.text = user.firstName ?? '';
      lastNameController.text = user.lastName ?? '';
      phoneController.text = user.phone ?? '';
      companyNameController.text = user.companyName ?? '';
      selectedGender.value = _normalizeGender(user.gender);
      email.value = user.email ?? '';
    }
    isReady.value = true; 
    super.onInit();
  }

  String _normalizeGender(String? gender) {
    if (gender == null) return '';
    gender = gender.toLowerCase();
    if (gender == 'male') return 'Male';
    if (gender == 'female') return 'Female';
    if (gender == 'other') return 'Other';
    return ''; // fallback
  }

  Future<void> updateProfile() async {
    try {
      isLoading.value = true;
      final token = await repository.getToken();

      if (token == null) {
        Get.snackbar("Error", "User token not found. Please log in again.");
        return;
      }

      final response = await repository.updateProfile(
        token: token,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        phone: phoneController.text,
        gender: selectedGender.value,
        companyName: companyNameController.text,
        profilePic: profileImage,
        companyLogo: companyLogo,
      );
      print(
          "Update profile response: ${response.statusCode} - ${response.body}");
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final updatedUserJson = responseBody['user'];

        // 🔁 Replace current user with updated one
        final updatedUser = User.fromJson(updatedUserJson);
        await authController.saveUserToPrefs(updatedUser);

        // Optional: Also re-init controllers with fresh data if needed
        onInit();
        print("Profile updated successfully: ${response.body}");
        Get.snackbar("Success", "Profile updated successfully");
      } else {
        print("Failed to update profile: ${response.body}");
        Get.snackbar("Error", "Failed to update profile");
      }
    } catch (e) {
      print("Error updating profile: $e");
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> pickImage({required bool isProfile}) async {
  //   final picker = ImagePicker();
  //   final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  //   if (image != null) {
  //     if (isProfile) {
  //       profileImage = File(image.path);
  //     } else {
  //       companyLogo = File(image.path);
  //     }
  //     update();
  //   }
  // }
  Future<void> pickImage({required bool isProfile}) async {
  final picker = ImagePicker();
  final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    // Step 1: Crop the image
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Crop Image',
        ),
      ],
    );

    // Step 2: Save cropped image
    if (croppedFile != null) {
      final File imageFile = File(croppedFile.path);
      if (isProfile) {
        profileImage = imageFile;
      } else {
        companyLogo = imageFile;
      }
      update(); // or setState if using StatefulWidget
    }
  }
}
}
