import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:scratch_app/utils/app_constants.dart';
import '../../auth/controller/auth_controller.dart';

class CreateScratchCardScreen extends StatefulWidget {
  const CreateScratchCardScreen({super.key});

  @override
  State<CreateScratchCardScreen> createState() =>
      _CreateScratchCardScreenState();
}

class _CreateScratchCardScreenState extends State<CreateScratchCardScreen> {
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController itemCountController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController statusController =
      TextEditingController(text: "active");

  String? selectedRatio;
  File? _selectedImage;
  bool _isLoading = false;

  final List<String> ratioOptions = [
    "5",
    "10",
    "15",
    "20",
    "25",
    "30",
    "35",
    "40",
    "45",
    "50",
    "55",
    "60",
    "65",
    "70",
    "75",
    "80",
    "85",
    "90",
    "95",
    "100"
  ];

  // Future<void> _pickImage() async {
  //   final pickedFile =
  //       await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _selectedImage = File(pickedFile.path);
  //     });
  //   }
  // }


  Future<void> _pickImage() async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    // Crop the image
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio16x9,
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.deepPurple,
          toolbarWidgetColor: Colors.white,
          hideBottomControls: false,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Crop Image',
        ),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        _selectedImage = File(croppedFile.path);
      });
    }
  }
}


  Future<void> _createCard() async {
    final userId = Get.find<AuthController>().user?.id;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    if (_selectedImage == null ||
        itemNameController.text.isEmpty ||
        itemCountController.text.isEmpty ||
        selectedRatio == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill all fields and select an image')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final uri =
        Uri.parse('${AppConstants.baseUrl}/api/scratchcards/create-assign');
    var request = http.MultipartRequest('POST', uri);

    request.fields['item_name'] = itemNameController.text;
    request.fields['item_count'] = itemCountController.text;
    request.fields['item_ratio'] = selectedRatio!;
    request.fields['status'] = statusController.text;
    request.fields['selected_user'] = userId.toString();
    request.fields['user_id'] = userId.toString();
    // request.fields['expiry_date'] = expiryDateController.text;

    request.files
        .add(await http.MultipartFile.fromPath('image', _selectedImage!.path));

    try {
      var response = await request.send();
      var res = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              '🎉 Successfully Card Created!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 2),
          ),
        );

        itemNameController.clear();
        itemCountController.clear();
        expiryDateController.clear();
        setState(() {
          _selectedImage = null;
          selectedRatio = null;
        });
      } else {
        final responseData = jsonDecode(res.body);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseData['message'] ?? 'Something went wrong!',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }

    setState(() => _isLoading = false);
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue, width: 2.5),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      prefixIcon: Icon(icon),
    );
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

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              // App Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Create Scratch Card",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextField(
                        controller: itemNameController,
                        decoration:
                            _inputDecoration("Item Name", Icons.card_giftcard),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: itemCountController,
                        keyboardType: TextInputType.number,
                        decoration:
                            _inputDecoration("Item Count", Icons.numbers),
                      ),
                      const SizedBox(height: 15),

                      // Item Ratio Dropdown
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey, width: 2),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: selectedRatio,
                            hint: const Text("Select Item Ratio (%)"),
                            items: ratioOptions.map((ratio) {
                              return DropdownMenuItem(
                                value: ratio,
                                child: Text("$ratio%"),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedRatio = value;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Expiry Date
                      // TextField(
                      //   controller: expiryDateController,
                      //   readOnly: true,
                      //   decoration: _inputDecoration("Expiry Date (DD/MM/YYYY)",
                      //       Icons.calendar_today_outlined),
                      //   onTap: () async {
                      //     final pickedDate = await showDatePicker(
                      //       context: context,
                      //       initialDate: DateTime.now(),
                      //       firstDate: DateTime.now(),
                      //       lastDate: DateTime.now()
                      //           .add(const Duration(days: 365 * 5)),
                      //     );
                      //     if (pickedDate != null) {
                      //       expiryDateController.text =
                      //           "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                      //     }
                      //   },
                      // ),
                      // const SizedBox(height: 15),
                      const SizedBox(height: 20),

                      // Image Picker + Preview
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: double.infinity,
                          height: 180,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey, width: 2),
                          ),
                          child: _selectedImage == null
                              ? const Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.image,
                                          color: Colors.red, size: 40),
                                      SizedBox(height: 10),
                                      Text("Tap to select image"),
                                    ],
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(_selectedImage!,
                                      fit: BoxFit.cover,
                                      width: double.infinity),
                                ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _createCard,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text(
                                  "Create Card",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
