import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scratch_app/app/profile/edit_profile_controller.dart';
import 'package:scratch_app/auth/controller/auth_controller.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(milliseconds: 100)),
      builder: (context, snapshot) {
        final authController = Get.find<AuthController>();

        if (authController.user == null) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        if (!Get.isRegistered<EditProfileController>()) {
          Get.put(EditProfileController(Get.find()));
        }

        final controller = Get.find<EditProfileController>();

        return Obx(() {
          if (!controller.isReady.value) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          }

          return buildProfileForm(controller);
        });
      },
    );
  }

  Widget buildProfileForm(EditProfileController ctrl) {
    // Your original Scaffold, Stack, ListView etc using `ctrl`
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red, Colors.yellowAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Get.back(),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Edit Profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Profile Image with Edit Button
              GetBuilder<EditProfileController>(
                builder: (ctrl) => Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      backgroundImage: ctrl.profileImage != null
                          ? FileImage(ctrl.profileImage!)
                          : (ctrl.authController.user?.profilePic != null
                              ? NetworkImage(
                                  ctrl.authController.user!.profilePic!)
                              : null) as ImageProvider?,
                      child: ctrl.profileImage == null &&
                              ctrl.authController.user?.profilePic == null
                          ? const Icon(Icons.person,
                              size: 60, color: Colors.grey)
                          : null,
                    ),
                    GestureDetector(
                      onTap: () => ctrl.pickImage(isProfile: true),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child:
                            const Icon(Icons.camera_alt, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Form Fields
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GetBuilder<EditProfileController>(
                    init: EditProfileController(
                        Get.find()), // ✅ Properly triggers `onInit`
                    builder: (ctrl) => ListView(
                      children: [
                        _buildTextField("First Name", ctrl.firstNameController),
                        _buildTextField("Last Name", ctrl.lastNameController),
                        _buildTextField("Email",
                            TextEditingController(text: ctrl.email.value),
                            readOnly: true),
                        _buildTextField("Phone Number", ctrl.phoneController),
                        _buildDropdown(ctrl),
                        _buildTextField(
                            "Company Name", ctrl.companyNameController),

                        // Company Logo Picker
                        const SizedBox(height: 10),
                        const Text("Company Logo",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 5),
                        Align(
                          alignment: Alignment
                              .center, 
                          child: GestureDetector(
                            onTap: () => ctrl.pickImage(isProfile: false),
                            child: Container(
                              height: 140,
                              width: 140,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                                image: ctrl.companyLogo != null
                                    ? DecorationImage(
                                        image: FileImage(ctrl.companyLogo!),
                                        fit: BoxFit.cover,
                                      )
                                    : (ctrl.authController.user?.companyLogo !=
                                            null
                                        ? DecorationImage(
                                            image: NetworkImage(ctrl
                                                .authController
                                                .user!
                                                .companyLogo!),
                                            fit: BoxFit.cover,
                                          )
                                        : null),
                              ),
                              child: (ctrl.companyLogo == null &&
                                      ctrl.authController.user?.companyLogo ==
                                          null)
                                  ? const Center(
                                      child: Icon(Icons.camera_alt,
                                          color: Colors.grey),
                                    )
                                  : null,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Save Button
                        Obx(
                          () => ElevatedButton(
                            onPressed: ctrl.isLoading.value
                                ? null
                                : ctrl.updateProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: ctrl.isLoading.value
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text("Save details",
                                    style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 5),
          TextField(
            controller: controller,
            readOnly: readOnly,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(EditProfileController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Gender", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Obx(() => DropdownButtonFormField<String>(
                  value: controller.selectedGender.value.isNotEmpty
                      ? controller.selectedGender.value
                      : null,
                  hint: const Text("Select your gender"),
                  decoration: const InputDecoration(border: InputBorder.none),
                  items: controller.genderList
                      .map((gender) =>
                          DropdownMenuItem(value: gender, child: Text(gender)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) controller.selectedGender.value = value;
                  },
                )),
          ),
        ],
      ),
    );
  }
}
