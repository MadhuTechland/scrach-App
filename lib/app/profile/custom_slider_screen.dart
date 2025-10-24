import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scratch_app/data/repository/auth_repo.dart';

class CustomSliderScreen extends StatefulWidget {
  final AuthRepo authRepo;
  CustomSliderScreen({super.key, required this.authRepo});

  @override
  State<CustomSliderScreen> createState() => _CustomSliderScreenState();
}

class _CustomSliderScreenState extends State<CustomSliderScreen> {
  final List<XFile> _selectedImages = [];

  Future<void> _pickImages() async {
    int count = await widget.authRepo.getCustomSliderCount();

    if (count >= 3) {
      Get.snackbar("Limit Reached", "You can upload only 3 custom sliders.");
      return;
    }

    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();

    if (images != null && images.isNotEmpty) {
      final remaining = 3 - count;
      final selected = images.take(remaining).toList();

      setState(() {
        _selectedImages.clear();
        _selectedImages.addAll(selected);
      });
    }
  }

  void _submitImages() async {
    if (_selectedImages.isEmpty) {
      Get.snackbar("Error", "Please select at least one image.");
      return;
    }

    final files = _selectedImages.map((x) => File(x.path)).toList();

    try {
      final streamedResponse = await widget.authRepo.uploadSliderImages(files);
      final responseBody = await streamedResponse.stream.bytesToString();

      if (streamedResponse.statusCode == 200) {
        Get.snackbar("Success", "Images uploaded successfully");
        setState(() => _selectedImages.clear());
      } else {
        debugPrint("Upload failed: $responseBody");
        Get.snackbar("Error", "Upload failed");
      }
    } catch (e) {
      debugPrint("Exception: $e");
      Get.snackbar("Error", "Something went wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red, Colors.yellow],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "Custom Sliders",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),

                // Main body with center alignment if no images
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: _selectedImages.isEmpty
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: _selectedImages.isEmpty ? 100.h : 30.h,
                        ),

                        // Photo icon box
                        Center(
                          child: GestureDetector(
                            onTap: _pickImages,
                            child: Container(
                              width: 120.w,
                              height: 120.w,
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: Colors.grey.shade400,
                                  width: 2.w,
                                ),
                              ),
                              child: Icon(
                                Icons.photo,
                                size: 50.sp,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 20.h),

                        Text(
                          "${_selectedImages.length} image(s) selected",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                          ),
                        ),

                        SizedBox(height: 20.h),

                        if (_selectedImages.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Wrap(
                              spacing: 10.w,
                              runSpacing: 10.h,
                              children: _selectedImages.map((image) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: Image.file(
                                    File(image.path),
                                    width: 100.w,
                                    height: 100.w,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),

                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
                ),

                // Submit Button at bottom
                Padding(
                  padding: EdgeInsets.only(bottom: 30.h),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: _submitImages,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 40.w,
                          vertical: 14.h,
                        ),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        "Submit",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
